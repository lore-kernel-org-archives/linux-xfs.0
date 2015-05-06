Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 068BA7F37
	for <xfs@oss.sgi.com>; Wed,  6 May 2015 16:48:59 -0500 (CDT)
Date: Wed, 6 May 2015 16:48:58 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: SGI Version 1 XFS on Linux
Message-ID: <20150506214858.GD10900@sgi.com>
References: <2994A55DE0FBBE41B8FE47F9885D74221BC0569C@ARLEXCHMBX02.lst.link.l-3com.com>
	<20150506171222.GA22744@sgi.com>
	<2994A55DE0FBBE41B8FE47F9885D74221BC056F3@ARLEXCHMBX02.lst.link.l-3com.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2994A55DE0FBBE41B8FE47F9885D74221BC056F3@ARLEXCHMBX02.lst.link.l-3com.com>
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
To: "Scott, Edmund J @ SSG - Link" <edmund.scott@l-3com.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hey Ed,

On Wed, May 06, 2015 at 07:47:51PM +0000, Scott, Edmund J @ SSG - Link
wrote:
> Hi,
> 
> We are in a thunderstorm right now so we had to shut down, be a while
> until we get things back up. We're in Utah with a rolling t-storm
> coming through. 
> 
> We did find documentation that XFS version 1 was pulled out of the
> linux kernel around or after kernel 2.4. and the messages kind of
> support that. I'm looking into digging up an old Red Hat OS to see if
> it is old enough to have the version 1 XFS in it.
> 
> While it was up, we've done the blkid command and it recognizes at
> least 1 partition on the SGI drive to be xfs, others were efs. We also
> used the hardware browser and got the same readings.
> 
> I did try using cpio on the one xfs partition it does recognize and
> got off some info, mainly only an indy patch directory and files. When
> I did a dd, cpio or a strings command and just let it stream from the
> partition, I could see a lot more information and files that I
> recognized as being the normal info that would be on that partition.
> 
> It's almost like I need to have some sort of combination of cpio, dd
> or strings in a script to strip the data off of the old partition
> without getting the filesystem info and save it into a desired
> directory.
> 
> We've also tried to make a disk image. If I try to mount the image on
> the linux computer, it will essentially give me the same error about
> version 1 xfs. Not that this was unexpected, it should error out just
> like the drive did. I also happen to have an O2 up and running, so I
> copied the image over to the O2 expecting to try and mount the image
> so it would/should automatically handle the xfs issue, but it looks
> like the O2 mount command does not have the loop or knows how to
> handle mounting an image like the Linux does. Right now I cannot
> restore the image, because it would wipe out my one good O2 drive, at
> least until I get some clones made up. You also might be thinking to
> just mount the Onyx drive to the O2, but the O2 does not have the
> interface to handle a wide differential high voltage SCSI interface.
> 
> If it's not one thing it's something else. I guess it would be boring
> if not for things like this.

I hear you.  Gotta love working on that old hardware though.  My
colleague Troy suggested that you are probably referring to directory
naming version 1, and not superblock version 1.

Dir v1 was removed in commit v2.6.17-rc6-55-gf6c2d1f:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=f6c2d1fa6310a71b1c2e05fc6d9ff9b91489fa0e

It's looking like your best bet is 2.6.16 or to mount it up on an irix
box.

> I'll get the info you requested later when we come back up.

Good luck with the storm.  ;)

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
