Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7E8197F58
	for <xfs@oss.sgi.com>; Mon, 26 May 2014 17:27:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 34F30AC003
	for <xfs@oss.sgi.com>; Mon, 26 May 2014 15:27:21 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	j5oCvnha6XJkpJ3S for <xfs@oss.sgi.com>;
	Mon, 26 May 2014 15:27:16 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Wp3MA-0001PS-BV
	for xfs@oss.sgi.com; Tue, 27 May 2014 08:26:58 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1Wp3MA-0002VA-Ao
	for xfs@oss.sgi.com; Tue, 27 May 2014 08:26:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: block allocation work needs to be kswapd aware
Date: Tue, 27 May 2014 08:26:53 +1000
Message-Id: <1401143214-9181-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1401143214-9181-1-git-send-email-david@fromorbit.com>
References: <1401143214-9181-1-git-send-email-david@fromorbit.com>
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

Upon memory pressure, kswapd calls xfs_vm_writepage() from
shrink_page_list(). This can result in delayed allocation occurring
and that gets deferred to the the allocation workqueue.

The allocation then runs outside kswapd context, which means if it
needs memory (and it does to demand page metadata from disk) it can
block in shrink_inactive_list() waiting for IO congestion. These
blocking waits are normally avoiding in kswapd context, so under
memory pressure writeback from kswapd can be arbitrarily delayed by
memory reclaim.

To avoid this, pass the kswapd context to the allocation being done
by the workqueue, so that memory reclaim understands correctly that
the work is being done for kswapd and therefore it is not blocked
and does not delay memory reclaim.

To avoid issues with int->char conversion of flag fields (as noticed
in v1 of this patch) convert the flag fields in the struct
xfs_bmalloca to bool types. pahole indicates these variables are
still single byte variables, so no extra space is consumed by this
change.

cc: <stable@vger.kernel.org>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap_util.c | 16 +++++++++++++---
 fs/xfs/xfs_bmap_util.h | 13 +++++++------
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 057f671..703b3ec 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -258,14 +258,23 @@ xfs_bmapi_allocate_worker(
 	struct xfs_bmalloca	*args = container_of(work,
 						struct xfs_bmalloca, work);
 	unsigned long		pflags;
+	unsigned long		new_pflags = PF_FSTRANS;
 
-	/* we are in a transaction context here */
-	current_set_flags_nested(&pflags, PF_FSTRANS);
+	/*
+	 * we are in a transaction context here, but may also be doing work
+	 * in kswapd context, and hence we may need to inherit that state
+	 * temporarily to ensure that we don't block waiting for memory reclaim
+	 * in any way.
+	 */
+	if (args->kswapd)
+		new_pflags |= PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;
+
+	current_set_flags_nested(&pflags, new_pflags);
 
 	args->result = __xfs_bmapi_allocate(args);
 	complete(args->done);
 
-	current_restore_flags_nested(&pflags, PF_FSTRANS);
+	current_restore_flags_nested(&pflags, new_pflags);
 }
 
 /*
@@ -284,6 +293,7 @@ xfs_bmapi_allocate(
 
 
 	args->done = &done;
+	args->kswapd = current_is_kswapd();
 	INIT_WORK_ONSTACK(&args->work, xfs_bmapi_allocate_worker);
 	queue_work(xfs_alloc_wq, &args->work);
 	wait_for_completion(&done);
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 935ed2b..075f722 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -50,12 +50,13 @@ struct xfs_bmalloca {
 	xfs_extlen_t		total;	/* total blocks needed for xaction */
 	xfs_extlen_t		minlen;	/* minimum allocation size (blocks) */
 	xfs_extlen_t		minleft; /* amount must be left after alloc */
-	char			eof;	/* set if allocating past last extent */
-	char			wasdel;	/* replacing a delayed allocation */
-	char			userdata;/* set if is user data */
-	char			aeof;	/* allocated space at eof */
-	char			conv;	/* overwriting unwritten extents */
-	char			stack_switch;
+	bool			eof;	/* set if allocating past last extent */
+	bool			wasdel;	/* replacing a delayed allocation */
+	bool			userdata;/* set if is user data */
+	bool			aeof;	/* allocated space at eof */
+	bool			conv;	/* overwriting unwritten extents */
+	bool			stack_switch;
+	bool			kswapd;	/* allocation in kswapd context */
 	int			flags;
 	struct completion	*done;
 	struct work_struct	work;
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
