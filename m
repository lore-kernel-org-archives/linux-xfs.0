Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54962 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727784AbeKJB1S (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Nov 2018 20:27:18 -0500
Date: Fri, 9 Nov 2018 10:46:09 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: defer online discard submission to a workqueue
Message-ID: <20181109154608.GB5572@bfoster>
References: <20181105181021.8174-1-bfoster@redhat.com>
 <20181105215139.GA3160@infradead.org>
 <20181106142310.GA2773@bfoster>
 <20181109150610.GB9153@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181109150610.GB9153@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Fri, Nov 09, 2018 at 07:06:10AM -0800, Christoph Hellwig wrote:
> On Tue, Nov 06, 2018 at 09:23:11AM -0500, Brian Foster wrote:
> > My
> > understanding is that these discards can stack up and take enough time
> > that a limit on outstanding discards is required, which now that I think
> > of it makes me somewhat skeptical of the whole serial execution thing.
> > Hitting that outstanding discard request limit is what bubbles up the
> > stack and affects XFS by holding up log forces, since new discard
> > submissions are presumably blocked on completion of the oldest
> > outstanding request.
> 
> We don't do strict ordering or request, but eventually requests
> waiting for completion will block others from being submitted.
> 

Ok, that's kind of what I expected.

> > I'm not quite sure what happens in the block layer if that limit were
> > lifted. Perhaps it assumes throttling responsibility directly via
> > queues/plugs? I'd guess that at minimum we'd end up blocking indirectly
> > somewhere (via memory allocation pressure?) anyways, so ISTM that some
> > kind of throttling is inevitable in this situation. What am I missing?
> 
> We'll still block new allocations waiting for these blocks and
> other bits.  Or to put it another way - if your discard implementation
> is slow (independent of synchronous or not) your are going to be in
> a world of pain with online discard.  That is what it's not default
> to start with.

Sure, it's not really the XFS bits I was asking about here. This is
certainly not a high priority and not a common use case. We're working
through some of the other issues in the other sub-thread. In particular,
I'm wondering if we can provide broader improvements to the overall
mechanism to reduce some of that pain.

Brian
