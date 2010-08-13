Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7DBcrHq053199 for <xfs@oss.sgi.com>; Fri, 13 Aug 2010 06:38:53 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 950B51702493
	for <xfs@oss.sgi.com>; Fri, 13 Aug 2010 04:39:18 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	FFyUmO3CimZhDiH6 for <xfs@oss.sgi.com>;
	Fri, 13 Aug 2010 04:39:18 -0700 (PDT)
Date: Fri, 13 Aug 2010 21:39:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Alignment size?
Message-ID: <20100813113915.GD10429@dastard>
References: <4C64715F.8060000@msgid.tls.msk.ru>
	<20100812234911.GC10429@dastard>
	<4C64E52E.2060806@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C64E52E.2060806@msgid.tls.msk.ru>
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
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: xfs@oss.sgi.com

On Fri, Aug 13, 2010 at 10:24:46AM +0400, Michael Tokarev wrote:
> 13.08.2010 03:49, Dave Chinner wrote:
> > On Fri, Aug 13, 2010 at 02:10:39AM +0400, Michael Tokarev wrote:
> >> Hello.
> >>
> >> I used XFS for a long time on many different
> >> servers, and it works well.  But now I encountered
> >> an.. unexpected problem.
> >>
> >> The question is: on one of our servers, XFS requires
> >> different alignment size for O_DIRECT operations than
> >> on others.  Usually it's 512 bytes, but on this server
> >> it is 4096 - both min_io and alignment (this is from
> >> XFS_IOC_DIOINFO ioctl).
> > 
> > It'll be a filesystem set up with a 4k sector size, then.  Check the
> > output of xfs_info.
> 
> yes, xfs_info reports sectsz=4096, I noticed this yesterday.

....

> So the question that remains is: why?
> 
> It's an old machine (PIV era), with old scsi disks (74Gb
> non-hotswap), -- the same disks as used on numerous other
> machines out there, where there's no such issue.

If the software was as old as the machine, then that's the likely
reason.  The old md raid5 implementation did not handle sub-page
size aligned IO very well - a change of IO alignment would cause the
stripe cache to be purged and cause performance to be terrible.
Hence every time XFS wrote the superblock or an AG header it would
purge the stripe cache.

The workaround old versions of mkfs.xfs used was to create the fs
with a sector size of 4k when it detected md raid5 underneath it so
the sb and ag headers were all 4k aligned and sized, just like the
rest of the filesystem....

> And a related question, -- is there a way to create
> xfs fs with the right sector size?  The filesystem
> were ok in years, not only on this machine, and I'm
> quite afraid to replace it with something else (e.g.
> ext4) in a hurry without good prior testing.

# mkfs.xfs -s <size> ....

if you want to set it manually. YOu shouldn't need to with any
relatively recent mkfs.xfs...

> By the way, how one can check the "sector size" of a
> block device nowadays?  I think I saw something about
> sysfs, but I see nothing of that sort in 2.6.32 kernel
> (which is used on this and other systems).

/sys/block/<dev>/queue/hw_sector_size

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
