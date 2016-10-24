Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:53249 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932125AbcJXCk2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Oct 2016 22:40:28 -0400
Date: Mon, 24 Oct 2016 13:40:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: BUG: Metadata corruption detected at xfs_attr3_leaf_read_verify
Message-ID: <20161024024024.GX14023@dastard>
References: <5244720.RPRsZ88NJ0@libor-nb>
 <20161021175912.GB54851@bfoster.bfoster>
 <3822835.q6ryES8eE3@libor-nb>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3822835.q6ryES8eE3@libor-nb>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Libor =?utf-8?B?S2xlcMOhxI0=?= <libor.klepac@bcom.cz>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Sun, Oct 23, 2016 at 08:48:06AM +0200, Libor Klepáč wrote:
> > On Fri, Oct 21, 2016 at 07:09:06PM +0200, Libor Klep�? wrote:
> > > Hello,
> > > Then shutdown occured on different block 0x12f63f40
> > > Oct 14 12:00:24 vps2 kernel: [18872956.205316] XFS (dm-2): Metadata
> > > corruption detected at xfs_attr3_leaf_write_verify+0xd5/0xe0 [xfs], block
> > > 0x12f63f40 Oct 14 12:00:24 vps2 kernel: [18872956.208382] XFS (dm-2):
> > > Unmount and run xfs_repair Oct 14 12:00:24 vps2 kernel: [18872956.209385]
> > > XFS (dm-2): First 64 bytes of corrupted metadata buffer: Oct 14 12:00:24
> > > vps2 kernel: [18872956.210187] ffff88011dadd000: 00 00 00 00 00 00 00 00
> > > fb ee 00 00 00 00 00 00  ................ Oct 14 12:00:24 vps2 kernel:
> > > [18872956.211816] ffff88011dadd010: 10 00 00 00 00 20 0f e0 00 00 00 00
> > > 00 00 00 00  ..... .......... Oct 14 12:00:24 vps2 kernel:
> > > [18872956.213390] ffff88011dadd020: 00 00 00 00 00 00 00 00 00 00 00 00
> > > 00 00 00 00  ................ Oct 14 12:00:24 vps2 kernel:
> > > [18872956.214983] ffff88011dadd030: 00 00 00 00 00 00 00 00 00 00 00 00
> > > 00 00 00 00  ................ Oct 14 12:00:24 vps2 kernel:
> > > [18872956.216598] XFS (dm-2): xfs_do_force_shutdown(0x8) called from line
> > > 1330 of file /build/linux-U7H2aZ/linux-3.16.7-ckt20/fs/xfs/xfs_buf.c. 
> > > Return address = 0xffffffffa03ef820 Oct 14 12:00:24 vps2 kernel:
> > > [18872956.217448] XFS (dm-2): Corruption of in-memory data detected. 
> > > Shutting down filesystem Oct 14 12:00:24 vps2 kernel: [18872956.218338]
> > > XFS (dm-2): Please umount the filesystem and rectify the problem(s)
> > The shutdown has more to do with whether the corruption is detected on
> > read vs. write. E.g., we shutdown on write verifier failure to avoid
> > writing corrupted data to disk and causing further damage.
> > 
> > I suppose in this particular instance we don't really know whether the
> > corruption existed on disk or originated in memory. Regardless, the
> > corruption appears to be consistently associated with extended attribute
> > blocks. Are you running an application that makes heavy use of xattrs?
> > 
> 
> Hello,
> i think that xattrs are not used at all or rarely. It's used for php 
> webhosting, cyrus mail server, mysql server.

selinux, acls or some other security system enabled that uses
xattrs?

> > So presumably xfs_repair found and fixed some problems. What version of
> > xfs_repair is being used?
> 
> It's version 3.2.1 from stable. Is it sufficient for 3.16 kernel or is it 
> better to upgrade to 4.3.0 from testing or to newest version from upstream? 

The newer the better. 3.2.1 is really quite old now, and we've fixed
a lot of bugs in xfs_repair since then....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
