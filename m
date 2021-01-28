Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65735C433E9
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:03:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24EAD64DDB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:03:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbhA1GDF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 01:03:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:37868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229953AbhA1GDD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 01:03:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5117461492;
        Thu, 28 Jan 2021 06:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611813767;
        bh=WLOegPftckdrBcMYm8iE+X3h0C15q39r6oHlMJd/p2w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PsgFQ/lpKwKtC99D1xW4JMsX0s6PKcspT2hvvsqd8jxkoHcO71+O0dHu6RmGeingt
         NToIkYAjZkhP8uxnUrHs2lxalz/JkctVIqyGWPOYDmY9p8DJXDfjXcXTh3rw1WBtyL
         lczvjKOmrialKF0dYJ0iQG1CYWQaMFEUS1+murB3qhJilQCD9SnV+5XR/vyBiJ07Ab
         C08jTJa3d8A6KR3mw2w0ofRBCzOHvnzKuiMQ40GGUNgCQfHo+f3xnHtNY8T/zfP32O
         L7T3SuwLbfli71v2++qnifd4X40rfKKrqTOxSHuUiJLRv8LAXkKTerACXhTYHf37B8
         bPO9uPTsU6bEw==
Subject: [PATCH 04/11] xfs: move and rename xfs_inode_free_quota_blocks to
 avoid conflicts
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Wed, 27 Jan 2021 22:02:43 -0800
Message-ID: <161181376352.1525026.14789613693604861224.stgit@magnolia>
In-Reply-To: <161181374062.1525026.14717838769921652940.stgit@magnolia>
References: <161181374062.1525026.14717838769921652940.stgit@magnolia>
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

