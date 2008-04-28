Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Apr 2008 20:11:11 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3S3Ai5K020910
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2008 20:10:46 -0700
Date: Mon, 28 Apr 2008 13:11:20 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] Don't initialise new inode generation numbers to zero V2
Message-ID: <20080428031120.GD103491721@sgi.com>
References: <20080422015806.GU108924158@sgi.com> <480D641B.8060301@melbourne.sgi.com> <20080422050447.GV103491721@sgi.com> <20080425085750.GA6395@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080425085750.GA6395@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, Greg Banks <gnb@melbourne.sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Apr 25, 2008 at 04:57:50AM -0400, Christoph Hellwig wrote:
> On Tue, Apr 22, 2008 at 03:04:48PM +1000, David Chinner wrote:
> > > I'm confused, why would an NFS client be trying to guess the generation
> > > number?  AFAICS the important thing is to ensure that the (inode,gen)
> > > tuple isn't reused for a long time to prevent accidental filehandle
> > > identity issues on clients; whether the gen is predictable or not
> > > doesn't matter at all.
> > 
> > Yeah, that's exactly what I said to Christoph, but that's the issue he
> > raised w.r.t a malicious client triggering inode/gen collisions
> > intentionally. If that's not a problem, then I can just use random32()
> > for the inode number. If it is a real problem, then it needs to be
> > a cryptographically secure random number. Personally, I don't care
> > either way - I just want to get the issue fixed.
> > 
> > Christoph, care to explain how and why this is a problem to everyone?
> 
> XFS has some heuristics for inode placement and of course for removing
> the inode cluster and re-allocting it.  I have a gut feeling that there
> is a small chance to trigger a re-use via nfs operations.  Making the
> initial generation number random means we remove one of the major
> user-triggerable inputs from the equation.

Ok, so is random32() good enough or does it need to be get_random_int()?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
