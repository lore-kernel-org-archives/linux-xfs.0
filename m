Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49378 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936050AbdIZFRw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2017 01:17:52 -0400
Content-Type: text/plain; charset="us-ascii"; delsp=yes; format=flowed
MIME-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v5 2/3] xfs: Set realtime flag based on initial allocation
 size
From: Richard Wareing <rwareing@fb.com>
In-Reply-To: <039ba853-ff85-61d9-3d4d-e933f137f499@sandeen.net>
Date: Mon, 25 Sep 2017 22:17:05 -0700
Content-Transfer-Encoding: 7bit
Message-ID: <6ABEC31B-4BEC-4D1D-ABA7-A09B84A9AE84@fb.com>
References: <20170925194418.720146-1-rwareing@fb.com>
 <20170925194418.720146-3-rwareing@fb.com>
 <039ba853-ff85-61d9-3d4d-e933f137f499@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org

Eric Sandeen <sandeen@sandeen.net> wrote:

> On 9/25/17 2:44 PM, Richard Wareing wrote:
>> - The rt_alloc_min sysfs option automatically selects the device (data
>>   device, or realtime) based on the size of the initial allocation of the
>>   file.
>> - This option can be used to route the storage of small files (and the
>>   inefficient workloads associated with them) to a suitable storage
>>   device such a SSD, while larger allocations are sent to a traditional
>>   HDD.
>> - Supports writes via O_DIRECT, buffered (i.e. page cache), and
>>   pre-allocations (i.e. fallocate)
>> - Available only when kernel is compiled w/ CONFIG_XFS_RT option.
>
> This needs documentation in Documentation/filesystems/xfs.txt
> along with all the other sysctls.  We can't just add magical tunables
> with no explanation of behavior.  ;)
>

I'll write it up tomorrow, not a problem.

