Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q42IjI4D070482 for <xfs@oss.sgi.com>; Wed, 2 May 2012 13:45:18 -0500
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id 0bsnMEFxkhmuD7cB for
	<xfs@oss.sgi.com>; Wed, 02 May 2012 11:45:15 -0700 (PDT)
Received: from smtp.pobox.com (unknown [127.0.0.1])
	by b-sasl-quonix.pobox.com (Postfix) with ESMTP id 46FDC6634
	for <xfs@oss.sgi.com>; Wed,  2 May 2012 14:45:13 -0400 (EDT)
Received: from b-pb-sasl-quonix.pobox.com (unknown [127.0.0.1])
	by b-sasl-quonix.pobox.com (Postfix) with ESMTP id 3E8E16633
	for <xfs@oss.sgi.com>; Wed,  2 May 2012 14:45:13 -0400 (EDT)
Received: from Brians-MacBook-Air.local (unknown [217.149.107.203]) (using
	TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits)) (No client
	certificate
	requested) by b-sasl-quonix.pobox.com (Postfix) with ESMTPSA id
	39FA46630 for
	<xfs@oss.sgi.com>; Wed,  2 May 2012 14:45:09 -0400 (EDT)
Received: from brian by Brians-MacBook-Air.local with local (Exim 4.77)
	(envelope-from <b.candler@pobox.com>) id M3ES2R-000210-06 for
	xfs@oss.sgi.com; Wed, 02 May 2012 19:44:51 +0100
Date: Wed, 2 May 2012 19:44:50 +0100
From: Brian Candler <B.Candler@pobox.com>
Subject: Storage server, hung tasks and tracebacks
Message-ID: <20120502184450.GA2557@nsrc.org>
MIME-Version: 1.0
Content-Disposition: inline
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

I have a really wierd problem with storage. The one thing that I *can* see
is dmesg output giving messages about hung tasks and XFS call tracebacks, so
I'm posting here in the hope that someone can help me interpret them - even
if only to say "this definitely means that your disks are not responding"
would be very helpful.

First a bit of background. there are three storage servers: they have 24 x
3TB SATA disks on LSI HBAs (1x16 port, 1x8 port), plus a boot disk directly
to the motherboard, and 8GB RAM.  They are running Ubuntu 11.10 server
amd64, kernel 3.0.0-16-server #29-Ubuntu SMP. Apart from the boot disk,
all filesystems are XFS mounted with inode64.

I had been testing them as gluster fileservers, and two of them locked up in
operation.  This gave the appearance of a hardware or BIOS fault - in
particular, a power-cycle at the front panel wouldn't bring them back to
life, but powering off using the physical switch on the PSU did.

So after upgrading the BIOS and iKVM firmware on the motherboards, I decided
to give them a soak test, running a couple of instances on bonnie++ talking
directly to the disks (so no gluster or network I/O involved).

When I came back to check on them, they have all locked up in similar ways.
On the two that I can still login to, I see the XFS call traces in dmesg.

The three servers have their disks configured slightly differently, and the
failure modes are slightly different, so I'll expand them here.

storage1
--------

Configured as two RAID6 groups of 12 disks each:

    $ cat /proc/mdstat
    Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
    md127 : active raid6 sdy[11] sdx[10] sdw[9] sdv[8] sdu[7] sdt[6] sds[5] sdr[4] sdq[3] sdp[2] sdo[1] sdn[0]
          29302650880 blocks super 1.2 level 6, 1024k chunk, algorithm 2 [12/12] [UUUUUUUUUUUU]
          
    md126 : active raid6 sdj[8] sdk[9] sdd[2] sde[3] sdi[7] sdm[11] sdg[5] sdc[1] sdb[0] sdl[10] sdh[6] sdf[4]
          29302650880 blocks super 1.2 level 6, 1024k chunk, algorithm 2 [12/12] [UUUUUUUUUUUU]
          
    unused devices: <none>
    $ df -h | grep md
    /dev/md126             28T  105G   28T   1% /disk/data1
    /dev/md127             28T   86G   28T   1% /disk/data2

My soak test was to run four instances of bonnie++, on
/disk/data1/{test,testb} and /disk/data2/{test,testb}, using variants
of this command line:

    while [ 1 ]; do bonnie++ -d /disk/data1/test -s 16384k -n 98:800k:500k:1000; done

SYMPTOM: I can happily ssh into this box, but iostat shows that no disk
activity is going on. The bonnie++ processes (which I was running in
screen sessions) have apparently hung, not having completed even a single
cycle:

    brian@storage1:~$ while [ 1 ]; do bonnie++ -d /disk/data1/test -s 16384k -n 98:800k:500k:1000; done
    Writing a byte at a time...done
    Writing intelligently...done
    Rewriting...done
    Reading a byte at a time...done
    Reading intelligently...done
    start 'em...done...done...done...done...done...
    Create files in sequential order...done.
    Stat files in sequential order...done.
    Delete files in sequential order...done.
    Create files in random order...

Three of the bonnie++ processes stopped at this point. The other stopped at
"Delete files in sequential order..."

dmesg is apparently silent until I start getting the call traces, here's how
they begin:

