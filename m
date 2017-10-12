Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:58653 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752692AbdJLA4M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2017 20:56:12 -0400
Date: Thu, 12 Oct 2017 11:56:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] xfs: cancel dirty pages on invalidation
Message-ID: <20171012005608.GO15067@dastard>
References: <20171008235414.13866-1-david@fromorbit.com>
 <20171008235414.13866-5-david@fromorbit.com>
 <20171009142445.GE18663@bfoster.bfoster>
 <20171009204816.GN3666@dastard>
 <20171010122945.GB23057@bfoster.bfoster>
 <20171011000400.GW3666@dastard>
 <20171011090219.GA32909@bfoster.bfoster>
 <20171011115858.GZ3666@dastard>
 <20171011130237.GF32909@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171011130237.GF32909@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2017 at 09:02:38AM -0400, Brian Foster wrote:
> On Wed, Oct 11, 2017 at 10:58:58PM +1100, Dave Chinner wrote:
> > On Wed, Oct 11, 2017 at 05:02:20AM -0400, Brian Foster wrote:
> 
> > i.e. if xfs_invalidatepage() is trashing the dirty state on the
> > buffers, then we should also be trashing the dirty state on the page
> > so they are clean and coherent when passed to xfs_vm_releasepage.
> > That leaves us with the simple rule in xfs_vm_releasepage():
> > 
> > 	Never release a dirty page because they always contain valid
> > 	data that needs to be written back first.
> > 
> > That's what I'm trying to do - move the control decisions to page
> > level, rather than having them split and, at times, be incoherent
> > at bufferhead level. We're wanting to get rid of bufferheads so we
> > should be making decisions in this code based on page state, not
> > the bufferhead state...
> > 
> 
> That seems reasonable to me. I'm not against this patch if it simplifies
> our internal logic for dealing with pages, though I'm still kind of
> wondering why to not do this by simply clearing the page earlier in
> truncate_complete_page().

/broken record

We can't change the generic code because of ext3.

Yes, it makes no sense that we can't just change the order to skip
over dirty pages first when you look at the generic code. But the
reality is we will break ext3 if we do that.

> That said, I suppose there's an argument to be made to do that locally
> and perhaps try to push it up the chain once the approach has some soak
> time.

That was my argument for a long while, but it's just not feasible
until someone fixes ext3. We've been advised, instead, to just fix
the filesystem specific callouts to behave correctly.

> Could you at least rewrite the commit log to reflect that this is
> not a regression and is more of a refactoring/cleanup to effectively
> elevate page state over bh state (a code comment to that effect probably
> couldn't hurt either)? Thanks.

I just went back and re-read the commit message I originally wrote.
It talks about being "defensive" and "being able to catch the case
where the page is dirty and should not have bufferheads removed from
it". There's othing about spurious warnings or regressions in it at all.

IOWs, it's already saying "use the page state to determine actions
rather than bufferhead state." Not in those exact words, but it's
not far off it. I'll rewrite it, but on re-reading the commit
message I've now got no idea what the problem was in the first
place. :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
