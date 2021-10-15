Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06DD7C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Oct 2021 00:48:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFE5A610FF
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Oct 2021 00:48:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbhJOAur (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 20:50:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:60788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229546AbhJOAur (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Oct 2021 20:50:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE4B36108B;
        Fri, 15 Oct 2021 00:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634258921;
        bh=DnC6dueocB5fCzyMf2y6AvHQYDvcDlxeVTMERgmEfZs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iQto4LdTkdT0szbB6163L615i9pGS0wvPSWAonTRSu6kLea95JNWNo2NILkNZ4DVo
         5XKCwy3SwRKKYOx7udGeMiqZ1z2s958XNu+RX9s0DNE+/9sVrmNiuanrqzQk7Tn6X0
         VdRBuM5yor4k287Vq1e3yP7+98DS1gwFqG0kFejdrXM1/+UiHVyolar49SORkxX86o
         UeYBvoB3riunCt8bEBu2ktQjwmtp8coSx5P2ZSeKNMhH6OWVRJ8KX+EpskFW5MUoT0
         GjbLGpo2Buy6KYu49M70Vama4XBAlWn2vWRF+rlCVYv4Oewj2FVx96g/UaMAHTN5Qn
         ohepOnlKBw6qg==
Date:   Thu, 14 Oct 2021 17:48:41 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 14/17] xfs: compute the maximum height of the rmap btree
 when reflink enabled
Message-ID: <20211015004841.GR24307@magnolia>
References: <163424261462.756780.16294781570977242370.stgit@magnolia>
 <163424269189.756780.15045314476103501683.stgit@magnolia>
 <20211014230333.GT2361455@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211014230333.GT2361455@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 15, 2021 at 10:03:33AM +1100, Dave Chinner wrote:
> On Thu, Oct 14, 2021 at 01:18:11PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Instead of assuming that the hardcoded XFS_BTREE_MAXLEVELS value is big
> > enough to handle the maximally tall rmap btree when all blocks are in
> > use and maximally shared, let's compute the maximum height assuming the
> > rmapbt consumes as many blocks as possible.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_btree.c       |   33 +++++++++++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_btree.h       |    2 ++
> >  fs/xfs/libxfs/xfs_rmap_btree.c  |   45 +++++++++++++++++++++++----------------
> >  fs/xfs/libxfs/xfs_trans_resv.c  |   16 ++++++++++++++
> >  fs/xfs/libxfs/xfs_trans_space.h |    7 ++++++
> >  5 files changed, 85 insertions(+), 18 deletions(-)
> 
> Looks good.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> >  /* Calculate the refcount btree size for some records. */
> > diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> > index c879e7754ee6..6f83d9b306ee 100644
> > --- a/fs/xfs/libxfs/xfs_trans_resv.c
> > +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> > @@ -814,6 +814,19 @@ xfs_trans_resv_calc(
> >  	struct xfs_mount	*mp,
> >  	struct xfs_trans_resv	*resp)
> >  {
> > +	unsigned int		rmap_maxlevels = mp->m_rmap_maxlevels;
> > +
> > +	/*
> > +	 * In the early days of rmap+reflink, we always set the rmap maxlevels
> > +	 * to 9 even if the AG was small enough that it would never grow to
> > +	 * that height.  Transaction reservation sizes influence the minimum
> > +	 * log size calculation, which influences the size of the log that mkfs
> > +	 * creates.  Use the old value here to ensure that newly formatted
> > +	 * small filesystems will mount on older kernels.
> > +	 */
> > +	if (xfs_has_rmapbt(mp) && xfs_has_reflink(mp))
> > +		mp->m_rmap_maxlevels = XFS_OLD_REFLINK_RMAP_MAXLEVELS;
> > +
> 
> As an aside, what are your plans to get your "legacy minimum log
> size reservations" calculation patch moved upstream so we can stop
> having to care about this in future?

Hmm.  I think I'm just going to bail on those until 5.17.

At this point I have the kmem_zone renaming series (already on the list)
and another patchset to shrink the defer items and convert them to use
slab caches that I might push after the kmem_zone thing if we get that
far.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
