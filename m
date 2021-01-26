Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3834DC4332D
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 10:21:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EE5920731
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 10:21:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313706AbhAZXCy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 18:02:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:54596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730491AbhAZFAL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Jan 2021 00:00:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F8AC22B3B;
        Tue, 26 Jan 2021 04:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611636758;
        bh=YE+9XPOegF4RA7zWwp/WaIN4DMB1fQalJFku4Xt3rZo=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=jIVjfiSc1DnJUZ9I/pZfmi1HaF8aZz3t2+C6pNEXO8QQ0AySF4s6cO+1GQsfFTVG6
         VJfCA/CfP1y/kLxAKN6axSvHVnMv3eUaeaUcK+L/yo0PvKnBKb/e9NsyvJm9AeQG9l
         JpZbzfGgj6QCM0SKweXcA9Ripc3yO5VcBNrZYTD5RJ3sNZEJST5XesOs/kkgBn3Rey
         tnHvWHVwpAYu8twfToGJFua1DDtzNm1O0PlwQd+iFxT2n8oRZdzx2S3epfY6aQhYlv
         W2F88etJZkymZ/9F8JUqTDtL860R8RV04rL+gn7m9/NAoXTu7EapjH9J2klLjh3fXZ
         EHZlSQwzUz28A==
Date:   Mon, 25 Jan 2021 20:52:37 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: [PATCH v4.1 05/11] xfs: pass flags and return gc errors from
 xfs_blockgc_free_quota
Message-ID: <20210126045237.GM7698@magnolia>
References: <161142791950.2171939.3320927557987463636.stgit@magnolia>
 <161142794741.2171939.10175775024910240954.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161142794741.2171939.10175775024910240954.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Change the signature of xfs_blockgc_free_quota in preparation for the
next few patches.  Callers can now pass EOF_FLAGS into the function to
control scan parameters; and the function will now pass back any
corruption errors seen while scanning, though for our retry loops we'll
just try again unconditionally.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
v4.1: fix some of the comments to make more sense
---
 fs/xfs/xfs_file.c   |   10 +++++-----
 fs/xfs/xfs_icache.c |   22 +++++++++++++---------
 fs/xfs/xfs_icache.h |    2 +-
 3 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index d69e5abcc1b4..3be0b1d81325 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -743,14 +743,14 @@ xfs_file_buffered_write(
 	 * metadata space. This reduces the chances that the eofblocks scan
 	 * waits on dirty mappings. Since xfs_flush_inodes() is serialized, this
 	 * also behaves as a filter to prevent too many eofblocks scans from
-	 * running at the same time.
+	 * running at the same time.  Use a synchronous scan to increase the
+	 * effectiveness of the scan.
 	 */
 	if (ret == -EDQUOT && !cleared_space) {
 		xfs_iunlock(ip, iolock);
-		cleared_space = xfs_blockgc_free_quota(ip);
-		if (cleared_space)
-			goto write_retry;
-		iolock = 0;
+		xfs_blockgc_free_quota(ip, XFS_EOF_FLAGS_SYNC);
+		cleared_space = true;
+		goto write_retry;
 	} else if (ret == -ENOSPC && !cleared_space) {
 		struct xfs_eofblocks eofb = {0};
 
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index aba901d5637b..7323a1a240bd 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1651,19 +1651,21 @@ xfs_start_block_reaping(
  * failure. We make a best effort by including each quota under low free space
  * conditions (less than 1% free space) in the scan.
  */
-bool
+int
 xfs_blockgc_free_quota(
-	struct xfs_inode	*ip)
+	struct xfs_inode	*ip,
+	unsigned int		eof_flags)
 {
 	struct xfs_eofblocks	eofb = {0};
 	struct xfs_dquot	*dq;
 	bool			do_work = false;
+	int			error;
 
 	/*
-	 * Run a sync scan to increase effectiveness and use the union filter to
-	 * cover all applicable quotas in a single scan.
+	 * Run a scan to free blocks using the union filter to cover all
+	 * applicable quotas in a single scan.
 	 */
-	eofb.eof_flags = XFS_EOF_FLAGS_UNION | XFS_EOF_FLAGS_SYNC;
+	eofb.eof_flags = XFS_EOF_FLAGS_UNION | eof_flags;
 
 	if (XFS_IS_UQUOTA_ENFORCED(ip->i_mount)) {
 		dq = xfs_inode_dquot(ip, XFS_DQTYPE_USER);
@@ -1693,9 +1695,11 @@ xfs_blockgc_free_quota(
 	}
 
 	if (!do_work)
-		return false;
+		return 0;
 
-	xfs_icache_free_eofblocks(ip->i_mount, &eofb);
-	xfs_icache_free_cowblocks(ip->i_mount, &eofb);
-	return true;
+	error = xfs_icache_free_eofblocks(ip->i_mount, &eofb);
+	if (error)
+		return error;
+
+	return xfs_icache_free_cowblocks(ip->i_mount, &eofb);
 }
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 21b726a05b0d..d64ea8f5c589 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -54,7 +54,7 @@ long xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
 
 void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
 
-bool xfs_blockgc_free_quota(struct xfs_inode *ip);
+int xfs_blockgc_free_quota(struct xfs_inode *ip, unsigned int eof_flags);
 
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
