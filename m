Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 04A4729DF8
	for <xfs@oss.sgi.com>; Thu,  9 May 2013 02:20:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C4B8E304053
	for <xfs@oss.sgi.com>; Thu,  9 May 2013 00:20:51 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	uZD9huu1rDeIY0df for <xfs@oss.sgi.com>;
	Thu, 09 May 2013 00:20:49 -0700 (PDT)
Date: Thu, 9 May 2013 17:20:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Rambling noise #1: generic/230 can trigger kernel debug lock
	detector
Message-ID: <20130509072045.GO24635@dastard>
References: <518B08D9.1060906@gmail.com>
 <20130509031646.GN24635@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130509031646.GN24635@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, May 09, 2013 at 01:16:46PM +1000, Dave Chinner wrote:
> On Wed, May 08, 2013 at 10:24:25PM -0400, Michael L. Semon wrote:
> > Hi!  I'm trying to come up with a series of ramblings that may or
> > may not be useful in a mailing-list context, with the idea that one
> > bug report might be good, the next might be me thinking aloud with
> > data in hand because I know something's wrong but can't put my
> > finger on it.  An ex-girlfriend saw the movie "Rain Man" years ago
> > pointed to the screen and said, "Do you see that guy?  That's you!"
> > If only I could be so smart...or act as well as Dustin Hoffman.  The
> > noisy thinking is there, just not the brilliant insights...
> > 
> > This report is to pass on a kernel lock detector message that might
> > be reproducible under a certain family of tests.  generic/230 may
> > not be at fault, it's just where the detector went off.
> 
> No, there's definitely a bug there. Thanks for the report, Michael.
> Try the patch below.

Actaully, there's a bug in the error handling in that version - it
fails to unlock the quotaoff lock properly on failure. The version
below fixes that problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: avoid nesting transactions in xfs_qm_scall_setqlim()

From: Dave Chinner <dchinner@redhat.com>

Lockdep reports:

=============================================
[ INFO: possible recursive locking detected ]
3.9.0+ #3 Not tainted
---------------------------------------------
setquota/28368 is trying to acquire lock:
 (sb_internal){++++.?}, at: [<c11e8846>] xfs_trans_alloc+0x26/0x50

but task is already holding lock:
 (sb_internal){++++.?}, at: [<c11e8846>] xfs_trans_alloc+0x26/0x50

from xfs_qm_scall_setqlim()->xfs_dqread() when a dquot needs to be
allocated.

xfs_qm_scall_setqlim() is starting a transaction and then not
passing it into xfs_qm_dqet() and so it starts it's own transaction
when allocating the dquot.  Splat!

Fix this by not allocating the dquot in xfs_qm_scall_setqlim()
inside the setqlim transaction. This requires getting the dquot
first (and allocating it if necessary) then dropping and relocking
the dquot before joining it to the setqlim transaction.

Reported-by: Michael L. Semon <mlsemon35@gmail.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_qm_syscalls.c |   35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index c41190c..dfa5c05 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -489,31 +489,36 @@ xfs_qm_scall_setqlim(
 	if ((newlim->d_fieldmask & XFS_DQ_MASK) == 0)
 		return 0;
 
-	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_SETQLIM);
-	error = xfs_trans_reserve(tp, 0, XFS_QM_SETQLIM_LOG_RES(mp),
-				  0, 0, XFS_DEFAULT_LOG_COUNT);
-	if (error) {
-		xfs_trans_cancel(tp, 0);
-		return (error);
-	}
-
 	/*
 	 * We don't want to race with a quotaoff so take the quotaoff lock.
-	 * (We don't hold an inode lock, so there's nothing else to stop
-	 * a quotaoff from happening). (XXXThis doesn't currently happen
-	 * because we take the vfslock before calling xfs_qm_sysent).
+	 * We don't hold an inode lock, so there's nothing else to stop
+	 * a quotaoff from happening.
 	 */
 	mutex_lock(&q->qi_quotaofflock);
 
 	/*
-	 * Get the dquot (locked), and join it to the transaction.
-	 * Allocate the dquot if this doesn't exist.
+	 * Get the dquot (locked) before we start, as we need to do a
+	 * transaction to allocate it if it doesn't exist. Once we have the
+	 * dquot, unlock it so we can start the next transaction safely. We hold
+	 * a reference to the dquot, so it's safe to do this unlock/lock without
+	 * it being reclaimed in the mean time.
 	 */
-	if ((error = xfs_qm_dqget(mp, NULL, id, type, XFS_QMOPT_DQALLOC, &dqp))) {
-		xfs_trans_cancel(tp, XFS_TRANS_ABORT);
+	error = xfs_qm_dqget(mp, NULL, id, type, XFS_QMOPT_DQALLOC, &dqp);
+	if (error) {
 		ASSERT(error != ENOENT);
 		goto out_unlock;
 	}
+	xfs_dqunlock(dqp);
+
+	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_SETQLIM);
+	error = xfs_trans_reserve(tp, 0, XFS_QM_SETQLIM_LOG_RES(mp),
+				  0, 0, XFS_DEFAULT_LOG_COUNT);
+	if (error) {
+		xfs_trans_cancel(tp, 0);
+		goto out_unlock;
+	}
+
+	xfs_dqlock(dqp);
 	xfs_trans_dqjoin(tp, dqp);
 	ddq = &dqp->q_core;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
