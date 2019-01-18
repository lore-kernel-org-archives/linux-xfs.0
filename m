Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:45525 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727177AbfAROsw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Jan 2019 09:48:52 -0500
Reply-To: d.aberger@profihost.ag
Subject: Re: XFS filesystem hang
References: <645a3d40-47a5-0f7a-7565-821bbce103f2@profihost.ag>
 <20190117123427.GA37591@bfoster>
 <8cf51b2c-6e9b-317a-16fc-9e47f916198e@profihost.ag>
 <20190117220512.GE6173@dastard>
From: Daniel Aberger - Profihost AG <d.aberger@profihost.ag>
Message-ID: <030b0a00-0c0f-4ab3-373d-f9734e60472f@profihost.ag>
Date: Fri, 18 Jan 2019 15:48:46 +0100
MIME-Version: 1.0
In-Reply-To: <20190117220512.GE6173@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, s.priebe@profihost.ag, n.fahldieck@profihost.ag

Am 17.01.19 um 23:05 schrieb Dave Chinner:
> On Thu, Jan 17, 2019 at 02:50:23PM +0100, Daniel Aberger - Profihost AG wrote:
>> Am 17.01.19 um 13:34 schrieb Brian Foster:
>>> On Thu, Jan 17, 2019 at 12:14:11PM +0100, Daniel Aberger - Profihost AG wrote:
>>>> Hi,
>>>>
>>>> one of our servers crashed / hung several times in the past days with
>>>> similar errors regarding XFS. Unfortunately we are unable to interprete
>>>> the call trace of dmesg to pinpoint the exact problem and I hope you
>>>> could help me to do so.
>>>>
>>>> We already ran xfs_repair to ensure that there are no filesystem errors.
>>>>
>>>> Here is an example dmesg output of recent crash of the mentioned server:
>>>>
>>>> 2019-01-12 06:06:35     INFO: task mysqld:1171 blocked for more than 120
>>>> seconds.
>>>
>>> This is not a crash but rather an indication from the kernel that this
>>> task has been sitting here for at least a couple minutes. This doesn't
>>> tell us whether the task will eventually recover or remain blocked
>>> indefinitely.
>>>
>>
>> Yes, you're right. Well I was referring to it as a crash since the
>> system does not respond to any inputs anymore and we have to perform a
>> REISUB to reboot it.
>>
>>>> 2019-01-12 06:06:35     Tainted: G 4.12.0+139-ph #1
>>>> 2019-01-12 06:06:35     "echo 0 >
>>>> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>>> 2019-01-12 06:06:35     mysqld D 0 1171 1 0x00080000
>>>> 2019-01-12 06:06:35     Call Trace:
>>>> 2019-01-12 06:06:35     ? __schedule+0x3bc/0x820
>>>> 2019-01-12 06:06:35     ? strlcpy+0x31/0x40
>>>> 2019-01-12 06:06:35     ?
>>>> kernfs_path_from_node_locked+0x238/0x320schedule+0x32/0x80xlog_grant_head_wait+0xca/0x200xlog_grant_head_check+0x86/0xe0xfs_log_reserve+0xc7/0x1c0xfs_trans_reserve+0x169/0x1c0xfs_trans_alloc+0xb9/0x130xfs_vn_update_time+0x4e/0x130file_update_time+0xa7/0x100xfs_file_aio_write_checks+0x178/0x1a0
>>>> 2019-01-12 06:06:35     ?
>>>
>>> I'm not sure how reliable the stack is, but fwiw it looks like this is
>>> an aio that is waiting on transaction reservation to update a file time.
>>> Transaction reservation is a normal blocking path because log space is a
>>> finite resource. We certainly don't expect to block here for minutes,
>>> but the fact that we don't know anything about your filesystem geometry,
>>> mount options, underlying storage, workload, etc. will make it difficult
>>> for anybody to surmise what the problem could be.
>>>
>>> Please see the following url for what information to include when
>>> reporting a problem:
>>>
>>> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
>>>
>>> I'd also suggest to include broader dmesg output and/or xfs_repair
>>> output if there are multiple error reports that aren't exactly the same.
>>>
>>
>> I'm sorry, I missed this page on my search for an FAQ somehow.
>>
>>
>> * Kernel Version: Linux 4.12.0+139-ph #1 SMP Tue Jan 1 21:46:16 UTC 2019
>> x86_64 GNU/Linux
> 
> Is that an unmodified distro kernel or one you've patched and built
> yourself?

