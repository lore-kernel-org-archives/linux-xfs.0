Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4DE817F3F
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 20:22:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2283B8F804C
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 18:22:16 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	dWKPMKezBrGq07Hv for <xfs@oss.sgi.com>;
	Tue, 24 Jun 2014 18:22:11 -0700 (PDT)
Date: Wed, 25 Jun 2014 11:21:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Metadata CRC error upon unclean unmount
Message-ID: <20140625012144.GK9508@dastard>
References: <CA+o=1OW0OXhzU+b9ACMZzg0dq=B7BSj+yPXD2Vrr9F6mWK8ruQ@mail.gmail.com>
	<20140624201946.GJ9508@dastard>
	<CA+o=1OVnORG0Ah3Zx8dkGzs7vtT7odRH=v12KqtLW0MP_3oHjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+o=1OVnORG0Ah3Zx8dkGzs7vtT7odRH=v12KqtLW0MP_3oHjQ@mail.gmail.com>
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
To: Fanael Linithien <fanael4@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Jun 24, 2014 at 11:50:52PM +0200, Fanael Linithien wrote:
> Managed to get the "metadata CRC error" again. Trying to get useful
> info from an initramfs recovery shell is fun.

What kernel are you running? (uname -a, please)

> dmesg:
> 
> [    4.215841] SGI XFS with ACLs, security attributes, realtime, large
> block/inode numbers, no debug enabled
> [    4.224047] XFS (sda1): Mounting V5 Filesystem
> [    4.527156] XFS (sda1): Starting recovery (logdev: internal)
> [    4.546698] XFS (sda1): Metadata CRC error detected at
> xfs_agi_read_verify+0x5e/0x110 [xfs], block 0x2
> [    4.547083] XFS (sda1): Unmount and run xfs_repair
> [    4.547347] XFS (sda1): First 64 bytes of corrupted metadata buffer:
> [    4.547670] ffff8800364d3600: 58 41 47 49 00 00 00 01 00 00 00 00
> 00 13 d0 00  XAGI............
> [    4.548027] ffff8800364d3610: 00 00 17 40 00 00 00 03 00 00 00 01
> 00 00 00 2b  ...@...........+
> [    4.548382] ffff8800364d3620: 00 0c 95 40 ff ff ff ff ff ff ff ff
> ff ff ff ff  ...@............
> [    4.548752] ffff8800364d3630: ff ff ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff  ................
> [    4.549420] XFS (sda1): metadata I/O error: block 0x2
> ("xfs_trans_read_buf_map") error 74 numblks 1
> 
> 
> Metadata dump (xz + base64): https://clbin.com/4KYSR

Yup, the CRC on disk is clearly wrong. Without mounting the
filesystem, it has a value of:

crc = 0x4e28030d (bad)

And after re-writing a field in it with xfs_db to the same value:

crc = 0x86a5538a (correct)

And then it mounts and recovers just fine.

But there's CRC errors in every AGI (all 4 on disk) and every inode
btree block, too.

Ok, dig further in to AGI 0 - the important bits form xfs_db:

length = 1298432
count = 5952
root = 3
level = 1
freecount = 43
lsn = 0x30000017e

Ok, so this version should match what is in the log checkpoint at
lsn = 0x30000017e. What do we have there:

LOG REC AT LSN cycle 3 block 382 (0x3, 0x17e)
============================================================================
TRANS: tid:0xc7ad5835  type:CHECKPOINT  #items:25  trans:0xc7ad5835  q:0x660a40
INO: cnt:2 total:2 a:0x668c10 len:56 a:0x660ac0 len:176 
        INODE: #regs:2   ino:0x85cee  flags:0x1   dsize:0
        CORE inode:
BUF: cnt:2 total:2 a:0x64f290 len:24 a:0x668c50 len:128 
        BUF:  #regs:2   start blkno:0x2   len:1   bmap size:1   flags:0x3800
        AGI Buffer: (XAGI)
                ver:1  seq#:0  len:1298432  cnt:5952  root:3
                level:1  free#:0x2c  newino:0xc9540
                         ^^^^^^^^^^
.....

0x2c = 44. The value on disk is *43*. It must have been logged again...

LOG REC AT LSN cycle 3 block 414 (0x3, 0x19e)
============================================================================
TRANS: tid:0x73c82586  type:CHECKPOINT  #items:23  trans:0x73c82586  q:0x660a40
INO: cnt:2 total:2 a:0x668c50 len:56 a:0x669880 len:176 
        INODE: #regs:2   ino:0xc9553  flags:0x1   dsize:0
        CORE inode:
BUF: cnt:2 total:2 a:0x66a110 len:24 a:0x6693d0 len:128 
        BUF:  #regs:2   start blkno:0x2   len:1   bmap size:1   flags:0x3800
        AGI Buffer: (XAGI)
                ver:1  seq#:0  len:1298432  cnt:5952  root:3
                level:1  free#:0x2b  newino:0xc9540

Yup, there it is - value 0x2b, which is 43. But if that value was
written to disk, then why is the LSN stamped in the buffer the
previous LSN? I can't see how that is possible, nor is the CRC in
the buffer consistent with just an updated LSN to match this
transaction.

OK:

$ xfs_db -x -c "agi 0" -c "write freecount 44" -c "p crc" -f agi-crc-bad.img 
Metadata CRC error detected at block 0x2/0x200
xfs_db: cannot init perag data (74). Continuing anyway.
freecount = 44
crc = 0x4e28030d (correct)
$

Ok, so the CRC corresponds to the version of the AGI that was logged
at lsn = 0x30000017e. That means the version on disk is a partial
update without a CRC recalculation. Ok, so how can that happen?

Given the lsn mismatch, I suspect log recovery has played a part as
it will not update the LSN when replaying changes in the log. It
should, however, always be attaching the appropriate verifier to
the buffers being recovered so the CRC should be recalculated
correctly.

Given that the CRC errors seem to propagate through the XAGI and
inode btree blocks *only*, it makes me think that unlinked inode
list recovery *might* have caused this, but I cannot yet see the
underlying cause of the initial corruption. What is clear, however,
is that you are now tripping over a problem caused by a previous
crash+recover cycle.

Can you reproduce the problem on demand from a brand new filesystem?
If so, can you run the cycle:

	mount
	write
	crash
	<restart>
	take metadump
	mount
	unmount
	run xfs_repair -n <dev>
	if clean
		do another iteration
	otherwise, something is wrong.
	record dmesg
	take a post-mount metadump
	post the pre- and post-mount metadumps for me to look at
	post the entire dmesg so I can look at it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