...
[48899.342127]  disk 9, o:1, dev:sdw
[48899.342129]  disk 10, o:1, dev:sdx
[48899.342131]  disk 11, o:1, dev:sdy[532203.415122] INFO: task bonnie++:28294 blocked for more than 120 seconds.
[532203.415489] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[532203.424964] bonnie++        D ffffffff81805120     0 28294  28242 0x00000000
[532203.424973]  ffff880212129cc8 0000000000000082 ffff880212129c68 ffffffff812ed3ee
[532203.424984]  ffff880212129fd8 ffff880212129fd8 ffff880212129fd8 0000000000012a40
[532203.424993]  ffffffff81c0b020 ffff88020f070000 ffff88021fc0de40 7fffffffffffffff
[532203.425003] Call Trace:
[532203.425016]  [<ffffffff812ed3ee>] ? radix_tree_lookup_slot+0xe/0x10
[532203.425025]  [<ffffffff816058cf>] schedule+0x3f/0x60
[532203.425031]  [<ffffffff81605f15>] schedule_timeout+0x2a5/0x320
[532203.425039]  [<ffffffff8102c3d3>] ? x2apic_send_IPI_mask+0x13/0x20
[532203.425046]  [<ffffffff81026558>] ? native_smp_send_reschedule+0x48/0x60
[532203.425054]  [<ffffffff8104a5d2>] ? ttwu_queue+0x92/0xd0
[532203.425060]  [<ffffffff81604f7f>] wait_for_common+0xdf/0x180
[532203.425068]  [<ffffffff81194610>] ? __sync_filesystem+0x90/0x90
[532203.425074]  [<ffffffff810574b0>] ? try_to_wake_up+0x200/0x200
[532203.425080]  [<ffffffff81194610>] ? __sync_filesystem+0x90/0x90
[532203.425087]  [<ffffffff816050fd>] wait_for_completion+0x1d/0x20
[532203.425093]  [<ffffffff8118e969>] writeback_inodes_sb_nr+0x79/0xa0
[532203.425099]  [<ffffffff8118ebc1>] writeback_inodes_sb+0x21/0x30
[532203.425104]  [<ffffffff811945c9>] __sync_filesystem+0x49/0x90
[532203.425110]  [<ffffffff8119462f>] sync_one_sb+0x1f/0x30
[532203.425117]  [<ffffffff8116b525>] iterate_supers+0xa5/0x100
[532203.425123]  [<ffffffff811946db>] sys_sync+0x2b/0x60
[532203.425131]  [<ffffffff8160fb82>] system_call_fastpath+0x16/0x1b
[532323.396630] INFO: task bonnie++:28239 blocked for more than 120 seconds.
[532323.401489] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[532323.411026] bonnie++        D ffffffff81805120     0 28239  26958 0x00000000
[532323.411033]  ffff88020fd85cc8 0000000000000086 ffff88020fd85c68 ffffffff812ed3ee
[532323.411038]  ffff88020fd85fd8 ffff88020fd85fd8 ffff88020fd85fd8 0000000000012a40
[532323.411042]  ffff880212d2dc80 ffff880207400000 ffff88021fd0de40 7fffffffffffffff
[532323.411050] Call Trace:
[532323.411062]  [<ffffffff812ed3ee>] ? radix_tree_lookup_slot+0xe/0x10
[532323.411072]  [<ffffffff816058cf>] schedule+0x3f/0x60
[532323.411079]  [<ffffffff81605f15>] schedule_timeout+0x2a5/0x320
[532323.411087]  [<ffffffff8102c3d3>] ? x2apic_send_IPI_mask+0x13/0x20
[532323.411094]  [<ffffffff81026558>] ? native_smp_send_reschedule+0x48/0x60
[532323.411102]  [<ffffffff8104a5d2>] ? ttwu_queue+0x92/0xd0
[532323.411109]  [<ffffffff81604f7f>] wait_for_common+0xdf/0x180
[532323.411117]  [<ffffffff81194610>] ? __sync_filesystem+0x90/0x90
[532323.411123]  [<ffffffff810574b0>] ? try_to_wake_up+0x200/0x200
[532323.411129]  [<ffffffff81194610>] ? __sync_filesystem+0x90/0x90
[532323.411136]  [<ffffffff816050fd>] wait_for_completion+0x1d/0x20
[532323.411142]  [<ffffffff8118e969>] writeback_inodes_sb_nr+0x79/0xa0
[532323.411149]  [<ffffffff8118ebc1>] writeback_inodes_sb+0x21/0x30
[532323.411155]  [<ffffffff811945c9>] __sync_filesystem+0x49/0x90
[532323.411166]  [<ffffffff8119462f>] sync_one_sb+0x1f/0x30
[532323.411170]  [<ffffffff8116b525>] iterate_supers+0xa5/0x100
[532323.411173]  [<ffffffff811946db>] sys_sync+0x2b/0x60
[532323.411177]  [<ffffffff8160fb82>] system_call_fastpath+0x16/0x1b
[535202.773094] INFO: task kswapd0:31 blocked for more than 120 seconds.
[535202.778172] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[535202.788110] kswapd0         D 0000000000000003     0    31      2 0x00000000
[535202.788116]  ffff880212f03980 0000000000000046 ffff8800891939b0 000000000000001a
[535202.788121]  ffff880212f03fd8 ffff880212f03fd8 ffff880212f03fd8 0000000000012a40
[535202.788126]  ffff880211a0ae40 ffff88020fbfae40 ffff880212f03970 ffff880208215818
[535202.788136] Call Trace:
[535202.788148]  [<ffffffff816058cf>] schedule+0x3f/0x60
[535202.788178]  [<ffffffffa01c2861>] _xfs_log_force_lsn+0x171/0x2e0 [xfs]
[535202.788186]  [<ffffffff810574b0>] ? try_to_wake_up+0x200/0x200
[535202.788210]  [<ffffffffa01b8945>] ? xfs_iunpin_wait+0x35/0xb0 [xfs]
[535202.788233]  [<ffffffffa01c29e8>] xfs_log_force_lsn+0x18/0x40 [xfs]
[535202.788252]  [<ffffffffa01b68a7>] xfs_iunpin_nowait+0x47/0xb0 [xfs]
[535202.788261]  [<ffffffffa01b8945>] xfs_iunpin_wait+0x35/0xb0 [xfs]
[535202.788265]  [<ffffffff8104652b>] ? try_wait_for_completion+0x4b/0x60
[535202.788277]  [<ffffffffa01e4352>] xfs_reclaim_inode+0xb2/0x2a0 [xfs]
[535202.788281]  [<ffffffff812ee45c>] ? radix_tree_gang_lookup_tag.part.7+0x6c/0xf0
[535202.788293]  [<ffffffffa01e4fec>] xfs_reclaim_inodes_ag+0x20c/0x330 [xfs]
[535202.788304]  [<ffffffffa01e51b3>] xfs_reclaim_inode_shrink+0xa3/0xc0 [xfs]
[535202.788309]  [<ffffffff8111b1dd>] shrink_slab+0x11d/0x190
[535202.788312]  [<ffffffff8111e42a>] balance_pgdat+0x52a/0x6f0
[535202.788315]  [<ffffffff8111e6da>] kswapd+0xea/0x1f0
[535202.788318]  [<ffffffff8111e5f0>] ? balance_pgdat+0x6f0/0x6f0
[535202.788321]  [<ffffffff81080dac>] kthread+0x8c/0xa0
[535202.788325]  [<ffffffff81610ca4>] kernel_thread_helper+0x4/0x10
[535202.788328]  [<ffffffff81080d20>] ? flush_kthread_worker+0xa0/0xa0
[535202.788331]  [<ffffffff81610ca0>] ? gs_change+0x13/0x13
[535202.788343] INFO: task bonnie++:28609 blocked for more than 120 seconds.
[535202.793856] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[535202.805501] bonnie++        D ffffffff81805120     0 28609  28557 0x00000000
[535202.805506]  ffff8800a95993d8 0000000000000086 ffff8802129c8000 0000000000000002
[535202.805510]  ffff8800a9599fd8 ffff8800a9599fd8 ffff8800a9599fd8 0000000000012a40
[535202.805515]  ffffffff81c0b020 ffff8802129c8000 ffff8800a95993c8 000000000000038d
[535202.805519] Call Trace:
[535202.805527]  [<ffffffff816058cf>] schedule+0x3f/0x60
[535202.805552]  [<ffffffffa01c40f7>] xlog_cil_force_lsn+0xf7/0x120 [xfs]
[535202.805567]  [<ffffffff810574b0>] ? try_to_wake_up+0x200/0x200
[535202.805585]  [<ffffffffa01b8945>] ? xfs_iunpin_wait+0x35/0xb0 [xfs]
[535202.805602]  [<ffffffffa01c2747>] _xfs_log_force_lsn+0x57/0x2e0 [xfs]
[535202.805609]  [<ffffffff8160772e>] ? _raw_spin_lock+0xe/0x20
[535202.805615]  [<ffffffff811510e8>] ? add_partial+0x58/0x90
[535202.805632]  [<ffffffffa01b8945>] ? xfs_iunpin_wait+0x35/0xb0 [xfs]
[535202.805648]  [<ffffffffa01c29e8>] xfs_log_force_lsn+0x18/0x40 [xfs]
[535202.805665]  [<ffffffffa01b68a7>] xfs_iunpin_nowait+0x47/0xb0 [xfs]
[535202.805681]  [<ffffffffa01b8945>] xfs_iunpin_wait+0x35/0xb0 [xfs]
[535202.805687]  [<ffffffff8104652b>] ? try_wait_for_completion+0x4b/0x60
[535202.805707]  [<ffffffffa01e4352>] xfs_reclaim_inode+0xb2/0x2a0 [xfs]
[535202.805713]  [<ffffffff812ee45c>] ? radix_tree_gang_lookup_tag.part.7+0x6c/0xf0
[535202.805732]  [<ffffffffa01e4fec>] xfs_reclaim_inodes_ag+0x20c/0x330 [xfs]
[535202.805751]  [<ffffffffa01e51b3>] xfs_reclaim_inode_shrink+0xa3/0xc0 [xfs]
[535202.805758]  [<ffffffff8111b1dd>] shrink_slab+0x11d/0x190
[535202.805763]  [<ffffffff8111d978>] do_try_to_free_pages+0x288/0x2e0
[535202.805782]  [<ffffffffa01da59f>] ? xfs_buf_get+0x8f/0x1a0 [xfs]
[535202.805787]  [<ffffffff8111dcd4>] try_to_free_pages+0xb4/0x180
[535202.805793]  [<ffffffff81113260>] __alloc_pages_nodemask+0x4e0/0x800
[535202.805799]  [<ffffffff81149273>] alloc_pages_current+0xa3/0x110
[535202.805805]  [<ffffffff81151f5d>] allocate_slab+0xfd/0x160
[535202.805810]  [<ffffffff81151ff0>] new_slab+0x30/0x160
[535202.805816]  [<ffffffff815f5299>] __slab_alloc+0x127/0x222
[535202.805822]  [<ffffffff8117d447>] ? d_alloc+0x27/0x1d0
[535202.805827]  [<ffffffff811534d2>] kmem_cache_alloc+0x112/0x120
[535202.805832]  [<ffffffff8117d447>] d_alloc+0x27/0x1d0
[535202.805838]  [<ffffffff81172c4d>] d_alloc_and_lookup+0x2d/0x90
[535202.805844]  [<ffffffff81180485>] ? d_lookup+0x35/0x60
[535202.805850]  [<ffffffff81173946>] __lookup_hash.part.15+0x96/0xb0
[535202.805869]  [<ffffffffa01ce173>] ? xfs_trans_free_item_desc+0x33/0x40 [xfs]
[535202.805874]  [<ffffffff81174230>] lookup_hash+0x80/0xe0
[535202.805878]  [<ffffffff8117625b>] do_last+0x26b/0x730
[535202.805883]  [<ffffffff811778aa>] path_openat+0xca/0x3f0
[535202.805901]  [<ffffffffa01d2630>] ? xfs_free_eofblocks+0x1d0/0x240 [xfs]
[535202.805919]  [<ffffffffa01d2630>] ? xfs_free_eofblocks+0x1d0/0x240 [xfs]
[535202.805925]  [<ffffffff81177cd2>] do_filp_open+0x42/0xa0
[535202.805931]  [<ffffffff812f4cc1>] ? strncpy_from_user+0x31/0x40
[535202.805936]  [<ffffffff8117307a>] ? do_getname+0x10a/0x180
[535202.805942]  [<ffffffff8160772e>] ? _raw_spin_lock+0xe/0x20
[535202.805947]  [<ffffffff81184f87>] ? alloc_fd+0xf7/0x150
[535202.805953]  [<ffffffff8116795d>] do_sys_open+0xed/0x220
[535202.805958]  [<ffffffff81169a65>] ? fput+0x25/0x30
[535202.805964]  [<ffffffff81167ab0>] sys_open+0x20/0x30
[535202.805970]  [<ffffffff8160fb82>] system_call_fastpath+0x16/0x1b
[535202.805975] INFO: task bonnie++:28664 blocked for more than 120 seconds.
... snip rest, I have more if you want it ...

