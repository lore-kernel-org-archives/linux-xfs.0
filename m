Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35770C83F15
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Aug 2023 06:33:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235924AbjH3Gcf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Aug 2023 02:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238767AbjH3Gc2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2023 02:32:28 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C191FCC
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 23:32:24 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1c06f6f98c0so40870895ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 23:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1693377144; x=1693981944; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/Yaa+JiqL48lPlq11gvte0grY7Fp/q2vqAUc+H5NAuE=;
        b=gj4dKrTsO8sc5xnujf5CmVEujgBCXkfNksVJQhnVvcwZqVdllRJ92XZ2eHa5oV6/6J
         Tk9ig7wJjZFASqbX3lacw2gfRiYanY5ifnuSHNGQEvj3t7OmPEIbfyI+wdpxOuqSU3z1
         t7ahq9F3yE4wMpCbQvBXPWJVBwMdQD//Ae5b1Yi+hoZILFjcy/qcFzpu4lUmCM7b7Xce
         szdjIaBuujePN1CIafv3UkBBJjlMWt+RO7NHmDN0VQHo3trd8WtoMaXl04iWbP+aeSCA
         Ua9UYx8TUXUomHvaM01EsXsW393LQJrcU43xIoMl/ol9lMgR3VPfFQ5Tn9Pj3KC3WRFB
         WvoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693377144; x=1693981944;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Yaa+JiqL48lPlq11gvte0grY7Fp/q2vqAUc+H5NAuE=;
        b=DM9bLd40xyB6eslb1H1CkI33pLnAQ5kE3HBxiL8tafHJ4mK9VVCtl/YECF+o1jblfd
         9IKz2tUWk/T2YwxZwE4IYFBAJxGOwZNicIPecTxpLIM0y3DLTYpLmkfpt2apOh4qfeb/
         c8ZKGvylpHzsD0f6V8NsG6vg844+ZX6SIysmIjgnq9eRy9WS3Wyez5nS5qSdtw1s8ZQd
         SN8bR3x+HL1EoRXP3T1VfzyQUMtIopSRMjwxAH6RfIT6fvod8YboYQOzS3gYTw2vUtFM
         u3POioiSp3fH+S67wWlIWxL2/6aBpcL40O6u0dsjLGBu5FStfGd7H8M9EO4xjnxZY2B+
         EcEw==
X-Gm-Message-State: AOJu0Yyxz/mZ4TPchRApwEEXYQeDxiECwLa7ztHtyDIeoUahKDlF8VYy
        0iQ4/4ToVDOCdEOSgeD5rAnz7Q==
X-Google-Smtp-Source: AGHT+IGJzqpXrXMa4nbC7BC1gIOD9TuoOrKtcLB7AFCoPm5yahhVN+Htk83F+sieaDfVbPg4Ka4fjA==
X-Received: by 2002:a17:902:d303:b0:1b9:de67:286f with SMTP id b3-20020a170902d30300b001b9de67286fmr1286565plc.49.1693377144008;
        Tue, 29 Aug 2023 23:32:24 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id e9-20020a170902744900b001b8b4730355sm10368726plt.287.2023.08.29.23.32.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 23:32:23 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qbEkV-008POJ-35;
        Wed, 30 Aug 2023 16:32:19 +1000
Date:   Wed, 30 Aug 2023 16:32:19 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] [RFC] xfs: reduce AGF hold times during fstrim operations
Message-ID: <ZO7ic6FqElir8L5r@dread.disaster.area>
References: <20230829065710.938039-1-david@fromorbit.com>
 <20230829155008.GD28186@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230829155008.GD28186@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 29, 2023 at 08:50:08AM -0700, Darrick J. Wong wrote:
