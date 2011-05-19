Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4JFxKGA041156 for <xfs@oss.sgi.com>; Thu, 19 May 2011 10:59:20 -0500
Received: from mail-qy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B813FCE734B
	for <xfs@oss.sgi.com>; Thu, 19 May 2011 08:59:19 -0700 (PDT)
Received: from mail-qy0-f181.google.com (mail-qy0-f181.google.com
	[209.85.216.181]) by cuda.sgi.com with ESMTP id
	K0vtQfsUKcERBg48 for <xfs@oss.sgi.com>;
	Thu, 19 May 2011 08:59:19 -0700 (PDT)
Received: by qyg14 with SMTP id 14so1849128qyg.5
	for <xfs@oss.sgi.com>; Thu, 19 May 2011 08:59:18 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 19 May 2011 11:59:18 -0400
Message-ID: <BANLkTinb3aQc9GSy4dqFVeVpGk8W4M92fA@mail.gmail.com>
Subject: btree re-write and XFS_WANT_CORRUPTED_GOTO
From: Peter Watkins <treestem@gmail.com>
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

Hello again,

I've occasionally seen the XFS_WANT_CORRUPTED_GOTO error from
xfs_free_extent, usually when cleaning up an unlinked file or
truncating a file.

Is the btree rewrite known to fix any WANT_CORRUPTED problems? More
generally, why was the btree code reworked? I'm in the process of
going from 2.6.27 to 2.6.32 (still old I know), which seems to span
the btree re-write.

Are any particular patches recommended for this problem? I came across
24446fc66fdebbdd8baca0f44fd2a47ad77ba580. It's discussed at
http://oss.sgi.com/archives/xfs/2011-01/msg00266.html  Do any others
come to mind?

Still trying to create a reproducer case, but no luck so far.

Thanks for any comments!

-Peter


Here's an example stack:

XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1545 of file
fs/xfs/xfs_alloc.c.  Caller 0xf8d5bef3
[<f8d85770>] xfs_error_report+0x60/0x70 [xfs]
[<f8d5bef3>] ? xfs_free_extent+0xc3/0xe0 [xfs]
[<f8d5ac21>] xfs_free_ag_extent+0x2e1/0x670 [xfs]
[<f8d5bef3>] ? xfs_free_extent+0xc3/0xe0 [xfs]
[<f8d5bef3>] xfs_free_extent+0xc3/0xe0 [xfs]
[<f8d6dd73>] xfs_bmap_finish+0xf3/0x170 [xfs]
[<f8d8f66c>] xfs_itruncate_finish+0x27c/0x3f0 [xfs]
[<f8dab30c>] xfs_setattr+0xaac/0xc00 [xfs]
[<f8db8942>] xfs_vn_setattr+0x22/0x30 [xfs]
[<c01d5d13>] fnotify_change+0x383/0x3a0
[<c01bd6ac>] do_truncate+0x6c/0x90
[<c03ad96d>] ? _spin_lock+0xd/0x10
[<c01bd88e>] do_sys_truncate+0x1be/0x220
[<c01bdae6>] sys_truncate64+0x16/0x20
[<c0109d73>] sysenter_do_call+0x12/0x2f

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
