Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F0A777F3F
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 03:09:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B31B230405F
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 01:09:36 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id XeofMcqaUb6Q9yNx (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 25 Sep 2013 01:09:35 -0700 (PDT)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r8P89X6W030852
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 08:09:34 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r8P89W4w017935
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 08:09:33 GMT
Received: from abhmt117.oracle.com (abhmt117.oracle.com [141.146.116.69])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r8P89WSi024014 for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 08:09:32 GMT
Message-ID: <52429A6C.3050908@oracle.com>
Date: Wed, 25 Sep 2013 16:10:20 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2 RESEND] xfs: fix dead loop at xfs_vm_writepage() on 32bit
	machine
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

From: Jie Liu <jeff.liu@oracle.com>

Write a file with an offset greater than 16TB on 32-bit system and
then trigger page write-back via sync(1) as below will cause the
task hang in a little while:
# block_size=4096
# offset=$(((2**32 - 1) * $block_size))
# xfs_io -f -c "pwrite $offset $block_size" /storage/test_file
# sync

INFO: task sync:2590 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sync            D c1064a28     0  2590   2097 0x00000000
.....
Call Trace:
[<c1064a28>] ? ttwu_do_wakeup+0x18/0x130
[<c1066d0e>] ? try_to_wake_up+0x1ce/0x220
[<c1066dbf>] ? wake_up_process+0x1f/0x40
[<c104fc2e>] ? wake_up_worker+0x1e/0x30
[<c15b6083>] schedule+0x23/0x60
[<c15b3c2d>] schedule_timeout+0x18d/0x1f0
[<c12a143e>] ? do_raw_spin_unlock+0x4e/0x90
[<c10515f1>] ? __queue_delayed_work+0x91/0x150
[<c12a12ef>] ? do_raw_spin_lock+0x3f/0x100
[<c12a143e>] ? do_raw_spin_unlock+0x4e/0x90
[<c15b5b5d>] wait_for_completion+0x7d/0xc0
[<c1066d60>] ? try_to_wake_up+0x220/0x220
[<c116a4d2>] sync_inodes_sb+0x92/0x180
[<c116fb05>] sync_inodes_one_sb+0x15/0x20
[<c114a8f8>] iterate_supers+0xb8/0xc0
[<c116faf0>] ? fdatawrite_one_bdev+0x20/0x20
[<c116fc21>] sys_sync+0x31/0x80
[<c15be18d>] sysenter_do_call+0x12/0x28

The reason is that the end_index is unsigned long with maximum value
'2^32-1=4294967295' on 32-bit platform, and the given offset cause it
wrapped to 0, so that the following codes will repeat again and again
until the task schedule time out:

end_index = offset >> PAGE_CACHE_SHIFT;
last_index = (offset - 1) >> PAGE_CACHE_SHIFT;
if (page->index >= end_index) {
	unsigned offset_into_page = offset & (PAGE_CACHE_SIZE - 1);
        /*
         * Just skip the page if it is fully outside i_size, e.g. due
         * to a truncate operation that is in progress.
         */
        if (page->index >= end_index + 1 || offset_into_page == 0) {
	^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
		unlock_page(page);
		return 0;
	}

To check a page is fully outsids i_size or not, we can change the
logic to:
	if (page->index > end_index ||
	    (page->index == end_index && offset_into_page == 0))

Secondly, there still has another similar issue when calculating the
end offset for mapping the filesystem blocks to the file blocks for
delalloc.  With the same tests to above, run unmount(8) will cause
kernel panic if CONFIG_XFS_DEBUG is enabled:

XFS: Assertion failed: XFS_FORCED_SHUTDOWN(ip->i_mount) || \
	ip->i_delayed_blks == 0, file: fs/xfs/xfs_super.c, line: 964

kernel BUG at fs/xfs/xfs_message.c:108!
invalid opcode: 0000 [#1] SMP 
task: edddc100 ti: ec6ee000 task.ti: ec6ee000
EIP: 0060:[<f83d87cb>] EFLAGS: 00010296 CPU: 1
EIP is at assfail+0x2b/0x30 [xfs]
..............
Call Trace:
[<f83d9cd4>] xfs_fs_destroy_inode+0x74/0x120 [xfs]
[<c115ddf1>] destroy_inode+0x31/0x50
[<c115deff>] evict+0xef/0x170
[<c115dfb2>] dispose_list+0x32/0x40
[<c115ea3a>] evict_inodes+0xca/0xe0
[<c1149706>] generic_shutdown_super+0x46/0xd0
[<c11497b9>] kill_block_super+0x29/0x70
[<c1149a14>] deactivate_locked_super+0x44/0x70
[<c114a427>] deactivate_super+0x47/0x60
[<c1161c3d>] mntput_no_expire+0xcd/0x120
[<c1162ae8>] SyS_umount+0xa8/0x370
[<c1162dce>] SyS_oldumount+0x1e/0x20
[<c15be18d>] sysenter_do_call+0x12/0x28

That because the end_offset is evaluated to 0 same to above, hence the
mapping and covertion for dealloc file blocks to file system blocks did
not happened.

This patch just fixed both issues.

Reported-by: Michael L. Semon <mlsemon35@gmail.com>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
v2: don't reset the s_max_bytes to MAX_LFS_FILESIZE, instead, revise the page offset
    check up strategy to avoid the potential overflow.
v1: http://oss.sgi.com/archives/xfs/2013-07/msg00154.html

 fs/xfs/xfs_aops.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 41a6950..6059d00 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -969,7 +969,9 @@ xfs_vm_writepage(
 	offset = i_size_read(inode);
 	end_index = offset >> PAGE_CACHE_SHIFT;
 	last_index = (offset - 1) >> PAGE_CACHE_SHIFT;
-	if (page->index >= end_index) {
+	if (page->index < end_index)
+		end_offset = (xfs_off_t)(page->index + 1) << PAGE_CACHE_SHIFT;
+	else {
 		unsigned offset_into_page = offset & (PAGE_CACHE_SIZE - 1);
 
 		/*
@@ -978,7 +980,8 @@ xfs_vm_writepage(
 		 * page so that reclaim stops reclaiming it. Otherwise
 		 * xfs_vm_releasepage() is called on it and gets confused.
 		 */
-		if (page->index >= end_index + 1 || offset_into_page == 0)
+		if (page->index > end_index ||
+		    (page->index == end_index && offset_into_page == 0))
 			goto redirty;
 
 		/*
@@ -990,11 +993,9 @@ xfs_vm_writepage(
 		 * not written out to the file."
 		 */
 		zero_user_segment(page, offset_into_page, PAGE_CACHE_SIZE);
+		end_offset = offset;
 	}
 
-	end_offset = min_t(unsigned long long,
-			(xfs_off_t)(page->index + 1) << PAGE_CACHE_SHIFT,
-			offset);
 	len = 1 << inode->i_blkbits;
 
 	bh = head = page_buffers(page);
-- 1.7.9.5 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
