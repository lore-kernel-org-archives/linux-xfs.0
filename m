Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 02 Feb 2007 04:25:21 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l12COlqw007246
	for <xfs@oss.sgi.com>; Fri, 2 Feb 2007 04:24:48 -0800
Date: Fri, 2 Feb 2007 11:48:30 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Review: Don't use kmap() in xfs_iozero().
Message-ID: <20070202114830.GB23187@infradead.org>
References: <20070202054044.GO33919298@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070202054044.GO33919298@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev@sgi.com, xfs@oss.sgi.com

On Fri, Feb 02, 2007 at 04:40:44PM +1100, David Chinner wrote:
> kmap is inefficient and does scale well. kmap_atomic() is a better
> choice. Use the generic wrapper function instead of open coding the
> kmap-memset-dcache flush-kumap stuff.  Suggested by Andrew Morton.
> 
> Comments?

Looks good.

> +		memclear_highpage_flush(page, (unsigned int)offset, bytes);

Do you need the cast here?  An unsigned long should be automatically
demoted to an unsigned int when passing it as an argument.
