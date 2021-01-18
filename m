Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ADB5C433E9
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 22:13:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E61722E03
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 22:13:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733204AbhARWNM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 17:13:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:34114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387794AbhARWNI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Jan 2021 17:13:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F23422EBF;
        Mon, 18 Jan 2021 22:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611007946;
        bh=Pxd9e2skq3a4JxElZBkyxl1qarYw7bOmrexTaqUfmyw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cXpyBtQZOK0lWoP79r4oWzhXRt8OwmiGXfk8Ne7vOEZTbgChJfB2dXiPtvl8sBcJD
         R++9I2Zqerl1TZqFLAhCl8vQ1yQ+mVnFodTe/eUkupbuw3SvBeZb1yK28I8WnpoBhf
         5GWDFQdRsz8CRsdbBDgrXq084bi3gJ9a4SQ+SJ+8fIS/8XVZKcFTsISapFltchWROs
         q/Xu44eA1wfR3OkMTPDBJgU4WiNLKiyqYx2dRtZt49jEqjbDyMjtH5ejmCWrK25CU5
         JFz6FPqp5GSSLTfcuHgi1oqOl2sfz2N/VW8W+Ej7jTeYvZOSNBc3iNBp7quaDLsaOq
         YRGkOg9zGcbYQ==
Subject: [PATCH 05/11] xfs: pass flags and return gc errors from
 xfs_blockgc_free_quota
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 18 Jan 2021 14:12:25 -0800
Message-ID: <161100794571.88816.8971225498794802527.stgit@magnolia>
In-Reply-To: <161100791789.88816.10902093186807310995.stgit@magnolia>
References: <161100791789.88816.10902093186807310995.stgit@magnolia>
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
corruption errors seen while scanning, so that we can fail fast.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c   |    7 ++++++-
 fs/xfs/xfs_icache.c |   35 ++++++++++++++++++++++-------------
 fs/xfs/xfs_icache.h |    3 ++-
 3 files changed, 30 insertions(+), 15 deletions(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 54c658d0f738..a318a4749b59 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -685,8 +685,13 @@ xfs_file_buffered_aio_write(
 	 * running at the same time.
 	 */
 	if (ret == -EDQUOT && !cleared_space) {
+		int	ret2;
+
 		xfs_iunlock(ip, iolock);
-		cleared_space = xfs_blockgc_free_quota(ip);
+		ret2 = xfs_blockgc_free_quota(ip, XFS_EOF_FLAGS_SYNC,
+				&cleared_space);
+		if (ret2)
+			return ret2;
 		if (cleared_space)
 			goto write_retry;
 		iolock = 0;
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index aba901d5637b..1e0ffc0fb73c 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1651,26 +1651,30 @@ xfs_start_block_reaping(
  * failure. We make a best effort by including each quota under low free space
  * conditions (less than 1% free space) in the scan.
  */
-bool
+int
 xfs_blockgc_free_quota(
-	struct xfs_inode	*ip)
+	struct xfs_inode	*ip,
+	unsigned int		eof_flags,
+	bool			*found_work)
 {
 	struct xfs_eofblocks	eofb = {0};
 	struct xfs_dquot	*dq;
-	bool			do_work = false;
+	int			error;
+
+	*found_work = false;
 
 	/*
-	 * Run a sync scan to increase effectiveness and use the union filter to
+	 * Run a scan to increase effectiveness and use the union filter to
 	 * cover all applicable quotas in a single scan.
 	 */
-	eofb.eof_flags = XFS_EOF_FLAGS_UNION | XFS_EOF_FLAGS_SYNC;
+	eofb.eof_flags = XFS_EOF_FLAGS_UNION | eof_flags;
 
 	if (XFS_IS_UQUOTA_ENFORCED(ip->i_mount)) {
 		dq = xfs_inode_dquot(ip, XFS_DQTYPE_USER);
 		if (dq && xfs_dquot_lowsp(dq)) {
 			eofb.eof_uid = VFS_I(ip)->i_uid;
 			eofb.eof_flags |= XFS_EOF_FLAGS_UID;
-			do_work = true;
+			*found_work = true;
 		}
 	}
 
@@ -1679,7 +1683,7 @@ xfs_blockgc_free_quota(
 		if (dq && xfs_dquot_lowsp(dq)) {
 			eofb.eof_gid = VFS_I(ip)->i_gid;
 			eofb.eof_flags |= XFS_EOF_FLAGS_GID;
-			do_work = true;
+			*found_work = true;
 		}
 	}
 
@@ -1688,14 +1692,19 @@ xfs_blockgc_free_quota(
 		if (dq && xfs_dquot_lowsp(dq)) {
 			eofb.eof_prid = ip->i_d.di_projid;
 			eofb.eof_flags |= XFS_EOF_FLAGS_PRID;
-			do_work = true;
+			*found_work = true;
 		}
 	}
 
-	if (!do_work)
-		return false;
+	if (*found_work) {
+		error = xfs_icache_free_eofblocks(ip->i_mount, &eofb);
+		if (error)
+			return error;
 
-	xfs_icache_free_eofblocks(ip->i_mount, &eofb);
-	xfs_icache_free_cowblocks(ip->i_mount, &eofb);
-	return true;
+		error = xfs_icache_free_cowblocks(ip->i_mount, &eofb);
+		if (error)
+			return error;
+	}
+
+	return 0;
 }
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 21b726a05b0d..f7b6ead6fc08 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -54,7 +54,8 @@ long xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
 
 void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
 
-bool xfs_blockgc_free_quota(struct xfs_inode *ip);
+int xfs_blockgc_free_quota(struct xfs_inode *ip, unsigned int eof_flags,
+		bool *found_work);
 
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);

