Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A907FC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 16:39:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6293061983
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 16:39:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhCVQie (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Mar 2021 12:38:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:33684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231987AbhCVQiL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Mar 2021 12:38:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C160061974;
        Mon, 22 Mar 2021 16:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616431090;
        bh=k/OMtkpmHFvnANCa7lV9rNQfnBYIpu6mBVYQXOpDlx0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nv4hNtry8+YY/BQ7NU0TLRbZTNudMsJFKhMdrTnMKVEKaJJYiwi0Vat2o7aDwfZQW
         vJAU1M5I5zxq5oG4/1BGUK4DGrqtJAqMNjJX6wpgI7gY9zneh17y+2lxmz3GYZlAWr
         YCuL9FaK1VeTa/3rpY0dmRgxXNwYf3w7jonog9YPZCPq1L3zfdBIgDpgrUrAtzip1x
         rQpFhGD4+Ywqm6H4opNv2FZQwU3z/s8OegNGhCCVfK/2SDtuQ3n15vQuMQLq855Lo1
         TA/5sVnRit12KbnRkYsTWyUCFVjwlE2bY2Jwa/pD8uF4g01zDiZWZReFNjBfBPELT9
         Be7sdUREfPRlQ==
Date:   Mon, 22 Mar 2021 09:38:10 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v8 3/5] xfs: introduce xfs_ag_shrink_space()
Message-ID: <20210322163810.GD22100@magnolia>
References: <20210305025703.3069469-1-hsiangkao@redhat.com>
 <20210305025703.3069469-4-hsiangkao@redhat.com>
 <YFh/u86JO4Pzmk8i@bfoster>
 <20210322120310.GB2000812@xiangao.remote.csb>
 <YFiM07d9DQxx4qHt@bfoster>
 <20210322123328.GA2007006@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322123328.GA2007006@xiangao.remote.csb>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 22, 2021 at 08:33:28PM +0800, Gao Xiang wrote:
