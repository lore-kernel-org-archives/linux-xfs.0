Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 415327F6C
	for <xfs@oss.sgi.com>; Mon, 27 Jan 2014 17:30:44 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 16AE38F804B
	for <xfs@oss.sgi.com>; Mon, 27 Jan 2014 15:30:43 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	uP8ORHJ3RRalJCmx for <xfs@oss.sgi.com>;
	Mon, 27 Jan 2014 15:30:41 -0800 (PST)
Date: Tue, 28 Jan 2014 10:30:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [NOISE] merge window blues, XFS broken
Message-ID: <20140127233039.GF2212@dastard>
References: <52E56386.5040802@gmail.com> <20140127015614.GD2212@dastard>
	<52E62ADA.2040800@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52E62ADA.2040800@gmail.com>
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

On Mon, Jan 27, 2014 at 04:46:02AM -0500, Michael L. Semon wrote:
> root@plbearer:~# ls $TEST_DIR/
> 
> [   94.140207] XFS: Assertion failed: IS_ALIGNED((unsigned long)vec->i_addr, sizeof(uint64_t)), file: fs/xfs/xfs_log.h, line: 49
> 
> Entering kdb (current=0xc5298c30, pid 297) Oops: (null)
> due to oops @ 0x791752c5
> CPU: 0 PID: 297 Comm: ls Not tainted 3.13.0+ #1
> Hardware name: Dell Computer Corporation Dimension 2350/07W080, BIOS A01 12/17/2002
> task: c5298c30 ti: c520e000 task.ti: c520e000
> EIP: 0060:[<791752c5>] EFLAGS: 00010286 CPU: 0
> EIP is at assfail+0x2b/0x2d
> EAX: 00000071 EBX: c60ba600 ECX: 00000296 EDX: c5299098
> ESI: c60ba61c EDI: c60ba600 EBP: c520fe40 ESP: c520fe2c
>  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> CR0: 80050033 CR2: 08f1612c CR3: 4d1f0000 CR4: 000007d0
> Stack:
>  00000000 79570bc8 79576e28 7956946d 00000031 c520fe70 791ce45f c520fe70
>  7917ceb0 c520fec4 c50d5068 c520fe70 c55d8000 00000000 c50d5068 c607ae30
>  c60ba600 c520fed4 791cb72b c607af80 c6c01e80 000000d8 c4294000 c520feec
> Call Trace:
>  [<791ce45f>] xfs_inode_item_format+0x4a/0x1c5

It's not clear to me that there's anything wrong with the inode log
item structure, so I need to know what iovec we tripped over here.
Can you post the disassembly of this function so we can see which
call to xlog_prepare_iovec tripped the assert? i.e.:

gdb> disass xfs_inode_item_format

to give the raw disassembly output, and

gdb> disass /m xfs_inode_item_format

To output the c-code annotated version.

Or even just annotating the code with printk()s prior to each
xlog_prepare_iovec() call in xfs_inode_item_format will do ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
