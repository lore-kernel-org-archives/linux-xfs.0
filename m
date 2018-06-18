Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:48384 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933134AbeFRLrr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Jun 2018 07:47:47 -0400
Date: Mon, 18 Jun 2018 07:47:45 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 2/2] xfs: use sync buffer I/O for sync delwri queue
 submission
Message-ID: <20180618114744.GA28320@bfoster>
References: <20180613110516.65494-1-bfoster@redhat.com>
 <20180613110516.65494-3-bfoster@redhat.com>
 <20180615112820.GB3230@infradead.org>
 <20180615115334.GC2857@bfoster>
 <20180615121602.GA32099@infradead.org>
 <20180615123956.GD2857@bfoster>
 <20180618112130.GA24243@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180618112130.GA24243@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Mon, Jun 18, 2018 at 04:21:30AM -0700, Christoph Hellwig wrote:
> On Fri, Jun 15, 2018 at 08:39:56AM -0400, Brian Foster wrote:
> > Ok, codewise I don't have much of a preference, but I don't think it's
> > worth redoing the regression testing and lowmem testing and whatnot just
> > to change how the guts are refactored here. What's the endgame?
> 
> Avoid the nasty duplication as much as possible.  I think your patch
> already goes a long way towards that, but I'd rather go all the way.
> 

That's what I figured, thanks.

> > I came
> > up with the following on top of patch 2. Compile tested only, and I can
> > refold the _common() helper back into the caller and invert the
> > nowait logic or whatnot..
> 
> Mostly looks fine, except that it seems pointless to have
> __xfs_buf_submit_common around instead of merging it into the only
> caller.
> 

Yes..

> > +	if (!(bp->b_flags & XBF_ASYNC) && !sync_nowait)
> 
> Also I'd rather pass in a
> 
> 	'bool wait' parameter.
> 
> xfs_buf_submit() would set it based on XBF_ASYNC, and the delwri
> code would just set it to false explicitly.

A patch with the above changes is essentially what I put through some
testing over the weekend. It doesn't look like anything exploded, so
I'll try to get it cleaned up and posted later today.

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
