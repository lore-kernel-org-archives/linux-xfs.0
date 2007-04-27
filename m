Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Apr 2007 23:16:48 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3R6GdfB001234
	for <xfs@oss.sgi.com>; Thu, 26 Apr 2007 23:16:44 -0700
Date: Fri, 27 Apr 2007 16:16:23 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] make growfs check device size limits too
Message-ID: <20070427061623.GB77450368@melbourne.sgi.com>
References: <1177569014.6273.367.camel@edge> <20070426071055.GA24411@infradead.org> <1177631120.6273.380.camel@edge>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177631120.6273.380.camel@edge>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nscott@aconex.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Apr 27, 2007 at 09:45:20AM +1000, Nathan Scott wrote:
> On Thu, 2007-04-26 at 08:10 +0100, Christoph Hellwig wrote:
> > On Thu, Apr 26, 2007 at 04:30:14PM +1000, Nathan Scott wrote:
> > > On the mount path we check for a superblock that describes a filesystem
> > > to large for the running kernel to handle.  This catches the case of an
> > > attempt to mount a >16TB filesystem on i386 (where we are limited by the
> > > page->index size, for XFS metadata buffers in xfs_buf.c).
> > > 
> > > This patch makes similar checks on the growfs code paths for regular and
> > > realtime growth, else we can end up with filesystem corruption, it would
> > > seem (from #xfs chatter).  Untested patch follows; probably better to do
> > > this as a macro, in a header, and call that in each place...?
> > 
> > Yeah, the check should probably we in one place only.  Given that's it's
> > only used in slow pathes a function would probably do it.
> 
> Here's a revised version...

Added to my qa tree.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
