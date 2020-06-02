Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A041EC433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 19:33:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74D722074B
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 19:33:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q/IMPwLD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbgFBTdP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 15:33:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26149 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726267AbgFBTdO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 15:33:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591126391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=29FPtk2HQw2RWYJEC7cNhWNMQPvmv5JwIE0mErFCZRo=;
        b=Q/IMPwLD8mWGNJZDN4G8oGEKXHmFZCV9Qpc9ourDGWWbfhhaVVkA6KPABezjMIhvVm54B9
        LNxP/i3FBRbV7USnHp1EMaIOP6SHeqCMzGXRtMzGEXcyhcAmwYn+OKU/oc8aa9CEbJ7EMQ
        ON7jI+9yt0LTe5+dVOpxIf3OtmMVfnk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-ZySJ3Up2MaCH9Ff79-iFzg-1; Tue, 02 Jun 2020 15:33:09 -0400
X-MC-Unique: ZySJ3Up2MaCH9Ff79-iFzg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66FADEC1A0;
        Tue,  2 Jun 2020 19:33:08 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 11AE619C4F;
        Tue,  2 Jun 2020 19:33:07 +0000 (UTC)
Date:   Tue, 2 Jun 2020 15:33:06 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: preserve rmapbt swapext block reservation from
 freed blocks
Message-ID: <20200602193306.GI7967@bfoster>
References: <20200602180206.9334-1-bfoster@redhat.com>
 <20200602182910.GE8230@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602182910.GE8230@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 02, 2020 at 11:29:10AM -0700, Darrick J. Wong wrote:
