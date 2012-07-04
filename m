Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q645vOZo171126 for <xfs@oss.sgi.com>; Wed, 4 Jul 2012 00:57:25 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Spulp3HXxBXyZfD5 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Jul 2012 22:57:23 -0700 (PDT)
Date: Wed, 4 Jul 2012 01:57:23 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: do not call xfs_bdstrat_cb in
	xfs_buf_iodone_callbacks
Message-ID: <20120704055723.GB27500@infradead.org>
References: <20120702100003.960640484@bombadil.infradead.org>
	<20120702100034.921366796@bombadil.infradead.org>
	<20120703002857.GY19223@dastard>
	<20120703160531.GA855@infradead.org>
	<20120703232923.GC19223@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120703232923.GC19223@dastard>
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

On Wed, Jul 04, 2012 at 09:29:23AM +1000, Dave Chinner wrote:
> It's not working yet - I found an issue with logging and writeback
> of uncached buffers through the AIL (i.e. the superblock). This only
> works by good fortune right now and requires uncached buffers to
> carry their block number internally, so I need to rethink and rework
> the patch.

What is the problem with uncached buffers?  I'd hate having to move
the superblock buffer away from the uncached scheme.

> How much does it change? I'm also trying to get all the read verify
> callback infrastructure changes done for 3.6, and i suspect these may
> step on each other. I've just about got those patches done - testing
> and bug fixing is happening at the moment....

Basically a lot of impact around all callers of xfsbdstrat (which is
going away) and some impact in xfs_buf.c around the higher-level
read/write code.  I'm not entirely done with the plane I have so
other things might get in the way and make it more complicated in
the end.

Another thing it depends on is to only start the sync work item later
during mount so that the re-read of the superblock after recovery can
use normal buffer cache interfaces instead of xfsbdstrat.  I have a
minimal version of that in my tree but was waiting for your planned
large changes in that area.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
