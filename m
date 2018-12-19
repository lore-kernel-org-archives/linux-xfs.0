Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48820 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727079AbeLSTh0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Dec 2018 14:37:26 -0500
Date: Wed, 19 Dec 2018 20:37:24 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 11/11] xfs: introduce an always_cow mode
Message-ID: <20181219193724.GD28624@lst.de>
References: <20181203222503.30649-1-hch@lst.de> <20181203222503.30649-12-hch@lst.de> <20181218232437.GS27208@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181218232437.GS27208@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Tue, Dec 18, 2018 at 03:24:37PM -0800, Darrick J. Wong wrote:
> On Mon, Dec 03, 2018 at 05:25:03PM -0500, Christoph Hellwig wrote:
> > Add a mode where XFS never overwrites existing blocks in place.  This
> > is to aid debugging our COW code, and also put infatructure in place
> > for things like possible future support for zoned block devices, which
> > can't support overwrites.
> > 
> > This mode is enabled globally by doing a:
> > 
> >     echo 1 > /sys/fs/xfs/debug/always_cow
> > 
> > Note that the parameter is global to allow running all tests in xfstests
> > easily in this mode, which would not easily be possible with a per-fs
> > sysfs file.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_aops.c    |  2 +-
> >  fs/xfs/xfs_file.c    | 11 ++++++++++-
> >  fs/xfs/xfs_iomap.c   | 28 ++++++++++++++++++----------
> >  fs/xfs/xfs_reflink.c | 28 ++++++++++++++++++++++++----
> >  fs/xfs/xfs_reflink.h | 13 +++++++++++++
> >  fs/xfs/xfs_super.c   | 13 +++++++++----
> >  fs/xfs/xfs_sysctl.h  |  1 +
> >  fs/xfs/xfs_sysfs.c   | 24 ++++++++++++++++++++++++
> >  8 files changed, 100 insertions(+), 20 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > index 7d95a84064e7..a900924f16e1 100644
> > --- a/fs/xfs/xfs_aops.c
> > +++ b/fs/xfs/xfs_aops.c
> > @@ -986,7 +986,7 @@ xfs_vm_bmap(
> >  	 * Since we don't pass back blockdev info, we can't return bmap
> >  	 * information for rt files either.
> >  	 */
> > -	if (xfs_is_reflink_inode(ip) || XFS_IS_REALTIME_INODE(ip))
> > +	if (xfs_is_cow_inode(ip) || XFS_IS_REALTIME_INODE(ip))
> >  		return 0;
> >  	return iomap_bmap(mapping, block, &xfs_iomap_ops);
> >  }
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index e47425071e65..8d2be043590a 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -507,7 +507,7 @@ xfs_file_dio_aio_write(
> >  		 * We can't properly handle unaligned direct I/O to reflink
> >  		 * files yet, as we can't unshare a partial block.
> >  		 */
> > -		if (xfs_is_reflink_inode(ip)) {
> > +		if (xfs_is_cow_inode(ip)) {
> >  			trace_xfs_reflink_bounce_dio_write(ip, iocb->ki_pos, count);
> >  			return -EREMCHG;
> >  		}
> > @@ -806,6 +806,15 @@ xfs_file_fallocate(
> >  		return -EOPNOTSUPP;
> >  
> >  	xfs_ilock(ip, iolock);
> > +	/*
> > +	 * If always_cow mode we can't use preallocation and thus should not
> > +	 * allow creating them.
> > +	 */
> > +	if (xfs_is_always_cow_inode(ip) && (mode & ~FALLOC_FL_KEEP_SIZE) == 0) {
> > +		error = -EOPNOTSUPP;
> > +		goto out_unlock;
> 
> I think this screws up both UNSHARE and ZERO_RANGE here -- if the first
> mode is set, we'll cow the shared extents, but we'll also fill holes
> with unwritten extents, which the comment implies isn't allowed.  In the
> second set we'll punch the range but refill it with unwritten extents
> that we'll never actually overwrite.

True.

> 
> Granted, I'm still rather fuzzy on what exactly is supposed to happen
> with preallocating fallocate when all writes require an allocation to
> succeed?  btrfs fills holes with unwritten extents which the next write
> will overwrite, but non-holes cow like normal.  That only makes sense if
> you assume people only use fallocate to preallocate holes.  Maybe we
> don't want to follow that route.  It's probably simpler not to support
> creation of unwritten extents for always_cow files, in which case you'll
> have to neuter UNSHARE too.
> 
> As for ZERO_RANGE, I think it's sufficient to punch the range, since we
> COW even the unwritten extents (which makes allocating them pointless),
> right?

Agreed.

> What's the real goal here?  I assume you're targeting both O_ATOMIC in
> addition to being able to use SMR drives as realtime devices, right?  It
> would help to have a better idea of where we're going here before adding
> anything user visible, even if it's just a debug knob for now.

My SMR plan (and is just that at the moment except for prep and bits
of prototype code) is to allow SMR drives instead of the realtime 
subvolume indeed.  It isn't really the rt subvolume anymore as we don't
use the RT allocator, but we need the bit to differenciate the metadata
device and the data going to SMR drives.

> >  	"reflink not compatible with realtime device!");
> > -		error = -EINVAL;
> > -		goto out_filestream_unmount;
> > +			error = -EINVAL;
> > +			goto out_filestream_unmount;
> > +		}
> > +
> > +		if (xfs_globals.always_cow)
> > +			xfs_info(mp, "using DEBUG-only always_cow mode.");
> 
> How does xfs handle the situation where always_cow mode comes on after
> you've already opened a file and begun writing to it?  I assume we
> allocate a new cow fork for files that need it and all writes after the
> switch flips will be COW?

Yes.  I guess in some ways it would be nicer to just sample the value
once at mount time - that could avoid having to deal with unexpected
corner cases in the future.