> On Tue, Aug 29, 2023 at 04:57:10PM +1000, Dave Chinner wrote:
> > +/*
> > + * Notes on an efficient, low latency fstrim algorithm
> > + *
> > + * We need to walk the filesystem free space and issue discards on the free
> > + * space that meet the search criteria (size and location). We cannot issue
> > + * discards on extents that might be in use, or are so recently in use they are
> > + * still marked as busy. To serialise against extent state changes whilst we are
> > + * gathering extents to trim, we must hold the AGF lock to lock out other
> > + * allocations and extent free operations that might change extent state.
> > + *
> > + * However, we cannot just hold the AGF for the entire AG free space walk whilst
> > + * we issue discards on each free space that is found. Storage devices can have
> > + * extremely slow discard implementations (e.g. ceph RBD) and so walking a
> > + * couple of million free extents and issuing synchronous discards on each
> > + * extent can take a *long* time. Whilst we are doing this walk, nothing else
> > + * can access the AGF, and we can stall transactions and hence the log whilst
> > + * modifications wait for the AGF lock to be released. This can lead hung tasks
> > + * kicking the hung task timer and rebooting the system. This is bad.
> > + *
> > + * Hence we need to take a leaf from the bulkstat playbook. It takes the AGI
> > + * lock, gathers a range of inode cluster buffers that are allocated, drops the
> > + * AGI lock and then reads all the inode cluster buffers and processes them. It
> > + * loops doing this, using a cursor to keep track of where it is up to in the AG
> > + * for each iteration to restart the INOBT lookup from.
> > + *
> > + * We can't do this exactly with free space - once we drop the AGF lock, the
> > + * state of the free extent is out of our control and we cannot run a discard
> > + * safely on it in this situation. Unless, of course, we've marked the free
> > + * extent as busy and undergoing a discard operation whilst we held the AGF
> > + * locked.
> > + *
> > + * This is exactly how online discard works - free extents are marked busy when
> > + * they are freed, and once the extent free has been committed to the journal,
> > + * the busy extent record is marked as "undergoing discard" and the discard is
> > + * then issued on the free extent. Once the discard completes, the busy extent
> > + * record is removed and the extent is able to be allocated again.
> > + *
> > + * In the context of fstrim, if we find a free extent we need to discard, we
> > + * don't have to discard it immediately. All we need to do it record that free
> > + * extent as being busy and under discard, and all the allocation routines will
> > + * now avoid trying to allocate it. Hence if we mark the extent as busy under
> > + * the AGF lock, we can safely discard it without holding the AGF lock because
> > + * nothing will attempt to allocate that free space until the discard completes.
> 
> ...and if the cntbt search encounters a busy extent, it'll skip it.  I
> think that means that two FITRIM invocations running in lockstep can
> miss the extents being discarded by the other, right?

Yes.

> I think this can happen with your patch?
> 
> T0:				T1:
> xfs_alloc_read_agf
> walk cntbt,
>     add free space to busy list
> relse agf
> issue discards
> 
> 				xfs_alloc_read_agf
> ...still waiting...
> 				walk cntbt,
> 				    see all free space on busy list
> 				relse agf
> ...still waiting...
> 				"done" (despite discard in progress)
> 
> ...still waiting...
> io completion
> done

Yes, though it doesn't actually wait for discards to complete. It
issues discards without blocking until the submission queue is full,
then the discard being submitted then waits for a free slot (i.e.
waits for io completion). So submission of new discards is
effectively throttled to whatever speed discards are completing,
without having to have anything explicitly wait for completion.

> Whereas currently I think T1 will stubbornly wait for the AGF and then
> re-discard everything again.

Yes, that is the current behaviour, and it isn't good.

> I wonder, should FITRIM call
> xfs_extent_busy_flush if it finds already-busy extents?

Perhaps. Maybe we can replace the log force before we grab the AGF
lock with a flush if we see non-discard busy extents in the walk,
but I'm not sure we really care that much because fstrim is
advisory...


> > + * w.r.t. AG header locking. By keeping the batch size low, we can minimise the
> > + * AGF lock holdoffs whilst still safely being able to issue discards similar to
> > + * bulkstat. We can also issue discards asynchronously like we do with online
> 
> Can we rearrange that "Similar to bulkstat's inode batching behavior, we
> can minimise the AGF lock holdoffs [hold times?] whilst safely issuing
> discards."
> 
> My hot take on that sentence was "bulkstat doesn't do discards" :)

Sure. I knew what it meant, maybe not everyone else :)

> > + * discard, and so for fast devices fstrim will run much faster as we can
> > + * pipeline the free extent search with in flight discard IO.
> > + */
> > +
> > +struct xfs_trim_work {
> > +	struct xfs_perag	*pag;
> > +	struct list_head	busy_extents;
> > +	uint64_t		blocks_trimmed;
> > +	struct work_struct	discard_endio_work;
> > +};
> > +
> > +static int
> > +xfs_trim_gather_extents(
> >  	struct xfs_perag	*pag,
> >  	xfs_daddr_t		start,
> >  	xfs_daddr_t		end,
> >  	xfs_daddr_t		minlen,
> > -	uint64_t		*blocks_trimmed)
> > +	xfs_extlen_t		*longest,
> 
> What is this @longest value?  Is that a cursor for however far we've
> walked through the cntbt?

*nod*

