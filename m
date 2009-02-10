Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1AADZnr044032 for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 04:13:36 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9C77A190EC8B
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 02:12:59 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id XNHmMYnCxPnt1pAw for
	<xfs@oss.sgi.com>; Tue, 10 Feb 2009 02:12:59 -0800 (PST)
Date: Tue, 10 Feb 2009 05:12:28 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Check if AIL has been started before stopping it
Message-ID: <20090210101228.GA5562@infradead.org>
References: <4990D7EA.7020902@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4990D7EA.7020902@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 10, 2009 at 12:27:06PM +1100, Lachlan McIlroy wrote:
> A failure during mount can result in shutting down the AIL when
> it may not have been started up yet.

The right fix is to not call xfsaild_stop in that case.

Something like this should fix your problem:


Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2009-02-10 11:10:41.804069754 +0100
+++ xfs/fs/xfs/xfs_log.c	2009-02-10 11:10:58.339943990 +0100
@@ -575,7 +575,7 @@ xfs_log_mount(
 	error = xfs_trans_ail_init(mp);
 	if (error) {
 		cmn_err(CE_WARN, "XFS: AIL initialisation failed: error %d", error);
-		goto error;
+		goto out_free_log;
 	}
 	mp->m_log->l_ailp = mp->m_ail;
 
@@ -595,20 +595,22 @@ xfs_log_mount(
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
