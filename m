Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 01 Aug 2007 03:03:16 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l71A39bm006777
	for <xfs@oss.sgi.com>; Wed, 1 Aug 2007 03:03:13 -0700
Date: Wed, 1 Aug 2007 20:02:58 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: RFC: log record CRC validation
Message-ID: <20070801100258.GV31489@sgi.com>
References: <20070725092445.GT12413810@sgi.com> <46A7226D.8080906@sgi.com> <46A8DF7E.4090006@agami.com> <20070726233129.GM12413810@sgi.com> <46AAA340.60208@agami.com> <20070731053048.GP31489@sgi.com> <46AFE2CB.6080102@agami.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46AFE2CB.6080102@agami.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "William J. Earl" <earl@agami.com>
Cc: David Chinner <dgc@sgi.com>, xfs-oss <xfs@oss.sgi.com>, Michael Nishimoto <miken@agami.com>, markgw@sgi.com

On Tue, Jul 31, 2007 at 06:32:59PM -0700, William J. Earl wrote:
> David Chinner wrote:
> >IMO, continuing down this same "the block device is perfect" path is
> >a "head in the sand" approach.  By ignoring the fact that errors can
> >and do occur, we're screwing ourselves when something does actually
> >go wrong because we haven't put in place the mechanisms to detect
> >errors because we've assumed they will never happen.
> >
> >We've spent 15 years so far trying to work out what has gone wrong
> >in XFS by adding more and more reactive debug into the code without
> >an eye to a robust solution. We add a chunk of code here to detect
> >that problem, a chunk of code there to detect this problem, and so
> >on. It's just not good enough anymore.
> >
> >Like good security, filesystem integrity is not provided by a single
> >mechanism. "Defense in depth" is what we are aiming to provide here
> >and to do that you have to assume that errors can propagate through
> >every interface into the filesystem.
> >
> >
> >  
>          I understand your argument, but why not simply strengthen the 
> block layer, even you do it with an optional XFS-based checksum scheme 
> on all blocks?

You could probably do this using dm-crypt and an integrity hash.

Unfortunately, I don't trust dm-crypt as far as I can throw it
because we've been severely bitten by bugs in dm-crypt. Specifically
the bug that existed from 2.6.14 through to 2.6.19 where it reported
success to readahead bios that had been cancelled due to block
device congestion and hence returning uninitialised bios as
"complete" and error free. This resulted in XFS shutdowns because
the only code in the entire of Linux that triggered this problem was
the XFS btree readahead. Every time this occurred the finger was
pointed at XFS because it detected the corruption and we had *zero*
information telling us what the problem might have been. A btree
block CRC failure would have *immediately* told us the block layer
had returned us bad data.

This is where I come back to defense in depth. Block device level
integrity checking is not sufficient as bugs in this layer still
need to be caught by the filesystem. I stand by this even if I
implemented the block layer code myself - I don't write perfect code
and nobody else does, either. Hence we *must* assume that the layer
that returned the block is imperfect even if we wrote it....

> That way, you would not wind up detecting metadata 
> corruption and silently ignoring file data corruption

Data integrity has different selection criteria compared to ensuring
structural integrity of the filesystem. That is, different users have
different requirements for data integrity and performance. e.g. bit
errors in video and audio data don't matter but performance does,
yet we still need to protect the filesystem metadata against the
same bit errors.

Hence, IMO, we really do need to treat them seperately to retain
flexibility in the filesystem for different applications. I would
prefer to aim for per-inode selection of data CRCs and allow
inheritance of the attribute through the directory heirachy. That
way the behaviour is user selectable for the subset of the files
that the system owner cares about enough to protect. If you
want to protect the entire filesystem, set the flag on the
root directory at mkfs time....

> For example, 
> suppose you stole one block in N (where you might choose N according to 
> the RAID data stripe size, when running over MD), and used it as a 
> checksum block (storing (N-1)*K subblock checksums)? This in effect
> would require either RAID full-stripe read-modify-write or at least an 
> extra block read-modify-write for a real block write, but it would give 
> you complete metadata and data integrity checking.   This could be an 
> XFS feature or a new MD feature ("checksum" layer).  

dm-crypt. But, see above.

>         This would clearly be somewhat expensive for random writes, 
> much like RAID 6, and also expensive for random reads, unless the N were 
> equal to the RAID block size, but, as with the NetApp and Tandem 
> software checksums, it would assure that a high level of data integrity.   

Good integrity, but random writes is one of XFS's weaknesses
and this would just make it worse. Netapp leverages both WAFL's
linearisation of random writes and specialised hardware (NVRAM)
to avoid this performance proble altogether but we can't. It's
a showstopper, IMO.

No matter which way I look at it, block layer integrity checking
provides insufficient correctness guarantees while neutralising
XFS's strengths and magnifying it's weaknesses. To me it just doesn't
make sense for XFS to go down this path when there are other
options that don't have these drawbacks.

Basically, it makes much more sense to me to break the problem down
into it's component pieces and provide protection for each of those
pieces one at a time without introducing new issues. This way we
don't compromise the strengths of XFS or reduce the flexibility of
the filesystem in any way whilst providing better protection against
errors that cause corruption.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
