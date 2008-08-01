Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Aug 2008 12:35:12 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m71JZA4p024489
	for <xfs@oss.sgi.com>; Fri, 1 Aug 2008 12:35:10 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3B64C1969487
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2008 12:36:23 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 1BydtQl8xroo0TOQ for <xfs@oss.sgi.com>; Fri, 01 Aug 2008 12:36:23 -0700 (PDT)
Date: Fri, 1 Aug 2008 21:36:25 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 08/21] make btree tracing generic
Message-ID: <20080801193625.GB1263@lst.de>
References: <20080729193044.GI19104@lst.de> <20080730013920.GI13395@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080730013920.GI13395@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Wed, Jul 30, 2008 at 11:39:20AM +1000, Dave Chinner wrote:
> > +	void		(*trace_enter)(struct xfs_btree_cur *, const char *,
> > +				       char *, int, int, __psunsigned_t,
> > +				       __psunsigned_t, __psunsigned_t,
> > +				       __psunsigned_t, __psunsigned_t,
> > +				       __psunsigned_t, __psunsigned_t,
> > +				       __psunsigned_t, __psunsigned_t,
> > +				       __psunsigned_t, __psunsigned_t);
> 
> Would it be better to use a 'trace args' structure here rather
> than passing a heap of parameters? memset(args, 0,...) rather than
> passing a whole heap of zeros in most cases seems like a better
> approach to me, esp. as they all get cast to (void *) anyway....

Well, we need to case to void * somewhere, and going from struct
to arguments list isn't helpful either.

Changing the whole ktrace thing to an args strucutr and/or varags
would be nice, but is not in scope for this patchset..

> > +static void
> > +xfsidb_btree_trace_record(
> 
> shouldn't these all use "xfsidbg" prefixes?

Probably.
