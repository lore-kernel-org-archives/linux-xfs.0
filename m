Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 635E77F3F
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 18:10:45 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D754FAC003
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 16:10:41 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	qz2O2IJSJGC5itaM for <xfs@oss.sgi.com>;
	Tue, 03 Dec 2013 16:10:39 -0800 (PST)
Date: Wed, 4 Dec 2013 11:10:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: reinstate the iolock in xfs_readdir
Message-ID: <20131204001030.GD10988@dastard>
References: <20131203212951.GP1935@sgi.com> <20131203225520.GZ10988@dastard>
	<20131203231415.GS1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131203231415.GS1935@sgi.com>
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

On Tue, Dec 03, 2013 at 05:14:15PM -0600, Ben Myers wrote:
> On Wed, Dec 04, 2013 at 09:55:20AM +1100, Dave Chinner wrote:
> > On Tue, Dec 03, 2013 at 03:29:51PM -0600, Ben Myers wrote:
> > > Although it was removed in commit 051e7cd44ab8, ilock needs to be taken in
> > > xfs_readdir because we might have to read the extent list in from disk.  This
> > > keeps other threads from reading from or writing to the extent list while it is
> > > being read in and is still in a transitional state.
> > >
> > > This has been associated with "Access to block zero" messages on directories
> > > with large numbers of extents resulting from excessive filesytem fragmentation,
> > > as well as extent list corruption.  Unfortunately no test case at this point.
> > 
> > That commit was from 2007, so this is not a result of a recent
> > change. As it is, access to directories is completely
> > serialised by the VFS i_mutex. We don't need the iolock to read in
> > the extent list for a directory, because by the time we get to
> > readdir it is already guaranteed to be read in by this code:
> 
> Gah.  Typo in my subject line.  That's the ilock, not the iolock.  Whenever we
> touch the extent list we want to have the ilock at some level.

I just copied what you said. ;)

> > STATIC int
> > xfs_dir_open(
> >         struct inode    *inode,
> >         struct file     *file)
> > {
> >         struct xfs_inode *ip = XFS_I(inode);
> >         int             mode;
> >         int             error;
> > 
> >         error = xfs_file_open(inode, file);
> >         if (error)
> >                 return error;
> > 
> >         /*
> >          * If there are any blocks, read-ahead block 0 as we're almost
> >          * certain to have the next operation be a read there.
> >          */
> >         mode = xfs_ilock_map_shared(ip);
> >         if (ip->i_d.di_nextents > 0)
> >                 xfs_dir3_data_readahead(NULL, ip, 0, -1);
> >         xfs_iunlock(ip, mode);
> >         return 0;
> > }
> > 
> > Which means that for a directory in block/leaf/node form the open of
> > it prior to the first readdir() call will read the extent tree into
> > memory and it will be pinned in memory for at least the life of the
> > file descriptor that is open on the directory.
> 
> That readahead _may_ read some of the blocks from disk but it doesn't copy them
> into the incore extent list.

Readahead reads data blocks based on their file offset. How do we
find the data block to read from the file offset? It looks it up in
the extent list via xfs_bmapi_read(), which reads the entire extent
map from disk and populates the incore extent tree in it's entirity
if it is not present.  i.e.

xfs_dir3_data_readahead
  xfs_da_reada_buf
    xfs_dabuf_map
      if (mappedbno == -1)
	xfs_bmapi_read
	  if (!XFS_IFEXTENTS)
	    xfs_iread_extents
	      set XFS_IFEXTENTS
	      xfs_bmap_read_extents
		<reads extent tree from disk>
		<populate incore extent list>
	  <map offset 0 to filesystem block>
      mappedbno = filesystem block from xfs_bmapi_read
    xfs_buf_reada(mappedbno)
      (reads directory data from disk)

Hence xfs_dir_open() has the correct locking and ensures that we
don't need to use the extent list lock for any read operations
through the VFS because all read operations are serialised against
modifications to the directory the i_mutex at the VFS.

> That's what we need to protect from other readers
> who don't take the i_mutex.  Will see if I can find an example.

The only way I can see there being a problem is if the directory
extent tree is being modified without the directory i_mutex being
held. AFAICT, that can't happen from the VFS, so maybe there's
something that is coming from the ioctl interfaces - the only thing
I can see there is xfs_attrmulti_attr_set() causing a directory
inode data fork to move from extent to btree format as an attribute
fork is added, but that wouldn't cause problems with existing
directories with large extent counts.

Also, nothing in xfstests/xfsprogs uses XFS_IOC_ATTRMULTI_BY_HANDLE
or the libhandle functions that call this ioctl, so it would seem to
me that the only thing that might use this function to set
attributes on files is DMF.....

Hmmm, that makes me wonder about whether this is a CXFS problem,
because it has hooks deep in the XFS code below the VFS. Last time I
looked, the MDS completely bypassed the VFS for directory
modifications driven by clients. That would explain why nobody has
seen this problem on mainline kernels for the best part of 6 years,
and also explain why the ilock is necessary across the readdir
operation to prevent the extent list problems from being seen....

Ben - if this is a DMF or CXFS problem, just say so. Some of us know
an awful lot about how those products work, so there's no point
wasting my time trying to dance around why a change needs to be made
without mentioning those products.

The simple fact is that if we ever want to do concurrent directory
read operations, we have to take the ilock in readdir() to ensure we
can serialise correctly against modifications because the i_mutex
can't be used to do that. So, really, I'm not against the fix you
proposed - I'm just trying to understand why it is necessary right
now....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