storage2
--------

This originally had all 24 disks in a software RAID0 array. Two of them
(sdr, sdy) started giving read errors, so I built a new 22-disk RAID0
without those two.  Then I ran two instances of bonnie++, on
/disk/scratch/test and /disk/scratch/testb

This machine has locked up in such a way that I cannot ssh to it, it
just drops the connection:

    $ telnet storage2 22
    Trying storage2...
    Connected to 192.168.5.71.
    Escape character is '^]'.
    Connection closed by foreign host.

At the console I see a number of messages about blocked tasks (kworker,
bonnie++, sshd, cron, mv, kswapd0).  There is a login prompt, but if I type
my username I get no password prompt.

    ...
    [520326.168622] INFO: task kswapd0:30 blocked for more than 120 seconds.
    [520326.177738] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
    [520326.197088] INFO: task kworder/3:2:4834 blocked for more than 120 seconds.
    [520326.207151] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.

    Ubuntu 11.10 storage2 tty1

    storage2 login: brian
    << no response past this point >>

storage3
--------

This has 24 disks in a software RAID0 array, and I was running two instances
of bonnie++ against it.

    $ cat /proc/mdstat
    Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
    md127 : active raid0 sdn[12] sdu[18] sdx[22] sdl[9] sdy[23] sdd[2] sdt[17] sdi[7] sdj[8] sdr[19] sdg[5] sdw[21] sdf[4] sdv[20] sds[16] sdk[10] sde[3] sdh[6] sdp[14] sdo[13] sdc[1] sdb[0] sdq[15] sdm[11]
          70326362112 blocks super 1.2 1024k chunks
          
    unused devices: <none>

