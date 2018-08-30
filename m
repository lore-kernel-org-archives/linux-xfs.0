Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:59734 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726889AbeH3XnJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 30 Aug 2018 19:43:09 -0400
Date: Thu, 30 Aug 2018 15:39:20 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH, RFC] xfs: re-enable FIBMAP on reflink; disable for swap
Message-ID: <20180830193919.GA35751@bfoster>
References: <2eb759e5-2faa-67fd-5c16-c1d8edc42d02@redhat.com>
 <20180830162545.GA26816@lst.de>
 <dbe27763-2e69-6e3a-f769-2528eda54940@redhat.com>
 <20180830163614.GA27069@lst.de>
 <65e818f2-885d-50a4-0d4a-7700c703c2af@sandeen.net>
 <20180830180204.GC2853@bfoster>
 <20180830182849.GA4359@magnolia>
 <10d35380-6f5f-22a5-7b6a-1cfb60c53cfd@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10d35380-6f5f-22a5-7b6a-1cfb60c53cfd@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Aug 30, 2018 at 01:51:56PM -0500, Eric Sandeen wrote:
> On 8/30/18 1:28 PM, Darrick J. Wong wrote:
> > On Thu, Aug 30, 2018 at 02:02:05PM -0400, Brian Foster wrote:
> >> On Thu, Aug 30, 2018 at 11:35:46AM -0500, Eric Sandeen wrote:
> >>> On 8/30/18 11:36 AM, Christoph Hellwig wrote:
> >>>> On Thu, Aug 30, 2018 at 11:31:40AM -0500, Eric Sandeen wrote:
> >>>>> That's no reason to uniquely disallow it for reflinked files, though;
> >>>>> the problem is universal.  It's true for fiemap as well.  So I'm not sure
> >>>>> that's an argument against the patch?
> >>>>
> >>>> fiemap at least tells you an extent is shared, bmap does not.
> >>>
> >>> yes, so bmap is clearly the wrong interface to use if you want to
> >>> write directly to a file's blocks.  But if you know enough to check
> >>> the fiemap shared flag, you know enough to not use fibmap for that purpose...
> >>>
> >>
> >> FWIW, this patch seems reasonable to me. To Christoph's point, I don't
> >> think either interface really grants license to write to the underlying
> >> blocks, so either way it's technically being abused for this purpose.
> >> Unless there's a clear way to return an error for a particular type of
> >> file, I think it's reasonable behavior for fibmap to expose the data it
> >> supports (i.e., block maps) and drop the data it doesn't (reflink
> >> state).
> > 
> > But shared block status isn't something that can be dropped lightly.  If
> > you write to a shared block without realizing it, you'll corrupt every
> > other file that shares the block.
> 
> But there is no circumstance under which it is safe to write to a mapped
> block no matter how you mapped it, tbh.  This is just singling out one case
> of many, and it seems capricious to me.  Other than the blast zone being
> possibly larger for reflinked files ... but I just don't think that's our
> judgement to make here.
> 
> > I prefer to have FIBMAP return errors to *cough* encourage people to use
> > FIEMAP.  If code are going to abuse the FI[BE]MAP interface they could
> > at least abuse the one that gives it enough context to avoid fs
> > corruption.  (A proper fs driver would be preferable, though very
> > difficult).
> > 

I think that's a reasonable option as well..

> > Granted, grub's blocklist code doesn't seem to check for shared blocks
> > when it writes grubenv.... yuck, though TBH I don't have the eye budget
> > to spend on digging through grub2.
> 
> grub2 doesn't even use fiemap or fibmap so I'm not sure it's relevant
> to this decision...
> 
> > Frankly I think FIBMAP comes verrry
> > close to "this API is unfixably stupid and shouldn't be enabled for new
> > use cases and should go away some day".
> So instead if anyone asks we'll just give them a successful response which
> is indistinguishable from a hole.  :(
> 

... but this seems to be the crux of the matter (IMO, at least). If we
can return -ENOTSUPP or whatever, then it can be made obvious that the
user either needs to use fiemap or avoid using reflinked files. ISTM
that what we do now is essentially report an incorrect bmap, which leads
to these subtle bug reports.

I haven't dug into the fibmap code.. does something prevent returning a
legitimate error code?

Brian

> I'm pretty strongly of the opinion that we should give the user what
> they ask for, and not try to intuit their motives for the question.
> 
> -Eric
