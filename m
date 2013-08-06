Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2017929DFB
	for <xfs@oss.sgi.com>; Tue,  6 Aug 2013 10:23:59 -0500 (CDT)
Date: Tue, 6 Aug 2013 10:23:55 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 03a/48] xfs: don't verify bmbt reads twice
Message-ID: <20130806152355.GJ3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-4-git-send-email-david@fromorbit.com>
	<20130723182648.GI3111@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130723182648.GI3111@sgi.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Jul 23, 2013 at 01:26:48PM -0500, Ben Myers wrote:
> On Fri, Jun 07, 2013 at 10:25:26AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> This patch mostly corresponds to commit ee1a47ab0e, and in some areas it is
> equivalent but slightly different.  There are some other things in here too:
> 
> * Addition of XFS_BUF_DADDR_NULL
> * rename of b_blkno to b_bn in struct xfs_buf
> * rename of b_fsprivate to b_fspriv in struct xfs_buf
> * addition of uuid_copy and uuid_equal, and libuuid to build
> 
> It all looks fine to me, except as below:
> 
> >  static void
> > @@ -733,13 +760,29 @@ xfs_bmbt_read_verify(
> >  	struct xfs_buf	*bp)
> >  {
> >  	xfs_bmbt_verify(bp);
> 	^^^^^^^^^^^^^^^^^^^^
> In commit ee1a47ab0e we removed this call.

From: Ben Myers <bpm@sgi.com>

xfs: don't verify bmbt reads twice

xfs_bmbt_read_verify is calling xfs_bmbt_verify twice in a row.  commit
ee1a47ab0e in the kernel removed the first xfs_bmbt_verify but this was
not carried over when it was implemented in userspace.

Signed-off-by: Ben Myers <bpm@sgi.com>

---
 libxfs/xfs_bmap_btree.c |    2 --
 1 file changed, 2 deletions(-)

Index: b/libxfs/xfs_bmap_btree.c
===================================================================
--- a/libxfs/xfs_bmap_btree.c	2013-08-06 10:18:21.600252696 -0500
+++ b/libxfs/xfs_bmap_btree.c	2013-08-06 10:21:59.630817672 -0500
@@ -759,7 +759,6 @@ static void
 xfs_bmbt_read_verify(
 	struct xfs_buf	*bp)
 {
-	xfs_bmbt_verify(bp);
 	if (!(xfs_btree_lblock_verify_crc(bp) &&
 	      xfs_bmbt_verify(bp))) {
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
@@ -767,7 +766,6 @@ xfs_bmbt_read_verify(
 				     bp->b_target->bt_mount, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
 	}
-
 }
 
 static void

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
