Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 83D3B7F4E
	for <xfs@oss.sgi.com>; Mon, 19 May 2014 04:27:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D5E16AC008
	for <xfs@oss.sgi.com>; Mon, 19 May 2014 02:27:04 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id of7pGc860AeDIxKb (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 19 May 2014 02:27:00 -0700 (PDT)
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id s4J9Qwj5030153
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 19 May 2014 09:26:58 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id
	s4J9QuJu008842
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 19 May 2014 09:26:57 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s4J9Quc1020542 for <xfs@oss.sgi.com>; Mon, 19 May 2014 09:26:56 GMT
Message-ID: <5379CE58.8010603@oracle.com>
Date: Mon, 19 May 2014 17:26:48 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v4] xfs: fix infinite loop at xfs_vm_writepage on 32bit system
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

Write to a file with an offset greater than 16TB on 32-bit system and
then trigger page write-back via sync(1) will cause task hang.

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

This issue can be triggered via xfstests/generic/308.

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

In order to check if a page is fully outsids i_size or not, we can fix
the code logic as below:
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

That because the end_offset is evaluated to 0 which is the same reason
to above, hence the mapping and covertion for dealloc file blocks to
file system blocks did not happened.

This patch just fixed both issues.

Reported-by: Michael L. Semon <mlsemon35@gmail.com>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
v4: s/dead loop/infinite loop/, as the latter is more meaningful
v3: Add code comments to reflect this change.
    http://oss.sgi.com/archives/xfs/2013-09/msg00688.html
v2: don't reset the s_max_bytes to MAX_LFS_FILESIZE, instead, revise the
    page offset check up strategy to avoid the potential overflow.
    http://oss.sgi.com/archives/xfs/2013-07/msg00339.html
v1: http://oss.sgi.com/archives/xfs/2013-07/msg00154.html

 fs/xfs/xfs_aops.c | 49 +++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 43 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 0479c32..8ec41dd 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -982,7 +982,32 @@ xfs_vm_writepage(
 	offset = i_size_read(inode);
 	end_index = offset >> PAGE_CACHE_SHIFT;
 	last_index = (offset - 1) >> PAGE_CACHE_SHIFT;
-	if (page->index >= end_index) {
+
+	/*
+	 * The page index is less than the end_index, adjust the end_offset
+	 * to the highest offset that this page should represent.
+	 * -----------------------------------------------------
+	 * |			file mapping	       | <EOF> |
+	 * -----------------------------------------------------
+	 * | Page ... | Page N-2 | Page N-1 |  Page N  |       |
+	 * ^--------------------------------^----------|--------
+	 * |     desired writeback range    |      see else    |
+	 * ---------------------------------^------------------|
+	 */
+	if (page->index < end_index)
+		end_offset = (xfs_off_t)(page->index + 1) << PAGE_CACHE_SHIFT;
+	else {
+		/*
+		 * Check whether the page to write out is beyond or straddles
+		 * i_size or not.
+		 * -------------------------------------------------------
+		 * |		file mapping		        | <EOF>  |
+		 * -------------------------------------------------------
+		 * | Page ... | Page N-2 | Page N-1 |  Page N   | Beyond |
+		 * ^--------------------------------^-----------|---------
+		 * |				    |      Straddles     |
+		 * ---------------------------------^-----------|--------|
+		 */
 		unsigned offset_into_page = offset & (PAGE_CACHE_SIZE - 1);
 
 		/*
@@ -990,24 +1015,36 @@ xfs_vm_writepage(
 		 * truncate operation that is in progress. We must redirty the
 		 * page so that reclaim stops reclaiming it. Otherwise
 		 * xfs_vm_releasepage() is called on it and gets confused.
+		 *
+		 * Note that the end_index is unsigned long, it would overflow
+		 * if the given offset is greater than 16TB on 32-bit system
+		 * and if we do check the page is fully outside i_size or not
+		 * via "if (page->index >= end_index + 1)" as "end_index + 1"
+		 * will be evaluated to 0.  Hence this page will be redirtied
+		 * and be written out repeatedly which would result in an
+		 * infinite loop, the user program that perform this operation
+		 * will hang.  Instead, we can verify this situation by checking
+		 * if the page to write is totally beyond the i_size or if it's
+		 * offset is just equal to the EOF.
 		 */
-		if (page->index >= end_index + 1 || offset_into_page == 0)
+		if (page->index > end_index ||
+		    (page->index == end_index && offset_into_page == 0))
 			goto redirty;
 
 		/*
 		 * The page straddles i_size.  It must be zeroed out on each
 		 * and every writepage invocation because it may be mmapped.
 		 * "A file is mapped in multiples of the page size.  For a file
-		 * that is not a multiple of the  page size, the remaining
+		 * that is not a multiple of the page size, the remaining
 		 * memory is zeroed when mapped, and writes to that region are
 		 * not written out to the file."
 		 */
 		zero_user_segment(page, offset_into_page, PAGE_CACHE_SIZE);
+
+		/* Adjust the end_offset to the end of file */
+		end_offset = offset;
 	}
 
-	end_offset = min_t(unsigned long long,
-			(xfs_off_t)(page->index + 1) << PAGE_CACHE_SHIFT,
-			offset);
 	len = 1 << inode->i_blkbits;
 
 	bh = head = page_buffers(page);
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
