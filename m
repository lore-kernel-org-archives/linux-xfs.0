Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4K8SlQA192889 for <xfs@oss.sgi.com>; Thu, 20 May 2010 03:28:48 -0500
Received: from peace.netnation.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A4CE335E197
	for <xfs@oss.sgi.com>; Thu, 20 May 2010 01:31:05 -0700 (PDT)
Received: from peace.netnation.com (newpeace.netnation.com [204.174.223.7]) by
	cuda.sgi.com with ESMTP id tg06xPD7xzQUd86M for
	<xfs@oss.sgi.com>; Thu, 20 May 2010 01:31:05 -0700 (PDT)
Received: from sim by peace.netnation.com with local (Exim 4.63)
	(envelope-from <sim@netnation.com>) id 1OF19k-0001JC-TT
	for xfs@oss.sgi.com; Thu, 20 May 2010 01:31:04 -0700
Date: Thu, 20 May 2010 01:31:04 -0700
From: Simon Kirby <sim@hostway.ca>
Subject: [2.6.33.3] scheduling while atomic (inode reclaim races still?)
Message-ID: <20100520083104.GA4723@hostway.ca>
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

This started happening on host about 10 days after upgrading to 2.6.33.3
(in hopes that it fixed all of the reclaim issues present in 2.6.33.2). 
I don't see any fixes in 2.6.33.4 relevant to this particular issue.

After this first error, the kernel logs just filled with repeat
occurrences with different backtraces.

BUG: scheduling while atomic: nfsd/29671/0x00000250
Modules linked in: aoe xt_MARK ipmi_devintf ipmi_si ipmi_msghandler e1000e bnx2
Pid: 29671, comm: nfsd Not tainted 2.6.33.3-hw #1
Call Trace:
 [<ffffffff81298f5e>] ? xfs_iflush+0x2ee/0x350
 [<ffffffff81045691>] __schedule_bug+0x61/0x70
 [<ffffffff81656f68>] schedule+0x588/0xa00
 [<ffffffff8106aee2>] ? bit_waitqueue+0x12/0xc0
 [<ffffffff8165773f>] schedule_timeout+0x18f/0x270
 [<ffffffff8105cd00>] ? process_timeout+0x0/0x10
 [<ffffffff8165697f>] io_schedule_timeout+0x8f/0xf0
 [<ffffffff810bed88>] balance_dirty_pages_ratelimited_nr+0x178/0x3a0
 [<ffffffff810b65d3>] generic_file_buffered_write+0x193/0x230
 [<ffffffff812befb6>] xfs_write+0x7c6/0x8f0
 [<ffffffff81294ec0>] ? xfs_iget+0x4f0/0x660
 [<ffffffff812bab50>] ? xfs_file_aio_write+0x0/0x60
 [<ffffffff812baba6>] xfs_file_aio_write+0x56/0x60
 [<ffffffff810eea6b>] do_sync_readv_writev+0xcb/0x110
 [<ffffffff81204616>] ? exportfs_decode_fh+0xe6/0x270
 [<ffffffff812081d0>] ? nfsd_acceptable+0x0/0x120
 [<ffffffff810ee88e>] ? rw_copy_check_uvector+0x7e/0x130
 [<ffffffff810ef15f>] do_readv_writev+0xcf/0x1f0
 [<ffffffff81208362>] ? nfsd_setuser_and_check_port+0x72/0x80
 [<ffffffff81208cac>] ? nfsd_permission+0xec/0x160
 [<ffffffff810ef2c0>] vfs_writev+0x40/0x60
 [<ffffffff81209ece>] nfsd_vfs_write+0xde/0x420
 [<ffffffff810ed1bd>] ? dentry_open+0x4d/0xb0
 [<ffffffff8120a8ce>] ? nfsd_open+0x16e/0x200
 [<ffffffff8120ad0a>] nfsd_write+0xea/0x100
 [<ffffffff812104cb>] ? nfsd_cache_lookup+0x2bb/0x3e0
 [<ffffffff81212b7f>] nfsd3_proc_write+0xaf/0x140
 [<ffffffff81204b4b>] nfsd_dispatch+0xbb/0x260
 [<ffffffff81618eaf>] svc_process+0x4af/0x820
 [<ffffffff81205190>] ? nfsd+0x0/0x160
 [<ffffffff8120526d>] nfsd+0xdd/0x160
 [<ffffffff8106aac6>] kthread+0x96/0xb0
 [<ffffffff8100ace4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8106aa30>] ? kthread+0x0/0xb0
 [<ffffffff8100ace0>] ? kernel_thread_helper+0x0/0x10
