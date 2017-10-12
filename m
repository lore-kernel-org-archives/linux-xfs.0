Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50828 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751140AbdJLKjP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Oct 2017 06:39:15 -0400
Date: Thu, 12 Oct 2017 06:39:14 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/4] xfs: cancel dirty pages on invalidation
Message-ID: <20171012103914.GA38151@bfoster.bfoster>
References: <20171008235414.13866-1-david@fromorbit.com>
 <20171008235414.13866-5-david@fromorbit.com>
 <20171009142445.GE18663@bfoster.bfoster>
 <20171009204816.GN3666@dastard>
 <20171010122945.GB23057@bfoster.bfoster>
 <20171011000400.GW3666@dastard>
 <20171011090219.GA32909@bfoster.bfoster>
 <20171011115858.GZ3666@dastard>
 <20171011130237.GF32909@bfoster.bfoster>
 <20171012005608.GO15067@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171012005608.GO15067@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 12, 2017 at 11:56:08AM +1100, Dave Chinner wrote:
> On Wed, Oct 11, 2017 at 09:02:38AM -0400, Brian Foster wrote:
> > On Wed, Oct 11, 2017 at 10:58:58PM +1100, Dave Chinner wrote:
> > > On Wed, Oct 11, 2017 at 05:02:20AM -0400, Brian Foster wrote:
> > 
> > > i.e. if xfs_invalidatepage() is trashing the dirty state on the
> > > buffers, then we should also be trashing the dirty state on the page
> > > so they are clean and coherent when passed to xfs_vm_releasepage.
> > > That leaves us with the simple rule in xfs_vm_releasepage():
> > > 
> > > 	Never release a dirty page because they always contain valid
> > > 	data that needs to be written back first.
> > > 
> > > That's what I'm trying to do - move the control decisions to page
> > > level, rather than having them split and, at times, be incoherent
> > > at bufferhead level. We're wanting to get rid of bufferheads so we
> > > should be making decisions in this code based on page state, not
> > > the bufferhead state...
> > > 
> > 
> > That seems reasonable to me. I'm not against this patch if it simplifies
> > our internal logic for dealing with pages, though I'm still kind of
> > wondering why to not do this by simply clearing the page earlier in
> > truncate_complete_page().
> 
> /broken record
> 
> We can't change the generic code because of ext3.
> 
> Yes, it makes no sense that we can't just change the order to skip
> over dirty pages first when you look at the generic code. But the
> reality is we will break ext3 if we do that.
> 

As I mentioned earlier, my understanding of the ext problem is that it
leaves around essentially clean pages with the dirty bit set. I.e., this
is the reason the mm needs to attempt to release such pages on reclaim
and why we need to accommodate that case in ->releasepage(). I don't see
how this is related to this question, which is why the mm can't clear
the page dirty state before it asks a filesystem to invalidate buffers
and release the page.

I'm not sure where the idea that truncating page has to clear buffers
and page state in a particular order for ext comes from. Maybe I just
have too limited an understanding of the issue, but it looks to me that
ext3 basically calls block_invalidatepage() on ->invalidatepage() and
try_to_free_buffers() on ->releasepage() (or jbd2 variants of each that
also mostly seem to care about buffers and don't seem to even consider
page dirty state). IOW, it does pretty much the same thing that XFS does
in this codepath. So "because ext3" doesn't really answer the question.
But again, I don't know ext, so perhaps there's something else going on
there that I'm missing or there is some other general reason not to do
that.

> > That said, I suppose there's an argument to be made to do that locally
> > and perhaps try to push it up the chain once the approach has some soak
> > time.
> 
> That was my argument for a long while, but it's just not feasible
> until someone fixes ext3. We've been advised, instead, to just fix
> the filesystem specific callouts to behave correctly.
> 

If we can't change the mm, for whatever reason (i.e., too risky or just
don't want to deal with it), then fair enough.

Brian

> > Could you at least rewrite the commit log to reflect that this is
> > not a regression and is more of a refactoring/cleanup to effectively
> > elevate page state over bh state (a code comment to that effect probably
> > couldn't hurt either)? Thanks.
> 
> I just went back and re-read the commit message I originally wrote.
> It talks about being "defensive" and "being able to catch the case
> where the page is dirty and should not have bufferheads removed from
> it". There's othing about spurious warnings or regressions in it at all.
> 
> IOWs, it's already saying "use the page state to determine actions
> rather than bufferhead state." Not in those exact words, but it's
> not far off it. I'll rewrite it, but on re-reading the commit
> message I've now got no idea what the problem was in the first
> place. :/
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
