Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:41195 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751436AbeAWRwR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jan 2018 12:52:17 -0500
Received: by mail-wr0-f171.google.com with SMTP id v15so1497312wrb.8
        for <linux-xfs@vger.kernel.org>; Tue, 23 Jan 2018 09:52:16 -0800 (PST)
Subject: Re: aio/dio write vs. file_update_time
From: Avi Kivity <avi@scylladb.com>
References: <52c2b3db-26cb-df95-2a77-866d27ce146c@scylladb.com>
 <20180123163133.GD32478@bfoster.bfoster>
 <f87e6ece-e98c-e39f-378a-c9c78f48be30@scylladb.com>
Message-ID: <1ec0f082-c6cf-0dc9-8f6f-5735292b2468@scylladb.com>
Date: Tue, 23 Jan 2018 19:52:13 +0200
MIME-Version: 1.0
In-Reply-To: <f87e6ece-e98c-e39f-378a-c9c78f48be30@scylladb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org



On 01/23/2018 07:25 PM, Avi Kivity wrote:
>
>
> On 01/23/2018 06:31 PM, Brian Foster wrote:
>> On Tue, Jan 23, 2018 at 06:10:51PM +0200, Avi Kivity wrote:
>>> I'm seeing the following lock contention in io_submit() (unfortunately,
>>> older kernel again)
>>>
>>>
>>>   0xffffffff816ab231 : __schedule+0x531/0x9b0 [kernel]
>>>   0xffffffff816ab6d9 : schedule+0x29/0x70 [kernel]
>>>   0xffffffff816acfc5 : rwsem_down_write_failed+0x225/0x3a0 [kernel]
>>>   0xffffffff81333ca7 : call_rwsem_down_write_failed+0x17/0x30 [kernel]
>>>   0xffff8819bc3f3bf8 : 0xffff8819bc3f3bf8
>>>   0xffffffff816aa8bd : down_write+0x2d/0x3d [kernel]
>>>   0xffffffffc00ca1d1 : xfs_ilock+0xc1/0x120 [xfs]
>>>   0xffffffffc00c7c8d : xfs_vn_update_time+0xcd/0x150 [xfs]
>>>   0xffffffff8121eda5 : update_time+0x25/0xd0 [kernel]
>>>   0xffffffff8121eef0 : file_update_time+0xa0/0xf0 [kernel]
>>>   0xffffffffc00be3a5 : xfs_file_aio_write_checks+0x185/0x1f0 [xfs]
>>>   0xffffffffc00be6c9 : xfs_file_dio_aio_write+0xd9/0x390 [xfs]
>>>   0xffffffffc00bed42 : xfs_file_aio_write+0x102/0x1b0 [xfs]
>>>   0xffffffffc00bec40 : xfs_file_aio_write+0x0/0x1b0 [xfs]
>>>   0xffffffff81255ff8 : do_io_submit+0x3b8/0x870 [kernel]
>>>
>>>
>>> There is only one thread issuing those writes, and nobody is reading 
>>> the
>>> file. Who could possibly be contending on this lock?
>>>
>> That looks like XFS_ILOCK_EXCL, which is a low level lock and thus not
>> necessarily restricted to user-driven operations. One possible example
>> of a background user is xfsaild, which acquires XFS_ILOCK_SHARED (and
>> thus locks out exclusive waiters) via xfs_inode_item_push() in order to
>> flush the dirty inode to disk (i.e., metadata writeback).
>>
>> I'm not exactly sure that's what is going on in your particular case,
>> but I think tracepoints are your friend here. ;) E.g., 'trace-cmd record
>> -e xfs:xfs_ilock' for the ilock, perhaps others for more context if
>> necessary..
>
> Here's what trace-cmd reported. I'm tracing xfs_ilock, xfs_iunlock, 
> and sched_switch:
>
>       syscall-14-12006 [007] 108264.972883: xfs_ilock: dev 9:0 ino 
> 0x10008c9a flags ILOCK_SHARED caller xfs_file_fsync
> <snip>
>       reactor-14-11979 [007] 108264.973292: xfs_iunlock: dev 9:0 ino 
> 0xa04d64c1 flags IOLOCK_SHARED caller xfs_file_dio_aio_read
>       reactor-14-11979 [007] 108264.973293: xfs_ilock: dev 9:0 ino 
> 0x10008c9a flags IOLOCK_SHARED caller xfs_file_dio_aio_write
>       reactor-14-11979 [007] 108264.973296: xfs_ilock: dev 9:0 ino 
> 0x10008c9a flags ILOCK_EXCL caller xfs_vn_update_time
>       reactor-14-11979 [007] 108264.973300: sched_switch: 
> reactor-14:11979 [120] D ==> kworker/7:1H:1350 [100]
> <snip>
>       syscall-14-12006 [007] 108265.015795: xfs_iunlock: dev 9:0 ino 
> 0x10008c9a flags ILOCK_SHARED caller xfs_file_fsync
>
>
> Is IOLOCK_SHARED mutually exclusive with ILOCK_EXCL? I'm guessing not.
>
>
> Looks like fsync clashed with io_submit() here, which wasn't supposed 
> to happen in my code, they ought to be mutually exclusive.

Actually I was wrong, we fsync() in parallel with writes to the 
application level commit log (for our data files, fsync is mutually 
exclusive with writes). So it looks like fsync is incompatible with aio 
writes to the same file.

