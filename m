Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F9D7EB64D7
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jun 2023 22:56:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbjF1W4D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jun 2023 18:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231416AbjF1Wzr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jun 2023 18:55:47 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 081D610F8
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2023 15:55:45 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-666e3b15370so71872b3a.0
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2023 15:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687992944; x=1690584944;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D65lMjhrQpRfyYlm4FZY3mrzsEr5YKAUBcpqs6gRP58=;
        b=2m9GNPjJdUHacut7gSpmAr1/PTH5CMbZZMzCY4Ihn3VWSCYKo3S8s2o1h6/O7DoYlU
         GBuTj+WWVLivIcwnnuXDEs2zD3uIAs1HnwpXOh0gIkG9CGUn+d9JDIr9To4+jLAuv7qp
         tvLR4CSEe6oRxeDKoWURlj6P9VyrMJtwbHRTUFPebQ5GZ/Rqi5/JhFruh+iepHKx2fMz
         K84e9KksmY1rUMnUT0vbFnEBXP1KulkhjfUwyAsXPRPcAKMU4rr3A1lTov71RA49RcQD
         hgOu+MqjesUOe7O50TjH+6LCTrLvw+wsRPldZ0yhuQX+VK5NO2mQUdbm29g4eV2/Jtzs
         Ascg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687992944; x=1690584944;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D65lMjhrQpRfyYlm4FZY3mrzsEr5YKAUBcpqs6gRP58=;
        b=lLvMZAkicT6uWcQwL7KIC7/Dp6zt31TfAQJHwvF7O0oi/4w75OwC5tgEfeNNXVYg04
         /tXsHYjRdg9qWUvvYK6so1bVp6ybtdQGVbf879t+MBEi7y2Uc15jBsOTlnTSs3lj5f6Y
         99yOPK54XF4DKW/hnWg2AIRcBgHyCs9H9c56qlahUoNbo6gFKshuUIs3W6k+TGBEognJ
         6J/6zOujX1Qunj68PmUnYmB6XrBq9QX4Q8IuojWS6AkKJp/c208ufIyNNpBQpdMU/2It
         q1XfYWAgVOVZm3TZScLlEnQHYEQJWgUjNo7ewJWWP1lUj+wwOzVVn/HCNHTiC0ef0ntR
         ngGQ==
X-Gm-Message-State: AC+VfDx8LI4dv3a+ixnLMyjNR6W6G7j9+u9RM63XLqVttKUZRgUi9RUT
        7aMDmT52u4pf33rMcLAi6CE3XdyMLmXZAQq2D2g=
X-Google-Smtp-Source: ACHHUZ5ehwJQIt418Ju8HzR36uVFI8uRPaILRGcnsygxdiph2BSrmb+h+NzSKIEl8MHuyAqAOKVbnw==
X-Received: by 2002:a05:6a00:1504:b0:668:9735:573c with SMTP id q4-20020a056a00150400b006689735573cmr28738842pfu.15.1687992944497;
        Wed, 28 Jun 2023 15:55:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-94-37.pa.vic.optusnet.com.au. [49.186.94.37])
        by smtp.gmail.com with ESMTPSA id z6-20020aa791c6000000b0065434edd521sm1248926pfa.196.2023.06.28.15.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jun 2023 15:55:43 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qEe4b-00HOzK-0q;
        Thu, 29 Jun 2023 08:55:41 +1000
Date:   Thu, 29 Jun 2023 08:55:41 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: use deferred frees for btree block freeing
Message-ID: <ZJy6bXphyOp4NGzk@dread.disaster.area>
References: <20230627224412.2242198-1-david@fromorbit.com>
 <20230627224412.2242198-3-david@fromorbit.com>
 <20230628174625.GT11441@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230628174625.GT11441@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 28, 2023 at 10:46:25AM -0700, Darrick J. Wong wrote:
