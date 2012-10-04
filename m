Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q94NUfS1237770 for <xfs@oss.sgi.com>; Thu, 4 Oct 2012 18:30:41 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	MIsOioxfcYa2JTXt for <xfs@oss.sgi.com>;
	Thu, 04 Oct 2012 16:32:06 -0700 (PDT)
Date: Fri, 5 Oct 2012 09:32:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_freeze same as umount?   How is that helpful?
Message-ID: <20121004233204.GB23644@dastard>
References: <506DAB8C.9000601@tlinx.org>
	<CAGpXXZJuWRAMnJfZKJMZ3N=0EwcfYOEwX+iteyk9hY7ojWA+XA@mail.gmail.com>
	<506E1025.8050605@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <506E1025.8050605@tlinx.org>
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
To: Linda Walsh <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Oct 04, 2012 at 03:39:33PM -0700, Linda Walsh wrote:
> Greg Freemyer wrote:
> >Conceptually it is typically:
> >- quiesce system
> ----
> 	Um... it seems that this is equivalent to being
> able to umount the disk?

NO, it's not. freeze intentionally leaves the log dirty, whereas
unmount leaves it clean.

> When I tried xfs_freeze / fs_freeze got fs-busy -- same as I would
> if I tried to umount it.

Of course - it's got to write all the dirty data andmetadata in
memory to disk. Freeze is about providing a stable, consistent disk
image of the filesystem, so it must flush dirty objects from memory
to disk to provide that.

> I thought the point of xfs_freeze was to allow it to be brought to
> a consistent state without unmounting it?

Exactly.

> Coincidentally, after trying a few freezes, the system froze.

Entirely possible if you froze the root filesystem and something you
rely on tried to write to the filesystem.

Anyway, a one-line "it froze" report doesn't tell us anything about
the problem you saw. So:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
