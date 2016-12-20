Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34506 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935110AbcLTORt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Dec 2016 09:17:49 -0500
Date: Tue, 20 Dec 2016 09:17:47 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/4] xfs: fix bogus minleft manipulations
Message-ID: <20161220141747.GA25290@bfoster.bfoster>
References: <1481644767-9098-1-git-send-email-hch@lst.de>
 <1481644767-9098-2-git-send-email-hch@lst.de>
 <20161214173507.GA24645@bfoster.bfoster>
 <20161214193626.GA12106@lst.de>
 <20161214215133.GA26688@bfoster.bfoster>
 <20161215143430.GB29477@bfoster.bfoster>
 <20161219113826.GA26535@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161219113826.GA26535@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, eguan@redhat.com, darrick.wong@oracle.com

On Mon, Dec 19, 2016 at 12:38:26PM +0100, Christoph Hellwig wrote:
> On Thu, Dec 15, 2016 at 09:34:33AM -0500, Brian Foster wrote:
> > FWIW, I was playing with this a bit more and managed to manufacture a
> > filesystem layout that this series doesn't handle too well. Emphasis on
> > "manufactured" because this might not be a likely real world scenario,
> > but either way the current code handles it fine.
> 
> It does, although mostly by accident.  I suspect with an even better
> manufcatured image you could also drive the current code to it's knees,
> e.g. only have one single block free in the first few AGs, and then
> a small number just higher than that in a higher AG.
> 

Perhaps, I certainly wouldn't expect the code in current form to be
perfect. It's hard enough to understand as it is. Just trying to avoid
regressions and properly scope the required fix...

> > I've attached a metadump of the offending image. mdestore it, mount and
> > attempt something like 'dd if=/dev/zero of=/mnt/file' on the root. The
> > buffered write looks like it's in a livelock, waiting indefinitely for a
> > writeback cycle that will never complete...
> 
> Yeah, that's the loop that keeps going even if it can't allocate any
> blocks, which seems generally bogus.  But even without that we'd get
> ENOSPC despite not having a reservations. Which is a little easier to
> debug, but just as wrong.
> 

Indeed.

> The only good way out I can see is to not hand out any more reservations
> after we only nave nr_ags * xfs_bmap_worst_indlen(1) available.  I'll
> see if I can come up with a patch for that.

Hmm, so the idea is to basically find a way we can infer accurate
information about the per-AG state at the time blocks are reserved from
the global pool (i.e., buffered write time) and cut off writes at the
point we can no longer guarantee at least one AG can satisfy the
smallest write..?

If so, that seems reasonable to me in principle. I'd have to think about
it a bit more. The first question that comes to mind is that we'd have
to make sure all allocations honor the minleft heuristic, yes? (Or
perhaps not allow any allocations after this point?) Otherwise, what
prevents the assumption of (available > nr_ags *
xfs_bmap_worst_indlen(1)) from becoming false after the reservation has
been granted but before the physical allocation is attempted at
writeback time? E.g., write/reserve the last available delalloc block,
then chew up the remaining minleft in each AG via sparse inode allocs or
something (for example), then writeback occurs and can't find an AG to
honor minleft (??).

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
