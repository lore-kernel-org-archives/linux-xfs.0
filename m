Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 30 May 2008 00:52:31 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4U7qS2p002221
	for <xfs@oss.sgi.com>; Fri, 30 May 2008 00:52:28 -0700
Date: Fri, 30 May 2008 09:53:11 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] use generic_*xattr routines
Message-ID: <20080530075310.GA8446@lst.de>
References: <20080430112217.GB16966@lst.de> <20080521081656.GA2638@lst.de> <48365486.3060503@sgi.com> <20080523054848.GA29507@lst.de> <483A15CE.9060409@sgi.com> <20080526053759.GA17825@lst.de> <483BE788.4050504@sgi.com> <20080529123910.GA30874@lst.de> <483FA0B6.1030703@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483FA0B6.1030703@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, May 30, 2008 at 04:37:42PM +1000, Timothy Shimmin wrote:
> > Yes.  I have an initial patch that goes directly to xfs_attr_list_int
> > from xfs_xattr.c and kills most of the ATTR_KERN flags.  It's a quite
> > nice cleanup already.  Next step will be to convert dmapi to use it's
> > own callback aswell.  This will be an even bigger cleanup as
> > put_listent gets the xattr value aswell and we can kill the additional
> > xfs_attr_get calls, making this code simpler and more efficient.
> > 
> Sorry, what xfs_attr_get call are you referring to?

xfs_dm_getall_dmattr currently does an xfs_attr_list and then performs
and xfs_attr_get for each attribute it cares about.  But rewriting this
to use put_listent we not only get rid of the temporary buffer but
also the need to calls xfs_attr_get because put_listent already gets
the attribute value passed.  It also fixes the race mentioned in the
comment and with a properly written put_listent helper can copy the
attributes directly to userspace without any kernel buffer at all.

That would also fix the direct userspace pointer dereference currently
lingering in that code :)

> > I've started looking at this and after some investigation I think
> > we should just pass the xfs_inode directly to all the functions and then
> > a void parameter, yes.  We'll need to find a solution for the
> > seen_enough paramter, but I think this could be handled similar to
> > filldir.  There's also some functions directly touching the attr cursor
> > which seems solveable, too.
> > 
> I'll await the patch :)
> The seen_enough param was added for search type callbacks so the callback
> could terminate the list walk early.
> Oh okay, I also used it to stop when we fill the buffer.

Yes. May idea is to break out of the loop as soon as put_listent returns
a non-zero value just like filldir.  We can then decided to play with
positivie / begative values to allow for a sucessfull early exit, or
just like filldir have the actual errno inside the private context
structure.  I suspect the first variant will be cleaner.
