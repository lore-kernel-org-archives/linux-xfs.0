Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71632C433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 18:29:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48BCB207D5
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 18:29:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oA0iMQHv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgFBS3S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 14:29:18 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53778 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgFBS3S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 14:29:18 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052IGg6Z192690;
        Tue, 2 Jun 2020 18:29:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=oKwtE95xHSB4IMXXwRNuFWXme3pT5v2oUK7ljvy0a3s=;
 b=oA0iMQHvHjV4k7SLpeC2PCXLFtxvqnuSci1nAA8uWj8XqsFxYgpt0MTiJET8NTJchyl0
 OZeKbOC2K43l1RCgnXyd+Up/CKURzdJ2G1VfhaSEhp/rFe8AMuc7SaP/J4xIQ+Vz9qIe
 RilYXfRb4IBD8iek3vN1jXfUmkthM+XSiNC+j2zm6C+x0AxoW6rUT1+cjZbDCB7vclaP
 IOzF4Wo/w7QBw2bwectnJUkozuDF72H9KKqUEnzxF8RhCVh+nmdVWwoVucljWffEYujN
 TPRhGx6ILXKjR9XTz5UYl5LXxydBAgucMrAcVVnhPKqzaBFOoIb17iLt/OxEAGtbIK38 aQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31bfem5f5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 18:29:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052IJHd3105452;
        Tue, 2 Jun 2020 18:29:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 31c1dxq379-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 18:29:12 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 052ITBoW001903;
        Tue, 2 Jun 2020 18:29:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jun 2020 11:29:11 -0700
Date:   Tue, 2 Jun 2020 11:29:10 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: preserve rmapbt swapext block reservation from
 freed blocks
