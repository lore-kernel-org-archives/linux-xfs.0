Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38352 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933306AbdIYShm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2017 14:37:42 -0400
Content-Type: text/plain; charset="us-ascii"; delsp=yes; format=flowed
MIME-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v4 3/3] xfs: Add realtime fallback if data device full
From: Richard Wareing <rwareing@fb.com>
In-Reply-To: <20170922070423.GE10955@dastard>
Date: Mon, 25 Sep 2017 11:37:02 -0700
Content-Transfer-Encoding: 7bit
Message-ID: <768B086C-A345-40AD-A1DD-6C175E768B63@fb.com>
References: <20170919035238.3976871-1-rwareing@fb.com>
 <20170919035238.3976871-4-rwareing@fb.com> <20170922070423.GE10955@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com, hch@infradead.org

Dave Chinner <david@fromorbit.com> wrote:

> On Mon, Sep 18, 2017 at 08:52:38PM -0700, Richard Wareing wrote:
>> - Adds tunable option to fallback to realtime device if configured
>>   when data device is full.
>> - Useful for realtime device users to help prevent ENOSPC errors when
>>   selectively storing some files (e.g. small files) on data device, while
>>   others are stored on realtime block device.
>> - Set via the "rt_fallback_pct" sysfs value which is available if
>>   the kernel is compiled with CONFIG_XFS_RT.
>>
>> Signed-off-by: Richard Wareing <rwareing@fb.com>
>> ---
>> Changes since v3:
>> * None, new patch to patch set
>>
>>  fs/xfs/xfs_bmap_util.c |  4 +++-
>>  fs/xfs/xfs_fsops.c     |  4 ++++
>>  fs/xfs/xfs_iomap.c     |  8 ++++++--
>>  fs/xfs/xfs_mount.c     | 27 ++++++++++++++++++++++++++-
>>  fs/xfs/xfs_mount.h     |  7 ++++++-
>>  fs/xfs/xfs_rtalloc.c   | 14 ++++++++++++++
>>  fs/xfs/xfs_rtalloc.h   |  3 ++-
>>  fs/xfs/xfs_sysfs.c     | 39 +++++++++++++++++++++++++++++++++++++++
>>  8 files changed, 100 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
>> index 2d253fb..9797c69 100644
>> --- a/fs/xfs/xfs_bmap_util.c
>> +++ b/fs/xfs/xfs_bmap_util.c
>> @@ -1026,8 +1026,10 @@ xfs_alloc_file_space(
>>  	if (len <= 0)
>>  		return -EINVAL;
>>
>> -	if (XFS_IS_REALTIME_MOUNT(mp))
>> +	if (XFS_IS_REALTIME_MOUNT(mp)) {
>>  		xfs_rt_alloc_min(ip, len);
>> +		xfs_rt_fallback(ip, mp);
>> +	}
>
> This should really go inside xfs_inode_select_target() as space
> availability is just another selection criteria....
>

Re-worked this.  I like this idea better as well.

>> rt = XFS_IS_REALTIME_INODE(ip);
>>  	extsz = xfs_get_extsz_hint(ip);
>> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
>> index 6ccaae9..c15e906 100644
>> --- a/fs/xfs/xfs_fsops.c
>> +++ b/fs/xfs/xfs_fsops.c
>> @@ -610,6 +610,10 @@ xfs_growfs_data_private(
>>  	xfs_set_low_space_thresholds(mp);
>>  	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
>>
>> +	if (XFS_IS_REALTIME_MOUNT(mp)) {
>> +		xfs_set_rt_min_fdblocks(mp);
>> +	}
>
> Normal way to do this is something like:
>
> 	mp->m_rt_min_fdblocks = xfs_calc_min_free_rtblocks(mp);
>
> and check XFS_IS_REALTIME_MOUNT() inside that function.
>
> And now, reading on, I find I've completely misunderstood what
> those variable and function names mean, so they need renaming
> to be clearer.

Fixed in new version, in my defense I was modeling this after
xfs_set_low_space_thresholds, but looks like xfs_alloc_set_aside
as you point out is a better pattern to follow (since mine is a
trivial assignment).

>
>> +
>> +/*
>> + * precalculate minimum of data blocks required, if we fall
>> + * below this value, we will fallback to the real-time device.
>> + *
>> + * m_rt_fallback_pct can only be non-zero if a real-time device
>> + * is configured.
>> + */
>> +void
>> +xfs_set_rt_min_fdblocks(
>> +	struct xfs_mount	*mp)
>> +{
>> +	if (mp->m_rt_fallback_pct) {
>> +		xfs_sb_t		*sbp = &mp->m_sb;
>> +		xfs_extlen_t 	lsize;
>> +		__uint64_t 		min_blocks;
>
> Stray whitespace. If you use vim, add this macro to your
> .vimrc so that it highlights stray whitespace for you:
>
> " highlight whitespace damage
> highlight RedundantSpaces ctermbg=red guibg=red
> match RedundantSpaces /\s\+$\| \+\ze\t/
>


Thanks for this, added to my vimrc!

>> +
>> +		lsize = sbp->sb_logstart ? sbp->sb_logblocks : 0;
>> +		min_blocks = (mp->m_sb.sb_dblocks - lsize) * mp->m_rt_fallback_pct;
>> +		do_div(min_blocks, 100);
>
> Why bother with the log size?
>

My thinking was to subtract out blocks used by the log, but upon further
reflection this isn't correct since the log blocks are already decremented
out of the free block count.  I've fixed this up.


>> +		/* Pre-compute minimum data blocks required before
>> +		 * falling back to RT device for allocations
>> +		 */
>
> Comment format.
>
>> +		mp->m_rt_min_fdblocks = min_blocks;
>
> Hmmm - I wonder if it would be better to tie this into the existing
> data device low space threshold code?
>

Not sure what you mean here?


>> +	}
>
> Also, indenting.
>
> 	if (!XFS_IS_REALTIME_MOUNT(mp))
> 		return 0;
> 	if (!mp->m_rt_fallback_pct)
> 		return 0;
> 	....
>
>
>
>> +}
>> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
>> index 067be3b..36676c4 100644
>> --- a/fs/xfs/xfs_mount.h
>> +++ b/fs/xfs/xfs_mount.h
>> @@ -197,7 +197,11 @@ typedef struct xfs_mount {
>>  	__uint32_t		m_generation;
>>
>>  	bool			m_fail_unmount;
>> -        uint                    m_rt_alloc_min; /* Min RT allocation */
>> +	uint			m_rt_alloc_min; /* Min RT allocation */
>> +	__uint8_t		m_rt_fallback_pct; /* Fall back to realtime device if
>
> uint32_t is fine. We're moving away from the __[u]int types, so
> we shouldn't really add any new ones.
>

Fixed.

>> +void xfs_rt_fallback(
>> +    struct xfs_inode    *ip,
>> +    struct xfs_mount    *mp)
>
> Mount first, then inode.
>

Just for my own knowledge, is this a convention?

>> +{
>> +    if (!XFS_IS_REALTIME_INODE(ip)) {
>> +        __uint64_t      free;
>> +        free = percpu_counter_sum(&mp->m_fdblocks) -
>> +            mp->m_alloc_set_aside;
>> +        if (free < mp->m_rt_min_fdblocks) {
>> +            ip->i_d.di_flags |= XFS_DIFLAG_REALTIME;
>> +        }
>> +    }
>> +}
>
> Indenting, but should really move to the target selection function.
>

Done.  I added a target function and two functions to contain the policy
code specific to each threshold.

>> +STATIC ssize_t
>> +rt_fallback_pct_store(
>> +	struct kobject			*kobject,
>> +	const char				*buf,
>> +	size_t					count)
>> +{
>> +	struct xfs_mount		*mp = to_mp(kobject);
>> +	int						ret;
>> +	int						val;
>> +
>> +	ret = kstrtoint(buf, 0, &val);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* Only valid if using a real-time device */
>> +	if (XFS_IS_REALTIME_MOUNT(mp) && ((val > 0) && (val <=100))) {
>> +		mp->m_rt_fallback_pct = val;
>> +		xfs_set_rt_min_fdblocks(mp);
>> +	} else if (val <= 0) {
>> +		mp->m_rt_fallback_pct = 0;
>> +		mp->m_rt_min_fdblocks = 0;
>> +	} else
>> +		return -EINVAL;
>
> Same issue as last patch.
>
> Also, just set then threshold percentage, and if there is no error,
> then call xfs_set_rt_min_fdblocks() rather than zeroing it directly.
>

Fixed.

> Cheers,
>
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com


