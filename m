Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 25 Jul 2007 22:55:15 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6Q5t4bm014960
	for <xfs@oss.sgi.com>; Wed, 25 Jul 2007 22:55:07 -0700
Date: Thu, 26 Jul 2007 15:55:01 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: RFC: log record CRC validation
Message-ID: <20070726055501.GF12413810@sgi.com>
References: <20070725092445.GT12413810@sgi.com> <46A7226D.8080906@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A7226D.8080906@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Goodwin <markgw@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Jul 25, 2007 at 08:14:05PM +1000, Mark Goodwin wrote:
> 
> 
> David Chinner wrote:
> >
> >The next question is the hard one. What do we do when we detect
> >a log record CRC error? Right now it just warns and sets a flag
> >in the log. I think it should probably prevent log replay from
> >replaying past this point (i.e. trim the head back to the last
> >good log record) but I'm not sure what the best thing to do here.
> >
> >Comments?
> 
> 1. perhaps use a new flag XLOG_CRC_MISMATCH instead of XLOG_CHKSUM_MISMATCH

Yeah, that's easy to do. What to do with the error is more important,
though.

> 2. is there (or could there be if we added it), correction for n-bit errors?

Nope. To do that, we'd need to implement some type of Reed-Solomon
coding and would need to use more bits on disk to store the ECC
data. That would have a much bigger impact on log throughput than a
table based CRC on a chunk of data that is hot in the CPU cache. And
we'd have to write the code as well. ;)

However, I'm not convinced that this sort of error correction is the
best thing to do at a high level as all the low level storage
already does Reed-Solomon based bit error correction.  I'd much
prefer to use a different method of redundancy in the filesystem so
the error detection and correction schemes at different levels don't
have the same weaknesses.

That means the filesystem needs strong enough CRCs to detect bit
errors and sufficient structure validity checking to detect gross
errors.  XFS already does pretty good structure checking; we don't
have bit error detection though....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
