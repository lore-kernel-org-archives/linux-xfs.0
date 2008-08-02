Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Aug 2008 18:12:53 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m721Cpum021806
	for <xfs@oss.sgi.com>; Fri, 1 Aug 2008 18:12:51 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C2466196B220
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2008 18:14:03 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id CfDGaCG3TOEDPv5A for <xfs@oss.sgi.com>; Fri, 01 Aug 2008 18:14:03 -0700 (PDT)
Date: Sat, 2 Aug 2008 11:14:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/21] implement generic xfs_btree_lookup
Message-ID: <20080802011400.GK6201@disturbed>
References: <20080729193104.GL19104@lst.de> <20080730045937.GL13395@disturbed> <20080801194336.GE1263@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080801194336.GE1263@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Fri, Aug 01, 2008 at 09:43:36PM +0200, Christoph Hellwig wrote:
> On Wed, Jul 30, 2008 at 02:59:37PM +1000, Dave Chinner wrote:
> > > --- linux-2.6-xfs.orig/fs/xfs/xfs_alloc.c	2008-07-15 17:46:52.000000000 +0200
> > > +++ linux-2.6-xfs/fs/xfs/xfs_alloc.c	2008-07-15 17:51:41.000000000 +0200
> > > @@ -90,6 +90,54 @@ STATIC int xfs_alloc_ag_vextent_small(xf
> > >   */
> > >  
> > >  /*
> > > + * Lookup the record equal to [bno, len] in the btree given by cur.
> > > + */
> > > +STATIC int				/* error */
> > > +xfs_alloc_lookup_eq(
> > 
> > Should these be xfs_allocbt_lookup_*() to be consistent
> > with all the other allocbt functions (and inobt_lookup/bmbt_lookup)?
> 
> Currently only the btree_ops methods are named allocbt.  Comments on
> that scheme would be appreciated.

I think I used 'abt' for it. Perhaps 'albt'? allocbt is probably ok,
though, just longer.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
