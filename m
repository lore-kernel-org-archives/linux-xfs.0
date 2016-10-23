Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.webx.cz ([109.123.222.201]:39933 "EHLO mail.webx.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751161AbcJWGs3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 23 Oct 2016 02:48:29 -0400
From: Libor =?utf-8?B?S2xlcMOhxI0=?= <libor.klepac@bcom.cz>
Subject: Re: BUG: Metadata corruption detected at xfs_attr3_leaf_read_verify
Date: Sun, 23 Oct 2016 08:48:06 +0200
Message-ID: <3822835.q6ryES8eE3@libor-nb>
In-Reply-To: <20161021175912.GB54851@bfoster.bfoster>
References: <5244720.RPRsZ88NJ0@libor-nb> <20161021175912.GB54851@bfoster.bfoster>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

> On Fri, Oct 21, 2016 at 07:09:06PM +0200, Libor Klep�? wrote:
> > Hello,
> > Then shutdown occured on different block 0x12f63f40
> > Oct 14 12:00:24 vps2 kernel: [18872956.205316] XFS (dm-2): Metadata
> > corruption detected at xfs_attr3_leaf_write_verify+0xd5/0xe0 [xfs], block
> > 0x12f63f40 Oct 14 12:00:24 vps2 kernel: [18872956.208382] XFS (dm-2):
> > Unmount and run xfs_repair Oct 14 12:00:24 vps2 kernel: [18872956.209385]
> > XFS (dm-2): First 64 bytes of corrupted metadata buffer: Oct 14 12:00:24
> > vps2 kernel: [18872956.210187] ffff88011dadd000: 00 00 00 00 00 00 00 00
> > fb ee 00 00 00 00 00 00  ................ Oct 14 12:00:24 vps2 kernel:
> > [18872956.211816] ffff88011dadd010: 10 00 00 00 00 20 0f e0 00 00 00 00
> > 00 00 00 00  ..... .......... Oct 14 12:00:24 vps2 kernel:
> > [18872956.213390] ffff88011dadd020: 00 00 00 00 00 00 00 00 00 00 00 00
> > 00 00 00 00  ................ Oct 14 12:00:24 vps2 kernel:
> > [18872956.214983] ffff88011dadd030: 00 00 00 00 00 00 00 00 00 00 00 00
> > 00 00 00 00  ................ Oct 14 12:00:24 vps2 kernel:
> > [18872956.216598] XFS (dm-2): xfs_do_force_shutdown(0x8) called from line
> > 1330 of file /build/linux-U7H2aZ/linux-3.16.7-ckt20/fs/xfs/xfs_buf.c. 
> > Return address = 0xffffffffa03ef820 Oct 14 12:00:24 vps2 kernel:
> > [18872956.217448] XFS (dm-2): Corruption of in-memory data detected. 
> > Shutting down filesystem Oct 14 12:00:24 vps2 kernel: [18872956.218338]
> > XFS (dm-2): Please umount the filesystem and rectify the problem(s)
> The shutdown has more to do with whether the corruption is detected on
> read vs. write. E.g., we shutdown on write verifier failure to avoid
> writing corrupted data to disk and causing further damage.
> 
> I suppose in this particular instance we don't really know whether the
> corruption existed on disk or originated in memory. Regardless, the
> corruption appears to be consistently associated with extended attribute
> blocks. Are you running an application that makes heavy use of xattrs?
> 

Hello,
i think that xattrs are not used at all or rarely. It's used for php 
webhosting, cyrus mail server, mysql server.

> > Oct 14 12:20:31 vps2 kernel: [18874164.759507] XFS (dm-2): Metadata
> > corruption detected at xfs_attr3_leaf_read_verify+0x46/0xd0 [xfs], block
> > 0x24c17ba8 Oct 14 12:20:31 vps2 kernel: [18874164.764684] XFS (dm-2):
> > Unmount and run xfs_repair Oct 14 12:20:31 vps2 kernel: [18874164.766246]
> > XFS (dm-2): First 64 bytes of corrupted metadata buffer: Oct 14 12:20:31
> > vps2 kernel: [18874164.767802] ffff880115a49000: 00 00 00 00 00 00 00 00
> > fb ee 00 00 00 00 00 00  ................ Oct 14 12:20:31 vps2 kernel:
> > [18874164.770820] ffff880115a49010: 10 00 00 00 00 20 0f e0 00 00 00 00
> > 00 00 00 00  ..... .......... Oct 14 12:20:31 vps2 kernel:
> > [18874164.773848] ffff880115a49020: 00 00 00 00 00 00 00 00 00 00 00 00
> > 00 00 00 00  ................ Oct 14 12:20:31 vps2 kernel:
> > [18874164.776839] ffff880115a49030: 00 00 00 00 00 00 00 00 00 00 00 00
> > 00 00 00 00  ................ Oct 14 12:20:31 vps2 kernel:
> > [18874164.779904] XFS (dm-2): metadata I/O error: block 0x24c17ba8
> > ("xfs_trans_read_buf_map") error 117 numblks 8
> > 
> > FS shutdown happened on Oct 13, but i don't have logs ...
> > 
> > Over night i upgraded kernel to debian kernel 3.16.36-1+deb8u1 , rebooted
> > a ran xfs_repair. It repaired some metadata (sorry, don't have logs
> > either :(
> So presumably xfs_repair found and fixed some problems. What version of
> xfs_repair is being used?
> 

It's version 3.2.1 from stable. Is it sufficient for 3.16 kernel or is it 
better to upgrade to 4.3.0 from testing or to newest version from upstream? 

We had fs shutdown on vps1 i mentioned in bottom of my first email again. 
I will run repair there too and post results.

Thanks Libor

