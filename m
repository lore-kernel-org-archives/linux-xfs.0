Received: from buffalo.tulip.relay.mailchannels.net (buffalo.tulip.relay.mailchannels.net [23.83.218.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465F228E8
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jul 2024 06:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721717918; cv=pass; b=SJ5G4CuRUNI9QHwlTvHcgaIIEmK+VQFhKuRQh1YG2pxye6J82aMYQ462m9Ujd3QlCD4ZX+dupzvvYiYnFiflDaU07falpC/O5IHCwWhbaAr1fAVNak7iYju0PoYyRrjOjjahhsGK/UJZRqg9Auv4ZqN06VA/GfpquCK53bwHirs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721717918; c=relaxed/simple;
	bh=wXsajKHZhXL8bL8eRUXHOsm+kwACo2NpylUqkjDDMuk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X7PygxU0LdN3MT53ccoG1yT7GKmnXgv30EgzrAqXXYr044kKmV4y9CyOzz2Qf0QHLstekcZI2ed90kiVso3i2QmgEOQ9Chu1reGSnf0HgzWbNl1KNwYHZDJh58xoAjdz/fNxsNWkw0ijPt95gxYEUg/4uWKF4p4FIDMv/eq3vs4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com; spf=pass smtp.mailfrom=templeofstupid.com; dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b=GGkcQYf4; arc=pass smtp.client-ip=23.83.218.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b="GGkcQYf4"
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id E2AF184763
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jul 2024 06:51:27 +0000 (UTC)
Received: from pdx1-sub0-mail-a223.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 890DC840BF
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jul 2024 06:51:27 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1721717487; a=rsa-sha256;
	cv=none;
	b=T1QmMo+ML8QDDz9jCPem5T4kEMUkyBu+kZmJ0jqUwcmvkHS9bK4mUkWrZnYeqoI9qpR7Fu
	iNVTC7BMUxGVl2loMr6cZZq9LEnRFmocab1RR/6wF46kwjJIj9MC02eTD1NfE5ptzJmmbi
	dVF3+yComVgZx0FEwkppE3GBTsGbAtZSOyu94jnys4Swzk9nCtITOBHNKl0QV1LizKpx2/
	qcI59Ce+yjWmoZmcj+rIQ60Cg9eH1fopgzpLWQdxNv+BKtNXQLiBCRI8+4VZbLDfNC4Q6v
	6Jght8ZgLfNk1/pQ3tNUPyDeisZJ8A1jPhSehPT5h3YWShFYG3eI+J/fxjXTzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1721717487;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NobN3ef0kIpy9AQQC1e5rqapbjc5z98zE24+JT+yFfI=;
	b=y7HiP8wVDRF0Q/WQ3ILovzGly7+X5PCIy5Pur6Y2kL1rtZidNZWlvDYj7OW1Hp77xwAk9P
	naEZO+vrfe/YcrtIP33unO6UN19CNovrGDITJe2jMqMyq5fkEm0sI539K5hVRvMZp4+ttv
	L+kKRL199ro9+4nQiYkRzL+IRAlr4urd4vw57rtkRJznLAdhDGg0TLnbtI1RuaESRQ1A18
	qzNnb5jygyTkNXYA4HyK9XITJAGWed62iI6KKs4gMTdfgU3kqdS7kTqPlQErKXaBqvYkZv
	Hwzeb6C7WDQFFBbS3E5/pI72OCg97ATvou64/NHvV6mz/QtXF44FVAbyl9lKGw==
ARC-Authentication-Results: i=1;
	rspamd-6c89c58bd7-cvhbj;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=kjlx@templeofstupid.com
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MailChannels-Auth-Id: dreamhost
X-Imminent-Power: 3ea3198e613a1d64_1721717487810_271112066
X-MC-Loop-Signature: 1721717487810:3288459392
X-MC-Ingress-Time: 1721717487810
Received: from pdx1-sub0-mail-a223.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.123.56.197 (trex/7.0.2);
	Tue, 23 Jul 2024 06:51:27 +0000
Received: from kmjvbox.templeofstupid.com (c-73-70-109-47.hsd1.ca.comcast.net [73.70.109.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kjlx@templeofstupid.com)
	by pdx1-sub0-mail-a223.dreamhost.com (Postfix) with ESMTPSA id 4WSnqg1VL5zJD
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jul 2024 23:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=templeofstupid.com;
	s=dreamhost; t=1721717487;
	bh=NobN3ef0kIpy9AQQC1e5rqapbjc5z98zE24+JT+yFfI=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=GGkcQYf4IbtC5wiSuT+8JZO+WLyB+XqCOAqCSQu2LBwZbWacL9jwXtz4iM/Q7KEYO
	 JqWBdt66alzF24MZeQxoiyI6W75nKbG6BvGd9uYwJwQ7e2dlN/QnK2o6VaXbNnwXAG
	 7d90LDURu5MPqcHa4wYpQxth4g8d0boMG6YKJjpnvhK+h6ubjc/mhLcdOxeIgzbu1z
	 x1dtJIv81IEW0jk92cWS/OUpodqw0FxUnkrJU6Que0X4JP0Y3vjIVPTipUD2V81Wq8
	 1HgXyJqByNiru2NE0XHH9cIrF+ZnVcKGE6iTL9fpW+5NGAr2VD9KaABOLeLIfcXOPK
	 wMbBaWTvWxkRA==
Received: from johansen (uid 1000)
	(envelope-from kjlx@templeofstupid.com)
	id e00e1
	by kmjvbox.templeofstupid.com (DragonFly Mail Agent v0.12);
	Mon, 22 Jul 2024 23:51:25 -0700
Date: Mon, 22 Jul 2024 23:51:25 -0700
From: Krister Johansen <kjlx@templeofstupid.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, Gao Xiang <xiang@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] xfs: resurrect the AGFL reservation
Message-ID: <20240723065125.GA2039@templeofstupid.com>
References: <cover.1718232004.git.kjlx@templeofstupid.com>
 <0dfbe8d00d2be53999b20e336641ba3d60306ffa.1718232004.git.kjlx@templeofstupid.com>
 <ZmuyFCG/jQrrRb6N@dread.disaster.area>
 <20240617234631.GC2044@templeofstupid.com>
 <ZoyeYBW7CvWJdWsu@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZoyeYBW7CvWJdWsu@dread.disaster.area>

[ My turn to apologize.  I had a couple of short weeks at the beginning
of July, but have finally been able to get back to this. ]

On Tue, Jul 09, 2024 at 12:20:16PM +1000, Dave Chinner wrote:
> On Mon, Jun 17, 2024 at 04:46:31PM -0700, Krister Johansen wrote:
> > On Fri, Jun 14, 2024 at 12:59:32PM +1000, Dave Chinner wrote:
> > > On Thu, Jun 13, 2024 at 01:27:26PM -0700, Krister Johansen wrote:
> > > > Transactions that perform multiple allocations may inadvertently run out
> > > > of space after the first allocation selects an AG that appears to have
> > > > enough available space.  The problem occurs when the allocation in the
> > > > transaction splits freespace b-trees but the second allocation does not
> > > > have enough available space to refill the AGFL.  This results in an
> > > > aborted transaction and a filesystem shutdown.  In this author's case,
> > > > it's frequently encountered in the xfs_bmap_extents_to_btree path on a
> > > > write to an AG that's almost reached its limits.
> > > > 
> > > > The AGFL reservation allows us to save some blocks to refill the AGFL to
> > > > its minimum level in an Nth allocation, and to prevent allocations from
> > > > proceeding when there's not enough reserved space to accommodate the
> > > > refill.
> > > > 
> > > > This patch just brings back the reservation and does the plumbing.  The
> > > > policy decisions about which allocations to allow will be in a
> > > > subsequent patch.
> > > > 
> > > > This implementation includes space for the bnobt and cnobt in the
> > > > reserve.  This was done largely because the AGFL reserve stubs appeared
> > > > to already be doing it this way.
> > > > 
> > > > Signed-off-by: Krister Johansen <kjlx@templeofstupid.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_ag.h          |  2 ++
> > > >  fs/xfs/libxfs/xfs_ag_resv.c     | 54 ++++++++++++++++++++++--------
> > > >  fs/xfs/libxfs/xfs_ag_resv.h     |  4 +++
> > > >  fs/xfs/libxfs/xfs_alloc.c       | 43 +++++++++++++++++++++++-
> > > >  fs/xfs/libxfs/xfs_alloc.h       |  3 +-
> > > >  fs/xfs/libxfs/xfs_alloc_btree.c | 59 +++++++++++++++++++++++++++++++++
> > > >  fs/xfs/libxfs/xfs_alloc_btree.h |  5 +++
> > > >  fs/xfs/libxfs/xfs_rmap_btree.c  |  5 +++
> > > >  fs/xfs/scrub/fscounters.c       |  1 +
> > > >  9 files changed, 161 insertions(+), 15 deletions(-)
> > > > diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> > > > index 35de09a2516c..40bff82f2b7e 100644
> > > > --- a/fs/xfs/libxfs/xfs_ag.h
> > > > +++ b/fs/xfs/libxfs/xfs_ag.h
> > > > @@ -62,6 +62,8 @@ struct xfs_perag {
> > > >  	struct xfs_ag_resv	pag_meta_resv;
> > > >  	/* Blocks reserved for the reverse mapping btree. */
> > > >  	struct xfs_ag_resv	pag_rmapbt_resv;
> > > > +	/* Blocks reserved for the AGFL. */
> > > > +	struct xfs_ag_resv	pag_agfl_resv;
> > > 

<snip>

> Not quite. Btrees don't work that way - once you split the root
> block, it can't be split again until the root block fills. That
> means we have to split the level below the root block enough times
> to fill the root block. And that requires splitting the level below
> that enough times to fill and split the second level enough times to
> fill the root block. The number of inserts needed to split the root
> block increases exponentially with the height of the tree.
> 
> Hence if we've got a height of 2 and 10 records/ptrs per leaf/node,
> a full tree looks like this:
> 
> Level 1			0123456789
>                         ||.......|
>         /---------------/|.......\---------------\
>         |                |                       |
> Level 0	0123456789	 0123456789	.....	0123456789
> 
> If we do an insert anywhere we'll get a full height split and a new
> root at level 2. Lets insert record A in the leaf at the left edge:
> 
> Level 2			01
>                         ||
>                 /-------/\------\
>                 |               |
> Level 1		0A1234		56789
>                 |||...	        ....|
>         /-------/|\------\	....\------------\
>         |        |        |                       |
> Level 0	01234    A56789	 0123456789	.....	0123456789
> 
> It should be obvious now that a followup insertion anywhere in the
> tree cannot split either the root node at level 2, nor the old root
> node that was split in two at level 1.
> 
> Yes, we can still split at level 0, but that will only result in
> nodes at level 1 getting updated, and only once they are full will
> they start splitting at level 1. And then level 2 (the root) won't
> split until level 1 has split enough to fill all the nodes in level
> 1.
> 
> What this means is that for any single insertion into a btree, the
> worst case demand for new blocks is "current height + 1". In the
> case of BMBT, INOBT and REFCOUNBT, we're typically only doing one or
> two adjacent record insertions in a given operation, so only one
> split will occur during the operation. The free space trees are
> different, however.
> 
> When the first allocation occurs, we split the tree as per above
> and that consumes (start height + 1) blocks from AGFL. We then
> get the next BMBT allocation request (because it's doing a
> multi-level split), and the best free space we find is, this time,
> in the leaf at the right side of the tree. Hence we split that
> block, but we don't need to split it's parent (level 1) block
> because it has free space in it. Hence the second allocation has
> a worst case block requirement of (start height - 1).
> 
> If we then do a third allocation (level 2 of the BMBT is splitting),
> and that lands in the middle of the tree, we split that block. That
> can be inserted into either of the level 1 blocks without causing a
> split there, either. Hence a worst case block requirement for that
> is also (start height - 1).
> 
> It's only once we've split enough blocks at (start height - 1) that
> to fill both blocks at start height that we'll get a larger split.
> We had ten blocks at level 0 to begin with, 11 after the first full
> hieght split, so we need, at minimum, another 9 splits at level 0 to
> fill level 1. This means we then have all the leaf blocks at either
> 5 or 6 records at the time the level 1 nodes fill. To then get
> another insert into level 1 to split that, we need to fill a minimum
> of -3 sibling- leaf blocks.
> 
> The reason we need to fill 3 leaf blocks and not 1 is that we shift
> records between left and right siblings instead of splitting. i.e.
> we steal space from a sibling in preference to splitting and
> inserting a new record into the parent. Hence we only insert into
> the parent when the insert node and both siblings are full
> completely full.
> 
> When we look at a typical AG btree on a v5 filesystem, we have at
> least 110 records/ptrs per block (1kB block size) so the minimum
> number of record inserts needed before we need to split a parent
> again after it was just split is at least 150 inserts.
> 
> Hence after a full height split, we are not going to split a node at
> the old root level again until at least 150 inserts (1kB block size)
> are done at the child level.
> 
> IOWs, we're never going to get two start height splits in a single
> allocation chain. At most we are going to get one start height split
> and then N (start height - 1) splits. That's the worst case AGFL we
> need to consider, but such a split chain would be so infintesimally
> probably that always reserving that amount of space in the AGFL is
> just a waste of space because it will never, ever be used.
> 
> So the worst case AGFL requirement for a data extent allocation or
> free will be:
> 
> 	1. data extent - full free space tree split * 2 + rmapbt
> 	2. BMBT leaf split - (free space height - 2) * 2 + rmapbt
> 	3. BMBT node split - (free space height - 2) * 2 + rmapbt
> 	....
> 	N. BMBT root split - (free space height - 2) * 2 + rmapbt
> 
> So the maximum number of chained allocations is likely going to be
> something like:
> 
> 	(max AGFL for one allocation) +
> 	((max bmbt/refcountbt height) * (max agfl for dependent allocation))
> 
> Which is likely to be in the order of...
> 
> > > So I wouldn't expect the AGFL reserve pool to be any larger than a
> > > couple of hundred blocks in the worst case.
> 
> ... this.

Thanks for the detailed explanation.  It helps.

I do have a few followup questions on this part.

What strategy would you recommend we use to calculate the 'rmapbt'
portion of this equation?  I've defaulted to the same strategy of a
single full-space rmapbt tree split, plus N (height - 2) splits, but
instead of using the free space height I used the maxlevel in
m_rmap_maxlevels.  Does that sound correct to you?

For trees that are short, like a free-space reservation with a max
height of 2, this math actually yields a smaller number of blocks than
the constants it might replace below.  In the case of a b-tree with a
max height of 2, do we assume then that we'd only need 2 blocks to
handle the full split, and the remaining dependent allocations would not
consume any more space as records are added to the tree?  (It sounds like
yes, but wanted to confirm)

> [ And now we disappear down the rabbit hole. ]
> 
> Take a look at xfs_alloc_ag_max_usable(), which is used to set
> mp->m_ag_max_usable:
> 
> 	blocks = XFS_BB_TO_FSB(mp, XFS_FSS_TO_BB(mp, 4)); /* ag headers */
>         blocks += XFS_ALLOCBT_AGFL_RESERVE;
>         blocks += 3;                    /* AGF, AGI btree root blocks */
> 	....
> 
> There's a number of blocks reserved for the AGFL that aren't usable
> already. What is that value for?
> 
> /*
>  * The number of blocks per AG that we withhold from xfs_dec_fdblocks to
>  * guarantee that we can refill the AGFL prior to allocating space in a nearly
>  * full AG.  Although the space described by the free space btrees, the
>  * blocks used by the freesp btrees themselves, and the blocks owned by the
>  * AGFL are counted in the ondisk fdblocks, it's a mistake to let the ondisk
>  * free space in the AG drop so low that the free space btrees cannot refill an
>  * empty AGFL up to the minimum level.  Rather than grind through empty AGs
>  * until the fs goes down, we subtract this many AG blocks from the incore
>  * fdblocks to ensure user allocation does not overcommit the space the
>  * filesystem needs for the AGFLs.  The rmap btree uses a per-AG reservation to
>  * withhold space from xfs_dec_fdblocks, so we do not account for that here.
>  */
> #define XFS_ALLOCBT_AGFL_RESERVE        4
> 
> What is this magic number of 4, then?
> 
> Remember what I said above about the free space btree blocks being
> accounted as free space and that freeing extents are always allowed
> to go ahead, even when the AG is full?
> 
> This AGFL reserve is the minimum space needed for an extent free to
> successfully refill the AGFL at ENOSPC to allow the extent free to
> proceed. That is, both trees have a singel level, so a full height
> split of either tree will require 2 blocks to be allocated. 2
> freespace trees per AG, two blocks per tree, and so we need 4 blocks
> per AG to ensure freeing extents at ENOSPC will always succeed.
> 
> This "magic 4" blocks isn't valid when we have rmapbt, recountbt, or
> finobt reservations in the AG anymore, because ENOSPC can occur when
> we still have multi-level bno/cnt btrees in the AG. That's the first
> thing we need to fix.
> 
> This AGFL set aside is taken out of the global free space pool via
> this function:
> 
> /*
>  * Compute the number of blocks that we set aside to guarantee the ability to
>  * refill the AGFL and handle a full bmap btree split.
>  *
>  * In order to avoid ENOSPC-related deadlock caused by out-of-order locking of
>  * AGF buffer (PV 947395), we place constraints on the relationship among
>  * actual allocations for data blocks, freelist blocks, and potential file data
>  * bmap btree blocks. However, these restrictions may result in no actual space
>  * allocated for a delayed extent, for example, a data block in a certain AG is
>  * allocated but there is no additional block for the additional bmap btree
>  * block due to a split of the bmap btree of the file. The result of this may
>  * lead to an infinite loop when the file gets flushed to disk and all delayed
>  * extents need to be actually allocated. To get around this, we explicitly set
>  * aside a few blocks which will not be reserved in delayed allocation.
>  *
>  * For each AG, we need to reserve enough blocks to replenish a totally empty
>  * AGFL and 4 more to handle a potential split of the file's bmap btree.
>  */
> unsigned int
> xfs_alloc_set_aside(
>         struct xfs_mount        *mp)
> {
>         return mp->m_sb.sb_agcount * (XFS_ALLOCBT_AGFL_RESERVE + 4);
> }
> 
> But where did that magic number of "4 more to handle a potential
> split of the file's bmap btree" come from?
> 
> Ah, a fix I made for a ENOSPC regression back in 2006:
> 
> + * ..... Considering the minimum number of
> + * needed freelist blocks is 4 fsbs _per AG_, a potential split of file's bmap
> + * btree requires 1 fsb, so we set the number of set-aside blocks
> + * to 4 + 4*agcount.
> + */
> +#define XFS_ALLOC_SET_ASIDE(mp)  (4 + ((mp)->m_sb.sb_agcount * 4))
> 
> That was fixing a regression caused by an ENOSPC deadlock bug fix
> done for SGI PV 947395.
> 
> commit 96b336c71016a85cd193762199aa6f99f543b6fe
> Author: Yingping Lu <yingping@sgi.com>
> Date:   Tue May 23 19:28:08 2006 +0000
> 
>     In actual allocation of file system blocks and freeing extents, the transaction
>     within each such operation may involve multiple locking of AGF buffer. While the
>     freeing extent function has sorted the extents based on AGF number before entering
>     into transaction, however, when the file system space is very limited, the allocation
>     of space would try every AGF to get space allocated, this could potentially cause
>     out-of-order locking, thus deadlock could happen. This fix mitigates the scarce space
>     for allocation by setting aside a few blocks without reservation, and avoid deadlock
>     by maintaining ascending order of AGF locking.
>     Add a new flag XFS_ALLOC_FLAG_FREEING to indicate whether the caller is freeing or
>     allocating. Add a field firstblock in structure xfs_alloc_arg to indicate whether
>     this is the first allocation request.
> 
> Which included this:
> 
> + * ...... Considering the minimum number of
> + * needed freelist blocks is 4 fsbs, a potential split of file's bmap
> + * btree requires 1 fsb, so we set the number of set-aside blocks to 8.
> +*/
> +#define SET_ASIDE_BLOCKS 8
> 
> <ding!>
> 
> Ah, now I get it. It's only taken me 18 years to really understand
> how this value was originally derived and why it is wrong.
> 
> It assumed 4 blocks for the AGFL for the initial allocation to fill
> and empty AGFL, and then 4 more blocks for the AGFL to allow a
> refill for the subsequent BMBT block allocation to refill the AGFL.
> IOWs, it wasn't reserving blocks for the BMBT itself, it was
> reserving blocks for a second AGFL refill in the allocation chain....
> 
> Right, so I think what we need to change is XFS_ALLOCBT_AGFL_RESERVE
> and xfs_alloc_set_aside() to reflect the worst case size of the free
> space trees when we hit ENOSPC for user data, not a hard coded 4 + 4.
> 
> The worst case free space tree size is going to be single block free
> records when all the per-ag reservations are at their maximum
> values. So we need to calculate maximum reservation sizes for the
> AG, then calculate how many btree blocks that will require to index
> as single block free space extents, then calculate the hieght of the
> btrees needs to index that. That gives us out "free space tree
> height at ENOSPC", and then we can calculate how many AGFL blocks we
> need at ENOSPC to handle a split of both trees. That value replaces
> XFS_ALLOCBT_AGFL_RESERVE.

Just to confirm, this would be
xfs_btree_compute_maxlevels(mp->m_alloc_mnr, n_perag_resvd_blocks),
correct?

> As for the BMBT split requiring more AGFL refills, we need to know
> what the maximum BMBT height the fs supports is (I think we already
> calculate that), and that then becomes the level we feed into the
> "how many AGFL blocks do we need in a full height BMBT split
> allocation chain. I did that math above, and that calculation
> should replace the "+ 4" in xfs_alloc_set_aside(). I think that
> ends up with the calculation being something like:
> 
> setaside = agcount * (number of dependent allocations *
> 			AGFL blocks for refill at ENOSPC)
> 
> I think we also need to make mp->m_ag_max_usable also take into
> account the BMBT split related AGFL refills as xfs_alloc_set_aside()
> as it only considers XFS_ALLOCBT_AGFL_RESERVE right now. That will
> ensure we always have those blocks available for the AGFL.

Thanks, this was convincing enough that I went off to prototype
something that tried to faithfully follow your advice.

> Fair summary. this is already long, and I think what I discovered
> above kinda comes under:
> 
> > 4. Implement a less ambitious AGFL reserve
> 
> That's what we did back in 2006 - we just carved out the smallest
> amount of blocks we needed from the free space pool to ensure the
> failing case worked.
> 
> > The draft in this thread tried to track all AGFL blocks from their
> > allocation and continued to account for them during their lifetime in
> > the bnobt and cnobt.  Instead of trying to build a reserve for all free
> > space management blocks that aren't rmapbt, reduce the scope of the AGFL
> > reserve to be just the number of blocks needed to satsify a single
> > transaction with multiple allocations that occurs close to an AG's
> > ENOSPC.
> 
> Yes, and that's what I suggest we extend xfs_alloc_set_aside() and
> mp->m_ag_max_usable to encompass. That way we don't actually need to
> track anything, the AGs will always have that space available to use
> because mp->m_ag_max_usable prevents them from being used by
> anything else.
> 
> > Do any of these approaches stand out as clearly better (or worse) to
> > you?
> 
> I think I've convinced myself that we already use option 4 and the
> accounting just needs extending to reserve the correct amount of
> blocks...

I've got something that sets the mp->m_ag_max_usable and
alloc_set_aside() to the values discussed above.  For demonstration
purposes, since I was ending up with numbers that were smaller than
XFS_ALLOCBT_AGFL_RESERVE + 4, I just picked some slightly different math
that inflated these numbers a bit to validate the assumptions.

I'm still able to run AG low enough on space to hit the bug with these
modifcations in place, partly because mp->m_ag_max_usable seems to place
an upper bound on large contiguous allocations in
xfs_alloc_space_available().  E.g. if I allocate in small chunks <
m_ag_max_usable, I can still run pagf_freeblks down to about the per-ag
reservation.  The test is explicit about only using space from a single
AG, which defeats the global reservation checks, since enough space
remains free in the other AGs that we don't hit any of the
per-filesystem reservation limits.

It seems like we've got the right general concept, but may need to make
a few more tweaks to the implementation.

In terms of where to go next, I have a few ideas, but would certainly
appreciate additional input.

One was to investigate propagating the per-AG set-aside into
xfs_alloc_space_available() so that it's only eligible for consumption
by a dependent allocation.  (Is the correct way to determine that by
checking tp->t_highest_agno != NULLAGNUMBER?)

The other was to determine if I needed add the quantity from
xfs_alloc_min_freelist(free space height) to the set-aside.  The reason
for this was that if the reserved free space can be indexed by a tree of
height 2, then the full split only needs 2 blocks, but once we've split
to a tree of that height, xfs_alloc_min_freelist() requires 12 blocks
free (with rmap off) to continue the allocation chain, even if we're
never going to allocate that many.  It's that edge case that these tests
always manage to hit: run the pagf_freeblks within a block or two of the
per-ag reservation, and then split a free-space b-tree right before a
BMBT split.  IOW, I need both the blocks for the b-tree expansion and
enough to satisfy the xfs_alloc_min_freelist() checks.  If you explained
this earlier, and I'm reading the equations too pedantically, my
apologies.

I also ran into a bit of a snag in the testing department after merging
with 673cd885bbbf ("xfs: honor init_xattrs in xfs_init_new_inode for !ATTR fs")
I understand broadly why this is needed, but it does modify when an
inode converts from extents to b-tree.  I couldn't find a way to disable
this behavior via mkfs or a mount option for testing purposes.  Are you
aware of a switch I may have missed?

> > Thanks again for taking the time to read through these patches and
> > provide feedback.  I appreciate all the comments, ideas, and
> > explanations.
> 
> Don't thank me - I've got to thank you for taking the time and
> effort to understand this complex code well enough to ask exactly
> the right question.  It's not often that answering a question on how
> to do something causes a whole bunch of not quite connected floating
> pieces in my head to suddenly fall and land in exactly the right
> places... :)

I do very much appreciate the detailed explanations and the feedback, so
it seemed like an expression of gratitude was appropriate.  Thanks for
your willingness to answer these questions in such detail.

-K
