Return-Path: <SRS0=IYS1=XL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1577C4CECD
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 12:20:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD29321670
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 12:20:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WbvUbiRe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732409AbfIPMUq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Sep 2019 08:20:46 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50590 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727810AbfIPMUq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Sep 2019 08:20:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=UN2Dniu5lJ/PLOxrRbaEE4lHZT6slvcdIJ/w0M9dxyk=; b=WbvUbiReMKKcETTOBGKSBJES2
        9zbFE08jEd/+t2n64MLx1+Y+2+Teaz+bceaGaBRvqSdwEZ7Q/mdcjXrwICYXlYt+h51JEk4tiwQS1
        G+OdqyKHTsCeQvOFDLYmVfcltwGr5sNnofsb/13i4L0gM7qp4Ochy6SMd3vlKD4Ik2vmk9vgYIdoU
        ftazYgcq0oR7ku57S5nyGXPk8xMFN1bPi00KpfTNLlYsfcYN7JPd1+VMJK6uB5KDyz1i6QgipR3zZ
        +FxfomE+DFcSIlMssexDYMxE2ZEzcYf8d2dXNRdjAPIl5tqgCybLeY9nBXZvfn8/WSC9DVoSYnBDm
        VSE1ycnFA==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1i9pzp-0001O5-Im
        for linux-xfs@vger.kernel.org; Mon, 16 Sep 2019 12:20:45 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: remove xfs_release
Date:   Mon, 16 Sep 2019 14:20:40 +0200
Message-Id: <20190916122041.24636-2-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190916122041.24636-1-hch@lst.de>
References: <20190916122041.24636-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We can just move the code directly to xfs_file_release.  Additionally
remove the pointless i_mode verification, and the error returns that
are entirely ignored by the calller of ->release.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c  | 66 ++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_inode.c | 80 ----------------------------------------------
 fs/xfs/xfs_inode.h |  1 -
 3 files changed, 63 insertions(+), 84 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index d952d5962e93..72680edf2ceb 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1060,10 +1060,70 @@ xfs_dir_open(
 
 STATIC int
 xfs_file_release(
-	struct inode	*inode,
-	struct file	*filp)
+	struct inode		*inode,
+	struct file		*file)
 {
-	return xfs_release(XFS_I(inode));
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+
+	if (mp->m_flags & XFS_MOUNT_RDONLY)
+		return 0;
+	
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return 0;
+
+	/*
+	 * If we previously truncated this file and removed old data in the
+	 * process, we want to initiate "early" writeout on the last close.
+	 * This is an attempt to combat the notorious NULL files problem which
+	 * is particularly noticeable from a truncate down, buffered (re-)write
+	 * (delalloc), followed by a crash.  What we are effectively doing here
+	 * is significantly reducing the time window where we'd otherwise be
+	 * exposed to that problem.
+	 */
+	if (xfs_iflags_test_and_clear(ip, XFS_ITRUNCATED)) {
+		xfs_iflags_clear(ip, XFS_IDIRTY_RELEASE);
+		if (ip->i_delayed_blks > 0)
+			filemap_flush(inode->i_mapping);
+		return 0;
+	}
+
+	if (inode->i_nlink == 0 || !xfs_can_free_eofblocks(ip, false))
+		return 0;
+
+	/*
+	 * Check if the inode is being opened, written and closed frequently and
+	 * we have delayed allocation blocks outstanding (e.g. streaming writes
+	 * from the NFS server), truncating the blocks past EOF will cause
+	 * fragmentation to occur.
+	 *
+	 * In this case don't do the truncation, but we have to be careful how
+	 * we detect this case. Blocks beyond EOF show up as i_delayed_blks even
+	 * when the inode is clean, so we need to truncate them away first
+	 * before checking for a dirty release.  Hence on the first dirty close
+	 * we will still remove the speculative allocation, but after that we
+	 * will leave it in place.
+	 */
+	if (xfs_iflags_test(ip, XFS_IDIRTY_RELEASE))
+		return 0;
+
+	/*
+	 * If we can't get the iolock just skip truncating the blocks past EOF
+	 * because we could deadlock with the mmap_sem otherwise.  We'll get
+	 * another chance to drop them once the last reference to the inode is
+	 * dropped, so we'll never leak blocks permanently.
+	 */
+	if (xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
+		xfs_free_eofblocks(ip);
+		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+	}
+
+	/*
+	 * Delalloc blocks after truncation means it really is dirty.
+	 */
+	if (ip->i_delayed_blks)
+		xfs_iflags_set(ip, XFS_IDIRTY_RELEASE);
+	return 0;
 }
 
 STATIC int
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 18f4b262e61c..b21405540c37 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1590,86 +1590,6 @@ xfs_itruncate_extents_flags(
 	return error;
 }
 