Unmodified regarding XFS and any subsystems related to XFS, as I was
being told.

> 
>> * xfsprogs version: 4.9.0
>>
>> * Single CPU, Xeon E5-1650 v3, 6 cores, 12 threads
>>
>> * /proc/meminfo, /proc/mounts, /proc/partitions and xfs_info can be
>> found here: https://pastebin.com/cZiTrUDL
> 
> Just  notes as I browse it.
> - lots of free memory.
> - xfs-info: 1.3TB, 32 ags, ~700MB log w/sunit =64fsbs
>   sunit=64 fsbs, swidth=192fsbs (RAID?)
> - mount options: noatime, sunit=512,sunit=1536, usrquota
> - /dev/sda3 mounted on /
> - /dev/sda3 also mounted on /home/tmp (bind mount of something?)
> 
>> * full dmesg output of problem mentioned in the first mail:
>> https://pastebin.com/pLaz18L1
> 
> No smoking gun.
> 
>> * a couple of more dmesg outputs from the same system with similar
>> behaviour:
>>  * https://pastebin.com/hWDbwcCr
>>  * https://pastebin.com/HAqs4yQc
> 
> Ok, so mysqld seems to be the problem child here.
> 

Our MySQL workload on this server is very small except for this time of
the day because our local backup to /backup happens during this time.
The highest IO happens during the night when our local backup is being
written. The timestamps of these two outputs suggest that the "mysql
dump" phase might just have been started. Unfortunately we only keep the
log of the last job, so I can't confirm that.

I might be able to dig up one or two more dmesg outputs for when these
hangs happen and no backup job is running.

>> * Raid Controller: Adaptec ASR8805
>>  * Logical Device 0 is a RAID6 with 5 SSDs (Samsung MZ7KM480), /dev/sda
> 
> Ok, so RAID6 on a RADI controller with 1GB cache and a small random
> write workload?
> 
>>  * Logical Device 1 is a single backup HDD (Seagate ST2000NX0253) for
>> internal backups, /dev/sdb
>>
>> * Output of xfs_repair: https://pastebin.com/JzVMqrLh
> 
> Nothing wrong at all. So this looks like it's either a log space
> accounting leak (i.e. XFS bug) or something else....
> 
>> The problem seems to happen randomly. There does not have to be high
>> load on our storage devices. This makes it pretty hard to find an exact
>> cause.
> 
> ... which makes me suspect "something else".
> 
> I note that nothing is stalled on reads from the device - it's all
> stalled on journal space (i.e. write operations). I've seen similar
> things before where the RAID controller is configured as a writeback
> cache and the workload just keeps dumping lots of small random writes
> into the RAID cache until it fills. Databases do lots of small
> writes.
> 
> This looks like the device is lightly loaded because writing into
> the cache is really fast. Right up until it fills and then has to
> dump hundreds of thousands of small writes to disk, which on RAID 6
> each require read-modify-raid-recalc-write cycles to run. This is
> really slow, and why RAID6 is generally a poor choice for database
> workloads.
> 
> i.e. when the RAID cache fills, new writes stalls waiting for a RAID
> cache flush - they run at slower than disk speed because they have
> to first wait for the RAID controller to comple.
> 
> It is is only noticed when the filesystem journal stalls
> because it's run out of space and is trying to dump a large amount
> of small metadata writes to the device to free up journal space. The
> journal space won't be freed up until the metadata that pins the
> tail of the log has been successfully written. When there's
> thousands of metadata IOs needed (a 700MB log can hold several
> hundred thousand dirty metadata objects in memory!) to move th elog
> forward, and the RAID cache is full, it will take a /long time/ and
> the filesystem will be stalled until that completes.
> 
> I've seen spinning disk RAID setups like this stall for hours while
> large RAID caches flush. SSDs should be a lot faster, but we're
> still potentially talking about having to do millions of IOs and the
> RAID controller will be CPU bound on parity recalculatoins.  So this
> /may/ just be a result of the storage configuration and have nothing
> to do with XFS at all.
> 
> Which leads me to ask: what is your RAID cache setup - write-thru,
> write-back, etc?
> 

Our RAID6 cache configuration:

   Read-cache setting                       : Disabled
   Read-cache status                        : Off
   Write-cache setting                      : Disabled
   Write-cache status                       : Off

Full Configuration: https://pastebin.com/PdGatDY4


- Daniel
