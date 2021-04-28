Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0095FC433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 15:02:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACF1C6141E
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 15:02:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbhD1PC5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 11:02:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49853 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239888AbhD1PCQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Apr 2021 11:02:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619622091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mmi+BNFQt43VAaVk4cTYBe9DgnJrvu/pvwNTGMWJhrM=;
        b=iHaAs+5ha1Pz/4wKj8ajEYELmONyAIBM5hOO3+JqD7t9RHgNgHaeIKVbF8uhg7eHWfcwls
        qlmbZqrqtBt4nZ9fQYnLJHog7WzasTEAd9Qciaap9J5JqiDSisu3bJryo1ig+lhysn7Kcx
        F+u3gYmsocR5srzKTs7F5l3T0sywgkw=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-BTahY-GxMQaXGcL8zRWeaA-1; Wed, 28 Apr 2021 11:01:29 -0400
X-MC-Unique: BTahY-GxMQaXGcL8zRWeaA-1
Received: by mail-qk1-f199.google.com with SMTP id m1-20020a05620a2201b02902e5493ba894so1473145qkh.17
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:01:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mmi+BNFQt43VAaVk4cTYBe9DgnJrvu/pvwNTGMWJhrM=;
        b=Qtbi/9EWHZd4ra0OH/mt5XOwp+pzWAOVxC/Yvea0cRxX68JbVh1nKd31ZcOmif4Qcj
         KEd8R1f755lEDhHH/GW/l4Z3bP+FpjxiwtXWz4A145wJkAsK46lMT1/BKeITPLhl3upD
         vykhSuPspauh9PhxstucYbHkrqWUdOI1BhpmoABoOc23ZtqJ0whKNC0/MO//pxa0kYxa
         Ni7refne1WplBny9MIdagu6xrgudiLyIWWYCzn2Ek/J4L2ul/YC8TpwuY/54qSeXTtJT
         zgMa8gPJpp6AoTHH94uGqN+IuBF+x/fO5hKabKBs4n7KgfL6CcLAA/aRjoZts4vW3t/O
         xa/A==
X-Gm-Message-State: AOAM532dBFf0VI28BJzprcyeQ53wGxdr3tLrya2XC6aHlREkL/hZVVcn
        vTbwwww0D8NiJiAsHAqLI4ty2zmAARQauE6NVFARBewKTSxai96QMCRkaR6vhF29pgV/s86yfW9
        2+JZq5mgjZrr2r/iAQix1
X-Received: by 2002:ac8:57cf:: with SMTP id w15mr27651576qta.336.1619622086908;
        Wed, 28 Apr 2021 08:01:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzUNal9UjgQnwyhR9ohOhnX9zzPbtvdz/i/qK5OjOVBrqheL6cnFw804/70XTDtsixRAQCJDA==
X-Received: by 2002:ac8:57cf:: with SMTP id w15mr27651558qta.336.1619622086654;
        Wed, 28 Apr 2021 08:01:26 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id d10sm5216744qki.122.2021.04.28.08.01.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 08:01:26 -0700 (PDT)
Date:   Wed, 28 Apr 2021 11:01:24 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 2/3] xfs: introduce in-core global counter of allocbt
 blocks
Message-ID: <YIl4xEtHk7R6kj6k@bfoster>
References: <20210423131050.141140-1-bfoster@redhat.com>
 <20210423131050.141140-3-bfoster@redhat.com>
 <20210428041509.GH3122264@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210428041509.GH3122264@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 27, 2021 at 09:15:09PM -0700, Darrick J. Wong wrote:
