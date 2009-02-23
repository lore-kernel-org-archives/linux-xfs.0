Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1NKrgsL109893 for <xfs@oss.sgi.com>; Mon, 23 Feb 2009 14:53:43 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 22CBF142FDD
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2009 12:53:11 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id FmpP5iKIbE1islHI for <xfs@oss.sgi.com>;
	Mon, 23 Feb 2009 12:53:11 -0800 (PST)
Message-ID: <49A30CB3.4040100@sandeen.net>
Date: Mon, 23 Feb 2009 14:53:07 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS on ARM-based Linux on USR8700 NAS appliance w/ mdadm/RAID5
References: <200902231243.33897.harry.mangalam@uci.edu>
In-Reply-To: <200902231243.33897.harry.mangalam@uci.edu>
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
To: Harry Mangalam <harry.mangalam@uci.edu>
Cc: xfs@oss.sgi.com

Harry Mangalam wrote:
> Here's an unusual (long) tale of woe.
> 
> We had a USRobotics 8700 NAS appliance with 4 SATA disks in RAID5:
>  <http://www.usr.com/support/product-template.asp?prod=8700>
> which was a fine (if crude) ARM-based Linux NAS until it stroked out 
> at some point, leaving us with a degraded RAID5 and comatose NAS 
> device.
> 
> We'd like to get the files back of course and I've moved the disks to 
> a Linux PC, hooked them up to a cheap Silicon Image 4x SATA 
> controller and brought up the whole frankenmess with mdadm.  It 
> reported a clean but degraded array.
> 
> (much mdadm stuff deleted)
> 
> Shortening this up considerably, I was able to get the RAID5 
> reconstituted with a new disk, but was not so fortunate with the 
> filesystem.
> 
> The docs and files on the USR web site imply that the native 
> filesystem was originally XFS, but when I try to mount it as such, I 
> can't:

...snip...

> and when I check dmesg:
> [  245.008000] SGI XFS with ACLs, security attributes, realtime, large 
> block numbers, no debug enabled
> [  245.020000] SGI XFS Quota Management subsystem
> [  245.020000] XFS: SB read failed
> [  327.696000] md: md0 stopped.
> [  327.696000] md: unbind<sdc1>
> [  327.696000] md: export_rdev(sdc1)
> [  327.696000] md: unbind<sde1>
> [  327.696000] md: export_rdev(sde1)
> [  327.696000] md: unbind<sdd1>
> [  327.696000] md: export_rdev(sdd1)
> [  439.660000] XFS: bad magic number
> [  439.660000] XFS: SB validate failed
> 
> repeated attempts repeat the last 2 lines above.  This implies that 
> the superblock is bad and xfs_repair also reports that:
> xfs_repair /dev/md1
>         - creating 2 worker thread(s)
> Phase 1 - find and verify superblock...
> bad primary superblock - bad magic number !!!

The main badness that I know of on some of the ARM NAS implementations
is a change which was made due to differing alignment on the old arm
ABI; the change that went into some vendor trees actually modified the
on-disk format rather than fixing it up properly.  (This should be fixed
upstream now).  There are other odd problems w/ cache aliasing too.

However this wouldn't cause a superblock mis-read like this.  If you get
it mounted, you *may* run into what looks like directory corruption on
the PC, though, due to the alignment issue.

Anyway, first, I'd look around for "XFSB" in the early few blocks of
your raid and see if the raid might possibly have been rebuilt out of order.

# dd if=/dev/md0 bs=4k count=32 | hexdump -C | grep XFSB

or so...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
