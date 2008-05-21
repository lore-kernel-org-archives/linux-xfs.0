Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 May 2008 23:00:25 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4L60MuV026396
	for <xfs@oss.sgi.com>; Tue, 20 May 2008 23:00:22 -0700
Date: Wed, 21 May 2008 08:01:03 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] streamline init/exit path
Message-ID: <20080521060103.GA25003@lst.de>
References: <20080518130511.GA28501@lst.de> <nccprrg32vr.fsf@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nccprrg32vr.fsf@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Wed, May 21, 2008 at 10:41:12AM +1000, Niv Sardi wrote:
> Looks good, appart from the fact that I don't see the point of merging
> xfs_{init,destroy}_zones into xfs_{init,exit}, appart from clobbering it
> and making it less readeable.
> 
> could be:
> error = xfs_init_zones();
> if (error)
>       goto out;
> 
> and all the other error cases will end with
> xfs_destroy_zones();
> 
> That would look much more like the rest of the calls in these functions.

I don't really see the point for splitting this up, it's not like it
makes the initialization much simpler.  But hey, if that's the only
objection I can changed it.

At least someone is looking at my xfs patches :)
