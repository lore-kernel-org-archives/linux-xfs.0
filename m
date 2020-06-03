Return-Path: <SRS0=rMVI=7Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80080C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 16:38:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E2752068D
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 16:38:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qO+vUPAT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgFCQiP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Jun 2020 12:38:15 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36952 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgFCQiP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jun 2020 12:38:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 053Gc6Zs048888;
        Wed, 3 Jun 2020 16:38:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=OvMYXA+LmkCbfv8ndYAZYrsYHSH4+uenpDj9KUezgXc=;
 b=qO+vUPATcxEUt6YJwNUq7qMfSYkpa7VZrNERXnXiFaRu0O1VWt7fffEVGiNTUL57a2Ac
 Bk+2GYRNIyH0qx0SxKYlEdQvdpB8o0Eq1CHfa9AXhkZZNkNgY45NPT4TYk0G+rFE3Rhx
 IWebYWTetw+HeYdDnv9Hv/qVwJl1AO8hUQBUh6nl3bI7Bn44pdK9joewtfExbuyD0IZX
 fKZq5wqeasa8zg1VAGDl78Sg32XY10BzpFYBDQLfes5dbsqNbY/XGsf8LRpgz+IVVgHj
 JxbxILwoRaYVGBnuFhG8ENNjwfEeO2gx+j7el9e9ZBx0L1uNct6jtQxmA4hfvrxTgsO/ Gg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31ef1ng5p3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 03 Jun 2020 16:38:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 053GXVkq015232;
        Wed, 3 Jun 2020 16:38:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 31c12r5373-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Jun 2020 16:38:10 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 053GcADE012888;
        Wed, 3 Jun 2020 16:38:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 03 Jun 2020 09:38:09 -0700
Date:   Wed, 3 Jun 2020 09:38:08 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: preserve rmapbt swapext block reservation from
 freed blocks
