Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E039C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:10:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2091761101
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:10:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbhIOXLd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:11:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:36434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231579AbhIOXLd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:11:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78BF1610A6;
        Wed, 15 Sep 2021 23:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747413;
        bh=3uTDRDXTKJwc3zgepikaXP/cg9K/7e7l3ZemhydkMoY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ff475+FLluXF8DIFAy7xDNPbkzhVFij0tBjy5ieLryD+IpaVGyvOCuOJEneGTGQby
         C4RBfdXrb7nr7seDFULGCul0QvU3KaLqFe62bvWqDsZw6+76wwg1Du8ZxJb+Ju7DIG
         X1gZHBWVv9YFpYpEQum6yk5Ci/1qerizL0ZoiRS7zt+XItvN0xn1EPjotkbi+tNTev
         wUJY9wLT+tiDcoDdS+zIThacNrZyLWw8bSLbgHvAExjQJMD3E6T5i347VYXNdijtZw
         o8Bon419c81hZbWeEcgpYIo8HvRPtyW+ZAGadZpy369xlP0KCqLaUK2rvQP5d+hqlJ
         AavuYL8IPVmIQ==
Subject: [PATCH 40/61] xfs: inode allocation can use a single perag instance
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:10:13 -0700
Message-ID: <163174741324.350433.3726522503472995156.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 309161f6603ce1a53b76a42817cde2a9bcd17e82

Now that we've internalised the two-phase inode allocation, we can
now easily make the AG selection and allocation atomic from the
perspective of a single perag context. This will ensure AGs going
offline/away cannot occur between the selection and allocation
steps.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_ialloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index b133b2ed..60e09a53 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1427,6 +1427,7 @@ static int
 xfs_dialloc_ag(
 	struct xfs_trans	*tp,
 	struct xfs_buf		*agbp,
+	struct xfs_perag	*pag,
 	xfs_ino_t		parent,
 	xfs_ino_t		*inop)
 {
@@ -1441,7 +1442,6 @@ xfs_dialloc_ag(
 	int				error;
 	int				offset;
 	int				i;
-	struct xfs_perag		*pag = agbp->b_pag;
 
 	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
 		return xfs_dialloc_ag_inobt(tp, agbp, pag, parent, inop);
@@ -1758,9 +1758,9 @@ xfs_dialloc(
 	xfs_perag_put(pag);
 	return error ? error : -ENOSPC;
 found_ag:
-	xfs_perag_put(pag);
 	/* Allocate an inode in the found AG */
-	error = xfs_dialloc_ag(*tpp, agbp, parent, &ino);
+	error = xfs_dialloc_ag(*tpp, agbp, pag, parent, &ino);
+	xfs_perag_put(pag);
 	if (error)
 		return error;
 	*new_ino = ino;

