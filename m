Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F11EC433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 15:30:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBE0261407
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 15:30:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhD1Pau (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 11:30:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53966 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229624AbhD1Pau (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Apr 2021 11:30:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619623804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JYFNlleKh3NZ7DFaQO8SlHiHUcmoVpnvmnKBDmWI2K0=;
        b=iXTyMaZghWdoOkm81sAmiXb1SS1egw1NJRg223s1xCCyu5ORiKXJuZ4sT7kUgrA1QcXpMv
        vJykuwR7w8iP7v/B/bC+jaTBgeNnFYh2sBf8ObNHaGnrBGX/hK7NIIgTJgCTIOwmXYIx2X
        hFfN6r/p45rPCesroPIdXomaB0xkEUw=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-PenBBkuuNHO0Znh7NkE4Yw-1; Wed, 28 Apr 2021 11:30:00 -0400
X-MC-Unique: PenBBkuuNHO0Znh7NkE4Yw-1
Received: by mail-qt1-f197.google.com with SMTP id 1-20020aed31010000b029019d1c685840so25537149qtg.3
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:30:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JYFNlleKh3NZ7DFaQO8SlHiHUcmoVpnvmnKBDmWI2K0=;
        b=SSyRKA1I91cY+yVcFwhrhI39jyHcaGEzHaisAPsXXmMhlZ5OSc7OVc3P1Bkhg+Ar3h
         +OOFiWzfJzC29YuJ5wnWh6gHPbkq30Vg31UcMXMMLU/gUdtQtDzXwthK5YM7E7Fp8Mak
         P+PnN81UTPJrrto9J4dwTd5u4lKAp8C+6LzbVZN17u2O6X9HqSdJ9kzdgIHrdXimvzhm
         L1xg1VJKfrG2168DTUKMQEMNx2WjlRJ7noPPmndPa84ObGZGgB6YQEdfeE4dXzRODVqV
         jvjn5a5ipSEQ/d20O0Zrv9Db5UZTo2XIN+zHTSZqLUKitVbHAaiVroZZlJbk6hKI2lNp
         9N5A==
X-Gm-Message-State: AOAM533qY0SkyTC8djxsCoEAUs72qbmm6kslGixGlc1mHqV3RRHCdNj/
        eehhyD8bRsVQCpcF4uZI3SFhShMV1V7R5sZ/X9b0m+oVnmP1D9RmujVIphTIAXwz0p69cU9/YIp
        5wjBDO9EBNWK0MCpteEiE
X-Received: by 2002:a05:620a:a96:: with SMTP id v22mr28998369qkg.347.1619623800239;
        Wed, 28 Apr 2021 08:30:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwuemF4lOovTUOF4JAIqhY4t1R3n0sl0z2OFqdOmLP83M2IcjYeW3S2op2Ng3CFS4yZY4qO8w==
X-Received: by 2002:a05:620a:a96:: with SMTP id v22mr28998354qkg.347.1619623800013;
        Wed, 28 Apr 2021 08:30:00 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id m14sm225575qtq.59.2021.04.28.08.29.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 08:29:59 -0700 (PDT)
Date:   Wed, 28 Apr 2021 11:29:57 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 2/3] xfs: introduce in-core global counter of allocbt
 blocks
Message-ID: <YIl/dTdCRLAOhFGf@bfoster>
References: <20210423131050.141140-1-bfoster@redhat.com>
 <20210423131050.141140-3-bfoster@redhat.com>
 <20210428041509.GH3122264@magnolia>
 <YIl4xEtHk7R6kj6k@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIl4xEtHk7R6kj6k@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 28, 2021 at 11:01:24AM -0400, Brian Foster wrote:
> On Tue, Apr 27, 2021 at 09:15:09PM -0700, Darrick J. Wong wrote:
> > On Fri, Apr 23, 2021 at 09:10:49AM -0400, Brian Foster wrote:
> > > Introduce an in-core counter to track the sum of all allocbt blocks
> > > used by the filesystem. This value is currently tracked per-ag via
> > > the ->agf_btreeblks field in the AGF, which also happens to include
> > > rmapbt blocks. A global, in-core count of allocbt blocks is required
> > > to identify the subset of global ->m_fdblocks that consists of
> > > unavailable blocks currently used for allocation btrees. To support
> > > this calculation at block reservation time, construct a similar
> > > global counter for allocbt blocks, populate it on first read of each
> > > AGF and update it as allocbt blocks are used and released.
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_alloc.c       | 12 ++++++++++++
> > >  fs/xfs/libxfs/xfs_alloc_btree.c |  2 ++
> > >  fs/xfs/xfs_mount.h              |  6 ++++++
> > >  3 files changed, 20 insertions(+)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > > index aaa19101bb2a..144e2d68245c 100644
> > > --- a/fs/xfs/libxfs/xfs_alloc.c
> > > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > > @@ -3036,6 +3036,7 @@ xfs_alloc_read_agf(
> > >  	struct xfs_agf		*agf;		/* ag freelist header */
> > >  	struct xfs_perag	*pag;		/* per allocation group data */
> > >  	int			error;
> > > +	uint32_t		allocbt_blks;
> > >  
> > >  	trace_xfs_alloc_read_agf(mp, agno);
> > >  
> > > @@ -3066,6 +3067,17 @@ xfs_alloc_read_agf(
> > >  		pag->pagf_refcount_level = be32_to_cpu(agf->agf_refcount_level);
> > >  		pag->pagf_init = 1;
> > >  		pag->pagf_agflreset = xfs_agfl_needs_reset(mp, agf);
> > > +
> > > +		/*
> > > +		 * Update the global in-core allocbt block counter. Filter
> > > +		 * rmapbt blocks from the on-disk counter because those are
> > > +		 * managed by perag reservation.
> > > +		 */
> > > +		if (pag->pagf_btreeblks > be32_to_cpu(agf->agf_rmap_blocks)) {
> > 
> > As pointed out elsewhere in the thread, agf_rmap_blocks counts the total
> > number of blocks in the rmapbt (whereas agf_btreeblks counts the number
> > of non-root blocks in all three free space btrees).  Does this need a
> > change?
> > 
> > 	int delta = (int)pag->pagf_btreeblks - (be32_to_cpu(...) - 1);
> > 	if (delta > 0)
> > 		atomic64_add(delta, &mp->m_allocbt_blks);
> >
> 
> Hm yes, this makes more sense. Will fix and update the comment..
> 

I ended up with the following:

		...
                /*
                 * Update the in-core allocbt counter. Filter out the rmapbt
                 * subset of the btreeblks counter because the rmapbt is managed
                 * by perag reservation. Subtract one for the rmapbt root block
                 * because the rmap counter includes it while the btreeblks
                 * counter only tracks non-root blocks.
                 */
                allocbt_blks = pag->pagf_btreeblks;
                if (xfs_sb_version_hasrmapbt(&mp->m_sb))
                        allocbt_blks -= be32_to_cpu(agf->agf_rmap_blocks) - 1;
                if (allocbt_blks > 0)
                        atomic64_add(allocbt_blks, &mp->m_allocbt_blks);
		...

Any thoughts before I post v5?

Brian

> Brian
>  
> > --D
> > 
> > > +			allocbt_blks = pag->pagf_btreeblks -
> > > +					be32_to_cpu(agf->agf_rmap_blocks);
> > > +			atomic64_add(allocbt_blks, &mp->m_allocbt_blks);
> > > +		}
> > >  	}
> > >  #ifdef DEBUG
> > >  	else if (!XFS_FORCED_SHUTDOWN(mp)) {
> > > diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> > > index 8e01231b308e..9f5a45f7baed 100644
> > > --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> > > +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> > > @@ -71,6 +71,7 @@ xfs_allocbt_alloc_block(
> > >  		return 0;
> > >  	}
> > >  
> > > +	atomic64_inc(&cur->bc_mp->m_allocbt_blks);
> > >  	xfs_extent_busy_reuse(cur->bc_mp, cur->bc_ag.agno, bno, 1, false);
> > >  
> > >  	xfs_trans_agbtree_delta(cur->bc_tp, 1);
> > > @@ -95,6 +96,7 @@ xfs_allocbt_free_block(
> > >  	if (error)
> > >  		return error;
> > >  
> > > +	atomic64_dec(&cur->bc_mp->m_allocbt_blks);
> > >  	xfs_extent_busy_insert(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1,
> > >  			      XFS_EXTENT_BUSY_SKIP_DISCARD);
> > >  	xfs_trans_agbtree_delta(cur->bc_tp, -1);
> > > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > > index 81829d19596e..bb67274ee23f 100644
> > > --- a/fs/xfs/xfs_mount.h
> > > +++ b/fs/xfs/xfs_mount.h
> > > @@ -170,6 +170,12 @@ typedef struct xfs_mount {
> > >  	 * extents or anything related to the rt device.
> > >  	 */
> > >  	struct percpu_counter	m_delalloc_blks;
> > > +	/*
> > > +	 * Global count of allocation btree blocks in use across all AGs. Only
> > > +	 * used when perag reservation is enabled. Helps prevent block
> > > +	 * reservation from attempting to reserve allocation btree blocks.
> > > +	 */
> > > +	atomic64_t		m_allocbt_blks;
> > >  
> > >  	struct radix_tree_root	m_perag_tree;	/* per-ag accounting info */
> > >  	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
> > > -- 
> > > 2.26.3
> > > 
> > 

