Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 772907FD8
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 22:28:24 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 60883304066
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 20:28:24 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id zCcDx3xSmdGLWs6c (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Dec 2013 20:28:14 -0800 (PST)
Message-ID: <52A7E9BC.3020905@oracle.com>
Date: Wed, 11 Dec 2013 12:27:40 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 04/15] mkfs: validate all input values
References: <1385689430-10103-1-git-send-email-david@fromorbit.com>	<1385689430-10103-5-git-send-email-david@fromorbit.com>	<20131202170420.GA14935@infradead.org>	<20131202231202.GA10988@dastard>
	<20131203094207.GB4906@infradead.org>
In-Reply-To: <20131203094207.GB4906@infradead.org>
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
To: Dave Chinner <david@fromorbit.com>Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi, Dave,

While test this patch, I wonder if we should also validate non-supported
data block size combine with the system page size or not, as we do such
kind of checkup for non-supported inode size in mkfs...

I can simply trigger scary corruption error with backtraces on 4K page
size machine via: mkfs.xfs -f -b size=8192 /dev/xxx; mount /dev/xxx /xfs

Also, here is patch inspired by Eric's previous fix for non-xfs mount probes.

Thanks,
-Jeff


From: Jie Liu <jeff.liu@oracle.com>
Subject: xfs: don't emit corruption noise on non-supported mount options

There is no need to issue the scary corruption error and backtrace
which were shown as following if we get ENOSYS due to mount with
non-supported options, e.g, mkfs.xfs -f -b size=8192 /dev/sda7

XFS (sda7): File system with blocksize 8192 bytes. Only pagesize (4096) or less will currently work.
.........
XFS (sda7): Internal error xfs_sb_read_verify at line 630 of file fs/xfs/xfs_sb.c
Workqueue: xfslogd xfs_buf_iodone_work [xfs]
Call Trace:
[<ffffffff8171412b>] dump_stack+0x45/0x56
[<ffffffffa0a63c7b>] xfs_error_report+0x3b/0x40 [xfs]
[<ffffffffa0a609e5>] ? xfs_buf_iodone_work+0xa5/0xd0 [xfs]
[<ffffffffa0a63cd5>] xfs_corruption_error+0x55/0x80 [xfs]
[<ffffffffa0ac9883>] xfs_sb_read_verify+0x143/0x150 [xfs]
[<ffffffffa0a609e5>] ? xfs_buf_iodone_work+0xa5/0xd0 [xfs]
[<ffffffffa0a609e5>] xfs_buf_iodone_work+0xa5/0xd0 [xfs]
[<ffffffff81080582>] process_one_work+0x182/0x450
[<ffffffff81081341>] worker_thread+0x121/0x410
[<ffffffff81081220>] ? rescuer_thread+0x3e0/0x3e0
[<ffffffff81087ff2>] kthread+0xd2/0xf0
[<ffffffff81087f20>] ? kthread_create_on_node+0x190/0x190
[<ffffffff81724c3c>] ret_from_fork+0x7c/0xb0
[<ffffffff81087f20>] ? kthread_create_on_node+0x190/0x190
XFS (sda7): Corruption detected. Unmount and run xfs_repair
XFS (sda7): SB validate failed with error 38.

This is inspired by another similar fix from Eric Sandeen:
[ commit 31625f28a "xfs: don't emit corruption noise on fs probes" ]

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_sb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_sb.c b/fs/xfs/xfs_sb.c
index b7c9aea..47e69c8 100644
--- a/fs/xfs/xfs_sb.c
+++ b/fs/xfs/xfs_sb.c
@@ -625,7 +625,7 @@ xfs_sb_read_verify(
 
 out_error:
 	if (error) {
-		if (error != EWRONGFS)
+		if (error != EWRONGFS && error != ENOSYS)
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
 					     mp, bp->b_addr);
 		xfs_buf_ioerror(bp, error);
-- 
1.8.3.2


On 12/03 2013 17:42 PM, Christoph Hellwig wrote:
> On Tue, Dec 03, 2013 at 10:12:02AM +1100, Dave Chinner wrote:
>> How does this make sense, though?
>>
>> # mkfs.xfs -s size=4s /dev/vda
>>
>> Specifying the sector size in *sectors* is currently considered a
>> valid thing to do. That's insane and fundamentally broken, because
>> this
>>
>> # mkfs.xfs -b size=4s -s size=2s /dev/vda
>>
>> results in the block size conversion using a 512 byte sector size,
>> and everything else using a 1024 byte sector size for conversions.
>> e.g:
>>
>> # mkfs.xfs -b size=4s -s size=2s -n size=2s /dev/vda
>>
>> results in a block size of 2k (4*512) and a directory block size of
>> 2k (2*1024). i.e. the result of unit conversion is dependent on
>> where the sector size is specified on the command line!
> 
> True.  Guess we should indeed just outright rejecting it.  I was more
> concerned about using the sector size before defined for other
> parameters, but given how seldomly we specify it on the command line
> anyway we're probably better off just using the normal table based
> validation.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
