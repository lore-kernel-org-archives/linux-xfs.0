Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from amazon.4net.rs ([159.69.148.70]:48914 "EHLO amazon.4net.rs"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727065AbeLMIV1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Dec 2018 03:21:27 -0500
Received: from localhost (amazon.4net.co.rs [127.0.0.1])
        by amazon.4net.rs (Postfix) with ESMTP id 86B016286A98
        for <linux-xfs@vger.kernel.org>; Thu, 13 Dec 2018 09:17:33 +0100 (CET)
Received: from amazon.4net.rs ([127.0.0.1])
        by localhost (amazon.dyn.4net.co.rs [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id zijPtXnwB5NN for <linux-xfs@vger.kernel.org>;
        Thu, 13 Dec 2018 09:17:31 +0100 (CET)
Received: from mail.4net.rs (green.4net.rs [10.188.221.8])
        by amazon.4net.rs (Postfix) with ESMTP id 4A22263BDF64
        for <linux-xfs@vger.kernel.org>; Thu, 13 Dec 2018 09:17:31 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by mail.4net.rs (Postfix) with ESMTP id 47E4DCB7B785C
        for <linux-xfs@vger.kernel.org>; Thu, 13 Dec 2018 09:21:19 +0100 (CET)
Received: from mail.4net.rs ([127.0.0.1])
        by localhost (green.4net.rs [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8ZDqiATyMbkx for <linux-xfs@vger.kernel.org>;
        Thu, 13 Dec 2018 09:21:19 +0100 (CET)
Received: from mail.4net.rs (localhost [127.0.0.1])
        by mail.4net.rs (Postfix) with ESMTP id DF6F6C9A6B021
        for <linux-xfs@vger.kernel.org>; Thu, 13 Dec 2018 09:21:18 +0100 (CET)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by mail.4net.rs (Postfix) with ESMTPSA id 963A9C9A6B016
        for <linux-xfs@vger.kernel.org>; Thu, 13 Dec 2018 09:21:18 +0100 (CET)
From: Sinisa <sinisa@4net.rs>
Subject: Re: XFS and RAID10 with o2 layout
References: <d9fc0327-eef3-63bd-82a3-98545251bfe5@4net.rs>
 <20181212143056.GA23748@bfoster>
Message-ID: <51c73b61-e9e1-b8cf-cb6f-916fc616fa60@4net.rs>
Date: Thu, 13 Dec 2018 09:21:18 +0100
MIME-Version: 1.0
In-Reply-To: <20181212143056.GA23748@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Thanks for a quick reply. Replies are inline...

On 12.12.2018 15:30, Brian Foster wrote:
> cc linux-raid
>
> On Wed, Dec 12, 2018 at 01:29:49PM +0100, Sinisa wrote:
>> Hello group,
>>
>> I have noticed something strange going on lately, but recently I have come
>> to conclusion that there is some unwanted interaction between XFS and Linux
>> RAID10 with "offset" layout.
>>
>> So here is the problem: I create a Linux RAID10 mirror with 2 disks (HDD or
>> SSD) and "o2" layout (best choice for read and write speed):
>> # mdadm -C -n2 -l10 -po2 /dev/mdX /dev/sdaX /dev/sdbX
>> # mkfs.xfs /dev/mdX
>> # mount /dev/mdX /mnt
>> # rsync -avxDPHS / /mnt
>>
>> So we have RAID10 initializing:
>>
>> # cat /proc/mdstat
>> Personalities : [raid1] [raid10]
>> md2 : active raid10 sdb3[1] sda3[0]
>>       314433536 blocks super 1.2 4096K chunks 2 offset-copies [2/2] [UU]
>>       [==>..................]  resync = 11.7% (36917568/314433536)
>> finish=8678.2min speed=532K/sec
>>       bitmap: 3/3 pages [12KB], 65536KB chunk
>>
>> but after a few minutes everything stops like you can see above. Rsync (or
>> any other process writing to that md device) also freezes. If I try to read
>> already copied files - freeze, usually with less that 2GB copied.
>>
>
> Does the same thing happen without the RAID initialization? E.g., if you
> wait for it to complete or (IIRC) if you create with --assume-clean? I
> assume the init-in-progress state is common with your tests on other
> filesystems?
>

No, if I wait for RAID to finish initializing, or create it with 
--assume-clean, everything works just fine.

Actualy, ever since openSUSE LEAP 15.0 release I have been doing just that: 
pause installation process until initialization is done, then let it go on.

But recently it has happened so that I had to replace one of the disks in a 
"live" system (small file server), and was unable to do that on multiple tries 
during work hours because of this problem. When I waited until afternoon, when 
nobody was working/writing, resync was able to finish...


> A few more notes below inline to the log..
>
>> Sometimes in dmesg I get some kernel messages about "task kworker/2:1:55
>> blocked for more than 480 seconds." (please see attached dmesg.txt and my
>> reports here: https://bugzilla.opensuse.org/show_bug.cgi?id=1111073),
>> sometimes nothing at all. When this happens, I can only reboot with SysRq-b
>> or "physically" with reset/power button.
>>
>> Same thing can happen with "far" layout, but it seems to me that it does not
>> happen every time (or that often). I might be wrong, because I never use
>> "far" layout in real life, only for testing.
>> I was unable to reproduce the failure with "near" layout.
>>
>> Also with EXT4 or BTRFS and any layout everything works just as it should,
>> that is sync goes on until finished, and rsync, cp, or any other write work
>> just fine at the same time.
>>
>> Let me just add that I first saw this behavior in openSUSE LEAP 15.0 (kernel
>> 4.12). In previous versions (up to kernel 4.4) I never had this problem. In
>> the meantime I have tested with kernels up to 4.20rc and it is the same.
>> Unfortunately I cannot go back to test kernels 4.5 - 4.11 to pinpoint the
>> moment the problem first appeared.
>>
>>
>>
>> --
>> Best regards,
>> Siniša Bandin
>> (excuse my English)
>>
>
>> [ 180.981499] SGI XFS with ACLs, security attributes, no debug enabled
>> [ 181.005019] XFS (md1): Mounting V5 Filesystem
>> [ 181.132076] XFS (md1): Starting recovery (logdev: internal)
>> [ 181.295606] XFS (md1): Ending recovery (logdev: internal)
>> [ 181.804011] XFS (md1): Unmounting Filesystem
>> [ 182.201794] XFS (md127): Mounting V4 Filesystem
>> [ 182.736958] md: recovery of RAID array md127
>> [ 182.915479] XFS (md127): Ending clean mount
>> [ 183.819702] XFS (md127): Unmounting Filesystem
>> [ 184.943831] EXT4-fs (md0): mounted filesystem with ordered data mode. 
>> Opts: (null)
>> [ 529.784557] EXT4-fs (md0): mounted filesystem with ordered data mode. 
>> Opts: (null)
>> [ 601.789958] md1: detected capacity change from 33284947968 to 0
>> [ 601.789973] md: md1 stopped.
>> [ 602.314112] md0: detected capacity change from 550436864 to 0
>> [ 602.314128] md: md0 stopped.
>> [ 602.745030] md: md127: recovery interrupted.
>> [ 603.131684] md127: detected capacity change from 966229229568 to 0
>> [ 603.132237] md: md127 stopped.
>> [ 603.435808] sda: sda1 sda2
>> [ 603.594074] udevd[5011]: inotify_add_watch(11, /dev/sda2, 10) failed: No 
>> such file or directory
>> [ 603.643959] sda:
>> [ 603.844724] sdb: sdb1 sdb2
>> [ 604.255407] sdb: sdb1
>> [ 604.490214] udevd[5050]: inotify_add_watch(11, /dev/sdb1, 10) failed: No 
>> such file or directory
>> [ 605.140952] sdb: sdb1
>> [ 605.628686] sdb: sdb1 sdb2
>> [ 606.271192] sdb: sdb1 sdb2 sdb3
>> [ 607.079626] sdb: sdb1 sdb2 sdb3
>> [ 607.611092] sda:
>> [ 608.273201] sda: sda1
>> [ 608.611952] sda: sda1 sda2
>> [ 609.031326] sda: sda1 sda2 sda3
>> [ 609.753140] md/raid10:md1: not clean -- starting background reconstruction
>> [ 609.753145] md/raid10:md1: active with 2 out of 2 devices
>> [ 609.768804] md1: detected capacity change from 0 to 32210157568
>> [ 609.772677] md: resync of RAID array md1
>> [ 614.590107] XFS (md1): Mounting V5 Filesystem
>> [ 615.449035] XFS (md1): Ending clean mount
>> [ 617.678462] md/raid1:md0: not clean -- starting background reconstruction
>> [ 617.678469] md/raid1:md0: active with 2 out of 2 mirrors
>> [ 617.740729] md0: detected capacity change from 0 to 524222464
>> [ 617.747107] md: delaying resync of md0 until md1 has finished (they share 
>> one or more physical units)
>
> What are md0 and md1? Note that I don't see md2 anywhere in this log.
>

Sorry that I did not clarify that immediately, this log was taken earlier, 
during installation, when I got to see it in dmesg.
md0 was /boot (with EXT4), md1 was / with XFS.

Example of cat /proc/mdstat was taken later, when I brought up the system (by 
changing md1 to "near" layout at install time). So wherever you see md1 or md2, 
you can assume they are the same thing: new RAID10/o2 being written to during 
initialization. But second time there was nothing in dmesg, so I could not 
attach that.


>> [ 620.037818] EXT4-fs (md0): mounted filesystem with ordered data mode. 
>> Opts: (null)
>> [ 1463.754785] INFO: task kworker/0:3:227 blocked for more than 480 seconds.
>> [ 1463.754793] Not tainted 4.19.5-1-default #1
>> [ 1463.754795] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables 
>> this message.
>> [ 1463.754799] kworker/0:3 D 0 227 2 0x80000000
>> [ 1463.755000] Workqueue: xfs-eofblocks/md1 xfs_eofblocks_worker [xfs]
>> [ 1463.755005] Call Trace:
>> [ 1463.755025] ? __schedule+0x29a/0x880
>> [ 1463.755032] ? rwsem_down_write_failed+0x197/0x350
>> [ 1463.755038] schedule+0x78/0x110
>> [ 1463.755044] rwsem_down_write_failed+0x197/0x350
>> [ 1463.755055] call_rwsem_down_write_failed+0x13/0x20
>> [ 1463.755061] down_write+0x20/0x30
>
> So we have a background task blocked on an inode lock.
>
>> [ 1463.755196] xfs_free_eofblocks+0x114/0x1a0 [xfs]
>> [ 1463.755330] xfs_inode_free_eofblocks+0xd3/0x1e0 [xfs]
>> [ 1463.755459] ? xfs_inode_ag_walk_grab+0x5b/0x90 [xfs]
>> [ 1463.755586] xfs_inode_ag_walk.isra.15+0x1aa/0x420 [xfs]
>> [ 1463.755714] ? __xfs_inode_clear_blocks_tag+0x120/0x120 [xfs]
>> [ 1463.755727] ? trace_hardirqs_on_thunk+0x1a/0x1c
>> [ 1463.755734] ? __switch_to_asm+0x40/0x70
>> [ 1463.755738] ? __switch_to_asm+0x34/0x70
>> [ 1463.755743] ? __switch_to_asm+0x40/0x70
>> [ 1463.755748] ? __switch_to_asm+0x34/0x70
>> [ 1463.755752] ? __switch_to_asm+0x40/0x70
>> [ 1463.755757] ? __switch_to_asm+0x34/0x70
>> [ 1463.755762] ? __switch_to_asm+0x40/0x70
>> [ 1463.755893] ? __xfs_inode_clear_blocks_tag+0x120/0x120 [xfs]
>> [ 1463.755900] ? radix_tree_gang_lookup_tag+0xc2/0x140
>> [ 1463.756032] ? __xfs_inode_clear_blocks_tag+0x120/0x120 [xfs]
>> [ 1463.756158] xfs_inode_ag_iterator_tag+0x73/0xb0 [xfs]
>> [ 1463.756288] xfs_eofblocks_worker+0x29/0x40 [xfs]
>> [ 1463.756298] process_one_work+0x1fd/0x420
>> [ 1463.756305] worker_thread+0x2d/0x3d0
>> [ 1463.756311] ? rescuer_thread+0x340/0x340
>> [ 1463.756316] kthread+0x112/0x130
>> [ 1463.756322] ? kthread_create_worker_on_cpu+0x40/0x40
>> [ 1463.756329] ret_from_fork+0x3a/0x50
>> [ 1463.756375] INFO: task kworker/u4:0:4615 blocked for more than 480 seconds.
>> [ 1463.756379] Not tainted 4.19.5-1-default #1
>> [ 1463.756380] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables 
>> this message.
>> [ 1463.756383] kworker/u4:0 D 0 4615 2 0x80000000
>> [ 1463.756395] Workqueue: writeback wb_workfn (flush-9:1)
>> [ 1463.756400] Call Trace:
>> [ 1463.756409] ? __schedule+0x29a/0x880
>> [ 1463.756420] ? wait_barrier+0xdd/0x170 [raid10]
>> [ 1463.756426] schedule+0x78/0x110
>> [ 1463.756433] wait_barrier+0xdd/0x170 [raid10]
>> [ 1463.756440] ? wait_woken+0x80/0x80
>> [ 1463.756448] raid10_write_request+0xf2/0x900 [raid10]
>> [ 1463.756454] ? wait_woken+0x80/0x80
>> [ 1463.756459] ? mempool_alloc+0x55/0x160
>> [ 1463.756483] ? md_write_start+0xa9/0x270 [md_mod]
>> [ 1463.756492] raid10_make_request+0xc1/0x120 [raid10]
>> [ 1463.756498] ? wait_woken+0x80/0x80
>> [ 1463.756514] md_handle_request+0x121/0x190 [md_mod]
>> [ 1463.756535] md_make_request+0x78/0x190 [md_mod]
>> [ 1463.756544] generic_make_request+0x1c6/0x470
>> [ 1463.756553] submit_bio+0x45/0x140
>
> Writeback is blocked submitting I/O down in the MD driver.
>
>> [ 1463.756714] xfs_submit_ioend+0x9c/0x1e0 [xfs]
>> [ 1463.756844] xfs_vm_writepages+0x68/0x80 [xfs]
>> [ 1463.756856] do_writepages+0x31/0xb0
>> [ 1463.756865] ? read_hpet+0x126/0x130
>> [ 1463.756873] ? ktime_get+0x36/0xa0
>> [ 1463.756881] __writeback_single_inode+0x3d/0x3e0
>> [ 1463.756889] writeback_sb_inodes+0x1c4/0x430
>> [ 1463.756902] __writeback_inodes_wb+0x5d/0xb0
>> [ 1463.756910] wb_writeback+0x26b/0x310
>> [ 1463.756920] wb_workfn+0x33a/0x410
>> [ 1463.756932] process_one_work+0x1fd/0x420
>> [ 1463.756940] worker_thread+0x2d/0x3d0
>> [ 1463.756946] ? rescuer_thread+0x340/0x340
>> [ 1463.756951] kthread+0x112/0x130
>> [ 1463.756957] ? kthread_create_worker_on_cpu+0x40/0x40
>> [ 1463.756965] ret_from_fork+0x3a/0x50
>> [ 1463.756979] INFO: task kworker/0:2:4994 blocked for more than 480 seconds.
>> [ 1463.756982] Not tainted 4.19.5-1-default #1
>> [ 1463.756984] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables 
>> this message.
>> [ 1463.756987] kworker/0:2 D 0 4994 2 0x80000000
>> [ 1463.757013] Workqueue: md submit_flushes [md_mod]
>> [ 1463.757016] Call Trace:
>> [ 1463.757024] ? __schedule+0x29a/0x880
>> [ 1463.757034] ? wait_barrier+0xdd/0x170 [raid10]
>> [ 1463.757039] schedule+0x78/0x110
>> [ 1463.757047] wait_barrier+0xdd/0x170 [raid10]
>> [ 1463.757054] ? wait_woken+0x80/0x80
>> [ 1463.757062] raid10_write_request+0xf2/0x900 [raid10]
>> [ 1463.757067] ? wait_woken+0x80/0x80
>> [ 1463.757072] ? mempool_alloc+0x55/0x160
>> [ 1463.757088] ? md_write_start+0xa9/0x270 [md_mod]
>> [ 1463.757095] ? trace_hardirqs_off_thunk+0x1a/0x1c
>> [ 1463.757104] raid10_make_request+0xc1/0x120 [raid10]
>> [ 1463.757110] ? wait_woken+0x80/0x80
>> [ 1463.757126] md_handle_request+0x121/0x190 [md_mod]
>> [ 1463.757132] ? _raw_spin_unlock_irq+0x22/0x40
>> [ 1463.757137] ? finish_task_switch+0x74/0x260
>> [ 1463.757156] submit_flushes+0x21/0x40 [md_mod]
>
> Some other MD task (?) also blocked submitting a request.
>
>> [ 1463.757163] process_one_work+0x1fd/0x420
>> [ 1463.757170] worker_thread+0x2d/0x3d0
>> [ 1463.757177] ? rescuer_thread+0x340/0x340
>> [ 1463.757181] kthread+0x112/0x130
>> [ 1463.757186] ? kthread_create_worker_on_cpu+0x40/0x40
>> [ 1463.757193] ret_from_fork+0x3a/0x50
>> [ 1463.757205] INFO: task md1_resync:5215 blocked for more than 480 seconds.
>> [ 1463.757207] Not tainted 4.19.5-1-default #1
>> [ 1463.757209] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables 
>> this message.
>> [ 1463.757212] md1_resync D 0 5215 2 0x80000000
>> [ 1463.757216] Call Trace:
>> [ 1463.757223] ? __schedule+0x29a/0x880
>> [ 1463.757231] ? raise_barrier+0x8d/0x140 [raid10]
>> [ 1463.757236] schedule+0x78/0x110
>> [ 1463.757243] raise_barrier+0x8d/0x140 [raid10]

>> [ 1463.757248] ? wait_woken+0x80/0x80
>> [ 1463.757257] raid10_sync_request+0x1f6/0x1e30 [raid10]
>> [ 1463.757265] ? _raw_spin_unlock_irq+0x22/0x40
>> [ 1463.757284] ? is_mddev_idle+0x125/0x137 [md_mod]
>> [ 1463.757302] md_do_sync.cold.78+0x404/0x969 [md_mod]
>
> The md1 sync task is blocked, I'm not sure on what.
>
>> [ 1463.757311] ? wait_woken+0x80/0x80
>> [ 1463.757336] ? md_rdev_init+0xb0/0xb0 [md_mod]
>> [ 1463.757351] md_thread+0xe9/0x140 [md_mod]
>> [ 1463.757358] ? _raw_spin_unlock_irqrestore+0x2e/0x60
>> [ 1463.757364] ? __kthread_parkme+0x4c/0x70
>> [ 1463.757369] kthread+0x112/0x130
>> [ 1463.757374] ? kthread_create_worker_on_cpu+0x40/0x40
>> [ 1463.757380] ret_from_fork+0x3a/0x50
>> [ 1463.757395] INFO: task xfsaild/md1:5233 blocked for more than 480 seconds.
>> [ 1463.757398] Not tainted 4.19.5-1-default #1
>> [ 1463.757400] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables 
>> this message.
>> [ 1463.757402] xfsaild/md1 D 0 5233 2 0x80000000
>> [ 1463.757406] Call Trace:
>> [ 1463.757413] ? __schedule+0x29a/0x880
>> [ 1463.757421] ? wait_barrier+0xdd/0x170 [raid10]
>> [ 1463.757426] schedule+0x78/0x110
>> [ 1463.757433] wait_barrier+0xdd/0x170 [raid10]
>> [ 1463.757438] ? wait_woken+0x80/0x80
>> [ 1463.757446] raid10_write_request+0xf2/0x900 [raid10]
>> [ 1463.757451] ? wait_woken+0x80/0x80
>> [ 1463.757455] ? mempool_alloc+0x55/0x160
>> [ 1463.757471] ? md_write_start+0xa9/0x270 [md_mod]
>> [ 1463.757477] ? trace_hardirqs_on_thunk+0x1a/0x1c
>> [ 1463.757485] raid10_make_request+0xc1/0x120 [raid10]
>> [ 1463.757491] ? wait_woken+0x80/0x80
>> [ 1463.757507] md_handle_request+0x121/0x190 [md_mod]
>> [ 1463.757527] md_make_request+0x78/0x190 [md_mod]
>> [ 1463.757536] generic_make_request+0x1c6/0x470
>> [ 1463.757544] submit_bio+0x45/0x140
>
> xfsaild (metadata writeback) is also blocked submitting I/O down in the
> MD driver.
>
>> [ 1463.757552] ? bio_add_page+0x48/0x60
>> [ 1463.757716] _xfs_buf_ioapply+0x2c1/0x450 [xfs]
>> [ 1463.757849] ? xfs_buf_delwri_submit_buffers+0xec/0x280 [xfs]
>> [ 1463.757974] __xfs_buf_submit+0x67/0x270 [xfs]
>> [ 1463.758102] xfs_buf_delwri_submit_buffers+0xec/0x280 [xfs]
>> [ 1463.758232] ? xfsaild+0x294/0x7e0 [xfs]
>> [ 1463.758364] xfsaild+0x294/0x7e0 [xfs]
>> [ 1463.758377] ? _raw_spin_unlock_irqrestore+0x2e/0x60
>> [ 1463.758508] ? xfs_trans_ail_cursor_first+0x80/0x80 [xfs]
>> [ 1463.758514] kthread+0x112/0x130
>> [ 1463.758520] ? kthread_create_worker_on_cpu+0x40/0x40
>> [ 1463.758527] ret_from_fork+0x3a/0x50
>> [ 1463.758543] INFO: task rpm:5364 blocked for more than 480 seconds.
>> [ 1463.758546] Not tainted 4.19.5-1-default #1
>> [ 1463.758547] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables 
>> this message.
>> [ 1463.758550] rpm D 0 5364 3757 0x00000000
>> [ 1463.758554] Call Trace:
>> [ 1463.758563] ? __schedule+0x29a/0x880
>> [ 1463.758701] ? xlog_wait+0x5c/0x70 [xfs]
>> [ 1463.759821] schedule+0x78/0x110
>> [ 1463.760022] xlog_wait+0x5c/0x70 [xfs]
>> [ 1463.760036] ? wake_up_q+0x70/0x70
>> [ 1463.760167] __xfs_log_force_lsn+0x223/0x230 [xfs]
>> [ 1463.760297] ? xfs_file_fsync+0x196/0x1d0 [xfs]
>> [ 1463.760424] xfs_log_force_lsn+0x93/0x140 [xfs]
>> [ 1463.760552] xfs_file_fsync+0x196/0x1d0 [xfs]
>
> An fsync is blocked, presumably on XFS log I/O completion.
>
>> [ 1463.760562] ? __sb_end_write+0x36/0x60
>> [ 1463.760571] do_fsync+0x38/0x70
>> [ 1463.760578] __x64_sys_fdatasync+0x13/0x20
>> [ 1463.760585] do_syscall_64+0x60/0x110
>> [ 1463.760594] entry_SYSCALL_64_after_hwframe+0x49/0xbe
>> [ 1463.760603] RIP: 0033:0x7f9757fae8a4
>> [ 1463.760616] Code: Bad RIP value.
>> [ 1463.760619] RSP: 002b:00007fff74fdb428 EFLAGS: 00000246 ORIG_RAX: 
>> 000000000000004b
>> [ 1463.760654] RAX: ffffffffffffffda RBX: 0000000000000064 RCX: 00007f9757fae8a4
>> [ 1463.760657] RDX: 00000000012c4c60 RSI: 00000000012cc130 RDI: 0000000000000004
>> [ 1463.760660] RBP: 0000000000000000 R08: 0000000000000000 R09: 00007f9758708c00
>> [ 1463.760662] R10: 0000000000000000 R11: 0000000000000246 R12: 00000000012cc130
>> [ 1463.760665] R13: 000000000123a3a0 R14: 0000000000010830 R15: 0000000000000062
>> [ 1463.760679] INFO: task kworker/0:8:5367 blocked for more than 480 seconds.
>> [ 1463.760683] Not tainted 4.19.5-1-default #1
>> [ 1463.760684] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables 
>> this message.
>> [ 1463.760687] kworker/0:8 D 0 5367 2 0x80000000
>> [ 1463.760718] Workqueue: md submit_flushes [md_mod]
>
> And that MD submit_flushes thing again.
>
> Not to say there isn't some issue between XFS and MD going on here, but
> I think we might want an MD person to take a look at this and possibly
> provide some insight. From an XFS perspective, this all just looks like
> we're blocked on I/O (via writeback, AIL and log) to a slow device.
>
> Brian
>
>> [ 1463.760721] Call Trace:
>> [ 1463.760731] ? __schedule+0x29a/0x880
>> [ 1463.760741] ? wait_barrier+0xdd/0x170 [raid10]
>> [ 1463.760746] schedule+0x78/0x110
>> [ 1463.760753] wait_barrier+0xdd/0x170 [raid10]
>> [ 1463.760761] ? wait_woken+0x80/0x80
>> [ 1463.760768] raid10_write_request+0xf2/0x900 [raid10]
>> [ 1463.760774] ? wait_woken+0x80/0x80
>> [ 1463.760778] ? mempool_alloc+0x55/0x160
>> [ 1463.760795] ? md_write_start+0xa9/0x270 [md_mod]
>> [ 1463.760801] ? try_to_wake_up+0x44/0x470
>> [ 1463.760810] raid10_make_request+0xc1/0x120 [raid10]
>> [ 1463.760816] ? wait_woken+0x80/0x80
>> [ 1463.760831] md_handle_request+0x121/0x190 [md_mod]
>> [ 1463.760851] md_make_request+0x78/0x190 [md_mod]
>> [ 1463.760860] generic_make_request+0x1c6/0x470
>> [ 1463.760870] raid10_write_request+0x77a/0x900 [raid10]
>> [ 1463.760875] ? wait_woken+0x80/0x80
>> [ 1463.760879] ? mempool_alloc+0x55/0x160
>> [ 1463.760895] ? md_write_start+0xa9/0x270 [md_mod]
>> [ 1463.760904] raid10_make_request+0xc1/0x120 [raid10]
>> [ 1463.760910] ? wait_woken+0x80/0x80
>> [ 1463.760926] md_handle_request+0x121/0x190 [md_mod]
>> [ 1463.760931] ? _raw_spin_unlock_irq+0x22/0x40
>> [ 1463.760936] ? finish_task_switch+0x74/0x260
>> [ 1463.760954] submit_flushes+0x21/0x40 [md_mod]
>> [ 1463.760962] process_one_work+0x1fd/0x420
>> [ 1463.760970] worker_thread+0x2d/0x3d0
>> [ 1463.760976] ? rescuer_thread+0x340/0x340
>> [ 1463.760981] kthread+0x112/0x130
>> [ 1463.760986] ? kthread_create_worker_on_cpu+0x40/0x40
>> [ 1463.760992] ret_from_fork+0x3a/0x50

-- 
Srdačan pozdrav/Best regards,
Siniša Bandin
