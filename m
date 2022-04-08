Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6062BC433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Apr 2022 17:42:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbiDHRo3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Apr 2022 13:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233215AbiDHRo3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Apr 2022 13:44:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3664537BE4
        for <linux-xfs@vger.kernel.org>; Fri,  8 Apr 2022 10:42:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6F116218D
        for <linux-xfs@vger.kernel.org>; Fri,  8 Apr 2022 17:42:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B55C385A1;
        Fri,  8 Apr 2022 17:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649439742;
        bh=IZYYDcgh7VOWyAeFeKA2TBUMgC4A39jVb58sAO0ewcU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PBDGhsGc61kcIb4BMZXN3d9Nd87KbR/f7jpOKvVb5LcoxbKHmWezTEfqs5D6dM1zH
         uJ1aS5xeO7ZmKoahPwAl9ULNZLIAPBD2/2H18Pxc1k3pd4n6aN/u/3dy5iY+vQUvNG
         bLwDJepCsLVlMcY2P5mPwwZ4GIuYQoJueMoe1kBXrJ6mKvGoZ515XVC76eJ7qFpE2d
         T3H7xl6vydz2CQqmuHRqj3nxRsYiTgjQQlUNoMyVjWjVceWPBspnbzxkwRIaZSpEBU
         Pv+ttYnXwdvW5yd5QqxqGUpIctwKBVX6vxevpg9qKNMnYdfrbJhlY760HhqwvQrHPS
         +iBayotNYrvSg==
Date:   Fri, 8 Apr 2022 10:42:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: recalculate free rt extents after log recovery
Message-ID: <20220408174221.GE27690@magnolia>
References: <164936441107.457511.6646449842358518774.stgit@magnolia>
 <164936441684.457511.12252243723468714698.stgit@magnolia>
 <20220407215605.GL1544202@dread.disaster.area>
 <20220407233941.GC27690@magnolia>
 <20220408000605.GN1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408000605.GN1544202@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 08, 2022 at 10:06:05AM +1000, Dave Chinner wrote:
> On Thu, Apr 07, 2022 at 04:39:41PM -0700, Darrick J. Wong wrote:
> > On Fri, Apr 08, 2022 at 07:56:05AM +1000, Dave Chinner wrote:
> > > On Thu, Apr 07, 2022 at 01:46:56PM -0700, Darrick J. Wong wrote:
> > > > @@ -1284,6 +1285,43 @@ xfs_rtmount_init(
> > > >  	return 0;
> > > >  }
> > > >  
> > > > +static inline int
> > > > +xfs_rtalloc_count_frextent(
> > > > +	struct xfs_trans		*tp,
> > > > +	const struct xfs_rtalloc_rec	*rec,
> > > > +	void				*priv)
> > > > +{
> > > > +	uint64_t			*valp = priv;
> > > > +
> > > > +	*valp += rec->ar_extcount;
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +/* Reinitialize the number of free realtime extents from the realtime bitmap. */
> > > > +STATIC int
> > > > +xfs_rtalloc_reinit_frextents(
> > > > +	struct xfs_mount	*mp)
> > > > +{
> > > > +	struct xfs_trans	*tp;
> > > > +	uint64_t		val = 0;
> > > > +	int			error;
> > > > +
> > > > +	error = xfs_trans_alloc_empty(mp, &tp);
> > > > +	if (error)
> > > > +		return error;
> > > 
> > > At this point in the mount, the transaction subsystem is not
> > > really available for use. I understand that this is an empty
> > > transaction and it doesn't reserve log space, but I don't like
> > > creating an implicit requirement that xfs_trans_alloc_empty() never
> > > touches log state for this code to work correctly into the future.
> > 
> > <nod> I'd wondered if it was really a good idea to be creating a
> > transaction at the "end" of log recovery.  Recovery itself does it, but
> > at least that's a carefully controlled box...
> > 
> > > That is, the log isn't in a state where we can run normal
> > > transactions because we can still have pending intent recovery
> > > queued in the AIL. These can't be moved from the tail of the AIL
> > > until xfs_log_mount_finish() is called to remove and process them.
> > > They are dependent on there being enough log space remaining for the
> > > transaction reservation they make to succeed and there may only be
> > > just enough space for the first intent to make that reservation.
> > > Hence if we consume any log space before we recover intents, we can
> > > deadlock on log space when then trying to recover the intents. And
> > > because the AIL can't push on intents, the same reservation deadlock
> > > could occur with any transaction reservation we try to run before
> > > xfs_log_mount_finish() has been run.
> > > 
> > > Yes, I know this is an empty transaction and so it doesn't push on
> > > the log or consume any space. But I think it's a bad precedent even
> > > to use transactions at all when we know we are in the middle of log
> > > recovery and the transaction subsystem is not open for general use
> > > yet.  Hence I think using transaction handles - even empty ones -
> > > before xfs_log_mount_finish() is run is a pattern we want to avoid
> > > if at all possible.
> > 
> > ...yes...
> > 
> > > > +
> > > > +	xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL);
> > > > +	error = xfs_rtalloc_query_all(tp, xfs_rtalloc_count_frextent, &val);
> > > 
> > > Looking at the code here, AFAICT the only thing the tp is absolutely
> > > required for here is to hold the mount pointer - all the internal
> > > bitmap walk operations grab and release buffers using interfaces
> > > that can handle a null tp being passed.
> > > 
> > > Hence it looks to me like a transaction context isn't necessary for
> > > this read-only bitmap walk. Is that correct?  Converting
> > > xfs_rtalloc_query_all() to take a mount and a trans would also make
> > > this code becomes a lot simpler....
> > 
> > ...and I was about to say "Yeah, we could make xfs_rtalloc_query_all
> > take the mount and an optional transaction", but it occurred to me:
> > 
> > The rtalloc queries need to read the rtbitmap file's data fork mappings
> > into memory to find the blocks.  If the rtbitmap is fragmented enough
> > that the data fork is in btree format and the bmbt contains an upward
> > cycle, loading the bmbt will livelock the mount attempt.
> 
> "upward cycle", as in a corrupted btree?

Yes.

> > Granted, xfs_bmapi_read doesn't take a transaction, so this means that
> > we'd either have to change it to take one, or we'd have to change the
> > rtmount code to create an empty transaction and call iread_extents to
> > detect a bmbt cycle.
> 
> 
> > So yeah, I think the answer to your question is "yes", but then there's
> > this other issue... :(
> 
> Yup, but keep in mind that:
> 
> xfs_fs_reserve_ag_blocks(tp == NULL)
>   xfs_ag_resv_init
>     xfs_finobt_calc_reserves
>       xfs_inobt_count_blocks
>         xfs_btree_count_blocks
> 
> Will do a finobt btree walk without a transaction pointer if
> we don't have finobt block counts recorded in the AGI. So it
> seems to me that we are already at risk of cycles in corrupted
> btrees being able to cause mount hangs.
> 
> Hence from that perspective, I think worrying about a corrupted
> rtbitmap BMBT btree is largely outside the scope of this patchset;
> it's a generic issue with transaction-less btree walks, and one we
> are already exposed to in the same phase of the mount/log recovery
> process. Hence I think we should consider how to solve this problem
> seperately rather that tie this patchset into twisty knots trying to
> deal with here...

<nod> I've long wanted to do a full audit of all the places we walk
ondisk graph metadata without a transaction, but still haven't gotten
to it... :(

Anyway, I'll leave /that/ for a future series.  In the meantime, I'll
amend the rtalloc query functions to take mp and tp.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
