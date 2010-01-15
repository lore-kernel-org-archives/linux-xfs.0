Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0F0pLt4051698 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 18:51:22 -0600
Received: from omr6.networksolutionsemail.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3623FF0DC55
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 16:52:12 -0800 (PST)
Received: from omr6.networksolutionsemail.com (omr6.networksolutionsemail.com
	[205.178.146.56]) by cuda.sgi.com with ESMTP id
	1YUYkv2xJypFNHpj for <xfs@oss.sgi.com>;
	Thu, 14 Jan 2010 16:52:12 -0800 (PST)
Received: from cm-omr5 (mail.networksolutionsemail.com [205.178.146.50])
	by omr6.networksolutionsemail.com (8.13.6/8.13.6) with ESMTP id
	o0F0qBuS031785 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 19:52:11 -0500
Message-ID: <4B4FBC3F.6050904@chaven.com>
Date: Thu, 14 Jan 2010 18:52:15 -0600
From: Steve Costaras <stevecs@chaven.com>
MIME-Version: 1.0
Subject: Re: XFS data corruption with high I/O even on Areca hardware raid
References: <4B4E6F3F.1090901@chaven.com>
	<20100114022409.GW17483@discord.disaster>
In-Reply-To: <20100114022409.GW17483@discord.disaster>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com



On 01/13/2010 20:24, Dave Chinner wrote:
> On Wed, Jan 13, 2010 at 07:11:27PM -0600, Steve Costaras wrote:
>    
>> Ok, I've been seeing a problem here since had to move over to XFS from
>> JFS due to file system size issues.   I am seeing XFS Data corruption
>> under ?heavy io?   Basically, what happens is that under heavy load
>> (i.e. if I'm doing say a xfs_fsr (which nearly always triggers the
>> freeze issue) on a volume the system hovers around 90% utilization for
>> the dm device for a while (sometimes an hour+, sometimes minutes) the
>> subsystem goes into 100% utilization and then freezes solid forcing me
>> to do a hard reboot of the box.
>>      
> xfs_fsr can cause a *large* amount of IO to be done, so it is no
> surprise that it can trigger high load bugs in hardware and
> software. XFS can trigger high load problems on hardware more
> readily than other filesystems because using direct IO (like xfs_fsr
> does) it can push far, far higher throughput to the starge subsystem
> than any other linux filesystem can.
>
> The fact that the IO subsystem is freezing at 100% elevator queue
> utilisation points to an IO never completing. This immediately makes
> me point a finger at either the RAID hardware or the driver - a bug
> in XFS is highly unlikely to cause this symptom as those stats are
> generated at layers lower than XFS.
>
> Next time you get a freeze, the output of:
>
> # echo w>  /proc/sysrq-trigger
>
> will tell use what the system is waiting on (i.e. why it is stuck)
>
> ...
>    

didn't want this to happen so soon, but another freeze just occured.  I 
have the output you mentioned above below.   Don't know if this helps 
pinpoint anything as to where the problem is more accurately.   I don't 
like the abort device commands to arcmsr, still have not heard anything 
from Areca support for them to look at it.