-int
-xfs_release(
-	xfs_inode_t	*ip)
-{
-	xfs_mount_t	*mp = ip->i_mount;
-	int		error;
-
-	if (!S_ISREG(VFS_I(ip)->i_mode) || (VFS_I(ip)->i_mode == 0))
-		return 0;
-
-	/* If this is a read-only mount, don't do this (would generate I/O) */
-	if (mp->m_flags & XFS_MOUNT_RDONLY)
-		return 0;
-
-	if (!XFS_FORCED_SHUTDOWN(mp)) {
-		int truncated;
-
-		/*
-		 * If we previously truncated this file and removed old data
-		 * in the process, we want to initiate "early" writeout on
-		 * the last close.  This is an attempt to combat the notorious
-		 * NULL files problem which is particularly noticeable from a
-		 * truncate down, buffered (re-)write (delalloc), followed by
-		 * a crash.  What we are effectively doing here is
-		 * significantly reducing the time window where we'd otherwise
-		 * be exposed to that problem.
-		 */
-		truncated = xfs_iflags_test_and_clear(ip, XFS_ITRUNCATED);
-		if (truncated) {
-			xfs_iflags_clear(ip, XFS_IDIRTY_RELEASE);
-			if (ip->i_delayed_blks > 0) {
-				error = filemap_flush(VFS_I(ip)->i_mapping);
-				if (error)
-					return error;
-			}
-		}
-	}
-
-	if (VFS_I(ip)->i_nlink == 0)
-		return 0;
-
-	if (xfs_can_free_eofblocks(ip, false)) {
-
-		/*
-		 * Check if the inode is being opened, written and closed
-		 * frequently and we have delayed allocation blocks outstanding
-		 * (e.g. streaming writes from the NFS server), truncating the
-		 * blocks past EOF will cause fragmentation to occur.
-		 *
-		 * In this case don't do the truncation, but we have to be
-		 * careful how we detect this case. Blocks beyond EOF show up as
-		 * i_delayed_blks even when the inode is clean, so we need to
-		 * truncate them away first before checking for a dirty release.
-		 * Hence on the first dirty close we will still remove the
-		 * speculative allocation, but after that we will leave it in
-		 * place.
-		 */
-		if (xfs_iflags_test(ip, XFS_IDIRTY_RELEASE))
-			return 0;
-		/*
-		 * If we can't get the iolock just skip truncating the blocks
-		 * past EOF because we could deadlock with the mmap_sem
-		 * otherwise. We'll get another chance to drop them once the
-		 * last reference to the inode is dropped, so we'll never leak
-		 * blocks permanently.
-		 */
-		if (xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
-			error = xfs_free_eofblocks(ip);
-			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
-			if (error)
-				return error;
-		}
-
-		/* delalloc blocks after truncation means it really is dirty */
-		if (ip->i_delayed_blks)
-			xfs_iflags_set(ip, XFS_IDIRTY_RELEASE);
-	}
-	return 0;
-}
-
 /*
  * xfs_inactive_truncate
  *
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 558173f95a03..4299905135b2 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -410,7 +410,6 @@ enum layout_break_reason {
 	(((pip)->i_mount->m_flags & XFS_MOUNT_GRPID) || \
 	 (VFS_I(pip)->i_mode & S_ISGID))
 
-int		xfs_release(struct xfs_inode *ip);
 void		xfs_inactive(struct xfs_inode *ip);
 int		xfs_lookup(struct xfs_inode *dp, struct xfs_name *name,
 			   struct xfs_inode **ipp, struct xfs_name *ci_name);
-- 
2.20.1

