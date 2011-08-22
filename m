Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7MERoT1071492 for <xfs@oss.sgi.com>; Mon, 22 Aug 2011 09:27:50 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8AEE0FDCD5
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2011 07:27:49 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	dENMKxGYQCvwrgqw for <xfs@oss.sgi.com>;
	Mon, 22 Aug 2011 07:27:49 -0700 (PDT)
Date: Mon, 22 Aug 2011 10:27:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] xfs: remove dead ENODEV handling in xfs_destroy_ioend
Message-ID: <20110822142746.GA24433@infradead.org>
References: <20110814222412.359079843@bombadil.infradead.org>
	<20110814222517.607954695@bombadil.infradead.org>
	<20110822063245.GK3162@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110822063245.GK3162@dastard>
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
Cc: xfs@oss.sgi.com

On Mon, Aug 22, 2011 at 04:32:45PM +1000, Dave Chinner wrote:
> On Sun, Aug 14, 2011 at 06:24:13PM -0400, Christoph Hellwig wrote:
> > No driver returns ENODEV from it bio completion handler, not has this
> > ever been documented.  Remove the dead code dealing with it.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> IIRC, this was added years ago for XVM to cause filesystems to shut
> down when the storage went away (e.g. someone tripped over a cable
> bundle or fenced the machine).  It would be nice if there was some
> standard way of handling this rather than having the filesytem
> continue to allow applications to dirty memory when there is no
> chance of ever cleaning it....
> 
> As it is, I see no point in keeping something that won't ever be
> used, so

Initially I just made sure to defer contexts with ENODEV returns
to the workqueues as well, as we can't really shutdown the fs from
irq context.  But given that this code is dead, and we are mixing
up positive and negative errors in io_error I decided it's better
to remove it for now.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
