Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Apr 2008 22:33:49 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3O5XTHE018652
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2008 22:33:31 -0700
Date: Thu, 24 Apr 2008 15:33:58 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS drops create/delete files to 6.6% of EXT3 (software raid) and to 0.6% of EXT3 (3ware hardware raid)
Message-ID: <20080424053358.GW103491721@sgi.com>
References: <c33e4330804231848n72ce683cqd48a8d45937f302@mail.gmail.com> <4810062F.50100@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4810062F.50100@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Michael Darling <darlingm@gmail.com>, xfs@oss.sgi.com

On Wed, Apr 23, 2008 at 11:01:51PM -0500, Eric Sandeen wrote:
> Michael Darling wrote:
> > I am preparing a new server, and benchmarking EXT3 against XFS, both using
> > software RAID and hardware RAID using a 3ware 9650SE-4LPML.
> > 
> > Using bonnie++ as a benchmark, I am seeing significant performance boosts in
> > my block sequential reads and writes moving from EXT3 to XFS.  I am aware
> > that XFS won't create and delete files as quickly as EXT3, however I am
> > seeing drops from 29455/second to 1957/second using software RAID, and from
> > 32524/second to 189/second using hardware RAID.  I'm not sure if when using
> > software raid, if creating and deleting files should drop to 6.6% of EXT3.
> > But, what I'm pretty sure of, is when using hardware raid, that creating and
> > deleting files shouldn't drop to 0.6% of EXT3.
> 
> So I played with this a little on 2.6.25, on plain partitions.
> 
> I saw similar numbers; for example, sequential creates:
> 
> ext3:		23698/s
> xfs:		  319/s
> xfs,nobarrier:	 4478/s

And with logbsize=256k?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
