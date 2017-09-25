Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22677 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934254AbdIYWsO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2017 18:48:14 -0400
Date: Mon, 25 Sep 2017 15:47:38 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v5 2/3] xfs: Set realtime flag based on initial
 allocation size
Message-ID: <20170925224738.GD5020@magnolia>
References: <20170925194418.720146-1-rwareing@fb.com>
 <20170925194418.720146-3-rwareing@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170925194418.720146-3-rwareing@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Richard Wareing <rwareing@fb.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org

On Mon, Sep 25, 2017 at 12:44:17PM -0700, Richard Wareing wrote:
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
> Changes since v4:
> * Added xfs_inode_select_target function to hold target selection
>   code
> * XFS_IS_REALTIME_MOUNT check now moved inside xfs_inode_select_target
>   function for better gating
> * Improved consistency in the sysfs set behavior
> * Style fixes
> 
> Changes since v3:
> * Now functions via initial allocation regardless of O_DIRECT, buffered or
>   pre-allocation code paths.  Provides a consistent user-experience.
> * I Did do some experiments putting this in the xfs_bmapi_write code path
>   however pre-allocation accounting unfortunately prevents this cleaner
>   approach.  As such, this proved to be the cleanest and functional approach.
> * No longer a mount option, now a sysfs tunable

I'm still struggling with the last two patches in this series.
Currently the decision to set or clear a file's RT flag rests with
whoever has write access to the file; and whatever they set stays that
way throughout the life of the file.

These patches add new behaviors to the filesystem, namely that initial
allocations and certain truncate operations can set or clear the
realtime flag, and that this happens without any particular notification
for whatever might've set that flag.  I imagine that programs that set
the realtime flag might be a little surprised when it doesn't stay set,
since we never used to do that.

At least the new behaviors are hidden behind a sysfs knob, but a big
thing missing from this series is a document for admins explaining that
we've added these various knobs to facilitate automatic tiering of files
on an XFS filesystem, what the knobs do, and which operations can change
a file's tier.  I also worry that we have no means to distinguish a file
that has had the rt flag set by the user from a file with automatic rt
flag management.

I think I may have mislead you a bit on the v1 patches when I objected
to the new fallocate behaviors -- my biggest concern back then (and now)
is the behavioral changes and how to help our existing users fit that
into their mental models of how XFS works.  Is the size of the first
non-fallocate write to a file sufficient to decide the rtflag?

TLDR: Is this how we (XFS community) want to present tiered XFS to users?

(Off in the crazy space that is my head we could just upload BPF
programs into XFS that would set and manage all the hints that can be
attached to an inode, along with either an "automanaged inode" flag that
locks out manual control or some kind of note that a particular setting
overrides the automated control.)

There are several mechanical problems too, which I'll cover below.

