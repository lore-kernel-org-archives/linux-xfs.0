Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EEA217F50
	for <xfs@oss.sgi.com>; Sat,  9 Jan 2016 15:17:23 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6A4D3AC002
	for <xfs@oss.sgi.com>; Sat,  9 Jan 2016 13:17:20 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id ybYmERoQU3RZbuKA (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 09 Jan 2016 13:17:18 -0800 (PST)
Date: Sat, 9 Jan 2016 13:17:13 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] xfs: cancel COW in xfs_cancel_ioend
Message-ID: <20160109211713.GB6112@birch.djwong.org>
References: <1451822873-12969-1-git-send-email-hch@lst.de>
	<1451822873-12969-4-git-send-email-hch@lst.de>
	<20160105014310.GK28330@birch.djwong.org>
	<20160105104214.GA16310@infradead.org>
	<20160107003227.GB8015@birch.djwong.org>
	<20160107152541.GA16982@lst.de>
	<20160108100933.GN28330@birch.djwong.org>
	<20160108134704.GA6708@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160108134704.GA6708@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Fri, Jan 08, 2016 at 02:47:04PM +0100, Christoph Hellwig wrote:
> Thanks Darrick!
> 
> I've not seen the inode eviction asserts anymore, but I now hit a
> corruption warnings in generic/168 reliably.  I did hit before as
> well, but not very reliably.

I'll see if I can repro the 168 error; it's been running in a loop all
night and hasn't bombed yet.

In the meantime, I added some more tests and fixed a CoW corruption when an
xfs_io_overwrite extent has cow reservations in the middle of the extent.

I also restarted testing on arm64, ppc64{,el}, and i686; it seems
stable enough right now to pass all ~130 reflink xfstests here.

> generic/168 17s ...[  296.988867] XFS (vdc): Metadata corruption detected at
> xfs_refcountbt_write_verify+0x3e/0x90, block 0xb0
> [  296.990412] XFS (vdc): Unmount and run xfs_repair
> [  296.991300] XFS (vdc): First 64 bytes of corrupted metadata buffer:
> [  296.992349] ffff88007b755000: 52 33 46 43 00 01 00 01 ff ff ff ff ff ff ff
> ff  R3FC............
> [  296.993893] ffff88007b755010: 00 00 00 00 00 00 00 b0 00 00 00 00 00 00 00
> 00  ................

No LSN?  That's ... odd.

> [  297.003293] ffff88007b755020: fe 94 c7 69 fd bd 4a 77 85 3d 9d 6d 7b 45 38
> 07  ...i..Jw.=.m{E8.

Does this match the FS UUID?

> [  297.004442] ffff88007b755030: 00 00 00 00 00 00 00 00 00 00 0b 9c 00 00 7f
> 07  ................

Also no owner or CRC.  Hmmmm.

> [  297.005867] XFS (vdc): xfs_do_force_shutdown(0x8) called from line 1247 of
> file fs/xfs/xfs_buf.c.  Return address = 0xffffffff814cce52
> 
> I'll investigate it in a little more detail.

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
