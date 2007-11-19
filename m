Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 18 Nov 2007 19:02:44 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAJ32dDa030610
	for <xfs@oss.sgi.com>; Sun, 18 Nov 2007 19:02:41 -0800
Date: Mon, 19 Nov 2007 14:02:44 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] bulkstat fixups
Message-ID: <20071119030244.GR66820511@sgi.com>
References: <4733EEF2.9010504@sgi.com> <20071111214759.GS995458@sgi.com> <4737C11D.8030007@sgi.com> <20071112041121.GT66820511@sgi.com> <473D1DE0.1090106@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473D1DE0.1090106@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Nov 16, 2007 at 03:34:40PM +1100, Lachlan McIlroy wrote:
> Updated patch - I added cond_resched() calls into each loop - for loops that
> have a 'continue' somewhere in them I added the cond_resched() at the start,
> otherwise I put it at the end.

You probably don't need the call in the innermost loop (the walking across
the inode cluster).

> >>>Userspace visile change. What applications do we have that rely on this
> >>>behaviour that will be broken by this change?
> >>Any apps that rely on the existing behaviour are probably broken.  If an 
> >>app
> >>wants to call xfs_bulkstat_single() it should use 
> >>XFS_IOC_FSBULKSTAT_SINGLE.
> >
> >Perhaps, but we can't arbitrarily decide that those apps will now break on
> >a new kernel with this change. At minimum we need to audit all of the code
> >we have that uses bulkstat for such breakage (including DMF!) before we 
> >make a
> >change like this.
> 
> I've looked through everything we have in xfs-cmds and nothing relies on
> this bug being present.  Vlad helped me with the DMF side - DMF does not
> use the XFS_IOC_FSBULKSTAT ioctl, it has it's own interface into the kernel
> which calls xfs_bulkstat() directly so it wont be affected by this change.

Sounds like it really is a bug as nothing is trying to exploit that
behaviour. Ok, seems fair to fix it.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
