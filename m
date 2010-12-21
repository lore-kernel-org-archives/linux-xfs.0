Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBL7SYre244929 for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 01:28:35 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4AF211470328
	for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 23:30:31 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	uTyZVeVr0bKrU1IG for <xfs@oss.sgi.com>;
	Mon, 20 Dec 2010 23:30:31 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	39223402-1927428
	for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 18:00:28 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PUwfy-0001EU-4P
	for xfs@oss.sgi.com; Tue, 21 Dec 2010 18:30:26 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PUwfm-0006aM-PQ
	for xfs@oss.sgi.com; Tue, 21 Dec 2010 18:30:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 34/34] xfs: kill useless spinlock_destroy macro
Date: Tue, 21 Dec 2010 18:29:30 +1100
Message-Id: <1292916570-25015-35-git-send-email-david@fromorbit.com>
In-Reply-To: <1292916570-25015-1-git-send-email-david@fromorbit.com>
References: <1292916570-25015-1-git-send-email-david@fromorbit.com>
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
index 0bf24b1..f94016d 100644
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
