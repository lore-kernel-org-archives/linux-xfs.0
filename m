Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30238 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728215AbfAVNC5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 22 Jan 2019 08:02:57 -0500
Date: Tue, 22 Jan 2019 08:02:55 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Regular FS shutdown while rsync is running
Message-ID: <20190122130254.GA22901@bfoster>
References: <1543238989.2507.33.camel@pengutronix.de>
 <20181126153249.GC14585@bfoster>
 <1548067317.2465.7.camel@pengutronix.de>
 <20190121130121.GA4537@bfoster>
 <1548087824.2465.9.camel@pengutronix.de>
 <20190121181151.GD14281@bfoster>
 <1548153593.2465.18.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1548153593.2465.18.camel@pengutronix.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Lucas Stach <l.stach@pengutronix.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 22, 2019 at 11:39:53AM +0100, Lucas Stach wrote:
> Hi Brian,
> 
> Am Montag, den 21.01.2019, 13:11 -0500 schrieb Brian Foster:
> [...]
> > > So for the moment, here's the output of the above sequence.
> > > 
> > > xfs_db> convert agno 5 agbno 7831662 fsb
> > > 0x5077806e (1350008942)
> > > xfs_db> fsb 0x5077806e
> > > xfs_db> type finobt
> > > xfs_db> print
> > > magic = 0x49414233
> > > level = 1
> > > numrecs = 335
> > > leftsib = 7810856
> > > rightsib = null
> > > bno = 7387612016
> > > lsn = 0x6671003d9700
> > > uuid = 026711cc-25c7-44b9-89aa-0aac496edfec
> > > owner = 5
> > > crc = 0xe12b19b2 (correct)
> > 
> > As expected, we have the inobt magic. Interesting that this is a fairly
> > full intermediate (level > 0) node. There is no right sibling, which
> > means we're at the far right end of the tree. I wouldn't mind poking
> > around a bit more at the tree, but that might be easier with access to
> > the metadump. I also think that xfs_repair would have complained were
> > something more significant wrong with the tree.
> > 
> > Hmm, I wonder if the (lightly tested) diff below would help us catch
> > anything. It basically just splits up the currently combined inobt and
> > finobt I/O verifiers to expect the appropriate magic number (rather than
> > accepting either magic for both trees). Could you give that a try?
> > Unless we're doing something like using the wrong type of cursor for a
> > particular tree, I'd think this would catch wherever we happen to put a
> > bad magic on disk. Note that this assumes the underlying filesystem has
> > been repaired so as to try and detect the next time an on-disk
> > corruption is introduced.
> > 
> > You'll also need to turn up the XFS error level to make sure this prints
> > out a stack trace if/when a verifier failure triggers:
> > 
> > echo 5 > /proc/sys/fs/xfs/error_level
> > 
> > I guess we also shouldn't rule out hardware issues or whatnot. I did
> > notice you have a strange kernel version: 4.19.4-holodeck10. Is that a
> > distro kernel? Has it been modified from upstream in any way? If so, I'd
> > strongly suggest to try and confirm whether this is reproducible with an
> > upstream kernel.
> 
> With the finobt verifier changes applied we are unable to mount the FS,
> even after running xfs_repair.
> 
> xfs_repair had found "bad magic # 0x49414233 in inobt block 5/2631703",
> which would be daddr 0x1b5db40b8 according to xfs_db. The mount trips
> over a buffer at a different daddr though:
> 

So the mount failed, you ran repair and discovered the bad magic..? That
suggests there was still an issue with the fs on-disk. Could you run
'xfs_repair -n' after the actual xfs_repair to confirm the fs is free of
errors before it is mounted? Note that xfs_repair unconditionally
regenerates certain metadata structures (like the finobt) from scratch
so there is always the possibility that xfs_repair itself is introducing
some problem in the fs.

I'm not quite sure what to make of the daddr discrepancy atm. As
described in Dave's mail, it might be interesting to spot check each
supposedly corrupted daddr in xfs_db and see which one is actually
busted. That essentially could mean to convert to fsb, load the fsb,
print the (decoded) block, visit a left or right sibling and check the
magic of the sibling and whether the sibling correctly points back to
the original block. Note that the sibling pointers are AG relative
blocks, so you'd need to find the agno from the daddr and do a "convert
agno <agno> agbno <ptr> fsb" to get the actual fsb to visit.

The intent of this is to try and get an idea of whether one of these
might be a misdirected read of an inobt block when trying to read the
finobt, and thus the magic on disk is actually correct. IOW, if we load
the fsb and see it has left/right siblings which also have inobt magics,
that might suggest we are actually looking at the inobt (I may want to
confirm that slice of the tree is actually active via a lookup, but one
thing at a time...).

