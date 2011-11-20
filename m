Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAKGY8ih166839 for <xfs@oss.sgi.com>; Sun, 20 Nov 2011 10:34:08 -0600
Received: from mail-iy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7CED61628540
	for <xfs@oss.sgi.com>; Sun, 20 Nov 2011 08:34:06 -0800 (PST)
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	TgyTycyCXAU2dZQ1 for <xfs@oss.sgi.com>;
	Sun, 20 Nov 2011 08:34:06 -0800 (PST)
Received: by iaen33 with SMTP id n33so7352021iae.26
	for <xfs@oss.sgi.com>; Sun, 20 Nov 2011 08:34:06 -0800 (PST)
From: Mike Krieger <mikeyk@instagram.com>
Subject: XFS / xfssyncd lock-ups on 2.6.38-8
Date: Sun, 20 Nov 2011 08:34:02 -0800
Message-Id: <A734D23E-8544-4261-A699-90B689887F46@instagram.com>
Mime-Version: 1.0 (Apple Message framework v1251.1)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

We're running a dozen Amazon AWS instances (on Ubuntu Natty Narwhal, kernel=
 2.6.38-8). We've recent brought up several machines based on some previous=
 snapshots (EBS snapshots, rather than LVM), and they've been locking up un=
der load. The dmesg output is below; does this issue look familiar, or perh=
aps fixed in a later kernel? Or could it be indicative of some data corrupt=
ion in the snapshot process? =


The drive is being used for Postgres write-ahead-logs, so it's a write-heav=
y, read-light drive. When the array (4 drives in RAID0) freezes up, nothing=
 seems to fix it short of a hard restart of the machine=97we've tried thing=
s like stopping Postgres, issuing a 'drop cache' to the kernel, and trying =
to kill the locked process, to no avail.

Would appreciate any thoughts/pointers to fixes or workarounds if this is a=
 known issue.

Thanks,
Mike

=3D=3D=3D=3D

(The /dev/md126 array that is locking up is an XFS RAID0 across 4 volumes)

The errors look like this:

[558307.361854] INFO: task xfssyncd/md126:1029 blocked for more than 120 se=
conds.
[558307.361867] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables=
 this message.
[558307.361874] xfssyncd/md126  D ffff881116f13b00     0  1029      2 0x000=
00000
[558307.361879]  ffff881088989d00 0000000000000246 ffff881088989fd8 ffff881=
088988000
[558307.361884]  0000000000013b00 ffff8810866c3120 ffff881088989fd8 0000000=
000013b00
[558307.361889]  ffff881089b84440 ffff8810866c2d80 ffffffff815dc13e ffff881=
08916e400
[558307.361894] Call Trace:
[558307.361904]  [<ffffffff815dc13e>] ? _raw_spin_unlock_irqrestore+0x1e/0x=
30
[558307.361932]  [<ffffffffa00e52d8>] xlog_grant_log_space+0x4a8/0x500 [xfs]
[558307.361937]  [<ffffffff8105f180>] ? default_wake_function+0x0/0x20
[558307.361951]  [<ffffffffa00e71ff>] xfs_log_reserve+0xff/0x140 [xfs]
[558307.361967]  [<ffffffffa00f31fc>] xfs_trans_reserve+0x9c/0x200 [xfs]
[558307.361980]  [<ffffffffa00d7383>] xfs_fs_log_dummy+0x43/0x90 [xfs]
[558307.361995]  [<ffffffffa010a3c1>] xfs_sync_worker+0x81/0x90 [xfs]
[558307.362009]  [<ffffffffa01090f3>] xfssyncd+0x183/0x230 [xfs]
[558307.362025]  [<ffffffffa0108f70>] ? xfssyncd+0x0/0x230 [xfs]
[558307.362030]  [<ffffffff81086ac6>] kthread+0x96/0xa0
[558307.362035]  [<ffffffff8100cde4>] kernel_thread_helper+0x4/0x10
[558307.362038]  [<ffffffff8100c1e3>] ? int_ret_from_sys_call+0x7/0x1b
[558307.362041]  [<ffffffff815dc621>] ? retint_restore_args+0x5/0x6
[558307.362045]  [<ffffffff8100cde0>] ? kernel_thread_helper+0x0/0x10


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
