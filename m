Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6RHpW1x117637 for <xfs@oss.sgi.com>; Mon, 27 Jul 2009 12:51:33 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0A67610C6128
	for <xfs@oss.sgi.com>; Mon, 27 Jul 2009 11:00:58 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id JKQ9FGYljqRQQHxE for <xfs@oss.sgi.com>;
	Mon, 27 Jul 2009 11:00:58 -0700 (PDT)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n6RHqHLg028048
	for <xfs@oss.sgi.com>; Mon, 27 Jul 2009 13:52:17 -0400
Message-ID: <4A6DE939.6050606@redhat.com>
Date: Mon, 27 Jul 2009 13:51:53 -0400
From: Prarit Bhargava <prarit@redhat.com>
MIME-Version: 1.0
Subject: Circular locking on rawhide 2.6.31-0.81.rc3.git4
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
To: xfs@oss.sgi.com, Eric Sandeen <sandeen@redhat.com>

Hello everyone,

This was seen while doing a "rpmbuild -bp kernel.spec" on a recent 
rawhide build.

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.31-0.81.rc3.git4.fc12.x86_64 #1
-------------------------------------------------------
rpm/4790 is trying to acquire lock:
 (&(&ip->i_iolock)->mr_lock){++++++}, at: [<ffffffffa0037e98>] 
xfs_ilock+0x3f/0xa7 [xfs]

but task is already holding lock:
 (&mm->mmap_sem){++++++}, at: [<ffffffff81118782>] sys_munmap+0x4b/0x86

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&mm->mmap_sem){++++++}:
       [<ffffffff810954b4>] __lock_acquire+0xa79/0xc0e
       [<ffffffff81095737>] lock_acquire+0xee/0x12e
       [<ffffffff8110fe5d>] might_fault+0x9e/0xd9
       [<ffffffff810f5dc7>] file_read_actor+0xdf/0x137
       [<ffffffff810f8a4e>] generic_file_aio_read+0x321/0x52f
       [<ffffffffa0060350>] xfs_read+0x190/0x214 [xfs]
       [<ffffffffa005bbda>] xfs_file_aio_read+0x77/0x8d [xfs]
       [<ffffffff8113caa8>] do_sync_read+0xfa/0x14b
       [<ffffffff8113d266>] vfs_read+0xba/0x12b
       [<ffffffff8113d3c9>] sys_read+0x59/0x91
       [<ffffffff81012f42>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (&(&ip->i_iolock)->mr_lock){++++++}:
       [<ffffffff81095391>] __lock_acquire+0x956/0xc0e
       [<ffffffff81095737>] lock_acquire+0xee/0x12e
       [<ffffffff81083f9e>] down_write_nested+0x61/0xac
       [<ffffffffa0037e98>] xfs_ilock+0x3f/0xa7 [xfs]
       [<ffffffffa0053a64>] xfs_free_eofblocks+0x126/0x238 [xfs]
       [<ffffffffa0054594>] xfs_release+0x150/0x173 [xfs]
       [<ffffffffa005ba24>] xfs_file_release+0x28/0x40 [xfs]
       [<ffffffff8113e515>] __fput+0x137/0x1f8
       [<ffffffff8113e603>] fput+0x2d/0x43
       [<ffffffff81117019>] remove_vma+0x67/0xb5
       [<ffffffff81118701>] do_munmap+0x305/0x33b
       [<ffffffff81118790>] sys_munmap+0x59/0x86
       [<ffffffff81012f42>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

1 lock held by rpm/4790:
 #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff81118782>] sys_munmap+0x4b/0x86

stack backtrace:
Pid: 4790, comm: rpm Not tainted 2.6.31-0.81.rc3.git4.fc12.x86_64 #1
Call Trace:
 [<ffffffff81094674>] print_circular_bug_tail+0x80/0x9f
 [<ffffffff8109459f>] ? check_noncircular+0x93/0xe8
 [<ffffffff81095391>] __lock_acquire+0x956/0xc0e
 [<ffffffff81095737>] lock_acquire+0xee/0x12e
 [<ffffffffa0037e98>] ? xfs_ilock+0x3f/0xa7 [xfs]
 [<ffffffffa0037e98>] ? xfs_ilock+0x3f/0xa7 [xfs]
 [<ffffffff81083f9e>] down_write_nested+0x61/0xac
 [<ffffffffa0037e98>] ? xfs_ilock+0x3f/0xa7 [xfs]
 [<ffffffffa0037e98>] xfs_ilock+0x3f/0xa7 [xfs]
 [<ffffffffa0053a64>] xfs_free_eofblocks+0x126/0x238 [xfs]
 [<ffffffffa0054594>] xfs_release+0x150/0x173 [xfs]
 [<ffffffffa005ba24>] xfs_file_release+0x28/0x40 [xfs]
 [<ffffffff8113e515>] __fput+0x137/0x1f8
 [<ffffffff8113e603>] fput+0x2d/0x43
 [<ffffffff81117019>] remove_vma+0x67/0xb5
 [<ffffffff81118701>] do_munmap+0x305/0x33b
 [<ffffffff81118782>] ? sys_munmap+0x4b/0x86
 [<ffffffff81118790>] sys_munmap+0x59/0x86
 [<ffffffff81012f42>] system_call_fastpath+0x16/0x1b

P.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
