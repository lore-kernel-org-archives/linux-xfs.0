Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBOIFu49141805 for <xfs@oss.sgi.com>; Fri, 24 Dec 2010 12:15:56 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EC36AF76005
	for <xfs@oss.sgi.com>; Fri, 24 Dec 2010 10:17:55 -0800 (PST)
Received: from mail.sandeen.net (64-131-28-21.usfamily.net [64.131.28.21]) by
	cuda.sgi.com with ESMTP id ULrDTNbdZKDaWbK4 for
	<xfs@oss.sgi.com>; Fri, 24 Dec 2010 10:17:55 -0800 (PST)
Message-ID: <4D14E3D2.4000505@sandeen.net>
Date: Fri, 24 Dec 2010 12:17:54 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfssyncd and disk spin down
References: <20101223165532.GA23813@peter.simplex.ro>
In-Reply-To: <20101223165532.GA23813@peter.simplex.ro>
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
To: Petre Rodan <petre.rodan@simplex.ro>
Cc: xfs@oss.sgi.com

On 12/23/10 10:55 AM, Petre Rodan wrote:
> 
> Hello,
> 
> I have a problem with a hard drive that never managed to spin down.
> this drive is a storage space, not a system disk, the only thing that
> generated writes is the nfs server that exports its contents. it has
> only one large xfs partition on it.
> 
> upon closer inspection it turns out that after the first Write action
> to that partition, an xfssyncd process continues to write to that
> partition each 36 seconds and it doesn't stop doing that, even if
> there are no more Writes from the exterior. this keeps the drive busy
> with varying consequences. more about that later.

Doesn't seem like that should happen.

> I found that the only easy way to stop the xfssyncd process poking
> the drive is to run a `mount -o remount /mnt/space`. this will
> silence any internal xfs process to acessing the drive, thus allowing
> it to spin down and only be woken up by a NFS access.
> 
> here are some simple steps to replicate the problem:
> 
> # echo 3 > /proc/sys/vm/drop_caches # free cached fs entities 
> # ( blktrace -d /dev/sdb -o - | blkparse -i - ) &
> # mount -o remount /mnt/space
> # find /mnt/space/ -type f > /dev/null  # generate some non-cached Read requests
> # # absolutely no writes have been performed to the drive, 
> # # it could spin down now if enough time would pass
> # touch /mnt/space/foo
> # # process 1352 will start writing to the drive at a 35-36s interval,
> # # even if there has been no other write request.
> 
>   8,16   1    36591  6306.873151576  1352  A WBS 976985862 + 2 <- (8,17) 976985799
>   8,16   1    36592  6306.873152998  1352  Q WBS 976985862 + 2 [xfssyncd/sdb1]
> [..]
>   8,16   1    36600  6342.875151286  1352  A WBS 976985864 + 2 <- (8,17) 976985801
>   8,16   1    36601  6342.875152938  1352  Q WBS 976985864 + 2 [xfssyncd/sdb1]
> [..]
>   8,16   1    36609  6378.877225211  1352  A WBS 976985866 + 2 <- (8,17) 976985803
>   8,16   1    36610  6378.877226935  1352  Q WBS 976985866 + 2 [xfssyncd/sdb1]
> 
> there was no file at or near the 976985799 inode (I presume that's an
> inode?)

Nope that's a sector on the drive.

> A WBS 976985862 + 2 <- (8,17) 976985799

976985799 is the sector on sdb1, mapped to 976985862 on sdb
(63 sectors in, yay dos partition tables!)

A means remapped (from sdb1 to sdb), Q means Queued.

WBS means Write/Barrier/Synchronous.

Also, you're stepping through, it looks like -
976985799, 976985801, 976985803, ....

> I found that the only way to stop it is to remount the partition. I
> also tried sync(1), but to no avail.
> 
> so is there an XFS option somewhere that would make the filesystem be
> more forgiving with the hardware beneath it? without loosing the
> journal of course.

I think we just need to figure out what's causing the writes, and
what's being written.
 
> I'm using a vanilla 2.6.36.2 kernel patched with grsecurity, default
> mkfs.xfs options, rw,nosuid,nodev,noexec,noatime,attr2,noquota mount
> options, and xfs_info looks like this:> 
> meta-data=/dev/sdb1              isize=256    agcount=4, agsize=61047500 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=244190000, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=32768, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=0
> realtime =none                   extsz=4096   blocks=0, rtextents=0

so what is sector 976985799 on the filesystem...

An AG is 61047500 blocks long, or 488380000 sectors long.  There are 4 of them,
and the log is at the front of an AG in the middle of the fs.

So the 1st AG starts at 0, 2nd at 488380000 sectors, 3rd at 976760000 sectors.

Your writes are at 976985799-ish sectors, or 225799 sectors into the
3rd AG.  The log is 262144 sectors long.  So this looks like log writes.
Makes sense with the WBS data too.

xfssyncd forces the log, reclaims inodes, and logs a dummy transaction if needed.

On an idle fs though I wouldn't expect that we need any of this, so probably
need to dig a little to see what's going on.  I don't think you need a mount
option, I think we need an explanation and maybe a bugfix.  :)

I'll try to find time to look into it unless someone else knows what's going
on off the top of their heads.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
