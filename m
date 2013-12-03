Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D54477F59
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 16:55:25 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BA68B8F804B
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 14:55:25 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	LfGImQCrFXMa56Rn for <xfs@oss.sgi.com>;
	Tue, 03 Dec 2013 14:55:23 -0800 (PST)
Date: Wed, 4 Dec 2013 09:55:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: reinstate the iolock in xfs_readdir
Message-ID: <20131203225520.GZ10988@dastard>
References: <20131203212951.GP1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131203212951.GP1935@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Dec 03, 2013 at 03:29:51PM -0600, Ben Myers wrote:
> Although it was removed in commit 051e7cd44ab8, ilock needs to be taken in
> xfs_readdir because we might have to read the extent list in from disk.  This
> keeps other threads from reading from or writing to the extent list while it is
> being read in and is still in a transitional state.
>
> This has been associated with "Access to block zero" messages on directories
> with large numbers of extents resulting from excessive filesytem fragmentation,
> as well as extent list corruption.  Unfortunately no test case at this point.

That commit was from 2007, so this is not a result of a recent
change. As it is, access to directories is completely
serialised by the VFS i_mutex. We don't need the iolock to read in
the extent list for a directory, because by the time we get to
readdir it is already guaranteed to be read in by this code:

STATIC int
xfs_dir_open(
        struct inode    *inode,
        struct file     *file)
{
        struct xfs_inode *ip = XFS_I(inode);
        int             mode;
        int             error;

        error = xfs_file_open(inode, file);
        if (error)
                return error;

        /*
         * If there are any blocks, read-ahead block 0 as we're almost
         * certain to have the next operation be a read there.
         */
        mode = xfs_ilock_map_shared(ip);
        if (ip->i_d.di_nextents > 0)
                xfs_dir3_data_readahead(NULL, ip, 0, -1);
        xfs_iunlock(ip, mode);
        return 0;
}

Which means that for a directory in block/leaf/node form the open of
it prior to the first readdir() call will read the extent tree into
memory and it will be pinned in memory for at least the life of the
file descriptor that is open on the directory.

If the directory is not in block form at open time, then the
first modification that takes it to block form will correctly lock
and initialise the extent tree, and concurrent readers will block on
the i_mutex at the VFS, not on the XFS iolock.

Now, if something is accessing the directory without going through
the VFS, there might be an issue, but all read accesses are via a
file descriptor of some kind and so should always have the extent
list initialised and read in correctly before reads occur due to the
code in xfs_dir_open() and serialisation via the i_mutex at the VFS
level.

So I don't see why holding the iolock during readdir is necessary,
nor how not holding it could lead to corrupt extent trees being seen
during directory operations. I need more information to understand
the issue being seen....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