-------------
[ 3494.731923] arcmsr6: abort device command of scsi id = 0 lun = 5
[ 3511.746966] arcmsr6: abort device command of scsi id = 0 lun = 5
[ 3511.746978] arcmsr6: abort device command of scsi id = 0 lun = 7
[ 3528.759509] arcmsr6: abort device command of scsi id = 0 lun = 7
[ 3528.759520] arcmsr6: abort device command of scsi id = 0 lun = 7
[ 3545.782040] arcmsr6: abort device command of scsi id = 0 lun = 7
[ 3545.782052] arcmsr6: abort device command of scsi id = 0 lun = 6
[ 3562.785862] arcmsr6: abort device command of scsi id = 0 lun = 6
[ 3562.785872] arcmsr6: abort device command of scsi id = 0 lun = 6
[ 3579.798404] arcmsr6: abort device command of scsi id = 0 lun = 6
[ 3579.798410] arcmsr6: abort device command of scsi id = 0 lun = 5
[ 3580.294587] SysRq : Show Blocked State
[ 3580.294646]   task                        PC stack   pid father
[ 3580.294653] pdflush       D 0000000000000000     0   221      2
[ 3580.294658]  ffff8102330dfd80 0000000000000046 ffff81023ef6ce48 
ffff81023ef6d008
[ 3580.294664]  ffff81023ef6d0e8 ffffffff80682c80 ffffffff80682c80 
ffffffff80682c80
[ 3580.294668]  ffffffff8067f0a0 ffffffff80682c80 ffff8102330dc230 
ffff8102330dfd4c
[ 3580.294673] Call Trace:
[ 3580.294699]  [<ffffffff80248812>] __mod_timer+0xc2/0xe0
[ 3580.294706]  [<ffffffff80470dbf>] schedule_timeout+0x5f/0xd0
[ 3580.294711]  [<ffffffff802482d0>] process_timeout+0x0/0x10
[ 3580.294715]  [<ffffffff80470dba>] schedule_timeout+0x5a/0xd0
[ 3580.294721]  [<ffffffff8028e250>] pdflush+0x0/0x230
[ 3580.294724]  [<ffffffff80470ca8>] io_schedule_timeout+0x28/0x40
[ 3580.294728]  [<ffffffff80293cdb>] congestion_wait+0x6b/0x90
[ 3580.294732]  [<ffffffff80254530>] autoremove_wake_function+0x0/0x30
[ 3580.294736]  [<ffffffff802d67c8>] writeback_inodes+0xb8/0xd0
[ 3580.294739]  [<ffffffff8028e250>] pdflush+0x0/0x230
[ 3580.294743]  [<ffffffff8028dc1f>] background_writeout+0x3f/0xe0
[ 3580.294751]  [<ffffffff8028e250>] pdflush+0x0/0x230
[ 3580.294755]  [<ffffffff8028e3a0>] pdflush+0x150/0x230
[ 3580.294759]  [<ffffffff8028dbe0>] background_writeout+0x0/0xe0
[ 3580.294764]  [<ffffffff8025416b>] kthread+0x4b/0x80
[ 3580.294768]  [<ffffffff8020d1b8>] child_rip+0xa/0x12
[ 3580.294777]  [<ffffffff80254120>] kthread+0x0/0x80
[ 3580.294780]  [<ffffffff8020d1ae>] child_rip+0x0/0x12
[ 3580.294784]
[ 3580.294786] pdflush       D 0000000000000001     0   222      2
[ 3580.294791]  ffff8102330e1d80 0000000000000046 ffff81023f22c2c8 
ffff81023ef6d008
[ 3580.294797]  ffff81023ef6d0e8 ffffffff80682c80 ffffffff80682c80 
ffffffff80682c80
[ 3580.294801]  ffffffff8067f0a0 ffffffff80682c80 ffff8102330d8a20 
ffff8102330e1d4c
[ 3580.294805] Call Trace:
[ 3580.294817]  [<ffffffff80248812>] __mod_timer+0xc2/0xe0
[ 3580.294823]  [<ffffffff80470dbf>] schedule_timeout+0x5f/0xd0
[ 3580.294827]  [<ffffffff802482d0>] process_timeout+0x0/0x10
[ 3580.294832]  [<ffffffff80470dba>] schedule_timeout+0x5a/0xd0
[ 3580.294837]  [<ffffffff8028e250>] pdflush+0x0/0x230
[ 3580.294840]  [<ffffffff80470ca8>] io_schedule_timeout+0x28/0x40
[ 3580.294845]  [<ffffffff80293cdb>] congestion_wait+0x6b/0x90
[ 3580.294849]  [<ffffffff80254530>] autoremove_wake_function+0x0/0x30
[ 3580.294852]  [<ffffffff802d67c8>] writeback_inodes+0xb8/0xd0
[ 3580.294856]  [<ffffffff8028e250>] pdflush+0x0/0x230
[ 3580.294860]  [<ffffffff8028dc1f>] background_writeout+0x3f/0xe0
[ 3580.294868]  [<ffffffff8028e250>] pdflush+0x0/0x230
[ 3580.294872]  [<ffffffff8028e3a0>] pdflush+0x150/0x230
[ 3580.294875]  [<ffffffff8028dbe0>] background_writeout+0x0/0xe0
[ 3580.294880]  [<ffffffff8025416b>] kthread+0x4b/0x80
[ 3580.294884]  [<ffffffff8020d1b8>] child_rip+0xa/0x12
[ 3580.294893]  [<ffffffff80254120>] kthread+0x0/0x80
[ 3580.294896]  [<ffffffff8020d1ae>] child_rip+0x0/0x12
[ 3580.294900]
[ 3580.294905] scsi_eh_6     D ffff8100010549a0     0  3058      2
[ 3580.294908]  ffff810231c89db0 0000000000000046 ffff810231c89d78 
3031343839372e39
[ 3580.294915]  ffffffff8000205d ffffffff80682c80 ffffffff80682c80 
ffffffff80682c80
[ 3580.294919]  ffffffff8067f0a0 ffffffff80682c80 ffff810232978230 
ffff810231c89d7c
[ 3580.294923] Call Trace:
[ 3580.294938]  [<ffffffff80470dbf>] schedule_timeout+0x5f/0xd0
[ 3580.294943]  [<ffffffff802482d0>] process_timeout+0x0/0x10
[ 3580.294947]  [<ffffffff80470dba>] schedule_timeout+0x5a/0xd0
[ 3580.294952]  [<ffffffff80248847>] msleep+0x17/0x30
[ 3580.294958]  [<ffffffff8817430e>] :arcmsr:arcmsr_abort+0x8e/0x340
[ 3580.294974]  [<ffffffff8812a379>] 
:scsi_mod:scsi_error_handler+0x399/0x570
[ 3580.294991]  [<ffffffff88129fe0>] :scsi_mod:scsi_error_handler+0x0/0x570
[ 3580.294995]  [<ffffffff8025416b>] kthread+0x4b/0x80
[ 3580.295000]  [<ffffffff8020d1b8>] child_rip+0xa/0x12
[ 3580.295009]  [<ffffffff80254120>] kthread+0x0/0x80
[ 3580.295012]  [<ffffffff8020d1ae>] child_rip+0x0/0x12
[ 3580.295017]
[ 3580.295021] xfsdatad/0    D 0000000000000000     0  5741      2
[ 3580.295024]  ffff8102034f7e00 0000000000000046 0000000000000000 
ffff810001033880
[ 3580.295029]  ffff810233177818 ffffffff80682c80 ffffffff80682c80 
ffffffff80682c80
[ 3580.295034]  ffffffff8067f0a0 ffffffff80682c80 ffff810233177a00 
ffff8102034f7dcc
[ 3580.295038] Call Trace:
[ 3580.295053]  [<ffffffff80471dd5>] __down_write_nested+0x75/0xb0
[ 3580.295075]  [<ffffffff884bf0bf>] :xfs:xfs_ilock+0x6f/0xa0
[ 3580.295091]  [<ffffffff884e3810>] :xfs:xfs_setfilesize+0x40/0xc0
[ 3580.295104]  [<ffffffff884e3960>] :xfs:xfs_end_bio_written+0x0/0x20
[ 3580.295118]  [<ffffffff884e3970>] :xfs:xfs_end_bio_written+0x10/0x20
[ 3580.295123]  [<ffffffff8024fddc>] run_workqueue+0xcc/0x170
[ 3580.295126]  [<ffffffff80250970>] worker_thread+0x0/0x110
[ 3580.295129]  [<ffffffff80250970>] worker_thread+0x0/0x110
[ 3580.295132]  [<ffffffff80250a13>] worker_thread+0xa3/0x110
[ 3580.295137]  [<ffffffff80254530>] autoremove_wake_function+0x0/0x30
[ 3580.295141]  [<ffffffff80250970>] worker_thread+0x0/0x110
[ 3580.295146]  [<ffffffff80250970>] worker_thread+0x0/0x110
[ 3580.295150]  [<ffffffff8025416b>] kthread+0x4b/0x80
[ 3580.295153]  [<ffffffff8020d1b8>] child_rip+0xa/0x12
[ 3580.295162]  [<ffffffff80254120>] kthread+0x0/0x80
[ 3580.295166]  [<ffffffff8020d1ae>] child_rip+0x0/0x12
[ 3580.295170]
[ 3580.295174] xfssyncd      D 0000000000000000     0  5758      2
[ 3580.295177]  ffff810202521b30 0000000000000046 0000000000000000 
ffff810075ca8c00
[ 3580.295183]  ffff810075ca8c00 ffffffff80682c80 ffffffff80682c80 
ffffffff80682c80
[ 3580.295186]  ffffffff8067f0a0 ffffffff80682c80 ffff81023317b210 
ffff810202521afc
[ 3580.295190] Call Trace:
[ 3580.295202]  [<ffffffff803419b4>] get_request+0x1a4/0x350
[ 3580.295208]  [<ffffffff80470ce8>] io_schedule+0x28/0x40
[ 3580.295212]  [<ffffffff8034278c>] get_request_wait+0xec/0x190
[ 3580.295221]  [<ffffffff8804f661>] :dm_mod:__map_bio+0xd1/0x130
[ 3580.295226]  [<ffffffff80254530>] autoremove_wake_function+0x0/0x30
[ 3580.295234]  [<ffffffff880501bf>] :dm_mod:__split_bio+0xef/0x3e0
[ 3580.295240]  [<ffffffff80343b1c>] __make_request+0x8c/0x680
[ 3580.295246]  [<ffffffff803526b1>] __up_read+0x21/0xb0
[ 3580.295252]  [<ffffffff80340486>] generic_make_request+0x1e6/0x3e0
[ 3580.295262]  [<ffffffff803406f5>] submit_bio+0x75/0x100
[ 3580.295278]  [<ffffffff884e5d88>] :xfs:_xfs_buf_ioapply+0x198/0x350
[ 3580.295297]  [<ffffffff884e6a89>] :xfs:xfs_buf_iorequest+0x29/0x80
[ 3580.295312]  [<ffffffff884c9d68>] :xfs:xlog_bdstrat_cb+0x38/0x40
[ 3580.295327]  [<ffffffff884cb10e>] :xfs:xlog_sync+0x1fe/0x460
[ 3580.295346]  [<ffffffff884cc732>] :xfs:xlog_state_sync_all+0x1f2/0x220
[ 3580.295352]  [<ffffffff802486d2>] try_to_del_timer_sync+0x52/0x60
[ 3580.295370]  [<ffffffff884ccbfd>] :xfs:_xfs_log_force+0x5d/0x80
[ 3580.295386]  [<ffffffff884dba5b>] :xfs:xfs_syncsub+0x4b/0x300
[ 3580.295402]  [<ffffffff884eceb7>] :xfs:xfs_sync_worker+0x17/0x40
[ 3580.295416]  [<ffffffff884ed18d>] :xfs:xfssyncd+0x13d/0x1c0
[ 3580.295433]  [<ffffffff884ed050>] :xfs:xfssyncd+0x0/0x1c0
[ 3580.295438]  [<ffffffff8025416b>] kthread+0x4b/0x80
[ 3580.295443]  [<ffffffff8020d1b8>] child_rip+0xa/0x12
[ 3580.295451]  [<ffffffff80220720>] lapic_next_event+0x0/0x10
[ 3580.295457]  [<ffffffff80254120>] kthread+0x0/0x80
[ 3580.295461]  [<ffffffff8020d1ae>] child_rip+0x0/0x12
[ 3580.295466]
[ 3580.295479] vmware-vmx    D 0000000000000000     0  7317      1
[ 3580.295485]  ffff8101f1b53a48 0000000000000086 0000000000000000 
ffff810005d8ae38
[ 3580.295490]  ffff810075ca8600 ffffffff80682c80 ffffffff80682c80 
ffffffff80682c80
[ 3580.295493]  ffffffff8067f0a0 ffffffff80682c80 ffff810231d9fa00 
ffff8101f1b53a14
[ 3580.295497] Call Trace:
[ 3580.295512]  [<ffffffff80285a20>] sync_page+0x0/0x50
[ 3580.295515]  [<ffffffff80470ce8>] io_schedule+0x28/0x40
[ 3580.295520]  [<ffffffff80285a57>] sync_page+0x37/0x50
[ 3580.295523]  [<ffffffff80470fdf>] __wait_on_bit+0x4f/0x80
[ 3580.295529]  [<ffffffff80285d4d>] wait_on_page_bit+0x6d/0x80
[ 3580.295534]  [<ffffffff80254560>] wake_bit_function+0x0/0x30
[ 3580.295539]  [<ffffffff8028cc1a>] __writepage+0xa/0x30
[ 3580.295542]  [<ffffffff8028d2a2>] write_cache_pages+0x2b2/0x340
[ 3580.295544]  [<ffffffff8028cc10>] __writepage+0x0/0x30
[ 3580.295556]  [<ffffffff80286f3b>] generic_file_buffered_write+0x1fb/0x6b0
[ 3580.295562]  [<ffffffff8028d380>] do_writepages+0x20/0x40
[ 3580.295566]  [<ffffffff802867b2>] __filemap_fdatawrite_range+0x52/0x60
[ 3580.295574]  [<ffffffff80286974>] sync_page_range+0x74/0xe0
[ 3580.295590]  [<ffffffff884ec745>] :xfs:xfs_write+0x775/0x910
[ 3580.295608]  [<ffffffff802b5179>] do_sync_write+0xd9/0x120
[ 3580.295617]  [<ffffffff80254530>] autoremove_wake_function+0x0/0x30
[ 3580.295622]  [<ffffffff8024aa45>] group_send_sig_info+0x25/0x90
[ 3580.295628]  [<ffffffff8024ab01>] kill_pid_info+0x51/0x90
[ 3580.295631]  [<ffffffff80250d43>] find_pid_ns+0x3/0xd0
[ 3580.295638]  [<ffffffff802b5abd>] vfs_write+0xed/0x190
[ 3580.295643]  [<ffffffff802b6324>] sys_pwrite64+0x84/0xa0
[ 3580.295649]  [<ffffffff8020c39e>] system_call+0x7e/0x83
[ 3580.295657]
[ 3580.295662] bacula-fd     D 0000000000000000     0  7573      1
[ 3580.295666]  ffff810161529b98 0000000000000086 0000000000000000 
ffffffff8812cdce
[ 3580.295674]  ffffffff884e4450 ffffffff80682c80 ffffffff80682c80 
ffffffff80682c80
[ 3580.295681]  ffffffff8067f0a0 ffffffff80682c80 ffff810232c45a00 
ffff810161529b64
[ 3580.295687] Call Trace:
[ 3580.295698]  [<ffffffff8812cdce>] :scsi_mod:scsi_request_fn+0x25e/0x3d0
[ 3580.295712]  [<ffffffff884e4450>] :xfs:xfs_get_blocks+0x0/0x10
[ 3580.295724]  [<ffffffff80285a20>] sync_page+0x0/0x50
[ 3580.295727]  [<ffffffff80470ce8>] io_schedule+0x28/0x40
[ 3580.295732]  [<ffffffff80285a57>] sync_page+0x37/0x50
[ 3580.295735]  [<ffffffff80470eba>] __wait_on_bit_lock+0x4a/0x80
[ 3580.295742]  [<ffffffff802859ff>] __lock_page+0x5f/0x70
[ 3580.295746]  [<ffffffff80254560>] wake_bit_function+0x0/0x30
[ 3580.295750]  [<ffffffff802862b0>] do_generic_mapping_read+0x1c0/0x3c0
[ 3580.295754]  [<ffffffff802856d0>] file_read_actor+0x0/0x160
[ 3580.295764]  [<ffffffff80287d3f>] generic_file_aio_read+0xff/0x1b0
[ 3580.295784]  [<ffffffff884ebe9c>] :xfs:xfs_read+0x11c/0x250
[ 3580.295792]  [<ffffffff802b5299>] do_sync_read+0xd9/0x120
[ 3580.295801]  [<ffffffff80254530>] autoremove_wake_function+0x0/0x30
[ 3580.295808]  [<ffffffff804706b0>] thread_return+0x3a/0x59a
[ 3580.295817]  [<ffffffff802b5c4d>] vfs_read+0xed/0x190
[ 3580.295822]  [<ffffffff802b6133>] sys_read+0x53/0x90
[ 3580.295828]  [<ffffffff8020c39e>] system_call+0x7e/0x83
[ 3580.295836]
[ 3580.295841] smbd          D 0000000000000000     0  7596   6572
[ 3580.295846]  ffff8101400b7578 0000000000000086 0000000000000000 
ffffffff803401cd
[ 3580.295853]  ffff8101f1de7480 ffffffff80682c80 ffffffff80682c80 
ffffffff80682c80
[ 3580.295860]  ffffffff8067f0a0 ffffffff80682c80 ffff81016154e230 
ffff8101400b7544
[ 3580.295865] Call Trace:
[ 3580.295869]  [<ffffffff803401cd>] blk_recount_segments+0x3d/0x80
[ 3580.295878]  [<ffffffff803419b4>] get_request+0x1a4/0x350
[ 3580.295885]  [<ffffffff80470ce8>] io_schedule+0x28/0x40
[ 3580.295890]  [<ffffffff8034278c>] get_request_wait+0xec/0x190
[ 3580.295897]  [<ffffffff8804f661>] :dm_mod:__map_bio+0xd1/0x130
[ 3580.295902]  [<ffffffff80254530>] autoremove_wake_function+0x0/0x30
[ 3580.295906]  [<ffffffff80341326>] ll_back_merge_fn+0x146/0x240
[ 3580.295912]  [<ffffffff80343b1c>] __make_request+0x8c/0x680
[ 3580.295918]  [<ffffffff803526b1>] __up_read+0x21/0xb0
[ 3580.295923]  [<ffffffff80340486>] generic_make_request+0x1e6/0x3e0
[ 3580.295927]  [<ffffffff8028f5f9>] __pagevec_release+0x19/0x30
[ 3580.295935]  [<ffffffff803406f5>] submit_bio+0x75/0x100
[ 3580.295939]  [<ffffffff802de566>] __bio_add_page+0x1a6/0x210
[ 3580.295955]  [<ffffffff884e40ee>] :xfs:xfs_submit_ioend_bio+0x1e/0x30
[ 3580.295970]  [<ffffffff884e41de>] :xfs:xfs_submit_ioend+0xbe/0xe0
[ 3580.295986]  [<ffffffff884e50e6>] :xfs:xfs_page_state_convert+0x3a6/0x660
[ 3580.296012]  [<ffffffff884e54df>] :xfs:xfs_vm_writepage+0x6f/0x120
[ 3580.296017]  [<ffffffff8028cc1a>] __writepage+0xa/0x30
[ 3580.296021]  [<ffffffff8028d23e>] write_cache_pages+0x24e/0x340
[ 3580.296024]  [<ffffffff8028cc10>] __writepage+0x0/0x30
[ 3580.296039]  [<ffffffff8028d380>] do_writepages+0x20/0x40
[ 3580.296043]  [<ffffffff802d5bf0>] __writeback_single_inode+0xb0/0x380
[ 3580.296054]  [<ffffffff802d62b9>] sync_sb_inodes+0x1f9/0x300
[ 3580.296061]  [<ffffffff802d67a2>] writeback_inodes+0x92/0xd0
[ 3580.296065]  [<ffffffff8028d9bc>] 
balance_dirty_pages_ratelimited_nr+0x25c/0x360
[ 3580.296078]  [<ffffffff80286f3b>] generic_file_buffered_write+0x1fb/0x6b0
[ 3580.296105]  [<ffffffff884ec646>] :xfs:xfs_write+0x676/0x910
[ 3580.296117]  [<ffffffff80315e22>] __key_link+0x162/0x330
[ 3580.296125]  [<ffffffff802b5179>] do_sync_write+0xd9/0x120
[ 3580.296134]  [<ffffffff80254530>] autoremove_wake_function+0x0/0x30
[ 3580.296142]  [<ffffffff802c7204>] fcntl_setlk+0x54/0x2f0
[ 3580.296150]  [<ffffffff802b5abd>] vfs_write+0xed/0x190
[ 3580.296155]  [<ffffffff802b6324>] sys_pwrite64+0x84/0xa0
[ 3580.296159]  [<ffffffff802c2ade>] sys_fcntl+0x6e/0x370
[ 3580.296164]  [<ffffffff8020c39e>] system_call+0x7e/0x83
[ 3580.296172]
[ 3580.296174] sync          D 0000000000000000     0  7639   7636
[ 3580.296179]  ffff810146023bb8 0000000000000086 ffff8100378d55a0 
ffff810202540228
[ 3580.296187]  ffff810231808000 ffffffff80682c80 ffffffff80682c80 
ffffffff80682c80
[ 3580.296193]  ffffffff8067f0a0 ffffffff80682c80 ffff8101dd1caa20 
ffffffff8033e44b
[ 3580.296199] Call Trace:
[ 3580.296207]  [<ffffffff8033e44b>] elv_next_request+0x5b/0x1f0
[ 3580.296221]  [<ffffffff8812cdce>] :scsi_mod:scsi_request_fn+0x25e/0x3d0
[ 3580.296228]  [<ffffffff80472287>] __down+0xa7/0x11f
[ 3580.296233]  [<ffffffff80236540>] default_wake_function+0x0/0x10
[ 3580.296246]  [<ffffffff884e5d88>] :xfs:_xfs_buf_ioapply+0x198/0x350
[ 3580.296252]  [<ffffffff80471f06>] __down_failed+0x35/0x3a
[ 3580.296262]  [<ffffffff8812cb70>] :scsi_mod:scsi_request_fn+0x0/0x3d0
[ 3580.296268]  [<ffffffff8034f100>] kobject_release+0x0/0x10
[ 3580.296283]  [<ffffffff884e56a6>] :xfs:xfs_buf_iowait+0x46/0x50
[ 3580.296297]  [<ffffffff884e7b76>] :xfs:xfs_buf_read_flags+0x66/0xa0
[ 3580.296313]  [<ffffffff884d87b4>] :xfs:xfs_trans_read_buf+0x64/0x340
[ 3580.296332]  [<ffffffff884c1f11>] :xfs:xfs_itobp+0x81/0x1e0
[ 3580.296336]  [<ffffffff8028d0fc>] write_cache_pages+0x10c/0x340
[ 3580.296355]  [<ffffffff884c48fe>] :xfs:xfs_iflush+0xfe/0x520
[ 3580.296359]  [<ffffffff80285864>] find_get_pages_tag+0x34/0x90
[ 3580.296363]  [<ffffffff80352612>] __down_read_trylock+0x42/0x60
[ 3580.296380]  [<ffffffff884df0d9>] :xfs:xfs_inode_flush+0x179/0x1b0
[ 3580.296396]  [<ffffffff884ecd38>] :xfs:xfs_fs_write_inode+0x28/0x70
[ 3580.296401]  [<ffffffff802d5dec>] __writeback_single_inode+0x2ac/0x380
[ 3580.296405]  [<ffffffff8028ecfa>] pagevec_lookup_tag+0x1a/0x30
[ 3580.296409]  [<ffffffff80286673>] wait_on_page_writeback_range+0x73/0x140
[ 3580.296417]  [<ffffffff802d62b9>] sync_sb_inodes+0x1f9/0x300
[ 3580.296424]  [<ffffffff802d6454>] sync_inodes_sb+0x94/0xb0
[ 3580.296430]  [<ffffffff802d64e9>] __sync_inodes+0x79/0xc0
[ 3580.296435]  [<ffffffff802d6541>] sync_inodes+0x11/0x30
[ 3580.296438]  [<ffffffff802d9672>] do_sync+0x12/0x70
[ 3580.296441]  [<ffffffff802d96de>] sys_sync+0xe/0x20
[ 3580.296445]  [<ffffffff8020c39e>] system_call+0x7e/0x83
[ 3580.296453]
[ 3580.296455] sh            D 0000000000000000     0  7640   7638
[ 3580.296461]  ffff810161fd1b18 0000000000000082 0000000000000000 
ffffffff802e2e60
[ 3580.296468]  ffffffff884e4450 ffffffff80682c80 ffffffff80682c80 
ffffffff80682c80
[ 3580.296474]  ffffffff8067f0a0 ffffffff80682c80 ffff810190c46a20 
ffff810161fd1ae4
[ 3580.296480] Call Trace:
[ 3580.296485]  [<ffffffff802e2e60>] mpage_readpages+0xe0/0x100
[ 3580.296499]  [<ffffffff884e4450>] :xfs:xfs_get_blocks+0x0/0x10
[ 3580.296511]  [<ffffffff80285a20>] sync_page+0x0/0x50
[ 3580.296515]  [<ffffffff80470ce8>] io_schedule+0x28/0x40
[ 3580.296519]  [<ffffffff80285a57>] sync_page+0x37/0x50
[ 3580.296522]  [<ffffffff80470eba>] __wait_on_bit_lock+0x4a/0x80
[ 3580.296528]  [<ffffffff802859ff>] __lock_page+0x5f/0x70
[ 3580.296532]  [<ffffffff80254560>] wake_bit_function+0x0/0x30
[ 3580.296537]  [<ffffffff802862b0>] do_generic_mapping_read+0x1c0/0x3c0
[ 3580.296540]  [<ffffffff80232311>] update_curr+0x71/0x100
[ 3580.296543]  [<ffffffff802856d0>] file_read_actor+0x0/0x160
[ 3580.296552]  [<ffffffff80287d3f>] generic_file_aio_read+0xff/0x1b0
[ 3580.296572]  [<ffffffff884ebe9c>] :xfs:xfs_read+0x11c/0x250
[ 3580.296575]  [<ffffffff8029352d>] zone_statistics+0x7d/0x80
[ 3580.296583]  [<ffffffff802b5299>] do_sync_read+0xd9/0x120
[ 3580.296591]  [<ffffffff80254530>] autoremove_wake_function+0x0/0x30
[ 3580.296596]  [<ffffffff80334e44>] aa_register_find+0x54/0x170
[ 3580.296602]  [<ffffffff80335e2a>] aa_register+0x19a/0x500
[ 3580.296611]  [<ffffffff802b5c4d>] vfs_read+0xed/0x190
[ 3580.296616]  [<ffffffff802b9be8>] kernel_read+0x38/0x50
[ 3580.296620]  [<ffffffff802bb8f5>] do_execve+0x165/0x220
[ 3580.296626]  [<ffffffff8020ae74>] sys_execve+0x44/0xb0
[ 3580.296631]  [<ffffffff8020c767>] stub_execve+0x67/0xb0
[ 3580.296642]
[ 3580.296644] smbd          D 0000000000000000     0  7641   6572
[ 3580.296649]  ffff8101a08fd878 0000000000000082 0000000000000000 
ffff810231c70000
[ 3580.296655]  ffff8101f1de7500 ffffffff80682c80 ffffffff80682c80 
ffffffff80682c80
[ 3580.296662]  ffffffff8067f0a0 ffffffff80682c80 ffff81016154f210 
ffff8101a08fd844
[ 3580.296667] Call Trace:
[ 3580.296682]  [<ffffffff80472287>] __down+0xa7/0x11f
[ 3580.296686]  [<ffffffff80236540>] default_wake_function+0x0/0x10
[ 3580.296701]  [<ffffffff884e5d88>] :xfs:_xfs_buf_ioapply+0x198/0x350
[ 3580.296706]  [<ffffffff80471f06>] __down_failed+0x35/0x3a
[ 3580.296723]  [<ffffffff884e56a6>] :xfs:xfs_buf_iowait+0x46/0x50
[ 3580.296738]  [<ffffffff884e7b76>] :xfs:xfs_buf_read_flags+0x66/0xa0
[ 3580.296754]  [<ffffffff884d87b4>] :xfs:xfs_trans_read_buf+0x64/0x340
[ 3580.296772]  [<ffffffff884c1f11>] :xfs:xfs_itobp+0x81/0x1e0
[ 3580.296792]  [<ffffffff884c5245>] :xfs:xfs_iread+0x85/0x220
[ 3580.296797]  [<ffffffff802af0cd>] __slab_alloc+0x1bd/0x410
[ 3580.296815]  [<ffffffff884bf831>] :xfs:xfs_iget_core+0x1e1/0x710
[ 3580.296839]  [<ffffffff884bfe47>] :xfs:xfs_iget+0xe7/0x160
[ 3580.296858]  [<ffffffff884d9a1d>] :xfs:xfs_dir_lookup_int+0x8d/0xf0
[ 3580.296876]  [<ffffffff884ddc15>] :xfs:xfs_lookup+0x75/0xa0
[ 3580.296893]  [<ffffffff884eaea1>] :xfs:xfs_vn_lookup+0x31/0x70
[ 3580.296898]  [<ffffffff802bda46>] do_lookup+0x1b6/0x250
[ 3580.296906]  [<ffffffff802bf8cb>] __link_path_walk+0x14b/0xe90
[ 3580.296915]  [<ffffffff802c066b>] link_path_walk+0x5b/0x100
[ 3580.296923]  [<ffffffff802c82af>] dput+0x1f/0x130
[ 3580.296927]  [<ffffffff802cda57>] mntput_no_expire+0x27/0xb0
[ 3580.296931]  [<ffffffff802c0691>] link_path_walk+0x81/0x100
[ 3580.296937]  [<ffffffff802c092a>] do_path_lookup+0x8a/0x250
[ 3580.296941]  [<ffffffff802bf4c9>] getname+0x1a9/0x220
[ 3580.296946]  [<ffffffff802c158b>] __user_walk_fd+0x4b/0x80
[ 3580.296951]  [<ffffffff802b917f>] vfs_stat_fd+0x2f/0x80
[ 3580.296957]  [<ffffffff802c82af>] dput+0x1f/0x130
[ 3580.296961]  [<ffffffff802cda57>] mntput_no_expire+0x27/0xb0
[ 3580.296966]  [<ffffffff802b48e0>] sys_chdir+0x60/0x90
[ 3580.296969]  [<ffffffff802b9267>] sys_newstat+0x27/0x50
[ 3580.296975]  [<ffffffff8024cf52>] set_user+0xa2/0xc0
[ 3580.296979]  [<ffffffff8024f074>] sys_setresuid+0x194/0x200
[ 3580.296985]  [<ffffffff8020c39e>] system_call+0x7e/0x83
[ 3580.296994]
[ 3580.296997] Sched Debug Version: v0.07, 2.6.24-26-server #1
[ 3580.296999] now at 3429623.454505 msecs
[ 3580.297001]   .sysctl_sched_latency                    : 60.000000
[ 3580.297004]   .sysctl_sched_min_granularity            : 12.000000
[ 3580.297006]   .sysctl_sched_wakeup_granularity         : 30.000000
[ 3580.297008]   .sysctl_sched_batch_wakeup_granularity   : 30.000000
[ 3580.297010]   .sysctl_sched_child_runs_first           : 0.000001
[ 3580.297013]   .sysctl_sched_features                   : 7
[ 3580.297015]
[ 3580.297016] cpu#0, 2404.113 MHz
[ 3580.297018]   .nr_running                    : 1
[ 3580.297020]   .load                          : 1024
[ 3580.297022]   .nr_switches                   : 7933994
[ 3580.297024]   .nr_load_updates               : 242407
[ 3580.297026]   .nr_uninterruptible            : -68690
[ 3580.297028]   .jiffies                       : 4295280258
[ 3580.297029]   .next_balance                  : 4295.280276
[ 3580.297032]   .curr->pid                     : 7288
[ 3580.297033]   .clock                         : 2424072.408800
[ 3580.297035]   .idle_clock                    : 0.000000
[ 3580.297037]   .prev_clock_raw                : 3580293.550258
[ 3580.297039]   .clock_warps                   : 0
[ 3580.297041]   .clock_overflows               : 2476352
[ 3580.297044]   .clock_deep_idle_events        : 0
[ 3580.297045]   .clock_max_delta               : 9.999980
[ 3580.297047]   .cpu_load[0]                   : 1024
[ 3580.297049]   .cpu_load[1]                   : 1024
[ 3580.297051]   .cpu_load[2]                   : 1024
[ 3580.297053]   .cpu_load[3]                   : 1024
[ 3580.297055]   .cpu_load[4]                   : 1024
[ 3580.297057]
[ 3580.297058] cfs_rq
[ 3580.297059]   .exec_clock                    : 0.000000
[ 3580.297062]   .MIN_vruntime                  : 0.000001
[ 3580.297064]   .min_vruntime                  : 552420.036852
[ 3580.297066]   .max_vruntime                  : 0.000001
[ 3580.297068]   .spread                        : 0.000000
[ 3580.297070]   .spread0                       : 0.000000
[ 3580.297072]   .nr_running                    : 1
[ 3580.297074]   .load                          : 1024
[ 3580.297075]   .nr_spread_over                : 0
[ 3580.297077]
[ 3580.297078] cfs_rq
[ 3580.297080]   .exec_clock                    : 0.000000
[ 3580.297082]   .MIN_vruntime                  : 0.000001
[ 3580.297084]   .min_vruntime                  : 552420.036852
[ 3580.297087]   .max_vruntime                  : 0.000001
[ 3580.297089]   .spread                        : 0.000000
[ 3580.297091]   .spread0                       : 0.000000
[ 3580.297092]   .nr_running                    : 1
[ 3580.297094]   .load                          : 1024
[ 3580.297096]   .nr_spread_over                : 0
[ 3580.297098]
[ 3580.297099] runnable tasks:
[ 3580.297099]             task   PID         tree-key  switches  
prio     exec-runtime         sum-exec        sum-sleep
[ 3580.297100] 
----------------------------------------------------------------------------------------------------------
[ 3580.297106] R     vmware-vmx  7288    518608.234067    320744   
120               0               0               0.000000               
0.000000               0.000000
[ 3580.297114]
[ 3580.297114] cpu#1, 2404.113 MHz
[ 3580.297116]   .nr_running                    : 2
[ 3580.297118]   .load                          : 2048
[ 3580.297120]   .nr_switches                   : 5422548
[ 3580.297121]   .nr_load_updates               : 244834
[ 3580.297123]   .nr_uninterruptible            : 56347
[ 3580.297126]   .jiffies                       : 4295280258
[ 3580.297128]   .next_balance                  : 4295.280257
[ 3580.297130]   .curr->pid                     : 7338
[ 3580.297132]   .clock                         : 2448350.962052
[ 3580.297134]   .idle_clock                    : 0.000000
[ 3580.297136]   .prev_clock_raw                : 3580296.984746
[ 3580.297137]   .clock_warps                   : 0
[ 3580.297139]   .clock_overflows               : 1027944
[ 3580.297141]   .clock_deep_idle_events        : 0
[ 3580.297143]   .clock_max_delta               : 9.999794
[ 3580.297145]   .cpu_load[0]                   : 0
[ 3580.297147]   .cpu_load[1]                   : 0
[ 3580.297149]   .cpu_load[2]                   : 139
[ 3580.297151]   .cpu_load[3]                   : 1532
[ 3580.297153]   .cpu_load[4]                   : 3045
[ 3580.297155]
[ 3580.297155] cfs_rq
[ 3580.297157]   .exec_clock                    : 0.000000
[ 3580.297159]   .MIN_vruntime                  : 0.000001
[ 3580.297161]   .min_vruntime                  : 437151.747709
[ 3580.297163]   .max_vruntime                  : 0.000001
[ 3580.297165]   .spread                        : 0.000000
[ 3580.297167]   .spread0                       : -115268.289143
[ 3580.297169]   .nr_running                    : 1
[ 3580.297171]   .load                          : 1024
[ 3580.297173]   .nr_spread_over                : 0
[ 3580.297175]
[ 3580.297175] cfs_rq
[ 3580.297177]   .exec_clock                    : 0.000000
[ 3580.297179]   .MIN_vruntime                  : 406855.054398
[ 3580.297181]   .min_vruntime                  : 437151.747709
[ 3580.297183]   .max_vruntime                  : 406855.054398
[ 3580.297185]   .spread                        : 0.000000
[ 3580.297188]   .spread0                       : -115268.289143
[ 3580.297190]   .nr_running                    : 2
[ 3580.297191]   .load                          : 2048
[ 3580.297193]   .nr_spread_over                : 0
[ 3580.297195]
[ 3580.297196] runnable tasks:
[ 3580.297196]             task   PID         tree-key  switches  
prio     exec-runtime         sum-exec        sum-sleep
[ 3580.297197] 
----------------------------------------------------------------------------------------------------------
[ 3580.297200]          syslogd  6216    406855.054398      2895   
120               0               0               0.000000               
0.000000               0.000000
[ 3580.297207] R           bash  7338    406855.172049      1400   
120               0               0               0.000000               
0.000000               0.000000
[ 3580.297215]
[ 3580.297215] cpu#2, 2404.113 MHz
[ 3580.297217]   .nr_running                    : 1
[ 3580.297219]   .load                          : 1024
[ 3580.297221]   .nr_switches                   : 1440663
[ 3580.297223]   .nr_load_updates               : 276188
[ 3580.297225]   .nr_uninterruptible            : 6380
[ 3580.297227]   .jiffies                       : 4295280258
[ 3580.297229]   .next_balance                  : 4295.280283
[ 3580.297231]   .curr->pid                     : 6235
[ 3580.297233]   .clock                         : 2761880.177500
[ 3580.297235]   .idle_clock                    : 0.000000
[ 3580.297237]   .prev_clock_raw                : 3580296.056586
[ 3580.297239]   .clock_warps                   : 0
[ 3580.297242]   .clock_overflows               : 214421
[ 3580.297243]   .clock_deep_idle_events        : 0
[ 3580.297245]   .clock_max_delta               : 9.999999
[ 3580.297247]   .cpu_load[0]                   : 1024
[ 3580.297249]   .cpu_load[1]                   : 512
[ 3580.297251]   .cpu_load[2]                   : 256
[ 3580.297253]   .cpu_load[3]                   : 128
[ 3580.297255]   .cpu_load[4]                   : 64
[ 3580.297257]
[ 3580.297257] cfs_rq
[ 3580.297259]   .exec_clock                    : 0.000000
[ 3580.297261]   .MIN_vruntime                  : 0.000001
[ 3580.297264]   .min_vruntime                  : 102512.690078
[ 3580.297265]   .max_vruntime                  : 0.000001
[ 3580.297268]   .spread                        : 0.000000
[ 3580.297269]   .spread0                       : -449907.346774
[ 3580.297271]   .nr_running                    : 1
[ 3580.297273]   .load                          : 1024
[ 3580.297275]   .nr_spread_over                : 0
[ 3580.297277]
[ 3580.297278] cfs_rq
[ 3580.297279]   .exec_clock                    : 0.000000
[ 3580.297282]   .MIN_vruntime                  : 0.000001
[ 3580.297284]   .min_vruntime                  : 102512.690078
[ 3580.297286]   .max_vruntime                  : 0.000001
[ 3580.297288]   .spread                        : 0.000000
[ 3580.297290]   .spread0                       : -449907.346774
[ 3580.297292]   .nr_running                    : 1
[ 3580.297294]   .load                          : 1024
[ 3580.297296]   .nr_spread_over                : 0
[ 3580.297298]
[ 3580.297298] runnable tasks:
[ 3580.297299]             task   PID         tree-key  switches  
prio     exec-runtime         sum-exec        sum-sleep
[ 3580.297300] 
----------------------------------------------------------------------------------------------------------
[ 3580.297303] R             dd  6235    115167.502387       274   
120               0               0               0.000000               
0.000000               0.000000
[ 3580.297311]
[ 3580.297311] cpu#3, 2404.113 MHz
[ 3580.297313]   .nr_running                    : 0
[ 3580.297315]   .load                          : 0
[ 3580.297317]   .nr_switches                   : 1591451
[ 3580.297320]   .nr_load_updates               : 227045
[ 3580.297322]   .nr_uninterruptible            : 5974
[ 3580.297323]   .jiffies                       : 4295280258
[ 3580.297325]   .next_balance                  : 4295.280259
[ 3580.297327]   .curr->pid                     : 0
[ 3580.297329]   .clock                         : 2270450.190151
[ 3580.297331]   .idle_clock                    : 0.000000
[ 3580.297334]   .prev_clock_raw                : 3580297.313151
[ 3580.297336]   .clock_warps                   : 0
[ 3580.297337]   .clock_overflows               : 226883
[ 3580.297339]   .clock_deep_idle_events        : 0
[ 3580.297341]   .clock_max_delta               : 9.999865
[ 3580.297343]   .cpu_load[0]                   : 0
[ 3580.297345]   .cpu_load[1]                   : 0
[ 3580.297347]   .cpu_load[2]                   : 0
[ 3580.297349]   .cpu_load[3]                   : 0
[ 3580.297351]   .cpu_load[4]                   : 0
[ 3580.297353]
[ 3580.297353] cfs_rq
[ 3580.297355]   .exec_clock                    : 0.000000
[ 3580.297358]   .MIN_vruntime                  : 0.000001
[ 3580.297360]   .min_vruntime                  : 118343.625154
[ 3580.297362]   .max_vruntime                  : 0.000001
[ 3580.297364]   .spread                        : 0.000000
[ 3580.297366]   .spread0                       : -434076.411698
[ 3580.297368]   .nr_running                    : 0
[ 3580.297370]   .load                          : 0
[ 3580.297372]   .nr_spread_over                : 0
[ 3580.297374]
[ 3580.297374] cfs_rq
[ 3580.297376]   .exec_clock                    : 0.000000
[ 3580.297378]   .MIN_vruntime                  : 0.000001
[ 3580.297380]   .min_vruntime                  : 118343.625154
[ 3580.297383]   .max_vruntime                  : 0.000001
[ 3580.297385]   .spread                        : 0.000000
[ 3580.297387]   .spread0                       : -434076.411698
[ 3580.297389]   .nr_running                    : 0
[ 3580.297391]   .load                          : 0
[ 3580.297393]   .nr_spread_over                : 0
[ 3580.297395]
[ 3580.297395] runnable tasks:
[ 3580.297396]             task   PID         tree-key  switches  
prio     exec-runtime         sum-exec        sum-sleep
[ 3580.297397] 
----------------------------------------------------------------------------------------------------------
[ 3580.297401]
----------------
iostat -m -x 5 output:
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           10.28    0.00   11.55    7.56    0.00   70.61

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     8.40    0.20    3.00     0.00     0.04    
29.00     0.00    0.62   0.62   0.20
sdb              10.20    36.00  120.60   34.40     8.18     5.25   
177.44     0.23    1.48   0.92  14.20
sdc              53.80    30.60   77.80   36.60     8.18     5.34   
242.03     0.24    2.10   1.19  13.60
sdd              10.00    36.60  120.80   37.60     8.18     5.31   
174.36     0.27    1.69   0.90  14.20
sde              54.60    33.40   76.40   36.80     8.19     5.39   
245.68     0.25    2.23   1.22  13.80
sdf               9.60    36.80  121.40   25.80     8.18     3.99   
169.23     5.16    0.99   2.08  30.60
sdg              54.80    32.20   76.00   24.80     8.18     4.01   
247.63     4.53    1.39   2.98  30.00
sdh               9.80    39.00  121.00   24.00     8.18     3.99   
171.88     4.86    1.10   2.25  32.60
sdi              54.40    33.40   76.40   23.20     8.18     4.02   
250.78     4.65    1.57   3.13  31.20
dm-0              0.00     0.00  523.60    0.00    65.45     0.00   
256.00     0.77    0.70   0.97  50.60
dm-1              0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00
dm-2              0.00     0.00    1.00  222.60     0.01    42.50   
389.30    20.40    3.54   1.18  26.40

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.42    0.00    6.51   30.68    0.00   62.39

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00    10.00    0.00    8.20     0.00     0.07    
17.76     0.00    0.00   0.00   0.00
sdb               0.00    17.80    0.00   14.80     0.00     2.42   
334.27     0.12    7.84   3.51   5.20
sdc               0.00    18.20    0.00   13.00     0.00     2.40   
378.34     0.13   10.15   4.31   5.60
sdd               0.00    17.80    0.00   16.20     0.00     2.42   
306.17     0.13    8.27   3.33   5.40
sde               0.00    16.60    0.00   16.80     0.00     2.43   
295.90     0.12    7.02   3.10   5.20
sdf               0.00    18.80    0.00    0.00     0.00     0.00     
0.00    99.53    0.00   0.00 100.00
sdg               0.00    17.40    0.00    0.00     0.00     0.00     
0.00    96.46    0.00   0.00 100.00
sdh               0.00    18.20    0.00    0.00     0.00     0.00     
0.00   101.26    0.00   0.00 100.00
sdi               0.00    19.00    0.00    0.00     0.00     0.00     
0.00   103.05    0.00   0.00 100.00
dm-0              0.00     0.00    0.00    0.00     0.00     0.00     
0.00     2.00    0.00   0.00 100.00
dm-1              0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00
dm-2              0.00     0.00    0.00  112.20     0.00    19.53   
356.53   476.04    2.76   8.91 100.00

-------------


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
