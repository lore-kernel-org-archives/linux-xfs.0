Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8AIjjOv122627 for <xfs@oss.sgi.com>; Sat, 10 Sep 2011 13:45:45 -0500
Date: Sat, 10 Sep 2011 14:45:42 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 13/25] xfs: introduce xfs_bmap_last_extent
Message-ID: <20110910184542.GA26979@infradead.org>
References: <20110824060428.789245205@bombadil.infradead.org>
	<20110824060643.154462765@bombadil.infradead.org>
	<1315599826.1999.58.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1315599826.1999.58.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Sep 09, 2011 at 03:23:46PM -0500, Alex Elder wrote:
> On Wed, 2011-08-24 at 02:04 -0400, Christoph Hellwig wrote:
> > plain text document attachment (xfs-simplify-xfs_bmap_isaeof)
> > Add a common helper for finding the last extent in a file.
> > 
> > Largely based on a patch from Dave Chinner.
> 
> 
> The new version of xfs_bmap_isaeof() no longer asserts
> that the data fork is the one being operated on.  Why?

Because it would work perfectly fine for the attr fork, too - even
if it's fairly useless for it.

> fork is empty, so mention that case in the comment header:
>  
>     Returns 0 in *aeof if the file (fork) is empty.
> 
> (Maybe you could explain why this is true at a more
> abstract level though.)

I've done both.

> This logic could be shortened:
> 
> 		*aeof = off >= rec.br_startoff + rec.br_blockcount ||
> 			(off >= rec.br_startoff &&
> 				 isnullstartblock(rec.br_startblock);

Done (including a comment update)

> > +	return 0;
> > +}
> > +
> > +/*
> > + * Check if the endoff is outside the last extent. If so the caller will grow
> > + * the allocation to a stripe unit boundary.
> 
>     All offsets are considered outside the end of file for an
>     empty file (fork), so 1 is returned in *eof in that case.

Ok.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
