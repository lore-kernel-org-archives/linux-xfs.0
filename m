Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 16 Sep 2008 17:56:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8H0uYw6022013
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2008 17:56:35 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1BA4A12BD216
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2008 17:58:06 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id f3nstGaTypPwGX0I for <xfs@oss.sgi.com>; Tue, 16 Sep 2008 17:58:06 -0700 (PDT)
Date: Wed, 17 Sep 2008 10:57:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/6] cleanup btree record / key / ptr addressing macros
Message-ID: <20080917005750.GG5811@disturbed>
References: <20080915004653.GE12213@lst.de> <20080916055333.GW5811@disturbed> <20080916174136.GC26187@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080916174136.GC26187@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Tue, Sep 16, 2008 at 07:41:36PM +0200, Christoph Hellwig wrote:
> On Tue, Sep 16, 2008 at 03:53:33PM +1000, Dave Chinner wrote:
> > On Mon, Sep 15, 2008 at 02:46:53AM +0200, Christoph Hellwig wrote:
> > > +#define XFS_BMAP_BROOT_PTR_ADDR(mp, bb, i, sz) \
> > > +	XFS_BMBT_PTR_ADDR(mp, bb, i, xfs_bmbt_maxrecs(mp, sz, 0))
> > 
> > Ah, that explains why that macro didn't change. Why keep just this
> > one?
> 
> It seems borderline useful, but if you care strongly I can kill it.

I don't really mind - i was just curious as to why that particular
macro didn't get changed like all the others. Seems reasonable to
leave it there....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
