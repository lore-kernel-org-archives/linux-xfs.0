Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 22 May 2008 15:12:18 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4MMCAOe022826
	for <xfs@oss.sgi.com>; Thu, 22 May 2008 15:12:12 -0700
Date: Fri, 23 May 2008 08:12:52 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [patch] xfsqa test to check log size scaling
Message-ID: <20080522221252.GV173056135@sgi.com>
References: <20080522061257.GR173056135@sgi.com> <20080522132542.GC4972@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080522132542.GC4972@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, May 22, 2008 at 09:25:42AM -0400, Christoph Hellwig wrote:
> On Thu, May 22, 2008 at 04:12:57PM +1000, David Chinner wrote:
> > XFS-QA test to check that log size scaling works correctly
> > for old and new maximum log sizes.
> 
> Am I missing somethign or would this fail if the partitions used for
> xfsqa are smaller than 256GB?  I don't even have that much total storage
> on my laptop :)

Uses loop devices and sparse files - should work just fine on any partition a
bit over 2GB (the log gets zeroed during mkfs). I know it passses on a 14GB
scratch filesystem....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