> > +	struct xfs_trim_work	*twork)
> >  {
> >  	struct xfs_mount	*mp = pag->pag_mount;
> > -	struct block_device	*bdev = mp->m_ddev_targp->bt_bdev;
> >  	struct xfs_btree_cur	*cur;
> >  	struct xfs_buf		*agbp;
> >  	struct xfs_agf		*agf;
> >  	int			error;
> >  	int			i;
> > +	int			batch = 100;
> >  
> >  	/*
> >  	 * Force out the log.  This means any transactions that might have freed
> > @@ -50,17 +110,27 @@ xfs_trim_extents(
> >  	cur = xfs_allocbt_init_cursor(mp, NULL, agbp, pag, XFS_BTNUM_CNT);
> >  
> >  	/*
> > -	 * Look up the longest btree in the AGF and start with it.
> > +	 * Look up the extent length requested in the AGF and start with it.
> > +	 *
> > +	 * XXX: continuations really want a lt lookup here, so we get the
> > +	 * largest extent adjacent to the size finished off in the last batch.
> > +	 * The ge search here results in the extent discarded in the last batch
> > +	 * being discarded again before we move on to the smaller size...
> >  	 */
> > -	error = xfs_alloc_lookup_ge(cur, 0, be32_to_cpu(agf->agf_longest), &i);
> > +	error = xfs_alloc_lookup_ge(cur, 0, *longest, &i);
> 
> Aha, it /is/ a cursor for the cntbt walk.  In that case, why not pass
> around a xfs_alloc_rec_incore_t as the cursor, since cntbt lookups are
> capable of searching by blockcount and startblock?
> 
> Then you'd initialize it with
> 
> struct xfs_alloc_rec_incore tcur = {
> 	.ar_blockcount = pag->pagf_longest;
> };
> 
> and the XXX above turns into:
> 
> if (!tcur->ar_startblock)
> 	error = xfs_alloc_lookup_ge(cur, 0, tcur->ar_blockcount, &i);
> else
> 	error = xfs_alloc_lookup_lt(cur, tcur->ar_startblock,
> 			tcur->ar_blockcount, &i);

Yup, that's a good idea, and it solves the lookup problem I was
working around with the whacky batch handling....

> >  	if (error)
> >  		goto out_del_cursor;
> > +	if (i == 0) {
> > +		/* nothing of that length left in the AG, we are done */
> > +		*longest = 0;
> > +		goto out_del_cursor;
> > +	}
> >  
> >  	/*
> >  	 * Loop until we are done with all extents that are large
> > -	 * enough to be worth discarding.
> > +	 * enough to be worth discarding or we hit batch limits.
> >  	 */
> > -	while (i) {
> > +	while (i && batch-- > 0) {
> >  		xfs_agblock_t	fbno;
> >  		xfs_extlen_t	flen;
> >  		xfs_daddr_t	dbno;
> > @@ -75,6 +145,20 @@ xfs_trim_extents(
> >  		}
> >  		ASSERT(flen <= be32_to_cpu(agf->agf_longest));
> >  
> > +		/*
> > +		 * Keep going on this batch until we hit the record size
> > +		 * changes. That way we will start the next batch with the new
> > +		 * extent size and we don't get stuck on an extent size when
> > +		 * there are more extents of that size than the batch size.
> > +		 */
> > +		if (batch == 0) {
> > +			if (flen != *longest)
> > +				break;
> > +			batch++;

.... here.

> 
> Hmm.  So if the cntbt records are:
> 
> [N1, 100000]
> [N2, 1]
> [N3, 1]
> ...
> [N100001, 1]
> 
> Does that mean batch 1 is:
> 
> [N1, 100000]
> 
> and batch 2 is:
> 
> <100,000 single block extents>
> 
> (where presumably N1..N100001 do not overlap)?
> 
> That seems poorly balanced, especially for (bad) SSDs whose per-discard
> runtime is y = mx + b with a small m and huge b.

Yes, it is poorly balanced - I hadn't thought hard enough about how
to optimise the cursor and lookup yet (which your suggestion above
does nicely) and so I just made it so it doesn't get stuck and
doesn't skip random extents...

> (Yes I have an SSD like that...)
> 
> I think if you changed the cursor to a cntbt record, then you could
> bound the batch size by number of blocks, or number of busy extents,
> or both, right?

I think just batching by the number of busy extents is fine - we
don't actually care how long the discards take anymore because we
aren't holding the AGF lock and so the block count spanned by the
discards is irrelevant. Doing it in batches of 50-100 busy
extents means the gather operation is confined to a single btree
block....

.... and so maybe the right batch size is "gather all the free
extents in a single btree leaf" to discard....

> > +static int
> > +xfs_trim_extents(
> > +	struct xfs_perag	*pag,
> > +	xfs_daddr_t		start,
> > +	xfs_daddr_t		end,
> > +	xfs_daddr_t		minlen,
> > +	uint64_t		*blocks_trimmed)
> > +{
> > +	struct xfs_trim_work	*twork;
> > +	xfs_extlen_t		longest = pag->pagf_longest;
> > +	int			error = 0;
> > +
> > +	do {
> > +		LIST_HEAD(extents);
> > +
> > +		twork = kzalloc(sizeof(*twork), GFP_KERNEL);
> > +		if (!twork) {
> > +			error = -ENOMEM;
> > +			break;
> > +		}
> > +
> > +		atomic_inc(&pag->pag_active_ref);
> > +		twork->pag = pag;
> 
> twork->pag = xfs_perag_hold(pag); ?

hold() takes a passive ref, but because we don't wait for discards to
complete, we need to hold an active ref on the AG until all the
discards are done and and cleared from perag.

Thanks for looking at this and solving problems I didn't have good
solutions to yet.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