> On Mon, Mar 22, 2021 at 08:25:55AM -0400, Brian Foster wrote:
> > On Mon, Mar 22, 2021 at 08:03:10PM +0800, Gao Xiang wrote:
> > > Hi Brian,
> > > 
> > > On Mon, Mar 22, 2021 at 07:30:03AM -0400, Brian Foster wrote:
> > > > On Fri, Mar 05, 2021 at 10:57:01AM +0800, Gao Xiang wrote:
> > > > > This patch introduces a helper to shrink unused space in the last AG
> > > > > by fixing up the freespace btree.
> > > > > 
> > > > > Also make sure that the per-AG reservation works under the new AG
> > > > > size. If such per-AG reservation or extent allocation fails, roll
> > > > > the transaction so the new transaction could cancel without any side
> > > > > effects.
> > > > > 
> > > > > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > > > > ---
> > > > 
> > > > Looks mostly good to me. Some nits..
> > > > 
> > > > >  fs/xfs/libxfs/xfs_ag.c | 111 +++++++++++++++++++++++++++++++++++++++++
> > > > >  fs/xfs/libxfs/xfs_ag.h |   4 +-
> > > > >  2 files changed, 114 insertions(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> > > > > index 9331f3516afa..1f6f9e70e1cb 100644
> > > > > --- a/fs/xfs/libxfs/xfs_ag.c
> > > > > +++ b/fs/xfs/libxfs/xfs_ag.c
> > > > ...
> > > > > @@ -485,6 +490,112 @@ xfs_ag_init_headers(
> > > > >  	return error;
> > > > >  }
> > > > >  
> > > > > +int
> > > > > +xfs_ag_shrink_space(
> > > > > +	struct xfs_mount	*mp,
> > > > > +	struct xfs_trans	**tpp,
> > > > > +	xfs_agnumber_t		agno,
> > > > > +	xfs_extlen_t		delta)
> > > > > +{
> > > > > +	struct xfs_alloc_arg	args = {
> > > > > +		.tp	= *tpp,
> > > > > +		.mp	= mp,
> > > > > +		.type	= XFS_ALLOCTYPE_THIS_BNO,
> > > > > +		.minlen = delta,
> > > > > +		.maxlen = delta,
> > > > > +		.oinfo	= XFS_RMAP_OINFO_SKIP_UPDATE,
> > > > > +		.resv	= XFS_AG_RESV_NONE,
> > > > > +		.prod	= 1
> > > > > +	};
> > > > > +	struct xfs_buf		*agibp, *agfbp;
> > > > > +	struct xfs_agi		*agi;
> > > > > +	struct xfs_agf		*agf;
> > > > > +	int			error, err2;
> > > > > +
> > > > > +	ASSERT(agno == mp->m_sb.sb_agcount - 1);
> > > > > +	error = xfs_ialloc_read_agi(mp, *tpp, agno, &agibp);
> > > > > +	if (error)
> > > > > +		return error;
> > > > > +
> > > > > +	agi = agibp->b_addr;
> > > > > +
> > > > > +	error = xfs_alloc_read_agf(mp, *tpp, agno, 0, &agfbp);
> > > > > +	if (error)
> > > > > +		return error;
> > > > > +
> > > > > +	agf = agfbp->b_addr;
> > > > > +	if (XFS_IS_CORRUPT(mp, agf->agf_length != agi->agi_length))
> > > > > +		return -EFSCORRUPTED;
> > > > 
> > > > Is this check here for a reason? It seems a bit random, so I wonder if
> > > > we should just leave the extra verification to buffer verifiers.
> > > 
> > > It came from Darrick's thought. I'm fine with either way, but I feel
> > > confused if different conflict opinions here:
> > > https://lore.kernel.org/linux-xfs/20210303181931.GB3419940@magnolia/
> > > 
> > 
> > Darrick's comment seems to refer to the check below. I'm referring to
> > the check above that agi_length and agf_length match. Are they intended
> > to go together? The check above seems to preexist the one below.
> 
> Sorry, update link of this:
> https://lore.kernel.org/r/20210111181753.GC1164246@magnolia/
> 
> > 
> > Anyways, if so, maybe just bunch them together and add a comment:
> > 
> > 	/* some extra paranoid checks before we shrink the ag */

Yes, all this is born out of paranoia checks on my part because I feel
that shrink is likely to have Real Bad Dataloss Consequences(tm) if we
don't check everything a second time before proceeding.

--D

> > 	if (XFS_IS_CORRUPT(...))
> > 		return -EFSCORRUPTED;
> > 	if (delta >= agf->agf_length)
> > 		return -EVINAL; 
> > 
> 
> ok, will update this.
> 
> > > > 
> > > > > +
> > > > > +	if (delta >= agi->agi_length)
> > > > > +		return -EINVAL;
> > > > > +
> > > > > +	args.fsbno = XFS_AGB_TO_FSB(mp, agno,
> > > > > +				    be32_to_cpu(agi->agi_length) - delta);
> > > > > +
> > > > > +	/* remove the preallocations before allocation and re-establish then */
> > ...
> > > > > diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> > > > > index 5166322807e7..41293ebde8da 100644
> > > > > --- a/fs/xfs/libxfs/xfs_ag.h
> > > > > +++ b/fs/xfs/libxfs/xfs_ag.h
> > > > > @@ -24,8 +24,10 @@ struct aghdr_init_data {
> > > > >  };
> > > > >  
> > > > >  int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
> > > > > +int xfs_ag_shrink_space(struct xfs_mount *mp, struct xfs_trans **tpp,
> > > > > +			xfs_agnumber_t agno, xfs_extlen_t len);
> > > > >  int xfs_ag_extend_space(struct xfs_mount *mp, struct xfs_trans *tp,
> > > > > -			struct aghdr_init_data *id, xfs_extlen_t len);
> > > > > +			struct aghdr_init_data *id, xfs_extlen_t delta);
> > > > 
> > > > This looks misplaced..?
> > > > 
> > > > Or maybe this is trying to make the APIs consistent, but the function
> > > > definition still uses len as well as the declaration for
> > > > _ag_shrink_space() (while the definition of that function uses delta).
> > > > 
> > > > FWIW, the name delta tends to suggest a signed value to me based on our
> > > > pattern of usage, whereas here it seems like these helpers always want a
> > > > positive value (i.e. a length).
> > > 
> > > Yeah, it's just misplaced, thanks for pointing out, sorry about that.
> > > `delta' name came from, `len' is confusing to Darrick.
> > > https://lore.kernel.org/r/20210303182527.GC3419940@magnolia/
> > > 
> > 
> > Fair enough. I'm not worried about the name, just pointing out some
> > potential inconsistencies.
> 
> Thanks for pointing out!
> 
> Thanks,
> Gao Xiang
> 
> > 
> > Brian
> > 
> > > Thanks,
> > > Gao Xiang
> > > 
> > > > 
> > > > Brian
> > > > 
> > > > >  int xfs_ag_get_geometry(struct xfs_mount *mp, xfs_agnumber_t agno,
> > > > >  			struct xfs_ag_geometry *ageo);
> > > > >  
> > > > > -- 
> > > > > 2.27.0
> > > > > 
> > > > 
> > > 
> > 
> 
