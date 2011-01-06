Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p06I11Yi097969 for <xfs@oss.sgi.com>; Thu, 6 Jan 2011 12:01:03 -0600
Date: Thu, 6 Jan 2011 13:03:05 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: add FITRIM support
Message-ID: <20110106180305.GA32670@infradead.org>
References: <20110102072202.GA26488@infradead.org>
	<1294178115.2485.19.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1294178115.2485.19.camel@doink>
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

> > + * Copyright (C) 2010 Red Hat, Inc.
> 
> Maybe 2011 now...

Nothing major changes in 2011, so no.

> > +		 * If the extent is entirely outside of the range we are
> > +		 * supposed to discard skip it.  Do not bother to trim
> > +		 * down partially overlapping ranges for now.
> > +		 */
> > +		if (XFS_AGB_TO_FSB(mp, agno, fbno) + flen < start ||
> > +		    XFS_AGB_TO_FSB(mp, agno, fbno) > start + len) {
> 
>                                                     ^
>                                           I think this should be >=

Yes.

> Do you want to add a boilerplate copyright header here?

Kinda hard to claim copyright on a single prototype.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
