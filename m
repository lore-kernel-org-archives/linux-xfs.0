Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51328 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934550AbeFRLVb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jun 2018 07:21:31 -0400
Date: Mon, 18 Jun 2018 04:21:30 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 2/2] xfs: use sync buffer I/O for sync delwri queue
 submission
Message-ID: <20180618112130.GA24243@infradead.org>
References: <20180613110516.65494-1-bfoster@redhat.com>
 <20180613110516.65494-3-bfoster@redhat.com>
 <20180615112820.GB3230@infradead.org>
 <20180615115334.GC2857@bfoster>
 <20180615121602.GA32099@infradead.org>
 <20180615123956.GD2857@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180615123956.GD2857@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Fri, Jun 15, 2018 at 08:39:56AM -0400, Brian Foster wrote:
> Ok, codewise I don't have much of a preference, but I don't think it's
> worth redoing the regression testing and lowmem testing and whatnot just
> to change how the guts are refactored here. What's the endgame?

Avoid the nasty duplication as much as possible.  I think your patch
already goes a long way towards that, but I'd rather go all the way.

> I came
> up with the following on top of patch 2. Compile tested only, and I can
> refold the _common() helper back into the caller and invert the
> nowait logic or whatnot..

Mostly looks fine, except that it seems pointless to have
__xfs_buf_submit_common around instead of merging it into the only
caller.

> +	if (!(bp->b_flags & XBF_ASYNC) && !sync_nowait)

Also I'd rather pass in a

	'bool wait' parameter.

xfs_buf_submit() would set it based on XBF_ASYNC, and the delwri
code would just set it to false explicitly.
