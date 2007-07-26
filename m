Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jul 2007 15:06:31 -0700 (PDT)
Received: from mx1.suse.de (mx1.suse.de [195.135.220.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6QM6Qbm010704
	for <xfs@oss.sgi.com>; Thu, 26 Jul 2007 15:06:27 -0700
Subject: Re: RFC: log record CRC validation
References: <20070725092445.GT12413810@sgi.com> <46A7226D.8080906@sgi.com>
	<20070726055501.GF12413810@sgi.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 27 Jul 2007 01:01:15 +0200
In-Reply-To: <20070726055501.GF12413810@sgi.com>
Message-ID: <p731weusrb8.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Mark Goodwin <markgw@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

David Chinner <dgc@sgi.com> writes:
> 
> Nope. To do that, we'd need to implement some type of Reed-Solomon
> coding and would need to use more bits on disk to store the ECC
> data. That would have a much bigger impact on log throughput than a
> table based CRC on a chunk of data that is hot in the CPU cache. 

Processing or rewriting cache hot data shouldn't be significantly
different in cost (assuming the basic CPU usage of the algorithms
is not too different); just the cache lines need to be already exclusive
which is likely the case with logs.

> And we'd have to write the code as well. ;)

Modern kernels have R-S functions in lib/reed_solomon. They
are used in some of the flash file systems. I haven't checked
how their performance compares to standard CRC though.

> 
> However, I'm not convinced that this sort of error correction is the
> best thing to do at a high level as all the low level storage
> already does Reed-Solomon based bit error correction.  I'd much
> prefer to use a different method of redundancy in the filesystem so
> the error detection and correction schemes at different levels don't
> have the same weaknesses.

Agreed. On the file system level the best way to handle this is 
likely data duplicated on different blocks.

> That means the filesystem needs strong enough CRCs to detect bit
> errors and sufficient structure validity checking to detect gross
> errors.  XFS already does pretty good structure checking; we don't

The trouble is that it tends to go to too drastic measures (shutdown) if it
detects any inconsistency.

-Andi
