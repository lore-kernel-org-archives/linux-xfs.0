Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:55692 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732689AbfHBPPl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Aug 2019 11:15:41 -0400
Date: Fri, 2 Aug 2019 08:15:19 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/9] fs: Move start and length fiemap fields into
 fiemap_extent_info
Message-ID: <20190802151519.GH7138@magnolia>
References: <20190731141245.7230-1-cmaiolino@redhat.com>
 <20190731141245.7230-6-cmaiolino@redhat.com>
 <20190731232837.GZ1561054@magnolia>
 <20190802095115.bjz6ejbouif3wkbt@pegasus.maiolino.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190802095115.bjz6ejbouif3wkbt@pegasus.maiolino.io>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, hch@lst.de, adilger@dilger.ca, jaegeuk@kernel.org, miklos@szeredi.hu, rpeterso@redhat.com, linux-xfs@vger.kernel.org

On Fri, Aug 02, 2019 at 11:51:16AM +0200, Carlos Maiolino wrote:
> > >  
> > >  STATIC int
> > >  xfs_vn_fiemap(
> > > -	struct inode		*inode,
> > > -	struct fiemap_extent_info *fieinfo,
> > > -	u64			start,
> > > -	u64			length)
> > > +	struct inode		  *inode,
> > > +	struct fiemap_extent_info *fieinfo)
> > >  {
> > > -	int			error;
> > > +	u64	start = fieinfo->fi_start;
> > > +	u64	length = fieinfo->fi_len;
> > > +	int	error;
> > 
> > Would be nice if the variable name indentation was consistent here, but
> > otherwise the xfs part looks ok.
> 
> These fields are removed on the next patch, updating it is really required?

Yes, please.

> > 
> > >  
> > >  	xfs_ilock(XFS_I(inode), XFS_IOLOCK_SHARED);
> > >  	if (fieinfo->fi_flags & FIEMAP_FLAG_XATTR) {
> > > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > > index d5e7c744aea6..7b744b7de24e 100644
> > > --- a/include/linux/fs.h
> > > +++ b/include/linux/fs.h
> > > @@ -1705,11 +1705,14 @@ extern bool may_open_dev(const struct path *path);
> > >   * VFS FS_IOC_FIEMAP helper definitions.
> > >   */
> > >  struct fiemap_extent_info {
> > > -	unsigned int fi_flags;		/* Flags as passed from user */
> > > -	unsigned int fi_extents_mapped;	/* Number of mapped extents */
> > > -	unsigned int fi_extents_max;	/* Size of fiemap_extent array */
> > > -	struct fiemap_extent __user *fi_extents_start; /* Start of
> > > -							fiemap_extent array */
> > > +	unsigned int	fi_flags;		/* Flags as passed from user */
> > > +	u64		fi_start;
> > > +	u64		fi_len;
> > 
> > Comments for these two new fields?
> 
> Sure, how about this:
> 
>        u64           fi_start;            /* Logical offset at which
>                                              start mapping */
>        u64           fi_len;              /* Logical length of mapping
>                                              the caller cares about */
> 
> 
> btw, Above indentation won't match final result

Looks good to me.

--D

> 
> Christoph, may I keep your reviewed tag by updating the comments as above?
> Otherwise I'll just remove your tag
> 
> > 
> > --D
> > 
> > > +	unsigned int	fi_extents_mapped;	/* Number of mapped extents */
> > > +	unsigned int	fi_extents_max;		/* Size of fiemap_extent array */
> > > +	struct		fiemap_extent __user *fi_extents_start;	/* Start of
> > > +								   fiemap_extent
> > > +								   array */
> > >  };
> > >  int fiemap_fill_next_extent(struct fiemap_extent_info *info, u64 logical,
> > >  			    u64 phys, u64 len, u32 flags);
> > > @@ -1841,8 +1844,7 @@ struct inode_operations {
> > >  	int (*setattr) (struct dentry *, struct iattr *);
> > >  	int (*getattr) (const struct path *, struct kstat *, u32, unsigned int);
> > >  	ssize_t (*listxattr) (struct dentry *, char *, size_t);
> > > -	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start,
> > > -		      u64 len);
> > > +	int (*fiemap)(struct inode *, struct fiemap_extent_info *);
> > >  	int (*update_time)(struct inode *, struct timespec64 *, int);
> > >  	int (*atomic_open)(struct inode *, struct dentry *,
> > >  			   struct file *, unsigned open_flag,
> > > @@ -3199,11 +3201,10 @@ extern int vfs_readlink(struct dentry *, char __user *, int);
> > >  
> > >  extern int __generic_block_fiemap(struct inode *inode,
> > >  				  struct fiemap_extent_info *fieinfo,
> > > -				  loff_t start, loff_t len,
> > >  				  get_block_t *get_block);
> > >  extern int generic_block_fiemap(struct inode *inode,
> > > -				struct fiemap_extent_info *fieinfo, u64 start,
> > > -				u64 len, get_block_t *get_block);
> > > +				struct fiemap_extent_info *fieinfo,
> > > +				get_block_t *get_block);
> > >  
> > >  extern struct file_system_type *get_filesystem(struct file_system_type *fs);
> > >  extern void put_filesystem(struct file_system_type *fs);
> > > -- 
> > > 2.20.1
> > > 
> 
> -- 
> Carlos
