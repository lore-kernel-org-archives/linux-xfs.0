Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q633LfTD046800 for <xfs@oss.sgi.com>; Mon, 2 Jul 2012 22:21:41 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	BPfY4dXHkB3TBVaD for <xfs@oss.sgi.com>;
	Mon, 02 Jul 2012 20:21:39 -0700 (PDT)
Date: Tue, 3 Jul 2012 13:21:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_btree_cur leak with 3.5-rc4
Message-ID: <20120703032136.GZ19223@dastard>
References: <20120702191412.GA3617@redhat.com> <20120703002611.GW19223@dastard>
	<20120703012628.GA5710@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120703012628.GA5710@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, xfs@oss.sgi.com

On Mon, Jul 02, 2012 at 09:26:28PM -0400, Mike Snitzer wrote:
> On Mon, Jul 02 2012 at  8:26pm -0400,
> Dave Chinner <david@fromorbit.com> wrote:
> 
> > On Mon, Jul 02, 2012 at 03:14:12PM -0400, Mike Snitzer wrote:
> > > I get kmemleak reports against XFS when I run the thinp-test-suite
> > > against 3.5-rc4.  I didn't see any XFS leaks with 3.4.
> > 
> > Already fixed in 3.5-rc5:
> > 
> > 76d0953 xfs: fix allocbt cursor leak in xfs_alloc_ag_vextent_near
> 
> Odd, I already have that fix (as it was included in 3.5-rc4).

I misread the git describe as saying it was included after -rc4. My
mistake. That indicates that the above fix wasn't quite correct...

Try the patch below.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


xfs: really first cursor leak in xfs_alloc_ag_vextent_near

From: Dave Chinner <dchinner@redhat.com>

The current cursor is reallocated when retrying the allocation, so
the exist cursor needs to be destroyed in both the restart and the
failure case.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 9d1aeb7..f654f51 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -1074,13 +1074,13 @@ restart:
 	 * If we couldn't get anything, give up.
 	 */
 	if (bno_cur_lt == NULL && bno_cur_gt == NULL) {
+		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
+
 		if (!forced++) {
 			trace_xfs_alloc_near_busy(args);
 			xfs_log_force(args->mp, XFS_LOG_SYNC);
 			goto restart;
 		}
-
-		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
 		trace_xfs_alloc_size_neither(args);
 		args->agbno = NULLAGBLOCK;
 		return 0;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
