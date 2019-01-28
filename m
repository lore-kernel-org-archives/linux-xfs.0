Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:38378 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726859AbfA1VGn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Jan 2019 16:06:43 -0500
Date: Tue, 29 Jan 2019 08:06:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] xfs: support magic value in xfs_buf_ops
Message-ID: <20190128210640.GP4205@dastard>
References: <20190124155440.46469-1-bfoster@redhat.com>
 <20190124190846.GC4368@magnolia>
 <20190124221917.GN4205@dastard>
 <20190125144324.GA58775@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190125144324.GA58775@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Fri, Jan 25, 2019 at 09:43:25AM -0500, Brian Foster wrote:
> On Fri, Jan 25, 2019 at 09:19:17AM +1100, Dave Chinner wrote:
> > On Thu, Jan 24, 2019 at 11:08:46AM -0800, Darrick J. Wong wrote:
> > > On Thu, Jan 24, 2019 at 10:54:40AM -0500, Brian Foster wrote:
> > > > Add a field to specify the v4 and v5 magic values in xfs_buf_ops.
> > > > This allows otherwise identical verifiers to distinguish between
> > > > and verify different magic values (inobt vs. finobt buffers). This
> > > > also facilitates verification of the appropriate magic value based
> > > > on superblock version.
> > > > 
> > > > The magic field is optional and is free to be used as appropriate
> > > > for each particular verifier.
> > > > 
> > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > ---
> > > > 
> > > > Hi all,
> > > > 
> > > > What do folks think of something like this as a lightweight (and
> > > > untested) means to do proper [f]inobt magic verification? For reference,
> > > > the initial version of this put together to help root cause a user
> > > > report is here[1]. I was hoping to do the same thing with less code
> > > > duplication. A couple things that come to mind:
> > > > 
> > > > 1. I know scrub has at least one place where we invoke the verifier with
> > > > ->b_ops == NULL, which will cause this to explode. Could we fix that up
> > > > to assign and reset ->b_ops to accommodate something like this, or is
> > > > that problematic?
> > > 
> > > IIRC one of the scrub findroot reviewers didn't like the idea of scrub
> > > setting b_ops until it was absolutely sure it wanted to.  I think it's
> > > actually ok to patch it in temporarily while running the read verifier
> > > since we have the buffer locked and patch it out afterwards.
> > 
> > How does this interact with xfs_buf_ensure_ops()?
> > 
> > [ side note: the comments about this function are poor - I have no
> > idea what problem it is avoiding from reading the code. Yes, I know
> > it protects against transactions with buffers and no ops, but the
> > comments don't tell me *how or when that occurs* so I do not know
> > where to go looking for potential issues here. ]
> > 
> 
> I think the when and how behind this logic is the scrub case (i.e.,
> xrep_findroot_block()) called out above: we read the buffer with a NULL
> b_ops param because we don't know which buf_ops actually applies. If a
> ->b_ops is not ultimately attached, the buf sits around in cache without
> ->b_ops and is never verified (even if read with a non-NULL b_ops) until
> it cycles out of cache.

IOWs, it is marked XBF_DONE, which prevents it from being verified
on future reads accesses even if a buf_ops is provided.

So, really, it is just very badly named - it's named for it's
implementation, not for the purpose it serves. i.e. it should be
named something like xfs_buf_reverify(bp, ops)?  Or even:

	if (xfs_buf_need_verify(bp, ops))
		xfs_buf_reverify(bp, ops);

> > > Hmm... not sure if I like the idea that you have to find the b_ops
> > > declaration to figure out which magic number the verifier function is
> > > checking, but I don't really have a cogent objection.
> > 
> > Yeah, I don't really like it either (especially the added CPU
> > overhead that we avoided by doing compile time byte swapping),
> > but I'm struggling to come up with a better option.
> 
> I suppose we could store the on-disk magics in the xfs_buf_ops
> structures (it works on x86_64 at least, I'd have to verify other
> arches), but that is pretty ugly. Given all of the other conversions and
> checks, I'm not sure it's worth it.
> 
> Hmm, I suppose we could also define a separate set of on-disk magic
> directives:
> 
> #define XFS_FIBT_CRC_MAGIC_DISK        cpu_to_be32(XFS_FIBT_CRC_MAGIC)
> 
> ... and start using those in various places to avoid the ugliness. I
> think that's a separate change though (and again, it's not immediately
> clear to me the benefit justifies the additional code).

I'd prefer we don't have to duplicate every magic number in XFS -
that feels like going backwards to the bad old days of crufty irix
code that we have cleaned up over the years.... Just use
cpu_to_be32(XFS_FIBT_CRC_MAGIC) where necessary.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
