Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AD7857CA4
	for <xfs@oss.sgi.com>; Sun,  8 May 2016 15:51:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 26C2BAC001
	for <xfs@oss.sgi.com>; Sun,  8 May 2016 13:51:45 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	c7ZFNmdUvJLsvRdH for <xfs@oss.sgi.com>;
	Sun, 08 May 2016 13:51:39 -0700 (PDT)
Date: Mon, 9 May 2016 06:51:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Unable to mount a XFS filesystem
Message-ID: <20160508205134.GH26977@dastard>
References: <30479c32-e298-c64b-1964-f9c9824bfe7a@usa.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <30479c32-e298-c64b-1964-f9c9824bfe7a@usa.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Issa Gorissen <issa-gorissen@usa.net>
Cc: xfs@oss.sgi.com

On Sun, May 08, 2016 at 04:12:59PM +0200, Issa Gorissen wrote:
> Hello,
> 
> After I have upgraded my htpc from openSuse 12.3 running kernel
> 3.7.10 to openSuse Tumbleweed running kernel 4.5.2; I am unable to
> mount my XFS filesystem anymore.
....
>  Avail Dev Size : 5860529896 (2794.52 GiB 3000.59 GB)
>      Array Size : 2930264896 (2794.52 GiB 3000.59 GB)
>   Used Dev Size : 5860529792 (2794.52 GiB 3000.59 GB)
>    Super Offset : 5860530160 sectors
>    Unused Space : before=0 sectors, after=344 sectors

Both devices are reporting 344 unused sectors. Which may be
important, because....

.....
> tv:/ # xfs_db /dev/md0
> xfs_db: error - read only 0 of 512 bytes

... something is wrong with the RAID device for this error to be
emitted. XFS checks to see if it can access the last sector of the
filesystem before it starts using it, and this is indicative of a
that read being beyond the end of the device.

> tv:/ # mount -t xfs /dev/md0 /data
> mount: /dev/md0: can't read superblock
> 
> dmesg outputs
> 
> 
> [ 5525.861750] SGI XFS with ACLs, security attributes, realtime, no
> debug enabled
> [ 5525.862231] attempt to access beyond end of device
> [ 5525.862232] md0: rw=32, want=5860529904, limit=5860529792
> [ 5525.862234] XFS (md0): last sector read failed

Yup, the kernel also emits the same error on the same check - most
likely during your upgrade the MD RAID device has changed size and
is now 112 sectors smaller than before, hence the filesystem will
refuse to mount.

> Any pointers to fix this ? It seems the disks still contains a XFS
> filesystem but for some reason, I cannot access it.

Unlikely to be an XFS problem, more likely a MD device/upgrade issue.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
