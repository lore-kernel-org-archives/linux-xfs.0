Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4E0Hbhw182433 for <xfs@oss.sgi.com>; Wed, 13 May 2009 19:17:37 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F00241D30C01
	for <xfs@oss.sgi.com>; Wed, 13 May 2009 17:17:43 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 6P9cg04xdKuDKAUZ for
	<xfs@oss.sgi.com>; Wed, 13 May 2009 17:17:43 -0700 (PDT)
Message-ID: <4A0B6325.8000706@sandeen.net>
Date: Wed, 13 May 2009 19:17:41 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: file preallocation without unwritten flag being set
References: <283244.29270.qm@web65608.mail.ac4.yahoo.com>	<4A0A0E76.6000701@sandeen.net>	<618437.93111.qm@web65601.mail.ac4.yahoo.com>	<4A0A55E0.4010202@sandeen.net>	<705795.15734.qm@web65604.mail.ac4.yahoo.com>	<20090513222823.GL16929@discord.disaster>
	<502709.63746.qm@web65615.mail.ac4.yahoo.com>
In-Reply-To: <502709.63746.qm@web65615.mail.ac4.yahoo.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: p v <pvlogin@yahoo.com>
Cc: xfs@oss.sgi.com

p v wrote:
> 
> I did it on a fresh filesystem (of course). It didn't make a
> difference - sb flags cleared, extent flags set, xfs_repair unhappy.

Strange, I don't see that when I test.

# dd if=/dev/urandom of=fsfile bs=1M count=64
# mkfs.xfs /dev/loop0
# for I in `seq 0 3`; do xfs_db -x /dev/loop0 -c "sb $I" -c "write
versionnum 0xa4a4"; done
# mount /dev/loop0 mnt/
# xfs_io -f -c "truncate 1m" -c "resvsp 0 1m" mnt/file
# hexdump -C mnt/file | more
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
|................|
*
00014000  09 d6 99 0d a7 43 a2 c9  95 ca 88 f6 4a 0c 93 8e
|.....C......J...|
00014010  ab b5 1a 1f c2 f3 2f 39  30 cc 8f 67 04 65 dd f1
|....../90..g.e..|
<morejunk>
# xfs_repair /dev/loop0
# xfs_db -c "version" /dev/loop0
versionnum [0xa4a4+0x8] = V4,NLINK,ALIGN,DIRV2,LOGV2,MOREBITS,ATTR2


> I tried to repro again and do cut/paste of my steps but I lost the
> machine. The only difference this time was that I was going to do it
> with the default mkfs and mount options. I created the fs, cleared
> extflg from the superblocks and run xfs_io to resvsp the space. Then
> I run truncate and truncate decided to initialize the extents to zero
> and since it's 10TB it's going to take a while (can't reset as it's a
> remote machine and xfs_io is looping in the kernel ...). It didn't do
> it before and if I remember right the only differences were mkfs with
> 2048 size inodes and mount options with
> noatime,nodiratime,inode64,allocsize=1g. Anyway - I'll try it again
> on a different machine and send the steps. However the fact that it
> did try to zero the reserved space tells me that the extent flags
> were not set this time - and unfortunatelly it also means that it
> won't work - unless I do the previous workaround and instead of
> calling truncate from xfs_io I'll do the xfs_db and set the inode
> size directly - in fact now I remember that was exactly the reason
> why the original steps were so tricky - truncate up would zero
> extents but xfs_db will set the inode size to whatever without any
> problem.

try truncate then resvsp; TBH not sure why it should matter though :)

> Thanks for the info regarding the max extent size.
> 
> The man pages I am looking at (FC4, Centos5) don't have the xfs
> options like allocsize, inode64. Probably should download the latest
> versions ...

those man pages are pretty old, yup.

> I am a little bit lost about the comment regarding the page caches. I
> unmounted the filesystem before running xfs_db. Shouldn't that flush
> pages, buffers, ...? I assume that xfs_db goes directly to the device
> so if the fs was unmounted then the device should be up to date?

The device is uptodate but the bdev address space may not be.

Unmounting will flush the filesytem address space, but not the block
device address space.

So yes unmount pushes everything to the disk, but the bdev address space
still has other cached data.

echo 3 > /proc/sys/vm/drop_caches

will force you to reread from disk.  (xfs_db uses buffered IO AFAIK)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
