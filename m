Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9A0HCQL133785 for <xfs@oss.sgi.com>; Sun, 9 Oct 2011 19:17:12 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F33B71C79C2D
	for <xfs@oss.sgi.com>; Sun,  9 Oct 2011 17:17:10 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	eiSIBZNkGymtDlmR for <xfs@oss.sgi.com>;
	Sun, 09 Oct 2011 17:17:10 -0700 (PDT)
Date: Mon, 10 Oct 2011 11:17:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/5] repair: handle repair of image files on large sector
	size filesystems
Message-ID: <20111010001708.GP3159@dastard>
References: <1318201910-11144-1-git-send-email-david@fromorbit.com>
	<1318201910-11144-2-git-send-email-david@fromorbit.com>
	<20111009235240.GD13527@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111009235240.GD13527@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sun, Oct 09, 2011 at 07:52:40PM -0400, Christoph Hellwig wrote:
> On Mon, Oct 10, 2011 at 10:11:46AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Because repair uses direct IO, it cannot do IO smaller than a sector
> > on the underlying device. When repairing a filesystem image, the
> > filesystem hosting the image may have a sector size larger than the
> > sector size of the image, and so single image sector reads and
> > writes will fail.
> 
> Does it?  Given that the loop driver uses buffered I/O that would be
> unexpected behaviour.  I'll try to reproduce it as soon as my 4k
> disk is available again.

My 3TB, RAID6 based image storage filesystem has a 4k sector size,
and I can't run xfs_repair on an image file that has smaller sector
sizes than 4k without this mod. In that case, xfs_repair is doing
direct IO on a file, not a device, and the file is on the 4k sector
sized filesytem. I've been carrying this patch for a while.

So it's definitely a real problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
