Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49AC5C48BCF
	for <linux-xfs@archiver.kernel.org>; Sun, 13 Jun 2021 17:20:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C72661285
	for <linux-xfs@archiver.kernel.org>; Sun, 13 Jun 2021 17:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbhFMRWU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 13 Jun 2021 13:22:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:41284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231915AbhFMRWU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 13 Jun 2021 13:22:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F96761078;
        Sun, 13 Jun 2021 17:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623604819;
        bh=7ZIoRfxfRm+VFi8nyVLZYOM8GZu3m/0OxVGTwbdu0/c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=AE4u/Yk9q/Kfc6EYYmqox9IB6ZDG5z7K6hvLPXee5guwzgwIjw5tkN1u1P+iC86oP
         4qtlfbM/eJ1CBRANj14yZJP2JFrVHqD96X9v/FuWH71Ti0eSfmS4I65cN/DR7DMMtI
         imf0oVHCCWEIftaQBxpYVw7H/fsGA0vvvQ2KeZfygE9mXN8oSpYB51SZNIkV3CZTAR
         esE2BjEfDQ6zGXAr/ZgS6iDKiD2Cj9FlbBJAq20Tmr+K9O3zBNipARQR7tbJ+WGLqK
         RKDMH4xKOrXkuh0/erPgmW4ymAxULG6HwYyB/2Nl+G/IDbLb4z7f2eu4eYNdGFQPTJ
         175jaHkPt6w3w==
Subject: [PATCH 04/16] xfs: clean up xfs_inactive a little bit
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org,
        bfoster@redhat.com
Date:   Sun, 13 Jun 2021 10:20:18 -0700
Message-ID: <162360481889.1530792.8153660904394768299.stgit@locust>
In-Reply-To: <162360479631.1530792.17147217854887531696.stgit@locust>
References: <162360479631.1530792.17147217854887531696.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move the dqattach further up in xfs_inactive.  In theory we should
always have dquots attached if there are CoW blocks, but this makes the
usage pattern more consistent with the rest of xfs (attach dquots, then
start making changes).

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 85b2b11b5217..67786814997c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1717,7 +1717,7 @@ xfs_inode_needs_inactive(
  */
 void
 xfs_inactive(
-	xfs_inode_t	*ip)
+	struct xfs_inode	*ip)
 {
 	struct xfs_mount	*mp;
 	int			error;
@@ -1743,6 +1743,11 @@ xfs_inactive(
 	if (xfs_is_metadata_inode(ip))
 		goto out;
 
+	/* Ensure dquots are attached prior to making changes to this file. */
+	error = xfs_qm_dqattach(ip);
+	if (error)
+		goto out;
+
 	/* Try to clean out the cow blocks if there are any. */
 	if (xfs_inode_has_cow_data(ip))
 		xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, true);
@@ -1768,10 +1773,6 @@ xfs_inactive(
 	     ip->i_df.if_nextents > 0 || ip->i_delayed_blks > 0))
 		truncate = 1;
 
-	error = xfs_qm_dqattach(ip);
-	if (error)
-		goto out;
-
 	if (S_ISLNK(VFS_I(ip)->i_mode))
 		error = xfs_inactive_symlink(ip);
 	else if (truncate)