> On Tue, Jun 02, 2020 at 02:02:06PM -0400, Brian Foster wrote:
> > The rmapbt extent swap algorithm remaps individual extents between
> > the source inode and the target to trigger reverse mapping metadata
> > updates. If either inode straddles a format or other bmap allocation
> > boundary, the individual unmap and map cycles can trigger repeated
> > bmap block allocations and frees as the extent count bounces back
> > and forth across the boundary. While net block usage is bound across
> > the swap operation, this behavior can prematurely exhaust the
> > transaction block reservation because it continuously drains as the
> > transaction rolls. Each allocation accounts against the reservation
> > and each free returns to global free space on transaction roll.
> > 
> > The previous workaround to this problem attempted to detect this
> > boundary condition and provide surplus block reservation to
> > acommodate it. This is insufficient because more remaps can occur
> > than implied by the extent counts; if start offset boundaries are
> > not aligned between the two inodes, for example.
> > 
> > To address this problem more generically and dynamically, add a
> > transaction accounting mode that returns freed blocks to the
> > transaction reservation instead of the superblock counters on
> > transaction roll and use it when the rmapbt based algorithm is
> > active. This allows the chain of remap transactions to preserve the
> > block reservation based own its own frees and prevent premature
> > exhaustion regardless of the remap pattern. Note that this is only
> > safe for superblocks with lazy sb accounting, but the latter is
> > required for v5 supers and the rmap feature depends on v5.
> > 
> > Fixes: b3fed434822d0 ("xfs: account format bouncing into rmapbt swapext tx reservation")
> > Root-caused-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > v1:
> > - Use a transaction flag to isolate behavior to rmapbt swapext.
> > rfc: https://lore.kernel.org/linux-xfs/20200522171828.53440-1-bfoster@redhat.com/
> > 
> >  fs/xfs/libxfs/xfs_shared.h |  1 +
> >  fs/xfs/xfs_bmap_util.c     | 18 +++++++++---------
> >  fs/xfs/xfs_trans.c         | 13 ++++++++++++-
> >  3 files changed, 22 insertions(+), 10 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> > index c45acbd3add9..708feb8eac76 100644
> > --- a/fs/xfs/libxfs/xfs_shared.h
> > +++ b/fs/xfs/libxfs/xfs_shared.h
> > @@ -65,6 +65,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
> >  #define XFS_TRANS_DQ_DIRTY	0x10	/* at least one dquot in trx dirty */
> >  #define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
> >  #define XFS_TRANS_NO_WRITECOUNT 0x40	/* do not elevate SB writecount */
> > +#define XFS_TRANS_RES_FDBLKS	0x80	/* reserve newly freed blocks */
> >  /*
> >   * LOWMODE is used by the allocator to activate the lowspace algorithm - when
> >   * free space is running low the extent allocator may choose to allocate an
> > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > index f37f5cc4b19f..afdc7f8e0e70 100644
> > --- a/fs/xfs/xfs_bmap_util.c
> > +++ b/fs/xfs/xfs_bmap_util.c
> > @@ -1567,6 +1567,7 @@ xfs_swap_extents(
> >  	int			lock_flags;
> >  	uint64_t		f;
> >  	int			resblks = 0;
> > +	unsigned int		flags = 0;
> >  
> >  	/*
> >  	 * Lock the inodes against other IO, page faults and truncate to
> > @@ -1630,17 +1631,16 @@ xfs_swap_extents(
> >  		resblks +=  XFS_SWAP_RMAP_SPACE_RES(mp, tipnext, w);
> >  
> >  		/*
> > -		 * Handle the corner case where either inode might straddle the
> > -		 * btree format boundary. If so, the inode could bounce between
> > -		 * btree <-> extent format on unmap -> remap cycles, freeing and
> > -		 * allocating a bmapbt block each time.
> > +		 * If either inode straddles a bmapbt block allocation boundary,
> > +		 * the rmapbt algorithm triggers repeated allocs and frees as
> > +		 * extents are remapped. This can exhaust the block reservation
> > +		 * prematurely and cause shutdown. Return freed blocks to the
> > +		 * transaction reservation to counter this behavior.
> >  		 */
> > -		if (ipnext == (XFS_IFORK_MAXEXT(ip, w) + 1))
> > -			resblks += XFS_IFORK_MAXEXT(ip, w);
> > -		if (tipnext == (XFS_IFORK_MAXEXT(tip, w) + 1))
> > -			resblks += XFS_IFORK_MAXEXT(tip, w);
> > +		flags |= XFS_TRANS_RES_FDBLKS;
> >  	}
> > -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
> > +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, flags,
> > +				&tp);
> >  	if (error)
> >  		goto out_unlock;
> >  
> > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > index 3c94e5ff4316..2040f2df58b5 100644
> > --- a/fs/xfs/xfs_trans.c
> > +++ b/fs/xfs/xfs_trans.c
> > @@ -107,7 +107,8 @@ xfs_trans_dup(
> >  
> >  	ntp->t_flags = XFS_TRANS_PERM_LOG_RES |
> >  		       (tp->t_flags & XFS_TRANS_RESERVE) |
> > -		       (tp->t_flags & XFS_TRANS_NO_WRITECOUNT);
> > +		       (tp->t_flags & XFS_TRANS_NO_WRITECOUNT) |
> > +		       (tp->t_flags & XFS_TRANS_RES_FDBLKS);
> 
> At some point I wonder if we'd be better off with a #define mask that
> covers all the flags that we preserve on transaction roll.
> 
> >  	/* We gave our writer reference to the new transaction */
> >  	tp->t_flags |= XFS_TRANS_NO_WRITECOUNT;
> >  	ntp->t_ticket = xfs_log_ticket_get(tp->t_ticket);
> > @@ -365,6 +366,16 @@ xfs_trans_mod_sb(
> >  			tp->t_blk_res_used += (uint)-delta;
> >  			if (tp->t_blk_res_used > tp->t_blk_res)
> >  				xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > +		} else if (delta > 0 && (tp->t_flags & XFS_TRANS_RES_FDBLKS)) {
> > +			/*
> > +			 * Return freed blocks directly to the reservation
> > +			 * instead of the global pool. This is used by chains of
> > +			 * transaction rolls that repeatedly free and allocate
> > +			 * blocks. Only safe with lazy sb accounting.
> > +			 */
> > +			ASSERT(xfs_sb_version_haslazysbcount(&mp->m_sb));
> 
> Shouldn't we check this at xfs_trans_alloc time so that it's immediately
> obvious when someone screws up?
> 

I dumped it here just because the assert was more simple, but sure, we
could move it to xfs_trans_alloc() and assert that lazy sb accounting is
enabled if the flag is passed.

> > +			tp->t_blk_res += delta;
> 
> What happens if t_blk_res + delta would overflow t_blk_res?  Can you
> make some (probably contrived) scenario where this is possible?
> 

Hmm.. perhaps if this were set on a transaction that truncated a large
file? It's not clear to me if it could happen on swapext, but we could
try to be defensive regardless and cap it to some max value. I have
another variant of this around that tracks the original reservation
count in a new ->t_blk_res_base field. Alternatively we could just cap
the addition to something like (UINT_MAX - tp->t_blk_res), since this
isolated use case probably isn't worth extending xfs_trans for. Hm?

> I'm also a little surprised that you don't subtract delta from
> t_blk_res_used (at least until t_blk_res_used == 0).  Doing it this way
> means that we'll ratchet up t_blk_res_used and t_blk_res every time we
> ping pong, which feels a little strange.  But maybe you can elaborate?
> 

My impression was that the common case is that one transaction consumes
a block, the next frees a block, and the cycle repeats. Therefore,
->t_blk_res ends up similarly toggling back and forth over however many
transactions rather than ratcheting up forever because xfs_trans_dup()
shrinks ->t_blk_res and ->t_blk_res_used starts at zero on each new
transaction.

I think there's a number of different ways to achieve the same net
accounting effect. I briefly considered adding a ->t_blk_res_freed
counter, but it wasn't clear that buys us anything. We could subtract
from ->t_blk_res_used first, but we still have to fall back if that's
zero so that just adds more code. It's also a logic wart since it
assumes the order of frees and allocs within the same transaction and
IMO slightly obfuscates the meaning of the flag by indirectly reducing
block usage vs. directly adding free blocks to the reservation, but I
suppose that bit is subjective. Since the purpose is really to affect a
chain of transactions vs any particular one, it just seemed that the
simplest and most predictable approach was to add freed blocks directly
to the reservation.

Brian

> --D
> 
> > +			delta = 0;
> >  		}
> >  		tp->t_fdblocks_delta += delta;
> >  		if (xfs_sb_version_haslazysbcount(&mp->m_sb))
> > -- 
> > 2.21.1
> > 
> 

