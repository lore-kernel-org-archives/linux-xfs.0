Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7308F7F3F
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 22:10:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DBD36AC009
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 20:10:15 -0700 (PDT)
Received: from mail-ie0-f172.google.com (mail-ie0-f172.google.com
	[209.85.223.172]) by cuda.sgi.com with ESMTP id
	bd7KZxMU5rzMRPxp (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 12 May 2014 20:10:10 -0700 (PDT)
Received: by mail-ie0-f172.google.com with SMTP id as1so8026639iec.3
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 20:10:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANGgnMa80WwQ8zSkL52yYegmQURVQeZiBFv41=FQXMZJ_NaEDw@mail.gmail.com>
References: <CANGgnMYPLF+8616Rs9eQOXUc9He2NSgFnNrvHvepV-x+pWS6oQ@mail.gmail.com>
	<20140305233551.GK6851@dastard>
	<CANGgnMb=2dYGQO4K36pQ9LEb8E4rT6S_VskLF+n=ndd0_kJr_g@mail.gmail.com>
	<CANGgnMa80WwQ8zSkL52yYegmQURVQeZiBFv41=FQXMZJ_NaEDw@mail.gmail.com>
Date: Mon, 12 May 2014 20:10:10 -0700
Message-ID: <CANGgnMbaQ4hcPHoZYa9LH2VacB9Z2pe-Pi6DPvK-ePRbCdLXTA@mail.gmail.com>
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
>
> [  360.448156] INFO: task kworker/1:1:42 blocked for more than 120 seconds.
> [  360.450266] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  360.452404] kworker/1:1     D ffff88042e0e2cc0     0    42      2 0x00000000
> [  360.452429] Workqueue: xfs-data/sda5 xfs_end_io [xfs]
> [  360.452432]  ffff88042af38000 0000000000000046 0000000000000000
> ffff88042b0cece0
> [  360.452433]  0000000000062cc0 ffff88042af1ffd8 0000000000062cc0
> ffff88042af1ffd8
> [  360.452435]  0000000000062cc0 ffff88042af38000 ffff8803eac3be40
> 0000000000000002
> [  360.452437] Call Trace:
> [  360.452443]  [<ffffffff813a1f93>] ? schedule+0x6b/0x7c
> [  360.452445]  [<ffffffff813a2438>] ? __rt_mutex_slowlock+0x7b/0xb4
> [  360.452447]  [<ffffffff813a2577>] ? rt_mutex_slowlock+0xe5/0x150
> [  360.452455]  [<ffffffffa0099adb>] ? xfs_setfilesize+0x48/0x120 [xfs]
> [  360.452462]  [<ffffffffa009a62f>] ? xfs_end_io+0x7a/0x8e [xfs]
> [  360.452465]  [<ffffffff81055a49>] ? process_one_work+0x19b/0x2b2
> [  360.452468]  [<ffffffff81055f41>] ? worker_thread+0x12b/0x1f6
> [  360.452469]  [<ffffffff81055e16>] ? rescuer_thread+0x28f/0x28f
> [  360.452471]  [<ffffffff8105a909>] ? kthread+0x81/0x89
> [  360.452473]  [<ffffffff8105a888>] ? __kthread_parkme+0x5c/0x5c
> [  360.452475]  [<ffffffff813a75fc>] ? ret_from_fork+0x7c/0xb0
> [  360.452477]  [<ffffffff8105a888>] ? __kthread_parkme+0x5c/0x5c
> [  360.452483] INFO: task kworker/u16:4:222 blocked for more than 120 seconds.
> [  360.454614] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  360.456801] kworker/u16:4   D ffff88042e062cc0     0   222      2 0x00000000
> [  360.456807] Workqueue: writeback bdi_writeback_workfn (flush-8:0)
> [  360.456810]  ffff88042af3cb60 0000000000000046 ffff8804292a0000
> ffffffff81616400
> [  360.456812]  0000000000062cc0 ffff8804292a1fd8 0000000000062cc0
> ffff8804292a1fd8
> [  360.456813]  ffff8804292a1978 ffff88042af3cb60 ffff88042af3cb60
> ffff8804292a1a50
> [  360.456815] Call Trace:
> [  360.456819]  [<ffffffff810cc034>] ? __lock_page+0x66/0x66
> [  360.456822]  [<ffffffff813a1f93>] ? schedule+0x6b/0x7c
> [  360.456824]  [<ffffffff813a1ff9>] ? io_schedule+0x55/0x6b
> [  360.456825]  [<ffffffff810cc03a>] ? sleep_on_page+0x6/0xa
> [  360.456827]  [<ffffffff813a137a>] ? __wait_on_bit_lock+0x3c/0x85
> [  360.456829]  [<ffffffff810cc4a4>] ? find_get_pages_tag+0xfa/0x125
> [  360.456831]  [<ffffffff810cc02f>] ? __lock_page+0x61/0x66
> [  360.456833]  [<ffffffff8105b333>] ? autoremove_wake_function+0x2a/0x2a
> [  360.456835]  [<ffffffff810d4700>] ? write_cache_pages+0x177/0x302
> [  360.456836]  [<ffffffff810d3d07>] ? page_index+0x14/0x14
> [  360.456838]  [<ffffffff810d48c6>] ? generic_writepages+0x3b/0x57
> [  360.456840]  [<ffffffff81134698>] ? __writeback_single_inode+0x72/0x225
> [  360.456842]  [<ffffffff8113550b>] ? writeback_sb_inodes+0x215/0x36d
> [  360.456844]  [<ffffffff811356cc>] ? __writeback_inodes_wb+0x69/0xab
> [  360.456846]  [<ffffffff81135844>] ? wb_writeback+0x136/0x2a7
> [  360.456848]  [<ffffffff81135c88>] ? wb_do_writeback+0x161/0x1dc
> [  360.456851]  [<ffffffff81135d66>] ? bdi_writeback_workfn+0x63/0xf4
> [  360.456852]  [<ffffffff81055a49>] ? process_one_work+0x19b/0x2b2
> [  360.456854]  [<ffffffff81055f41>] ? worker_thread+0x12b/0x1f6
> [  360.456856]  [<ffffffff81055e16>] ? rescuer_thread+0x28f/0x28f
> [  360.456857]  [<ffffffff8105a909>] ? kthread+0x81/0x89
> [  360.456859]  [<ffffffff8105a888>] ? __kthread_parkme+0x5c/0x5c
> [  360.456860]  [<ffffffff813a75fc>] ? ret_from_fork+0x7c/0xb0
> [  360.456862]  [<ffffffff8105a888>] ? __kthread_parkme+0x5c/0x5c
> [  360.456881] INFO: task dpkg:5140 blocked for more than 120 seconds.
> [  360.459062] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  360.461283] dpkg            D ffff88042e0e2cc0     0  5140   5112 0x00000000
> [  360.461287]  ffff8804290d2180 0000000000000086 000000000000020c
> ffff88042af38000
> [  360.461289]  0000000000062cc0 ffff880429bf7fd8 0000000000062cc0
> ffff880429bf7fd8
> [  360.461290]  ffff880429bf78e8 ffff8804290d2180 ffff880429bf7a10
> ffff880429bf7a08
> [  360.461292] Call Trace:
> [  360.461296]  [<ffffffff813a10ef>] ? console_conditional_schedule+0xf/0xf
> [  360.461298]  [<ffffffff813a1f93>] ? schedule+0x6b/0x7c
> [  360.461299]  [<ffffffff813a111b>] ? schedule_timeout+0x2c/0x123
> [  360.461301]  [<ffffffff813a5c20>] ? add_preempt_count+0xb7/0xe0
> [  360.461303]  [<ffffffff81065cfd>] ? migrate_enable+0x1cd/0x1dd
> [  360.461306]  [<ffffffff810651ab>] ? get_parent_ip+0x9/0x1b
> [  360.461308]  [<ffffffff813a5c20>] ? add_preempt_count+0xb7/0xe0
> [  360.461310]  [<ffffffff813a188b>] ? __wait_for_common+0x78/0xd6
> [  360.461323]  [<ffffffffa00c0032>] ? xfs_bmapi_allocate+0x92/0x9e [xfs]
> [  360.461333]  [<ffffffffa00c035d>] ? xfs_bmapi_write+0x31f/0x558 [xfs]
> [  360.461336]  [<ffffffff81109680>] ? kmem_cache_alloc+0x7c/0x17d
> [  360.461346]  [<ffffffffa00bde6e>] ? __xfs_bmapi_allocate+0x22b/0x22b [xfs]
> [  360.461354]  [<ffffffffa00a6899>] ?
> xfs_iomap_write_allocate+0x1bc/0x2c8 [xfs]
> [  360.461362]  [<ffffffffa0099dc5>] ? xfs_map_blocks+0x125/0x1f5 [xfs]
> [  360.461369]  [<ffffffffa009ac87>] ? xfs_vm_writepage+0x266/0x48f [xfs]
> [  360.461371]  [<ffffffff810d3d14>] ? __writepage+0xd/0x2a
> [  360.461372]  [<ffffffff810d4790>] ? write_cache_pages+0x207/0x302
> [  360.461374]  [<ffffffff810d3d07>] ? page_index+0x14/0x14
> [  360.461376]  [<ffffffff810d48c6>] ? generic_writepages+0x3b/0x57
> [  360.461378]  [<ffffffff810cd303>] ? __filemap_fdatawrite_range+0x50/0x55
> [  360.461380]  [<ffffffff81138a63>] ? SyS_sync_file_range+0xe2/0x127
> [  360.461382]  [<ffffffff813a76a9>] ? system_call_fastpath+0x16/0x1b
>
> Austin

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
