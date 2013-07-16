Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CCA3F7F37
	for <xfs@oss.sgi.com>; Tue, 16 Jul 2013 00:11:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3CE3AAC001
	for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 22:11:02 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 5uaWwU9JF0u0GJHt (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 15 Jul 2013 22:11:00 -0700 (PDT)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r6G5AxWI023042
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 16 Jul 2013 05:11:00 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r6G5Aw4Q013455
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 16 Jul 2013 05:10:59 GMT
Received: from abhmt113.oracle.com (abhmt113.oracle.com [141.146.116.65])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r6G5AvST004090 for <xfs@oss.sgi.com>; Tue, 16 Jul 2013 05:10:58 GMT
Message-ID: <51E4D5F4.902@oracle.com>
Date: Tue, 16 Jul 2013 13:11:16 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH RESEND] xfs:  fix assertion failure in xfs_vm_write_failed()
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

In xfs_vm_write_failed(), we evaluate the block_offset of pos with
PAGE_MASK which is an unsigned long.  That is fine on 64-bit platforms
regardless of whether the request pos is 32-bit or 64-bit.  However, on
32-bit platforms the value is 0xfffff000 and so the high 32 bits in it
will be masked off with (pos & PAGE_MASK) for a 64-bit pos.

As a result, the evaluated block_offset is incorrect which will cause
this failure ASSERT(block_offset + from == pos); and potentially pass
the wrong block to xfs_vm_kill_delalloc_range().

In this case, we can get a kernel panic if CONFIG_XFS_DEBUG is enabled:

XFS: Assertion failed: block_offset + from == pos, file: fs/xfs/xfs_aops.c, line: 1504

------------[ cut here ]------------
 kernel BUG at fs/xfs/xfs_message.c:100!
 invalid opcode: 0000 [#1] SMP
 ........
 Pid: 4057, comm: mkfs.xfs Tainted: G           O 3.9.0-rc2 #1
 EIP: 0060:[<f94a7e8b>] EFLAGS: 00010282 CPU: 0
 EIP is at assfail+0x2b/0x30 [xfs]
 EAX: 00000056 EBX: f6ef28a0 ECX: 00000007 EDX: f57d22a4
 ESI: 1c2fb000 EDI: 00000000 EBP: ea6b5d30 ESP: ea6b5d1c
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
 CR0: 8005003b CR2: 094f3ff4 CR3: 2bcb4000 CR4: 000006f0
 DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
 DR6: ffff0ff0 DR7: 00000400
 Process mkfs.xfs (pid: 4057, ti=ea6b4000 task=ea5799e0 task.ti=ea6b4000)
 Stack:
 00000000 f9525c48 f951fa80 f951f96b 000005e4 ea6b5d7c f9494b34 c19b0ea2
 00000066 f3d6c620 c19b0ea2 00000000 e9a91458 00001000 00000000 00000000
 00000000 c15c7e89 00000000 1c2fb000 00000000 00000000 1c2fb000 00000080
 Call Trace:
 [<f9494b34>] xfs_vm_write_failed+0x74/0x1b0 [xfs]
 [<c15c7e89>] ? printk+0x4d/0x4f
 [<f9494d7d>] xfs_vm_write_begin+0x10d/0x170 [xfs]
 [<c110a34c>] generic_file_buffered_write+0xdc/0x210
 [<f949b669>] xfs_file_buffered_aio_write+0xf9/0x190 [xfs]
 [<f949b7f3>] xfs_file_aio_write+0xf3/0x160 [xfs]
 [<c115e504>] do_sync_write+0x94/0xd0
 [<c115ed1f>] vfs_write+0x8f/0x160
 [<c115e470>] ? wait_on_retry_sync_kiocb+0x50/0x50
 [<c115f017>] sys_write+0x47/0x80
 [<c15d860d>] sysenter_do_call+0x12/0x28
 .............
 EIP: [<f94a7e8b>] assfail+0x2b/0x30 [xfs] SS:ESP 0068:ea6b5d1c
 ---[ end trace cdd9af4f4ecab42f ]---
 Kernel panic - not syncing: Fatal exception

In order to avoid this, we can evaluate the block_offset of the start
of the page by using shifts rather than masks the mismatch problem.

Thanks Dave Chinner for help finding and fixing this bug.

Reported-by: Michael L. Semon <mlsemon35@gmail.com>
Reviewed-by: Dave Chinner <david@fromorbit.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_aops.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 596ec71..7967086 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1516,13 +1516,26 @@ xfs_vm_write_failed(
 	loff_t			pos,
 	unsigned		len)
 {
-	loff_t			block_offset = pos & PAGE_MASK;
+	loff_t			block_offset;
 	loff_t			block_start;
 	loff_t			block_end;
 	loff_t			from = pos & (PAGE_CACHE_SIZE - 1);
 	loff_t			to = from + len;
 	struct buffer_head	*bh, *head;
 
+	/*
+	 * The request pos offset might be 32 or 64 bit, this is all fine
+	 * on 64-bit platform.  However, for 64-bit pos request on 32-bit
+	 * platform, the high 32-bit will be masked off if we evaluate the
+	 * block_offset via (pos & PAGE_MASK) because the PAGE_MASK is
+	 * 0xfffff000 as an unsigned long, hence the result is incorrect
+	 * which could cause the following ASSERT failed in most cases.
+	 * In order to avoid this, we can evaluate the block_offset of the
+	 * start of the page by using shifts rather than masks the mismatch
+	 * problem.
+	 */
+	block_offset = (pos >> PAGE_CACHE_SHIFT) << PAGE_CACHE_SHIFT;
+
 	ASSERT(block_offset + from == pos);
 
 	head = page_buffers(page);
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
