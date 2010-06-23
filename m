Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5NNENgP044595 for <xfs@oss.sgi.com>; Wed, 23 Jun 2010 18:14:23 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EEF53B5F908
	for <xfs@oss.sgi.com>; Wed, 23 Jun 2010 16:21:22 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	kaMPlA2mlL8K2XMj for <xfs@oss.sgi.com>;
	Wed, 23 Jun 2010 16:21:22 -0700 (PDT)
Date: Thu, 24 Jun 2010 09:17:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS peculiar behavior
Message-ID: <20100623231700.GP6590@dastard>
References: <4C21B9AF.9010307@ics.forth.gr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C21B9AF.9010307@ics.forth.gr>
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
To: Yannis Klonatos <klonatos@ics.forth.gr>
Cc: xfs@oss.sgi.com

On Wed, Jun 23, 2010 at 10:37:19AM +0300, Yannis Klonatos wrote:
> Hi all!
> 
>         I have come across the following peculiar behavior in XFS
> and i would appreciate any information anyone
> could provide.
>         In our lab we have a system that has twelve 500GByte hard
> disks (total capacity 6TByte), connected to an
> Areca (ARC-1680D-IX-12) SAS storage controller. The disks are
> configured as a RAID-0 device. Then I create
> a clean XFS filesystem on top of the raid volume, using the whole
> capacity. We use this test-setup to measure
> performance improvement for a TPC-H experiment. We copy the database
> over the clean XFS filesystem using the
> cp utility. The database used in our experiments is 56GBytes in size
> (data + indices).
>         The problem is that i have noticed that XFS may - not all
> times - split a table over a large disk distance. For
> example in one run i have noticed that a file of 13GByte is split
> over a 4,7TByte distance (I calculate this distance
> by subtracting the final block used for the file with the first one.
> The two disk blocks values are acquired using the
> FIBMAP ioctl).
>         Is there some reasoning behind this (peculiar) behavior? I
> would expect that since the underlying storage is so
> large, and the dataset is so small, XFS would try to minimize disk
> seeks and thus place the file sequentially in disk.
> Furthermore, I understand that there may be some blocks left unused
> by XFS between subsequent file blocks used
> in order to handle any write appends that may come afterward. But i
> wouldn't expect such a large splitting of a single
> file.
>         Any help?

The reasons for it being split are wide and varied. We need more
information before trying to determie the reason.

The output of "xfs_info <mntpt>" will tell us your filesystem
geometry and the output of xfs_bmap <split file> will tell us
exactly how it was laid out on disk. These are needed to see exactly
what the problem is.

Did you copy the file alone, with others, or while there were other
write operations going on in the background? was it a pristine
filesystem that you copied it to? If so, what was the directory
structure created before/by the copy?

Also, the kernel version you are running, and the version of
xfsprogs you have installed (xfs_info -V) will help us determine if
you are tripping any known bugs...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
