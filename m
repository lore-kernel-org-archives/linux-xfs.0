Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Apr 2007 14:49:43 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3NLnefB014695
	for <xfs@oss.sgi.com>; Mon, 23 Apr 2007 14:49:41 -0700
Date: Mon, 23 Apr 2007 22:23:36 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: review: handle barriers being switched off dynamically.
Message-ID: <20070423212336.GC13572@infradead.org>
References: <20070419073714.GU48531920@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070419073714.GU48531920@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Apr 19, 2007 at 05:37:14PM +1000, David Chinner wrote:
> 
> As pointed out by Neil Brown, MD can switch barriers off
> dynamically underneath a mounted filesystem. If this happens
> to XFS, it will shutdown the filesystem immediately.
> 
> Handle this more sanely by yelling into the syslog, retrying
> the I/O without barriers and if that is successful, turn
> off barriers.
> 
> Also remove an unnecessary check when first checking to
> see if the underlying device supports barriers.

Looks good to me (well, not really good, but as good as it can
be given the circumstances..)

> +	/*
> +	 * We can get an EOPNOTSUPP to ordered writes.  Here we clear the
> +	 * ordered flag and reissue them.  Because we can't tell the higher
> +	 * layers directly that they should not issue ordered I/O anymore, they
> +	 * need to check if the ordered flag was cleared during I/O completion.
> +	 */
> +	if ((bp->b_error == EOPNOTSUPP) &&

no need for the additional braces here, though.