Message-ID: <20200602182910.GE8230@magnolia>
References: <20200602180206.9334-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602180206.9334-1-bfoster@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1015
 impostorscore=0 adultscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020133
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 02, 2020 at 02:02:06PM -0400, Brian Foster wrote:
> The rmapbt extent swap algorithm remaps individual extents between
> the source inode and the target to trigger reverse mapping metadata
> updates. If either inode straddles a format or other bmap allocation
> boundary, the individual unmap and map cycles can trigger repeated
> bmap block allocations and frees as the extent count bounces back
> and forth across the boundary. While net block usage is bound across
> the swap operation, this behavior can prematurely exhaust the
> transaction block reservation because it continuously drains as the
> transaction rolls. Each allocation accounts against the reservation
> and each free returns to global free space on transaction roll.
> 
> The previous workaround to this problem attempted to detect this
> boundary condition and provide surplus block reservation to
> acommodate it. This is insufficient because more remaps can occur
> than implied by the extent counts; if start offset boundaries are
> not aligned between the two inodes, for example.
> 
> To address this problem more generically and dynamically, add a
> transaction accounting mode that returns freed blocks to the
> transaction reservation instead of the superblock counters on
> transaction roll and use it when the rmapbt based algorithm is
> active. This allows the chain of remap transactions to preserve the
> block reservation based own its own frees and prevent premature
> exhaustion regardless of the remap pattern. Note that this is only
> safe for superblocks with lazy sb accounting, but the latter is
> required for v5 supers and the rmap feature depends on v5.
> 
> Fixes: b3fed434822d0 ("xfs: account format bouncing into rmapbt swapext tx reservation")
> Root-caused-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> v1:
> - Use a transaction flag to isolate behavior to rmapbt swapext.
> rfc: https://lore.kernel.org/linux-xfs/20200522171828.53440-1-bfoster@redhat.com/
> 
>  fs/xfs/libxfs/xfs_shared.h |  1 +
>  fs/xfs/xfs_bmap_util.c     | 18 +++++++++---------
>  fs/xfs/xfs_trans.c         | 13 ++++++++++++-
>  3 files changed, 22 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> index c45acbd3add9..708feb8eac76 100644
> --- a/fs/xfs/libxfs/xfs_shared.h
> +++ b/fs/xfs/libxfs/xfs_shared.h
> @@ -65,6 +65,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
>  #define XFS_TRANS_DQ_DIRTY	0x10	/* at least one dquot in trx dirty */
>  #define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
>  #define XFS_TRANS_NO_WRITECOUNT 0x40	/* do not elevate SB writecount */
> +#define XFS_TRANS_RES_FDBLKS	0x80	/* reserve newly freed blocks */
>  /*
>   * LOWMODE is used by the allocator to activate the lowspace algorithm - when
>   * free space is running low the extent allocator may choose to allocate an
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index f37f5cc4b19f..afdc7f8e0e70 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1567,6 +1567,7 @@ xfs_swap_extents(
>  	int			lock_flags;
>  	uint64_t		f;
>  	int			resblks = 0;
> +	unsigned int		flags = 0;
>  
>  	/*
>  	 * Lock the inodes against other IO, page faults and truncate to
> @@ -1630,17 +1631,16 @@ xfs_swap_extents(
>  		resblks +=  XFS_SWAP_RMAP_SPACE_RES(mp, tipnext, w);
>  
>  		/*
> -		 * Handle the corner case where either inode might straddle the
> -		 * btree format boundary. If so, the inode could bounce between
> -		 * btree <-> extent format on unmap -> remap cycles, freeing and
> -		 * allocating a bmapbt block each time.
> +		 * If either inode straddles a bmapbt block allocation boundary,
> +		 * the rmapbt algorithm triggers repeated allocs and frees as
> +		 * extents are remapped. This can exhaust the block reservation
> +		 * prematurely and cause shutdown. Return freed blocks to the
> +		 * transaction reservation to counter this behavior.
>  		 */
> -		if (ipnext == (XFS_IFORK_MAXEXT(ip, w) + 1))
> -			resblks += XFS_IFORK_MAXEXT(ip, w);
> -		if (tipnext == (XFS_IFORK_MAXEXT(tip, w) + 1))
> -			resblks += XFS_IFORK_MAXEXT(tip, w);
> +		flags |= XFS_TRANS_RES_FDBLKS;
>  	}
> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
> +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, flags,
> +				&tp);
>  	if (error)
>  		goto out_unlock;
>  
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 3c94e5ff4316..2040f2df58b5 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -107,7 +107,8 @@ xfs_trans_dup(
>  
>  	ntp->t_flags = XFS_TRANS_PERM_LOG_RES |
>  		       (tp->t_flags & XFS_TRANS_RESERVE) |
> -		       (tp->t_flags & XFS_TRANS_NO_WRITECOUNT);
> +		       (tp->t_flags & XFS_TRANS_NO_WRITECOUNT) |
> +		       (tp->t_flags & XFS_TRANS_RES_FDBLKS);

At some point I wonder if we'd be better off with a #define mask that
covers all the flags that we preserve on transaction roll.

>  	/* We gave our writer reference to the new transaction */
>  	tp->t_flags |= XFS_TRANS_NO_WRITECOUNT;
>  	ntp->t_ticket = xfs_log_ticket_get(tp->t_ticket);
> @@ -365,6 +366,16 @@ xfs_trans_mod_sb(
>  			tp->t_blk_res_used += (uint)-delta;
>  			if (tp->t_blk_res_used > tp->t_blk_res)
>  				xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +		} else if (delta > 0 && (tp->t_flags & XFS_TRANS_RES_FDBLKS)) {
> +			/*
> +			 * Return freed blocks directly to the reservation
> +			 * instead of the global pool. This is used by chains of
> +			 * transaction rolls that repeatedly free and allocate
> +			 * blocks. Only safe with lazy sb accounting.
> +			 */
> +			ASSERT(xfs_sb_version_haslazysbcount(&mp->m_sb));

Shouldn't we check this at xfs_trans_alloc time so that it's immediately
obvious when someone screws up?

> +			tp->t_blk_res += delta;

What happens if t_blk_res + delta would overflow t_blk_res?  Can you
make some (probably contrived) scenario where this is possible?

I'm also a little surprised that you don't subtract delta from
t_blk_res_used (at least until t_blk_res_used == 0).  Doing it this way
means that we'll ratchet up t_blk_res_used and t_blk_res every time we
ping pong, which feels a little strange.  But maybe you can elaborate?

--D

> +			delta = 0;
>  		}
>  		tp->t_fdblocks_delta += delta;
>  		if (xfs_sb_version_haslazysbcount(&mp->m_sb))
> -- 
> 2.21.1
> 
