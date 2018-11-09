Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55728 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727781AbeKJArH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Nov 2018 19:47:07 -0500
Date: Fri, 9 Nov 2018 07:06:10 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: defer online discard submission to a workqueue
Message-ID: <20181109150610.GB9153@infradead.org>
References: <20181105181021.8174-1-bfoster@redhat.com>
 <20181105215139.GA3160@infradead.org>
 <20181106142310.GA2773@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181106142310.GA2773@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Tue, Nov 06, 2018 at 09:23:11AM -0500, Brian Foster wrote:
> My
> understanding is that these discards can stack up and take enough time
> that a limit on outstanding discards is required, which now that I think
> of it makes me somewhat skeptical of the whole serial execution thing.
> Hitting that outstanding discard request limit is what bubbles up the
> stack and affects XFS by holding up log forces, since new discard
> submissions are presumably blocked on completion of the oldest
> outstanding request.

We don't do strict ordering or request, but eventually requests
waiting for completion will block others from being submitted.

> I'm not quite sure what happens in the block layer if that limit were
> lifted. Perhaps it assumes throttling responsibility directly via
> queues/plugs? I'd guess that at minimum we'd end up blocking indirectly
> somewhere (via memory allocation pressure?) anyways, so ISTM that some
> kind of throttling is inevitable in this situation. What am I missing?

We'll still block new allocations waiting for these blocks and
other bits.  Or to put it another way - if your discard implementation
is slow (independent of synchronous or not) your are going to be in
a world of pain with online discard.  That is what it's not default
to start with.
