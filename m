Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EB0E57F81
	for <xfs@oss.sgi.com>; Sun, 17 Mar 2013 23:48:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 684FEAC002
	for <xfs@oss.sgi.com>; Sun, 17 Mar 2013 21:48:27 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id sD3MM2gd6FDk24sP (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 17 Mar 2013 21:48:26 -0700 (PDT)
Message-ID: <51469C90.1000001@oracle.com>
Date: Mon, 18 Mar 2013 12:48:16 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2] xfs: fix assertion failure in xfs_vm_write_failed()
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

Here is the v2 patch for fixing ASSERTION failed at xfs_vm_write_failed() according
to Dave's comments, so I added Dave as SOB for credit.

Hi Michael,
Please kindly try at your at your convenience.

Thanks,
-Jeff


From: Jie Liu <jeff.liu@oracle.com>

In xfs_vm_write_failed(), we evaluate the block_offset of pos with PAGE_MASK which
is 0xfffff000 as an unsigned long, that is fine on 64-bit system no matter the
request pos is 32-bit or 64-bit.  However, on 32-bit system, the high 32-bit in it
will be masked off with (pos & PAGE_MASK) for 64-bit pos request.  As a result, the
evaluated block_offset is incorrect which will trigger ASSERTION failure:
ASSERT(block_offset + from == pos);
In this case, we can get the following kernel Panic if the CONFIG_XFS_DEBUG is enabled:

[   68.700573] XFS: Assertion failed: block_offset + from == pos, file: fs/xfs/xfs_aops.c, line: 1504
[   68.700656] ------------[ cut here ]------------
[   68.700692] kernel BUG at fs/xfs/xfs_message.c:100!
[   68.700742] invalid opcode: 0000 [#1] SMP 
........
[   68.701678] Pid: 4057, comm: mkfs.xfs Tainted: G           O 3.9.0-rc2 #1
[   68.701722] EIP: 0060:[<f94a7e8b>] EFLAGS: 00010282 CPU: 0
[   68.701783] EIP is at assfail+0x2b/0x30 [xfs]
[   68.701819] EAX: 00000056 EBX: f6ef28a0 ECX: 00000007 EDX: f57d22a4
[   68.701852] ESI: 1c2fb000 EDI: 00000000 EBP: ea6b5d30 ESP: ea6b5d1c
[   68.701895]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   68.701934] CR0: 8005003b CR2: 094f3ff4 CR3: 2bcb4000 CR4: 000006f0
[   68.701970] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   68.702011] DR6: ffff0ff0 DR7: 00000400
[   68.702046] Process mkfs.xfs (pid: 4057, ti=ea6b4000 task=ea5799e0 task.ti=ea6b4000)
[   68.702086] Stack:
[   68.702124]  00000000 f9525c48 f951fa80 f951f96b 000005e4 ea6b5d7c f9494b34 c19b0ea2
[   68.702445]  00000066 f3d6c620 c19b0ea2 00000000 e9a91458 00001000 00000000 00000000
[   68.702868]  00000000 c15c7e89 00000000 1c2fb000 00000000 00000000 1c2fb000 00000080
[   68.703192] Call Trace:
[   68.703248]  [<f9494b34>] xfs_vm_write_failed+0x74/0x1b0 [xfs]
[   68.703441]  [<c15c7e89>] ? printk+0x4d/0x4f
[   68.703496]  [<f9494d7d>] xfs_vm_write_begin+0x10d/0x170 [xfs]
[   68.703535]  [<c110a34c>] generic_file_buffered_write+0xdc/0x210
[   68.703583]  [<f949b669>] xfs_file_buffered_aio_write+0xf9/0x190 [xfs]
[   68.703629]  [<f949b7f3>] xfs_file_aio_write+0xf3/0x160 [xfs]
[   68.703668]  [<c115e504>] do_sync_write+0x94/0xd0
[   68.703716]  [<c115ed1f>] vfs_write+0x8f/0x160
[   68.703753]  [<c115e470>] ? wait_on_retry_sync_kiocb+0x50/0x50
[   68.703794]  [<c115f017>] sys_write+0x47/0x80
[   68.703830]  [<c15d860d>] sysenter_do_call+0x12/0x28
.............
[   68.704203] EIP: [<f94a7e8b>] assfail+0x2b/0x30 [xfs] SS:ESP 0068:ea6b5d1c
[   68.706615] ---[ end trace cdd9af4f4ecab42f ]---
[   68.706687] Kernel panic - not syncing: Fatal exception

This patch fix the block_offset evaluation to clear the lower 12 bits as:
block_offset = pos >> PAGE_CACHE_SHIFT) << PAGE_CACHE_SHIFT
Hence, the ASSERTION should be correct because the from offset in a page
is evaluated to have the lower 12 bits only.

Thanks Dave Chinner for pointing this out.

Reported-by: Michael L. Semon <mlsemon35@gmail.com>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_aops.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 5f707e5..a418e17 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1494,7 +1494,8 @@ xfs_vm_write_failed(
 	loff_t			pos,
 	unsigned		len)
 {
-	loff_t			block_offset = pos & PAGE_MASK;
+	loff_t			block_offset = (pos >> PAGE_CACHE_SHIFT) <<
+						PAGE_CACHE_SHIFT;
 	loff_t			block_start;
 	loff_t			block_end;
 	loff_t			from = pos & (PAGE_CACHE_SIZE - 1);
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
