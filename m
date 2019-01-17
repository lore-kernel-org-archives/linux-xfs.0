Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:12889 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725878AbfAQNu0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jan 2019 08:50:26 -0500
Reply-To: d.aberger@profihost.ag
Subject: Re: XFS filesystem hang
References: <645a3d40-47a5-0f7a-7565-821bbce103f2@profihost.ag>
 <20190117123427.GA37591@bfoster>
From: Daniel Aberger - Profihost AG <d.aberger@profihost.ag>
Message-ID: <8cf51b2c-6e9b-317a-16fc-9e47f916198e@profihost.ag>
Date: Thu, 17 Jan 2019 14:50:23 +0100
MIME-Version: 1.0
In-Reply-To: <20190117123427.GA37591@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, s.priebe@profihost.ag, n.fahldieck@profihost.ag

Am 17.01.19 um 13:34 schrieb Brian Foster:
> On Thu, Jan 17, 2019 at 12:14:11PM +0100, Daniel Aberger - Profihost AG wrote:
>> Hi,
>>
>> one of our servers crashed / hung several times in the past days with
>> similar errors regarding XFS. Unfortunately we are unable to interprete
>> the call trace of dmesg to pinpoint the exact problem and I hope you
>> could help me to do so.
>>
>> We already ran xfs_repair to ensure that there are no filesystem errors.
>>
>> Here is an example dmesg output of recent crash of the mentioned server:
>>
>> 2019-01-12 06:06:35     INFO: task mysqld:1171 blocked for more than 120
>> seconds.
> 
> This is not a crash but rather an indication from the kernel that this
> task has been sitting here for at least a couple minutes. This doesn't
> tell us whether the task will eventually recover or remain blocked
> indefinitely.
> 

Yes, you're right. Well I was referring to it as a crash since the
system does not respond to any inputs anymore and we have to perform a
REISUB to reboot it.

>> 2019-01-12 06:06:35     Tainted: G 4.12.0+139-ph #1
>> 2019-01-12 06:06:35     "echo 0 >
>> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> 2019-01-12 06:06:35     mysqld D 0 1171 1 0x00080000
>> 2019-01-12 06:06:35     Call Trace:
>> 2019-01-12 06:06:35     ? __schedule+0x3bc/0x820
>> 2019-01-12 06:06:35     ? strlcpy+0x31/0x40
>> 2019-01-12 06:06:35     ?
>> kernfs_path_from_node_locked+0x238/0x320schedule+0x32/0x80xlog_grant_head_wait+0xca/0x200xlog_grant_head_check+0x86/0xe0xfs_log_reserve+0xc7/0x1c0xfs_trans_reserve+0x169/0x1c0xfs_trans_alloc+0xb9/0x130xfs_vn_update_time+0x4e/0x130file_update_time+0xa7/0x100xfs_file_aio_write_checks+0x178/0x1a0
>> 2019-01-12 06:06:35     ?
> 
> I'm not sure how reliable the stack is, but fwiw it looks like this is
> an aio that is waiting on transaction reservation to update a file time.
> Transaction reservation is a normal blocking path because log space is a
> finite resource. We certainly don't expect to block here for minutes,
> but the fact that we don't know anything about your filesystem geometry,
> mount options, underlying storage, workload, etc. will make it difficult
> for anybody to surmise what the problem could be.
> 
> Please see the following url for what information to include when
> reporting a problem:
> 
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> 
> I'd also suggest to include broader dmesg output and/or xfs_repair
> output if there are multiple error reports that aren't exactly the same.
> 

I'm sorry, I missed this page on my search for an FAQ somehow.


* Kernel Version: Linux 4.12.0+139-ph #1 SMP Tue Jan 1 21:46:16 UTC 2019
x86_64 GNU/Linux

* xfsprogs version: 4.9.0

* Single CPU, Xeon E5-1650 v3, 6 cores, 12 threads

* /proc/meminfo, /proc/mounts, /proc/partitions and xfs_info can be
found here: https://pastebin.com/cZiTrUDL

* full dmesg output of problem mentioned in the first mail:
https://pastebin.com/pLaz18L1

* a couple of more dmesg outputs from the same system with similar
behaviour:
 * https://pastebin.com/hWDbwcCr
 * https://pastebin.com/HAqs4yQc

* Raid Controller: Adaptec ASR8805
 * Logical Device 0 is a RAID6 with 5 SSDs (Samsung MZ7KM480), /dev/sda
 * Logical Device 1 is a single backup HDD (Seagate ST2000NX0253) for
internal backups, /dev/sdb

* Output of xfs_repair: https://pastebin.com/JzVMqrLh

The problem seems to happen randomly. There does not have to be high
load on our storage devices. This makes it pretty hard to find an exact
cause.


- Daniel

> Brian
> 
>> ktime_get+0x3e/0xa0xfs_file_dio_aio_write+0xb1/0x230xfs_file_write_iter+0xff/0x150aio_write+0xf6/0x150
>> 2019-01-12 06:06:35     ? queue_unplugged+0x25/0xa0
>> 2019-01-12 06:06:35     ? kmem_cache_alloc+0xf7/0x570
>> 2019-01-12 06:06:35     ? do_io_submit+0x35c/0x690do_io_submit+0x35c/0x690
>> 2019-01-12 06:06:35     ?
>> do_syscall_64+0x74/0x150do_syscall_64+0x74/0x150entry_SYSCALL_64_after_hwframe+0x3d/0xa2
>> 2019-01-12 06:06:35     RIP: 0033:0x7f37aa6b6717
>> 2019-01-12 06:06:35     RSP: 002b:00007f32953f4228 EFLAGS: 00000206
>> ORIG_RAX: 00000000000000d1
>> 2019-01-12 06:06:35     RAX: ffffffffffffffda RBX: 00000000000040f6 RCX:
>> 00007f37aa6b6717
>> 2019-01-12 06:06:35     RDX: 00007f32953f4230 RSI: 0000000000000001 RDI:
>> 00007f37aaef9000
>> 2019-01-12 06:06:35     RBP: 00007f32953f4250 R08: 00007f32953f4230 R09:
>> 0000000000000000
>> 2019-01-12 06:06:35     R10: 0000000000010000 R11: 0000000000000206 R12:
>> 00007f32953f4370
>> 2019-01-12 06:06:35     R13: 00007f37a806d158 R14: 00007f32a5829b98 R15:
>> 00007f379df26100
>>
>> Thanks,
>>
>> Daniel