SYMPTOM: Like storage1, I can ssh in but I find no I/O activity going on. I
also see call tracebacks in dmesg, although this time the first one is
kworker not bonnie++

...
[   38.659687] eth3: no IPv6 routers present
[   41.738989] eth2: no IPv6 routers present
[531843.502509] INFO: task kworker/2:1:29 blocked for more than 120 seconds.
[531843.502876] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[531843.512298] kworker/2:1     D 0000000000000002     0    29      2 0x00000000
[531843.512304]  ffff88020f493b80 0000000000000046 ffff880017213af8 ffff8800c93384c8
[531843.512309]  ffff88020f493fd8 ffff88020f493fd8 ffff88020f493fd8 0000000000012a40
[531843.512313]  ffff88020d80ae40 ffff88020f498000 0000000000000000 ffff88020e9c11e8
[531843.512318] Call Trace:
[531843.512327]  [<ffffffff816058cf>] schedule+0x3f/0x60
[531843.512332]  [<ffffffff816066c7>] __mutex_lock_slowpath+0xd7/0x150
[531843.512338]  [<ffffffff81606282>] mutex_lock+0x22/0x40
[531843.512371]  [<ffffffffa020806d>] xfs_reclaim_inodes_ag+0x28d/0x330 [xfs]
[531843.512395]  [<ffffffffa02081f0>] ? xfs_reclaim_inodes+0x20/0x20 [xfs]
[531843.512416]  [<ffffffffa02081ed>] xfs_reclaim_inodes+0x1d/0x20 [xfs]
[531843.512436]  [<ffffffffa0208212>] xfs_reclaim_worker+0x22/0x40 [xfs]
[531843.512443]  [<ffffffff8107bbba>] process_one_work+0x11a/0x480
[531843.512449]  [<ffffffff8107c965>] worker_thread+0x165/0x370
[531843.512455]  [<ffffffff8107c800>] ? manage_workers.isra.30+0x130/0x130
[531843.512461]  [<ffffffff81080dac>] kthread+0x8c/0xa0
[531843.512468]  [<ffffffff81610ca4>] kernel_thread_helper+0x4/0x10
[531843.512475]  [<ffffffff81080d20>] ? flush_kthread_worker+0xa0/0xa0
[531843.512481]  [<ffffffff81610ca0>] ? gs_change+0x13/0x13
[531843.512485] INFO: task kswapd0:31 blocked for more than 120 seconds.
[531843.517282] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[531843.526697] kswapd0         D ffffffff81805120     0    31      2 0x00000000
[531843.526701]  ffff880212f018f0 0000000000000046 0000000000000000 0000000000000000
[531843.526706]  ffff880212f01fd8 ffff880212f01fd8 ffff880212f01fd8 0000000000012a40
[531843.526710]  ffff880212d2dc80 ffff88020f49ae40 ffff880212f018e0 0000000000004978
[531843.526714] Call Trace:
[531843.526719]  [<ffffffff816058cf>] schedule+0x3f/0x60
[531843.526740]  [<ffffffffa01e70f7>] xlog_cil_force_lsn+0xf7/0x120 [xfs]
[531843.526744]  [<ffffffff810574b0>] ? try_to_wake_up+0x200/0x200
[531843.526764]  [<ffffffffa01db945>] ? xfs_iunpin_wait+0x35/0xb0 [xfs]
[531843.526783]  [<ffffffffa01e5747>] _xfs_log_force_lsn+0x57/0x2e0 [xfs]
[531843.526802]  [<ffffffffa01db945>] ? xfs_iunpin_wait+0x35/0xb0 [xfs]
[531843.526819]  [<ffffffffa01e59e8>] xfs_log_force_lsn+0x18/0x40 [xfs]
[531843.526837]  [<ffffffffa01d98a7>] xfs_iunpin_nowait+0x47/0xb0 [xfs]
[531843.526854]  [<ffffffffa01db945>] xfs_iunpin_wait+0x35/0xb0 [xfs]
[531843.526858]  [<ffffffff8104652b>] ? try_wait_for_completion+0x4b/0x60
[531843.526879]  [<ffffffffa0207352>] xfs_reclaim_inode+0xb2/0x2a0 [xfs]
[531843.526884]  [<ffffffff812ee45c>] ? radix_tree_gang_lookup_tag.part.7+0x6c/0xf0
[531843.526904]  [<ffffffffa0207fec>] xfs_reclaim_inodes_ag+0x20c/0x330 [xfs]
[531843.526910]  [<ffffffff8160772e>] ? _raw_spin_lock+0xe/0x20
[531843.526928]  [<ffffffffa02081b3>] xfs_reclaim_inode_shrink+0xa3/0xc0 [xfs]
[531843.526934]  [<ffffffff8111b1dd>] shrink_slab+0x11d/0x190
[531843.526937]  [<ffffffff8111e42a>] balance_pgdat+0x52a/0x6f0
[531843.526941]  [<ffffffff8111e6da>] kswapd+0xea/0x1f0
[531843.526944]  [<ffffffff8111e5f0>] ? balance_pgdat+0x6f0/0x6f0
[531843.526948]  [<ffffffff81080dac>] kthread+0x8c/0xa0
[531843.526951]  [<ffffffff81610ca4>] kernel_thread_helper+0x4/0x10
[531843.526956]  [<ffffffff81080d20>] ? flush_kthread_worker+0xa0/0xa0
[531843.526959]  [<ffffffff81610ca0>] ? gs_change+0x13/0x13
[531843.526963] INFO: task kworker/3:1:52 blocked for more than 120 seconds.
[531843.532003] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[531843.541890] kworker/3:1     D 0000000000000003     0    52      2 0x00000000
[531843.541894]  ffff88020f0b9450 0000000000000046 0000000000000000 0000000000000000
[531843.541899]  ffff88020f0b9fd8 ffff88020f0b9fd8 ffff88020f0b9fd8 0000000000012a40
[531843.541903]  ffff88020d808000 ffff88020f07ae40 ffff88020f0b9440 0000000000004978
[531843.541907] Call Trace:
[531843.541912]  [<ffffffff816058cf>] schedule+0x3f/0x60
[531843.541931]  [<ffffffffa01e70f7>] xlog_cil_force_lsn+0xf7/0x120 [xfs]
[531843.541938]  [<ffffffff810574b0>] ? try_to_wake_up+0x200/0x200
[531843.541959]  [<ffffffffa01db945>] ? xfs_iunpin_wait+0x35/0xb0 [xfs]
[531843.541979]  [<ffffffffa01e5747>] _xfs_log_force_lsn+0x57/0x2e0 [xfs]
[531843.541999]  [<ffffffffa01bbefc>] ? xfs_bmapi+0x2ac/0x1150 [xfs]
[531843.542019]  [<ffffffffa01db945>] ? xfs_iunpin_wait+0x35/0xb0 [xfs]
[531843.542039]  [<ffffffffa01e59e8>] xfs_log_force_lsn+0x18/0x40 [xfs]
[531843.542059]  [<ffffffffa01d98a7>] xfs_iunpin_nowait+0x47/0xb0 [xfs]
[531843.542078]  [<ffffffffa01db945>] xfs_iunpin_wait+0x35/0xb0 [xfs]
[531843.542084]  [<ffffffff8104652b>] ? try_wait_for_completion+0x4b/0x60
[531843.542107]  [<ffffffffa0207352>] xfs_reclaim_inode+0xb2/0x2a0 [xfs]
[531843.542114]  [<ffffffff812ee45c>] ? radix_tree_gang_lookup_tag.part.7+0x6c/0xf0
[531843.542136]  [<ffffffffa0207fec>] xfs_reclaim_inodes_ag+0x20c/0x330 [xfs]
[531843.542158]  [<ffffffffa02081b3>] xfs_reclaim_inode_shrink+0xa3/0xc0 [xfs]
[531843.542166]  [<ffffffff8111b1dd>] shrink_slab+0x11d/0x190
[531843.542171]  [<ffffffff8111d978>] do_try_to_free_pages+0x288/0x2e0
[531843.542178]  [<ffffffff8111dcd4>] try_to_free_pages+0xb4/0x180
[531843.542184]  [<ffffffff81113260>] __alloc_pages_nodemask+0x4e0/0x800
[531843.542192]  [<ffffffff8160772e>] ? _raw_spin_lock+0xe/0x20
[531843.542199]  [<ffffffff81149273>] alloc_pages_current+0xa3/0x110
[531843.542205]  [<ffffffff81151f5d>] allocate_slab+0xfd/0x160
[531843.542211]  [<ffffffff81151ff0>] new_slab+0x30/0x160
[531843.542218]  [<ffffffff815f5299>] __slab_alloc+0x127/0x222
[531843.542225]  [<ffffffff8110c545>] ? mempool_alloc_slab+0x15/0x20
[531843.542232]  [<ffffffff811534d2>] kmem_cache_alloc+0x112/0x120
[531843.542238]  [<ffffffff8110c545>] mempool_alloc_slab+0x15/0x20
[531843.542245]  [<ffffffff8110c863>] mempool_alloc+0x53/0x130
[531843.542251]  [<ffffffff81081850>] ? add_wait_queue+0x60/0x60
[531843.542257]  [<ffffffff8119bfbe>] bio_alloc_bioset+0x3e/0xf0
[531843.542263]  [<ffffffff814a9350>] ? slot_store+0x2e0/0x2e0
[531843.542271]  [<ffffffff814a51f7>] bio_alloc_mddev+0x27/0x50
[531843.542276]  [<ffffffff814a93f8>] submit_flushes+0xa8/0x140[531843.542282]  [<ffffffff8107bbba>] process_one_work+0x11a/0x480
[531843.542287]  [<ffffffff8107c965>] worker_thread+0x165/0x370
[531843.542293]  [<ffffffff8107c800>] ? manage_workers.isra.30+0x130/0x130
[531843.542299]  [<ffffffff81080dac>] kthread+0x8c/0xa0
[531843.542305]  [<ffffffff81610ca4>] kernel_thread_helper+0x4/0x10
[531843.542312]  [<ffffffff81080d20>] ? flush_kthread_worker+0xa0/0xa0
[531843.542318]  [<ffffffff81610ca0>] ? gs_change+0x13/0x13
[531843.542325] INFO: task xfsaild/md127:1146 blocked for more than 120 seconds.
[531843.547840] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[531843.559458] xfsaild/md127   D 0000000000000003     0  1146      2 0x00000000
[531843.559461]  ffff8802119bb700 0000000000000046 ffff8802119bb6f0 ffffffff81079c25
[531843.559463]  ffff8802119bbfd8 ffff8802119bbfd8 ffff8802119bbfd8 0000000000012a40
[531843.559465]  ffff88020f07ae40 ffff8802129d4560 ffff8802119bb6f0 ffff8802129d4560
[531843.559467] Call Trace:
[531843.559469]  [<ffffffff81079c25>] ? __queue_work+0xe5/0x320
[531843.559471]  [<ffffffff816058cf>] schedule+0x3f/0x60
[531843.559473]  [<ffffffff814a9606>] md_flush_request+0x86/0x140
[531843.559475]  [<ffffffff810574b0>] ? try_to_wake_up+0x200/0x200
[531843.559481]  [<ffffffffa0010419>] raid0_make_request+0x119/0x1e0 [raid0]
[531843.559484]  [<ffffffff812df850>] ? blk_throtl_bio+0x1c0/0x510
[531843.559486]  [<ffffffff814a4886>] md_make_request+0xc6/0x200
[531843.559488]  [<ffffffff8110c545>] ? mempool_alloc_slab+0x15/0x20
[531843.559490]  [<ffffffff812ce48a>] generic_make_request.part.51+0x24a/0x510
[531843.559492]  [<ffffffff812ce795>] generic_make_request+0x45/0x60
[531843.559494]  [<ffffffff812ce837>] submit_bio+0x87/0x110
[531843.559504]  [<ffffffffa01fda82>] _xfs_buf_ioapply+0x162/0x1e0 [xfs]
[531843.559514]  [<ffffffffa01e1dea>] ? xlog_bdstrat+0x2a/0x60 [xfs]
[531843.559525]  [<ffffffffa01fdc5e>] xfs_buf_iorequest+0x5e/0x100 [xfs]
[531843.559535]  [<ffffffffa01e1dea>] xlog_bdstrat+0x2a/0x60 [xfs]
[531843.559545]  [<ffffffffa01e3249>] xlog_sync+0x1c9/0x3c0 [xfs]
[531843.559554]  [<ffffffffa01e48a5>] xlog_state_release_iclog+0xa5/0xd0 [xfs]
[531843.559563]  [<ffffffffa01e4cf7>] xlog_write_copy_finish.isra.12+0x147/0x170 [xfs]
[531843.559573]  [<ffffffffa01e50f8>] xlog_write+0x268/0x400 [xfs]
[531843.559583]  [<ffffffffa01f9667>] ? kmem_zone_alloc+0x67/0xe0 [xfs]
[531843.559593]  [<ffffffffa01e67ec>] xlog_cil_push+0x20c/0x380 [xfs]
[531843.559603]  [<ffffffffa01e710e>] xlog_cil_force_lsn+0x10e/0x120 [xfs]
[531843.559606]  [<ffffffff81086bb6>] ? down_trylock+0x36/0x50
[531843.559617]  [<ffffffffa01fc881>] ? xfs_buf_rele+0x51/0x130 [xfs]
[531843.559627]  [<ffffffffa01fcd06>] ? _xfs_buf_find+0x56/0x280 [xfs]
[531843.559637]  [<ffffffffa01e5478>] _xfs_log_force+0x68/0x2a0 [xfs]
[531843.559647]  [<ffffffffa01fcef9>] ? _xfs_buf_find+0x249/0x280 [xfs]
[531843.559658]  [<ffffffffa01d91d9>] ? xfs_iunlock+0xe9/0x150 [xfs]
[531843.559668]  [<ffffffffa01dec87>] ? xfs_inode_item_pushbuf+0x87/0xe0 [xfs]
[531843.559678]  [<ffffffffa01e56c8>] xfs_log_force+0x18/0x40 [xfs]
[531843.559688]  [<ffffffffa01f37b4>] xfsaild_push+0x394/0x3a0 [xfs]
[531843.559699]  [<ffffffffa01f3822>] xfsaild+0x62/0xc0 [xfs]
[531843.559708]  [<ffffffffa01f37c0>] ? xfsaild_push+0x3a0/0x3a0 [xfs]
[531843.559711]  [<ffffffff81080dac>] kthread+0x8c/0xa0
[531843.559714]  [<ffffffff81610ca4>] kernel_thread_helper+0x4/0x10
[531843.559717]  [<ffffffff81080d20>] ? flush_kthread_worker+0xa0/0xa0
[531843.559720]  [<ffffffff81610ca0>] ? gs_change+0x13/0x13
[531843.559725] INFO: task bonnie++:15912 blocked for more than 120 seconds.
... etc

