Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78F37C433C1
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 16:07:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4144B61A33
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 16:07:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhCZQHL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Mar 2021 12:07:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231184AbhCZQHC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 26 Mar 2021 12:07:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63A5E61A2A;
        Fri, 26 Mar 2021 16:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616774822;
        bh=ld5jXWszz9mnlMEUjgdRJcsQjxduNFIImTydz9RYBfM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OrBBJCRwJj6nM1jXUrns9AnupZJSvW0PV6B9oTwz+bHTHBiY3g8q6Jjs63aRZuju+
         GvoT80MeFcqlSiAeJ2TKBgOEtbl7cZtqTiPLcC7vQPiaEDtoiSvjmdDgdQiJvO8I5V
         IhBIGa3bJW+ZI+Io5Eo5796QqSdsxAhUTbMW5NdBADqD4fyDLFTF+9TXE9Oshq/N2m
         5B+5G34xn6cLnrxOM6ElIjihL97UdzBoA2I7Cr2hNacc7PCWVMQv12BpuCL7GWkdCx
         dw1Vi6a9ECh5uqrJImIl0mOLeMhoGtfXxehNh6irEcmqMt60LmfEz9fY1fDC7cLKkZ
         dQny9MYWkcBSA==
Date:   Fri, 26 Mar 2021 09:07:01 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: merge xfs_reclaim_inodes_ag into
 xfs_inode_walk_ag
Message-ID: <20210326160701.GW4090233@magnolia>
References: <161671807287.621936.13471099564526590235.stgit@magnolia>
 <161671810078.621936.339407186528826628.stgit@magnolia>
 <20210326063056.GF3421955@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326063056.GF3421955@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 26, 2021 at 06:30:56AM +0000, Christoph Hellwig wrote:
> On Thu, Mar 25, 2021 at 05:21:40PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Merge these two inode walk loops together, since they're pretty similar
> > now.  Get rid of XFS_ICI_NO_TAG since nobody uses it.
> 
> The laster user of XFS_ICI_NO_TAG was quotoff, and the last reference
> was removed in "xfs: remove indirect calls from xfs_inode_walk{,_ag}".
> So I think it should be dropped there, or even better in a prep patch
> removing all the XFS_ICI_NO_TAG code before that one.

Ok, moved to patch 3.

> > +static inline bool
> > +selected_for_walk(
> > +	unsigned int		tag,
> > +	struct xfs_inode	*ip)
> > +{
> > +	switch (tag) {
> > +	case XFS_ICI_BLOCKGC_TAG:
> > +		return xfs_blockgc_grab(ip);
> > +	case XFS_ICI_RECLAIM_TAG:
> > +		return xfs_reclaim_inode_grab(ip);
> > +	default:
> > +		return false;
> > +	}
> > +}
> 
> Maybe name ths something that starts with xfs_ and ends with _grab?

xfs_grabbed_for_walk?

> >   * and release all incore inodes with the given radix tree @tag.
> > @@ -786,12 +803,14 @@ xfs_inode_walk_ag(
> >  	bool			done;
> >  	int			nr_found;
> >  
> > -	ASSERT(tag == XFS_ICI_BLOCKGC_TAG);
> > +	ASSERT(tag < RADIX_TREE_MAX_TAGS);
> >  
> >  restart:
> >  	done = false;
> >  	skipped = 0;
> >  	first_index = 0;
> > +	if (tag == XFS_ICI_RECLAIM_TAG)
> > +		first_index = READ_ONCE(pag->pag_ici_reclaim_cursor);
> 
> if / else to make this clear?

Done.

> >  		for (i = 0; i < nr_found; i++) {
> >  			if (!batch[i])
> >  				continue;
> > -			error = xfs_blockgc_scan_inode(batch[i], eofb);
> > -			xfs_irele(batch[i]);
> > +			switch (tag) {
> > +			case XFS_ICI_BLOCKGC_TAG:
> > +				error = xfs_blockgc_scan_inode(batch[i], eofb);
> > +				xfs_irele(batch[i]);
> > +				break;
> > +			case XFS_ICI_RECLAIM_TAG:
> > +				xfs_reclaim_inode(batch[i], pag);
> > +				error = 0;
> 
> Maybe move the irele into xfs_blockgc_scan_inode to make the calling
> conventions more similar?

Ok.  I'll also fix the off-by-one error in the nr_to_scan check.

--D
