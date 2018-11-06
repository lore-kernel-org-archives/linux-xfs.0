Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54314 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729642AbeKFXsk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Nov 2018 18:48:40 -0500
Date: Tue, 6 Nov 2018 09:23:11 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: defer online discard submission to a workqueue
Message-ID: <20181106142310.GA2773@bfoster>
References: <20181105181021.8174-1-bfoster@redhat.com>
 <20181105215139.GA3160@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181105215139.GA3160@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Mon, Nov 05, 2018 at 01:51:39PM -0800, Christoph Hellwig wrote:
> On Mon, Nov 05, 2018 at 01:10:21PM -0500, Brian Foster wrote:
> > When online discard is enabled, discards of busy extents are
> > submitted asynchronously as a bio chain. bio completion and
> > resulting busy extent cleanup is deferred to a workqueue. Async
> > discard submission is intended to avoid blocking log forces on a
> > full discard sequence which can take a noticeable amount of time in
> > some cases.
> > 
> > We've had reports of this still producing log force stalls with XFS
> > on VDO,
> 
> Please fix this in VDO instead.  We should not work around out of
> tree code making stupid decisions.

I assume the "stupid decision" refers to sync discard execution. I'm not
familiar with the internals of VDO, this is just what I was told. My
understanding is that these discards can stack up and take enough time
that a limit on outstanding discards is required, which now that I think
of it makes me somewhat skeptical of the whole serial execution thing.
Hitting that outstanding discard request limit is what bubbles up the
stack and affects XFS by holding up log forces, since new discard
submissions are presumably blocked on completion of the oldest
outstanding request.

I'm not quite sure what happens in the block layer if that limit were
lifted. Perhaps it assumes throttling responsibility directly via
queues/plugs? I'd guess that at minimum we'd end up blocking indirectly
somewhere (via memory allocation pressure?) anyways, so ISTM that some
kind of throttling is inevitable in this situation. What am I missing?

Brian
