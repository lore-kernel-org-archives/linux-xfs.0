Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Dec 2007 04:29:10 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBICT02P026070
	for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 04:29:02 -0800
Date: Tue, 18 Dec 2007 23:29:00 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Issue with 2.6.23 and drbd 8.0.7
Message-ID: <20071218122900.GK4396912@sgi.com>
References: <20071217143655.chiehahh@trusted.lncsa.com> <20071217220354.GU4396912@sgi.com> <4766F58C.8040000@lncsa.com> <20071217233759.GB4396912@sgi.com> <47678124.80906@lncsa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47678124.80906@lncsa.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Laurent CARON <lcaron@lncsa.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Tue, Dec 18, 2007 at 09:13:24AM +0100, Laurent CARON wrote:
> David Chinner wrote:
> > Hmmm - no real surprises there, but the numbers are well lower than the
> > ~960MB low memory limit. I suspect that there's something at around
> > 2.55am that does a filesystem traversal and that blows out the memory
> > usage of these slab caches and you run out of lowmem...
> 
> Thanks David for this information,
> 
> On the previous setup (same pieces of software), we didn't had that kind
> of problem.
> 
> Do you think that more memory is used while using XFS on a filesystem
> traversal than with ReiserFS (the previous setup used ReiserFS)?

Yes, XFS will use more memory - XFS's inodes are substantially larger
in memory than for reiserfs and so will consume more memory for the
same number of cached inodes.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
