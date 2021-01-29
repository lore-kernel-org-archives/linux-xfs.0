Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF9A4C433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Jan 2021 02:18:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80A7764E07
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Jan 2021 02:18:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbhA2CSw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 21:18:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:57806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229819AbhA2CSu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 21:18:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0FC064E02;
        Fri, 29 Jan 2021 02:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611886689;
        bh=WLOegPftckdrBcMYm8iE+X3h0C15q39r6oHlMJd/p2w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TKcspfKHrRqcg/ymToB4kl2NyMwoxqjEBid6f78iqjghmw5Sv0A6A3C4bLxc3TuZg
         zB/3sUvU+1ZHpwpWaNbGrUFFA7ot4TmgPqOf0qY0YJ7d2PWnw1EZwVbRyttL8ITUsj
         o0peY61ZEkTIIpJI6PIA6Iutl+W3X1xu1QOW4+tUHCppE4eHFqqOkVralhOmQMP7gT
         1GVONMCdE1W7CP12/oby6f8OJePqwblGtTonOtPMrnDM/JpYJ/ef0CgVimyxArIAmS
         PdsJiNyL5jsOZ4R45HyG8b0tHmc4Paa8P3WUzFpn3wlt0C61WYZM/TAkFttwqJo575
         hSIdwxvGAxBmg==
