Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 27D407F57
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 17:14:19 -0600 (CST)
Date: Tue, 3 Dec 2013 17:14:15 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: reinstate the iolock in xfs_readdir
Message-ID: <20131203231415.GS1935@sgi.com>
References: <20131203212951.GP1935@sgi.com>
 <20131203225520.GZ10988@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131203225520.GZ10988@dastard>
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

On Wed, Dec 04, 2013 at 09:55:20AM +1100, Dave Chinner wrote:
> On Tue, Dec 03, 2013 at 03:29:51PM -0600, Ben Myers wrote:
> > Although it was removed in commit 051e7cd44ab8, ilock needs to be taken in
> > xfs_readdir because we might have to read the extent list in from disk.  This
> > keeps other threads from reading from or writing to the extent list while it is
> > being read in and is still in a transitional state.
> >
> > This has been associated with "Access to block zero" messages on directories
> > with large numbers of extents resulting from excessive filesytem fragmentation,
> > as well as extent list corruption.  Unfortunately no test case at this point.
> 
> That commit was from 2007, so this is not a result of a recent
> change. As it is, access to directories is completely
> serialised by the VFS i_mutex. We don't need the iolock to read in
> the extent list for a directory, because by the time we get to
> readdir it is already guaranteed to be read in by this code:

Gah.  Typo in my subject line.  That's the ilock, not the iolock.  Whenever we
touch the extent list we want to have the ilock at some level.

> STATIC int
> xfs_dir_open(
>         struct inode    *inode,
>         struct file     *file)
> {
>         struct xfs_inode *ip = XFS_I(inode);
>         int             mode;
>         int             error;
> 
>         error = xfs_file_open(inode, file);
>         if (error)
>                 return error;
> 
>         /*
>          * If there are any blocks, read-ahead block 0 as we're almost
>          * certain to have the next operation be a read there.
>          */
>         mode = xfs_ilock_map_shared(ip);
>         if (ip->i_d.di_nextents > 0)
>                 xfs_dir3_data_readahead(NULL, ip, 0, -1);
>         xfs_iunlock(ip, mode);
>         return 0;
> }
> 
> Which means that for a directory in block/leaf/node form the open of
> it prior to the first readdir() call will read the extent tree into
> memory and it will be pinned in memory for at least the life of the
> file descriptor that is open on the directory.

That readahead _may_ read some of the blocks from disk but it doesn't copy them
into the incore extent list.  That's what we need to protect from other readers
who don't take the i_mutex.  Will see if I can find an example.

> If the directory is not in block form at open time, then the
> first modification that takes it to block form will correctly lock
> and initialise the extent tree, and concurrent readers will block on
> the i_mutex at the VFS, not on the XFS iolock.
> 
> Now, if something is accessing the directory without going through
> the VFS, there might be an issue, but all read accesses are via a
> file descriptor of some kind and so should always have the extent
> list initialised and read in correctly before reads occur due to the
> code in xfs_dir_open() and serialisation via the i_mutex at the VFS
> level.
> 
> So I don't see why holding the iolock during readdir is necessary,
> nor how not holding it could lead to corrupt extent trees being seen
> during directory operations. I need more information to understand
> the issue being seen....

Sorry for the confusion.  bbl.  ;)

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
