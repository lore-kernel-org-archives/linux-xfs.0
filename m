Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D81167F50
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2015 17:48:47 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 55192AC004
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2015 15:48:47 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	eRm0YI6GHMXoRHex for <xfs@oss.sgi.com>;
	Mon, 16 Feb 2015 15:48:40 -0800 (PST)
Date: Tue, 17 Feb 2015 10:48:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFD] : Allowing xfs_fsr to defragment portions of a file
Message-ID: <20150216234838.GC4251@dastard>
References: <CALJmpHP+PwdV1n8VLusxqz0Wb=1PLL52frEMBn8+4h0v5+7Ssg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CALJmpHP+PwdV1n8VLusxqz0Wb=1PLL52frEMBn8+4h0v5+7Ssg@mail.gmail.com>
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
To: Dhruvesh Rathore <adrscube@gmail.com>
Cc: xfs@oss.sgi.com

On Sun, Feb 15, 2015 at 08:08:46PM +0530, Dhruvesh Rathore wrote:
> Hi,
> 
> The xfs_fsr utility in its current state does not support defragmentation of
> parts of file. Either the entire file is defragmented, or if free space is not
> available then the operation is not performed.
> We would like to enhance the utility allowing it to defragment parts
> of the file, ins such a condition.
> ---------------------------------------------------------------------------------------------------------------
> 
> Our initial task was to understand how xfs_fsr currently defragments the file:
> 
> 1) In /fsr/xfs_fsr.c from main() the control is passed to fsrfile().
> In fsrfile(), we
> open the original file and collect bstat information. A call is then made to
> fsrfile_common()
> 
> 2) In fsrfile_common() we check if sufficient free space is available to
> defragment the file, and if not then we exit. If free space is available, then a
> call is made to packfile()
> 
> 3) In packfile(), read_fd_bmap() function provides us with the current number of
> extents used by the file (cur_nextents) and the ideal number of extents needed
> to save the file (nextents). In function read_fd_bmap() the the
> outmap[ ] structure
> is also populated.
> 
> 4) packfile() will initially allocate new extents (nextents) to the
> temporary file and
> then copy(swap) extents form the existing file. We then fchown() the new temp
> file and space occupied by the prev fragmented copy is then freed.
> 
> ---------------------------------------------------------------------------------------------------------------
> 
> Our understanding to the approach of defragmenting portions of a file
> is as follows:
> 
> 1) In fsrfile_common(), a new function will be called when the code
> determines that
> there is insufficient free space to defragment the entire file.
> 
> 2) The new function performs the following tasks:
> 
> ---> Call read_fd_bmap() to get cur_nextents and nextents(ideal). Using
> nextents we will
> then have to determine how many extents can be defragmented against
> the free space
> available.
> 
> ---> Creating a temp file will not be feasible as it will create a
> problem when we want to
> change owners.

fsr runs as root. There is no issue with changing owners, though
that should not be necessary with extent swap operations between
two files. The tempfile creation is the same as fsr is currently
already doing for full file defragmentation, so you shouldn't need
to be doing anything different here.

> ---> The function will have to hence focus on swapping the existing
> extents from the
> fragmented file. For this a swap_extent() function will be needed,
> which will take arguments
> as the current extent and the location(in free space) where it needs
> to be swapped to.

You can't swap an in use extent with a free space location. You need
to preallocate space in a temporary file, copy the data across to
it, and then swap the extent ranges between the two files.

> For the above functionality Dave suggested that we have a look at
> EXT4_IOC_MOVE_EXT
> and its usage.

The extent swap between two files is exactly what that ioctl does.
Look at the API, especially the struct move_extent that defines the
information passed to the kernel to perform the extent swap
operation. The XFS APi will be similar.

> We are however unsure of how to compress the extents which have been chosen for
> defragmentation and keep the other extents untouched. We are also in
> doubt about how to
> proceed without creating a temp file for defragmentation.

The process in fsr is this:

	1. bulkstat original file inode [bstat] for change
	   detection whilst doing copying operation.
	2. get block map of range [off, len] of orignal file
	   that needs to be swapped
	3. create temp file
	4. preallocate extent [toff, tlen] in temp file
	5. check the number of extents in [toff, tlen] is less than
	   the number of extents in [off, len] in the original file.
	   If it's not an improvement, abort.
	6. copy data from [orig, off, len] to [temp, toff, tlen]
	7. ioctl(orig_fd, XFS_IOC_SWAPEXT_RANGE, [bstat, off, len, temp, toff])

The kernel side of the ioctl is somewhat more complex, and we'll get
to that once the fsr infrastructure is ready to use it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
