Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:39132 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403902AbfHBIMX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Aug 2019 04:12:23 -0400
Date: Fri, 2 Aug 2019 01:12:21 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/24] xfs: don't allow log IO to be throttled
Message-ID: <20190802081221.GA15849@infradead.org>
References: <20190801021752.4986-1-david@fromorbit.com>
 <20190801021752.4986-10-david@fromorbit.com>
 <F1E7CC65-D2CB-4078-9AA3-9D172ECDE17B@fb.com>
 <20190801235849.GO7777@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801235849.GO7777@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Chris Mason <clm@fb.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>

On Fri, Aug 02, 2019 at 09:58:49AM +1000, Dave Chinner wrote:
> Which simply reinforces the fact that that request type based
> throttling is a fundamentally broken architecture.
> 
> > It feels awkward to have one set of prio inversion workarounds for io.* 
> > and another for wbt.  Jens, should we make an explicit one that doesn't 
> > rely on magic side effects, or just decide that metadata is meta enough 
> > to break all the rules?
> 
> The problem isn't REQ_META blows throw the throttling, the problem
> is that different REQ_META IOs have different priority.
> 
> IOWs, the problem here is that we are trying to infer priority from
> the request type rather than an actual priority assigned by the
> submitter. There is no way direct IO has higher priority in a
> filesystem than log IO tagged with REQ_META as direct IO can require
> log IO to make progress. Priority is a policy determined by the
> submitter, not the mechanism doing the throttling.
> 
> Can we please move this all over to priorites based on
> bio->b_ioprio? And then document how the range of priorities are
> managed, such as:

Yes, we need to fix the magic deducted throttling behavior, especiall
the odd REQ_IDLE that in its various incarnations has been a massive
source of toruble and confusion.  Not sure tons of priorities are
really helping, given that even hardware with priority level support
usually just supports about two priorit levels.
