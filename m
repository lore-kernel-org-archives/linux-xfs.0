Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2R5mYLi196541 for <xfs@oss.sgi.com>; Tue, 27 Mar 2012 00:48:36 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	lJ4ClQyCAG3WSdrV (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 26 Mar 2012 22:48:30 -0700 (PDT)
Date: Tue, 27 Mar 2012 01:48:27 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] xfs: push the ilock into xfs_zero_eof
Message-ID: <20120327054827.GA11976@infradead.org>
References: <20120326211421.518374058@bombadil.infradead.org>
	<20120326211603.654869525@bombadil.infradead.org>
	<20120327011540.GS5091@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120327011540.GS5091@dastard>
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

On Tue, Mar 27, 2012 at 12:15:40PM +1100, Dave Chinner wrote:
> > +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> >  	error = xfs_bmapi_read(ip, last_fsb, 1, &imap, &nimaps, 0);
> > +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> 
> Does that even need to be an exclusive lock? a shared lock is all
> that is needed to do a lookup, and this is just a lookup...

It has to be a xfs_ilock_map_shared - but given that we hold the iolock
exclusive anyway I didn't bother to optimize this further.

Same for the second xfs_bmapi_read call.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
