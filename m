Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 02 Feb 2007 05:40:55 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l12Degqw017508
	for <xfs@oss.sgi.com>; Fri, 2 Feb 2007 05:40:44 -0800
Date: Sat, 3 Feb 2007 00:39:41 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: Don't use kmap() in xfs_iozero().
Message-ID: <20070202133941.GW33919298@melbourne.sgi.com>
References: <20070202054044.GO33919298@melbourne.sgi.com> <20070202114830.GB23187@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070202114830.GB23187@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, xfs-dev@sgi.com, xfs@oss.sgi.com

On Fri, Feb 02, 2007 at 11:48:30AM +0000, Christoph Hellwig wrote:
> On Fri, Feb 02, 2007 at 04:40:44PM +1100, David Chinner wrote:
> > kmap is inefficient and does scale well. kmap_atomic() is a better
> > choice. Use the generic wrapper function instead of open coding the
> > kmap-memset-dcache flush-kumap stuff.  Suggested by Andrew Morton.
> > 
> > Comments?
> 
> Looks good.
> 
> > +		memclear_highpage_flush(page, (unsigned int)offset, bytes);
> 
> Do you need the cast here?  An unsigned long should be automatically
> demoted to an unsigned int when passing it as an argument.

Even on 64 bit platforms? I just added an explicit cast as a matter
of avoiding potential gcc warnings on other platforms/compiler
versions. Maybe I'm just being paranoid and I can remove it?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
