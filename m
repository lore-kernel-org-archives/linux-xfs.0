Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA8CBv09097908 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 06:11:57 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D99A0160F44
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 04:13:24 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id rYBaiNAzUPkW8z9C for
	<xfs@oss.sgi.com>; Mon, 08 Nov 2010 04:13:24 -0800 (PST)
Date: Mon, 8 Nov 2010 07:13:22 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/16] [RFC] xfs: use generic per-cpu counter
	infrastructure
Message-ID: <20101108121322.GA3023@infradead.org>
References: <1289206519-18377-1-git-send-email-david@fromorbit.com>
	<1289206519-18377-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1289206519-18377-4-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Nov 08, 2010 at 07:55:06PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> XFS has a per-cpu counter implementation for in-core superblock
> counters that pre-dated the generic implementation. It is complex
> and baroque as it is tailored directly to the needs of ENOSPC
> detection. Implement the complex accurate-compare-and-add
> calculation in the generic per-cpu counter code and convert the
> XFS counters to use the much simpler generic counter code.
> 
> Passes xfsqa on SMP system.

Some mostly cosmetic comments below.  I haven't looked at the more
hairy bits like the changes to the generic percpu code and the
reservation handling yet.

> 	1. kill the no-per-cpu-counter mode?

already done.

> 	3. do we need to factor xfs_mod_sb_incore()?

Doesn't exist anymore. 

> -	xfs_icsb_sync_counters(mp, XFS_ICSB_LAZY_COUNT);
> +	xfs_icsb_sync_counters(mp);
>  	spin_lock(&mp->m_sb_lock);

Can be moved inside the lock and use the unlocked version, too.

> +static inline int
> +xfs_icsb_add(
> +	struct xfs_mount	*mp,
> +	int			counter,
> +	int64_t			delta,
> +	int64_t			threshold)
> +{
> +	int			ret;
> +
> +	ret = percpu_counter_add_unless_lt(&mp->m_icsb[counter], delta,
> +								threshold);
> +	if (ret < 0)
> +		return -ENOSPC;
> +	return 0;
> +}
> +
> +static inline void
> +xfs_icsb_set(
> +	struct xfs_mount	*mp,
> +	int			counter,
> +	int64_t			value)
> +{
> +	percpu_counter_set(&mp->m_icsb[counter], value);
> +}
> +
> +static inline int64_t
> +xfs_icsb_sum(
> +	struct xfs_mount	*mp,
> +	int			counter)
> +{
> +	return percpu_counter_sum_positive(&mp->m_icsb[counter]);
> +}
> +
> +static inline int64_t
> +xfs_icsb_read(
> +	struct xfs_mount	*mp,
> +	int			counter)
> +{
> +	return percpu_counter_read_positive(&mp->m_icsb[counter]);
> +}

I would just opencode all these helpers in their callers.  There's
generally just one caller of each, which iterates over the three
counters anyway.


> +int
> +xfs_icsb_modify_counters(
> +	xfs_mount_t	*mp,
> +	xfs_sb_field_t	field,
> +	int64_t		delta,
> +	int		rsvd)

I can't see the point of keeping this multiplexer.  The inode counts
are handled entirely different from the block count, so they should
have separate functions.

> +{
> +	int64_t		lcounter;
> +	int64_t		res_used;
> +	int		ret = 0;
> +
> +
> +	switch (field) {
> +	case XFS_SBS_ICOUNT:
> +		ret = xfs_icsb_add(mp, XFS_ICSB_ICOUNT, delta, 0);
> +		if (ret < 0) {
> +			ASSERT(0);
> +			return XFS_ERROR(EINVAL);
> +		}
> +		return 0;
> +
> +	case XFS_SBS_IFREE:
> +		ret = xfs_icsb_add(mp, XFS_ICSB_IFREE, delta, 0);
> +		if (ret < 0) {
> +			ASSERT(0);
> +			return XFS_ERROR(EINVAL);
> +		}
> +		return 0;

If you're keeping a common helper for both inode counts this can be
simplified by sharing the code and just passing on the field instead
of having two cases.

> +	struct percpu_counter	m_icsb[XFS_ICSB_MAX];

I wonder if there's all that much of a point in keeping the array.
We basically only use the fact it's an array for the init/destroy
code.  Maybe it would be a tad cleaner to just have three separate
percpu counters.

> +static inline void
> +xfs_icsb_sync_counters(
> +	struct xfs_mount	*mp)
> +{
> +	spin_lock(&mp->m_sb_lock);
> +	xfs_icsb_sync_counters_locked(mp);
> +	spin_unlock(&mp->m_sb_lock);
> +}

There's only one callers of this left after my comment above is
addressed. I'd just make xfs_icsb_sync_counters the locked version,
throw in an assert_spin_locked and have the one remaining caller
take the lock opencoded as well.

> --- a/include/linux/percpu_counter.h
> +++ b/include/linux/percpu_counter.h
> @@ -41,6 +41,8 @@ void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
>  void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch);
>  s64 __percpu_counter_sum(struct percpu_counter *fbc);
>  int percpu_counter_compare(struct percpu_counter *fbc, s64 rhs);
> +int percpu_counter_add_unless_lt(struct percpu_counter *fbc, s64 amount,
> +							s64 threshold);
>  
>  static inline void percpu_counter_add(struct percpu_counter *fbc, s64 amount)
>  {
> @@ -153,6 +155,20 @@ static inline int percpu_counter_initialized(struct percpu_counter *fbc)
>  	return 1;
>  }
>  
> +static inline int percpu_counter_test_and_add_delta(struct percpu_counter *fbc, s64 delta)

This doesn't match the function provided for CONFIG_SMP.

> +/**
> + *

spurious line.

> +int percpu_counter_add_unless_lt(struct percpu_counter *fbc, s64 amount, s64
> +threshold)

too long line

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
