Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44977C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:04:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236143AbiLaCE0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:04:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236148AbiLaCEZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:04:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BB8178A5
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:04:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB04CB81D63
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:04:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545B3C433EF;
        Sat, 31 Dec 2022 02:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452262;
        bh=1I8vjx1anjdjEC4TmUNaTtzTF/xQg3nLvg2APpdwBGs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PkyG5FNpIYgOaCRuDYqo8O6+0gzWsf/u3oUGtOvAMjHPtQDNHZB2XXb2PxBWSnjJP
         Vn0nBdeNmKWb283o8UcSmsKP5SezQKw3ts2gYMB4fyBQ2zGvrOPk8fF5IYz4Dtr1/F
         h5wC9crbvJiHGHlSIc3LDYUfYs6TIHo0a/oxJrkOqySzhcNpLtuKoLPNcnTXNCIXPb
         BkVV2kaxwVzy7rIxk4wXWMAZ8e57t1NMi1VwgbEb5nNF1s3t7rvUXPIluSKnbWJwfT
         cjlHuO35hOyb1gWpFEo2x7DOpqHWnrr7o9YauJSZ1RCgQBOaK02gH5SA9D9IiXZMRX
         PlQIRYhPPQ76A==
Subject: [PATCH 05/26] libxfs: pass IGET flags through to xfs_iread
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:13 -0800
Message-ID: <167243875385.723621.4220111121208397182.stgit@magnolia>
In-Reply-To: <167243875315.723621.17759760420120912799.stgit@magnolia>
References: <167243875315.723621.17759760420120912799.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Change the lock_flags parameter to iget_flags so that we can supply
XFS_IGET_ flags in future patches.  All callers of libxfs_iget and
libxfs_trans_iget pass zero for this parameter and there are no inode
locks in xfsprogs, so there's no behavior change here.

Port the kernel's version of the xfs_inode_from_disk callsite.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/inode.c |   40 ++++++++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 12 deletions(-)


diff --git a/libxfs/inode.c b/libxfs/inode.c
index c7843aea753..588aff33ef4 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -263,11 +263,10 @@ libxfs_iget(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
 	xfs_ino_t		ino,
-	uint			lock_flags,
+	uint			flags,
 	struct xfs_inode	**ipp)
 {
 	struct xfs_inode	*ip;
-	struct xfs_buf		*bp;
 	int			error = 0;
 
 	ip = kmem_cache_zalloc(xfs_inode_cache, 0);
@@ -284,18 +283,35 @@ libxfs_iget(
 	if (error)
 		goto out_destroy;
 
-	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &bp);
-	if (error)
-		goto out_destroy;
+	/*
+	 * For version 5 superblocks, if we are initialising a new inode and we
+	 * are not utilising the XFS_MOUNT_IKEEP inode cluster mode, we can
+	 * simply build the new inode core with a random generation number.
+	 *
+	 * For version 4 (and older) superblocks, log recovery is dependent on
+	 * the di_flushiter field being initialised from the current on-disk
+	 * value and hence we must also read the inode off disk even when
+	 * initializing new inodes.
+	 */
+	if (xfs_has_v3inodes(mp) &&
+	    (flags & XFS_IGET_CREATE) && !xfs_has_ikeep(mp)) {
+		VFS_I(ip)->i_generation = get_random_u32();
+	} else {
+		struct xfs_buf		*bp;
 
-	error = xfs_inode_from_disk(ip,
-			xfs_buf_offset(bp, ip->i_imap.im_boffset));
-	if (!error)
-		xfs_buf_set_ref(bp, XFS_INO_REF);
-	xfs_trans_brelse(tp, bp);
+		error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &bp);
+		if (error)
+			goto out_destroy;
 
-	if (error)
-		goto out_destroy;
+		error = xfs_inode_from_disk(ip,
+				xfs_buf_offset(bp, ip->i_imap.im_boffset));
+		if (!error)
+			xfs_buf_set_ref(bp, XFS_INO_REF);
+		xfs_trans_brelse(tp, bp);
+
+		if (error)
+			goto out_destroy;
+	}
 
 	*ipp = ip;
 	return 0;

