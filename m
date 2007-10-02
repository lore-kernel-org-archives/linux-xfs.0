Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 02 Oct 2007 03:25:15 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l92APAu5003667
	for <xfs@oss.sgi.com>; Tue, 2 Oct 2007 03:25:11 -0700
From: Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] Replace XFS bit functions with Linux functions
Date: Tue, 2 Oct 2007 12:11:47 +0200
References: <200710021010.58284.ak@suse.de> <20071002095525.GA25405@infradead.org>
In-Reply-To: <20071002095525.GA25405@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710021211.47718.ak@suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com


> 
> >  	while (fields) {
> > -		f = (xfs_sb_field_t)xfs_lowbit64((__uint64_t)fields);
> > +		f = (xfs_sb_field_t)find_first_bit((unsigned long *)&fields,64);
> 
> I don't think we should add the case here but rather pass the fields
> varialble as an unsigned long to start with.

I actually did this first, but ran into some issues I unfortunately can't remember right 
now so I reverted it to the cast.

> 
> > @@ -1428,11 +1428,11 @@ xfs_mod_sb(xfs_trans_t *tp, __int64_t fi
> >  
> >  	/* find modified range */
> >  
> > -	f = (xfs_sb_field_t)xfs_lowbit64((__uint64_t)fields);
> > +	f = (xfs_sb_field_t)find_first_bit((unsigned long *)&fields, 64);
> >  	ASSERT((1LL << f) & XFS_SB_MOD_BITS);
> >  	first = xfs_sb_info[f].offset;
> >  
> > -	f = (xfs_sb_field_t)xfs_highbit64((__uint64_t)fields);
> > +	f = (xfs_sb_field_t)fls64((__uint64_t)fields) - 1;
> 
> Same here.

The casts here are actually not needed, but I was too lazy to remove them
(they also don't hurt) 

> 
> > +/* All callers check for 0 arguments already; so no -1 handling */
> > +static inline int xfs_rtlobit(unsigned long v)
> > +{
> > +	return find_first_bit(&v, 32);
> > +}
> > +
> > +#define	XFS_RTLOBIT(w)  xfs_rtlobit(w)
> 
> I think just a
> 
> #define	XFS_RTLOBIT(w)	find_first_bit(&(w), 32)
> 
> should be fine. 

Nope -- not all callers pass sufficiently aligned unsigned longs
as ffb requires.

> Or make it just an inline, but not both a macro an 
> an inline.

That should be probably done as a separate patch because there
are much more macros that need this treatment in the rt code.

-Andi
