Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 22 May 2008 21:58:30 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4N4wOrp005452
	for <xfs@oss.sgi.com>; Thu, 22 May 2008 21:58:27 -0700
Date: Fri, 23 May 2008 00:59:13 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] xfsqa test to check log size scaling
Message-ID: <20080523045912.GA12194@infradead.org>
References: <20080522061257.GR173056135@sgi.com> <20080522132542.GC4972@infradead.org> <20080522221252.GV173056135@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080522221252.GV173056135@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, May 23, 2008 at 08:12:52AM +1000, David Chinner wrote:
> On Thu, May 22, 2008 at 09:25:42AM -0400, Christoph Hellwig wrote:
> > On Thu, May 22, 2008 at 04:12:57PM +1000, David Chinner wrote:
> > > XFS-QA test to check that log size scaling works correctly
> > > for old and new maximum log sizes.
> > 
> > Am I missing somethign or would this fail if the partitions used for
> > xfsqa are smaller than 256GB?  I don't even have that much total storage
> > on my laptop :)
> 
> Uses loop devices and sparse files - should work just fine on any partition a
> bit over 2GB (the log gets zeroed during mkfs). I know it passses on a 14GB
> scratch filesystem....

Okay for the patch then.
