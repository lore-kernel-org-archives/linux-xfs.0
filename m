Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36512 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727493AbeJUUEC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 21 Oct 2018 16:04:02 -0400
Received: by mail-wr1-f66.google.com with SMTP id y16so41888103wrw.3
        for <linux-xfs@vger.kernel.org>; Sun, 21 Oct 2018 04:49:57 -0700 (PDT)
Subject: Re: ENSOPC on a 10% used disk
References: <40c52a7b-2520-8ae4-11d5-ae4b33e1dc29@scylladb.com>
 <f5f7cd96-1a7a-3a3b-90f9-6415450b02a0@sandeen.net>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <d4a9257f-7ba9-15ad-1a6f-e12c74da8046@scylladb.com>
Date: Sun, 21 Oct 2018 14:49:54 +0300
MIME-Version: 1.0
In-Reply-To: <f5f7cd96-1a7a-3a3b-90f9-6415450b02a0@sandeen.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org


On 18/10/2018 18.54, Eric Sandeen wrote:
> On 10/17/18 2:52 AM, Avi Kivity wrote:
>> I have a user running a 1.7TB filesystem with ~10% usage (as shown by df), getting sporadic ENOSPC errors. The disk is mounted with inode64 and has a relatively small number of large files. The disk is a single-member RAID0 array, with 1MB chunk size. There are 32 AGs. Running Linux 4.9.17.
>>
>>
>> The write load consists of AIO/DIO writes, followed by unlinks of these files. The writes are non-size-changing (we truncate ahead) and we use XFS_IOC_FSSETXATTR/XFS_FLAG_EXTSIZE with a hint size of 32MB. The errors happen on commit logs, which have a target size of 32MB (but may exceed it a little).
>>
>>
>> The errors are sporadic and after restarting the workload they go away for a few hours to a few days, but then return. During one of the crashes I used xfs_db to look at fragmentation and saw that most AGs had free extents of size categories up to 128-255, but a few had more. I tried xfs_fsr but it did not help.
>>
>>
>> Is this a known issue? Would upgrading the kernel help?
>>
>>
>> I'll try to get a metadata dump next time this happens, and I'll be happy to supply more information.
> It sounds like you all figured this out, but I'll drop a reference to
> One Weird Trick to figure out just what function is returning a specific
> error value (the example below is EINVAL)
>
> First is my hack, what follows was Dave's refinement.  We should get this
> into scripts/ some day.


Cool, although to get noticed these days you have to put in bpf 
somewhere (and probably it can help with some kernel-side filtering - 
start logging as soon as you see the error, and hopefully you can 
recover the path from the returns).


>> # for FUNCTION in `grep "t xfs_" /proc/kallsyms | awk '{print $3}'`; do echo "r:ret_$FUNCTION $FUNCTION \$retval" >> /sys/kernel/debug/tracing/kprobe_events; done
>>
>> # for ENABLE in /sys/kernel/debug/tracing/events/kprobes/ret_xfs_*/enable; do echo 1 > $ENABLE; done
>>
>> run a test that fails:
>>
>> # dd if=/dev/zero of=newfile bs=513 oflag=direct
>> dd: writing `newfile': Invalid argument
>>
>> # for ENABLE in /sys/kernel/debug/tracing/events/kprobes/ret_xfs_*/enable; do echo 0 > $ENABLE; done
>>
>> # cat /sys/kernel/debug/tracing/trace
>> <snip>
>>             <...>-63791 [000] d... 705435.568913: ret_xfs_vn_mknod: (xfs_vn_create+0x13/0x20 [xfs] <- xfs_vn_mknod) arg1=0
>>             <...>-63791 [000] d... 705435.568913: ret_xfs_vn_create: (vfs_create+0xdb/0x100 <- xfs_vn_create) arg1=0
>>             <...>-63791 [000] d... 705435.568918: ret_xfs_file_open: (do_dentry_open+0x24e/0x2e0 <- xfs_file_open) arg1=0
>>             <...>-63791 [000] d... 705435.568934: ret_xfs_file_dio_aio_write: (xfs_file_aio_write+0x147/0x150 [xfs] <- xfs_file_dio_aio_write) arg1=ffffffffffffffea
>>
>> Hey look, it's "-22" in hex!
>>
>> so it's possible, but bleah.
> Dave later refined that to:
>
>> #!/bin/bash
>>
>> TRACEDIR=/sys/kernel/debug/tracing
>>
>> grep -i 't xfs_' /proc/kallsyms | awk '{print $3}' ; while read F; do
>> 	echo "r:ret_$F $F \$retval" >> $TRACEDIR/kprobe_events
>> done
>>
>> for E in $TRACEDIR/events/kprobes/ret_xfs_*/enable; do
>> 	echo 1 > $E
>> done;
>>
>> echo 'arg1 > 0xffffffffffffff00' > $TRACEDIR/events/kprobes/filter
>>
>> for T in $TRACEDIR/events/kprobes/ret_xfs_*/trigger; do
>> 	echo 'traceoff if arg1 > 0xffffffffffffff00' > $T
>> done
>
>
>> And that gives:
>>
>> # dd if=/dev/zero of=/mnt/scratch/newfile bs=513 oflag=direct
>> dd: error writing ¿/mnt/scratch/newfile¿: Invalid argument
>> 1+0 records in
>> 0+0 records out
>> 0 bytes (0 B) copied, 0.000259882 s, 0.0 kB/s
>> root@test4:~# cat /sys/kernel/debug/tracing/trace
>> # tracer: nop
>> #
>> # entries-in-buffer/entries-written: 1/1   #P:16
>> #
>> #                              _-----=> irqs-off
>> #                             / _----=> need-resched
>> #                            | / _---=> hardirq/softirq
>> #                            || / _--=> preempt-depth
>> #                            ||| /     delay
>> #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
>> #              | |       |   ||||       |         |
>>             <...>-8073  [006] d... 145740.460546: ret_xfs_file_dio_aio_write: (xfs_file_aio_write+0x170/0x180 <- xfs_file_dio_aio_write) arg1=0xffffffffffffffea
>>
>> Which is precisely the detection that XFS_ERROR would have given us.
>> Ok, so I guess we can now add whatever need need to that trigger...
>>
>> Basically, pass in teh XFs function names you want to trace, the
>> sets up teh events, whatever trigger beahviour you want, and
>> we're off to the races...
>