> [   73.237007] XFS (dm-3): Mounting V5 Filesystem
> [   73.456481] XFS (dm-3): Ending clean mount
> [   74.132671] XFS (dm-3): Metadata corruption detected at xfs_finobt_verify+0x50/0x90 [xfs], xfs_finobt block 0x1b5df7d50 
> [   74.133028] XFS (dm-3): Unmount and run xfs_repair
> [   74.133184] XFS (dm-3): First 128 bytes of corrupted metadata buffer:
> [   74.133395] 00000000e44dfb87: 49 41 42 33 00 01 01 50 00 07 53 58 ff ff ff ff  IAB3...P..SX....
> [   74.133679] 000000009f21b317: 00 00 00 01 b5 df 7d 50 00 00 00 00 00 00 00 00  ......}P........
> [   74.133964] 000000003429321b: 02 67 11 cc 25 c7 44 b9 89 aa 0a ac 49 6e df ec  .g..%.D.....In..
> [   74.134272] 00000000fe79b835: 00 00 00 05 24 52 54 c6 32 dc 7d 00 32 e9 b9 a0  ....$RT.2.}.2...
> [   74.134554] 00000000d1e887dc: 32 f4 97 80 33 01 36 80 33 09 ca 80 33 1e b7 80  2...3.6.3...3...
> [   74.134852] 00000000612879d2: 33 2f 50 00 33 33 e8 80 33 40 a9 c0 33 4c 08 80  3/P.33..3@..3L..
> [   74.135140] 00000000e63fd33a: 33 64 d7 80 33 79 34 40 33 8f 08 80 33 a7 be c0  3d..3y4@3...3...
> [   74.135427] 00000000d1c405d7: 33 b6 10 80 33 bf 1e c0 33 d0 99 00 33 df cd 00  3...3...3...3...
> [   74.135871] XFS (dm-3): Metadata corruption detected at xfs_finobt_verify+0x50/0x90 [xfs], xfs_finobt block 0x1b5df7d50 
> [   74.136231] XFS (dm-3): Unmount and run xfs_repair
> [   74.136390] XFS (dm-3): First 128 bytes of corrupted metadata buffer:
> [   74.136604] 00000000e44dfb87: 49 41 42 33 00 01 01 50 00 07 53 58 ff ff ff ff  IAB3...P..SX....
> [   74.136887] 000000009f21b317: 00 00 00 01 b5 df 7d 50 00 00 00 00 00 00 00 00  ......}P........
> [   74.137174] 000000003429321b: 02 67 11 cc 25 c7 44 b9 89 aa 0a ac 49 6e df ec  .g..%.D.....In..
> [   74.137463] 00000000fe79b835: 00 00 00 05 24 52 54 c6 32 dc 7d 00 32 e9 b9 a0  ....$RT.2.}.2...
> [   74.137750] 00000000d1e887dc: 32 f4 97 80 33 01 36 80 33 09 ca 80 33 1e b7 80  2...3.6.3...3...
> [   74.138035] 00000000612879d2: 33 2f 50 00 33 33 e8 80 33 40 a9 c0 33 4c 08 80  3/P.33..3@..3L..
> [   74.138358] 00000000e63fd33a: 33 64 d7 80 33 79 34 40 33 8f 08 80 33 a7 be c0  3d..3y4@3...3...
> [   74.138639] 00000000d1c405d7: 33 b6 10 80 33 bf 1e c0 33 d0 99 00 33 df cd 00  3...3...3...3...
> [   74.138964] XFS (dm-3): metadata I/O error in "xfs_trans_read_buf_map" at daddr 0x1b5df7d50 len 8 error 117
> [   78.489686] XFS (dm-3): Error -117 reserving per-AG metadata reserve pool.
> [   78.489691] XFS (dm-3): xfs_do_force_shutdown(0x8) called from line 548 of file fs/xfs/xfs_fsops.c.  Return address = 00000000b2beb4b0
> [   78.489697] XFS (dm-3): Corruption of in-memory data detected.  Shutting down filesystem
> [   78.489955] XFS (dm-3): Please umount the filesystem and rectify the problem(s)
> 
> Is this a real issue, or false positive due to things working
> differently during early mount?
> 

The mount isn't behaving any differently here. The internal block
reservation mechanism runs a scan of the finobt on mount for internal
accounting purposes. This is a read only scan, but now that we're
enforcing that finobt blocks must have finobt magic this appears to act
as a mount time scrub of the issue we're looking for. I think that if
the filesystem is clear of this state at mount time, we'd get through
this phase and the mount sequence without incident.

BTW, did you bump the error_level? Was a stack trace not printed with
this error report?

Brian

> Regards,
> Lucas
