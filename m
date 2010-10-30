Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9UEbGnG066826 for <xfs@oss.sgi.com>; Sat, 30 Oct 2010 09:37:18 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 43F1913777F0
	for <xfs@oss.sgi.com>; Sat, 30 Oct 2010 07:54:31 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id hrNupTPXUsja0gcZ for
	<xfs@oss.sgi.com>; Sat, 30 Oct 2010 07:54:31 -0700 (PDT)
Date: Sat, 30 Oct 2010 10:38:33 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [bug, 2.6.37-current] Assertion failed:
	atomic_read(&pag->pag_ref) == 0
Message-ID: <20101030143833.GA5490@infradead.org>
References: <20101026071356.GY32255@dastard>
	<20101028115800.GA4472@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101028115800.GA4472@infradead.org>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Oct 28, 2010 at 07:58:00AM -0400, Christoph Hellwig wrote:
> On Tue, Oct 26, 2010 at 06:13:56PM +1100, Dave Chinner wrote:
> > Folks,
> > 
> > Since themainline merge, I've been getting unmount failures during
> > shutdown that look like:
> 
> I've done quite a few mainline runs, but haven't seen anything like
> that.  On the other hand I see completely silent hangs in 076 once in
> a while.

I can't reproduce that anymore since upgrading to a newer Linus' tree.
But I've hit the following twice now:

070 7s ...
[ 1208.818651] Assertion failed: dp->i_d.di_forkoff, file: fs/xfs/xfs_attr_leaf.c, line: 373
[ 1208.823852] ------------[ cut here ]------------
[ 1208.825880] kernel BUG at fs/xfs/support/debug.c:108!
[ 1208.827647] invalid opcode: 0000 [#1] SMP 
[ 1208.827724] last sysfs file: /sys/devices/virtio-pci/virtio1/block/vdb/removable
[ 1208.827724] Modules linked in:
[ 1208.827724] 
[ 1208.827724] Pid: 4422, comm: fsstress Not tainted 2.6.36-xfs+ #68 /Bochs
[ 1208.827724] EIP: 0060:[<c04eba6e>] EFLAGS: 00010282 CPU: 0
[ 1208.827724] EIP is at assfail+0x1e/0x30
[ 1208.827724] EAX: 00000060 EBX: f4c8d530 ECX: ffffffa0 EDX: 016e0000
[ 1208.827724] ESI: 00000051 EDI: 00000000 EBP: ece99d20 ESP: ece99d10
[ 1208.827724]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[ 1208.827724] Process fsstress (pid: 4422, ti=ece98000 task=f6310040 task.ti=ece98000)
[ 1208.827724] Stack:
[ 1208.827724]  c0b9dbb8 c0b5fa7e c0b5f912 00000175 ece99d58 c04848a9 00000001 f65cea88
[ 1208.827724] <0> 02e99d44 f5533258 ece99d78 f4c8d530 00000002 00000003 00000051 f4c8d530
[ 1208.827724] <0> 00000000 0000000a ece99df8 c04807d5 00000000 00000004 00000003 ece99d78
[ 1208.827724] Call Trace:
[ 1208.827724]  [<c04848a9>] ? xfs_attr_shortform_remove+0x159/0x270
[ 1208.827724]  [<c04807d5>] ? xfs_attr_remove_int+0x225/0x280
[ 1208.827724]  [<c04b512a>] ? xfs_iunlock+0xaa/0x160
[ 1208.827724]  [<c04808cc>] ? xfs_attr_remove+0x9c/0xc0
[ 1208.827724]  [<c04eb769>] ? xfs_xattr_set+0x89/0x90
[ 1208.827724]  [<c02283ec>] ? generic_removexattr+0x8c/0xa0
[ 1208.827724]  [<c022884e>] ? vfs_removexattr+0x7e/0xf0
[ 1208.827724]  [<c01f0e46>] ? might_fault+0x46/0xa0
[ 1208.827724]  [<c02288fb>] ? removexattr+0x3b/0x60
[ 1208.827724]  [<c0206d8e>] ? kfree_debugcheck+0xe/0x30
[ 1208.827724]  [<c02071bc>] ? cache_free_debugcheck+0x17c/0x250
[ 1208.827724]  [<c067f994>] ? debug_check_no_obj_freed+0x124/0x180
[ 1208.827724]  [<c0195d16>] ? debug_check_no_locks_freed+0xb6/0x140
[ 1208.827724]  [<c0207345>] ? kmem_cache_free+0xb5/0x120
[ 1208.827724]  [<c0195c5b>] ? trace_hardirqs_on+0xb/0x10
[ 1208.827724]  [<c0219d4a>] ? user_path_at+0x4a/0x80
[ 1208.827724]  [<c02120d2>] ? sys_stat64+0x22/0x30
[ 1208.827724]  [<c02289fb>] ? sys_lremovexattr+0x6b/0x80
[ 1208.827724]  [<c0911f2d>] ? syscall_call+0x7/0xb

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
