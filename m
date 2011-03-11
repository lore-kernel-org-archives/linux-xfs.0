Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2BA7Ube154559 for <xfs@oss.sgi.com>; Fri, 11 Mar 2011 04:07:40 -0600
Date: Fri, 11 Mar 2011 05:10:20 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfstests: a few fixes to Makefile
Message-ID: <20110311101020.GC11879@infradead.org>
References: <201103041937.p24JbaaN004813@stout.americas.sgi.com>
	<20110310172537.GB13390@infradead.org>
	<1299795366.2573.78.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1299795366.2573.78.camel@doink>
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

On Thu, Mar 10, 2011 at 04:16:06PM -0600, Alex Elder wrote:
> On Thu, 2011-03-10 at 12:25 -0500, Christoph Hellwig wrote:
> > > +ifeq ($(HAVE_DMAPI), true)
> > >  	# automake doesn't always support "default" target 
> > >  	# so do dmapi make explicitly with "all"
> > > -ifeq ($(HAVE_DMAPI), true)
> > 
> > What about moving the # signs to the first line so that it never gets
> > echoed at all?
> > 
> > Otherwise looks good to me.
> 
> That would work too.  A later patch makes the
> whole thing go away though, so it's sort of moot.
> (And I already committed it after some discussion
> with Eric yesterday...)

Ok.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
