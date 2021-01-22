Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A966CC4361A
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Jan 2021 17:56:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B6DB23B19
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Jan 2021 17:56:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729355AbhAVR1P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Jan 2021 12:27:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729455AbhAVQrm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Jan 2021 11:47:42 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F20C061786
        for <linux-xfs@vger.kernel.org>; Fri, 22 Jan 2021 08:46:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=jNlNU+3Udw7sq9V7Met30J/TMNIT6VTkaCsY3CU9c/Q=; b=oHImHujLeRIl8Y1Scn90+9c5FF
        IdBaltDm1xF62dPv4cpMjngcHewcFjH3g9ViFJT0x9Zoo2wkkPjMbor3ylq3iyXAjUsOPEt/UiEpi
        RdtSnz9ga08+GE+v4CnwFoRjMTH3iO9KbWPrBSdFhPFiHVj40DhKqTPnX+ukPzl0JOET4lE0VJ2oN
        6ATJlTU3XWoEr1x01lRlpWoMyDUJiivKivsnoivJAUZN5o5HJr2UsNIMKU4Uxv8dftAI5hgmzg4xn
        fgDsp5ZEVVHBGCKQPgW+wmdN3St5Zqt23IH+ezm5vzGlC3tS6qne2Kh7mZjt/NzzZSPBY+z+YXlSG
        tp5gHqJA==;
Received: from [2001:4bb8:188:1954:662b:86d3:ab5f:ac21] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l2zaD-000yXL-1t; Fri, 22 Jan 2021 16:46:50 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/2] xfs: refactor xfs_file_fsync
Date:   Fri, 22 Jan 2021 17:46:42 +0100
Message-Id: <20210122164643.620257-2-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210122164643.620257-1-hch@lst.de>
References: <20210122164643.620257-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Factor out the log syncing logic into two helpers to make the code easier
to read and more maintainable.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_file.c | 81 +++++++++++++++++++++++++++++------------------
 1 file changed, 50 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 39695b59dfcc92..588232c77f11e0 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -118,6 +118,54 @@ xfs_dir_fsync(
 	return xfs_log_force_inode(ip);
 }
 
+static xfs_lsn_t
+xfs_fsync_lsn(
+	struct xfs_inode	*ip,
+	bool			datasync)
+{
+	if (!xfs_ipincount(ip))
+		return 0;
+	if (datasync && !(ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
+		return 0;
+	return ip->i_itemp->ili_last_lsn;
+}
+
+/*
+ * All metadata updates are logged, which means that we just have to flush the
+ * log up to the latest LSN that touched the inode.
+ *
+ * If we have concurrent fsync/fdatasync() calls, we need them to all block on
+ * the log force before we clear the ili_fsync_fields field. This ensures that
+ * we don't get a racing sync operation that does not wait for the metadata to
+ * hit the journal before returning.  If we race with clearing ili_fsync_fields,
+ * then all that will happen is the log force will do nothing as the lsn will
+ * already be on disk.  We can't race with setting ili_fsync_fields because that
+ * is done under XFS_ILOCK_EXCL, and that can't happen because we hold the lock
+ * shared until after the ili_fsync_fields is cleared.
+ */
+static  int
+xfs_fsync_flush_log(
+	struct xfs_inode	*ip,
+	bool			datasync,
+	int			*log_flushed)
+{
+	int			error = 0;
+	xfs_lsn_t		lsn;
+
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	lsn = xfs_fsync_lsn(ip, datasync);
+	if (lsn) {
+		error = xfs_log_force_lsn(ip->i_mount, lsn, XFS_LOG_SYNC,
+					  log_flushed);
+
+		spin_lock(&ip->i_itemp->ili_lock);
+		ip->i_itemp->ili_fsync_fields = 0;
+		spin_unlock(&ip->i_itemp->ili_lock);
+	}
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	return error;
+}
+
 STATIC int
 xfs_file_fsync(
 	struct file		*file,
@@ -125,13 +173,10 @@ xfs_file_fsync(
 	loff_t			end,
 	int			datasync)
 {
-	struct inode		*inode = file->f_mapping->host;
-	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_inode_log_item *iip = ip->i_itemp;
+	struct xfs_inode	*ip = XFS_I(file->f_mapping->host);
 	struct xfs_mount	*mp = ip->i_mount;
 	int			error = 0;
 	int			log_flushed = 0;
-	xfs_lsn_t		lsn = 0;
 
 	trace_xfs_file_fsync(ip);
 
@@ -155,33 +200,7 @@ xfs_file_fsync(
 	else if (mp->m_logdev_targp != mp->m_ddev_targp)
 		xfs_blkdev_issue_flush(mp->m_ddev_targp);
 
-	/*
-	 * All metadata updates are logged, which means that we just have to
-	 * flush the log up to the latest LSN that touched the inode. If we have
-	 * concurrent fsync/fdatasync() calls, we need them to all block on the
-	 * log force before we clear the ili_fsync_fields field. This ensures
-	 * that we don't get a racing sync operation that does not wait for the
-	 * metadata to hit the journal before returning. If we race with
-	 * clearing the ili_fsync_fields, then all that will happen is the log
-	 * force will do nothing as the lsn will already be on disk. We can't
-	 * race with setting ili_fsync_fields because that is done under
-	 * XFS_ILOCK_EXCL, and that can't happen because we hold the lock shared
-	 * until after the ili_fsync_fields is cleared.
-	 */
-	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	if (xfs_ipincount(ip)) {
-		if (!datasync ||
-		    (iip->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
-			lsn = iip->ili_last_lsn;
-	}
-
-	if (lsn) {
-		error = xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, &log_flushed);
-		spin_lock(&iip->ili_lock);
-		iip->ili_fsync_fields = 0;
-		spin_unlock(&iip->ili_lock);
-	}
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	error = xfs_fsync_flush_log(ip, datasync, &log_flushed);
 
 	/*
 	 * If we only have a single device, and the log force about was
-- 
2.29.2

