Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 13 Sep 2007 03:40:04 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8DAdx4p024791
	for <xfs@oss.sgi.com>; Thu, 13 Sep 2007 03:40:00 -0700
Date: Thu, 13 Sep 2007 12:40:00 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: state of the cvs tree
Message-ID: <20070913104000.GB3351@lst.de>
References: <20070912121938.GA16870@lst.de> <46E870AB.30906@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E870AB.30906@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Goodwin <markgw@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Thu, Sep 13, 2007 at 09:05:15AM +1000, Mark Goodwin wrote:
> 
> 
> Christoph Hellwig wrote:
> >looks like the cvs tree is broken currently - fs/xfs/ is merged up to
> >2.6.23-rc, but everything else is still at 2.6.22-rc state leading to
> >various compile failures.
> 
> I think Tim is in the middle of the .23 update and still has some more
> to push in. Tim?
> 
> What else do you (or anyone for that matter) have in the pipeline for XFS?
> Whilst we're taking huge patches and cleanups, let's get them all in asap.

I have a long pipeline waiting, but as Dave said most of that really
shouldn't go into 2.6.24.

There's one patch from me that I sent a long time ago that's a trivial
cleanup and should probably go into 2.6.24 still, that's

	"[PATCH] kill unused IOMAP_EOF flag"

One thing that is in my alreayd submitted queue that should go into CVS
ASAP after a small review is:

	"[PATCH] kill probe_* sysctl leftovers"

this is stuff that never was in mainline, so putting it in seems fine.

Then I have a patch from Eric sitting in the front of my queue,

	"[PATCH V2] refactor xfs_mountfs for clarity & stack savings"

which might be a little too big for 2.6.24, but should at least go into
CVS ASAP.  I think Eric would be really happy to see it in 2.6.24 aswell
because that means FC8 could actually mount xfs out of the box without
running out of stack or something.
