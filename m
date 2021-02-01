Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEFFCC433DB
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 02:07:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 815A964E28
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 02:07:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhBACHh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 31 Jan 2021 21:07:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:34398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231309AbhBACGg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 31 Jan 2021 21:06:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D97064E2F;
        Mon,  1 Feb 2021 02:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612145155;
        bh=ClBONMnDsnLPgrBMvRzHjzGSGUDWD+5ec74bFVP200s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=s2+m2hET05yAiAMkp9mB71bSiZGtByc1SSgOfYlMmz6cdPAF0mo7FRg2jKNUb3Mej
         +odPV1/g4ag0glIlc2DmjfvruMrKW1N2yTYz1F7NnpkxPfpytwetE5+dQjIXH6zxgH
         YuVk/WDxRayW4D/4WksUqKEiDNnsJhG8BnhPAqPwmuIusRL9UCDxDUGmRVrxcMZNsd
         2Wx3QZeG3jPCFanKmzF2jrABy0UDXsRwqxVdr+8+05tbhjKxV5zCiaHv4HLUgElGpT
         tYKQOPIbsGLlT4kqf9I0xwbuJH97lKsdmAGMo+BgV5ZkskXoqfesfG+sbJ+foTn/PK
         qc/STP3dkN9zw==
Subject: [PATCH 05/12] xfs: pass flags and return gc errors from
 xfs_blockgc_free_quota
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Sun, 31 Jan 2021 18:05:54 -0800
Message-ID: <161214515467.140945.3619758551060932899.stgit@magnolia>
In-Reply-To: <161214512641.140945.11651856181122264773.stgit@magnolia>
References: <161214512641.140945.11651856181122264773.stgit@magnolia>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_file.c   |   10 +++++-----
 fs/xfs/xfs_icache.c |   26 +++++++++++++++++---------
 fs/xfs/xfs_icache.h |    2 +-
 3 files changed, 23 insertions(+), 15 deletions(-)


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
index aba901d5637b..4a074aa12b52 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1650,20 +1650,26 @@ xfs_start_block_reaping(
  * with multiple quotas, we don't know exactly which quota caused an allocation
  * failure. We make a best effort by including each quota under low free space
  * conditions (less than 1% free space) in the scan.
+ *
+ * Callers must not hold any inode's ILOCK.  If requesting a synchronous scan
+ * (XFS_EOF_FLAGS_SYNC), the caller also must not hold any inode's IOLOCK or
+ * MMAPLOCK.
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
@@ -1693,9 +1699,11 @@ xfs_blockgc_free_quota(
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

