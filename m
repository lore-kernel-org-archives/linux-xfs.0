Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 904EA7F47
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 22:33:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3B9D48F8294
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 20:33:34 -0700 (PDT)
Received: from mail-ig0-f177.google.com (mail-ig0-f177.google.com
	[209.85.213.177]) by cuda.sgi.com with ESMTP id
	yKEF96ZBsirpa6xx (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 12 May 2014 20:33:32 -0700 (PDT)
Received: by mail-ig0-f177.google.com with SMTP id l13so4705504iga.4
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 20:33:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANGgnMa80WwQ8zSkL52yYegmQURVQeZiBFv41=FQXMZJ_NaEDw@mail.gmail.com>
References: <CANGgnMYPLF+8616Rs9eQOXUc9He2NSgFnNrvHvepV-x+pWS6oQ@mail.gmail.com>
	<20140305233551.GK6851@dastard>
	<CANGgnMb=2dYGQO4K36pQ9LEb8E4rT6S_VskLF+n=ndd0_kJr_g@mail.gmail.com>
	<CANGgnMa80WwQ8zSkL52yYegmQURVQeZiBFv41=FQXMZJ_NaEDw@mail.gmail.com>
Date: Mon, 12 May 2014 20:33:31 -0700
Message-ID: <CANGgnMbdL+qOsQaWGHR2-joiHTHkez5DpzhSn5b2-EiDFveY9w@mail.gmail.com>
Subject: Re: XFS crash?
From: Austin Schuh <austin@peloton-tech.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs <xfs@oss.sgi.com>

On Mon, May 12, 2014 at 6:29 PM, Austin Schuh <austin@peloton-tech.com> wrote:
> On Wed, Mar 5, 2014 at 4:53 PM, Austin Schuh <austin@peloton-tech.com> wrote:
>> Hi Dave,
>>
>> On Wed, Mar 5, 2014 at 3:35 PM, Dave Chinner <david@fromorbit.com> wrote:
>>> On Wed, Mar 05, 2014 at 03:08:16PM -0800, Austin Schuh wrote:
>>>> Howdy,
>>>>
>>>> I'm running a config_preempt_rt patched version of the 3.10.11 kernel,
>>>> and I'm seeing a couple lockups and crashes which I think are related
>>>> to XFS.
>>>
>>> I think they ar emore likely related to RT issues....
>>>
>>
>> That very well may be true.
>>
>>> Your usb device has disconnected and gone down the device
>>> removal/invalidate partition route. and it's trying to flush the
>>> device, which is stuck on IO completion which is stuck waiting for
>>> the device error handling to error them out.
>>>
>>> So, this is a block device problem error handling problem caused by
>>> device unplug getting stuck because it's decided to ask the
>>> filesystem to complete operations that can't be completed until the
>>> device error handling progress far enough to error out the IOs that
>>> the filesystem is waiting for completion on.
>>>
>>> Cheers,
>>>
>>> Dave.
>>> --
>>> Dave Chinner
>>> david@fromorbit.com
>
> I had the issue reproduce itself today with just the main SSD
> installed.  This was on a new machine that was built this morning.
> There is a lot less going on in this trace than the previous one.


Fun times...  I rebooted the machine (had to power cycle it to get it
to go down), repeated the same set of commands and it locked up again.

I ran apt-get update; dpkg --configure -a; apt-get update; apt-get
upgrade, and then it locked up during the upgrade.  It was in the
middle of unpacking a 348 MB package.

[  241.634377] INFO: task kworker/1:2:60 blocked for more than 120 seconds.
[  241.641284] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  241.648252] kworker/1:2     D ffff880429ed10c0     0    60      2 0x00000000
[  241.648310] Workqueue: xfs-data/sda5 xfs_end_io [xfs]
[  241.648320]  ffff880429ed10c0 0000000000000046 ffffffffffffffff
ffff8804240053c0
[  241.648327]  0000000000062cc0 ffff880429f4dfd8 0000000000062cc0
ffff880429f4dfd8
[  241.648331]  0000000000000001 ffff880429ed10c0 ffff8803eb87dac0
0000000000000002
[  241.648339] Call Trace:
[  241.648358]  [<ffffffff813a1f93>] ? schedule+0x6b/0x7c
[  241.648365]  [<ffffffff813a2438>] ? __rt_mutex_slowlock+0x7b/0xb4
[  241.648371]  [<ffffffff813a2577>] ? rt_mutex_slowlock+0xe5/0x150
[  241.648380]  [<ffffffff8100c02f>] ? load_TLS+0x7/0xa
[  241.648415]  [<ffffffffa00a9adb>] ? xfs_setfilesize+0x48/0x120 [xfs]
[  241.648423]  [<ffffffff81063d25>] ? finish_task_switch+0x80/0xc6
[  241.648447]  [<ffffffffa00aa62f>] ? xfs_end_io+0x7a/0x8e [xfs]
[  241.648455]  [<ffffffff81055a49>] ? process_one_work+0x19b/0x2b2
[  241.648462]  [<ffffffff81055f41>] ? worker_thread+0x12b/0x1f6
[  241.648468]  [<ffffffff81055e16>] ? rescuer_thread+0x28f/0x28f
[  241.648473]  [<ffffffff8105a909>] ? kthread+0x81/0x89
[  241.648481]  [<ffffffff8105a888>] ? __kthread_parkme+0x5c/0x5c
[  241.648487]  [<ffffffff813a75fc>] ? ret_from_fork+0x7c/0xb0
[  241.648492]  [<ffffffff8105a888>] ? __kthread_parkme+0x5c/0x5c
[  241.648531] INFO: task dpkg:5181 blocked for more than 120 seconds.
[  241.655649] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  241.662711] dpkg            D ffff88042e0e2cc0     0  5181   5153 0x00000000
[  241.662727]  ffff8804240053c0 0000000000000086 0000000000000018
ffff88042b0cece0
[  241.662731]  0000000000062cc0 ffff88042989dfd8 0000000000062cc0
ffff88042989dfd8
[  241.662735]  ffff88042989d8e8 ffff8804240053c0 ffff88042989da10
ffff88042989da08
[  241.662742] Call Trace:
[  241.662754]  [<ffffffff813a10ef>] ? console_conditional_schedule+0xf/0xf
[  241.662760]  [<ffffffff813a1f93>] ? schedule+0x6b/0x7c
[  241.662767]  [<ffffffff813a111b>] ? schedule_timeout+0x2c/0x123
[  241.662772]  [<ffffffff813a5c20>] ? add_preempt_count+0xb7/0xe0
[  241.662777]  [<ffffffff81065cfd>] ? migrate_enable+0x1cd/0x1dd
[  241.662786]  [<ffffffff810651ab>] ? get_parent_ip+0x9/0x1b
[  241.662791]  [<ffffffff813a5c20>] ? add_preempt_count+0xb7/0xe0
[  241.662797]  [<ffffffff813a188b>] ? __wait_for_common+0x78/0xd6
[  241.662845]  [<ffffffffa00d0032>] ? xfs_bmapi_allocate+0x92/0x9e [xfs]
[  241.662878]  [<ffffffffa00d035d>] ? xfs_bmapi_write+0x31f/0x558 [xfs]
[  241.662884]  [<ffffffff81063d25>] ? finish_task_switch+0x80/0xc6
[  241.662924]  [<ffffffffa00cde6e>] ? __xfs_bmapi_allocate+0x22b/0x22b [xfs]
[  241.662950]  [<ffffffffa00b6899>] ?
xfs_iomap_write_allocate+0x1bc/0x2c8 [xfs]
[  241.662977]  [<ffffffffa00a9dc5>] ? xfs_map_blocks+0x125/0x1f5 [xfs]
[  241.663001]  [<ffffffffa00aac87>] ? xfs_vm_writepage+0x266/0x48f [xfs]
[  241.663010]  [<ffffffff810d3d14>] ? __writepage+0xd/0x2a
[  241.663014]  [<ffffffff810d4790>] ? write_cache_pages+0x207/0x302
[  241.663018]  [<ffffffff810d3d07>] ? page_index+0x14/0x14
[  241.663025]  [<ffffffff810d48c6>] ? generic_writepages+0x3b/0x57
[  241.663034]  [<ffffffff810cd303>] ? __filemap_fdatawrite_range+0x50/0x55
[  241.663039]  [<ffffffff81138a63>] ? SyS_sync_file_range+0xe2/0x127
[  241.663047]  [<ffffffff813a76a9>] ? system_call_fastpath+0x16/0x1b

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
