Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85DD2C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 16:46:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5966D61108
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 16:46:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhJNQs2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 12:48:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:35998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229587AbhJNQs1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Oct 2021 12:48:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC87660EBB;
        Thu, 14 Oct 2021 16:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634229982;
        bh=E7uyOAsGrJjGVBItqyqDpCtTx3q9IuYhSoVdni7oSz4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h51JkScx0x+fmu/lRw9XSHOeha0GzhlpzZyWq76qtaGyDOQgV5qXGtCgELRj3gP77
         L2hps1J/vYai3N3dsRGEfgVrDhenQMJCfS8beTEY6zhd611KuEol0MvBHeeO4JvgLd
         ugoY4A3qx1SKqclc3KeYhFJEbbi6dHtzLhEAFzO19kGwqmW90p24/WfY1N18Fqzs73
         bOxAd7A+A8lMrAPS2NXas5P0eC/NHGDRLk2vgsuFhEf8uq7HYM2FWGM+R7W4rsOcLY
         i9Bn/eWZ2db5BmN1XW+CuNsRQ9wuaGjId5V82I2uXKHxFUtU7Quu1hKJUS2rl7GeOm
         p9ydDhmNIGQ3w==
Date:   Thu, 14 Oct 2021 09:46:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 3/4] xfs: terminate perag iteration reliably on agcount
Message-ID: <20211014164621.GA24333@magnolia>
References: <20211012165203.1354826-1-bfoster@redhat.com>
 <20211012165203.1354826-4-bfoster@redhat.com>
 <20211012190822.GN24307@magnolia>
 <YWg6XNufgGOUXNnI@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWg6XNufgGOUXNnI@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 14, 2021 at 10:10:36AM -0400, Brian Foster wrote:
> On Tue, Oct 12, 2021 at 12:08:22PM -0700, Darrick J. Wong wrote:
> > On Tue, Oct 12, 2021 at 12:52:02PM -0400, Brian Foster wrote:
> > > The for_each_perag_from() iteration macro relies on sb_agcount to
> > > process every perag currently within EOFS from a given starting
> > > point. It's perfectly valid to have perag structures beyond
> > > sb_agcount, however, such as if a growfs is in progress. If a perag
> > > loop happens to race with growfs in this manner, it will actually
> > > attempt to process the post-EOFS perag where ->pag_agno ==
> > > sb_agcount. This is reproduced by xfs/104 and manifests as the
> > > following assert failure in superblock write verifier context:
> > > 
> > >  XFS: Assertion failed: agno < mp->m_sb.sb_agcount, file: fs/xfs/libxfs/xfs_types.c, line: 22
> > > 
> > > Update the corresponding macro to only process perags that are
> > > within the current sb_agcount.
> > 
> > Does this need a Fixes: tag?
> > 
> 
> Probably. I briefly looked into this originally, saw that this code was
> introduced/modified across a span of commits and skipped it because it
> wasn't immediately clear which singular commit may have introduced the
> bug(s). Since these are now separate patches, I'd probably go with
> 58d43a7e3263 ("xfs: pass perags around in fsmap data dev functions") for
> this one (since it introduced the use of sb_agcount) and f250eedcf762
> ("xfs: make for_each_perag... a first class citizen") for the next
> patch.
> 
> That said, technically we could probably refer to the latter for both of
> these fixes as a suitable enough catchall for the intended purpose of
> the Fixes tag. I suspect the fundamental problem actually exists in that
> base patch because for_each_perag() iterates solely based on pag !=
> NULL. It seems a little odd that the sb_agcount usage is not introduced
> until a couple patches later, but I suppose that could just be
> considered a dependency. In reality, it's probably unlikely to ever have
> a stable kernel at that intermediate point of a rework series so it
> might not matter much either way. I don't really have a preference one
> way or the other. Your call..?

Those fixes tags seem like a reasonable breadcrumb for finding fixes.
I'll add them to the respective patches on commit.  So for this third
one:

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

> > Also ... should we be checking for agno <= agcount-1 for the initial
> > xfs_perag_get in the first for loop clause of for_each_perag_range?
> > I /think/ the answer is that the current users are careful enough to
> > check that race, but I haven't looked exhaustively.
> > 
> 
> Not sure I follow... for_each_perag_range() is a more generic variant
> that doesn't know or care about sb_agcount. I think it should support
> the ability to span an arbitrary range of perags regardless of
> sb_agcount. Hm?

Oh, I was idly wondering if these iterators ought to have one more
training wheel where the loop would be skipped entirely if you did
something buggy such as:

agno = mp->m_sb.sb_agcount;
/* time goes by */
for_each_perag_from(mp, agno...)
	/* stuff */

Normally that would be skipped since xfs_perag_get(sb_agcount) returns
NULL, except in the case that it's racing with growfs.  But, some
malfunction like this should be fairly easy to spot even in the common
case.

--D

> > Welcome back, by the way. :)
> > 
> 
> Thanks!
> 
> Brian
> 
> > --D
> > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_ag.h | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> > > index cf8baae2ba18..b8cc5017efba 100644
> > > --- a/fs/xfs/libxfs/xfs_ag.h
> > > +++ b/fs/xfs/libxfs/xfs_ag.h
> > > @@ -142,7 +142,7 @@ struct xfs_perag *xfs_perag_next(
> > >  		(pag) = xfs_perag_next((pag), &(agno)))
> > >  
> > >  #define for_each_perag_from(mp, agno, pag) \
> > > -	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount, (pag))
> > > +	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount - 1, (pag))
> > >  
> > >  
> > >  #define for_each_perag(mp, agno, pag) \
> > > -- 
> > > 2.31.1
> > > 
> > 
> 