>> Signed-off-by: Richard Wareing <rwareing@fb.com>
>> ---
>> Changes since v4:
>> * Added xfs_inode_select_target function to hold target selection
>>   code
>> * XFS_IS_REALTIME_MOUNT check now moved inside xfs_inode_select_target
>>   function for better gating
>> * Improved consistency in the sysfs set behavior
>> * Style fixes
>>
>> Changes since v3:
>> * Now functions via initial allocation regardless of O_DIRECT, buffered or
>>   pre-allocation code paths.  Provides a consistent user-experience.
>> * I Did do some experiments putting this in the xfs_bmapi_write code path
>>   however pre-allocation accounting unfortunately prevents this cleaner
>>   approach.  As such, this proved to be the cleanest and functional approach.
>> * No longer a mount option, now a sysfs tunable
>>
>>  fs/xfs/xfs_bmap_util.c |  2 ++
>>  fs/xfs/xfs_inode.c     | 18 ++++++++++++------
>>  fs/xfs/xfs_iomap.c     |  5 +++++
>>  fs/xfs/xfs_mount.h     |  1 +
>>  fs/xfs/xfs_rtalloc.c   | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/xfs/xfs_rtalloc.h   |  2 ++
>>  fs/xfs/xfs_sysfs.c     | 38 ++++++++++++++++++++++++++++++++++++++
>>  7 files changed, 110 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
>> index 9e3cc21..8205669d 100644
>> --- a/fs/xfs/xfs_bmap_util.c
>> +++ b/fs/xfs/xfs_bmap_util.c
>> @@ -1026,6 +1026,8 @@ xfs_alloc_file_space(
>>  	if (len <= 0)
>>  		return -EINVAL;
>>
>> +	xfs_inode_select_target(ip, len);
>> +
>>  	rt = XFS_IS_REALTIME_INODE(ip);
>>  	extsz = xfs_get_extsz_hint(ip);
>>
>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>> index ec9826c..f9e2deb 100644
>> --- a/fs/xfs/xfs_inode.c
>> +++ b/fs/xfs/xfs_inode.c
>> @@ -1620,12 +1620,18 @@ xfs_itruncate_extents(
>>  	if (error)
>>  		goto out;
>>
>> -	/*
>> -	 * Clear the reflink flag if we truncated everything.
>> -	 */
>> -	if (ip->i_d.di_nblocks == 0 && xfs_is_reflink_inode(ip)) {
>> -		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
>> -		xfs_inode_clear_cowblocks_tag(ip);
>> +	if (ip->i_d.di_nblocks == 0) {
>> +		/*
>> +		 * Clear the reflink flag if we truncated everything.
>> +		 */
>> +		if (xfs_is_reflink_inode(ip)) {
>> +			ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
>> +			xfs_inode_clear_cowblocks_tag(ip);
>> +		}
>> +		/* Clear realtime flag if m_rt_alloc_min policy is in place */
>> +		if (XFS_IS_REALTIME_MOUNT(mp) && mp->m_rt_alloc_min) {
>> +			ip->i_d.di_flags &= ~XFS_DIFLAG_REALTIME;
>> +		}
>
> This behavior needs documentation as well.  So now truncation will
> clear the realtime flag but only if some /other/ tunable is set?
>
> it used to be that if you set the realtime flag it would stay until
> specifically cleared.  now there's magic to clear it if your policy
> is in place.  I wonder what the reasoning behind this is?  Apologies
> if I missed it in other discussions ...
>


The reasoning here is that if you are using policy driven realtime
allocation, then you really want these policies deciding where data
should live, and for the policies to work consistently we need to
clear the flag upon truncation.  For those who want to manually decide
where data lives, the behavior will be what they know and love if they
do not enable these features.


>> }
>>
>>  	/*
>> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
>> index 94e5bdf..b3c3b9b 100644
>> --- a/fs/xfs/xfs_iomap.c
>> +++ b/fs/xfs/xfs_iomap.c
>> @@ -40,6 +40,7 @@
>>  #include "xfs_dquot_item.h"
>>  #include "xfs_dquot.h"
>>  #include "xfs_reflink.h"
>> +#include "xfs_rtalloc.h"
>>
>>
>>  #define XFS_WRITEIO_ALIGN(mp,off)	(((off) >> mp->m_writeio_log) \
>> @@ -174,6 +175,8 @@ xfs_iomap_write_direct(
>>  	int		bmapi_flags = XFS_BMAPI_PREALLOC;
>>  	uint		tflags = 0;
>>
>> +	xfs_inode_select_target(ip, count);
>
> I think you're changing on-disk inodes here with no locking
> and no transaction ... ?
>

You are correct, after chatting with Dave tonight I should be able
to fix this up.  You'll have to bear with me a bit as I'm still learning
this code base :).

The plan is to create/set the XFS_BMAPI_ and then update the inode flag
within a transaction later on (in xfs_bmapi* functions).  The
xfs_bmapi_reserve_delalloc function has to be special cased as there's no
transaction context in there.

I'll update/re-work things tomorrow.


>> +
>>  	rt = XFS_IS_REALTIME_INODE(ip);
>>  	extsz = xfs_get_extsz_hint(ip);
>>  	lockmode = XFS_ILOCK_SHARED;	/* locked by caller */
>> @@ -981,6 +984,8 @@ xfs_file_iomap_begin(
>>  	if (XFS_FORCED_SHUTDOWN(mp))
>>  		return -EIO;
>>
>> +	xfs_inode_select_target(ip, length);
>> +
>>  	if (((flags & (IOMAP_WRITE | IOMAP_DIRECT)) == IOMAP_WRITE) &&
>>  			!IS_DAX(inode) && !xfs_get_extsz_hint(ip)) {
>>  		/* Reserve delalloc blocks for regular writeback. */
>> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
>> index 9fa312a..2adc701 100644
>> --- a/fs/xfs/xfs_mount.h
>> +++ b/fs/xfs/xfs_mount.h
>> @@ -197,6 +197,7 @@ typedef struct xfs_mount {
>>  	__uint32_t		m_generation;
>>
>>  	bool			m_fail_unmount;
>> +	uint			m_rt_alloc_min; /* Min RT allocation */
>
>> #ifdef DEBUG
>>  	/*
>>  	 * DEBUG mode instrumentation to test and/or trigger delayed allocation
>> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
>> index c57aa7f..421f860 100644
>> --- a/fs/xfs/xfs_rtalloc.c
>> +++ b/fs/xfs/xfs_rtalloc.c
>> @@ -1284,3 +1284,53 @@ xfs_rtpick_extent(
>>  	*pick = b;
>>  	return 0;
>>  }
>> +
>> +/*
>> + * If allocation length is less than rt_alloc_min threshold select the
>> + * data device.   Otherwise, select the realtime device.
>> + */
>> +void xfs_rt_alloc_min(
>> +	struct xfs_mount	*mp,
>> +	struct xfs_inode	*ip,
>> +	xfs_off_t			len)
>> +{
>> +	if (!mp->m_rt_alloc_min)
>> +		return;
>> +
>> +	if (len < mp->m_rt_alloc_min) {
>> +		ip->i_d.di_flags &= ~XFS_DIFLAG_REALTIME;
>> +	} else {
>> +		ip->i_d.di_flags |= XFS_DIFLAG_REALTIME;
>> +	}
>> +}
>
> This has only one caller, over in another file.  Why not put it inline in
> xfs_inode_select_target?
>

Well rational here was to try to keep as much of the realtime code living
close together.  If this is already a lost cause I can stick it in the same
file.

>> +
>> +/*
>> +* Select the target device for the inode based on either the size of the
>> +* initial allocation, or the amount of space available on the data  
>> device.
>> +*
>> +*/
>> +void xfs_inode_select_target(
>> +	struct xfs_inode	*ip,
>> +	xfs_off_t			len)
>> +{
>> +	struct xfs_mount    *mp = ip->i_mount;
>
> Pls line up these variables on a consistent minimum tab stop, unless it's  
> some
> email artifact that has thrown me off :)

Hmmm, looks good on my vim editor, though I just grabbed the vim plugin from
https://github.com/vivien/vim-linux-coding-style and now I see it.  Fixing...

>
>> +
>> +	/* If the mount does not have a realtime device configured, there's
>> +	 * nothing to do here.
>> +	 */
>> +	if (!XFS_IS_REALTIME_MOUNT(mp))
>> +		return;
>> +
>> +	/* You cannot select a new device target once blocks have been allocated
>> +	 * (e.g. fallocate() beyond EOF), or if data has been written already.
>> +	 */
>> +	if (ip->i_d.di_nextents)
>> +		return;
>> +	if (ip->i_d.di_size)
>> +		return;
>> +
>> +	/* m_rt_alloc_min controls target selection.  Target selection code is
>> +	 * not valid if not set.
>> +	 */
>> +	xfs_rt_alloc_min(mp, ip, len);
>> +}
>> diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
>> index f13133e..eaf7ed3 100644
>> --- a/fs/xfs/xfs_rtalloc.h
>> +++ b/fs/xfs/xfs_rtalloc.h
>> @@ -136,6 +136,7 @@ int xfs_rtalloc_query_range(struct xfs_trans *tp,
>>  int xfs_rtalloc_query_all(struct xfs_trans *tp,
>>  			  xfs_rtalloc_query_range_fn fn,
>>  			  void *priv);
>> +void xfs_inode_select_target(struct xfs_inode *ip, xfs_off_t len);
>>  #else
>>  # define xfs_rtallocate_extent(t,b,min,max,l,f,p,rb)    (ENOSYS)
>>  # define xfs_rtfree_extent(t,b,l)                       (ENOSYS)
>> @@ -155,6 +156,7 @@ xfs_rtmount_init(
>>  }
>>  # define xfs_rtmount_inodes(m)  (((mp)->m_sb.sb_rblocks == 0)? 0 : (ENOSYS))
>>  # define xfs_rtunmount_inodes(m)
>> +# define xfs_inode_select_target(i,l)
>>  #endif	/* CONFIG_XFS_RT */
>>
>>  #endif	/* __XFS_RTALLOC_H__ */
>> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
>> index 80ac15f..1e202a1 100644
>> --- a/fs/xfs/xfs_sysfs.c
>> +++ b/fs/xfs/xfs_sysfs.c
>> @@ -129,10 +129,48 @@ XFS_SYSFS_ATTR_RW(drop_writes);
>>
>>  #endif /* DEBUG */
>>
>> +STATIC ssize_t
>> +rt_alloc_min_store(> +	struct kobject			*kobject,
>> +	const char				*buf,
>> +	size_t					count)
>> +{
>> +	struct xfs_mount		*mp = to_mp(kobject);
>> +	int						ret;
>> +	int						val;
>
> ditto on the lining up sanely:
>
> +rt_alloc_min_store(
> +	struct kobject		*kobject,
> +	const char		*buf,
> +	size_t			count)
> +{
> +	struct xfs_mount	*mp = to_mp(kobject);
> +	int			ret;
> +	int			val;
>

Fixed, hoping with the Linux kernel style vim plugin I won't have these
problems any longer.


>> +
>> +	ret = kstrtoint(buf, 0, &val);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* Only valid if using a real-time device */
>> +	if(!XFS_IS_REALTIME_MOUNT(mp))
>> +		return -EINVAL;
>> +
>> +	if (val >= 0)
>> +		mp->m_rt_alloc_min = val;
>> +	else
>> +		return -EINVAL;
>> +
>> +	return count;
>> +}
>> +
>> +STATIC ssize_t
>> +rt_alloc_min_show(
>> +	struct kobject          *kobject,
>> +	char                    *buf)
>> +{
>> +	struct xfs_mount        *mp = to_mp(kobject);
>> +
>> +	return snprintf(buf, PAGE_SIZE, "%d\n", mp->m_rt_alloc_min);
>> +}
>> +XFS_SYSFS_ATTR_RW(rt_alloc_min);
>
> Is this sysctl presented even if CONFIG_XFS_RT is turned off?
> Seems like that shouldn't show up if it doesn't do anything...
>

Agreed, I originally had it as such, but Dave suggested given it's
user facing it should remain visible.  I just pinged him on IRC and
he's fine changing it back.  I don't have strong feelings either way,
though I lean towards your thinking (hence my original choice).

>> +
>>  static struct attribute *xfs_mp_attrs[] = {
>>  #ifdef DEBUG
>>  	ATTR_LIST(drop_writes),
>>  #endif
>> +	ATTR_LIST(rt_alloc_min),
>>  	NULL,
>>  };


Richard...