BUG: scheduling while atomic: nfsd/29671/0x00000250
Modules linked in: aoe xt_MARK ipmi_devintf ipmi_si ipmi_msghandler e1000e bnx2
Pid: 29671, comm: nfsd Not tainted 2.6.33.3-hw #1
Call Trace:
 [<ffffffff81045691>] __schedule_bug+0x61/0x70
 [<ffffffff81656f68>] schedule+0x588/0xa00
 [<ffffffff8105cb34>] ? try_to_del_timer_sync+0xa4/0xd0
 [<ffffffff8165773f>] schedule_timeout+0x18f/0x270
 [<ffffffff8105cd00>] ? process_timeout+0x0/0x10
 [<ffffffff8165697f>] io_schedule_timeout+0x8f/0xf0
 [<ffffffff810bed88>] balance_dirty_pages_ratelimited_nr+0x178/0x3a0
 [<ffffffff810b65d3>] generic_file_buffered_write+0x193/0x230
 [<ffffffff812befb6>] xfs_write+0x7c6/0x8f0
 [<ffffffff81294ec0>] ? xfs_iget+0x4f0/0x660
 [<ffffffff812bab50>] ? xfs_file_aio_write+0x0/0x60
 [<ffffffff812baba6>] xfs_file_aio_write+0x56/0x60
 [<ffffffff810eea6b>] do_sync_readv_writev+0xcb/0x110
 [<ffffffff81204616>] ? exportfs_decode_fh+0xe6/0x270
 [<ffffffff812081d0>] ? nfsd_acceptable+0x0/0x120
 [<ffffffff810ee88e>] ? rw_copy_check_uvector+0x7e/0x130
 [<ffffffff810ef15f>] do_readv_writev+0xcf/0x1f0
 [<ffffffff81208362>] ? nfsd_setuser_and_check_port+0x72/0x80
 [<ffffffff81208cac>] ? nfsd_permission+0xec/0x160
 [<ffffffff810ef2c0>] vfs_writev+0x40/0x60
 [<ffffffff81209ece>] nfsd_vfs_write+0xde/0x420
 [<ffffffff810ed1bd>] ? dentry_open+0x4d/0xb0
 [<ffffffff8120a8ce>] ? nfsd_open+0x16e/0x200
 [<ffffffff8120ad0a>] nfsd_write+0xea/0x100
 [<ffffffff812104cb>] ? nfsd_cache_lookup+0x2bb/0x3e0
 [<ffffffff81212b7f>] nfsd3_proc_write+0xaf/0x140
 [<ffffffff81204b4b>] nfsd_dispatch+0xbb/0x260
 [<ffffffff81618eaf>] svc_process+0x4af/0x820
 [<ffffffff81205190>] ? nfsd+0x0/0x160
 [<ffffffff8120526d>] nfsd+0xdd/0x160
 [<ffffffff8106aac6>] kthread+0x96/0xb0
 [<ffffffff8100ace4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8106aa30>] ? kthread+0x0/0xb0
 [<ffffffff8100ace0>] ? kernel_thread_helper+0x0/0x10
BUG: scheduling while atomic: nfsd/29671/0x00000250
Modules linked in: aoe xt_MARK ipmi_devintf ipmi_si ipmi_msghandler e1000e bnx2
Pid: 29671, comm: nfsd Not tainted 2.6.33.3-hw #1
Call Trace:
 [<ffffffff81045691>] __schedule_bug+0x61/0x70
 [<ffffffff81656f68>] schedule+0x588/0xa00
 [<ffffffff810bd448>] ? __alloc_pages_nodemask+0x108/0x6e0
 [<ffffffff8165773f>] schedule_timeout+0x18f/0x270
 [<ffffffff8105cd00>] ? process_timeout+0x0/0x10
 [<ffffffff81626f99>] svc_recv+0x539/0x8b0
 [<ffffffff81047f30>] ? default_wake_function+0x0/0x10
 [<ffffffff81205190>] ? nfsd+0x0/0x160
 [<ffffffff8120522d>] nfsd+0x9d/0x160
 [<ffffffff8106aac6>] kthread+0x96/0xb0
 [<ffffffff8100ace4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8106aa30>] ? kthread+0x0/0xb0
 [<ffffffff8100ace0>] ? kernel_thread_helper+0x0/0x10

(followed by several million more "scheduling while atomic" errors with
different backtraces)

Simon-

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
