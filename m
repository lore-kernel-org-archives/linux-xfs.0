Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BE3117F50
	for <xfs@oss.sgi.com>; Sun, 11 Oct 2015 23:28:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AE511304048
	for <xfs@oss.sgi.com>; Sun, 11 Oct 2015 21:28:47 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	GtTDFWX1CN7EV6bk for <xfs@oss.sgi.com>;
	Sun, 11 Oct 2015 21:28:44 -0700 (PDT)
Date: Mon, 12 Oct 2015 15:28:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] cancel the setfilesize transation when io error happen
Message-ID: <20151012042827.GD27164@dastard>
References: <55F0DF7A.7050404@huawei.com>
	<20150915114244.GC21323@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150915114244.GC21323@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: hch@infradead.org, Zhaohongjiang <zhaohongjiang@huawei.com>, xfs@oss.sgi.com

On Tue, Sep 15, 2015 at 07:42:45AM -0400, Brian Foster wrote:
> On Thu, Sep 10, 2015 at 09:40:10AM +0800, Zhaohongjiang wrote:
> > When I ran xfstest/073 case, the remount process was blocked to wait
> > transactions to be zero. I found there was a io error happened, and the
> > setfilesize transaction was not released properly. We should add the
> > changes to cancel the io error in this case.
> > 
> 
> Thanks for the patch. Was the io error by chance or part of the test? I
> ask because it would be good to have test coverage for this if we don't
> currently.
> 
> > Reproduction steps:
> > 1. dd if=/dev/zero of=xfs1.img bs=1M count=2048
> > 2. mkfs.xfs xfs1.img
> > 3. losetup -f ./xfs1.img /dev/loop0
> > 4. mount -t xfs /dev/loop0 /home/test_dir/
> > 5. mkdir /home/test_dir/test
> > 6. mkfs.xfs -dfile,name=image,size=2g
> > 7. mount -t xfs -o loop image /home/test_dir/test
> > 8. cp a file bigger than 2g to /home/test_dir/test
> > 9. mount -t xfs -o remount,ro /home/test_dir/test
> > 
> > Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
> > ---
> >  fs/xfs/xfs_aops.c | 15 ++++++++++++++-
> >  1 file changed, 14 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > index 50ab287..fab55da 100644
> > --- a/fs/xfs/xfs_aops.c
> > +++ b/fs/xfs/xfs_aops.c
> > @@ -212,8 +212,21 @@ xfs_end_io(
> >  		ioend->io_error = -EIO;
> >  		goto done;
> >  	}
> > -	if (ioend->io_error)
> > +	if (ioend->io_error) {
> > +		/*
> > +		 * We should cancel the setfilesize transation when io error
> > +		 * happen.
> > +		 */
> > +		if (ioend->io_append_trans) {
> > +			current_set_flags_nested(&ioend->io_append_trans->t_pflags,
> > +								PF_FSTRANS);
> > +			rwsem_acquire_read(&VFS_I(XFS_I(ioend->io_inode))->i_sb
> > +				->s_writers.lock_map[SB_FREEZE_FS-1], 0, 1, _THIS_IP_);
> > +			xfs_trans_cancel(ioend->io_append_trans);			
> 
> Trailing whitespace on the line above.
> 
> That aside, I wonder if it would be cleaner to put this stuff in a
> helper similar to xfs_setfilesize_ioend(). In fact, we could probably
> just update xfs_setfilesize_ioend() to check ioend->io_error after
> fixing up the task flags and whatnot and cancel the transaction instead
> of calling xfs_setfilesize(). Then, call it here also and update the new
> comment to point out that it cancels the transaction on error. Thoughts?

Agreed, I made this modification on commit. See below.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

cancel the setfilesize transation when io error happen

From: Zhaohongjiang <zhaohongjiang@huawei.com>

When I ran xfstest/073 case, the remount process was blocked to wait
transactions to be zero. I found there was a io error happened, and the
setfilesize transaction was not released properly. We should add the
changes to cancel the io error in this case.

Reproduction steps:
1. dd if=/dev/zero of=xfs1.img bs=1M count=2048
2. mkfs.xfs xfs1.img
3. losetup -f ./xfs1.img /dev/loop0
4. mount -t xfs /dev/loop0 /home/test_dir/
5. mkdir /home/test_dir/test
6. mkfs.xfs -dfile,name=image,size=2g
7. mount -t xfs -o loop image /home/test_dir/test
8. cp a file bigger than 2g to /home/test_dir/test
9. mount -t xfs -o remount,ro /home/test_dir/test

[ dchinner: moved io error detection to xfs_setfilesize_ioend() after
  transaction context restoration. ]

Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_aops.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index aa9b441..c1c87f9 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -172,6 +172,12 @@ xfs_setfilesize_ioend(
 	current_set_flags_nested(&tp->t_pflags, PF_FSTRANS);
 	__sb_writers_acquired(VFS_I(ip)->i_sb, SB_FREEZE_FS);
 
+	/* we abort the update if there was an IO error */
+	if (ioend->io_error) {
+		xfs_trans_cancel(tp);
+		return ioend->io_error;
+	}
+
 	return xfs_setfilesize(ip, tp, ioend->io_offset, ioend->io_size);
 }
 
@@ -212,14 +218,17 @@ xfs_end_io(
 		ioend->io_error = -EIO;
 		goto done;
 	}
-	if (ioend->io_error)
-		goto done;
 
 	/*
 	 * For unwritten extents we need to issue transactions to convert a
 	 * range to normal written extens after the data I/O has finished.
+	 * Detecting and handling completion IO errors is done individually
+	 * for each case as different cleanup operations need to be performed
+	 * on error.
 	 */
 	if (ioend->io_type == XFS_IO_UNWRITTEN) {
+		if (ioend->io_error)
+			goto done;
 		error = xfs_iomap_write_unwritten(ip, ioend->io_offset,
 						  ioend->io_size);
 	} else if (ioend->io_append_trans) {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
