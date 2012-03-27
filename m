Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2R6BXMM206626 for <xfs@oss.sgi.com>; Tue, 27 Mar 2012 01:11:33 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	AWONrAvNQRUs5YGe for <xfs@oss.sgi.com>;
	Mon, 26 Mar 2012 23:11:31 -0700 (PDT)
Date: Tue, 27 Mar 2012 17:11:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/5] xfs: push the ilock into xfs_zero_eof
Message-ID: <20120327061129.GY5091@dastard>
References: <20120326211421.518374058@bombadil.infradead.org>
	<20120326211603.654869525@bombadil.infradead.org>
	<20120327011540.GS5091@dastard>
	<20120327054827.GA11976@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120327054827.GA11976@infradead.org>
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

On Tue, Mar 27, 2012 at 01:48:27AM -0400, Christoph Hellwig wrote:
> On Tue, Mar 27, 2012 at 12:15:40PM +1100, Dave Chinner wrote:
> > > +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > >  	error = xfs_bmapi_read(ip, last_fsb, 1, &imap, &nimaps, 0);
> > > +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > 
> > Does that even need to be an exclusive lock? a shared lock is all
> > that is needed to do a lookup, and this is just a lookup...
> 
> It has to be a xfs_ilock_map_shared - but given that we hold the iolock
> exclusive anyway I didn't bother to optimize this further.

Ok, makes sense.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
