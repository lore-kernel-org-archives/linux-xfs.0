Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Apr 2007 14:49:34 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3NLnWfB014540
	for <xfs@oss.sgi.com>; Mon, 23 Apr 2007 14:49:32 -0700
Date: Mon, 23 Apr 2007 22:27:15 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: review: don't block non-blocking writes when frozen
Message-ID: <20070423212715.GF13572@infradead.org>
References: <20070423002616.GY32602149@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423002616.GY32602149@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Apr 23, 2007 at 10:26:16AM +1000, David Chinner wrote:
> 
> Prevent nfsds for blocking trying to write to a frozen filesystem
> or a filesystem in the process of freezing.

Looks good for trees actually having support for non-blocking file
I/O, which doesn't include mainline.  (So please don't send this
upstead)
