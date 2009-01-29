Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0TISxKQ225113 for <xfs@oss.sgi.com>; Thu, 29 Jan 2009 12:28:59 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 176ED1887310
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2009 10:28:16 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com
	with ESMTP id S1zF7kFNRlMEdNmX for <xfs@oss.sgi.com>;
	Thu, 29 Jan 2009 10:28:16 -0800 (PST)
Date: Thu, 29 Jan 2009 11:45:02 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: spurious -ENOSPC on XFS
In-Reply-To: <Pine.LNX.4.64.0901291136050.19368@hs20-bc2-1.build.redhat.com>
Message-ID: <Pine.LNX.4.64.0901291142480.20219@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0901120509550.11089@hs20-bc2-1.build.redhat.com>
	<20090113214949.GN8071@disturbed>
	<Pine.LNX.4.64.0901132324070.16396@hs20-bc2-1.build.redhat.com>
	<20090118173144.GA1999@infradead.org>
	<Pine.LNX.4.64.0901201430250.4603@hs20-bc2-1.build.redhat.com>
	<20090120232422.GF10158@disturbed>
	<20090122205913.GA30859@infradead.org>
	<20090122224347.GA18751@infradead.org>
	<Pine.LNX.4.64.0901231509010.5179@hs20-bc2-1.build.redhat.com>
	<20090124071249.GF32390@disturbed>
	<Pine.LNX.4.64.0901291136050.19368@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

> > > So synchronous flushing definitely needs some thinking and lock 
> > > rearchitecting.
> > 
> > No, not at all. At most the grabbing of the iolock in
> > xfs_sync_inodes_ag() needs to become a trylock....
> > 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> 
> You are wrong, the comments in the code are right. It really deadlocks if 
> it is modified to use synchronous wait for the end of the flush and if 
> the flush is done with xfs_sync_inodes:
> 
> xfssyncd      D 0000000000606808     0  4819      2
> Call Trace:
>  [0000000000606788] rwsem_down_failed_common+0x1ac/0x1d8
>  [0000000000606808] rwsem_down_read_failed+0x24/0x34
>  [0000000000606848] __down_read+0x30/0x40
>  [0000000000468a64] down_read_nested+0x48/0x58
>  [00000000100e6cc8] xfs_ilock+0x48/0x8c [xfs]
>  [000000001011018c] xfs_sync_inodes_ag+0x17c/0x2dc [xfs]
>  [000000001011034c] xfs_sync_inodes+0x60/0xc4 [xfs]
>  [00000000101103c4] xfs_flush_device_work+0x14/0x2c [xfs]
>  [000000001010ff1c] xfssyncd+0x110/0x174 [xfs]
>  [000000000046556c] kthread+0x54/0x88
>  [000000000042b2a0] kernel_thread+0x3c/0x54
>  [00000000004653b8] kthreadd+0xac/0x160
> dd            D 00000000006045c4     0  4829   2500
> Call Trace:
>  [00000000006047d8] schedule_timeout+0x24/0xb8
>  [00000000006045c4] wait_for_common+0xe4/0x14c
>  [0000000000604700] wait_for_completion+0x1c/0x2c
>  [00000000101106b0] xfs_flush_device+0x68/0x88 [xfs]
>  [00000000100edba4] xfs_flush_space+0xa8/0xd0 [xfs]
>  [00000000100edec0] xfs_iomap_write_delay+0x1bc/0x228 [xfs]
>  [00000000100ee4b8] xfs_iomap+0x1c4/0x2e0 [xfs]
>  [0000000010104f04] __xfs_get_blocks+0x74/0x240 [xfs]
>  [000000001010512c] xfs_get_blocks+0x24/0x38 [xfs]
>  [00000000004d05f0] __block_prepare_write+0x184/0x41c
>  [00000000004d095c] block_write_begin+0x84/0xe8
>  [000000001010447c] xfs_vm_write_begin+0x3c/0x50 [xfs]
>  [0000000000485258] generic_file_buffered_write+0xe8/0x28c
>  [000000001010cec4] xfs_write+0x40c/0x604 [xfs]
>  [0000000010108d3c] xfs_file_aio_write+0x74/0x84 [xfs]
>  [00000000004ae70c] do_sync_write+0x8c/0xdc
> 
> Mikulas

BTW. I modified it to use completion to wait for the end of the sync work 
(instead of that fixed 500ms wait) and got this deadlock quite quickly.

filemap_flush used to deadlock, I disabled it and used only 
xfs_sync_inodes, but xfs_sync_inodes also deadlocks.

Mikulas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
