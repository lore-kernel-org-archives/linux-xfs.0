Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FABB3812DB;
	Fri, 16 Oct 2026 20:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792183190; cv=none; b=gbr96Vcxi4+/ntd8cOeZN4/SCapB3iom+JtGR+nFwEd/VCCtT5JsBegE0I5a/EuwLoxm7Wd3VFSeXUnXeUjsPYyva8lLNSwD1cTZCnHVmsRpKS6+NzdTG2shgDFYxrKw7/odxCOziwIt9DyoqHLqVpBg3KFqh+kT6+gCYCZxfaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792183190; c=relaxed/simple;
	bh=iEV4Jr2RFPRMdQ1JB6oMkpbHhAHNo+T0o9eEeV7qbNQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WEu6/KYnO0UIdLMTKRYIplIW5DEleF8/DSIWrfNzwGw5v26S0PEBZ40+BwLh97SXR6629cc44NiW3U0HJ8Upz4I7jbSdC5afCKoyqA98+sff4yMTs2Jf9MpTq1DQbbNgKp8iG/JO32m7yv3H/3Dg3TBiotO9SwOc3O6Jh6wh5XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YbLpZWgr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YbLpZWgr"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DD3EC1F000C4;
	Fri, 16 Oct 2026 20:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792183189;
	bh=KF5hjvAXTpNqqsVsTYXclBmKcEdX2PX37ZB36HfpOnE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YbLpZWgr7NjAoz6vMi+/ZY5XdsImTlZTwHLtz5UQz4n8vq69G5+3sV/zyH+iT/JQL
	 BxlP2UDq3LGNmSF04UQhUPW2/4BivEG0D9dejutjpAKp/4yN4rU10UZWZWHdTsO1hY
	 cbfepxQBaIoDWvHoc8c6sR6BWIh7suYIynj4/mJXblHkD1ckaN0b8rek5D8lxtgGRo
	 pDwu1rYRXXz+I1hnSN6KGvYDrhs6kD8mK8JSaw5AQkayV+IlxmMO8meQgS21Vq87NJ
	 McblRwhSK0PplK/ID8PEW1LPsdvGzz0pkieKfDmiz+N10RaKhuse3l1p6F1t5QPM9J
	 0d9EFvbvXZgOQ==
Date: Fri, 16 Oct 2026 13:39:48 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: brauner@kernel.org, hch@lst.de, dgc@kernel.org, cem@kernel.org,
	jack@suse.cz, axboe@kernel.dk, kbusch@kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH v6 4/8] xfs: implement software write-stream management
Message-ID: <20261016203948.GM107986@frogsfrogsfrogs>
References: <20261015063246.103433-1-joshi.k@samsung.com>
 <CGME20261015063434epcas5p3442627e6ade60cd8ad9bfa7ec95d468e@epcas5p3.samsung.com>
 <20261015063246.103433-5-joshi.k@samsung.com>
 <20261016203639.GL107986@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016203639.GL107986@frogsfrogsfrogs>

