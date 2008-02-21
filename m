Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 14:49:59 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1LMnoCt003949
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 14:49:53 -0800
Date: Fri, 22 Feb 2008 09:50:13 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [patch] Don't change ctime in truncate is size does not change
Message-ID: <20080221225013.GF155407@sgi.com>
References: <20080218233251.GV155407@sgi.com> <20080220232615.GA25493@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080220232615.GA25493@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Feb 20, 2008 at 06:26:15PM -0500, Christoph Hellwig wrote:
> > +		if (vap->va_size != ip->i_size || mask & XFS_AT_CTIME)
> 
> Normal Linux style is to always have braces around the 'foo & bar'
> statements to avoid operator precedance problems when re-ordering the
> statements.  Otherwise this one looks good.

Fixed up. Thank's for the review.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
