Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BDD6F7FD5
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 19:57:54 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 49739AC001
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 17:57:54 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	65KGiHctchCpEbpt for <xfs@oss.sgi.com>;
	Thu, 07 Mar 2013 17:57:52 -0800 (PST)
Date: Fri, 8 Mar 2013 12:57:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [dm-devel] [BUG] pvmove corrupting XFS filesystems (was Re:
	[BUG] Internal error xfs_dir2_data_reada_verify)
Message-ID: <20130308015723.GA23616@dastard>
References: <87d2vnc34r.fsf@fftw.org> <20130226044039.GM5551@dastard>
	<20130227010414.GD1514@agk.fab.redhat.com>
	<20130227014900.GY5551@dastard> <87y5eah4xz.fsf@fftw.org>
	<87k3pjs908.fsf@fftw.org> <20130307223140.GU23616@dastard>
	<87hakmpxac.fsf@fftw.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87hakmpxac.fsf@fftw.org>
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
To: Matteo Frigo <athena@fftw.org>
Cc: dm-devel@redhat.com, xfs@oss.sgi.com

On Thu, Mar 07, 2013 at 07:09:31PM -0500, Matteo Frigo wrote:
> Dave Chinner <david@fromorbit.com> writes:
> 
> > You need the XFS patch I posted so that readahead buffer
> > verification is avoided in the case of an error being returned from
> > the readahead.
> 
> I apologize if I was not clear in my previous post.  I mean to say that
> returning -EIO from dm, even in conjunction with your patch, is not
> sufficient to fix the problem.
> 
> Specifically, I repeated the experiment with v3.8.2 patched as discussed
> below, running my original script (repeated here for completeness):
> 
>    pvcreate /dev/vd[bc]
>    vgcreate test /dev/vd[bc]
>    lvcreate -L 8G -n vol test /dev/vdb
>    mkfs.xfs -f /dev/mapper/test-vol
>    mount -o noatime /dev/mapper/test-vol /mnt
>    cd /mnt
>    git clone ~/linux-stable
>    cd /
>    umount /mnt
> 
>    mount -o noatime /dev/mapper/test-vol /mnt
>    pvmove -b /dev/vdb /dev/vdc
>    sleep 2
>    rm -rf /mnt/linux-stable
> 
> I obtained a string of errors that starts with this:
> 
>   [  166.596574] XFS (dm-1): metadata I/O error: block 0x805060 ("xfs_trans_read_buf_map") error 5 numblks 8
>   [  166.599556] XFS (dm-1): metadata I/O error: block 0x805060 ("xfs_trans_read_buf_map") error 5 numblks 8
>   [  166.604845] XFS (dm-1): metadata I/O error: block 0x5285b8 ("xfs_trans_read_buf_map") error 5 numblks 8
>   [  166.607894] XFS (dm-1): metadata I/O error: block 0x5285b8 ("xfs_trans_read_buf_map") error 5 numblks 8
>   [  166.614242] XFS (dm-1): metadata I/O error: block 0x54f2b0 ("xfs_trans_read_buf_map") error 5 numblks 8
>   [  166.617307] XFS (dm-1): metadata I/O error: block 0x54f2b0 ("xfs_trans_read_buf_map") error 5 numblks 8
>   [  166.651373] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
>   [  166.653517] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
>   [  166.655545] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
>   [  166.657614] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
>   [  166.659685] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
>   [  166.661731] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
>   [  166.663761] XFS (dm-1): Corruption detected. Unmount and run xfs_repair

Add the the patch below. If you still see errors, then they are real
IO errors from the block device.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: ensure we capture IO errors correctly

From: Dave Chinner <dchinner@redhat.com>

Failed buffer readahead can leave the buffer in the cache marked
with an error. Most callers that then issue a subsequent read on the
buffer do not zero the b_error field out, and so we may incorectly
detect an error during IO completion due to the stale error value
left on the buffer.

Avoid this problem by zeroing the error before IO submission. This
ensures that the only IO errors that are detected those captured
from are those captured from bio submission or completion.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 50eb603..82b70bd 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1336,6 +1336,12 @@ _xfs_buf_ioapply(
 	int		size;
 	int		i;
 
+	/*
+	 * Make sure we capture only current IO errors rather than stale errors
+	 * left over from previous use of the buffer (e.g. failed readahead).
+	 */
+	bp->b_error = 0;
+
 	if (bp->b_flags & XBF_WRITE) {
 		if (bp->b_flags & XBF_SYNCIO)
 			rw = WRITE_SYNC;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
