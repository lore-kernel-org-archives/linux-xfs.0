Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0D61729DF5
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 16:43:57 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EE8C48F8064
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 14:43:53 -0800 (PST)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20]) by
	cuda.sgi.com with ESMTP id u04Ybtxq1t0oItc4 for
	<xfs@oss.sgi.com>; Wed, 10 Feb 2016 14:43:52 -0800 (PST)
Date: Wed, 10 Feb 2016 15:43:40 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2 2/2] dax: move writeback calls into the filesystems
Message-ID: <20160210224340.GA30938@linux.intel.com>
References: <1455137336-28720-1-git-send-email-ross.zwisler@linux.intel.com>
	<1455137336-28720-3-git-send-email-ross.zwisler@linux.intel.com>
	<20160210220312.GP14668@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160210220312.GP14668@dastard>
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
Cc: Theodore Ts'o <tytso@mit.edu>, linux-nvdimm@lists.01.org, Jan Kara <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On Thu, Feb 11, 2016 at 09:03:12AM +1100, Dave Chinner wrote:
> On Wed, Feb 10, 2016 at 01:48:56PM -0700, Ross Zwisler wrote:
> > Previously calls to dax_writeback_mapping_range() for all DAX filesystems
> > (ext2, ext4 & xfs) were centralized in filemap_write_and_wait_range().
> > dax_writeback_mapping_range() needs a struct block_device, and it used to
> > get that from inode->i_sb->s_bdev.  This is correct for normal inodes
> > mounted on ext2, ext4 and XFS filesystems, but is incorrect for DAX raw
> > block devices and for XFS real-time files.
> > 
> > Instead, call dax_writeback_mapping_range() directly from the filesystem
> > ->writepages function so that it can supply us with a valid block
> > device. This also fixes DAX code to properly flush caches in response to
> > sync(2).
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/block_dev.c      | 16 +++++++++++++++-
> >  fs/dax.c            | 13 ++++++++-----
> >  fs/ext2/inode.c     | 11 +++++++++++
> >  fs/ext4/inode.c     |  7 +++++++
> >  fs/xfs/xfs_aops.c   |  9 +++++++++
> >  include/linux/dax.h |  6 ++++--
> >  mm/filemap.c        | 12 ++++--------
> >  7 files changed, 58 insertions(+), 16 deletions(-)
> > 
> > diff --git a/fs/block_dev.c b/fs/block_dev.c
> > index 39b3a17..fc01e43 100644
> > --- a/fs/block_dev.c
> > +++ b/fs/block_dev.c
> > @@ -1693,13 +1693,27 @@ static int blkdev_releasepage(struct page *page, gfp_t wait)
> >  	return try_to_free_buffers(page);
> >  }
> >  
> > +static int blkdev_writepages(struct address_space *mapping,
> > +			     struct writeback_control *wbc)
> > +{
> > +	if (dax_mapping(mapping)) {
> > +		struct block_device *bdev = I_BDEV(mapping->host);
> > +		int error;
> > +
> > +		error = dax_writeback_mapping_range(mapping, bdev, wbc);
> > +		if (error)
> > +			return error;
> > +	}
> > +	return generic_writepages(mapping, wbc);
> > +}
> 
> Can you remind of the reason for calling generic_writepages() on DAX
> enabled address spaces?

Sure.  The initial version of this patch didn't do this, and during testing I
hit a bunch of xfstests failures.  In ext2 at least I believe these were
happening because we were skipping the call into generic_writepages() for DAX
inodes. Without a lot of data to back this up, my guess is that this is due
to metadata inodes or something being marked as DAX (so dax_mapping(mapping)
returns true), but having dirty page cache pages that need to be written back
as part of the writeback.

Changing this so we always call generic_writepages() even in the DAX case
solved the xfstest failures. 

If this sounds incorrect, please let me know and I'll go and gather more data.

- Ross

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
