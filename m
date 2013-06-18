Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8514629DF8
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 19:37:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 681758F804B
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 17:37:53 -0700 (PDT)
Received: from mail-ee0-f43.google.com (mail-ee0-f43.google.com
	[74.125.83.43]) by cuda.sgi.com with ESMTP id RSYbDirzK4yrHNmV
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 17 Jun 2013 17:37:51 -0700 (PDT)
Received: by mail-ee0-f43.google.com with SMTP id l10so2174683eei.30
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 17:37:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130618001920.GM29376@dastard>
References: <CA+aXbB5ohJkDde8qJSE0AU6B0dh59YjNPVfxVjXCOg73k7ihXQ@mail.gmail.com>
	<20130615010313.GA29338@dastard>
	<CA+aXbB5b0Vqp9mTPUiV4x_bGkVfbnCTErW-QoX=SMjv0mADf-w@mail.gmail.com>
	<20130618001920.GM29376@dastard>
Date: Tue, 18 Jun 2013 04:37:50 +0400
Message-ID: <CA+aXbB6p8rTGqKf__BsSWkOhzCL7z3cbgKu85bvP=okVT31R3A@mail.gmail.com>
Subject: Re: possible null pointer in xlog_iodone
From: Vlad Bespalov <vlad.botanic@gmail.com>
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
Cc: xfs@oss.sgi.com

