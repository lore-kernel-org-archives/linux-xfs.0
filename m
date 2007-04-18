Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Apr 2007 16:51:14 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3INp8fB014489
	for <xfs@oss.sgi.com>; Wed, 18 Apr 2007 16:51:10 -0700
Date: Thu, 19 Apr 2007 09:50:56 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] remove various useless min/max macros
Message-ID: <20070418235056.GJ48531920@melbourne.sgi.com>
References: <20070418175730.GA18315@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070418175730.GA18315@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Wed, Apr 18, 2007 at 07:57:30PM +0200, Christoph Hellwig wrote:
> xfs_btree.h has various macros to calculate a min/max after casting
> it's arguments to a specific type.  This can be done much simpler
> by using min_t/max_t with the type as first argument.

Sure, but I NACKed that last October for good reason.

http://marc.info/?t=116116017600003&r=1&w=2

Specifically:

http://marc.info/?l=linux-kernel&m=116122285309389&w=2

I still have no objection to changing the implementation of these
macros or even changing them to non-shouting static inlines but
I don't want them removed....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