> On Wed, Jun 28, 2023 at 08:44:06AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Btrees that aren't freespace management trees use the normal extent
> > allocation and freeing routines for their blocks. Hence when a btree
> > block is freed, a direct call to xfs_free_extent() is made and the
> > extent is immediately freed. This puts the entire free space
> > management btrees under this path, so we are stacking btrees on
> > btrees in the call stack. The inobt, finobt and refcount btrees
> > all do this.
> > 
> > However, the bmap btree does not do this - it calls
> > xfs_free_extent_later() to defer the extent free operation via an
> > XEFI and hence it gets processed in deferred operation processing
> > during the commit of the primary transaction (i.e. via intent
> > chaining).
> > 
> > We need to change xfs_free_extent() to behave in a non-blocking
> > manner so that we can avoid deadlocks with busy extents near ENOSPC
> > in transactions that free multiple extents. Inserting or removing a
> > record from a btree can cause a multi-level tree merge operation and
> > that will free multiple blocks from the btree in a single
> > transaction. i.e. we can call xfs_free_extent() multiple times, and
> > hence the btree manipulation transaction is vulnerable to this busy
> > extent deadlock vector.
> > 
> > To fix this, convert all the remaining callers of xfs_free_extent()
> > to use xfs_free_extent_later() to queue XEFIs and hence defer
> > processing of the extent frees to a context that can be safely
> > restarted if a deadlock condition is detected.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_ag.c             | 2 +-
> >  fs/xfs/libxfs/xfs_alloc.c          | 4 ++++
> >  fs/xfs/libxfs/xfs_alloc.h          | 8 +++++---
> >  fs/xfs/libxfs/xfs_bmap.c           | 8 +++++---
> >  fs/xfs/libxfs/xfs_bmap_btree.c     | 3 ++-
> >  fs/xfs/libxfs/xfs_ialloc.c         | 8 ++++----
> >  fs/xfs/libxfs/xfs_ialloc_btree.c   | 3 +--
> >  fs/xfs/libxfs/xfs_refcount.c       | 9 ++++++---
> >  fs/xfs/libxfs/xfs_refcount_btree.c | 8 +-------
> >  fs/xfs/xfs_extfree_item.c          | 3 ++-
> >  fs/xfs/xfs_reflink.c               | 3 ++-
> >  11 files changed, 33 insertions(+), 26 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> > index ee84835ebc66..e9cc481b4ddf 100644
> > --- a/fs/xfs/libxfs/xfs_ag.c
> > +++ b/fs/xfs/libxfs/xfs_ag.c
> > @@ -985,7 +985,7 @@ xfs_ag_shrink_space(
> >  			goto resv_err;
> >  
> >  		err2 = __xfs_free_extent_later(*tpp, args.fsbno, delta, NULL,
> > -				true);
> > +				XFS_AG_RESV_NONE, true);
> >  		if (err2)
> >  			goto resv_err;
> >  
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index c20fe99405d8..cc3f7b905ea1 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -2449,6 +2449,7 @@ xfs_defer_agfl_block(
> >  	xefi->xefi_startblock = XFS_AGB_TO_FSB(mp, agno, agbno);
> >  	xefi->xefi_blockcount = 1;
> >  	xefi->xefi_owner = oinfo->oi_owner;
> > +	xefi->xefi_type = XFS_AG_RESV_AGFL;
> >  	if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbno(mp, xefi->xefi_startblock)))
> >  		return -EFSCORRUPTED;
> > @@ -2470,6 +2471,7 @@ __xfs_free_extent_later(
> >  	xfs_fsblock_t			bno,
> >  	xfs_filblks_t			len,
> >  	const struct xfs_owner_info	*oinfo,
> > +	enum xfs_ag_resv_type		type,
> >  	bool				skip_discard)
> >  {
> >  	struct xfs_extent_free_item	*xefi;
> > @@ -2490,6 +2492,7 @@ __xfs_free_extent_later(
> >  	ASSERT(agbno + len <= mp->m_sb.sb_agblocks);
> >  #endif
> >  	ASSERT(xfs_extfree_item_cache != NULL);
> > +	ASSERT(type != XFS_AG_RESV_AGFL);
> >  
> >  	if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbext(mp, bno, len)))
> >  		return -EFSCORRUPTED;
> > @@ -2498,6 +2501,7 @@ __xfs_free_extent_later(
> >  			       GFP_KERNEL | __GFP_NOFAIL);
> >  	xefi->xefi_startblock = bno;
> >  	xefi->xefi_blockcount = (xfs_extlen_t)len;
> > +	xefi->xefi_type = type;
> >  	if (skip_discard)
> >  		xefi->xefi_flags |= XFS_EFI_SKIP_DISCARD;
> >  	if (oinfo) {
> > diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> > index 85ac470be0da..121faf1e11ad 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.h
> > +++ b/fs/xfs/libxfs/xfs_alloc.h
> > @@ -232,7 +232,7 @@ xfs_buf_to_agfl_bno(
> >  
> >  int __xfs_free_extent_later(struct xfs_trans *tp, xfs_fsblock_t bno,
> >  		xfs_filblks_t len, const struct xfs_owner_info *oinfo,
> > -		bool skip_discard);
> > +		enum xfs_ag_resv_type type, bool skip_discard);
> >  
> >  /*
> >   * List of extents to be free "later".
> > @@ -245,6 +245,7 @@ struct xfs_extent_free_item {
> >  	xfs_extlen_t		xefi_blockcount;/* number of blocks in extent */
> >  	struct xfs_perag	*xefi_pag;
> >  	unsigned int		xefi_flags;
> 
> /me is barely back from vacation, starting to process the ~1100 emails
> by taking care of the obvious bugfixes first...
> 
> > +	enum xfs_ag_resv_type	xefi_type;
> 
> I got confused by 'xefi_type' until I remembered that
> XFS_DEFER_OPS_TYPE_AGFL_FREE / XFS_DEFER_OPS_TYPE_FREE are stuffed in
> the xfs_defer_pending structure, not the xefi itself.
> 
> Could this field be named xefi_agresv instead?

Sure.

> The rest of the logic in this patch looks correct and makes things
> easier for the rt modernization patches, so I'll say
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> and change the name on commit, if that's ok?

That's fine.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
