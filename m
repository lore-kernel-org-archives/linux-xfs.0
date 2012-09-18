Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8IKs3Bw101100 for <xfs@oss.sgi.com>; Tue, 18 Sep 2012 15:54:03 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	qi0E6d0ZsPBDdhWL for <xfs@oss.sgi.com>;
	Tue, 18 Sep 2012 13:55:12 -0700 (PDT)
Date: Wed, 19 Sep 2012 06:55:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs mount fails 'can't read superblock'
Message-ID: <20120918205508.GA31501@dastard>
References: <50583590.7060702@tbi.univie.ac.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50583590.7060702@tbi.univie.ac.at>
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
To: Richard Neuboeck <hawk@tbi.univie.ac.at>
Cc: xfs@oss.sgi.com

On Tue, Sep 18, 2012 at 10:49:20AM +0200, Richard Neuboeck wrote:
> Hi XFS gurus,
> 
> I've a XFS related problem that boggles my find and I couldn't find a
> solution yet.
> 
> I've got a virtual machine (huddle) that gets a ~66TB logical volume
> from the host handed as (virtio) block device (/dev/vdb). For ease of
> maintenance I didn't partition the device but formatted it directly with
> xfs. The system at the time of formatting was Ubuntu Lucid 64bit.

virtio configuration? (i.e. cache=none?)

> A few days ago I upgraded the virtual machine to Ubuntu LTS 'precise',
> Kernel 3.2, and got the following error while trying to mount the device:

Upgraded from what?

> root@huddle:~# mount /dev/vdb /mnt/storage
> mount: /dev/vdb: can't read superblock
> 
> dmesg shows some more info:
> root@huddle:~# dmesg | tail
> [  672.774206] end_request: I/O error, dev vdb, sector 0
> [  672.774393] XFS (vdb): SB buffer read failed
> 
> At first I thought the block device had some error and checked the
> virtual machine configuration and host system.
> 
> From the host system (Ubuntu lucid 64bit, Kernel 2.6) I can still mount
> the xfs formatted device without problems. I also ran xfs_repair -n that
> didn't show any problem.

So the filesystem is accesible via direct IO from the host. What's
the xfs_info output once it is mounted?

> I tried to hand the virual machine a different ext4 formated block
> device (also without partition and preformatted). This didn't yield any
> mount problems.
> 
> The Ubuntu 'precise' machine has an older kernel (2.6.32-42) too.
> Booting this kernel the xfs formatted block device gets mounted without
> error.

The newer kernel has a different buffer cache implementation, so
sector sized IO (such as superblocks) is cached and issued
differently.

> The curious part is that it is still possible to mount the volume under
> Kernel 3.2 without error using the loop option:
> 
> root@huddle:~# mount -v -t xfs -o loop /dev/vdb /mnt/storage/

Turns all IO into pagecache based IO, so 4k aligned. Will avoid any
sector size mismatch issues.

> Trying xfs_repair also brings up the I/O Error unless I use it with the
> -f option under Kernel 3.2.

-f can turn direct IO into buffered IO is there is a sector size
mismatch between the filesystem and the underlying storage.

> Obviously the problem is Kernel 3.2 related. I'm not sure if I'm at the
> right place in the XFS Mailinglist but thought it would make a good
> starting point since I couldn't find anything related in bugzilla or the
> web in general and the problem didn't show up using ext4 (so may not be
> a generic kernel problem).

Sounds like a sector size based problem to me - direct Io does
sector aligned and sized IO, buffered IO does page sized IO. So my
initial thought is that you've got a 512 byte sector filesystem on a
4k sector device....

> Running any kernel, blkid still identifies the device correctly as xfs
> volume:
> root@huddle:~# blkid /dev/vdb
> /dev/vdb: UUID="5adcd575-d3f2-48c3-81de-104f125b275e" TYPE="xfs"

Buffered IO, again.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
