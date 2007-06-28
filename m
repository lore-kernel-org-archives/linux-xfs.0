Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 02:26:44 -0700 (PDT)
Received: from z2.cat.iki.fi (z2.cat.iki.fi [212.16.98.133])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5S9QbtL027922
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 02:26:38 -0700
Received: (mea@mea-ext) by mail.zmailer.org id S3541649AbXF1JFv (ORCPT
	<rfc822;xfs@oss.sgi.com>); Thu, 28 Jun 2007 12:05:51 +0300
Date: Thu, 28 Jun 2007 12:05:51 +0300
From: Matti Aarnio <matti.aarnio@zmailer.org>
Subject: Re: Fastest Chunk Size w/XFS For MD Software RAID = 1024k
Message-ID: <20070628090551.GG4504@mea-ext.zmailer.org>
References: <Pine.LNX.4.64.0706271918010.29111@p34.internal.lan> <46832E60.9000006@rabbit.us> <Pine.LNX.4.64.0706280406520.1406@p34.internal.lan> <46837056.4050306@rabbit.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46837056.4050306@rabbit.us>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Rabbitson <rabbit@rabbit.us>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>

On Thu, Jun 28, 2007 at 10:24:54AM +0200, Peter Rabbitson wrote:
> Interesting, I came up with the same results (1M chunk being superior) 
> with a completely different raid set with XFS on top:
> 
> mdadm	--create \
> 	--level=10 \
> 	--chunk=1024 \
> 	--raid-devices=4 \
> 	--layout=f3 \
> 	...
> 
> Could it be attributed to XFS itself?

Sort of..

 /dev/md4:
         Version : 00.90.03
      Raid Level : raid5
    Raid Devices : 4
   Total Devices : 4
 Preferred Minor : 4
 
  Active Devices : 4
 Working Devices : 4

          Layout : left-symmetric
      Chunk Size : 256K

This means there are 3x 256k for the user data..
Now I had to carefully tune the XFS  bsize/sunit/swidth  to match that:

 meta-data=/dev/DataDisk/lvol0    isize=256    agcount=32, agsize=7325824 blks
          =                       sectsz=512   attr=1
 data     =                       bsize=4096   blocks=234426368, imaxpct=25
          =                       sunit=64     swidth=192 blks, unwritten=1
 ...

That is, 4k * 64 = 256k,   and   64 * 3 = 192
With that, bulk writing on the file system runs without need to
read back blocks of disk-space to calculate RAID5 parity data because
the filesystem's idea of block does not align with RAID5 surface.

I do have LVM in between the MD-RAID5 and XFS, so I did also align
the LVM to that  3 * 256k.

Doing this alignment thing did boost write performance by nearly
a factor of 2 from mkfs.xfs with default parameters.


With very wide RAID5, like the original question...  I would find it
very surprising if the alignment of upper layers to MD-RAID level
would not be important there as well.

Very small continuous writing does not make good use of disk mechanism,
(seek time, rotation delay), so something in order of 128k-1024k will
speed things up -- presuming that when you are writing, you are doing
it many MB at the time.  Database transactions are a lot smaller, and
are indeed harmed by such large megachunk-IO oriented surfaces.

RAID-levels 0 and 1 (and 10)  do not have the need of reading back parts
of the surface because a subset of it was not altered by incoming write.

Some DB application on top of the filesystem would benefit if we had
a way for it to ask about these alignment boundary issues, so it could
read whole alignment block even though it writes out only a subset of it.
(Theory being that those same blocks would also exist in memory cache
and thus be available for write-back parity calculation.)


> Peter

/Matti Aarnio