---------------- system log:
<1>XFS (mtab~): metadata I/O error: block 0xa03e1b ("xlog_iodone")
error 5 buf count 1024
<1>BUG: unable to handle kernel paging request at 00000005000000fe
<1>IP: [<ffffffffa057b14e>] __xfs_printk+0xe/0x50 [xfs]
<4>PGD 0
<4>Oops: 0000 [#1] SMP
<4>last sysfs file: /sys/devices/virtual/block/<device>/queue/hw_sector_size
<4>CPU 3
<4>Modules linked in: xfs exportfs fuse fiop(P)(U) sunrpc ipt_REJECT
nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT
nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter
ip6_tables ipv6 uinput power_meter sg dcdbas microcode serio_raw
iTCO_wdt iTCO_vendor_support i7core_edac edac_core bnx2 ext4 mbcache
jbd2 sr_mod cdrom sd_mod crc_t10dif pata_acpi ata_generic ata_piix
ocz10xx(U) mptsas mptscsih mptbase mpt2sas scsi_transport_sas
raid_class dm_mirror dm_region_hash dm_log dm_mod [last unloaded:
speedstep_lib]
<4>
<4>Pid: 4408, comm: xfslogd/3 Tainted: P           ---------------
2.6.32-358.2.1.el6.x86_64 #1 Dell Inc. PowerEdge T410/0H19HD
<4>RIP: 0010:[<ffffffffa057b14e>]  [<ffffffffa057b14e>]
__xfs_printk+0xe/0x50 [xfs]
<4>RSP: 0018:ffff8807f99a1d30  EFLAGS: 00010206
<4>RAX: ffff8807f99a1d40 RBX: 0000000000000002 RCX: 0000000000000002
<4>RDX: ffff8807f99a1d60 RSI: 0000000500000006 RDI: ffffffffa058d4de
<4>RBP: ffff8807f99a1d30 R08: 000000000000041c R09: ffffffffa058c9e0
<4>R10: 0000000000000003 R11: 0000000000000000 R12: 0000000500000006
<4>R13: 0000000000000002 R14: 0000000000000000 R15: ffffe8fbe9a2d208
<4>FS:  0000000000000000(0000) GS:ffff880028220000(0000) knlGS:0000000000000000
<4>CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
<4>CR2: 00000005000000fe CR3: 0000000001a85000 CR4: 00000000000007e0
<4>DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
<4>DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
<4>Process xfslogd/3 (pid: 4408, threadinfo ffff8807f99a0000, task
ffff8807f8afeaa0)
<4>Stack:
<4> ffff8807f99a1da0 ffffffffa057b243 0000000000000010 ffff8807f99a1db0
<4><d> ffff8807f99a1d70 ffffffffa057b171 ffffffffa0589438 ffff8807f99a1d40
<4><d> ffff880700000030 ffff8807f99a1de0 ffffffffa0586570 0000000000000002
<4>Call Trace:
<4> [<ffffffffa057b243>] xfs_notice+0x53/0x60 [xfs]
<4> [<ffffffffa057b171>] ? __xfs_printk+0x31/0x50 [xfs]
<4> [<ffffffffa056fc6d>] xfs_do_force_shutdown+0xed/0x170 [xfs]
<4> [<ffffffffa0559e51>] ? xlog_iodone+0xa1/0xb0 [xfs]
<4> [<ffffffffa0559e51>] xlog_iodone+0xa1/0xb0 [xfs]
<4> [<ffffffffa0574c30>] ? xfs_buf_iodone_work+0x0/0x50 [xfs]
<4> [<ffffffffa0574c56>] xfs_buf_iodone_work+0x26/0x50 [xfs]
<4> [<ffffffff81090ae0>] worker_thread+0x170/0x2a0
<4> [<ffffffff81096ca0>] ? autoremove_wake_function+0x0/0x40
<4> [<ffffffff81090970>] ? worker_thread+0x0/0x2a0
<4> [<ffffffff81096936>] kthread+0x96/0xa0
<4> [<ffffffff8100c0ca>] child_rip+0xa/0x20
<4> [<ffffffff810968a0>] ? kthread+0x0/0xa0
<4> [<ffffffff8100c0c0>] ? child_rip+0x0/0x20
<4>Code: 58 a0 c7 44 24 08 01 00 00 00 e8 de 96 d0 e0 c9 c3 66 66 66
2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 0f 1f 44 00 00 48 85 f6 74 2a
<48> 8b 86 f8 00 00 00 48 85 c0 74 1e 48 89 d1 48 89 fe 48 89 c2
<1>RIP  [<ffffffffa057b14e>] __xfs_printk+0xe/0x50 [xfs]
<4> RSP <ffff8807f99a1d30>
<4>CR2: 00000005000000fe

-------------------------------------------------------------

---------------- another system log:
<1>XFS (<device>): metadata I/O error: block 0xa01edc ("xlog_iodone")
error 5 buf count 1024
<5>XFS (<device>): xfs_do_force_shutdown(0x2) called from line 1052 of
file fs/xfs/xfs_log.c.  Return address = 0xffffffffa0756e51
<1>XFS (<device>): Log I/O Error Detected.  Shutting down filesystem
<1>XFS (<device>): Please umount the filesystem and rectify the problem(s)
<4>XFS (<device>): xfs_log_force: error 5 returned.
<5>XFS (<device>): xfs_do_force_shutdown(0x1) called from line 1063 of
file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xffffffffa0772693
<4>XFS (<device>): xfs_log_force: error 5 returned.
<4>XFS (<device>): xfs_log_force: error 5 returned.
<5>sd 3:0:0:2: [sde] Synchronizing SCSI cache
...
<1>XFS: metadata I/O error: block 0xa01eda ("xlog_iodone") error 5 buf
count 1024
<1>BUG: unable to handle kernel NULL pointer dereference at (null)
<1>IP: [<ffffffffa0756e37>] xlog_iodone+0x87/0xb0 [xfs]
<4>PGD 3544bd067 PUD 246d05067 PMD 0
<4>Oops: 0000 [#1] SMP
<4>last sysfs file:
/sys/devices/pci0000:00/0000:00:0a.0/0000:02:00.0/host3/port-3:0/end_device-3:0/target3:0:0/3:0:0:2/delete
<4>CPU 1
<4>Modules linked in: xfs exportfs fiop(P)(U) sunrpc ipt_REJECT
nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT
nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter
ip6_tables ipv6 uinput power_meter sg dcdbas microcode serio_raw
iTCO_wdt iTCO_vendor_support i7core_edac edac_core bnx2 ext4 mbcache
jbd2 sr_mod cdrom sd_mod crc_t10dif pata_acpi ata_generic ata_piix
mptsas mptscsih mptbase ocz10xx(U) mpt2sas scsi_transport_sas
raid_class dm_mirror dm_region_hash dm_log dm_mod [last unloaded:
fiop]
<4>
<4>Pid: 5552, comm: xfslogd/1 Tainted: P           ---------------
2.6.32-358.2.1.el6.x86_64 #1 Dell Inc. PowerEdge T410/0H19HD
<4>RIP: 0010:[<ffffffffa0756e37>]  [<ffffffffa0756e37>]
xlog_iodone+0x87/0xb0 [xfs]
<4>RSP: 0018:ffff88080c113df0  EFLAGS: 00010246
<4>RAX: 0000000000000055 RBX: ffff880828809980 RCX: 0000000000002f3d
<4>RDX: 0000000000000000 RSI: 0000000000000046 RDI: ffff880827243200
<4>RBP: ffff88080c113e10 R08: 0000000000042702 R09: 00000000fffffffb
<4>R10: 0000000000000003 R11: 0000000000000000 R12: 0000000000000000
<4>R13: ffff880827243200 R14: ffff88080c113fd8 R15: ffffe8fbe9a0cec8
<4>FS:  0000000000000000(0000) GS:ffff880028200000(0000) knlGS:0000000000000000
<4>CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
<4>CR2: 0000000000000000 CR3: 000000027a961000 CR4: 00000000000007e0
<4>DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
<4>DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
<4>Process xfslogd/1 (pid: 5552, threadinfo ffff88080c112000, task
ffff880826be2aa0)
<4>Stack:
<4> ffff88080c113e30 ffff880827243200 ffffe8fbe9a0cec0 ffffffffa0771c30
<4><d> ffff88080c113e30 ffffffffa0771c56 ffffe8fbe9a0cec0 ffffe8fbe9a0cec0
<4><d> ffff88080c113ee0 ffffffff81090ae0 0000000000000000 0000000000000000
<4>Call Trace:
<4> [<ffffffffa0771c30>] ? xfs_buf_iodone_work+0x0/0x50 [xfs]
<4> [<ffffffffa0771c56>] xfs_buf_iodone_work+0x26/0x50 [xfs]
<4> [<ffffffff81090ae0>] worker_thread+0x170/0x2a0
<4> [<ffffffff81096ca0>] ? autoremove_wake_function+0x0/0x40
<4> [<ffffffff81090970>] ? worker_thread+0x0/0x2a0
<4> [<ffffffff81096936>] kthread+0x96/0xa0
<4> [<ffffffff8100c0ca>] child_rip+0xa/0x20
<4> [<ffffffff810968a0>] ? kthread+0x0/0xa0
<4> [<ffffffff8100c0c0>] ? child_rip+0x0/0x20
<4>Code: e8 4c 8b 65 f0 4c 8b 6d f8 c9 c3 66 0f 1f 84 00 00 00 00 00
48 c7 c6 f8 2d 78 a0 4c 89 ef e8 c1 93 01 00 4c 89 ef e8 29 8a 01 00
<49> 8b 3c 24 be 02 00 00 00 b9 1c 04 00 00 48 c7 c2 e0 99 78 a0
<1>RIP  [<ffffffffa0756e37>] xlog_iodone+0x87/0xb0 [xfs]
<4> RSP <ffff88080c113df0>
<4>CR2: 0000000000000000

---------------- crash core for 2nd case is available:
PID: 5552   TASK: ffff880826be2aa0  CPU: 1   COMMAND: "xfslogd/1"
 #0 [ffff88080c1139e0] machine_kexec at ffffffff81035bbb
 #1 [ffff88080c113a40] crash_kexec at ffffffff810c0dd2
 #2 [ffff88080c113b10] oops_end at ffffffff81511450
 #3 [ffff88080c113b40] no_context at ffffffff81046bfb
 #4 [ffff88080c113b90] __bad_area_nosemaphore at ffffffff81046e85
 #5 [ffff88080c113be0] bad_area_nosemaphore at ffffffff81046f53
 #6 [ffff88080c113bf0] __do_page_fault at ffffffff810476b1
 #7 [ffff88080c113d10] do_page_fault at ffffffff8151339e
 #8 [ffff88080c113d40] page_fault at ffffffff81510755
    [exception RIP: xlog_iodone+135]
    RIP: ffffffffa0756e37  RSP: ffff88080c113df0  RFLAGS: 00010246
    RAX: 0000000000000055  RBX: ffff880828809980  RCX: 0000000000002f3d
    RDX: 0000000000000000  RSI: 0000000000000046  RDI: ffff880827243200
    RBP: ffff88080c113e10   R8: 0000000000042702   R9: 00000000fffffffb
    R10: 0000000000000003  R11: 0000000000000000  R12: 0000000000000000
    R13: ffff880827243200  R14: ffff88080c113fd8  R15: ffffe8fbe9a0cec8
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #9 [ffff88080c113e18] xfs_buf_iodone_work at ffffffffa0771c56 [xfs]
#10 [ffff88080c113e38] worker_thread at ffffffff81090ae0
#11 [ffff88080c113ee8] kthread at ffffffff81096936
#12 [ffff88080c113f48] kernel_thread at ffffffff8100c0ca

On 18 June 2013 04:19, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Jun 17, 2013 at 06:38:56PM +0400, Vlad Bespalov wrote:
>> CentOS 6.4 kernel 2.6.32-358.2.1.el6.x86_64
>> i`ll try to make a script that can be used out-of-house.
>>
>> several requests may have failed (un)conveniently, so we have passed
>> through setting XLOG_IO_ERROR in xfs_log_force_unmount() and
>> eventually skipped xlog_wait altogether:
>> -----------------
>> <1>XFS (<device>): metadata I/O error: block 0xa03e1d ("xlog_iodone")
>> error 5 buf count 1024
>> <5>XFS (<device>): xfs_do_force_shutdown(0x2) called from line 1052 of
>> file fs/xfs/xfs_log.c.  Return address = 0xffffffffa0559e51
>> <1>XFS (<device>): Log I/O Error Detected.  Shutting down filesystem
>> <1>XFS (<device>): Please umount the filesystem and rectify the problem(s)
>> <4>XFS (<device>): xfs_log_force: error 5 returned.
>> <5>XFS (<device>): xfs_do_force_shutdown(0x1) called from line 1063 of
>> file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xffffffffa0575
>> <4>XFS (<device>): xfs_log_force: error 5 returned.
>> <4>XFS (<device>): xfs_log_force: error 5 returned.
>> ...
>> <1>XFS (mtab~): metadata I/O error: block 0xa03e1b ("xlog_iodone")
>> error 5 buf count 1024
>
> And the rest of dmesg showing the stack trace of the oops?
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
