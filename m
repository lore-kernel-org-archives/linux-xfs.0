Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BB8A47F82
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 03:56:09 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 441DEAC003
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 01:56:06 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	6AiuNOyNFcbueLvv for <xfs@oss.sgi.com>;
	Tue, 28 Jan 2014 01:56:03 -0800 (PST)
Date: Tue, 28 Jan 2014 20:55:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [NOISE] merge window blues, XFS broken
Message-ID: <20140128095559.GJ2212@dastard>
References: <52E56386.5040802@gmail.com> <20140127015614.GD2212@dastard>
	<52E62ADA.2040800@gmail.com> <20140127233039.GF2212@dastard>
	<52E768CF.5040908@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52E768CF.5040908@gmail.com>
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
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Jan 28, 2014 at 03:22:39AM -0500, Michael L. Semon wrote:
> On 01/27/2014 06:30 PM, Dave Chinner wrote:
> > On Mon, Jan 27, 2014 at 04:46:02AM -0500, Michael L. Semon wrote:
> >> root@plbearer:~# ls $TEST_DIR/
> >>
> >> [   94.140207] XFS: Assertion failed: IS_ALIGNED((unsigned long)vec->i_addr, sizeof(uint64_t)), file: fs/xfs/xfs_log.h, line: 49
> >>
> >> Entering kdb (current=0xc5298c30, pid 297) Oops: (null)
> >> due to oops @ 0x791752c5
> >> CPU: 0 PID: 297 Comm: ls Not tainted 3.13.0+ #1
> >> Hardware name: Dell Computer Corporation Dimension 2350/07W080, BIOS A01 12/17/2002
> >> task: c5298c30 ti: c520e000 task.ti: c520e000
> >> EIP: 0060:[<791752c5>] EFLAGS: 00010286 CPU: 0
> >> EIP is at assfail+0x2b/0x2d
> >> EAX: 00000071 EBX: c60ba600 ECX: 00000296 EDX: c5299098
> >> ESI: c60ba61c EDI: c60ba600 EBP: c520fe40 ESP: c520fe2c
> >>  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> >> CR0: 80050033 CR2: 08f1612c CR3: 4d1f0000 CR4: 000007d0
> >> Stack:
> >>  00000000 79570bc8 79576e28 7956946d 00000031 c520fe70 791ce45f c520fe70
> >>  7917ceb0 c520fec4 c50d5068 c520fe70 c55d8000 00000000 c50d5068 c607ae30
> >>  c60ba600 c520fed4 791cb72b c607af80 c6c01e80 000000d8 c4294000 c520feec
> >> Call Trace:
> >>  [<791ce45f>] xfs_inode_item_format+0x4a/0x1c5
> > 
> > It's not clear to me that there's anything wrong with the inode log
> > item structure, so I need to know what iovec we tripped over here.
> > Can you post the disassembly of this function so we can see which
> > call to xlog_prepare_iovec tripped the assert? i.e.:
.....
> OK, I had to generate a new crash for this, so pardon the dust:

Actually, you don't ned to crash a kernel to do this. Just run
'gdb vmlinux' from your build directory....

> crash> gdb disass /m xfs_inode_item_format
> Dump of assembler code for function xfs_inode_item_format:
> 367     {
>    0x791ce415 <+0>:     push   %ebp
>    0x791ce416 <+1>:     mov    %esp,%ebp
>    0x791ce418 <+3>:     push   %edi
>    0x791ce419 <+4>:     push   %esi
>    0x791ce41a <+5>:     push   %ebx
>    0x791ce41b <+6>:     sub    $0x1c,%esp
>    0x791ce41e <+9>:     lea    %ds:0x0(%esi,%eiz,1),%esi
>    0x791ce423 <+14>:    mov    %eax,-0x1c(%ebp)
>    0x791ce426 <+17>:    mov    %edx,%ebx
> 
> 368             struct xfs_inode_log_item *iip = INODE_ITEM(lip);
> 369             struct xfs_inode        *ip = iip->ili_inode;
>    0x791ce428 <+19>:    mov    0x44(%eax),%eax
>    0x791ce42b <+22>:    mov    %eax,-0x14(%ebp)
> 
> 370             struct xfs_inode_log_format *ilf;
> 371             struct xfs_log_iovec    *vecp = NULL;
>    0x791ce42e <+25>:    movl   $0x0,-0x10(%ebp)
> 
> 372     
> 373             ilf = xlog_prepare_iovec(lv, &vecp, XLOG_REG_TYPE_IFORMAT);
> 374             ilf->ilf_type = XFS_LI_INODE;
>    0x791ce464 <+79>:    movw   $0x123b,(%esi)

Ok, so xfs_inode_item_format+0x4a is inside the very first call to
preapre the ilf structure. That tells us that the initial
xfs_log_vec/xfs_log_iovec array are resulting in an unaligned
buffer.

Can you try the patch below, Michael?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: ensure correct log item buffer alignment

From: Dave Chinner <dchinner@redhat.com>

On 32 bit platforms, the log item vector headers are not 64 bit
aligned or sized. hence if we don't take care to align them
correctly or pad the buffer appropriately for 8 byte alignment, we
can end up with alignment issues when accessing the user buffer
directly as a structure.

To solve this, simply pad the buffer headers to 64 bit offset so
that the data section is always 8 byte aligned. 

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index cdebd83..4ef6fdb 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -205,16 +205,25 @@ xlog_cil_insert_format_items(
 		/*
 		 * We 64-bit align the length of each iovec so that the start
 		 * of the next one is naturally aligned.  We'll need to
-		 * account for that slack space here.
+		 * account for that slack space here. Then round nbytes up
+		 * to 64-bit alignment so that the initial buffer alignment is
+		 * easy to calculate and verify.
 		 */
 		nbytes += niovecs * sizeof(uint64_t);
+		nbytes = round_up(nbytes, sizeof(uint64_t));
 
 		/* grab the old item if it exists for reservation accounting */
 		old_lv = lip->li_lv;
 
-		/* calc buffer size */
-		buf_size = sizeof(struct xfs_log_vec) + nbytes +
-				niovecs * sizeof(struct xfs_log_iovec);
+		/*
+		 * The data buffer needs to start 64-bit aligned, so round up
+		 * that space to ensure we can align it appropriately and not
+		 * overrun the buffer.
+		 */
+		buf_size = nbytes +
+			   round_up((sizeof(struct xfs_log_vec) +
+				     niovecs * sizeof(struct xfs_log_iovec)),
+				    sizeof(uint64_t));
 
 		/* compare to existing item size */
 		if (lip->li_lv && buf_size <= lip->li_lv->lv_size) {
@@ -251,6 +260,8 @@ xlog_cil_insert_format_items(
 		/* The allocated data region lies beyond the iovec region */
 		lv->lv_buf_len = 0;
 		lv->lv_buf = (char *)lv + buf_size - nbytes;
+		ASSERT(IS_ALIGNED((unsigned long)lv->lv_buf, sizeof(uint64_t)));
+
 		lip->li_ops->iop_format(lip, lv);
 insert:
 		ASSERT(lv->lv_buf_len <= nbytes);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
