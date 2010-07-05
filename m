Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o65MrMjX144468 for <xfs@oss.sgi.com>; Mon, 5 Jul 2010 17:53:22 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B10E4B7AB72
	for <xfs@oss.sgi.com>; Mon,  5 Jul 2010 16:01:33 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	LcBlWA9K7IH7O4Uu for <xfs@oss.sgi.com>;
	Mon, 05 Jul 2010 16:01:33 -0700 (PDT)
Date: Tue, 6 Jul 2010 08:56:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Volume Group and XFS Partition Recovery
Message-ID: <20100705225602.GA24712@dastard>
References: <AANLkTilPPMnasFD5b4_kgsF9uUZsjCtTMKaGmO4L7a3j@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTilPPMnasFD5b4_kgsF9uUZsjCtTMKaGmO4L7a3j@mail.gmail.com>
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
To: Andrew Ragone <ajr9166@rit.edu>
Cc: xfs@oss.sgi.com

On Sat, Jul 03, 2010 at 01:26:18PM -0400, Andrew Ragone wrote:
> Hey everyone:
> 
> I hope everyone's summers have been exciting so far. The other day mine had
> a little hiccup thrown in there that I was hoping some of the bright members
> of this group could shed some light on. Rundown of the problem is as
> follows:
> 
> Alright so I have an XFS partition inside of a volume group on my server.
> It's been configured as such for awhile and is functional. Regardless, I
> recently added some drives and expanded the raid on my 3ware card
> successfully from 14 TB to 20TB.

First question is: what kernel version?

> Of course the next step is to expand the
> partition and then the file system. (The partition lives in a Volume Group
> in a Logical Volume). I have done this entire process once before
> successfully without data loss when expanding from 10TB to 14TB but for some
> reason it all blew up in my face this time.

OK, so growing within 16TB was fine, but growing past 16TB blew up.
There's several possibilities there.

> Commands used were similar to
> this:
> 
> umount -a (unmount all partitions)
> 
>       vgchange -an (disable all volume groups)
>       partprobe (reread partition tables on all disks)
>       parted /dev/sda resize 1 0.017 267466 (resize the partition)
>       partprobe (reread partition tables on all disks)
>       pvresize /dev/<disk_partition> (resize the physical volume << seems to
> be about the point this went awry)
>       vgchange -ay (enable all volume groups)
>       mount -a (remount all disk partitions)
> 
> Basically I've got things in this strange state where the partition
> /dev/sda1 (being based off the logical block device for the raid) looks like
> it has successfully expanded from End Cylinder 1945212 (previous config) to
> 267466 (using all 20 TB) but can't be mounted.

How does decreasing the end cylinder from 1945212 to 267466 increase
the partition size? What does /proc/partitions tell you about the
partition sizes?

> It actually seems to have
> initially disappeared from the volume group listing (correct me if this
> terminology is wrong): initially the block device was mapped to
> /dev/oasis/puddle yet /dev/oasis is now empty. So to "recapture" the
> partition I tried to all a new v
>   olume group now called vol0x that should house the /dev/sda1 physical
> volume. Of course in /dev/oasis I show only /dev/oasis/vol0x and not
> /dev/oasis/puddle

Ok, so you have some LVM problem you need to sort out before even
looking at XFS. I can't really help you much there.

> On this, my question is* can I reconfigure volume groups and logical volumes
> on the fly in order to "recapture" the actual partition without affecting
> the data?* If I am correct, the data is only a simple mapping in the GPT
> table on the first sector of the drive.

If changing the LVM configuration involves writing to the drives,
then I'd say the answer is no.

> Further, the actual volume group that houses the XFS file system now exists
> as "lvm2pv" which I'm fairly certain needs to be "xfs". Should this be the
> case?

Sounds like you need to recover the LV information before worrying
about the filesystem...

> I've shut down the machine so no data is accessed, attempted to be accessed,
> etc. until I can get some ideas on recovery approach.
> 
>    - Basically, can anyone provide some insight on what order LVs, PVs, and
>    VGs need to be configured to work properly?

You'd do better asking this on the LVM lists.

>    - What are some approaches to attempt to grab this data back?

Recover you LVM configuration first before worrying about the
filesystem. Once you've got the LV back without damaging anything
else, then worry about the filesystem.

>       - Is anyone familiar with what xfs_repair does and how I might be able
>       to apply it here?

Only run it in no-modify mode (xfs_repair -n) until you are certain
everything is reconstructed correctly. If the lvm information is
reconstructed correctly then repair should most likely run without errors.

>       - Worse case scenario: having software such as TestDisk remap the file
>       info, though I've read XFS is a huge pain in filesystem world to
> do this on.

I've never used such software - you're on your own with that one.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
