Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42668 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727228AbeIRTxo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Sep 2018 15:53:44 -0400
Date: Tue, 18 Sep 2018 09:20:53 -0500
From: David Teigland <teigland@redhat.com>
Subject: Re: dm-writecache issue
Message-ID: <20180918142053.GA26193@redhat.com>
References: <20180911221147.GA23308@redhat.com>
 <alpine.LRH.2.02.1809180741001.6599@file01.intranet.prod.int.rdu2.redhat.com>
 <20180918123238.GI27618@dastard>
 <817349b8-b54e-a16a-276f-7a977f29b449@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <817349b8-b54e-a16a-276f-7a977f29b449@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Chinner <david@fromorbit.com>, Mikulas Patocka <mpatocka@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Tue, Sep 18, 2018 at 07:48:04AM -0500, Eric Sandeen wrote:
> Not only that, but it must have told us that it had a /physical/ 512 sector.
> If it had even said physical/logical 4096/512, we would have chosen 4096.

Right, just after asking I discovered that the advertised
physical_block_size changes after attaching dm-writecache:

Before:

# dmsetup ls
foo-main        (253:3)
foo-fast        (253:4)

# cat /sys/block/dm-3/queue/physical_block_size 
512
# cat /sys/block/dm-4/queue/physical_block_size 
4096

After:

# dmsetup ls
foo-main_wcorig (253:4)
foo-main        (253:5)
foo-fast        (253:3)

# cat /sys/block/dm-3/queue/physical_block_size 
4096
# cat /sys/block/dm-5/queue/physical_block_size 
4096


> What does please check blockdev --getpbsz --getss /dev/$FOO say at mkfs time?

Before:

# blockdev --getpbsz --getss /dev/foo/main
512
512

After:

# blockdev --getpbsz --getss /dev/foo/main
4096
4096


> > Yes, it does, but mkfs should also fail when it tries to write 512
> > byte sectors to a 4k device, too.

By default it uses the 4k sectors in that case:

# mkfs.xfs -f /dev/foo/main
meta-data=/dev/foo/main          isize=512    agcount=4, agsize=13056 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=0, sparse=0
data     =                       bsize=4096   blocks=52224, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=1605, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


But you are correct if I request 512 on a 4k device:

# mkfs.xfs -f -s size=512 /dev/foo/main
illegal sector size 512; hw sector is 4096

> > I'm betting that the underlying device advertised a logical/physical
> > sector size of 512 bytes to mkfs, and then adding pmem as the cache
> > device changed the logical volume from a 512 byte sector device to a
> > hard 4k sector device.

Yes

I've been dealing with this by just using -s size=4096.
