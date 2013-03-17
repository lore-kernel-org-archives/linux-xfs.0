Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5AFA07F63
	for <xfs@oss.sgi.com>; Sun, 17 Mar 2013 10:01:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3ABBC8F804B
	for <xfs@oss.sgi.com>; Sun, 17 Mar 2013 08:01:28 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id J446hbYki8SyCCyf (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 17 Mar 2013 08:01:27 -0700 (PDT)
Message-ID: <5145DAB4.40007@oracle.com>
Date: Sun, 17 Mar 2013 23:01:08 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: fix ASSERTION failure in xfs_vm_write_failed()
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
Cc: "Michael L. Semon" <mlsemon35@gmail.com>

Hello,

Yesterday, Michael reported that ran xfstest-078 got kernel panic when growing a
small partition to a huge size(64-bit) on 32-bit system, this issue can be easily
reproduced on the latest upstream 38 to 39-rc2 if CONFIG_XFS_DEBUG is enabled.
According to my investigation, if the request pos offset exceeding 32-bit integer
range, evaluate block_offset with pos & PAGE_MASK will cause overflows so that
it most likely that the assert is not true.

This patch fix it by checking "block_offset + from == (pos & ~0UL)" instead.

Thanks,
-Jeff


From: Jie Liu <jeff.liu@oracle.com>

XFSTEST-078 cause kernel panic on 32-bit system if CONFIG_XFS_DEBUG is enabled:

XFS: Assertion failed: block_offset + from == pos, file: fs/xfs/xfs_aops.c, line: 1504
------------[ cut here ]------------
kernel BUG at fs/xfs/xfs_message.c:100!
invalid opcode: 0000 [#1] SMP 
Modules linked in: netconsole configfs xfs(O) libcrc32c joydev
Pid: 4280, comm: mkfs.xfs Tainted: G           O 3.9.0-rc2 #1 innotek GmbH VirtualBox
EIP: 0060:[<f9492e5b>] EFLAGS: 00010282 CPU: 0
EIP is at assfail+0x2b/0x30 [xfs]
EAX: 00000056 EBX: f6dca440 ECX: 00000007 EDX: f57d22a4
ESI: 1c2f8000 EDI: 00000000 EBP: eababd30 ESP: eababd1c
DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
CR0: 8005003b CR2: b2e43000 CR3: 2b92c000 CR4: 000006f0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Process mkfs.xfs (pid: 4280, ti=eabaa000 task=ebf35a90 task.ti=eabaa000)
Stack:
00000000 f9510c14 f950aa70 f950a96b 000005e0 eababd7c f947fb04 c19b0ea2
00000066 f30b22a0 c19b0ea2 00000000 f3dbc118 00001000 00000000 00000000
00000000 c15c7e89 00000000 1c2f8000 00000000 00000000 1c2f8000 00000080
Call Trace:
[<f947fb04>] xfs_vm_write_failed+0x74/0x1b0 [xfs]
[<c15c7e89>] ? printk+0x4d/0x4f
[<f947fd4d>] xfs_vm_write_begin+0x10d/0x170 [xfs]
[<c110a34c>] generic_file_buffered_write+0xdc/0x210
[<f9486639>] xfs_file_buffered_aio_write+0xf9/0x190 [xfs]
[<f94867c3>] xfs_file_aio_write+0xf3/0x160 [xfs]
[<c115e504>] do_sync_write+0x94/0xd0
[<c115ed1f>] vfs_write+0x8f/0x160
[<c115e470>] ? wait_on_retry_sync_kiocb+0x50/0x50
[<c115f017>] sys_write+0x47/0x80
[<c15d860d>] sysenter_do_call+0x12/0x28
Code: 55 89 e5 83 ec 14 3e 8d 74 26 00 89 4c 24 10 89 54 24 0c 89 44
24 08 c7 44 24 04 14 0c 51 f9 c7 04 24 00 00 00 00 e8 d5 fd ff ff <0f>
0b 8d 76 00 55 89 e5 83 ec 14 3e 8d 74 26 00 b9 01 00 00 00
EIP: [<f9492e5b>] assfail+0x2b/0x30 [xfs] SS:ESP 0068:eababd1c
---[ end trace 3348226f4d43bec2 ]---
Kernel panic - not syncing: Fatal exception

On 32-bit system, if the request pos is 64-bit and evaluate block_offset
with (pos & PAGE_MASK) will result in overflows, therefore the assertion
will failed.  We have to check the write offset against (pos & ~0UL) to
avoid this issue as it can evaluate the highest 20 bits on 32-bit correctly
if the pos request is 64-bit and keep the expected result of 64-bit pos request
on 64-bit system unchanged.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Reported-by: Michael L. Semon <mlsemon35@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_aops.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 5f707e5..2fc7367 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1501,7 +1501,12 @@ xfs_vm_write_failed(
 	loff_t			to = from + len;
 	struct buffer_head	*bh, *head;
 
-	ASSERT(block_offset + from == pos);
+	/*
+	 * Evaluate block_offset via (pos & PAGE_MASK) on 32-bit system
+	 * can cause overflow if the request pos is 64-bit.  Hence we
+	 * have to verify the write offset with (pos & ~0UL) to avoid it.
+	 */
+	ASSERT(block_offset + from == (pos & ~0UL));
 
 	head = page_buffers(page);
 	block_start = 0;
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
