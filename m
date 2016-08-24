Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2C8187CA0
	for <xfs@oss.sgi.com>; Wed, 24 Aug 2016 18:42:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D65968F8033
	for <xfs@oss.sgi.com>; Wed, 24 Aug 2016 16:42:44 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 8qupufAXPwnUkwAk (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 24 Aug 2016 16:42:42 -0700 (PDT)
Date: Wed, 24 Aug 2016 16:42:37 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: "Bad page state" errors when calling BULKSTAT under memory pressure?
Message-ID: <20160824234237.GA22760@birch.djwong.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Hi everyone,

[cc'ing Brian because he was the last one to touch xfs_buf.c]

I've been stress-testing xfs_scrub against a 900GB filesystem with 2M inodes
using a VM with 512M of RAM.  I've noticed that I get BUG messages about
pages with negative refcount, but only if the system is under memory pressure.
No errors are seen if the VM memory is increased to, say, 20GB.

: BUG: Bad page state in process xfs_scrub  pfn:00426
: page:ffffea0000010980 count:-1 mapcount:0 mapping:          (null) index:0x0
: flags: 0x0()
: page dumped because: nonzero _count
: Modules linked in: xfs libcrc32c sch_fq_codel af_packet
: CPU: 1 PID: 2058 Comm: xfs_scrub Not tainted 4.8.0-rc3-mcsum #18
: Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
:  0000000000000000 ffff906f9c4237b0 ffffffff98331bf3 ffffea0000010980
:  ffffffff989d923c ffff906f9c4237d8 ffffffff9819c5b4 0000000000000000
:  0000000000000000 0000000000000000 ffff906f9c4237e8 ffffffff9819c701
: Call Trace:
:  [<ffffffff98331bf3>] dump_stack+0x85/0xc2
:  [<ffffffff9819c5b4>] bad_page+0xc4/0x130
:  [<ffffffff9819c701>] check_new_page_bad+0x71/0x80
:  [<ffffffff9819fd97>] get_page_from_freelist+0x907/0xa60
:  [<ffffffff981a05a6>] __alloc_pages_nodemask+0x156/0xf70
:  [<ffffffff9812812f>] ? is_module_address+0x2f/0x50
:  [<ffffffffc03ca746>] xfs_buf_allocate_memory+0x1f6/0x2f0 [xfs]
:  [<ffffffffc03cc49d>] xfs_buf_get_map+0x1bd/0x400 [xfs]
:  [<ffffffffc03cdb2c>] xfs_buf_read_map+0x2c/0x360 [xfs]
:  [<ffffffff98307767>] ? queue_unplugged+0x57/0x190
:  [<ffffffffc03cdeb2>] xfs_buf_readahead_map+0x52/0x70 [xfs]
:  [<ffffffffc037fdfd>] xfs_btree_reada_bufs+0x9d/0xb0 [xfs]
:  [<ffffffffc03eea6a>] xfs_bulkstat_ichunk_ra+0xda/0x110 [xfs]
:  [<ffffffffc037ef14>] ? xfs_btree_check_block+0x14/0x20 [xfs]
:  [<ffffffffc03eeec8>] xfs_bulkstat+0x2b8/0x6c0 [xfs]
:  [<ffffffffc03ee960>] ? xfs_bulkstat_one_int+0x430/0x430 [xfs]
:  [<ffffffffc03e0826>] xfs_ioc_bulkstat+0x116/0x210 [xfs]
:  [<ffffffffc03e2631>] xfs_file_ioctl+0x591/0xf10 [xfs]
:  [<ffffffff98045b03>] ? kvm_clock_read+0x23/0x40
:  [<ffffffff98045b39>] ? kvm_sched_clock_read+0x9/0x20
:  [<ffffffff98022729>] ? sched_clock+0x9/0x10
:  [<ffffffff980dddcd>] ? __lock_acquire+0x25d/0x14b0
:  [<ffffffff98234993>] ? __fget+0xf3/0x200
:  [<ffffffff98234993>] ? __fget+0xf3/0x200
:  [<ffffffff98350277>] ? debug_smp_processor_id+0x17/0x20
:  [<ffffffff980d9a19>] ? get_lock_stats+0x19/0x60
:  [<ffffffff982276d3>] do_vfs_ioctl+0x93/0x700
:  [<ffffffff982349b0>] ? __fget+0x110/0x200
:  [<ffffffff982348a5>] ? __fget+0x5/0x200
:  [<ffffffff98227d81>] SyS_ioctl+0x41/0x70
:  [<ffffffff9866d6bc>] entry_SYSCALL_64_fastpath+0x1f/0xbd
: Disabling lock debugging due to kernel taint

Obviously, a page refcount of -1 is not a good sign.  I had a hunch that
the page in question was (hopefully) a page backing an xfs_buf, so I
applied the following debug patch:

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 607cc29..144b976 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -317,7 +317,7 @@ xfs_buf_free(
 
                for (i = 0; i < bp->b_page_count; i++) {
                        struct page     *page = bp->b_pages[i];
-
+if (page_ref_count(page) != 1) {xfs_err(NULL, "%s: OHNO! daddr=%llu page=%p ref=%d", __func__, bp->b_bn, page, page_ref_count(page)); dump_stack();}
                        __free_page(page);
                }
        } else if (bp->b_flags & _XBF_KMEM)

I then saw this:

: SGI XFS with ACLs, security attributes, realtime, debug enabled
: XFS (sda): Mounting V4 Filesystem
: XFS (sda): Ending clean mount
: XFS: xfs_buf_free: OHNO! daddr=113849120 page=ffffea0000010980 ref=0
: CPU: 2 PID: 2058 Comm: xfs_scrub Not tainted 4.8.0-rc3-mcsum #18
: Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
:  0000000000000000 ffff906f9c4239f8 ffffffff98331bf3 ffff906f95e86b00
:  0000000000000000 ffff906f9c423a20 ffffffffc03ca53e ffff906f9c604900
:  0000000000000000 0000000000010015 ffff906f9c423a60 ffffffffc03cc640
: Call Trace:
:  [<ffffffff98331bf3>] dump_stack+0x85/0xc2
:  [<ffffffffc03ca53e>] xfs_buf_free+0x27e/0x290 [xfs]
:  [<ffffffffc03cc640>] xfs_buf_get_map+0x360/0x400 [xfs]
:  [<ffffffffc03cdb2c>] xfs_buf_read_map+0x2c/0x360 [xfs]
:  [<ffffffffc03cdeb2>] ? xfs_buf_readahead_map+0x52/0x70 [xfs]
:  [<ffffffffc03cdeb2>] xfs_buf_readahead_map+0x52/0x70 [xfs]
:  [<ffffffffc037fdfd>] xfs_btree_reada_bufs+0x9d/0xb0 [xfs]
:  [<ffffffffc03eea6a>] xfs_bulkstat_ichunk_ra+0xda/0x110 [xfs]
:  [<ffffffffc037ef14>] ? xfs_btree_check_block+0x14/0x20 [xfs]
:  [<ffffffffc03eeec8>] xfs_bulkstat+0x2b8/0x6c0 [xfs]
:  [<ffffffffc03ee960>] ? xfs_bulkstat_one_int+0x430/0x430 [xfs]
:  [<ffffffffc03e0826>] xfs_ioc_bulkstat+0x116/0x210 [xfs]
:  [<ffffffffc03e2631>] xfs_file_ioctl+0x591/0xf10 [xfs]
:  [<ffffffff98045b03>] ? kvm_clock_read+0x23/0x40
:  [<ffffffff98045b39>] ? kvm_sched_clock_read+0x9/0x20
:  [<ffffffff98022729>] ? sched_clock+0x9/0x10
:  [<ffffffff980dddcd>] ? __lock_acquire+0x25d/0x14b0
:  [<ffffffff98234993>] ? __fget+0xf3/0x200
:  [<ffffffff98234993>] ? __fget+0xf3/0x200
:  [<ffffffff98350277>] ? debug_smp_processor_id+0x17/0x20
:  [<ffffffff980d9a19>] ? get_lock_stats+0x19/0x60
:  [<ffffffff982276d3>] do_vfs_ioctl+0x93/0x700
:  [<ffffffff982349b0>] ? __fget+0x110/0x200
:  [<ffffffff982348a5>] ? __fget+0x5/0x200
:  [<ffffffff98227d81>] SyS_ioctl+0x41/0x70
:  [<ffffffff9866d6bc>] entry_SYSCALL_64_fastpath+0x1f/0xbd

...followed several seconds later by the BUG message seen earlier.
It looks as though the bulkstat call is attempting to start readahead
of the inode chunk, but I'm not familiar enough with how RA works to
readily tell what's going on here, or why it's freeing a xfs_buf as
part of starting RA.  The sector 113849120 does indeed contain an
inode.

# xfs_info /mnt
meta-data=/dev/sda               isize=512    agcount=4, agsize=56308224 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=0        finobt=0 spinodes=0 rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=225232896, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal               bsize=4096   blocks=109977, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
# df -i /mnt ; df -k /mnt
Filesystem     Inodes IUsed IFree IUse% Mounted on
/dev/sda         430M  2.0M  428M    1% /mnt
Filesystem     1K-blocks      Used Available Use% Mounted on
/dev/sda       900491676 326109388 574382288  37% /mnt

Kernel is 4.8-rc3 + Darrick's giant patchset, though I can reproduce
it with plain 4.8-rc3 if I beat on bulkstat somewhat harder.  Not
sure what the fix is here, though disabling inode chunk readahead
for bulkstat does make the BUG go away. :$

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
