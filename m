Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40518 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751052AbeEIMBw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 9 May 2018 08:01:52 -0400
Date: Wed, 9 May 2018 08:01:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 1/3] xfs: add bmapi nodiscard flag
Message-ID: <20180509120150.GA65322@bfoster.bfoster>
References: <20180508172231.53570-1-bfoster@redhat.com>
 <20180508172231.53570-2-bfoster@redhat.com>
 <20180509074629.GC19933@infradead.org>
 <20180509105853.GD64624@bfoster.bfoster>
 <20180509113942.GA17093@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180509113942.GA17093@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>

On Wed, May 09, 2018 at 04:39:42AM -0700, Christoph Hellwig wrote:
> > I deliberately went away from that approach based on Dave's feedback
> > (similarly with the xfs_itruncate_extents() comment in the subsequent
> > patch). I used the bool that is used here rather than pass the flag
> > directly, but it's essentially the same idea in terms of exposing the
> > function signature change to callers.
> 
> I haven't had time to catch up on the previous iterations, sorry.
> 
> > 
> > TBH, I don't much care which of the N possible variants of code
> > factoring we use here, but I think we're officially bikeshedding once
> > the feedback starts to go in circles as such. ;) So unless I see some
> > broader/mutual agreement (or a strong preference from the maintainer) on
> > a change back to something like the original factoring (perhaps using a
> > flag instead of a bool), I'm going to assume changing it back will
> > simply reintroduce the previous feedback and leave this as is.
> 
> FYI, I really hate trivial rappers that just hide a single argument.
> There are a few use cases for them, mostly because the API has a lot
> of pre-existing callers that don't care and it would create too much
> churn.  But creating wrappers for both possible arguments of a bool
> is just silly.
> 

Reasonable argument, for sure...

> Also in general bools can be ver confusing, especially once we grow
> more than one in a given prototype.  If we already only use it to set
> a flag deeper down I much, much prefer to expose the flag as it is
> self-documenting, very much unlike a 'true' or 'false' argument.

I'm fine with replacing the bool argument(s) with flags where applicable
if we do eliminate the wrappers. I'm just hesitant to change it given
the previous feedback to move away from something very close..

Dave, care to chime in here? As mentioned, I'll do a refactored v3 if
there's some kind of consensus/agreement on a final approach.

Brian
