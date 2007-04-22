Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 22 Apr 2007 07:35:56 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3MEZnfB013651
	for <xfs@oss.sgi.com>; Sun, 22 Apr 2007 07:35:51 -0700
Date: Sun, 22 Apr 2007 16:35:48 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] remove various useless min/max macros
Message-ID: <20070422143548.GB15747@lst.de>
References: <20070418175730.GA18315@lst.de> <20070418235056.GJ48531920@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070418235056.GJ48531920@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Thu, Apr 19, 2007 at 09:50:56AM +1000, David Chinner wrote:
> On Wed, Apr 18, 2007 at 07:57:30PM +0200, Christoph Hellwig wrote:
> > xfs_btree.h has various macros to calculate a min/max after casting
> > it's arguments to a specific type.  This can be done much simpler
> > by using min_t/max_t with the type as first argument.
> 
> Sure, but I NACKed that last October for good reason.
> 
> http://marc.info/?t=116116017600003&r=1&w=2
> 
> Specifically:
> 
> http://marc.info/?l=linux-kernel&m=116122285309389&w=2
> 
> I still have no objection to changing the implementation of these
> macros or even changing them to non-shouting static inlines but
> I don't want them removed....

Oh, I don't remember that thread anymore.  Anyway, I disagree.
min_t/max_t says as much as the existing macros that we want to
do a comparism as the first type passed to it.  That's the whole
point of these macros.  I agree in case you apply your judgement to
the first patch posted in that thread that uses plain min/max.

But anyway, you're the maintainer, so..
