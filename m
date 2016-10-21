Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:20587 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933808AbcJUWUJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Oct 2016 18:20:09 -0400
Date: Sat, 22 Oct 2016 09:20:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: BUG: Metadata corruption detected at xfs_attr3_leaf_read_verify
Message-ID: <20161021222005.GU23194@dastard>
References: <5244720.RPRsZ88NJ0@libor-nb>
 <20161021175912.GB54851@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20161021175912.GB54851@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Libor =?utf-8?B?S2xlcMOhxI0=?= <libor.klepac@bcom.cz>, linux-xfs@vger.kernel.org

On Fri, Oct 21, 2016 at 01:59:13PM -0400, Brian Foster wrote:
> On Fri, Oct 21, 2016 at 07:09:06PM +0200, Libor Klepáč wrote:
> > Hello,
> > sorry for last incomplete email (if it arrives), i hit some send button by accident.
> > 
> > Last week we have started to have problems with one virtual machine running debian jessie, with kernel 3.16.7-ckt20-1+deb8u4.
> > virtualization is done on vmware 5.5 on dell r610, disks are on perc h700.
> > 
> > XFS is on data disk (/dev/mapper/vgDisk2-lvData) running cyrus, mysql, apache+php.
> > It resides on single disk LVM, without partitions.
> > #pvs
> >   PV         VG      Fmt  Attr PSize   PFree
> >   /dev/sda2  vgDisk1 lvm2 a--   15.76g    0 
> >   /dev/sdb   vgDisk2 lvm2 a--  410.00g    0
> > 
> > #lvs
> >   LV       VG      Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
> >   lvSwap   vgDisk1 -wi-ao----   1.86g                                                    
> >   lvSystem vgDisk1 -wi-ao----  13.90g                                                    
> >   lvData   vgDisk2 -wi-ao---- 410.00g
> > 
> > #grep xfs /etc/fstab 
> > /dev/mapper/vgDisk2-lvData      /mountpoint       xfs     noatime,logbufs=8       0       1
> > 
> > It was created in Debian Squeeze on kernel 2.6.32 OR Wheezy on 3.2.0.
> > 
> > 
> > There are some logs, this one repeats but doesn't cause shutdown
> > 
> > Oct 14 07:02:58 vps2 kernel: [18855093.206725] XFS (dm-2): Metadata corruption detected at xfs_attr3_leaf_read_verify+0x46/0xd0 [xfs], block 0x24c17ba8
> > Oct 14 07:02:58 vps2 kernel: [18855093.210393] XFS (dm-2): Unmount and run xfs_repair
> > Oct 14 07:02:58 vps2 kernel: [18855093.211224] XFS (dm-2): First 64 bytes of corrupted metadata buffer:
> > Oct 14 07:02:58 vps2 kernel: [18855093.212092] ffff8801853da000: 00 00 00 00 00 00 00 00 fb ee 00 00 00 00 00 00  ................
> > Oct 14 07:02:58 vps2 kernel: [18855093.213932] ffff8801853da010: 10 00 00 00 00 20 0f e0 00 00 00 00 00 00 00 00  ..... ..........
> > Oct 14 07:02:58 vps2 kernel: [18855093.215915] ffff8801853da020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > Oct 14 07:02:58 vps2 kernel: [18855093.218054] ffff8801853da030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

ffff8801853da000: 00 00 00 00 00 00 00 00 fb ee 00 00 00 00 00 00  ................
                  | forw     |  back     |magic| pad |count|usedbytes
ffff8801853da010: 10 00 00 00 00 20 0f e0 00 00 00 00 00 00 00 00  ..... ..........
	      firstused|hl|pd|base0|size0|base1|size1|base2|size2|
ffff8801853da020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
		  entry data....
ffff8801853da030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

Ok, that's a completely empty attribute leaf block. It's got no
attribute entries in it, and because the entry data is zero, it's
never had any data in it. It's failing the verifier because the
entry count in the header is zero. i.e. this sort of empty buffer
should never end up on disk.

This rings a bell, but I can't put my finger on it right now. It may
be a really old corruption that has been sitting on disk for a long
time (i.e. from whatever kernel the fs was originally created and
run on) that is only manifest now on a more recent kernel that has
better validity checking...

> > Is there some way to stop this? Maybe upgrading to kernel 4.7 from backports?
> > Is there a way to map those "block 0x12f4ca30" , "block 0x24c17ba8" to a specific file?
> > 
> 
> v3.16 is certainly kind of old. For starters though, I would suggest to
> grab the most recent xfsprogs release you can (you can even grab the
> source and run it right out of the build tree), run 'xfs_repair -n' and
> report the results.

This, please, and paste the output for us to see. If repair is not
detecting and correcting the corrupt attribute block you'll continue
to see the problem. 

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
