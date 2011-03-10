Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2AMDSOb124956 for <xfs@oss.sgi.com>; Thu, 10 Mar 2011 16:13:34 -0600
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 43A9FAC00E
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2011 14:16:20 -0800 (PST)
Subject: Re: [PATCH 1/2] xfstests: a few fixes to Makefile
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110310172537.GB13390@infradead.org>
References: <201103041937.p24JbaaN004813@stout.americas.sgi.com>
	<20110310172537.GB13390@infradead.org>
Date: Thu, 10 Mar 2011 16:16:06 -0600
Message-ID: <1299795366.2573.78.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Thu, 2011-03-10 at 12:25 -0500, Christoph Hellwig wrote:
> > +ifeq ($(HAVE_DMAPI), true)
> >  	# automake doesn't always support "default" target 
> >  	# so do dmapi make explicitly with "all"
> > -ifeq ($(HAVE_DMAPI), true)
> 
> What about moving the # signs to the first line so that it never gets
> echoed at all?
> 
> Otherwise looks good to me.

That would work too.  A later patch makes the
whole thing go away though, so it's sort of moot.
(And I already committed it after some discussion
with Eric yesterday...)

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
