Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E265BC433DB
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:53:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB26123358
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:53:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726288AbhAWSxS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 Jan 2021 13:53:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:35350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbhAWSxI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 23 Jan 2021 13:53:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C443C224DE;
        Sat, 23 Jan 2021 18:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611427945;
        bh=8uX6T3eVn0nrimK/vR+YaFj2VETD5VK3f+EVwQ0Q43M=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RsgteMT21+0BYdNNUvQcOb1xO+hdg9VQHPcf+Vr+hrnNLMQQfq/4hjVaq1ARJYa0E
         AA8ox5NTScckYbrA0vgnYIJrRm4rZy7VhslcaTZFWFsBXxGbXrjc/F2BDVrLBvNpVq
         gP8I2nJHNlhdQUY0XUteXgrGxP5RxG7lA4M/7O4evNiuF8poKQlN/hOUEU1STbkTs8
         aPhkBFwzhahTie1Ne5G75t669PpsvfrzmES8gHgjmOGOZ1d4MApP4FSwT85dN0b7vh
         +Wi/jRBdm5doFcFlcGtfTeMXo9ol/y4F2LqWxPCWlqovvtH4c9I8r2PoYZ/wb9iOqP
         addTqBfzJAUWw==
Subject: [PATCH 05/11] xfs: pass flags and return gc errors from
 xfs_blockgc_free_quota
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Date:   Sat, 23 Jan 2021 10:52:27 -0800
Message-ID: <161142794741.2171939.10175775024910240954.stgit@magnolia>
In-Reply-To: <161142791950.2171939.3320927557987463636.stgit@magnolia>
References: <161142791950.2171939.3320927557987463636.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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
---
 fs/xfs/xfs_file.c   |    7 +++----
 fs/xfs/xfs_icache.c |   20 ++++++++++++--------
 fs/xfs/xfs_icache.h |    2 +-
 3 files changed, 16 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index d69e5abcc1b4..57086838a676 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -747,10 +747,9 @@ xfs_file_buffered_write(
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
index aba901d5637b..68b6f72593dc 100644
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
+	 * Run a scan to increase effectiveness and use the union filter to
 	 * cover all applicable quotas in a single scan.
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

