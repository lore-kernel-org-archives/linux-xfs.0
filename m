Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 435637F37
	for <xfs@oss.sgi.com>; Wed,  6 May 2015 14:48:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 22C01304053
	for <xfs@oss.sgi.com>; Wed,  6 May 2015 12:48:11 -0700 (PDT)
Received: from smtp4out.l-3com.com (smtp4out.l-3com.com [128.170.207.112]) by
	cuda.sgi.com with ESMTP id DxRTVcD4BEqTV3kE for
	<xfs@oss.sgi.com>; Wed, 06 May 2015 12:48:08 -0700 (PDT)
From: "Scott, Edmund J @ SSG - Link" <edmund.scott@l-3com.com>
Subject: RE: SGI Version 1 XFS on Linux
Date: Wed, 6 May 2015 19:47:51 +0000
Message-ID: <2994A55DE0FBBE41B8FE47F9885D74221BC056F3@ARLEXCHMBX02.lst.link.l-3com.com>
References: <2994A55DE0FBBE41B8FE47F9885D74221BC0569C@ARLEXCHMBX02.lst.link.l-3com.com>
	<20150506171222.GA22744@sgi.com>
In-Reply-To: <20150506171222.GA22744@sgi.com>
Content-Language: en-US
MIME-Version: 1.0
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
To: Ben Myers <bpm@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi,

We are in a thunderstorm right now so we had to shut down, be a while until we get things back up. We're in Utah with a rolling t-storm coming through. 

We did find documentation that XFS version 1 was pulled out of the linux kernel around or after kernel 2.4. and the messages kind of support that. I'm looking into digging up an old Red Hat OS to see if it is old enough to have the version 1 XFS in it.

While it was up, we've done the blkid command and it recognizes at least 1 partition on the SGI drive to be xfs, others were efs. We also used the hardware browser and got the same readings.

I did try using cpio on the one xfs partition it does recognize and got off some info, mainly only an indy patch directory and files. When I did a dd, cpio or a strings command and just let it stream from the partition, I could see a lot more information and files that I recognized as being the normal info that would be on that partition.

It's almost like I need to have some sort of combination of cpio, dd or strings in a script to strip the data off of the old partition without getting the filesystem info and save it into a desired directory.

We've also tried to make a disk image. If I try to mount the image on the linux computer, it will essentially give me the same error about version 1 xfs. Not that this was unexpected, it should error out just like the drive did. I also happen to have an O2 up and running, so I copied the image over to the O2 expecting to try and mount the image so it would/should automatically handle the xfs issue, but it looks like the O2 mount command does not have the loop or knows how to handle mounting an image like the Linux does. Right now I cannot restore the image, because it would wipe out my one good O2 drive, at least until I get some clones made up. You also might be thinking to just mount the Onyx drive to the O2, but the O2 does not have the interface to handle a wide differential high voltage SCSI interface.

If it's not one thing it's something else. I guess it would be boring if not for things like this.

I'll get the info you requested later when we come back up.

Thanks for the help,
Later,
Ed

-----Original Message-----
From: Ben Myers [mailto:bpm@sgi.com] 
Sent: Wednesday, May 06, 2015 11:12 AM
To: Scott, Edmund J @ SSG - Link
Cc: xfs@oss.sgi.com
Subject: Re: SGI Version 1 XFS on Linux

Hi Edmund,

On Wed, May 06, 2015 at 03:12:59PM +0000, Scott, Edmund J @ SSG - Link
wrote:
> We have several older SGI hard drives we are trying to recover data 
> from. However, since these drives came from an SGI Onyx running IRIX 
> 6.2, it uses the older version 1 XFS file system. I can see the SCSI 
> drive on my Linux box (CentOS 5.11) and I know data is on the drive, I 
> can list out some of the info using dd, cpio or strings, but cannot 
> copy the data off of it. I have tried using xfs_copy to a version 2 
> XFS partition, but it just converts the target partition to version 1, 
> which I cannot mount. I have also looked at xfs_dump/restore, but 
> those require mounted filesystems.
> 
> Is there any script or program or option I can use to copy the data 
> off of the un-mounted SGI XFS partition. I'm guessing some combination 
> of the cpio and dd, but I have not figured out the right combination 
> yet.

Apparently CentOS 5.11 should be a 2.6.18 kernel.  It looks like it should still have support for version 1, so I'm surprised you're having trouble.  Could you provide a little more information?  

1) dmesg output when you try to mount the filesystem
2) xfs_info output, e.g.
	xfs_info /dev/sda5
3) hexdump of the superblock, e.g. 
	dd if=/dev/sda5 count=1 | hexdump -C

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