Additional testing
------------------

All three machines are still stuck in this state, and I can leave them like
this for the next few days if necessary if there are any tests or anything
that you can suggest I do to the systems while they're like this.

The only thing I could think of doing was a 'dd' to see if the underlying
drives are working:

root     23604  0.0  0.0  11064  1688 pts/4    D+   19:04   0:00 dd if=/dev/md127 of=/dev/null bs=1024k count=1024

That process hung. So I tried again with smaller ones:

strace dd if=/dev/md127 of=/dev/null bs=1024k count=1 #ok
strace dd if=/dev/md127 of=/dev/null bs=1024k count=2 #ok
strace dd if=/dev/md127 of=/dev/null bs=1024k count=3 #ok
strace dd if=/dev/md127 of=/dev/null bs=1024k count=4 #ok
strace dd if=/dev/md127 of=/dev/null bs=1024k count=5 #hung

The strace of the last process was like this:

open("/dev/md127", O_RDONLY)            = 3
dup2(3, 0)                              = 0
close(3)                                = 0
lseek(0, 0, SEEK_CUR)                   = 0
open("/dev/null", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 3
dup2(3, 1)                              = 1
close(3)                                = 0
mmap(NULL, 1060864, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f6d5a1c7000
read(0, "XFSB\0\0\20\0\0\0\0\4\27\361\310\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1048576) = 1048576
write(1, "XFSB\0\0\20\0\0\0\0\4\27\361\310\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1048576) = 1048576
read(0, "INA\355\2\1\0\0\0\0\0\0\0\0\0\0\0\0\0\6\0\0\0\0\0\0\0\0\0\0\0\4"..., 1048576) = 1048576
write(1, "INA\355\2\1\0\0\0\0\0\0\0\0\0\0\0\0\0\6\0\0\0\0\0\0\0\0\0\0\0\4"..., 1048576) = 1048576
read(0, "IN\201\244\2\2\0\0\0\0\3\350\0\0\3\350\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\16"..., 1048576) = 1048576
write(1, "IN\201\244\2\2\0\0\0\0\3\350\0\0\3\350\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\16"..., 1048576) = 1048576
read(0, "p1\17\343>\203)\321\272\1\357\0\0\0\272\252V\206\377~\300\203\376\351\3\366\35)Zh[\25"..., 1048576) = 1048576
write(1, "p1\17\343>\203)\321\272\1\357\0\0\0\272\252V\206\377~\300\203\376\351\3\366\35)Zh[\25"..., 1048576) = 1048576
read(0, 

That is, it read 4 chunks OK and hung reading the 5th. This seems
suspiciously like a drive has locked up, but there are no dmesg errors for
sd[a-z] to suggest disk problems, whereas when I had a real failed disk
on storage2 I had messages like this (captured previously):

    [ 1217.995083] sd 5:0:0:0: [sdr] Unhandled sense code
    [ 1217.995085] sd 5:0:0:0: [sdr]  Result: hostbyte=invalid driverbyte=DRIVER_SENSE
    [ 1217.995089] sd 5:0:0:0: [sdr]  Sense Key : Medium Error [current] 
    [ 1217.995095] sd 5:0:0:0: [sdr]  Add. Sense: Unrecovered read error
    [ 1217.995099] sd 5:0:0:0: [sdr] CDB: Read(10): 28 00 30 00 05 80 00 00 10 00
    [ 1217.995108] end_request: critical target error, dev sdr, sector 805307776

Furthermore, the following command which makes a small transfer to every
disk runs fine:

    # for i in sd{b..y}; do echo $i; dd if=/dev/$i of=/dev/null count=1; done

But this one gets stuck at sdk:

    # for i in sd{b..y}; do echo $i; dd if=/dev/$i of=/dev/null bs=1024k count=1; done

Final point: the dd and bonnie++ processes can't be killed even with -9.

So, these machines are very sick, and in roughly the same way. And the fact
I can get simple dd's to lock up implies it's *not* anything to do with XFS,
so my apologies if this is the wrong forum.

Fortunately the problem appears fairly easy to reproduce.  They are
identical hardware, in terms of chassis, PSU, motherboard, BIOS version; and
they are the same OS.

I had already flashed the newest LSI firmware into the HBAs:

    $ sudo ./sas2flash -listall
    LSI Corporation SAS2 Flash Utility
    Version 13.00.00.00 (2012.02.17) 
    Copyright (c) 2008-2012 LSI Corporation. All rights reserved 

            Adapter Selected is a LSI SAS: SAS2116_1(B1) 

    Num   Ctlr            FW Ver        NVDATA        x86-BIOS         PCI Addr
    ----------------------------------------------------------------------------

    0  SAS2116_1(B1)   13.00.01.00    0c.00.00.01    07.25.00.00     00:02:00:00
    1  SAS2008(B2)     13.00.01.00    0c.00.00.05    07.25.00.00     00:03:00:00

            Finished Processing Commands Successfully.
            Exiting SAS2Flash.

(Maybe "newest" wasn't a good idea - it was released Feb 17 2012)

I could try ubuntu 12.04 with its newer kernel - I'd be surprised if the LSI
driver in 11.10 was as broken as this appears to be, but it's not
impossible. LSI themselves only seem to provide driver packages
for RH4/SLES9 and RH5/SLES10 at
http://www.lsi.com/channel/support/products/Pages/LSISAS9201-16i.aspx
(and I guess trying CentOS 5 is another option)

Any other suggestions (and of course interpretation of the kernel call
tracebacks) would be much appreciated.

Thanks,

Brian.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
