Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82CD9C07E9A
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 05:00:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67EB5613B2
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 05:00:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237802AbhGNFDX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 01:03:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:39502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229451AbhGNFDX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jul 2021 01:03:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 832DB6135A;
        Wed, 14 Jul 2021 05:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626238832;
        bh=g4xMm2vkWMaXK+vU8jj7LWHhNuJ3OmXqqkhsfGJJID8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DVJU1TxArxUHS57dV3y21MAqt3is0jSyBu2FJSBlZAVEYOH1JGQiUrNvBG0OD7PGO
         8e8bIrvUs2iuVYXr7XpOWaMF2i2w4CCjKEIxJbxvkEo39WCaDsl9EyE8uliat33qX0
         TfSuj46OCAJa8hEXb9JpSy/wx5bZ96/AGDPAxEcfrELniYAAwNAWYV3oR4yL1NFjBz
         jMjSg9L4gC1mXwnwuL8hwPu/G8+Chm3HIWOw1UV5BcFJ/tYkRo/S/FG4C2Bvg2J7pJ
         RXILYH4MqVxNE3fSJeajBr7SFHDUJwMZ9PjnQyTqnmhnO7hpY585IA0cLmH5sKvQkJ
         JTjb0bI8ZfQSQ==
Date:   Tue, 13 Jul 2021 22:00:32 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: fix an integer overflow error in xfs_growfs_rt
Message-ID: <20210714050032.GF22402@magnolia>
References: <162612763990.39052.10884597587360249026.stgit@magnolia>
 <162612765097.39052.11033534688048926480.stgit@magnolia>
 <20210714011215.GU664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714011215.GU664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 11:12:15AM +1000, Dave Chinner wrote:
> On Mon, Jul 12, 2021 at 03:07:31PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > During a realtime grow operation, we run a single transaction for each
> > rt bitmap block added to the filesystem.  This means that each step has
> > to be careful to increase sb_rblocks appropriately.
> > 
> > Fix the integer overflow error in this calculation that can happen when
> > the extent size is very large.  Found by running growfs to add a rt
> > volume to a filesystem formatted with a 1g rt extent size.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_rtalloc.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> > index 8920bce4fb0a..a47d43c30283 100644
> > --- a/fs/xfs/xfs_rtalloc.c
> > +++ b/fs/xfs/xfs_rtalloc.c
> > @@ -1019,7 +1019,7 @@ xfs_growfs_rt(
> >  		nsbp->sb_rbmblocks = bmbno + 1;
> >  		nsbp->sb_rblocks =
> >  			XFS_RTMIN(nrblocks,
> > -				  nsbp->sb_rbmblocks * NBBY *
> > +				  (xfs_rfsblock_t)nsbp->sb_rbmblocks * NBBY *
> >  				  nsbp->sb_blocksize * nsbp->sb_rextsize);
> >  		nsbp->sb_rextents = nsbp->sb_rblocks;
> >  		do_div(nsbp->sb_rextents, nsbp->sb_rextsize);
> 
> Oh, that's just nasty code.  This needs a comment explaining that the
> cast is to avoid an overflow, otherwise someone will come along
> later and remove the "unnecessary" cast.
> 
> Alternatively, because we do "nsbp->sb_rbmblocks = bmbno + 1;" a
> couple of lines above, this could be done differently without the
> need for a cast. Make bmbno a xfs_rfsblock_t, and simply write the
> code as:
> 
> 		nsbp->sb_rblocks = min(nrblocks,
> 					(bmbno + 1) * NBBY *
> 					nsbp->sb_blocksize * nsbp->sb_rextsize);
> 		nsbp->sb_rbmblocks = bmbno + 1;

I like that, it'll get changed in the next revision.

> Notes for future cleanup:
> 
> #define XFS_RTMIN(a,b) ((a) < (b) ? (a) : (b))
> 
> Needs to die.

Heh, yes.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