> On Fri, Apr 23, 2021 at 09:10:49AM -0400, Brian Foster wrote:
> > Introduce an in-core counter to track the sum of all allocbt blocks
> > used by the filesystem. This value is currently tracked per-ag via
> > the ->agf_btreeblks field in the AGF, which also happens to include
> > rmapbt blocks. A global, in-core count of allocbt blocks is required
> > to identify the subset of global ->m_fdblocks that consists of
> > unavailable blocks currently used for allocation btrees. To support
> > this calculation at block reservation time, construct a similar
> > global counter for allocbt blocks, populate it on first read of each
> > AGF and update it as allocbt blocks are used and released.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c       | 12 ++++++++++++
> >  fs/xfs/libxfs/xfs_alloc_btree.c |  2 ++
> >  fs/xfs/xfs_mount.h              |  6 ++++++
> >  3 files changed, 20 insertions(+)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index aaa19101bb2a..144e2d68245c 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -3036,6 +3036,7 @@ xfs_alloc_read_agf(
> >  	struct xfs_agf		*agf;		/* ag freelist header */
> >  	struct xfs_perag	*pag;		/* per allocation group data */
> >  	int			error;
> > +	uint32_t		allocbt_blks;
> >  
> >  	trace_xfs_alloc_read_agf(mp, agno);
> >  
> > @@ -3066,6 +3067,17 @@ xfs_alloc_read_agf(
> >  		pag->pagf_refcount_level = be32_to_cpu(agf->agf_refcount_level);
> >  		pag->pagf_init = 1;
> >  		pag->pagf_agflreset = xfs_agfl_needs_reset(mp, agf);
> > +
> > +		/*
> > +		 * Update the global in-core allocbt block counter. Filter
> > +		 * rmapbt blocks from the on-disk counter because those are
> > +		 * managed by perag reservation.
> > +		 */
> > +		if (pag->pagf_btreeblks > be32_to_cpu(agf->agf_rmap_blocks)) {
> 
> As pointed out elsewhere in the thread, agf_rmap_blocks counts the total
> number of blocks in the rmapbt (whereas agf_btreeblks counts the number
> of non-root blocks in all three free space btrees).  Does this need a
> change?
> 
> 	int delta = (int)pag->pagf_btreeblks - (be32_to_cpu(...) - 1);
> 	if (delta > 0)
> 		atomic64_add(delta, &mp->m_allocbt_blks);
>

Hm yes, this makes more sense. Will fix and update the comment..

Brian
 
> --D
> 
> > +			allocbt_blks = pag->pagf_btreeblks -
> > +					be32_to_cpu(agf->agf_rmap_blocks);
> > +			atomic64_add(allocbt_blks, &mp->m_allocbt_blks);
> > +		}
> >  	}
> >  #ifdef DEBUG
> >  	else if (!XFS_FORCED_SHUTDOWN(mp)) {
> > diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> > index 8e01231b308e..9f5a45f7baed 100644
> > --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> > +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> > @@ -71,6 +71,7 @@ xfs_allocbt_alloc_block(
> >  		return 0;
> >  	}
> >  
> > +	atomic64_inc(&cur->bc_mp->m_allocbt_blks);
> >  	xfs_extent_busy_reuse(cur->bc_mp, cur->bc_ag.agno, bno, 1, false);
> >  
> >  	xfs_trans_agbtree_delta(cur->bc_tp, 1);
> > @@ -95,6 +96,7 @@ xfs_allocbt_free_block(
> >  	if (error)
> >  		return error;
> >  
> > +	atomic64_dec(&cur->bc_mp->m_allocbt_blks);
> >  	xfs_extent_busy_insert(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1,
> >  			      XFS_EXTENT_BUSY_SKIP_DISCARD);
> >  	xfs_trans_agbtree_delta(cur->bc_tp, -1);
> > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > index 81829d19596e..bb67274ee23f 100644
> > --- a/fs/xfs/xfs_mount.h
> > +++ b/fs/xfs/xfs_mount.h
> > @@ -170,6 +170,12 @@ typedef struct xfs_mount {
> >  	 * extents or anything related to the rt device.
> >  	 */
> >  	struct percpu_counter	m_delalloc_blks;
> > +	/*
> > +	 * Global count of allocation btree blocks in use across all AGs. Only
> > +	 * used when perag reservation is enabled. Helps prevent block
> > +	 * reservation from attempting to reserve allocation btree blocks.
> > +	 */
> > +	atomic64_t		m_allocbt_blks;
> >  
> >  	struct radix_tree_root	m_perag_tree;	/* per-ag accounting info */
> >  	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
> > -- 
> > 2.26.3
> > 
> 

