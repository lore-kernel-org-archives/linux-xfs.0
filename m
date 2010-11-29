Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAT1bNMv082122 for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 19:37:23 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1391A1AE776
	for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 17:39:03 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	Fsd0IlrupUdtc59U for <xfs@oss.sgi.com>;
	Sun, 28 Nov 2010 17:39:03 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	48055179-1927428
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 12:09:02 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1PMshp-0000de-RM
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 12:39:01 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PMshQ-0005ck-Dj
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 12:38:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 11/14] xfs: remove log grant lock
Date: Mon, 29 Nov 2010 12:38:29 +1100
Message-Id: <1290994712-21376-12-git-send-email-david@fromorbit.com>
In-Reply-To: <1290994712-21376-1-git-send-email-david@fromorbit.com>
References: <1290994712-21376-1-git-send-email-david@fromorbit.com>
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

The log grant lock no longer protects anything, so remove the remaining
initialisation and teardown code that still exists.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c      |    3 ---
 fs/xfs/xfs_log_priv.h |    3 ---
 2 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 50cf6af..d54d8f8 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1118,7 +1118,6 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	log->l_xbuf = bp;
 
 	spin_lock_init(&log->l_icloglock);
-	spin_lock_init(&log->l_grant_lock);
 	sv_init(&log->l_flush_wait, 0, "flush_wait");
 
 	/* log record size must be multiple of BBSIZE; see xlog_rec_header_t */
@@ -1199,7 +1198,6 @@ out_free_iclog:
 		kmem_free(iclog);
 	}
 	spinlock_destroy(&log->l_icloglock);
-	spinlock_destroy(&log->l_grant_lock);
 	xfs_buf_free(log->l_xbuf);
 out_free_log:
 	kmem_free(log);
@@ -1516,7 +1514,6 @@ xlog_dealloc_log(xlog_t *log)
 		iclog = next_iclog;
 	}
 	spinlock_destroy(&log->l_icloglock);
-	spinlock_destroy(&log->l_grant_lock);
 
 	xfs_buf_free(log->l_xbuf);
 	log->l_mp->m_log = NULL;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 621002c..cd62400 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -512,9 +512,6 @@ typedef struct log {
 	int			l_curr_block;   /* current logical log block */
 	int			l_prev_block;   /* previous logical log block */
 
-	/* The following block of fields are changed while holding grant_lock */
-	spinlock_t		l_grant_lock ____cacheline_aligned_in_smp;
-
 	/*
 	 * l_last_sync_lsn and l_tail_lsn are atomics so they can be set and
 	 * read without needing to hold specific locks. To avoid operations
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
