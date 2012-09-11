Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8B7kl4u046874 for <xfs@oss.sgi.com>; Tue, 11 Sep 2012 02:46:47 -0500
Received: from mail-ee0-f53.google.com (mail-ee0-f53.google.com
	[74.125.83.53]) by cuda.sgi.com with ESMTP id csM7OeBX2IYR4CwS
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 11 Sep 2012 00:47:50 -0700 (PDT)
Received: by eekb47 with SMTP id b47so144452eek.26
	for <xfs@oss.sgi.com>; Tue, 11 Sep 2012 00:47:49 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 11 Sep 2012 09:47:49 +0200
Message-ID: <CADDYkjRbji4swSOm7gz907-iXFoZwEycLgUGgDV3JZtQaBbieg@mail.gmail.com>
Subject: Internal error xfs_trans_cancel at line 1467 of file
	fs/xfs/xfs_trans.c
From: Jacek Luczak <difrost.kernel@gmail.com>
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

Hi All,

got this during heavy IO (parallel checkout of few large projects from SVN):

XFS (dm-8): Corruption detected. Unmount and run xfs_repair
XFS (dm-8): Internal error xfs_trans_cancel at line 1467 of file
fs/xfs/xfs_trans.c.  Caller 0xffffffffa03c9974

Pid: 11930, comm: svn Not tainted 3.4.10-1 #1
Call Trace:
 [<ffffffffa03f758b>] ? xfs_trans_cancel+0x56/0xd7 [xfs]
 [<ffffffffa03c9974>] ? xfs_create+0x467/0x4cf [xfs]
 [<ffffffffa03c1777>] ? xfs_vn_mknod+0xcb/0x160 [xfs]
 [<ffffffff81101a30>] ? vfs_create+0x6e/0xc7
 [<ffffffff81102487>] ? do_last+0x3a5/0x745
 [<ffffffff811028f5>] ? path_openat+0xce/0x35f
 [<ffffffff81102c53>] ? do_filp_open+0x2c/0x72
 [<ffffffffa03ca5d7>] ? xfs_release+0x1ac/0x1cc [xfs]
 [<ffffffff8110c169>] ? alloc_fd+0x69/0xf2
 [<ffffffff810f588e>] ? do_sys_open+0x107/0x18e
 [<ffffffff813cb3f9>] ? system_call_fastpath+0x16/0x1b
XFS (dm-8): xfs_do_force_shutdown(0x8) called from line 1468 of file
fs/xfs/xfs_trans.c.  Return address = 0xffffffffa03f75a4
XFS (dm-8): Corruption of in-memory data detected.  Shutting down filesystem
XFS (dm-8): Please umount the filesystem and rectify the problem(s)
XFS (dm-8): xfs_log_force: error 5 returned.
XFS (dm-8): xfs_log_force: error 5 returned.
XFS (dm-8): xfs_log_force: error 5 returned.
XFS (dm-8): xfs_log_force: error 5 returned.
XFS (dm-8): xfs_log_force: error 5 returned.
XFS (dm-8): xfs_log_force: error 5 returned.
XFS (dm-8): xfs_log_force: error 5 returned.
XFS (dm-8): xfs_log_force: error 5 returned.
XFS (dm-8): xfs_log_force: error 5 returned.
XFS (dm-8): xfs_log_force: error 5 returned.
XFS (dm-8): xfs_log_force: error 5 returned.
XFS (dm-8): xfs_log_force: error 5 returned.
XFS (dm-8): xfs_log_force: error 5 returned.
XFS (dm-8): xfs_log_force: error 5 returned.
XFS (dm-8): xfs_log_force: error 5 returned.
XFS (dm-8): xfs_log_force: error 5 returned.
XFS (dm-8): xfs_log_force: error 5 returned.
XFS (dm-8): xfs_log_force: error 5 returned.
XFS (dm-8): xfs_log_force: error 5 returned.
XFS (dm-8): xfs_log_force: error 5 returned.
XFS (dm-8): xfs_log_force: error 5 returned.
XFS (dm-8): xfs_log_force: error 5 returned.
XFS (dm-8): xfs_log_force: error 5 returned.
XFS (dm-8): xfs_log_force: error 5 returned.
XFS (dm-8): xfs_log_force: error 5 returned.
XFS (dm-8): xfs_log_force: error 5 returned.
XFS (dm-8): xfs_log_force: error 5 returned.
XFS (dm-8): xfs_log_force: error 5 returned.
XFS (dm-8): xfs_log_force: error 5 returned.
XFS (dm-8): xfs_log_force: error 5 returned.
XFS (dm-8): xfs_log_force: error 5 returned.
XFS (dm-8): xfs_log_force: error 5 returned.
XFS (dm-8): xfs_do_force_shutdown(0x1) called from line 1031 of file
fs/xfs/xfs_buf.c.  Return address = 0xffffffffa03b9f45
XFS (dm-8): xfs_log_force: error 5 returned.
XFS (dm-8): xfs_log_force: error 5 returned.
XFS (dm-8): Mounting Filesystem
XFS (dm-8): Starting recovery (logdev: internal)
XFS (dm-8): Ending recovery (logdev: internal)


Is it a known issue? I have not - yet - enabled this host in CI thus
can't tell if this can be reproduced.

I've done repair but did not saved output.

Cheers,
-Jacek

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
