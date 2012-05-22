Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4MGcVZ7224721 for <xfs@oss.sgi.com>; Tue, 22 May 2012 11:38:31 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Og52r18sfOQi3a77 for
	<xfs@oss.sgi.com>; Tue, 22 May 2012 09:38:30 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q4MGcTbE028709
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 22 May 2012 12:38:29 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH v3 2/2] xfs: fix xfsaild hang due to lost wake ups
Date: Tue, 22 May 2012 12:38:34 -0400
Message-Id: <1337704714-50235-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1337704714-50235-1-git-send-email-bfoster@redhat.com>
References: <1337704714-50235-1-git-send-email-bfoster@redhat.com>
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
Cc: Brian Foster <bfoster@redhat.com>

Running xfstests 273 in a loop reproduces an XFS lockup due to
xfsaild entering idle mode indefinitely. The following
high-level sequence of events leads to the hang:

- xfsaild is running with a cached target lsn
- xfs_ail_push() is invoked, updates ailp->xa_target_lsn and
  invokes wake_up_process(). wake_up_process() returns 0
  because xfsaild is already running.
- xfsaild enters idle mode having met its current target.

Once in the described state, xfs_ail_push() is invoked many
more times with the already set threshold_lsn, but these calls
do not lead to wake_up_process() calls because no further
invocations result in moving the threshold_lsn forward. Add a
flag to xfs_ail to capture whether an issued wake actually
succeeds. If not, continue issuing wakes until we know one has
been successful for the current target.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_trans_ail.c  |    4 ++--
 fs/xfs/xfs_trans_priv.h |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 8a122d3..8b49be8 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -564,7 +564,7 @@ xfs_ail_push(
 
 	lip = xfs_ail_min(ailp);
 	if (!lip || XFS_FORCED_SHUTDOWN(ailp->xa_mount) ||
-	    XFS_LSN_CMP(threshold_lsn, ailp->xa_target) <= 0)
+	    ((XFS_LSN_CMP(threshold_lsn, ailp->xa_target) <= 0) && !ailp->xa_pending_wake))
 		return;
 
 	/*
@@ -575,7 +575,7 @@ xfs_ail_push(
 	xfs_trans_ail_copy_lsn(ailp, &ailp->xa_target, &threshold_lsn);
 	smp_wmb();
 
-	wake_up_process(ailp->xa_task);
+	ailp->xa_pending_wake = !wake_up_process(ailp->xa_task);
 }
 
 /*
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index fb62377..688ef73 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -71,6 +71,7 @@ struct xfs_ail {
 	spinlock_t		xa_lock;
 	xfs_lsn_t		xa_last_pushed_lsn;
 	int			xa_log_flush;
+	int			xa_pending_wake;
 	struct list_head	xa_buf_list;
 	wait_queue_head_t	xa_empty;
 };
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
