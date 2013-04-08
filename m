Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C8D767F74
	for <xfs@oss.sgi.com>; Mon,  8 Apr 2013 16:47:59 -0500 (CDT)
Message-ID: <51633B0E.4010602@sgi.com>
Date: Mon, 08 Apr 2013 16:47:58 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfs: fix assertion failure in xfs_vm_write_failed()
References: <51469C90.1000001@oracle.com> <20130318233026.GS6369@dastard>
	<514800DB.5070306@oracle.com> <20130319192322.GB6369@dastard>
	<51491C5C.4040102@oracle.com>
In-Reply-To: <51491C5C.4040102@oracle.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "Michael L. Semon" <mlsemon35@gmail.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>


>>
>> Reviewed-by: Dave Chinner<dchinner@redhat.com>
>
> Thanks Dave for correcting me with detailed comments, the revised patch was shown as following.
>
> Regards,
> -Jeff
>
>
> In xfs_vm_write_failed(), we evaluate the block_offset of pos with PAGE_MASK
> which is an unsigned long.  That is fine on 64-bit platforms regardless of
> whether the request pos is 32-bit or 64-bit.  However, on 32-bit platforms
> the value is 0xfffff000 and so the high 32 bits in it will be masked off with
> (pos&  PAGE_MASK) for a 64-bit pos.  As a result, the evaluated block_offset is
> incorrect which will cause this failure ASSERT(block_offset + from == pos); and
> potentially pass the wrong block to xfs_vm_kill_delalloc_range().
>
> In this case, we can get the following kernel Panic if the CONFIG_XFS_DEBUG is enabled:
>
> [   68.700573] XFS: Assertion failed: block_offset + from == pos, file: fs/xfs/xfs_aops.c, line: 1504
> [   68.700656] ------------[ cut here ]------------
> [   68.700692] kernel BUG at fs/xfs/xfs_message.c:100!
> [   68.700742] invalid opcode: 0000 [#1] SMP
> ........
> [   68.701678] Pid: 4057, comm: mkfs.xfs Tainted: G           O 3.9.0-rc2 #1
> [   68.701722] EIP: 0060:[<f94a7e8b>] EFLAGS: 00010282 CPU: 0
> [   68.701783] EIP is at assfail+0x2b/0x30 [xfs]
> [   68.701819] EAX: 00000056 EBX: f6ef28a0 ECX: 00000007 EDX: f57d22a4
> [   68.701852] ESI: 1c2fb000 EDI: 00000000 EBP: ea6b5d30 ESP: ea6b5d1c
> [   68.701895]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [   68.701934] CR0: 8005003b CR2: 094f3ff4 CR3: 2bcb4000 CR4: 000006f0
> [   68.701970] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [   68.702011] DR6: ffff0ff0 DR7: 00000400
> [   68.702046] Process mkfs.xfs (pid: 4057, ti=ea6b4000 task=ea5799e0 task.ti=ea6b4000)
> [   68.702086] Stack:
> [   68.702124]  00000000 f9525c48 f951fa80 f951f96b 000005e4 ea6b5d7c f9494b34 c19b0ea2
> [   68.702445]  00000066 f3d6c620 c19b0ea2 00000000 e9a91458 00001000 00000000 00000000
> [   68.702868]  00000000 c15c7e89 00000000 1c2fb000 00000000 00000000 1c2fb000 00000080
> [   68.703192] Call Trace:
> [   68.703248]  [<f9494b34>] xfs_vm_write_failed+0x74/0x1b0 [xfs]
> [   68.703441]  [<c15c7e89>] ? printk+0x4d/0x4f
> [   68.703496]  [<f9494d7d>] xfs_vm_write_begin+0x10d/0x170 [xfs]
> [   68.703535]  [<c110a34c>] generic_file_buffered_write+0xdc/0x210
> [   68.703583]  [<f949b669>] xfs_file_buffered_aio_write+0xf9/0x190 [xfs]
> [   68.703629]  [<f949b7f3>] xfs_file_aio_write+0xf3/0x160 [xfs]
> [   68.703668]  [<c115e504>] do_sync_write+0x94/0xd0
> [   68.703716]  [<c115ed1f>] vfs_write+0x8f/0x160
> [   68.703753]  [<c115e470>] ? wait_on_retry_sync_kiocb+0x50/0x50
> [   68.703794]  [<c115f017>] sys_write+0x47/0x80
> [   68.703830]  [<c15d860d>] sysenter_do_call+0x12/0x28
> .............
> [   68.704203] EIP: [<f94a7e8b>] assfail+0x2b/0x30 [xfs] SS:ESP 0068:ea6b5d1c
> [   68.706615] ---[ end trace cdd9af4f4ecab42f ]---
> [   68.706687] Kernel panic - not syncing: Fatal exception
>
> In order to avoid this, we can evaluate the block_offset of the start of the page
> by using shifts rather than masks the mismatch problem.
>
> Thanks Dave Chinner for help finding and fixing this bug.
>
> Reported-by: Michael L. Semon<mlsemon35@gmail.com>
> Reviewed-by: Dave Chinner<david@fromorbit.com>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
> ---
>   fs/xfs/xfs_aops.c |   15 ++++++++++++++-
>   1 file changed, 14 insertions(+), 1 deletion(-)
>

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
