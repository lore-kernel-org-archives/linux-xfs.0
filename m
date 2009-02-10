Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1AJjpNe071037 for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 13:45:52 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0EEFC10615A
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 11:45:15 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id KAG1rZyjmxkDMYra for
	<xfs@oss.sgi.com>; Tue, 10 Feb 2009 11:45:15 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LWyXj-0000j5-Ma
	for xfs@oss.sgi.com; Tue, 10 Feb 2009 19:45:15 +0000
Message-Id: <20090210194515.509547000@bombadil.infradead.org>
Date: Tue, 10 Feb 2009 14:44:23 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/2] xfs: fix error handling in xfs_log_mount
References: <20090210194422.767988000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-log-mount-error-handling
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

We can't just call xfs_log_unmount_dealloc on any failure because the
ail thread which is torn down by xfs_log_unmount_dealloc might not
be initialized yet.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2009-02-10 19:16:18.761945594 +0100
+++ xfs/fs/xfs/xfs_log.c	2009-02-10 19:18:54.177068965 +0100
@@ -574,7 +574,7 @@ xfs_log_mount(
 	error = xfs_trans_ail_init(mp);
 	if (error) {
 		cmn_err(CE_WARN, "XFS: AIL initialisation failed: error %d", error);
-		goto error;
+		goto out_free_log;
 	}
 	mp->m_log->l_ailp = mp->m_ail;
 
@@ -594,20 +594,22 @@ xfs_log_mount(
 			mp->m_flags |= XFS_MOUNT_RDONLY;
 		if (error) {
 			cmn_err(CE_WARN, "XFS: log mount/recovery failed: error %d", error);
-			goto error;
+			goto out_destroy_ail;
 		}
 	}
 
 	/* Normal transactions can now occur */
 	mp->m_log->l_flags &= ~XLOG_ACTIVE_RECOVERY;
 
-	/* End mounting message in xfs_log_mount_finish */
 	return 0;
-error:
-	xfs_log_unmount_dealloc(mp);
+
+out_destroy_ail:
+	xfs_trans_ail_destroy(mp);
+out_free_log:
+	xlog_dealloc_log(mp->m_log);
 out:
 	return error;
-}	/* xfs_log_mount */
+}
 
 /*
  * Finish the recovery of the file system.  This is separate from

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
