Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.webx.cz ([109.123.222.201]:54742 "EHLO mail.webx.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932299AbcJYGwo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Oct 2016 02:52:44 -0400
From: Libor =?utf-8?B?S2xlcMOhxI0=?= <libor.klepac@bcom.cz>
Subject: Re: BUG: Metadata corruption detected at xfs_attr3_leaf_read_verify
Date: Tue, 25 Oct 2016 08:52:39 +0200
Message-ID: <1681488.KqzT1rtqcH@libor-nb>
In-Reply-To: <20161024024024.GX14023@dastard>
References: <5244720.RPRsZ88NJ0@libor-nb> <3822835.q6ryES8eE3@libor-nb> <20161024024024.GX14023@dastard>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

Hello,
sorry for delay, Microsoft marks those emails as spam ...

On pondělí 24. října 2016 13:40:25 CEST Dave Chinner wrote:
> On Sun, Oct 23, 2016 at 08:48:06AM +0200, Libor Klep�? wrote:
> > > On Fri, Oct 21, 2016 at 07:09:06PM +0200, Libor Klep?? wrote:
> > > > Hello,
> > > > Then shutdown occured on different block 0x12f63f40
> > > > Oct 14 12:00:24 vps2 kernel: [18872956.205316] XFS (dm-2): Metadata
> > > > corruption detected at xfs_attr3_leaf_write_verify+0xd5/0xe0 [xfs],
> > > > block
> > > > 0x12f63f40 Oct 14 12:00:24 vps2 kernel: [18872956.208382] XFS (dm-2):
> > > > Unmount and run xfs_repair Oct 14 12:00:24 vps2 kernel:
> > > > [18872956.209385]
> > > > XFS (dm-2): First 64 bytes of corrupted metadata buffer: Oct 14
> > > > 12:00:24
> > > > vps2 kernel: [18872956.210187] ffff88011dadd000: 00 00 00 00 00 00 00
> > > > 00
> > > > fb ee 00 00 00 00 00 00  ................ Oct 14 12:00:24 vps2 kernel:
> > > > [18872956.211816] ffff88011dadd010: 10 00 00 00 00 20 0f e0 00 00 00
> > > > 00
> > > > 00 00 00 00  ..... .......... Oct 14 12:00:24 vps2 kernel:
> > > > [18872956.213390] ffff88011dadd020: 00 00 00 00 00 00 00 00 00 00 00
> > > > 00
> > > > 00 00 00 00  ................ Oct 14 12:00:24 vps2 kernel:
> > > > [18872956.214983] ffff88011dadd030: 00 00 00 00 00 00 00 00 00 00 00
> > > > 00
> > > > 00 00 00 00  ................ Oct 14 12:00:24 vps2 kernel:
> > > > [18872956.216598] XFS (dm-2): xfs_do_force_shutdown(0x8) called from
> > > > line
> > > > 1330 of file /build/linux-U7H2aZ/linux-3.16.7-ckt20/fs/xfs/xfs_buf.c.
> > > > Return address = 0xffffffffa03ef820 Oct 14 12:00:24 vps2 kernel:
> > > > [18872956.217448] XFS (dm-2): Corruption of in-memory data detected.
> > > > Shutting down filesystem Oct 14 12:00:24 vps2 kernel:
> > > > [18872956.218338]
> > > > XFS (dm-2): Please umount the filesystem and rectify the problem(s)
> > > 
> > > The shutdown has more to do with whether the corruption is detected on
> > > read vs. write. E.g., we shutdown on write verifier failure to avoid
> > > writing corrupted data to disk and causing further damage.
> > > 
> > > I suppose in this particular instance we don't really know whether the
> > > corruption existed on disk or originated in memory. Regardless, the
> > > corruption appears to be consistently associated with extended attribute
> > > blocks. Are you running an application that makes heavy use of xattrs?
> > 
> > Hello,
> > i think that xattrs are not used at all or rarely. It's used for php
> > webhosting, cyrus mail server, mysql server.
> 
> selinux, acls or some other security system enabled that uses
> xattrs?

No selinux, but we started to use ACL recently (files are owned by separate 
users who run php-fpm, but everything is made readable to user www-data, using 
acls) - backuppc says, full backup of server has around 4 million files, most 
of them are probably with acls.

> 
> > > So presumably xfs_repair found and fixed some problems. What version of
> > > xfs_repair is being used?
> > 
> > It's version 3.2.1 from stable. Is it sufficient for 3.16 kernel or is it
> > better to upgrade to 4.3.0 from testing or to newest version from
> > upstream?
> 
> The newer the better. 3.2.1 is really quite old now, and we've fixed
> a lot of bugs in xfs_repair since then....
> 

Ok, i will upgrade and report back. I have to coordinate with customer, 
because xfs_repair runs about 35 minutes on this filesystem.

Thanks,
Libor

> Cheers,
> 
> Dave.

