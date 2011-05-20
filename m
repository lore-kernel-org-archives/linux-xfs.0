Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4KMZjZd115362 for <xfs@oss.sgi.com>; Fri, 20 May 2011 17:35:46 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6A6B71342AF9
	for <xfs@oss.sgi.com>; Fri, 20 May 2011 15:35:43 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id TQndSZpaDPkF2B97 for <xfs@oss.sgi.com>;
	Fri, 20 May 2011 15:35:43 -0700 (PDT)
Message-ID: <4DD6ECBE.3030106@sandeen.net>
Date: Fri, 20 May 2011 17:35:42 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS mount via 2.6.38.5 fails - suggestions?
References: <BANLkTikHE1iBrhLf-Y2F_YXoxFEW_Ybvhw@mail.gmail.com>
In-Reply-To: <BANLkTikHE1iBrhLf-Y2F_YXoxFEW_Ybvhw@mail.gmail.com>
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
To: Paul Anderson <pha@umich.edu>
Cc: xfs@oss.sgi.com

On 5/20/11 8:41 AM, Paul Anderson wrote:
> The following traceback comes when we try to mount what appears to now
> be a corrupted filesystem.  We have backups of all small files, but
> would like to copy off additional large files that were not backed up.
>  The hardware the filesystem is on is currently working, but has a
> checkered past (4 power outages over 2 years, lots of unrelated kernel
> crashes, etc).  The filesystem is mounted on an LVM that spans about 6
> hardware RAID6 arrays.  The last events that might have triggered the
> problem were an unplanned power outage Monday, followed up on Tuesday
> by a user who remove 7T of data.
> 
> I can't mount the FS, otherwise, I'd also include the xfs_info output
> - but the settings were all stock from plain, unadorned mkfs.xfs
> 
> I have not attempted any recovery.  We tried two versions of the
> kernel, 2.6.35 (our cluster version) and 2.6.38.5, which the report
> below is from.
> 
> Can I mount readonly without playing the log without causing any
> further damage to the filesystem?  I am familiar with the
> xfs_dump/restore option, which also would be suspect given the
> apparent damage.

yes; I'd suggest mount -o ro,norecovery to get past this bug, then most
likely you can get the majority of your files off.

> It is a 70T filesystem, and I expect any recovery to be fairly long
> term (weeks, maybe longer), but I am looking for suggestions of things
> to try.