On Fri, Oct 16, 2026 at 01:36:39PM -0700, Darrick J. Wong wrote:
> On Thu, Oct 15, 2026 at 12:02:42PM +0530, Kanchan Joshi wrote:
> > From: Anuj Gupta <anuj20.g@samsung.com>
> > 
> > Implement the FS_IOC_WRITE_STREAM_* handlers.
> > 
> > Keep a stream pool in the data device buftarg, sized from the AG count.
> > The id is stored in inode->i_write_stream and is not written to disk.
> > 
> > Write streams, filestreams and write life time hints are mutually
> > exclusive. GET_MAX reports zero for filestream and realtime inodes, SET
> > rejects those and any inode carrying a hint, and setattr refuses to turn
> > on filestream or realtime placement while a stream is attached.
> > 
> > ALLOC is restricted to CAP_SYS_ADMIN.
> > 
> > Suggested-by: Christoph Hellwig <hch@lst.de>
> > Suggested-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> > Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> > ---
> >  fs/xfs/xfs_buf.c   | 31 ++++++++++++++++++
> >  fs/xfs/xfs_buf.h   |  6 ++++
> >  fs/xfs/xfs_inode.c | 69 ++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_inode.h |  4 +++
> >  fs/xfs/xfs_ioctl.c | 79 ++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_super.c |  5 +++
> >  6 files changed, 194 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index 8256c1d13ce2..a96f67630362 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -1647,6 +1647,7 @@ void
> >  xfs_free_buftarg(
> >  	struct xfs_buftarg	*btp)
> >  {
> > +	write_stream_pool_destroy(&btp->bt_stream_pool);
> >  	xfs_destroy_buftarg(btp);
> >  	fs_put_dax(btp->bt_daxdev, btp->bt_mount);
> >  	/* the main block device is closed by kill_block_super */
> > @@ -1684,6 +1685,36 @@ xfs_configure_buftarg_atomic_writes(
> >  	btp->bt_awu_max = max_bytes;
> >  }
> >  
> > +/* the block layer can tag I/O with at most U8_MAX write streams */
> > +#define XFS_MAX_WRITE_STREAMS		U8_MAX
> > +
> > +/* Heuristic to derive software write stream count from a group topology */
> > +static unsigned int
> > +xfs_sw_write_stream_count(
> > +	unsigned int		nr_groups)
> > +{
> > +	unsigned int		group_set_size;
> > +
> > +	if (nr_groups >= 16)
> > +		group_set_size = 4;
> > +	else if (nr_groups >= 8)
> > +		group_set_size = 2;
> > +	else
> > +		group_set_size = 1;
> > +	return min(nr_groups / group_set_size, XFS_MAX_WRITE_STREAMS);
> > +}
> > +
> > +int
> > +xfs_buftarg_init_streams(
> > +	struct xfs_buftarg	*btp,
> > +	unsigned int		nr_groups)
> > +{
> > +	unsigned int		nr_streams;
> > +
> > +	nr_streams = xfs_sw_write_stream_count(nr_groups);
> > +	return write_stream_pool_init(&btp->bt_stream_pool, nr_streams);
> > +}
> > +
> >  /* Configure a buffer target that abstracts a block device. */
> >  int
> >  xfs_configure_buftarg(
> > diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> > index a4729253b56f..b5292e5731e3 100644
> > --- a/fs/xfs/xfs_buf.h
> > +++ b/fs/xfs/xfs_buf.h
> > @@ -15,6 +15,7 @@
> >  #include <linux/uio.h>
> >  #include <linux/list_lru.h>
> >  #include <linux/lockref.h>
> > +#include <linux/write_streams.h>
> >  
> >  extern struct kmem_cache *xfs_buf_cache;
> >  
> > @@ -102,6 +103,9 @@ struct xfs_buftarg {
> >  	unsigned int		bt_awu_min;
> >  	unsigned int		bt_awu_max;
> >  
> > +	/* slot pool for stream fds on this device */
> > +	struct write_stream_pool bt_stream_pool;
> > +
> >  	struct rhashtable	bt_hash;
> >  };
> >  
> > @@ -360,6 +364,8 @@ extern void xfs_buftarg_wait(struct xfs_buftarg *);
> >  extern void xfs_buftarg_drain(struct xfs_buftarg *);
> >  int xfs_configure_buftarg(struct xfs_buftarg *btp, unsigned int sectorsize,
> >  		xfs_fsblock_t nr_blocks);
> > +int xfs_buftarg_init_streams(struct xfs_buftarg *btp,
> > +		unsigned int nr_groups);
> >  
> >  #define xfs_readonly_buftarg(buftarg)	bdev_read_only((buftarg)->bt_bdev)
> >  
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 621513d7215e..e36812103054 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -4,6 +4,7 @@
> >   * All Rights Reserved.
> >   */
> >  #include <linux/iversion.h>
> > +#include <linux/write_streams.h>
> >  
> >  #include "xfs_platform.h"
> >  #include "xfs_fs.h"
> > @@ -47,6 +48,74 @@
> >  
> >  struct kmem_cache *xfs_inode_cache;
> >  
> > +/* Number of write streams available to this inode. */
> > +int
> > +xfs_inode_max_write_streams(
> > +	struct xfs_inode	*ip)
> > +{
> > +	xfs_assert_ilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL);
> > +
> > +	if (xfs_inode_is_filestream(ip))
> > +		return 0;
> > +	if (XFS_IS_REALTIME_INODE(ip))
> > +		return 0;
> > +	return write_stream_pool_count(&xfs_inode_buftarg(ip)->bt_stream_pool);
> > +}
> > +
> > +/* Bind the write stream named by @stream_fd to @ip */
> > +int
> > +xfs_inode_set_write_stream(
> > +	struct xfs_inode	*ip,
> > +	int			stream_fd)
> > +{
> > +	CLASS(fd, f)(stream_fd);
> > +	struct xfs_buftarg	*target;
> > +	int			id, error = 0;
> > +
> > +	if (!fd_file(f))
> > +		return -EBADF;
> > +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > +	if (XFS_IS_REALTIME_INODE(ip)) {
> > +		error = -EINVAL;
> > +		goto out_unlock;
> > +	}
> > +
> > +	target = xfs_inode_buftarg(ip);
> > +	id = write_stream_get_id(fd_file(f), &target->bt_stream_pool);
> > +	if (id < 0) {
> > +		error = id;
> > +		goto out_unlock;
> > +	}
> > +
> > +	/* Filestream and write-stream are mutually exclusive */
> > +	if (xfs_inode_is_filestream(ip)) {
> > +		error = -EINVAL;
> > +		goto out_unlock;
> > +	}
> > +
> > +	/* keep write stream and write life time hint mutually exclusive */
> > +	spin_lock(&VFS_I(ip)->i_lock);
> > +	if (VFS_I(ip)->i_write_hint != WRITE_LIFE_NOT_SET) {
> > +		spin_unlock(&VFS_I(ip)->i_lock);
> > +		error = -EBUSY;
> > +		goto out_unlock;
> > +	}
> > +	WRITE_ONCE(VFS_I(ip)->i_write_stream, id);
> 
> Hmm.  I think this should be a vfs function since write hints and write
> streams are (apparently) mutually exclusive, and this is enforced on one
> end by the VFS?
> 
> > +	spin_unlock(&VFS_I(ip)->i_lock);
> > +out_unlock:
> > +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > +	return error;
> > +}
> > +
> > +void
> > +xfs_inode_clear_write_stream(
> > +	struct xfs_inode	*ip)
> > +{
> > +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > +	WRITE_ONCE(VFS_I(ip)->i_write_stream, 0);
> > +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > +}
> > +
> >  /*
> >   * These two are wrapper routines around the xfs_ilock() routine used to
> >   * centralize some grungy code.  They are used in places that wish to lock the
> > diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> > index 1602027cd0aa..c053f105d2fa 100644
> > --- a/fs/xfs/xfs_inode.h
> > +++ b/fs/xfs/xfs_inode.h
> > @@ -672,4 +672,8 @@ int xfs_icreate_dqalloc(const struct xfs_icreate_args *args,
> >  		struct xfs_dquot **udqpp, struct xfs_dquot **gdqpp,
> >  		struct xfs_dquot **pdqpp);
> >  
> > +int xfs_inode_max_write_streams(struct xfs_inode *ip);
> > +int xfs_inode_set_write_stream(struct xfs_inode *ip, int stream_fd);
> > +void xfs_inode_clear_write_stream(struct xfs_inode *ip);
> > +
> >  #endif	/* __XFS_INODE_H__ */
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 96ca3e480cb9..bc6957ad06cb 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -557,6 +557,11 @@ xfs_ioctl_setattr_xflags(
> >  	bool			rtflag = (fa->fsx_xflags & FS_XFLAG_REALTIME);
> >  	uint64_t		i_flags2;
> >  
> > +	/* refuse a filestream/realtime flag change while a stream is attached */
> > +	if (READ_ONCE(VFS_I(ip)->i_write_stream) &&
> > +	    ((fa->fsx_xflags & FS_XFLAG_FILESTREAM) || rtflag))
> 
> Shouldn't this detect a level change, e.g.
> 
> 	(!!rtflags != !!XFS_INODE_IS_REALTIME(ip))
> 
> For the case of clearing the rt flag?
> 
> Still not thrilled that you're not adding support for rt files.

Silly me, I didn't notice this all gets redone for rt support in a
couple of patches.  Please disregard this whole comment.

--D

> --D
> 
> > +		return -EINVAL;
> > +
> >  	if (rtflag != XFS_IS_REALTIME_INODE(ip)) {
> >  		/* Can't change realtime flag if any extents are allocated. */
> >  		if (xfs_inode_has_filedata(ip))
> > @@ -1200,6 +1205,73 @@ xfs_ioctl_fs_counts(
> >  	return 0;
> >  }
> >  
> > +static int
> > +xfs_ioc_write_stream_get_max(
> > +	struct file		*filp,
> > +	void __user		*arg)
> > +{
> > +	struct xfs_inode	*ip = XFS_I(file_inode(filp));
> > +	__u32			max;
> > +
> > +	xfs_ilock(ip, XFS_ILOCK_SHARED);
> > +	max = xfs_inode_max_write_streams(ip);
> > +	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> > +
> > +	return put_user(max, (__u32 __user *)arg);
> > +}
> > +
> > +static int
> > +xfs_ioc_write_stream_alloc(
> > +	struct file		*filp)
> > +{
> > +	struct xfs_inode	*ip = XFS_I(file_inode(filp));
> > +	struct xfs_buftarg	*target;
> > +	int			max;
> > +
> > +	if (!capable(CAP_SYS_ADMIN))
> > +		return -EPERM;
> > +
> > +	xfs_ilock(ip, XFS_ILOCK_SHARED);
> > +	max = xfs_inode_max_write_streams(ip);
> > +	target = xfs_inode_buftarg(ip);
> > +	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> > +
> > +	if (!max)
> > +		return -EOPNOTSUPP;
> > +	return write_stream_alloc_fd(&target->bt_stream_pool, filp);
> > +}
> > +
> > +static int
> > +xfs_ioc_write_stream_set(
> > +	struct file		*filp,
> > +	void __user		*arg)
> > +{
> > +	struct xfs_inode	*ip = XFS_I(file_inode(filp));
> > +	struct fs_write_stream_set set;
> > +
> > +	if (!(filp->f_mode & FMODE_WRITE))
> > +		return -EBADF;
> > +	if (copy_from_user(&set, arg, sizeof(set)))
> > +		return -EFAULT;
> > +	if (set.flags & ~FS_WRITE_STREAM_SET_CLEAR)
> > +		return -EINVAL;
> > +
> > +	/* Regular files only. */
> > +	if (!S_ISREG(VFS_I(ip)->i_mode))
> > +		return -EINVAL;
> > +
> > +	if (!inode_owner_or_capable(file_mnt_idmap(filp), VFS_I(ip)))
> > +		return -EPERM;
> > +
> > +	if (set.flags & FS_WRITE_STREAM_SET_CLEAR) {
> > +		if (set.stream_fd != -1)
> > +			return -EINVAL;
> > +		xfs_inode_clear_write_stream(ip);
> > +		return 0;
> > +	}
> > +	return xfs_inode_set_write_stream(ip, set.stream_fd);
> > +}
> > +
> >  /*
> >   * These long-unused ioctls were removed from the official ioctl API in 5.17,
> >   * but retain these definitions so that we can log warnings about them.
> > @@ -1466,6 +1538,13 @@ xfs_file_ioctl(
> >  	case XFS_IOC_VERIFY_MEDIA:
> >  		return xfs_ioc_verify_media(filp, arg);
> >  
> > +	case FS_IOC_WRITE_STREAM_GET_MAX:
> > +		return xfs_ioc_write_stream_get_max(filp, arg);
> > +	case FS_IOC_WRITE_STREAM_ALLOC:
> > +		return xfs_ioc_write_stream_alloc(filp);
> > +	case FS_IOC_WRITE_STREAM_SET:
> > +		return xfs_ioc_write_stream_set(filp, (void __user *)arg);
> > +
> >  	default:
> >  		return -ENOTTY;
> >  	}
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index b24db75eaedc..443b3d847150 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -608,6 +608,11 @@ xfs_setup_devices(
> >  	if (error)
> >  		return error;
> >  
> > +	error = xfs_buftarg_init_streams(mp->m_ddev_targp,
> > +			mp->m_sb.sb_agcount);
> > +	if (error)
> > +		return error;
> 
> Does this need to be done for m_rtdev_targp?
> 
> --D
> 
> > +
> >  	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp) {
> >  		unsigned int	log_sector_size = BBSIZE;
> >  
> > -- 
> > 2.25.1
> > 
> > 
> 
