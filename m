Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4LIjvE4243893 for <xfs@oss.sgi.com>; Mon, 21 May 2012 13:45:57 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id h2RjwB78dzp7g7Ng for
	<xfs@oss.sgi.com>; Mon, 21 May 2012 11:45:56 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q4LIjqbt017430
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 21 May 2012 14:45:55 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH 3/3] xfs: fix xfsaild hang due to lost wake ups
Date: Mon, 21 May 2012 13:21:26 -0400
Message-Id: <1337620886-41807-4-git-send-email-bfoster@redhat.com>
In-Reply-To: <1337620886-41807-1-git-send-email-bfoster@redhat.com>
References: <1337620886-41807-1-git-send-email-bfoster@redhat.com>
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
index 5818076..35ae0d3 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -576,7 +576,7 @@ xfs_ail_push(
 
 	lip = xfs_ail_min(ailp);
 	if (!lip || XFS_FORCED_SHUTDOWN(ailp->xa_mount) ||
-	    XFS_LSN_CMP(threshold_lsn, ailp->xa_target) <= 0)
+	    ((XFS_LSN_CMP(threshold_lsn, ailp->xa_target) <= 0) && !ailp->xa_pending_wake))
 		return;
 
 	/*
@@ -587,7 +587,7 @@ xfs_ail_push(
 	xfs_trans_ail_copy_lsn(ailp, &ailp->xa_target, &threshold_lsn);
 	smp_wmb();
 
-	wake_up_process(ailp->xa_task);
+	ailp->xa_pending_wake = !wake_up_process(ailp->xa_task);
 }
 
 /*
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 0af1175..05d9de5 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -70,6 +70,7 @@ struct xfs_ail {
 	struct list_head	xa_cursors;
 	spinlock_t		xa_lock;
 	xfs_lsn_t		xa_last_pushed_lsn;
+	int			xa_pending_wake;
 };
 
 /*
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
