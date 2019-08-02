Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43864 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730492AbfHBNsX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Aug 2019 09:48:23 -0400
Received: by mail-wr1-f66.google.com with SMTP id p13so2700676wru.10
        for <linux-xfs@vger.kernel.org>; Fri, 02 Aug 2019 06:48:20 -0700 (PDT)
Date: Fri, 2 Aug 2019 15:48:17 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 8/9] Use FIEMAP for FIBMAP calls
Message-ID: <20190802134816.usmauocewduggrjt@pegasus.maiolino.io>
References: <20190731141245.7230-1-cmaiolino@redhat.com>
 <20190731141245.7230-9-cmaiolino@redhat.com>
 <20190731232254.GW1561054@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731232254.GW1561054@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, hch@lst.de, adilger@dilger.ca, jaegeuk@kernel.org, miklos@szeredi.hu, rpeterso@redhat.com, linux-xfs@vger.kernel.org

> > -#define EXT4_FIEMAP_FLAGS	(FIEMAP_FLAG_SYNC|FIEMAP_FLAG_XATTR)
> > +#define EXT4_FIEMAP_FLAGS	(FIEMAP_FLAG_SYNC | \
> > +				 FIEMAP_FLAG_XATTR| \
> > +				 FIEMAP_KERNEL_FIBMAP)
> >  
> >  static int ext4_xattr_fiemap(struct inode *inode,
> >  				struct fiemap_extent_info *fieinfo)
> > @@ -5048,6 +5050,9 @@ int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo)
> >  	if (ext4_has_inline_data(inode)) {
> >  		int has_inline = 1;
> >  
> > +		if (fieinfo->fi_flags & FIEMAP_KERNEL_FIBMAP)
> > +			return -EINVAL;
> 
> Wouldn't the inline data case be caught by fiemap_bmap and turned into
> -EINVAL?

Yes, it does, but until ext4_fiemap() returns the extent with the INLINE flag,
it does need to go through the whole fiemap mapping mechanism when we already
know the result... So, instead of letting the ext4_fiemap() map the extent, just
take the shortcut and return -EINVAL directly.

The check in fiemap_bmap() is a 'safe measure' (if it does have other name I
don't know :), but if the filesystem already knows it's gonna fall into an
inline inode, taking the shortcut is better, isn't it?

> > +		return 1;
> > +	return 0;
> > +}
> > +
> > +static int bmap_fiemap(struct inode *inode, sector_t *block)
> > +{
> > +	struct fiemap_extent_info fieinfo = { 0, };
> > +	struct fiemap_extent fextent;
> > +	u64 start = *block << inode->i_blkbits;
> > +	int error = -EINVAL;
> > +
> > +	fextent.fe_logical = 0;
> > +	fextent.fe_physical = 0;
> > +	fieinfo.fi_extents_max = 1;
> > +	fieinfo.fi_extents_mapped = 0;
> > +	fieinfo.fi_cb_data = &fextent;
> > +	fieinfo.fi_start = start;
> > +	fieinfo.fi_len = 1 << inode->i_blkbits;
> > +	fieinfo.fi_cb = fiemap_fill_kernel_extent;
> > +	fieinfo.fi_flags = (FIEMAP_KERNEL_FIBMAP | FIEMAP_FLAG_SYNC);
> > +
> > +	error = inode->i_op->fiemap(inode, &fieinfo);
> > +
> > +	if (error)
> > +		return error;
> > +
> > +	if (fieinfo.fi_flags & (FIEMAP_EXTENT_UNKNOWN |
> > +				FIEMAP_EXTENT_ENCODED |
> > +				FIEMAP_EXTENT_DATA_INLINE |
> > +				FIEMAP_EXTENT_UNWRITTEN |
> > +				FIEMAP_EXTENT_SHARED))
> > +		return -EINVAL;
> > +
> > +	*block = (fextent.fe_physical +
> > +		  (start - fextent.fe_logical)) >> inode->i_blkbits;
> > +
> > +	return error;
> > +}
> > +
> >  /**
> >   *	bmap	- find a block number in a file
> >   *	@inode:  inode owning the block number being requested
> > @@ -1591,10 +1663,15 @@ EXPORT_SYMBOL(iput);
> >   */
> >  int bmap(struct inode *inode, sector_t *block)
> >  {
> > -	if (!inode->i_mapping->a_ops->bmap)
> > +	if (inode->i_op->fiemap)
> > +		return bmap_fiemap(inode, block);
> > +
> > +	if (inode->i_mapping->a_ops->bmap)
> > +		*block = inode->i_mapping->a_ops->bmap(inode->i_mapping,
> > +						       *block);
> > +	else
> >  		return -EINVAL;
> >  
> > -	*block = inode->i_mapping->a_ops->bmap(inode->i_mapping, *block);
> >  	return 0;
> >  }
> >  EXPORT_SYMBOL(bmap);
> > diff --git a/fs/ioctl.c b/fs/ioctl.c
> > index d72696c222de..0759ac6e4c7e 100644
> > --- a/fs/ioctl.c
> > +++ b/fs/ioctl.c
> > @@ -77,11 +77,8 @@ static int ioctl_fibmap(struct file *filp, int __user *p)
> >  	return error;
> >  }
> >  
> > -#define SET_UNKNOWN_FLAGS	(FIEMAP_EXTENT_DELALLOC)
> > -#define SET_NO_UNMOUNTED_IO_FLAGS	(FIEMAP_EXTENT_DATA_ENCRYPTED)
> > -#define SET_NOT_ALIGNED_FLAGS	(FIEMAP_EXTENT_DATA_TAIL|FIEMAP_EXTENT_DATA_INLINE)
> > -int fiemap_fill_user_extent(struct fiemap_extent_info *fieinfo, u64 logical,
> > -			    u64 phys, u64 len, u32 flags)
> > +static int fiemap_fill_user_extent(struct fiemap_extent_info *fieinfo,
> > +			u64 logical, u64 phys, u64 len, u32 flags)
> >  {
> >  	struct fiemap_extent extent;
> >  	struct fiemap_extent __user *dest = fieinfo->fi_cb_data;
> > @@ -89,17 +86,17 @@ int fiemap_fill_user_extent(struct fiemap_extent_info *fieinfo, u64 logical,
> >  	/* only count the extents */
> >  	if (fieinfo->fi_extents_max == 0) {
> >  		fieinfo->fi_extents_mapped++;
> > -		return (flags & FIEMAP_EXTENT_LAST) ? 1 : 0;
> > +		goto out;
> >  	}
> >  
> >  	if (fieinfo->fi_extents_mapped >= fieinfo->fi_extents_max)
> >  		return 1;
> >  
> > -	if (flags & SET_UNKNOWN_FLAGS)
> > +	if (flags & FIEMAP_EXTENT_DELALLOC)
> >  		flags |= FIEMAP_EXTENT_UNKNOWN;
> > -	if (flags & SET_NO_UNMOUNTED_IO_FLAGS)
> > +	if (flags & FIEMAP_EXTENT_DATA_ENCRYPTED)
> >  		flags |= FIEMAP_EXTENT_ENCODED;
> > -	if (flags & SET_NOT_ALIGNED_FLAGS)
> 
> It's too bad that we lose the "not aligned" semantic meaning here.

May you explain a bit better what you mean? We don't lose it, just the define
goes away, the reason I dropped these defines is because the same flags are used
in both functions, fiemap_fill_{user,kernel}_extent(), and I didn't think
defining them on both places (or in fs.h) has any benefit here, so I opted to
remove them.

> 
> > +	if (flags & (FIEMAP_EXTENT_DATA_TAIL | FIEMAP_EXTENT_DATA_INLINE))
> >  		flags |= FIEMAP_EXTENT_NOT_ALIGNED;
> 
> Why doesn't this function just call fiemap_fill_kernel_extent to fill
> out the onstack @extent structure?  We've now implemented "fill out out
> a struct fiemap_extent" twice.

fiemap_fill_{user, kernel}_extent() have different purposes, and the big
difference is one handles a userspace pointer memory and the other don't. IIRC
the original proposal was some sort of sharing a single function, but then
Christoph suggested a new design, using different functions as callbacks.

> > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > index b485190b7ecd..18a798e9076b 100644
> > --- a/fs/xfs/xfs_iops.c
> > +++ b/fs/xfs/xfs_iops.c
> > @@ -1113,6 +1113,11 @@ xfs_vn_fiemap(
> >  	struct fiemap_extent_info *fieinfo)
> >  {
> >  	int	error;
> > +	struct	xfs_inode	*ip = XFS_I(inode);
> 
> Would you mind fixing the indentation to match usual xfs style?

Sure, will fix it


> 
> > +
> > +	if (fieinfo->fi_flags & FIEMAP_KERNEL_FIBMAP)
> > +		if (xfs_is_reflink_inode(ip) || XFS_IS_REALTIME_INODE(ip))
> > +			return -EINVAL;
> 
> The xfs part looks ok to me.
> 
> --D
> 

-- 
Carlos