Message-ID: <20200603163808.GB8230@magnolia>
References: <20200602180206.9334-1-bfoster@redhat.com>
 <20200602182910.GE8230@magnolia>
 <20200602193306.GI7967@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602193306.GI7967@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9641 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006030130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9641 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 clxscore=1015
 malwarescore=0 priorityscore=1501 impostorscore=0 spamscore=0
 suspectscore=0 bulkscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 mlxscore=0 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006030130
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 02, 2020 at 03:33:06PM -0400, Brian Foster wrote:
> On Tue, Jun 02, 2020 at 11:29:10AM -0700, Darrick J. Wong wrote:
> > On Tue, Jun 02, 2020 at 02:02:06PM -0400, Brian Foster wrote:
> > > The rmapbt extent swap algorithm remaps individual extents between
> > > the source inode and the target to trigger reverse mapping metadata
> > > updates. If either inode straddles a format or other bmap allocation
> > > boundary, the individual unmap and map cycles can trigger repeated
> > > bmap block allocations and frees as the extent count bounces back
> > > and forth across the boundary. While net block usage is bound across
> > > the swap operation, this behavior can prematurely exhaust the
> > > transaction block reservation because it continuously drains as the
> > > transaction rolls. Each allocation accounts against the reservation
> > > and each free returns to global free space on transaction roll.
> > > 
> > > The previous workaround to this problem attempted to detect this
> > > boundary condition and provide surplus block reservation to
> > > acommodate it. This is insufficient because more remaps can occur
> > > than implied by the extent counts; if start offset boundaries are
> > > not aligned between the two inodes, for example.
> > > 
> > > To address this problem more generically and dynamically, add a
> > > transaction accounting mode that returns freed blocks to the
> > > transaction reservation instead of the superblock counters on
> > > transaction roll and use it when the rmapbt based algorithm is
> > > active. This allows the chain of remap transactions to preserve the
> > > block reservation based own its own frees and prevent premature
> > > exhaustion regardless of the remap pattern. Note that this is only
> > > safe for superblocks with lazy sb accounting, but the latter is
> > > required for v5 supers and the rmap feature depends on v5.
> > > 
> > > Fixes: b3fed434822d0 ("xfs: account format bouncing into rmapbt swapext tx reservation")
> > > Root-caused-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > > 
> > > v1:
> > > - Use a transaction flag to isolate behavior to rmapbt swapext.
> > > rfc: https://lore.kernel.org/linux-xfs/20200522171828.53440-1-bfoster@redhat.com/
> > > 
> > >  fs/xfs/libxfs/xfs_shared.h |  1 +
> > >  fs/xfs/xfs_bmap_util.c     | 18 +++++++++---------
> > >  fs/xfs/xfs_trans.c         | 13 ++++++++++++-
> > >  3 files changed, 22 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> > > index c45acbd3add9..708feb8eac76 100644
> > > --- a/fs/xfs/libxfs/xfs_shared.h
> > > +++ b/fs/xfs/libxfs/xfs_shared.h
> > > @@ -65,6 +65,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
> > >  #define XFS_TRANS_DQ_DIRTY	0x10	/* at least one dquot in trx dirty */
> > >  #define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
> > >  #define XFS_TRANS_NO_WRITECOUNT 0x40	/* do not elevate SB writecount */
> > > +#define XFS_TRANS_RES_FDBLKS	0x80	/* reserve newly freed blocks */
> > >  /*
> > >   * LOWMODE is used by the allocator to activate the lowspace algorithm - when
> > >   * free space is running low the extent allocator may choose to allocate an
> > > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > > index f37f5cc4b19f..afdc7f8e0e70 100644
> > > --- a/fs/xfs/xfs_bmap_util.c
> > > +++ b/fs/xfs/xfs_bmap_util.c
> > > @@ -1567,6 +1567,7 @@ xfs_swap_extents(
> > >  	int			lock_flags;
> > >  	uint64_t		f;
> > >  	int			resblks = 0;
> > > +	unsigned int		flags = 0;
> > >  
> > >  	/*
> > >  	 * Lock the inodes against other IO, page faults and truncate to
> > > @@ -1630,17 +1631,16 @@ xfs_swap_extents(
> > >  		resblks +=  XFS_SWAP_RMAP_SPACE_RES(mp, tipnext, w);
> > >  
> > >  		/*
> > > -		 * Handle the corner case where either inode might straddle the
> > > -		 * btree format boundary. If so, the inode could bounce between
> > > -		 * btree <-> extent format on unmap -> remap cycles, freeing and
> > > -		 * allocating a bmapbt block each time.
> > > +		 * If either inode straddles a bmapbt block allocation boundary,
> > > +		 * the rmapbt algorithm triggers repeated allocs and frees as
> > > +		 * extents are remapped. This can exhaust the block reservation
> > > +		 * prematurely and cause shutdown. Return freed blocks to the
> > > +		 * transaction reservation to counter this behavior.
> > >  		 */
> > > -		if (ipnext == (XFS_IFORK_MAXEXT(ip, w) + 1))
> > > -			resblks += XFS_IFORK_MAXEXT(ip, w);
> > > -		if (tipnext == (XFS_IFORK_MAXEXT(tip, w) + 1))
> > > -			resblks += XFS_IFORK_MAXEXT(tip, w);
> > > +		flags |= XFS_TRANS_RES_FDBLKS;
> > >  	}
> > > -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
> > > +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, flags,
> > > +				&tp);
> > >  	if (error)
> > >  		goto out_unlock;
> > >  
> > > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > > index 3c94e5ff4316..2040f2df58b5 100644
> > > --- a/fs/xfs/xfs_trans.c
> > > +++ b/fs/xfs/xfs_trans.c
> > > @@ -107,7 +107,8 @@ xfs_trans_dup(
> > >  
> > >  	ntp->t_flags = XFS_TRANS_PERM_LOG_RES |
> > >  		       (tp->t_flags & XFS_TRANS_RESERVE) |
> > > -		       (tp->t_flags & XFS_TRANS_NO_WRITECOUNT);
> > > +		       (tp->t_flags & XFS_TRANS_NO_WRITECOUNT) |
> > > +		       (tp->t_flags & XFS_TRANS_RES_FDBLKS);
> > 
> > At some point I wonder if we'd be better off with a #define mask that
> > covers all the flags that we preserve on transaction roll.
> > 
> > >  	/* We gave our writer reference to the new transaction */
> > >  	tp->t_flags |= XFS_TRANS_NO_WRITECOUNT;
> > >  	ntp->t_ticket = xfs_log_ticket_get(tp->t_ticket);
> > > @@ -365,6 +366,16 @@ xfs_trans_mod_sb(
> > >  			tp->t_blk_res_used += (uint)-delta;
> > >  			if (tp->t_blk_res_used > tp->t_blk_res)
> > >  				xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > > +		} else if (delta > 0 && (tp->t_flags & XFS_TRANS_RES_FDBLKS)) {
> > > +			/*
> > > +			 * Return freed blocks directly to the reservation
> > > +			 * instead of the global pool. This is used by chains of
> > > +			 * transaction rolls that repeatedly free and allocate
> > > +			 * blocks. Only safe with lazy sb accounting.
> > > +			 */
> > > +			ASSERT(xfs_sb_version_haslazysbcount(&mp->m_sb));
> > 
> > Shouldn't we check this at xfs_trans_alloc time so that it's immediately
> > obvious when someone screws up?
> > 
> 
> I dumped it here just because the assert was more simple, but sure, we
> could move it to xfs_trans_alloc() and assert that lazy sb accounting is
> enabled if the flag is passed.

<nod>

> > > +			tp->t_blk_res += delta;
> > 
> > What happens if t_blk_res + delta would overflow t_blk_res?  Can you
> > make some (probably contrived) scenario where this is possible?
> > 
> 
> Hmm.. perhaps if this were set on a transaction that truncated a large
> file? It's not clear to me if it could happen on swapext, but we could
> try to be defensive regardless and cap it to some max value. I have
> another variant of this around that tracks the original reservation
> count in a new ->t_blk_res_base field. Alternatively we could just cap
> the addition to something like (UINT_MAX - tp->t_blk_res), since this
> isolated use case probably isn't worth extending xfs_trans for. Hm?

I think it's best not to leave a lurking logic bomb, particularly
because you'd roll over to a weirdly tiny t_blk_res value that could be
smaller than t_blk_res_used.  I think this'll do:

	int blkres_delta = max(UINT_MAX - tp->t_blk_res, delta);

	tp->t_blk_res += blkres_delta;
	delta -= blkres_delta;

	<and then later>

	tp->t_fdblocks_delta += delta;

(Pretend I worked out any potential integer handling bugs in that...)

> > I'm also a little surprised that you don't subtract delta from
> > t_blk_res_used (at least until t_blk_res_used == 0).  Doing it this way
> > means that we'll ratchet up t_blk_res_used and t_blk_res every time we
> > ping pong, which feels a little strange.  But maybe you can elaborate?
> > 
> 
> My impression was that the common case is that one transaction consumes
> a block, the next frees a block, and the cycle repeats. Therefore,
> ->t_blk_res ends up similarly toggling back and forth over however many
> transactions rather than ratcheting up forever because xfs_trans_dup()
> shrinks ->t_blk_res and ->t_blk_res_used starts at zero on each new
> transaction.

Oh, right.  I forgot that it does that.  Ok, never mind then. :)

> I think there's a number of different ways to achieve the same net
> accounting effect. I briefly considered adding a ->t_blk_res_freed
> counter, but it wasn't clear that buys us anything. We could subtract
> from ->t_blk_res_used first, but we still have to fall back if that's
> zero so that just adds more code. It's also a logic wart since it
> assumes the order of frees and allocs within the same transaction and
> IMO slightly obfuscates the meaning of the flag by indirectly reducing
> block usage vs. directly adding free blocks to the reservation, but I
> suppose that bit is subjective. Since the purpose is really to affect a
> chain of transactions vs any particular one, it just seemed that the
> simplest and most predictable approach was to add freed blocks directly
> to the reservation.

<nod> Ok, I'm convinced.

--D

> Brian
> 
> > --D
> > 
> > > +			delta = 0;
> > >  		}
> > >  		tp->t_fdblocks_delta += delta;
> > >  		if (xfs_sb_version_haslazysbcount(&mp->m_sb))
> > > -- 
> > > 2.21.1
> > > 
> > 
> 
