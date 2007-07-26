Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jul 2007 16:50:43 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6QNobbm003848
	for <xfs@oss.sgi.com>; Thu, 26 Jul 2007 16:50:39 -0700
Date: Fri, 27 Jul 2007 09:50:34 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: RFC: log record CRC validation
Message-ID: <20070726235034.GN12413810@sgi.com>
References: <20070725092445.GT12413810@sgi.com> <46A7226D.8080906@sgi.com> <20070726055501.GF12413810@sgi.com> <p731weusrb8.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p731weusrb8.fsf@bingen.suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andi Kleen <andi@firstfloor.org>
Cc: David Chinner <dgc@sgi.com>, Mark Goodwin <markgw@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Jul 27, 2007 at 01:01:15AM +0200, Andi Kleen wrote:
> David Chinner <dgc@sgi.com> writes:
> > 
> > Nope. To do that, we'd need to implement some type of Reed-Solomon
> > coding and would need to use more bits on disk to store the ECC
> > data. That would have a much bigger impact on log throughput than a
> > table based CRC on a chunk of data that is hot in the CPU cache. 
> 
> Processing or rewriting cache hot data shouldn't be significantly
> different in cost (assuming the basic CPU usage of the algorithms
> is not too different); just the cache lines need to be already exclusive
> which is likely the case with logs.

*nod*

> > And we'd have to write the code as well. ;)
> 
> Modern kernels have R-S functions in lib/reed_solomon. They
> are used in some of the flash file systems. I haven't checked
> how their performance compares to standard CRC though.

Ah, I didn't know that. I'll have a look at it....

Admittedly I didn't look all that hard because:

> > However, I'm not convinced that this sort of error correction is the
> > best thing to do at a high level as all the low level storage
> > already does Reed-Solomon based bit error correction.  I'd much
> > prefer to use a different method of redundancy in the filesystem so
> > the error detection and correction schemes at different levels don't
> > have the same weaknesses.
> 
> Agreed. On the file system level the best way to handle this is 
> likely data duplicated on different blocks.

Yes, something like that. I haven't looked into all the potential
ways of providing redundancy yet - I'm still focussing on making
error detection more effective.

> > That means the filesystem needs strong enough CRCs to detect bit
> > errors and sufficient structure validity checking to detect gross
> > errors.  XFS already does pretty good structure checking; we don't
> 
> The trouble is that it tends to go to too drastic measures (shutdown) if it
> detects any inconsistency.

IMO, that's not drastic - it's the only sane thing to do in the
absence of redundant metadata that you can use to recover from.  To
continue operations on a known corrupted filesystem risks making it
far, far worse, esp. if the corruption is in something like a free
space btree.

However, solving this is a separable problem - reliable error
correction comes after robust error detection....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
