Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 29 Aug 2008 02:36:31 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7T9aP3a030612
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2008 02:36:25 -0700
Received: from tyo202.gate.nec.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D3AA01BC82ED
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2008 02:37:48 -0700 (PDT)
Received: from tyo202.gate.nec.co.jp (TYO202.gate.nec.co.jp [202.32.8.206]) by cuda.sgi.com with ESMTP id 9MEj773BQYPiRoDo for <xfs@oss.sgi.com>; Fri, 29 Aug 2008 02:37:48 -0700 (PDT)
Message-ID: <4DF7C90FADA442868BA3D4C269F96DBF@nsl.ad.nec.co.jp>
From: "Takashi Sato" <t-sato@yk.jp.nec.com>
References: <20080818212819t-sato@mail.jp.nec.com> <20080821125841.a04a706f.akpm@linux-foundation.org>
In-Reply-To: <20080821125841.a04a706f.akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] Implement generic freeze feature
Date: Fri, 29 Aug 2008 18:36:56 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk, mtk.manpages@googlemail.com, linux-kernel@vger.kernel.org

Hi,

Andrew Morton wrote:
>> --- linux-2.6.27-rc2.org/include/linux/fs.h  2008-08-06 13:49:54.000000000 +0900
>> +++ linux-2.6.27-rc2-freeze/include/linux/fs.h       2008-08-07 08:59:54.000000000 +0900
>> @@ -226,6 +226,8 @@ extern int dir_notify_enable;
>>  #define BMAP_IOCTL 1                /* obsolete - kept for compatibility */
>>  #define FIBMAP         _IO(0x00,1)  /* bmap access */
>>  #define FIGETBSZ   _IO(0x00,2)      /* get the block size used for bmap */
>> +#define FIFREEZE    _IOWR('X', 119, int)    /* Freeze */
>> +#define FITHAW              _IOWR('X', 120, int)    /* Thaw */
>
>FIFREEZE is 119, but a few lines above we have
>
>#define BLKDISCARD _IO(0x12,119)
>
>Should we be using 120 and 121 here?

As Andreas said, we need to use 'X' to keep compatibility with
XFS's freeze ioctl.

>
>>  #define     FS_IOC_GETFLAGS                 _IOR('f', 1, long)
>>  #define     FS_IOC_SETFLAGS                 _IOW('f', 2, long)
>> @@ -574,6 +576,10 @@ struct block_device {
>>       * care to not mess up bd_private for that case.
>>       */
>>      unsigned long           bd_private;
>> +    /* The counter of freeze processes */
>> +    int                     bd_freeze_count;
>> +    /* Semaphore for freeze */
>> +    struct semaphore        bd_freeze_sem;
>
>"freeze" is not an adequate description of what this protects.  I think
>it's only the modification and testing of bd_freeze_count, isn't it?
>
>If so, all this could be done more neatly by removing the lock,
>switching to atomic_t and using our (rich) atomic_t operations.
>
>otoh, perhaps it protects more than this, in which case the lock
>can/should be switched to a `struct mutex'?

bd_freeze_sem protects the following two sequences.
1. freeze_bdev()
  - Test of bd_freeze_count
  - Increment of bd_freeze_count
  - s_op->write_super_lockfs
  - Set unfreeze timer

2. thaw_bdev()
  - Test of bd_freeze_count
  - Decrement of bd_freeze_count
  - s_op->unlockfs
  - Unset unfreeze timer
Because the journal sync in ext3's write_super_lockfs might
need a long time, we should use the mutex (not atomic_t).
If bd_freeze_sem protects only the modification and
testing of bd_freeze_count, freeze_bdev() and thaw_bdev() will
run simultaneously and unexpected problem will occur. 
(For example, after we run the freeze ioctl with timeout period,
the filesystem is frozen, but the unfreeze timer isn't set.)

Cheers, Takashi
