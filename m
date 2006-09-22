Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Sep 2006 23:20:51 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k8M6KeaG007814
	for <xfs@oss.sgi.com>; Thu, 21 Sep 2006 23:20:43 -0700
Date: Fri, 22 Sep 2006 16:19:50 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH -mm] rescue large xfs preferred iosize from the inode diet patch
Message-ID: <20060922061950.GE3034@melbourne.sgi.com>
References: <45131334.6050803@sandeen.net> <45134472.7080002@sgi.com> <4513493F.8090005@sandeen.net> <45134DC5.4070607@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45134DC5.4070607@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Timothy Shimmin <tes@sgi.com>, xfs mailing list <xfs@oss.sgi.com>

On Thu, Sep 21, 2006 at 09:43:17PM -0500, Eric Sandeen wrote:
> Eric Sandeen wrote:
> >
> >Ah, ok, thanks guys.  Should have checked CVS I guess.
> >
> cc -= lkml;
> 
> actually the patch nathan put in seems like a lot of replicated code.

Yeah, that's what caught me - I looked at the tree which had nathan's
patch in it, and assumed that the stuff the -mm tree had cleaned it up
to use the generic_fillattr() code.

> But maybe he's solving some problem I didn't think of.

The difference is the old code updated the fields in the linux inode
with all the info from disk and then filled in the stat data from
the linux inode.  The new code gets the data from "disk" and puts it
straight into the the stat buffer without updating the linux inode.

> Any idea what?

I would have thought that we want what we report to userspace to be
consistent in the linux inode as well. I suppose that by duplicating
the code we removed a copy of the data but I see little advantage
from doing that considering the extra code to do it and the fat that
the linux inode may not be up to date now....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