Another option might be to do an xfs_metadump, and then xfs_mdrestore
to a file image, and point xfs_repair -L at that to see what you're facing
in terms of fs corruption.  (-L would zero the log out, since it is
log replay that is going down your path to a null pointer deref,
it's one heavy-handed option).

But see below:

> Our team is also interested in recruiting a short term contractor (5
> hours?) who is qualified to look into the problem for us (preferably a
> known XFS developer).  Please let me know off list if you have ability
> and interest to look into this.
> 
> Thanks,
> 
> Paul
> 
> 
> 
> [  143.914901] XFS mounting filesystem dm-1
> [  144.125964] Starting XFS recovery on filesystem: dm-1 (logdev: internal)
> [  216.506511] BUG: unable to handle kernel NULL pointer dereference
> at 00000000000000f8
> [  216.516382] IP: [<ffffffffa046bb82>] xfs_cmn_err+0x52/0xd0 [xfs]

er null pointer deref in the error message function itself?  well that's a bummer.

So you're going down this path:

xfs_free_ag_extent
	XFS_WANT_CORRUPTED_GOTO
		XFS_ERROR_REPORT( ... mp == NULL)
			xfs_error_report(... mp ...)
				xfs_cmn_err(... mp ...)

but:

69 xfs_cmn_err(
70         int                     panic_tag,
71         const char              *lvl,
72         struct xfs_mount        *mp,
...
89         printk(KERN_ALERT "Filesystem %s: %pV", mp->m_fsname, &vaf);

so the null ptr deref is on mp.  Looks like that issue is fixed upstream.

you could just comment out the printk on line 89 of fs/xfs/support/debug.c
above, to avoid the null ptr deref but this is still the result of a corrupted
fs.

So the suggestion of xfs_metadump, xfs_mdrestore, and xfs_repair -L on the
image to see what you'd run into on a "real" repair still stands.

-Eric


> [  216.516382] PGD 1f3d9e6067 PUD 1f38547067 PMD 0
> [  216.516382] Oops: 0000 [#1] SMP
> [  216.516382] last sysfs file: /sys/devices/virtual/net/lo/type
> [  216.516382] CPU 0
> [  216.516382] Modules linked in: dlm configfs autofs4 dm_crypt xfs
> mptctl nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc ixgbe bnx2
> psmouse dca lp mdio shpchp joydev serio_raw dcdbas parport ses
> enclosure radeon fbcon ttm tileblit font bitblit softcursor
> drm_kms_helper drm e1000e mptfc mptscsih i2c_algo_bit usbhid hid
> mptbase megaraid_sas scsi_transport_fc scsi_tgt
> [  216.516382]
> [  216.516382] Pid: 2068, comm: mount Not tainted 2.6.38.5 #1 Dell
> Inc. PowerEdge R900/0X947H
> [  216.516382] RIP: 0010:[<ffffffffa046bb82>]  [<ffffffffa046bb82>]
> xfs_cmn_err+0x52/0xd0 [xfs]
> [  216.516382] RSP: 0018:ffff881f3e28f9c8  EFLAGS: 00010246
> [  216.516382] RAX: ffff881f3e28f9f8 RBX: ffff881f3e28fa08 RCX: ffffffffa0473d80
> [  216.516382] RDX: 0000000000000000 RSI: ffffffffa0478dde RDI: ffffffffa0479e17
> [  216.516382] RBP: ffff881f3e28fa48 R08: ffffffffa04789cd R09: 00000000000005f6
> [  216.516382] R10: ffff881f3dedf500 R11: 0000000000000001 R12: ffff881f3dade0d0
> [  216.516382] R13: ffff881f3d4f87a8 R14: ffff881f3dade000 R15: 0000000001cf0a0f
> [  216.516382] FS:  00007f0565c5e7e0(0000) GS:ffff8800bf400000(0000)
> knlGS:0000000000000000
> [  216.516382] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  216.516382] CR2: 00000000000000f8 CR3: 0000001f3df72000 CR4: 00000000000006f0
> [  216.516382] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  216.516382] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  216.516382] Process mount (pid: 2068, threadinfo ffff881f3e28e000,
> task ffff881f2d2396c0)
> [  216.516382] Stack:
> [  216.516382]  0000000000014680 0000000000014680 0000000000000020
> ffff881f3e28fa58
> [  216.516382]  ffff881f3e28fa08 0000000000000001 ffffffffa0473d80
> ffff881f3e28f9d8
> [  216.516382]  ffff881fb2cebf00 ffff881f3d4f87a8 ffff881f35e5b000
> ffffffffa040eb6c
> [  216.516382] Call Trace:
> [  216.516382]  [<ffffffffa040eb6c>] ? xfs_allocbt_init_cursor+0x4c/0xc0 [xfs]
> [  216.516382]  [<ffffffffa04366e0>] xfs_error_report+0x40/0x50 [xfs]
> [  216.516382]  [<ffffffffa040e3e2>] ? xfs_free_extent+0xa2/0xc0 [xfs]
> [  216.516382]  [<ffffffffa040c62c>] xfs_free_ag_extent+0x60c/0x7f0 [xfs]
> [  216.516382]  [<ffffffffa040e3e2>] xfs_free_extent+0xa2/0xc0 [xfs]
> [  216.516382]  [<ffffffffa04499c5>] xlog_recover_process_efi+0x1b5/0x200 [xfs]
> [  216.516382]  [<ffffffffa04556ca>] ? xfs_trans_ail_cursor_set+0x1a/0x30 [xfs]
> [  216.516382]  [<ffffffffa0449b57>] xlog_recover_process_efis+0x67/0xc0 [xfs]
> [  216.516382]  [<ffffffffa044dcc4>] xlog_recover_finish+0x24/0xe0 [xfs]
> [  216.516382]  [<ffffffffa04458bc>] xfs_log_mount_finish+0x2c/0x30 [xfs]
> [  216.516382]  [<ffffffffa04519d4>] xfs_mountfs+0x444/0x710 [xfs]
> [  216.516382]  [<ffffffffa0469915>] xfs_fs_fill_super+0x245/0x340 [xfs]
> [  216.516382]  [<ffffffff8114d3f3>] mount_bdev+0x1c3/0x210
> [  216.516382]  [<ffffffffa04696d0>] ? xfs_fs_fill_super+0x0/0x340 [xfs]
> [  216.516382]  [<ffffffffa0467705>] xfs_fs_mount+0x15/0x20 [xfs]
> [  216.516382]  [<ffffffff8114c8c2>] vfs_kern_mount+0x92/0x250
> [  216.516382]  [<ffffffff8114caf2>] do_kern_mount+0x52/0x110
> [  216.516382]  [<ffffffff811693f9>] do_mount+0x259/0x840
> [  216.516382]  [<ffffffff81166e6a>] ? copy_mount_options+0xfa/0x1a0
> [  216.516382]  [<ffffffff81169a70>] sys_mount+0x90/0xe0
> [  216.516382]  [<ffffffff8100bf82>] system_call_fastpath+0x16/0x1b
> [  216.516382] Code: 10 48 8d 45 90 c7 45 90 20 00 00 00 48 89 4d b0
> 48 c7 c7 17 9e 47 a0 48 89 5d 98 48 8d 5d c0 48 89 45 b8 48 8d 45 b0
> 48 89 5d a0 <48> 8b b2 f8 00 00 00 48 89 c2 31 c0 e8 d7 fc 10 e1 48 83
> c4 78
> [  216.516382] RIP  [<ffffffffa046bb82>] xfs_cmn_err+0x52/0xd0 [xfs]
> [  216.516382]  RSP <ffff881f3e28f9c8>
> [  216.516382] CR2: 00000000000000f8
> [  216.810967] ---[ end trace e790084103e4ceee ]---
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
