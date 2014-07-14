Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A37A87F60
	for <xfs@oss.sgi.com>; Sun, 13 Jul 2014 23:49:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 99414304053
	for <xfs@oss.sgi.com>; Sun, 13 Jul 2014 21:49:12 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	7dED8KDYIF5WCpDz for <xfs@oss.sgi.com>;
	Sun, 13 Jul 2014 21:49:11 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1X6YCE-0006Jd-Ad
	for xfs@oss.sgi.com; Mon, 14 Jul 2014 14:49:02 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1X6YCE-0007ah-9k
	for xfs@oss.sgi.com; Mon, 14 Jul 2014 14:49:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/3] Revert "xfs: block allocation work needs to be kswapd
	aware"
Date: Mon, 14 Jul 2014 14:48:57 +1000
Message-Id: <1405313339-29110-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1405313339-29110-1-git-send-email-david@fromorbit.com>
References: <1405313339-29110-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

This reverts commit 1f6d64829db78a7e1d63e15c9f48f0a5d2b5a679.

This commit resulted in regressions in performance in low
memory situations where kswapd was doing writeback of delayed
allocation blocks. It resulted in significant parallelism of the
kswapd work and with the special kswapd flags meant that hundreds of
active allocation could dip into kswapd specific memory reserves and
avoid being throttled. This cause a large amount of performance
variation, as well as random OOM-killer invocations that didn't
previously exist.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_bmap_util.c | 16 +++-------------
 fs/xfs/xfs_bmap_util.h | 13 ++++++-------
 2 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 703b3ec..057f671 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -258,23 +258,14 @@ xfs_bmapi_allocate_worker(
 	struct xfs_bmalloca	*args = container_of(work,
 						struct xfs_bmalloca, work);
 	unsigned long		pflags;
-	unsigned long		new_pflags = PF_FSTRANS;
 
-	/*
-	 * we are in a transaction context here, but may also be doing work
-	 * in kswapd context, and hence we may need to inherit that state
-	 * temporarily to ensure that we don't block waiting for memory reclaim
-	 * in any way.
-	 */
-	if (args->kswapd)
-		new_pflags |= PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;
-
-	current_set_flags_nested(&pflags, new_pflags);
+	/* we are in a transaction context here */
+	current_set_flags_nested(&pflags, PF_FSTRANS);
 
 	args->result = __xfs_bmapi_allocate(args);
 	complete(args->done);
 
-	current_restore_flags_nested(&pflags, new_pflags);
+	current_restore_flags_nested(&pflags, PF_FSTRANS);
 }
 
 /*
@@ -293,7 +284,6 @@ xfs_bmapi_allocate(
 
 
 	args->done = &done;
-	args->kswapd = current_is_kswapd();
 	INIT_WORK_ONSTACK(&args->work, xfs_bmapi_allocate_worker);
 	queue_work(xfs_alloc_wq, &args->work);
 	wait_for_completion(&done);
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 075f722..935ed2b 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -50,13 +50,12 @@ struct xfs_bmalloca {
 	xfs_extlen_t		total;	/* total blocks needed for xaction */
 	xfs_extlen_t		minlen;	/* minimum allocation size (blocks) */
 	xfs_extlen_t		minleft; /* amount must be left after alloc */
-	bool			eof;	/* set if allocating past last extent */
-	bool			wasdel;	/* replacing a delayed allocation */
-	bool			userdata;/* set if is user data */
-	bool			aeof;	/* allocated space at eof */
-	bool			conv;	/* overwriting unwritten extents */
-	bool			stack_switch;
-	bool			kswapd;	/* allocation in kswapd context */
+	char			eof;	/* set if allocating past last extent */
+	char			wasdel;	/* replacing a delayed allocation */
+	char			userdata;/* set if is user data */
+	char			aeof;	/* allocated space at eof */
+	char			conv;	/* overwriting unwritten extents */
+	char			stack_switch;
 	int			flags;
 	struct completion	*done;
 	struct work_struct	work;
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
