Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBD4tJaN160440 for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 22:55:19 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 49D951CBADE9
	for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 20:46:48 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	TJXeP1tyU9t03DbI for <xfs@oss.sgi.com>;
	Sun, 12 Dec 2010 20:46:48 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	50129163-1927428
	for <xfs@oss.sgi.com>; Mon, 13 Dec 2010 15:16:45 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PS0J9-000237-PM
	for xfs@oss.sgi.com; Mon, 13 Dec 2010 15:46:43 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PS0Hf-0004mq-Jh
	for xfs@oss.sgi.com; Mon, 13 Dec 2010 15:45:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 12/12] xfs: kill useless spinlock_destroy macro
Date: Mon, 13 Dec 2010 15:44:43 +1100
Message-Id: <1292215483-18224-13-git-send-email-david@fromorbit.com>
In-Reply-To: <1292215483-18224-1-git-send-email-david@fromorbit.com>
References: <1292215483-18224-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

It is only used in 2 places in the log code, and is an empty macro,
so get rid of it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/linux-2.6/xfs_linux.h |    2 --
 fs/xfs/xfs_log.c             |    2 --
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_linux.h b/fs/xfs/linux-2.6/xfs_linux.h
index ccebd86..e7cfa27 100644
--- a/fs/xfs/linux-2.6/xfs_linux.h
+++ b/fs/xfs/linux-2.6/xfs_linux.h
@@ -113,8 +113,6 @@
 #define current_restore_flags_nested(sp, f)	\
 		(current->flags = ((current->flags & ~(f)) | (*(sp) & (f))))
 
-#define spinlock_destroy(lock)
-
 #define NBBY		8		/* number of bits per byte */
 
 /*
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 58326ba..7fadc36 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1141,7 +1141,6 @@ out_free_iclog:
 			xfs_buf_free(iclog->ic_bp);
 		kmem_free(iclog);
 	}
-	spinlock_destroy(&log->l_icloglock);
 	xfs_buf_free(log->l_xbuf);
 out_free_log:
 	kmem_free(log);
@@ -1458,7 +1457,6 @@ xlog_dealloc_log(xlog_t *log)
 		kmem_free(iclog);
 		iclog = next_iclog;
 	}
-	spinlock_destroy(&log->l_icloglock);
 
 	xfs_buf_free(log->l_xbuf);
 	log->l_mp->m_log = NULL;
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
