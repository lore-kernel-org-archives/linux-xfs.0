Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:29587 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725913AbfAXWTU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Jan 2019 17:19:20 -0500
Date: Fri, 25 Jan 2019 09:19:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] xfs: support magic value in xfs_buf_ops
Message-ID: <20190124221917.GN4205@dastard>
References: <20190124155440.46469-1-bfoster@redhat.com>
 <20190124190846.GC4368@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190124190846.GC4368@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Thu, Jan 24, 2019 at 11:08:46AM -0800, Darrick J. Wong wrote:
> On Thu, Jan 24, 2019 at 10:54:40AM -0500, Brian Foster wrote:
> > Add a field to specify the v4 and v5 magic values in xfs_buf_ops.
> > This allows otherwise identical verifiers to distinguish between
> > and verify different magic values (inobt vs. finobt buffers). This
> > also facilitates verification of the appropriate magic value based
> > on superblock version.
> > 
> > The magic field is optional and is free to be used as appropriate
> > for each particular verifier.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > Hi all,
> > 
> > What do folks think of something like this as a lightweight (and
> > untested) means to do proper [f]inobt magic verification? For reference,
> > the initial version of this put together to help root cause a user
> > report is here[1]. I was hoping to do the same thing with less code
> > duplication. A couple things that come to mind:
> > 
> > 1. I know scrub has at least one place where we invoke the verifier with
> > ->b_ops == NULL, which will cause this to explode. Could we fix that up
> > to assign and reset ->b_ops to accommodate something like this, or is
> > that problematic?
> 
> IIRC one of the scrub findroot reviewers didn't like the idea of scrub
> setting b_ops until it was absolutely sure it wanted to.  I think it's
> actually ok to patch it in temporarily while running the read verifier
> since we have the buffer locked and patch it out afterwards.

How does this interact with xfs_buf_ensure_ops()?

[ side note: the comments about this function are poor - I have no
idea what problem it is avoiding from reading the code. Yes, I know
it protects against transactions with buffers and no ops, but the
comments don't tell me *how or when that occurs* so I do not know
where to go looking for potential issues here. ]

> > 2. We have some other verifiers around that actually use the buffer
> > magic to set a more specific verifier. See xfs_da3_node_read_verify()
> > for an example. I'm not sure this is all that useful for such higher
> > level verifiers, but I think we'd at least be able to use it for the
> > underlying verifiers. That might provide some extra sb version vs. magic
> > sanity checking for places that might not already look at the sb version
> > (otherwise it's just refactoring).
> > 
> > Thoughts or other ideas before I try to apply this more broadly? Thanks.
> 
> Hmm... not sure if I like the idea that you have to find the b_ops
> declaration to figure out which magic number the verifier function is
> checking, but I don't really have a cogent objection.

Yeah, I don't really like it either (especially the added CPU
overhead that we avoided by doing compile time byte swapping),
but I'm struggling to come up with a better option.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
