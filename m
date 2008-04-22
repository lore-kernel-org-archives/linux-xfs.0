Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Apr 2008 22:04:37 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3M547Ku003473
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2008 22:04:11 -0700
Date: Tue, 22 Apr 2008 15:04:48 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] Don't initialise new inode generation numbers to zero V2
Message-ID: <20080422050447.GV103491721@sgi.com>
References: <20080422015806.GU108924158@sgi.com> <480D641B.8060301@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480D641B.8060301@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Greg Banks <gnb@melbourne.sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Apr 22, 2008 at 02:05:47PM +1000, Greg Banks wrote:
> David Chinner wrote:
> > Don't initialise new inode generation numbers to zero
> >
> > When we allocation new inode chunks, we initialise the generation
> > numbers to zero. This works fine until we delete a chunk and then
> > reallocate it, resulting in the same inode numbers but with a
> > reset generation count. This can result in inode/generation
> > pairs of different inodes occurring relatively close together.
> >
> > Given that the inode/gen pair makes up the "unique" portion of
> > an NFS filehandle on XFS, this can result in file handles cached
> > on clients being seen on the wire from the server but refer to
> > a different file. This causes .... issues for NFS clients.
> >
> > Hence we need a unique generation number initialisation for
> > each inode to prevent reuse of a small portion of the generation
> > number space. Make this initialiser per-allocation group so
> > that it is not a single point of contention in the filesystem,
> > and increment it on every allocation within an AG to reduce the
> > chance that a generation number is reused for a given inode number
> > if the inode chunk is deleted and reallocated immediately
> > afterwards.
> >
> > Version 2:
> > o remove persistent per-AGI agi_newinogen field and replace with
> >   randomly generated 32 bit number for each new cluster. This prevents
> >   NFS clients from potentially guessing what the next generation
> >   number is going to be.
> >   
> I'm confused, why would an NFS client be trying to guess the generation
> number?  AFAICS the important thing is to ensure that the (inode,gen)
> tuple isn't reused for a long time to prevent accidental filehandle
> identity issues on clients; whether the gen is predictable or not
> doesn't matter at all.

Yeah, that's exactly what I said to Christoph, but that's the issue he
raised w.r.t a malicious client triggering inode/gen collisions
intentionally. If that's not a problem, then I can just use random32()
for the inode number. If it is a real problem, then it needs to be
a cryptographically secure random number. Personally, I don't care
either way - I just want to get the issue fixed.

Christoph, care to explain how and why this is a problem to everyone?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
