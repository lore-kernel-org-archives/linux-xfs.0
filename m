Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FDB9C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:45:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5956F60F5C
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:45:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhG2SpE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jul 2021 14:45:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229672AbhG2SpD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Jul 2021 14:45:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F07C460F4B;
        Thu, 29 Jul 2021 18:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627584300;
        bh=59IjRXR3dE7tCYB5uvPPbqbUMuH/da6gnIZKSjoljrQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=h1BVj5yGwdun11aJ9WMte83S5R+CcLMRY6mkVbZRfozD/kWX9nhLVU+GSOMFtfuHe
         OHDyzQovfjhO5Fjt6S6sMsl3Q7dxXDYPtnqEIWK2vrbeE5Cgc3UjgvDjuisew8NcDc
         pwMAmgxzmDqHsXnUUzs8DpL4vAauUPD+CwwO2g/QSaiA/3K9kiJjKvxnVoi9fG5I0F
         V4Nc+fAlKo0skAZ3n5QSJnqK13CavPBeJ0RhLINemMmpJN98VoR7okDC674Uxn7awL
         QElLJ/PISV8X91aOiNBYffFkiopYGGZddP762m1P38tesVWrIpD2fP1j7IKDGoLSGh
         A55oETA/bRLcg==
Subject: [PATCH 12/20] xfs: inactivate inodes any time we try to free
 speculative preallocations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Thu, 29 Jul 2021 11:44:59 -0700
Message-ID: <162758429967.332903.1341972104802367229.stgit@magnolia>
In-Reply-To: <162758423315.332903.16799817941903734904.stgit@magnolia>
References: <162758423315.332903.16799817941903734904.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Other parts of XFS have learned to call xfs_blockgc_free_{space,quota}
to try to free speculative preallocations when space is tight.  This
means that file writes, transaction reservation failures, quota limit
enforcement, and the EOFBLOCKS ioctl all call this function to free
space when things are tight.

Since inode inactivation is now a background task, this means that the
filesystem can be hanging on to unlinked but not yet freed space.  Add
this to the list of things that xfs_blockgc_free_* makes writer threads
scan for when they cannot reserve space.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 91a1dc7eb352..3501f04d0914 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1836,16 +1836,23 @@ xfs_blockgc_worker(
 }
 
 /*
- * Try to free space in the filesystem by purging eofblocks and cowblocks.
+ * Try to free space in the filesystem by purging inactive inodes, eofblocks
+ * and cowblocks.
  */
 int
 xfs_blockgc_free_space(
 	struct xfs_mount	*mp,
 	struct xfs_icwalk	*icw)
 {
+	int			error;
+
 	trace_xfs_blockgc_free_space(mp, icw, _RET_IP_);
 
-	return xfs_icwalk(mp, XFS_ICWALK_BLOCKGC, icw);
+	error = xfs_icwalk(mp, XFS_ICWALK_BLOCKGC, icw);
+	if (error)
+		return error;
+
+	return xfs_icwalk(mp, XFS_ICWALK_INODEGC, icw);
 }
 
 /*

