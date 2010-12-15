Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBFCGJGr199734 for <xfs@oss.sgi.com>; Wed, 15 Dec 2010 06:16:19 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 57F7C1CCCD81
	for <xfs@oss.sgi.com>; Wed, 15 Dec 2010 04:18:13 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id R9gnQE60hZ3ufD8U for
	<xfs@oss.sgi.com>; Wed, 15 Dec 2010 04:18:13 -0800 (PST)
Date: Wed, 15 Dec 2010 07:18:11 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: provide a inode iolock lockdep class
Message-ID: <20101215121811.GA3122@infradead.org>
References: <1292202431-15320-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1292202431-15320-1-git-send-email-david@fromorbit.com>
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

On Mon, Dec 13, 2010 at 12:07:11PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The XFS iolock needs to be re-initialised to a new lock class before
> it enters reclaim to prevent lockdep false positives. Unfortunately,
> this is not sufficient protection as inodes in the XFS_IRECLAIMABLE
> state can be recycled and not re-initialised before being reused.
> 
> We need to re-initialise the lock state when transfering out of
> XFS_IRECLAIMABLE state to XFS_INEW, but we need to keep the same
> class as if the inode was just allocated. Hence we need a specific
> lockdep class variable for the iolock so that both initialisations
> use the same class.
> 
> While there, add a specific class for inodes in the reclaim state so
> that it is easy to tell from lockdep reports what state the inode
> was in that generated the report.

Looks good to me.  As long as we have the mrlock abstraction we might as
well hide this behind it, but as I plan on killing the abstraction
that's probably not worth the effort.


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
