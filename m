Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E3BCB7F55
	for <xfs@oss.sgi.com>; Wed, 25 Feb 2015 09:23:41 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A4D228F80CE
	for <xfs@oss.sgi.com>; Wed, 25 Feb 2015 07:23:41 -0800 (PST)
Received: from mail-pa0-f54.google.com (mail-pa0-f54.google.com
	[209.85.220.54]) by cuda.sgi.com with ESMTP id BFGLWnnImYCyvuFJ
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 25 Feb 2015 07:23:39 -0800 (PST)
Received: by paceu11 with SMTP id eu11so5912606pac.10
	for <xfs@oss.sgi.com>; Wed, 25 Feb 2015 07:23:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150216234838.GC4251@dastard>
References: <CALJmpHP+PwdV1n8VLusxqz0Wb=1PLL52frEMBn8+4h0v5+7Ssg@mail.gmail.com>
	<20150216234838.GC4251@dastard>
Date: Wed, 25 Feb 2015 20:53:39 +0530
Message-ID: <CALJmpHOZe44t5Mimv213vrQV60Jp6FGpAYpT36bmawKZina56g@mail.gmail.com>
Subject: Re: [RFD] : Allowing xfs_fsr to defragment portions of a file
From: Dhruvesh Rathore <adrscube@gmail.com>
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
To: xfs@oss.sgi.com, Dave Chinner <david@fromorbit.com>

On Tue, Feb 17, 2015 at 5:18 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Sun, Feb 15, 2015 at 08:08:46PM +0530, Dhruvesh Rathore wrote:

>> A new function will have to hence focus on swapping the existing
>> extents from the
>> fragmented file. For this a new_swap_extent() function will be needed,
>> which will take arguments
>> as the current extent and the location(in free space) where it needs
>> to be swapped to.
>
> You can't swap an in use extent with a free space location. You need
> to preallocate space in a temporary file, copy the data across to
> it, and then swap the extent ranges between the two files.
>
>> For the above functionality Dave suggested that we have a look at
>> EXT4_IOC_MOVE_EXT
>> and its usage.
>
> The extent swap between two files is exactly what that ioctl does.
> Look at the API, especially the struct move_extent that defines the
> information passed to the kernel to perform the extent swap
> operation. The XFS APi will be similar.
>

Over the past few days we have been going over the XFS API for
EXT4_IOC_MOVE_EXT available in misc/e4defrag.c, to lay down the
groundwork of the required XFS API.

-----

These are a few things that we felt do not be changed in the new API:

1) The original file will be opened in fsrfile() in xfs_fsr.c, similar to the
original file being opened in file_defrag() in e4defrag.c

2) The check for sufficient freespace done in fsrfile_common() in
xfs_fsr.c achieves the same objective as the check_freesize() in
e4defrag.c

-----

On the same lines, we have identified the following additions
that will be needed in the XFS API for fsr/xfs_fsr.c

1) The read_fd_bmap() function in xfs_fsr.c which gets the block map
of range of original file (map) and the defragmented file (outmap), will
need to be added to when we are performing partial defragmentation.

A function get_file_extents() is called in e4defrag.c twice, which populates
a struct fiemap, struct fiemap_extent and struct fiemap_extent_list
for both original file and donor file (temp file).

The operation of this function will need to be added in xfs_fsr.c as the
EXT4_IOC_MOVE_EXT ioctl primarily uses these fiemap structures.
We will need both the fiemap structures and the existing part of read_fd_bmap( )
in this new XFS API.


2) The temp file getting created in xfs_fsr.c, will be made similar to
the donor file
of e4defrag.c.
We were a bit unsure about the function of join_extents() in
e4defrag.c, which finds a
continuous region (extents group), and how it will fit in the XFS API.
Is it similar to the process of preallocating extents[toff, tlen] in temp file ?


3) Now instead of copying data from [orig, off, len] to [temp, toff,
tlen] and then calling
XFS_IOC_SWPEXT, we will need to simulate the ioctl EXT4_IOC_MOVE_EXT.

In call_defrag( ) in e4defrag.c, the struct fiemap_extent_list
structure, which is basically
a link list of extent information is used.
In our XFS API we will similarly use this structure in a loop and call
the IOCTL for
each of the extents (off donor file) which need to be filled by
swapping data blocks.

In this loop the fields orig_start, donor_start, len and moved_len of
struct move_extent
will be populated from the fiemap_extent_list structure before each ioctl call.

-----

Before all of the above we will need to select the extents that can be
defragmented
i.e the best possible choice, and then mark them.
For this we decided to create another data structure - an array
(user_array[ ]), which
will store extent size information (blocks).
For instance say a file has 5 extents then
user_array[0] : save size of extent 1
user_array[1] : save size of extents 1, 2
user_array[2] : save size of extents 1, 2, 3
user_array[3] : save size of extents 1, 2, 3, 4
user_array[4] : save size of extents 1, 2 3, 4, 5
This way we could perform the selection efficiently, by necessary
comparison with
available space.

----

We would love to hear your comments or directions on the above points. After
confirmation from you, we will finish creating the XFS API on the above lines.

> The process in fsr is this:
>
>         1. bulkstat original file inode [bstat] for change
>            detection whilst doing copying operation.
>         2. get block map of range [off, len] of orignal file
>            that needs to be swapped
>         3. create temp file
>         4. preallocate extent [toff, tlen] in temp file
>         5. check the number of extents in [toff, tlen] is less than
>            the number of extents in [off, len] in the original file.
>            If it's not an improvement, abort.
>         6. copy data from [orig, off, len] to [temp, toff, tlen]
>         7. ioctl(orig_fd, XFS_IOC_SWAPEXT_RANGE, [bstat, off, len, temp, toff])
>
> The kernel side of the ioctl is somewhat more complex, and we'll get
> to that once the fsr infrastructure is ready to use it.
>
> Cheers,
>
> Dave.


Regards,
A-DRS

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
