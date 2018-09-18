Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:14588 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728681AbeIRSFE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Sep 2018 14:05:04 -0400
Date: Tue, 18 Sep 2018 22:32:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: dm-writecache issue
Message-ID: <20180918123238.GI27618@dastard>
References: <20180911221147.GA23308@redhat.com>
 <alpine.LRH.2.02.1809180741001.6599@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1809180741001.6599@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, David Teigland <teigland@redhat.com>

On Tue, Sep 18, 2018 at 07:46:47AM -0400, Mikulas Patocka wrote:
> I would ask the XFS developers about this - why does mkfs.xfs select 
> sector size 512 by default?

Because the underlying device told it that it supported a
sector size of 512 bytes?

> If a filesystem created with the default 512-byte sector size is activated 
> on a device with 4k sectors, it results in mount failure.

Yes, it does, but mkfs should also fail when it tries to write 512
byte sectors to a 4k device, too.

> On Tue, 11 Sep 2018, David Teigland wrote:
> 
> > Hi Mikulas,
> > 
> > Am I doing something wrong below or is there a bug somewhere?  (I could be
> > doing something wrong in the lvm activation code, also.)
> > Thanks
> > 
> > 
> > [root@null-05 ~]# lvs foo
> >   LV   VG  Attr       LSize   
> >   fast foo -wi-------  32.00m
> >   main foo -wi------- 200.00m
> > 
> > [root@null-05 ~]# lvchange -ay foo/main
> > 
> > [root@null-05 ~]# mkfs.xfs /dev/foo/main
> > meta-data=/dev/foo/main          isize=512    agcount=4, agsize=12800 blks
> >          =                       sectsz=512   attr=2, projid32bit=1
> >          =                       crc=1        finobt=0, sparse=0
> > data     =                       bsize=4096   blocks=51200, imaxpct=25
> >          =                       sunit=0      swidth=0 blks
> > naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> > log      =internal log           bsize=4096   blocks=855, version=2
> >          =                       sectsz=512   sunit=0 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > 
> > [root@null-05 ~]# mount /dev/foo/main /mnt
> > [root@null-05 ~]# cp /root/pattern* /mnt/
> > [root@null-05 ~]# umount /mnt
> > [root@null-05 ~]# lvchange -an foo/main
> > 
> > [root@null-05 ~]# lvconvert --type writecache --cachepool fast foo/main
> >   Logical volume foo/main now has write cache.
> > 
> > [root@null-05 ~]# lvs -a foo -o+devices
> >   LV            VG  Attr       LSize   Origin        Devices       
> >   [fast]        foo -wi-------  32.00m               /dev/pmem0(0) 
> >   main          foo Cwi------- 200.00m [main_wcorig] main_wcorig(0)
> >   [main_wcorig] foo -wi------- 200.00m               /dev/loop0(0) 

Yeehaw!

I'm betting that the underlying device advertised a logical/physical
sector size of 512 bytes to mkfs, and then adding pmem as the cache
device changed the logical volume from a 512 byte sector device to a
hard 4k sector device.

If so, this is a dm-cache bug. Filesystems don't support changing
the logical/physical sector sizes of the block device dynamically.
Filesystems lay out the filesystem structure at mkfs time based on
the assumption that the sector size of the block device is fixed and
will never change for the life of that filesystem.

Indeed, if the sector size of the block device is not fixed and can
change dynamically, then the block device also violates the
assumptions that the filesystem journalling algorithms make about
the atomic write size of the underlying device....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
