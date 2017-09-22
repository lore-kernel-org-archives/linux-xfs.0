Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:44490 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751637AbdIVFyi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Sep 2017 01:54:38 -0400
Date: Fri, 22 Sep 2017 15:54:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 2/3] xfs: Set realtime flag based on initial
 allocation size
Message-ID: <20170922055434.GD10955@dastard>
References: <20170919035238.3976871-1-rwareing@fb.com>
 <20170919035238.3976871-3-rwareing@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170919035238.3976871-3-rwareing@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Richard Wareing <rwareing@fb.com>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com, hch@infradead.org

On Mon, Sep 18, 2017 at 08:52:37PM -0700, Richard Wareing wrote:
> - The rt_alloc_min sysfs option automatically selects the device (data
>   device, or realtime) based on the size of the initial allocation of the
>   file.
> - This option can be used to route the storage of small files (and the
>   inefficient workloads associated with them) to a suitable storage
>   device such a SSD, while larger allocations are sent to a traditional
>   HDD.
> - Supports writes via O_DIRECT, buffered (i.e. page cache), and
>   pre-allocations (i.e. fallocate)
> - Available only when kernel is compiled w/ CONFIG_XFS_RT option.
> 
> Signed-off-by: Richard Wareing <rwareing@fb.com>
> ---
> Changes since v3:
> * Now functions via initial allocation regardless of O_DIRECT, buffered or
>   pre-allocation code paths.  Provides a consistent user-experience.
> * I Did do some experiments putting this in the xfs_bmapi_write code path
>   however pre-allocation accounting unfortunately prevents this cleaner
>   approach.  As such, this proved to be the cleanest and functional approach.
> * No longer a mount option, now a sysfs tunable
> 
> Changes since v2:
> * None
> 
>  fs/xfs/xfs_bmap_util.c |  3 +++
>  fs/xfs/xfs_inode.c     | 18 ++++++++++++------
>  fs/xfs/xfs_iomap.c     |  8 ++++++++
>  fs/xfs/xfs_mount.h     |  1 +
>  fs/xfs/xfs_rtalloc.c   | 26 ++++++++++++++++++++++++++
>  fs/xfs/xfs_rtalloc.h   |  4 ++++
>  fs/xfs/xfs_sysfs.c     | 41 +++++++++++++++++++++++++++++++++++++++++
>  7 files changed, 95 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 9e3cc21..2d253fb 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1026,6 +1026,9 @@ xfs_alloc_file_space(
>  	if (len <= 0)
>  		return -EINVAL;
>  
> +	if (XFS_IS_REALTIME_MOUNT(mp))
> +		xfs_rt_alloc_min(ip, len);

I'd put the XFS_IS_REALTIME_MOUNT() check inside xfs_rt_alloc_min().
That way we can compile the code out completely when
CONFIG_XFS_RT=n.

>  	rt = XFS_IS_REALTIME_INODE(ip);
>  	extsz = xfs_get_extsz_hint(ip);
>  
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index ec9826c..f9e2deb 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1620,12 +1620,18 @@ xfs_itruncate_extents(
>  	if (error)
>  		goto out;
>  
> -	/*
> -	 * Clear the reflink flag if we truncated everything.
> -	 */
> -	if (ip->i_d.di_nblocks == 0 && xfs_is_reflink_inode(ip)) {
> -		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
> -		xfs_inode_clear_cowblocks_tag(ip);
> +	if (ip->i_d.di_nblocks == 0) {
> +		/*
> +		 * Clear the reflink flag if we truncated everything.
> +		 */
> +		if (xfs_is_reflink_inode(ip)) {
> +			ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
> +			xfs_inode_clear_cowblocks_tag(ip);
> +		}
> +		/* Clear realtime flag if m_rt_alloc_min policy is in place */
> +		if (XFS_IS_REALTIME_MOUNT(mp) && mp->m_rt_alloc_min) {

Won't m_rt_alloc_min always be zero on non-rt filesystems?

> +			ip->i_d.di_flags &= ~XFS_DIFLAG_REALTIME;
> +		}
>  	}
>  
>  	/*
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 94e5bdf..11f1c95 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -40,6 +40,7 @@
>  #include "xfs_dquot_item.h"
>  #include "xfs_dquot.h"
>  #include "xfs_reflink.h"
> +#include "xfs_rtalloc.h"
>  
>  
>  #define XFS_WRITEIO_ALIGN(mp,off)	(((off) >> mp->m_writeio_log) \
> @@ -174,6 +175,10 @@ xfs_iomap_write_direct(
>  	int		bmapi_flags = XFS_BMAPI_PREALLOC;
>  	uint		tflags = 0;
>  
> +
> +	if (XFS_IS_REALTIME_MOUNT(mp))
> +		xfs_rt_alloc_min(ip, count);

Reading this makes me wonder what we are allocating here :/
A better name might be in order - something that indicates we're
selecting the target device rather allocating something. e.g.
xfs_inode_select_target()?

> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 9fa312a..067be3b 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -197,6 +197,7 @@ typedef struct xfs_mount {
>  	__uint32_t		m_generation;
>  
>  	bool			m_fail_unmount;
> +        uint                    m_rt_alloc_min; /* Min RT allocation */

WHitespace problem - looks like spaces instead of tabs....

>  #ifdef DEBUG
>  	/*
>  	 * DEBUG mode instrumentation to test and/or trigger delayed allocation
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index c57aa7f..e51cb25 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1284,3 +1284,29 @@ xfs_rtpick_extent(
>  	*pick = b;
>  	return 0;
>  }
> +
> +/*
> + * Automatically set real-time flag if initial write to inode is > m_rt_alloc_min
> + *
> + * Also valid on truncations.
> + *
> + */
> +void xfs_rt_alloc_min(
> +	struct xfs_inode	*ip,
> +	xfs_off_t       	len)
> +{
> +	struct xfs_mount    *mp = ip->i_mount;
> +
> +	if (!mp->m_rt_alloc_min || ip->i_d.di_size)
> +		return;

I kinda prefer stacking single checks like

	/*
	 * m_rt_alloc_min controls the target selection. It is
	 * inactive if it is not set.
	 */
	if (!mp->m_rt_alloc_min)
		return;

	/*
	 * Can't select a different target if we've already
	 * allocated blocks (e.g. fallocate() beyond EOF) or has
	 * data in it already.
	 */
	if (!ip->i_nextents)
		return;
	if (!ip->i_d.di_size)
		return;

> +	if (XFS_IS_REALTIME_INODE(ip)) {
> +		if (len < mp->m_rt_alloc_min) {
> +			ip->i_d.di_flags &= ~XFS_DIFLAG_REALTIME;
> +		}
> +	} else {
> +		if (len >= mp->m_rt_alloc_min) {
> +			ip->i_d.di_flags |= XFS_DIFLAG_REALTIME;
> +		}
> +	}

Checking for XFS_IS_REALTIME_INODE() is redundant here. This does
the same thing:

	/*
	 * if the allocation length is less than the threshold,
	 * always select the data device. Otherwise we should
	 * select the realtime device.
	 */
	if (len < mp->m_rt_alloc_min)
		ip->i_d.di_flags &= ~XFS_DIFLAG_REALTIME;
	else
		ip->i_d.di_flags |= XFS_DIFLAG_REALTIME;

> +}
> diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
> index f13133e..12939d9 100644
> --- a/fs/xfs/xfs_rtalloc.h
> +++ b/fs/xfs/xfs_rtalloc.h
> @@ -136,6 +136,9 @@ int xfs_rtalloc_query_range(struct xfs_trans *tp,
>  int xfs_rtalloc_query_all(struct xfs_trans *tp,
>  			  xfs_rtalloc_query_range_fn fn,
>  			  void *priv);
> +void xfs_rt_alloc_min(struct xfs_inode *ip, xfs_off_t len);
> +
> +
>  #else
>  # define xfs_rtallocate_extent(t,b,min,max,l,f,p,rb)    (ENOSYS)
>  # define xfs_rtfree_extent(t,b,l)                       (ENOSYS)
> @@ -155,6 +158,7 @@ xfs_rtmount_init(
>  }
>  # define xfs_rtmount_inodes(m)  (((mp)->m_sb.sb_rblocks == 0)? 0 : (ENOSYS))
>  # define xfs_rtunmount_inodes(m)
> +# define xfs_rt_alloc_min(i,l)                          (ENOSYS)
>  #endif	/* CONFIG_XFS_RT */
>  
>  #endif	/* __XFS_RTALLOC_H__ */
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index 80ac15f..3c8dedb 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -129,10 +129,51 @@ XFS_SYSFS_ATTR_RW(drop_writes);
>  
>  #endif /* DEBUG */
>  
> +#ifdef CONFIG_XFS_RT
> +STATIC ssize_t
> +rt_alloc_min_store(
> +	struct kobject			*kobject,
> +	const char				*buf,
> +	size_t					count)
> +{
> +	struct xfs_mount		*mp = to_mp(kobject);
> +	int						ret;
> +	int						val;
> +
> +	ret = kstrtoint(buf, 0, &val);
> +	if (ret)
> +		return ret;
> +
> +	/* Only valid if using a real-time device */
> +	if (XFS_IS_REALTIME_MOUNT(mp) && val > 0)
> +		mp->m_rt_alloc_min = val;
> +	else if (val <= 0)
> +		mp->m_rt_alloc_min = 0;
> +	else
> +		return -EINVAL;

Seems inconsistent. This will allow a value <= 0 for a non-realtime
mount, but will return EINVAL for values > 0. Perhaps it would be
more consistent to return EINVAL for a non-realtime mount or
any value < 0?

> +
> +	return count;
> +}
> +
> +STATIC ssize_t
> +rt_alloc_min_show(
> +	struct kobject          *kobject,
> +	char                    *buf)
> +{
> +	struct xfs_mount        *mp = to_mp(kobject);
> +
> +	return snprintf(buf, PAGE_SIZE, "%d\n", mp->m_rt_alloc_min);
> +}
> +XFS_SYSFS_ATTR_RW(rt_alloc_min);
> +#endif /* CONFIG_XFS_RT */
> +
>  static struct attribute *xfs_mp_attrs[] = {
>  #ifdef DEBUG
>  	ATTR_LIST(drop_writes),
>  #endif
> +#ifdef CONFIG_XFS_RT
> +	ATTR_LIST(rt_alloc_min),
> +#endif

This is userspace visible - shouldn't we always compile this in,
even if all it does it return EINVAL to attempts to change it when
CONFIG_XFS_RT=n?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
