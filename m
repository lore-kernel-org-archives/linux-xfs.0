Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DA92A7F9A
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 12:32:55 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CAB808F8059
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 10:32:55 -0800 (PST)
Received: from mail-vb0-f47.google.com (mail-vb0-f47.google.com
	[209.85.212.47]) by cuda.sgi.com with ESMTP id GN67g0RVbPHDC34f
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 28 Jan 2014 10:32:51 -0800 (PST)
Received: by mail-vb0-f47.google.com with SMTP id p6so480313vbe.20
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 10:32:51 -0800 (PST)
MIME-Version: 1.0
From: Max Veprinsky <max.veprinsky@livetext.com>
Date: Tue, 28 Jan 2014 12:32:28 -0600
Message-ID: <CAGoO68jx6XgyEX3=GXy2icm0Ze65i_T4nVSv0ito8Kz6hP_jWg@mail.gmail.com>
Subject: server lock ups maybe XFS related - BUG: bad unlock balance detected!
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
To: xfs@oss.sgi.com

Hello everybody!

First time called, first time listener looking for help.
In the past couple of months a Dell R900 has been locking up what
seems to be at random intervals. This time the messages log has
captured something that maybe of use to help sort out the issue, of
course it could be not related at all.

 The server did not lockup until Jan 28 11:20

Thank you
- Max Veprinsky



Linux dw-prod-4 2.6.32-431.3.1.el6.x86_64.debug #1 SMP Fri Jan 3
22:12:36 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux

CentOS release 6.5 (Final)

xfsprogs-3.1.1-14.el6.x86_64

Jan 27 08:04:40 dw-prod-4 kernel:
Jan 27 08:04:40 dw-prod-4 kernel: =====================================
Jan 27 08:04:40 dw-prod-4 kernel: [ BUG: bad unlock balance detected! ]
Jan 27 08:04:40 dw-prod-4 kernel: -------------------------------------
Jan 27 08:04:40 dw-prod-4 kernel: xfsdatad/4/1613 is trying to release
lock (sb_internal) at:
Jan 27 08:04:40 dw-prod-4 kernel: [<ffffffffa0352e77>]
xfs_trans_free+0x57/0x80 [xfs]
Jan 27 08:04:40 dw-prod-4 kernel: but there are no more locks to release!
Jan 27 08:04:40 dw-prod-4 kernel:
Jan 27 08:04:40 dw-prod-4 kernel: other info that might help us debug this:
Jan 27 08:04:40 dw-prod-4 kernel: 3 locks held by xfsdatad/4/1613:
Jan 27 08:04:40 dw-prod-4 kernel: #0:  (xfsdatad){+.+...}, at:
[<ffffffff8109a65b>] worker_thread+0x1cb/0x3d0
Jan 27 08:04:40 dw-prod-4 kernel: #1:  (&ioend->io_work){+.+...}, at:
[<ffffffff8109a65b>] worker_thread+0x1cb/0x3d0
Jan 27 08:04:40 dw-prod-4 kernel: #2:
(&(&ip->i_lock)->mr_lock){++++..}, at: [<ffffffffa033a0fd>]
xfs_ilock_nowait+0x9d/0x150 [xfs]
Jan 27 08:04:40 dw-prod-4 kernel:
Jan 27 08:04:40 dw-prod-4 kernel: stack backtrace:
Jan 27 08:04:40 dw-prod-4 kernel: Pid: 1613, comm: xfsdatad/4 Not
tainted 2.6.32-431.3.1.el6.x86_64.debug #1
Jan 27 08:04:40 dw-prod-4 kernel: Call Trace:
Jan 27 08:04:40 dw-prod-4 kernel: [<ffffffff810b9986>] ?
print_unlock_inbalance_bug+0xe6/0xf0
Jan 27 08:04:40 dw-prod-4 kernel: [<ffffffff810bcfcf>] ?
lock_release_non_nested+0x24f/0x3a0
Jan 27 08:04:40 dw-prod-4 kernel: [<ffffffff810ba5fd>] ?
lock_release_holdtime+0x3d/0x190
Jan 27 08:04:40 dw-prod-4 kernel: [<ffffffffa0352e77>] ?
xfs_trans_free+0x57/0x80 [xfs]
Jan 27 08:04:40 dw-prod-4 kernel: [<ffffffffa0352e77>] ?
xfs_trans_free+0x57/0x80 [xfs]
Jan 27 08:04:40 dw-prod-4 kernel: [<ffffffff810bd1ec>] ? lock_release+0xcc/0x220
Jan 27 08:04:40 dw-prod-4 kernel: [<ffffffff811a8a47>] ?
__sb_end_write+0x87/0x90
Jan 27 08:04:40 dw-prod-4 kernel: [<ffffffffa0352e77>] ?
xfs_trans_free+0x57/0x80 [xfs]
Jan 27 08:04:40 dw-prod-4 kernel: [<ffffffffa0354824>] ?
_xfs_trans_commit+0x214/0x2a0 [xfs]
Jan 27 08:04:40 dw-prod-4 kernel: [<ffffffffa033a0fd>] ?
xfs_ilock_nowait+0x9d/0x150 [xfs]
Jan 27 08:04:40 dw-prod-4 kernel: [<ffffffffa035b934>] ?
xfs_setfilesize+0xb4/0x100 [xfs]
Jan 27 08:04:40 dw-prod-4 kernel: [<ffffffffa035bc80>] ?
xfs_end_io+0x0/0x100 [xfs]
Jan 27 08:04:40 dw-prod-4 kernel: [<ffffffffa035bd06>] ?
xfs_end_io+0x86/0x100 [xfs]
Jan 27 08:04:40 dw-prod-4 kernel: [<ffffffff8109a6ac>] ?
worker_thread+0x21c/0x3d0
Jan 27 08:04:40 dw-prod-4 kernel: [<ffffffff8109a65b>] ?
worker_thread+0x1cb/0x3d0
Jan 27 08:04:40 dw-prod-4 kernel: [<ffffffff810a1280>] ?
autoremove_wake_function+0x0/0x40
Jan 27 08:04:40 dw-prod-4 kernel: [<ffffffff8109a490>] ? worker_thread+0x0/0x3d0
Jan 27 08:04:40 dw-prod-4 kernel: [<ffffffff810a0ef6>] ? kthread+0x96/0xa0
Jan 27 08:04:40 dw-prod-4 kernel: [<ffffffff8100c30a>] ? child_rip+0xa/0x20
Jan 27 08:04:40 dw-prod-4 kernel: [<ffffffff8100bb10>] ? restore_args+0x0/0x30
Jan 27 08:04:40 dw-prod-4 kernel: [<ffffffff810a0e60>] ? kthread+0x0/0xa0
Jan 27 08:04:40 dw-prod-4 kernel: [<ffffffff8100c300>] ? child_rip+0x0/0x20

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