Subject: [PATCH 04/12] xfs: move and rename xfs_inode_free_quota_blocks to
 avoid conflicts
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Thu, 28 Jan 2021 18:18:09 -0800
Message-ID: <161188668922.1943978.16135411188719072001.stgit@magnolia>
In-Reply-To: <161188666613.1943978.971196931920996596.stgit@magnolia>
References: <161188666613.1943978.971196931920996596.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move this function further down in the file so that later cleanups won't
have to declare static functions.  Change the name because we're about
to rework all the code that performs garbage collection of speculatively
allocated file blocks.  No functional changes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_file.c   |    2 -
 fs/xfs/xfs_icache.c |  110 ++++++++++++++++++++++++++-------------------------
 fs/xfs/xfs_icache.h |    2 -
 3 files changed, 57 insertions(+), 57 deletions(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 69879237533b..d69e5abcc1b4 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -747,7 +747,7 @@ xfs_file_buffered_write(
 	 */
 	if (ret == -EDQUOT && !cleared_space) {
 		xfs_iunlock(ip, iolock);
-		cleared_space = xfs_inode_free_quota_blocks(ip);
+		cleared_space = xfs_blockgc_free_quota(ip);
 		if (cleared_space)
 			goto write_retry;
 		iolock = 0;
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 10c1a0dee17d..aba901d5637b 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1396,61 +1396,6 @@ xfs_icache_free_eofblocks(
 			XFS_ICI_EOFBLOCKS_TAG);
 }
 
-/*
- * Run cow/eofblocks scans on the quotas applicable to the inode. For inodes
- * with multiple quotas, we don't know exactly which quota caused an allocation
- * failure. We make a best effort by including each quota under low free space
- * conditions (less than 1% free space) in the scan.
- */
-bool
-xfs_inode_free_quota_blocks(
-	struct xfs_inode	*ip)
-{
-	struct xfs_eofblocks	eofb = {0};
-	struct xfs_dquot	*dq;
-	bool			do_work = false;
-
-	/*
-	 * Run a sync scan to increase effectiveness and use the union filter to
-	 * cover all applicable quotas in a single scan.
-	 */
-	eofb.eof_flags = XFS_EOF_FLAGS_UNION | XFS_EOF_FLAGS_SYNC;
-
-	if (XFS_IS_UQUOTA_ENFORCED(ip->i_mount)) {
-		dq = xfs_inode_dquot(ip, XFS_DQTYPE_USER);
-		if (dq && xfs_dquot_lowsp(dq)) {
-			eofb.eof_uid = VFS_I(ip)->i_uid;
-			eofb.eof_flags |= XFS_EOF_FLAGS_UID;
-			do_work = true;
-		}
-	}
-
-	if (XFS_IS_GQUOTA_ENFORCED(ip->i_mount)) {
-		dq = xfs_inode_dquot(ip, XFS_DQTYPE_GROUP);
-		if (dq && xfs_dquot_lowsp(dq)) {
-			eofb.eof_gid = VFS_I(ip)->i_gid;
-			eofb.eof_flags |= XFS_EOF_FLAGS_GID;
-			do_work = true;
-		}
-	}
-
-	if (XFS_IS_PQUOTA_ENFORCED(ip->i_mount)) {
-		dq = xfs_inode_dquot(ip, XFS_DQTYPE_PROJ);
-		if (dq && xfs_dquot_lowsp(dq)) {
-			eofb.eof_prid = ip->i_d.di_projid;
-			eofb.eof_flags |= XFS_EOF_FLAGS_PRID;
-			do_work = true;
-		}
-	}
-
-	if (!do_work)
-		return false;
-
-	xfs_icache_free_eofblocks(ip->i_mount, &eofb);
-	xfs_icache_free_cowblocks(ip->i_mount, &eofb);
-	return true;
-}
-
 static inline unsigned long
 xfs_iflag_for_tag(
 	int		tag)
@@ -1699,3 +1644,58 @@ xfs_start_block_reaping(
 	xfs_queue_eofblocks(mp);
 	xfs_queue_cowblocks(mp);
 }
+
+/*
+ * Run cow/eofblocks scans on the quotas applicable to the inode. For inodes
+ * with multiple quotas, we don't know exactly which quota caused an allocation
+ * failure. We make a best effort by including each quota under low free space
+ * conditions (less than 1% free space) in the scan.
+ */
+bool
+xfs_blockgc_free_quota(
+	struct xfs_inode	*ip)
+{
+	struct xfs_eofblocks	eofb = {0};
+	struct xfs_dquot	*dq;
+	bool			do_work = false;
+
+	/*
+	 * Run a sync scan to increase effectiveness and use the union filter to
+	 * cover all applicable quotas in a single scan.
+	 */
+	eofb.eof_flags = XFS_EOF_FLAGS_UNION | XFS_EOF_FLAGS_SYNC;
+
+	if (XFS_IS_UQUOTA_ENFORCED(ip->i_mount)) {
+		dq = xfs_inode_dquot(ip, XFS_DQTYPE_USER);
+		if (dq && xfs_dquot_lowsp(dq)) {
+			eofb.eof_uid = VFS_I(ip)->i_uid;
+			eofb.eof_flags |= XFS_EOF_FLAGS_UID;
+			do_work = true;
+		}
+	}
+
+	if (XFS_IS_GQUOTA_ENFORCED(ip->i_mount)) {
+		dq = xfs_inode_dquot(ip, XFS_DQTYPE_GROUP);
+		if (dq && xfs_dquot_lowsp(dq)) {
+			eofb.eof_gid = VFS_I(ip)->i_gid;
+			eofb.eof_flags |= XFS_EOF_FLAGS_GID;
+			do_work = true;
+		}
+	}
+
+	if (XFS_IS_PQUOTA_ENFORCED(ip->i_mount)) {
+		dq = xfs_inode_dquot(ip, XFS_DQTYPE_PROJ);
+		if (dq && xfs_dquot_lowsp(dq)) {
+			eofb.eof_prid = ip->i_d.di_projid;
+			eofb.eof_flags |= XFS_EOF_FLAGS_PRID;
+			do_work = true;
+		}
+	}
+
+	if (!do_work)
+		return false;
+
+	xfs_icache_free_eofblocks(ip->i_mount, &eofb);
+	xfs_icache_free_cowblocks(ip->i_mount, &eofb);
+	return true;
+}
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 3f7ddbca8638..21b726a05b0d 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -54,7 +54,7 @@ long xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
 
 void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
 
-bool xfs_inode_free_quota_blocks(struct xfs_inode *ip);
+bool xfs_blockgc_free_quota(struct xfs_inode *ip);
 
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);

