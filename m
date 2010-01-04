Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o04AsjOV101603 for <xfs@oss.sgi.com>; Mon, 4 Jan 2010 04:54:45 -0600
Received: from smtpout5.poczta.onet.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5AB791DAD6BD
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2010 02:55:34 -0800 (PST)
Received: from smtpout5.poczta.onet.pl (smtpout5.poczta.onet.pl
	[213.180.147.165]) by cuda.sgi.com with ESMTP id
	KY46hWacuCJR7U6u for <xfs@oss.sgi.com>;
	Mon, 04 Jan 2010 02:55:34 -0800 (PST)
Received: from ip-83-238-22-2.netia.com.pl ([83.238.22.2]:53059 "EHLO
	[192.168.248.143]" rhost-flags-OK-FAIL-OK-FAIL) by ps1.m5r2.onet
	with ESMTPSA id S50332326Ab0ADKzdNoqjv (ORCPT
	<rfc822;xfs@oss.sgi.com>); Mon, 4 Jan 2010 11:55:33 +0100
Message-ID: <4B41D724.1090805@poczta.onet.pl>
Date: Mon, 04 Jan 2010 12:55:16 +0100
From: aluno3 <aluno3@poczta.onet.pl>
MIME-Version: 1.0
Subject: Re: Call trace with 2.6.27.39
References: <4B40E90D.4030409@poczta.onet.pl>
In-Reply-To: <4B40E90D.4030409@poczta.onet.pl>
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
To: david@fromorbit.com
Cc: xfs@oss.sgi.com

Sorry for my delay,
>
> On Tue, Dec 29, 2009 at 07:18:32PM +0100, aluno3 wrote:
>   
>> Hi
>>  
>> I have tested kernel 2.6.27.39 with fsstress, LVM, DD and snapshots and after a few hours I got call trace.I had 2 volumes and 10 snapshots for each volume.I created and deleted these snapshots from time to time and wrote to origin volumes with use DD from /dev/zero.Fsstress was run for 1 volume.
>>
>>
>> Filesystem "dm-41": xfs_log_force: error 5 returned.
>>     
>
> What were the errors in the log before this? i.e. why did
> xfs_log_force() get an EIO error? It sounds like there's something
> already gone wrong before this point.
>   
This error probably occurred after overflowing and umounting the snapshot.
>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
>> IP: [<ffffffff802e99c3>] bdevname+0x3/0x20
>>     
> ....
>   
>> Process xfslogd/0 (pid: 404, threadinfo ffff88021d956000, task ffff88021fafd890)
>> Stack:  ffffffff803e7526 ffff880028046970 ffffffff80817020 ffff88021d957e38
>>  00000000ffff8b92 ffff88021fafdac0 ffff88021fafd890 000000001d957eb8
>>  ffff880207fe8800 ffff88007fbf6cc0 ffff88021d937bc8 ffff88021d937bc8
>> Call Trace:
>>  [<ffffffff803e7526>] ? xfs_ioerror_alert+0x56/0xc0
>>  [<ffffffff803d5060>] ? xlog_recover_iodone+0x40/0x90
>>  [<ffffffff803eaa60>] ? xfs_buf_iodone_work+0x0/0x80
>>     
>
> This has died during log recovery (on a different filesytem?), which
> implies that a buffer has not been set up properly with a buftarg or
> mount stucture. I can't see how that would happen from the code
> because each place that explicitly sets xlog_recover_iodone() as the
> completion also sets the bp->b_mount correctly. Still, there's been
> an IO error of some kind to get to xfs_ioerror_alert(), so it comes
> back to whether there were errors reported before this failure?
>
> Also, were you mounting a snapshot when this occurred? If so, you
> shouldn't be doing log recovery on a snapshot because that writes to
> the snapshot - you should mount them with the "ro,norecovery"
> options to avoid this.
>   
As I wrote above this call trace probably occurred after umounting the
snapshots which was mounted with
"rw,noatime,nouuid,attr2,nobarrier,noquota" options.I will try reproduce
this error again and check if it is repetitious and which command cause
this call trace.

I send you whole dmesg:

Filesystem "dm-61": xfs_log_force: error 5 returned.
Filesystem "dm-61": xfs_log_force: error 5 returned.
xfs_force_shutdown(dm-61,0x1) called from line 420 of file fs/xfs/xfs_rw.c.  Return address = 0xffffffff803e776e
Filesystem "dm-61": xfs_log_force: error 5 returned.
Filesystem "dm-61": xfs_log_force: error 5 returned.
xfs_force_shutdown(dm-61,0x1) called from line 420 of file fs/xfs/xfs_rw.c.  Return address = 0xffffffff803e776e
Filesystem "dm-61": xfs_log_force: error 5 returned.
Filesystem "dm-61": xfs_log_force: error 5 returned.
xfs_force_shutdown(dm-61,0x1) called from line 420 of file fs/xfs/xfs_rw.c.  Return address = 0xffffffff803e776e
Filesystem "dm-61": xfs_log_force: error 5 returned.
Filesystem "dm-61": xfs_log_force: error 5 returned.
Filesystem "dm-61": xfs_log_force: error 5 returned.
Filesystem "dm-61": xfs_log_force: error 5 returned.
Filesystem "dm-61": xfs_log_force: error 5 returned.
Filesystem "dm-41": Disabling barriers, trial barrier write failed
XFS mounting filesystem dm-41
Starting XFS recovery on filesystem: dm-41 (logdev: internal)
XFS resetting qflags for filesystem dm-41
Ending XFS recovery on filesystem: dm-41 (logdev: internal)
Filesystem "dm-42": Disabling barriers, trial barrier write failed
XFS mounting filesystem dm-42
Starting XFS recovery on filesystem: dm-42 (logdev: internal)
XFS resetting qflags for filesystem dm-42
Ending XFS recovery on filesystem: dm-42 (logdev: internal)
Filesystem "dm-43": Disabling barriers, trial barrier write failed
XFS mounting filesystem dm-43
Starting XFS recovery on filesystem: dm-43 (logdev: internal)
device-mapper: snapshots: Invalidating snapshot: Unable to allocate exception.
XFS resetting qflags for filesystem dm-43
Ending XFS recovery on filesystem: dm-43 (logdev: internal)
xfs_force_shutdown(dm-41,0x1) called from line 420 of file fs/xfs/xfs_rw.c.  Return address = 0xffffffff803e776e
Filesystem "dm-41": I/O Error Detected.  Shutting down filesystem: dm-41
Please umount the filesystem, and rectify the problem(s)
Filesystem "dm-41": xfs_log_force: error 5 returned.
Filesystem "dm-41": xfs_log_force: error 5 returned.
xfs_force_shutdown(dm-41,0x1) called from line 420 of file fs/xfs/xfs_rw.c.  Return address = 0xffffffff803e776e
Filesystem "dm-41": xfs_log_force: error 5 returned.
Filesystem "dm-41": xfs_log_force: error 5 returned.
xfs_force_shutdown(dm-41,0x1) called from line 420 of file fs/xfs/xfs_rw.c.  Return address = 0xffffffff803e776e
Filesystem "dm-41": xfs_log_force: error 5 returned.
Filesystem "dm-41": xfs_log_force: error 5 returned.
xfs_force_shutdown(dm-41,0x1) called from line 420 of file fs/xfs/xfs_rw.c.  Return address = 0xffffffff803e776e
Filesystem "dm-41": xfs_log_force: error 5 returned.
Filesystem "dm-41": xfs_log_force: error 5 returned.
xfs_force_shutdown(dm-41,0x1) called from line 420 of file fs/xfs/xfs_rw.c.  Return address = 0xffffffff803e776e
Filesystem "dm-41": xfs_log_force: error 5 returned.
Filesystem "dm-41": xfs_log_force: error 5 returned.
Filesystem "dm-41": xfs_log_force: error 5 returned.
Filesystem "dm-41": xfs_log_force: error 5 returned.
xfs_force_shutdown(dm-41,0x1) called from line 420 of file fs/xfs/xfs_rw.c.  Return address = 0xffffffff803e776e
Filesystem "dm-41": xfs_log_force: error 5 returned.
Filesystem "dm-44": Disabling barriers, trial barrier write failed
XFS mounting filesystem dm-44
Filesystem "dm-41": xfs_log_force: error 5 returned.
Filesystem "dm-41": xfs_log_force: error 5 returned.
device-mapper: snapshots: Invalidating snapshot: Unable to allocate exception.
Filesystem "dm-41": xfs_log_force: error 5 returned.
device-mapper: snapshots: Invalidating snapshot: Unable to allocate exception.
Starting XFS recovery on filesystem: dm-44 (logdev: internal)
Filesystem "dm-41": xfs_log_force: error 5 returned.
Filesystem "dm-41": xfs_log_force: error 5 returned.
xfs_force_shutdown(dm-41,0x1) called from line 420 of file fs/xfs/xfs_rw.c.  Return address = 0xffffffff803e776e
xfs_force_shutdown(dm-42,0x1) called from line 420 of file fs/xfs/xfs_rw.c.  Return address = 0xffffffff803e776e
Filesystem "dm-42": I/O Error Detected.  Shutting down filesystem: dm-42
Please umount the filesystem, and rectify the problem(s)
xfs_force_shutdown(dm-43,0x1) called from line 420 of file fs/xfs/xfs_rw.c.  Return address = 0xffffffff803e776e
Filesystem "dm-43": I/O Error Detected.  Shutting down filesystem: dm-43
Please umount the filesystem, and rectify the problem(s)
device-mapper: snapshots: Invalidating snapshot: Unable to allocate exception.
I/O error in filesystem ("dm-44") meta-data dev dm-44 block 0x2088       ("xlog_recover_do..(read#1)") error 5 buf count 4096
XFS: log mount/recovery failed: error 5
XFS: log mount failed
I/O error in filesystem ("dm-44") meta-data dev dm-44 block 0x7d7820       ("xlog_recover_iodone") error 5 buf count 4096
xfs_force_shutdown(dm-44,0x1) called from line 285 of file fs/xfs/xfs_log_recover.c.  Return address = 0xffffffff803d5079
Filesystem "dm-44": I/O Error Detected.  Shutting down filesystem: dm-44
Please umount the filesystem, and rectify the problem(s)
I/O error in filesystem ("dm-44") meta-data dev dm-44 block 0x105a8       ("xlog_recover_iodone") error 5 buf count 4096
xfs_force_shutdown(dm-44,0x1) called from line 285 of file fs/xfs/xfs_log_recover.c.  Return address = 0xffffffff803d5079
I/O error in filesystem ("dm-44") meta-data dev dm-44 block 0x7cb0       ("xlog_recover_iodone") error 5 buf count 4096
xfs_force_shutdown(dm-44,0x1) called from line 285 of file fs/xfs/xfs_log_recover.c.  Return address = 0xffffffff803d5079
I/O error in filesystem ("dm-44") meta-data dev dm-44 block 0x1772dd8       ("xlog_recover_iodone") error 5 buf count 4096
xfs_force_shutdown(dm-44,0x1) called from line 285 of file fs/xfs/xfs_log_recover.c.  Return address = 0xffffffff803d5079
I/O error in filesystem ("dm-44") meta-data dev dm-44 block 0x18       ("xlog_recover_iodone") error 5 buf count 4096
xfs_force_shutdown(dm-44,0x1) called from line 285 of file fs/xfs/xfs_log_recover.c.  Return address = 0xffffffff803d5079
I/O error in filesystem ("dm-44") meta-data dev dm-44 block 0x2       ("xlog_recover_iodone") error 5 buf count 512
xfs_force_shutdown(dm-44,0x1) called from line 285 of file fs/xfs/xfs_log_recover.c.  Return address = 0xffffffff803d5079
I/O error in filesystem ("dm-44") meta-data dev dm-44 block 0x39a90       ("xlog_recover_iodone") error 5 buf count 8192
xfs_force_shutdown(dm-44,0x1) called from line 285 of file fs/xfs/xfs_log_recover.c.  Return address = 0xffffffff803d5079
I/O error in filesystem ("dm-44") meta-data dev dm-44 block 0x7d0018       ("xlog_recover_iodone") error 5 buf count 4096
xfs_force_shutdown(dm-44,0x1) called from line 285 of file fs/xfs/xfs_log_recover.c.  Return address = 0xffffffff803d5079
I/O error in filesystem ("dm-44") meta-data dev dm-44 block 0x7d0002       ("xlog_recover_iodone") error 5 buf count 512
xfs_force_shutdown(dm-44,0x1) called from line 285 of file fs/xfs/xfs_log_recover.c.  Return address = 0xffffffff803d5079
I/O error in filesystem ("dm-44") meta-data dev dm-44 block 0x7d0008       ("xlog_recover_iodone") error 5 buf count 4096
xfs_force_shutdown(dm-44,0x1) called from line 285 of file fs/xfs/xfs_log_recover.c.  Return address = 0xffffffff803d5079
I/O error in filesystem ("dm-44") meta-data dev dm-44 block 0x7d0010       ("xlog_recover_iodone") error 5 buf count 4096
xfs_force_shutdown(dm-44,0x1) called from line 285 of file fs/xfs/xfs_log_recover.c.  Return address = 0xffffffff803d5079
I/O error in filesystem ("dm-44") meta-data dev dm-44 block 0x7d0001       ("xlog_recover_iodone") error 5 buf count 512
xfs_force_shutdown(dm-44,0x1) called from line 285 of file fs/xfs/xfs_log_recover.c.  Return address = 0xffffffff803d5079
I/O error in filesystem ("dm-44") meta-data dev dm-44 block 0x1770008       ("xlog_recover_iodone") error 5 buf count 4096
xfs_force_shutdown(dm-44,0x1) called from line 285 of file fs/xfs/xfs_log_recover.c.  Return address = 0xffffffff803d5079
I/O error in filesystem ("dm-44") meta-data dev dm-44 block 0x1770010       ("xlog_recover_iodone") error 5 buf count 4096
xfs_force_shutdown(dm-44,0x1) called from line 285 of file fs/xfs/xfs_log_recover.c.  Return address = 0xffffffff803d5079
I/O error in filesystem ("dm-44") meta-data dev dm-44 block 0x1770001       ("xlog_recover_iodone") error 5 buf count 512
xfs_force_shutdown(dm-44,0x1) called from line 285 of file fs/xfs/xfs_log_recover.c.  Return address = 0xffffffff803d5079
I/O error in filesystem ("dm-44") meta-data dev dm-44 block 0xfa0008       ("xlog_recover_iodone") error 5 buf count 4096
xfs_force_shutdown(dm-44,0x1) called from line 285 of file fs/xfs/xfs_log_recover.c.  Return address = 0xffffffff803d5079
I/O error in filesystem ("dm-44") meta-data dev dm-44 block 0xfa0010       ("xlog_recover_iodone") error 5 buf count 4096
xfs_force_shutdown(dm-44,0x1) called from line 285 of file fs/xfs/xfs_log_recover.c.  Return address = 0xffffffff803d5079
I/O error in filesystem ("dm-44") meta-data dev dm-44 block 0xfa0001       ("xlog_recover_iodone") error 5 buf count 512
xfs_force_shutdown(dm-44,0x1) called from line 285 of file fs/xfs/xfs_log_recover.c.  Return address = 0xffffffff803d5079
I/O error in filesystem ("dm-44") meta-data dev dm-44 block 0x8       ("xlog_recover_iodone") error 5 buf count 4096
xfs_force_shutdown(dm-44,0x1) called from line 285 of file fs/xfs/xfs_log_recover.c.  Return address = 0xffffffff803d5079
I/O error in filesystem ("dm-44") meta-data dev dm-44 block 0x10       ("xlog_recover_iodone") error 5 buf count 4096
xfs_force_shutdown(dm-44,0x1) called from line 285 of file fs/xfs/xfs_log_recover.c.  Return address = 0xffffffff803d5079
I/O error in filesystem ("dm-44") meta-data dev dm-44 block 0x1       ("xlog_recover_iodone") error 5 buf count 512
xfs_force_shutdown(dm-44,0x1) called from line 285 of file fs/xfs/xfs_log_recover.c.  Return address = 0xffffffff803d5079
I/O error in filesystem ("dm-44") meta-data dev dm-44 block 0x0       ("xlog_recover_iodone") error 5 buf count 512
xfs_force_shutdown(dm-44,0x1) called from line 285 of file fs/xfs/xfs_log_recover.c.  Return address = 0xffffffff803d5079
Filesystem "dm-41": xfs_log_force: error 5 returned.
BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
IP: [<ffffffff802e99c3>] bdevname+0x3/0x20
PGD 0 
Oops: 0000 [1] SMP 
CPU 0 
Modules linked in: iscsi_scst scst_vdisk scst drbd twofish twofish_common serpent blowfish cast5 sha256_generic crypto_null iscsi_tcp libiscsi scsi_transport_iscsi bonding button thermal processor e1000e sg ftdi_sio usbserial nls_iso8859_1 nls_cp437 arcmsr uhci_hcd ohci_hcd ehci_hcd vfat fat aufs [last unloaded: ohci_hcd]
Pid: 404, comm: xfslogd/0 Not tainted 2.6.27.39-oe64-00000-g92ed9a0 #65
RIP: 0010:[<ffffffff802e99c3>]  [<ffffffff802e99c3>] bdevname+0x3/0x20
RSP: 0000:ffff88021d957de8  EFLAGS: 00010286
RAX: ffff88021d957e00 RBX: ffff88007fbf6cc0 RCX: 0000000001770520
RDX: ffff88007fbf6cc0 RSI: ffff88021d957e00 RDI: 0000000000000000
RBP: ffff880207fe8800 R08: ffff88021d956000 R09: 0000000000000000
R10: 0000000000000000 R11: ffffffff803d5020 R12: 0000000001770520
R13: ffffffff8078cf02 R14: ffff88021d957e00 R15: 0000000000000005
FS:  0000000000000000(0000) GS:ffffffff80952080(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process xfslogd/0 (pid: 404, threadinfo ffff88021d956000, task ffff88021fafd890)
Stack:  ffffffff803e7526 ffff880028046970 ffffffff80817020 ffff88021d957e38
 00000000ffff8b92 ffff88021fafdac0 ffff88021fafd890 000000001d957eb8
 ffff880207fe8800 ffff88007fbf6cc0 ffff88021d937bc8 ffff88021d937bc8
Call Trace:
 [<ffffffff803e7526>] ? xfs_ioerror_alert+0x56/0xc0
 [<ffffffff803d5060>] ? xlog_recover_iodone+0x40/0x90
 [<ffffffff803eaa60>] ? xfs_buf_iodone_work+0x0/0x80
 [<ffffffff8024692a>] ? run_workqueue+0x5a/0x110
 [<ffffffff80246a7c>] ? worker_thread+0x9c/0xf0
 [<ffffffff8024a7b0>] ? autoremove_wake_function+0x0/0x30
 [<ffffffff8024a7b0>] ? autoremove_wake_function+0x0/0x30
 [<ffffffff802469e0>] ? worker_thread+0x0/0xf0
 [<ffffffff80249fcc>] ? kthread+0x6c/0xa0
 [<ffffffff8020d1c9>] ? child_rip+0xa/0x11
 [<ffffffff80249f60>] ? kthread+0x0/0xa0
 [<ffffffff8020d1bf>] ? child_rip+0x0/0x11


Code: 13 00 48 89 d8 5b c3 48 89 df 48 c7 c2 ea b5 7a 80 be 20 00 00 00 31 c0 e8 cb e7 13 00 48 89 d8 5b c3 66 66 90 66 66 90 48 89 f0 <8b> 37 48 8b bf 98 00 00 00 48 89 c2 81 e6 ff ff 0f 00 2b 77 04 
RIP  [<ffffffff802e99c3>] bdevname+0x3/0x20
 RSP <ffff88021d957de8>
CR2: 0000000000000000
---[ end trace e0541894570554ab ]---
Filesystem "dm-41": xfs_log_force: error 5 returned.
Filesystem "dm-41": xfs_log_force: error 5 returned.
xfs_force_shutdown(dm-41,0x1) called from line 420 of file fs/xfs/xfs_rw.c.  Return address = 0xffffffff803e776e
Filesystem "dm-42": xfs_log_force: error 5 returned.
Filesystem "dm-42": xfs_log_force: error 5 returned.
xfs_force_shutdown(dm-42,0x1) called from line 420 of file fs/xfs/xfs_rw.c.  Return address = 0xffffffff803e776e
Filesystem "dm-43": xfs_log_force: error 5 returned.
Filesystem "dm-43": xfs_log_force: error 5 returned.
xfs_force_shutdown(dm-43,0x1) called from line 420 of file fs/xfs/xfs_rw.c.  Return address = 0xffffffff803e776e
Filesystem "dm-41": xfs_log_force: error 5 returned.
Filesystem "dm-41": xfs_log_force: error 5 returned.
xfs_force_shutdown(dm-41,0x1) called from line 420 of file fs/xfs/xfs_rw.c.  Return address = 0xffffffff803e776e
Filesystem "dm-42": xfs_log_force: error 5 returned.
Filesystem "dm-42": xfs_log_force: error 5 returned.
xfs_force_shutdown(dm-42,0x1) called from line 420 of file fs/xfs/xfs_rw.c.  Return address = 0xffffffff803e776e
Filesystem "dm-43": xfs_log_force: error 5 returned.
Filesystem "dm-43": xfs_log_force: error 5 returned.
xfs_force_shutdown(dm-43,0x1) called from line 420 of file fs/xfs/xfs_rw.c.  Return address = 0xffffffff803e776e
Filesystem "dm-42": xfs_log_force: error 5 returned.
Filesystem "dm-41": xfs_log_force: error 5 returned.
Filesystem "dm-41": xfs_log_force: error 5 returned.
xfs_force_shutdown(dm-41,0x1) called from line 420 of file fs/xfs/xfs_rw.c.  Return address = 0xffffffff803e776e
Filesystem "dm-42": xfs_log_force: error 5 returned.
Filesystem "dm-42": xfs_log_force: error 5 returned.
xfs_force_shutdown(dm-42,0x1) called from line 420 of file fs/xfs/xfs_rw.c.  Return address = 0xffffffff803e776e
Filesystem "dm-43": xfs_log_force: error 5 returned.
Filesystem "dm-43": xfs_log_force: error 5 returned.
xfs_force_shutdown(dm-43,0x1) called from line 420 of file fs/xfs/xfs_rw.c.  Return address = 0xffffffff803e776e
Filesystem "dm-41": xfs_log_force: error 5 returned.
Filesystem "dm-41": xfs_log_force: error 5 returned.
xfs_force_shutdown(dm-41,0x1) called from line 420 of file fs/xfs/xfs_rw.c.  Return address = 0xffffffff803e776e
Filesystem "dm-42": xfs_log_force: error 5 returned.
Filesystem "dm-42": xfs_log_force: error 5 returned.
xfs_force_shutdown(dm-42,0x1) called from line 420 of file fs/xfs/xfs_rw.c.  Return address = 0xffffffff803e776e
Filesystem "dm-43": xfs_log_force: error 5 returned.
Filesystem "dm-43": xfs_log_force: error 5 returned.
xfs_force_shutdown(dm-43,0x1) called from line 420 of file fs/xfs/xfs_rw.c.  Return address = 0xffffffff803e776e
Filesystem "dm-43": xfs_log_force: error 5 returned.
Filesystem "dm-41": xfs_log_force: error 5 returned.
Filesystem "dm-41": xfs_log_force: error 5 returned.
xfs_force_shutdown(dm-41,0x1) called from line 420 of file fs/xfs/xfs_rw.c.  Return address = 0xffffffff803e776e
Filesystem "dm-42": xfs_log_force: error 5 returned.
Filesystem "dm-42": xfs_log_force: error 5 returned.
xfs_force_shutdown(dm-42,0x1) called from line 420 of file fs/xfs/xfs_rw.c.  Return address = 0xffffffff803e776e
Filesystem "dm-43": xfs_log_force: error 5 returned.
Filesystem "dm-43": xfs_log_force: error 5 returned.
xfs_force_shutdown(dm-43,0x1) called from line 420 of file fs/xfs/xfs_rw.c.  Return address = 0xffffffff803e776e
Filesystem "dm-41": xfs_log_force: error 5 returned.
Filesystem "dm-42": xfs_log_force: error 5 returned.
Filesystem "dm-43": xfs_log_force: error 5 returned.




> Cheers,
>
> Dave.
>   


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
