Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50136 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933685AbdIZDdG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2017 23:33:06 -0400
Content-Type: text/plain; charset="us-ascii"; delsp=yes; format=flowed
MIME-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v5 1/3] xfs: Show realtime device stats on statfs calls if
 inherit flag set
From: Richard Wareing <rwareing@fb.com>
In-Reply-To: <2ccf2df8-d99b-c8c3-2a70-97946a38fb1c@sandeen.net>
Date: Mon, 25 Sep 2017 20:32:17 -0700
Content-Transfer-Encoding: 7bit
Message-ID: <4DE6C725-5C10-4185-A763-C1D525EF4CC3@fb.com>
References: <20170925194418.720146-1-rwareing@fb.com>
 <20170925194418.720146-2-rwareing@fb.com>
 <2ccf2df8-d99b-c8c3-2a70-97946a38fb1c@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org

Eric Sandeen <sandeen@sandeen.net> wrote:

> On 9/25/17 2:44 PM, Richard Wareing wrote:
>> - Reports realtime device free blocks in statfs calls if inheritance
>>   bit is set on the inode of directory.  This is a bit more intuitive,
>>   especially for use-cases which are using a much larger device for
>>   the realtime device.
>> - Add XFS_IS_REALTIME_MOUNT option to gate based on the existence of a
>>   realtime device on the mount, similar to the XFS_IS_REALTIME_INODE
>>   option.
>
> Sorry for chiming in late.
>
> So, this is a major change in behavior of statfs on xfs.  How will the
> user know this, where is it documented?
>
> Also, if I read this right, does that mean that you get the magical
> new statfs results if you stat a /directory/ with XFS_DIFLAG_RTINHERIT
> set, but not if you stat a /file/ with XFS_DIFLAG_REALTIME set?
>
> That seems quite confusing, but maybe I'm missing something obvious.
>
> As for which filesystem is getting reported, would it be totally
> bonkers to have an xfs-realtime f_type to make it 100% clear what's
> being reported?
>
> -Eric
>

Wrt docs, I can write something up.  Any suggestions where the docs should
live?  Man page?

I'm also open to making this a sysfs option, it did cross my mind that
this change in behavior might be jarring (though in a good way ;) ).  For
those folks who wish to use realtime devices to place metadata on an SSD
this behavior is far more intuitive IMHO (as it more closely resembles the
presentation on a traditional FS setup).

You are also correct on the directory behavior.  For files you just
get their actual size on whatever device they happen to be stored on.
There is no change to that behavior.

Wrt new f_type, I'd be expecting a bit of push back on this as it may be
considered an abuse of this interface.

Richard


>> Signed-off-by: Richard Wareing <rwareing@fb.com>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Reviewed-by: Dave Chinner <dchinner@redhat.com>
>> ---
>> Changes since v4:
>> * None
>>
>> Changes since v3:
>> * Fixed accounting bug, we are not required to substract m_alloc_set_aside
>>   as this is a data device only requirement.
>> * Added XFS_IS_REALTIME_MOUNT macro based on learnings from  
>> CVE-2017-14340,
>>   now provides similar gating on the mount as XFS_IS_REALTIME_INODE does
>>   for the inode.
>>
>> Changes since v2:
>> * Style updated per Christoph Hellwig's comment
>> * Fixed bug: statp->f_bavail = statp->f_bfree
>>
>>  fs/xfs/xfs_linux.h | 2 ++
>>  fs/xfs/xfs_super.c | 8 ++++++++
>>  2 files changed, 10 insertions(+)
>>
>> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
>> index 044fb0e..fe46e71 100644
>> --- a/fs/xfs/xfs_linux.h
>> +++ b/fs/xfs/xfs_linux.h
>> @@ -280,8 +280,10 @@ static inline __uint64_t howmany_64(__uint64_t x,  
>> __uint32_t y)
>>
>>  #ifdef CONFIG_XFS_RT
>>  #define XFS_IS_REALTIME_INODE(ip) ((ip)->i_d.di_flags & XFS_DIFLAG_REALTIME)
>> +#define XFS_IS_REALTIME_MOUNT(mp) ((mp)->m_rtdev_targp ? 1 : 0)
>>  #else
>>  #define XFS_IS_REALTIME_INODE(ip) (0)
>> +#define XFS_IS_REALTIME_MOUNT(mp) (0)
>>  #endif
>>
>>  #endif /* __XFS_LINUX__ */
>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>> index 455a575..6d33a5e 100644
>> --- a/fs/xfs/xfs_super.c
>> +++ b/fs/xfs/xfs_super.c
>> @@ -1136,6 +1136,14 @@ xfs_fs_statfs(
>>  	    ((mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD))) ==
>>  			      (XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD))
>>  		xfs_qm_statvfs(ip, statp);
>> +
>> +	if (XFS_IS_REALTIME_MOUNT(mp) &&
>> +	    (ip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)) {
>> +		statp->f_blocks = sbp->sb_rblocks;
>> +		statp->f_bavail = statp->f_bfree =
>> +			sbp->sb_frextents * sbp->sb_rextsize;
>> +	}
>> +
>>  	return 0;
>>  }


