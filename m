Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9A0JAD6133852 for <xfs@oss.sgi.com>; Sun, 9 Oct 2011 19:19:11 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8697D4EF2EC
	for <xfs@oss.sgi.com>; Sun,  9 Oct 2011 17:19:10 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	NaJvMfGKLf3tBJCp for <xfs@oss.sgi.com>;
	Sun, 09 Oct 2011 17:19:10 -0700 (PDT)
Date: Sun, 9 Oct 2011 20:19:09 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] repair: handle repair of image files on large sector
	size filesystems
Message-ID: <20111010001909.GA4886@infradead.org>
References: <1318201910-11144-1-git-send-email-david@fromorbit.com>
	<1318201910-11144-2-git-send-email-david@fromorbit.com>
	<20111009235240.GD13527@infradead.org>
	<20111010001708.GP3159@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111010001708.GP3159@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Oct 10, 2011 at 11:17:08AM +1100, Dave Chinner wrote:
> > Does it?  Given that the loop driver uses buffered I/O that would be
> > unexpected behaviour.  I'll try to reproduce it as soon as my 4k
> > disk is available again.
> 
> My 3TB, RAID6 based image storage filesystem has a 4k sector size,
> and I can't run xfs_repair on an image file that has smaller sector
> sizes than 4k without this mod. In that case, xfs_repair is doing
> direct IO on a file, not a device, and the file is on the 4k sector
> sized filesytem. I've been carrying this patch for a while.

Got it - you repair the image on directly on the device, without the
loop driver.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
