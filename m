Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 22:29:09 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3A5Su7K006391
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 22:28:59 -0700
Message-ID: <47FDA5BA.3080401@sgi.com>
Date: Thu, 10 Apr 2008 15:29:30 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [patch] remove unnecessary periodic superblock logging.
References: <20080410042001.GF108924158@sgi.com> <op.t9do1hkj3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.t9do1hkj3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Barry Naujok <bnaujok@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Barry Naujok wrote:
> On Thu, 10 Apr 2008 14:20:01 +1000, David Chinner <dgc@sgi.com> wrote:
> 
>> Remove periodic logging of in-core superblock counters.
>>
>> xfssyncd triggers the logging of superblock counters every
>> 30s if the filesystem is made with lazy-count=1. This will
>> prevent disks from idling and spinning down as there will
>> be a log write every 30s. With the way counter recovery
>> works for lazy-count=1, this code is unnecessary and provides
>> no real benefit, so just remove it.
> 
> I'm happy with this (xfs_initialize_perag_data() does the
> global counter recovery during mount).
> 

So we only do the sb count logging at unmount type times...
xfs_attr_quiesce() and xfs_unmountfs(),
when no log recovery will happen.
Hmmm...so why do we have to log it out at these times?
I'm forgetting how this works.

--Tim


>> Signed-off-by: Dave Chinner <dgc@sgi.com>
>> ---
>>  fs/xfs/linux-2.6/xfs_super.c |    3 +--
>>  fs/xfs/linux-2.6/xfs_vfs.h   |    1 -
>>  fs/xfs/xfs_vfsops.c          |   13 -------------
>>  3 files changed, 1 insertion(+), 16 deletions(-)
>>
>> Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_super.c
>> ===================================================================
>> --- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_super.c    2008-04-10 
>> 10:02:14.000000000 +1000
>> +++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_super.c    2008-04-10 
>> 10:02:58.419346393 +1000
>> @@ -1028,8 +1028,7 @@ xfs_sync_worker(
>>      int        error;
>>     if (!(mp->m_flags & XFS_MOUNT_RDONLY))
>> -        error = xfs_sync(mp, SYNC_FSDATA | SYNC_BDFLUSH | SYNC_ATTR |
>> -                     SYNC_REFCACHE | SYNC_SUPER);
>> +        error = xfs_sync(mp, SYNC_FSDATA | SYNC_BDFLUSH | SYNC_ATTR);
>>      mp->m_sync_seq++;
>>      wake_up(&mp->m_wait_single_sync_task);
>>  }
>> Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_vfs.h
>> ===================================================================
>> --- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_vfs.h    2008-04-10 
>> 10:00:25.000000000 +1000
>> +++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_vfs.h    2008-04-10 
>> 10:02:58.419346393 +1000
>> @@ -49,7 +49,6 @@ typedef struct bhv_vfs_sync_work {
>>  #define SYNC_REFCACHE        0x0040  /* prune some of the nfs ref 
>> cache */
>>  #define SYNC_REMOUNT        0x0080  /* remount readonly, no dummy LRs */
>>  #define SYNC_IOWAIT        0x0100  /* wait for all I/O to complete */
>> -#define SYNC_SUPER        0x0200  /* flush superblock to disk */
>> /*
>>   * When remounting a filesystem read-only or freezing the filesystem,
>> Index: 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c
>> ===================================================================
>> --- 2.6.x-xfs-new.orig/fs/xfs/xfs_vfsops.c    2008-04-10 
>> 10:01:54.000000000 +1000
>> +++ 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c    2008-04-10 10:03:35.288729547 
>> +1000
>> @@ -1326,21 +1326,8 @@ xfs_syncsub(
>>      }
>>     /*
>> -     * If asked, update the disk superblock with incore counter 
>> values if we
>> -     * are using non-persistent counters so that they don't get too 
>> far out
>> -     * of sync if we crash or get a forced shutdown. We don't want to 
>> force
>> -     * this to disk, just get a transaction into the iclogs....
>> -     */
>> -    if (flags & SYNC_SUPER) {
>> -        error = xfs_log_sbcount(mp, 0);
>> -        if (error)
>> -            last_error = error;
>> -    }
>> -
>> -    /*
>>       * Now check to see if the log needs a "dummy" transaction.
>>       */
>> -
>>      if (!(flags & SYNC_REMOUNT) && xfs_log_need_covered(mp)) {
>>          xfs_trans_t *tp;
>>          xfs_inode_t *ip;
>>
>>
> 
> 
> 