> 
>  fs/xfs/xfs_bmap_util.c |  2 ++
>  fs/xfs/xfs_inode.c     | 18 ++++++++++++------
>  fs/xfs/xfs_iomap.c     |  5 +++++
>  fs/xfs/xfs_mount.h     |  1 +
>  fs/xfs/xfs_rtalloc.c   | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_rtalloc.h   |  2 ++
>  fs/xfs/xfs_sysfs.c     | 38 ++++++++++++++++++++++++++++++++++++++
>  7 files changed, 110 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 9e3cc21..8205669d 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1026,6 +1026,8 @@ xfs_alloc_file_space(
>  	if (len <= 0)
>  		return -EINVAL;
>  
> +	xfs_inode_select_target(ip, len);
> +
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

FYI this chunk is going to change when some of the patches I have queued
up for -rc3 go upstream.

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
> +			ip->i_d.di_flags &= ~XFS_DIFLAG_REALTIME;

Why clear the rt flag from the file if we truncate the file and no
blocks are left, but not if (say) we punch out every block in the file?

Say we set rt_alloc_min = 64k and then pwrite 1mb at 10mb so that the rt
flag is automatically set.  Then we truncate the file to 9mb.  The file
size is 9MB, it has no blocks, and we auto-clear the rt flag?

Yet below I see that the auto-set function bails out if the /size/ is
greater than zero.

This seems inconsistent to me, why don't we also require the size to be
zero to clear the rt flag?  What if I set the rt flag myself and later
it gets cleared out automatically?  That's a new behavior that quietly
happens behind my back.

> +		}
>  	}
>  
>  	/*
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 94e5bdf..b3c3b9b 100644
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
> @@ -174,6 +175,8 @@ xfs_iomap_write_direct(
>  	int		bmapi_flags = XFS_BMAPI_PREALLOC;
>  	uint		tflags = 0;
>  
> +	xfs_inode_select_target(ip, count);
> +
>  	rt = XFS_IS_REALTIME_INODE(ip);
>  	extsz = xfs_get_extsz_hint(ip);
>  	lockmode = XFS_ILOCK_SHARED;	/* locked by caller */
> @@ -981,6 +984,8 @@ xfs_file_iomap_begin(
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
>  
> +	xfs_inode_select_target(ip, length);

iomap_begin can get called for more than just file writes.
Don't change the rt flag because someone FIEMAP'd a zero-length file.

> +
>  	if (((flags & (IOMAP_WRITE | IOMAP_DIRECT)) == IOMAP_WRITE) &&
>  			!IS_DAX(inode) && !xfs_get_extsz_hint(ip)) {
>  		/* Reserve delalloc blocks for regular writeback. */
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 9fa312a..2adc701 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -197,6 +197,7 @@ typedef struct xfs_mount {
>  	__uint32_t		m_generation;
>  
>  	bool			m_fail_unmount;
> +	uint			m_rt_alloc_min; /* Min RT allocation */

Bytes?  Do we need xfs_off_t here?

>  #ifdef DEBUG
>  	/*
>  	 * DEBUG mode instrumentation to test and/or trigger delayed allocation
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index c57aa7f..421f860 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1284,3 +1284,53 @@ xfs_rtpick_extent(
>  	*pick = b;
>  	return 0;
>  }
> +
> +/*
> + * If allocation length is less than rt_alloc_min threshold select the
> + * data device.   Otherwise, select the realtime device.
> + */
> +void xfs_rt_alloc_min(
> +	struct xfs_mount	*mp,
> +	struct xfs_inode	*ip,
> +	xfs_off_t			len)
> +{

Indenting...

void
xfs_rt_alloc_min(
	struct xfs_mount	*mp,
	struct xfs_inode	*ip,
	xfs_off_t		len)
{
	...
}

> +	if (!mp->m_rt_alloc_min)
> +		return;
> +
> +	if (len < mp->m_rt_alloc_min) {
> +		ip->i_d.di_flags &= ~XFS_DIFLAG_REALTIME;
> +	} else {
> +		ip->i_d.di_flags |= XFS_DIFLAG_REALTIME;
> +	}

Wait, xfs_rt_alloc_min updates inode flags??  Don't we need a
transaction and a xfs_trans_log_inode for this?  Since this is a
helper for the next function, the same question applies to it.

> +}
> +
> +/*
> +* Select the target device for the inode based on either the size of the
> +* initial allocation, or the amount of space available on the data device.
> +*
> +*/
> +void xfs_inode_select_target(
> +	struct xfs_inode	*ip,
> +	xfs_off_t			len)

Indenting again, and ... this is an inode function, shouldn't it go in
xfs_inode.c ?

And no, you can't just change the incore inode flags without a
transaction and without the ilock.

> +{
> +	struct xfs_mount    *mp = ip->i_mount;
> +
> +	/* If the mount does not have a realtime device configured, there's
> +	 * nothing to do here.
> +	 */
> +	if (!XFS_IS_REALTIME_MOUNT(mp))
> +		return;
> +
> +	/* You cannot select a new device target once blocks have been allocated
> +	 * (e.g. fallocate() beyond EOF), or if data has been written already.
> +	 */
> +	if (ip->i_d.di_nextents)
> +		return;
> +	if (ip->i_d.di_size)
> +		return;
> +
> +	/* m_rt_alloc_min controls target selection.  Target selection code is
> +	 * not valid if not set.
> +	 */
> +	xfs_rt_alloc_min(mp, ip, len);

If the helper functions are only going to be a few lines long and used
once, just put them directly in the function here.

> +}
> diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
> index f13133e..eaf7ed3 100644
> --- a/fs/xfs/xfs_rtalloc.h
> +++ b/fs/xfs/xfs_rtalloc.h
> @@ -136,6 +136,7 @@ int xfs_rtalloc_query_range(struct xfs_trans *tp,
>  int xfs_rtalloc_query_all(struct xfs_trans *tp,
>  			  xfs_rtalloc_query_range_fn fn,
>  			  void *priv);
> +void xfs_inode_select_target(struct xfs_inode *ip, xfs_off_t len);
>  #else
>  # define xfs_rtallocate_extent(t,b,min,max,l,f,p,rb)    (ENOSYS)
>  # define xfs_rtfree_extent(t,b,l)                       (ENOSYS)
> @@ -155,6 +156,7 @@ xfs_rtmount_init(
>  }
>  # define xfs_rtmount_inodes(m)  (((mp)->m_sb.sb_rblocks == 0)? 0 : (ENOSYS))
>  # define xfs_rtunmount_inodes(m)
> +# define xfs_inode_select_target(i,l)
>  #endif	/* CONFIG_XFS_RT */
>  
>  #endif	/* __XFS_RTALLOC_H__ */
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index 80ac15f..1e202a1 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -129,10 +129,48 @@ XFS_SYSFS_ATTR_RW(drop_writes);
>  
>  #endif /* DEBUG */
>  
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
> +	if(!XFS_IS_REALTIME_MOUNT(mp))
> +		return -EINVAL;
> +
> +	if (val >= 0)
> +		mp->m_rt_alloc_min = val;
> +	else
> +		return -EINVAL;
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
> +
>  static struct attribute *xfs_mp_attrs[] = {
>  #ifdef DEBUG
>  	ATTR_LIST(drop_writes),
>  #endif
> +	ATTR_LIST(rt_alloc_min),
>  	NULL,
>  };
>  
> -- 
> 2.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
