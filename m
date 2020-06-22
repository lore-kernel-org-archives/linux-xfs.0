Return-Path: <SRS0=RL8k=AD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59D4FC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 17:22:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31E502073E
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 17:22:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c9yEEtPY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729857AbgFVRWf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Jun 2020 13:22:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60182 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729777AbgFVRWf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jun 2020 13:22:35 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05MHCKf2001960;
        Mon, 22 Jun 2020 17:22:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=uYERjNyhLxyx6XqSLogtAvyDnjG5po036PUnIwedzg4=;
 b=c9yEEtPYnaCuLaMpd5BjK54Ha0YR1k78RJlUR/XwWHDLmqlm4jteHA8ZQLBF1qWG+6Y1
 AhNVDa7sfElDwS+vghQEQMn9BcelET+AjggA/OcMUPlZbvvgOfr7OV1fH06apKrB2DeQ
 fwAeWouzQO8u1Bf3m2W3WVH3cRYKaWQjmCu90U4JxvSmJvqufUVZmHcvQSkWET8oz3D8
 i0Baq36bg9CHF/dSdiV7Qop2lgsUFow3ZGZtOqzxDBV73mjacKf9sV9K7Ufsam31iWyV
 LQ+53+WLFPHIB37Z3Om2E4pA9DQj+eJeO6NBe/nuvE3Ela4HCkOKTgDYTQ2WHINZhrNz UA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 31sebbgnwx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 22 Jun 2020 17:22:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05MHDqSP019169;
        Mon, 22 Jun 2020 17:22:31 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 31svc1pqjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Jun 2020 17:22:31 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05MHMTD1010062;
        Mon, 22 Jun 2020 17:22:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 22 Jun 2020 17:22:29 +0000
Date:   Mon, 22 Jun 2020 10:22:28 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: preserve rmapbt swapext block reservation from
 freed blocks
Message-ID: <20200622172228.GH11245@magnolia>
References: <20200605144924.24165-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605144924.24165-1-bfoster@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 spamscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006220120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 cotscore=-2147483648 mlxscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 suspectscore=0 clxscore=1015
 impostorscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006220120
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 05, 2020 at 10:49:24AM -0400, Brian Foster wrote:
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

Hm.  Ok, so now we (conditionally) feed freed block counts into the
transaction block reservation unless it hits UINT_MAX.  A transaction
roll will prevent t_blk_res from climbing infinitely high, and the
effective result is that we can pingpong without blowing out the block
reservation limits.

I'll try this one out for 5.9, thanks for putting this together.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> v2:
> - Move flag assert check to transaction allocation.
> - Prevent potential overflow of ->t_blk_res.
> v1: https://lore.kernel.org/linux-xfs/20200602180206.9334-1-bfoster@redhat.com/
> - Use a transaction flag to isolate behavior to rmapbt swapext.
> rfc: https://lore.kernel.org/linux-xfs/20200522171828.53440-1-bfoster@redhat.com/
> 
>  fs/xfs/libxfs/xfs_shared.h |  1 +
>  fs/xfs/xfs_bmap_util.c     | 18 +++++++++---------
>  fs/xfs/xfs_trans.c         | 19 ++++++++++++++++++-
>  3 files changed, 28 insertions(+), 10 deletions(-)
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
> index 3c94e5ff4316..0ad72a83edac 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -107,7 +107,8 @@ xfs_trans_dup(
>  
>  	ntp->t_flags = XFS_TRANS_PERM_LOG_RES |
>  		       (tp->t_flags & XFS_TRANS_RESERVE) |
> -		       (tp->t_flags & XFS_TRANS_NO_WRITECOUNT);
> +		       (tp->t_flags & XFS_TRANS_NO_WRITECOUNT) |
> +		       (tp->t_flags & XFS_TRANS_RES_FDBLKS);
>  	/* We gave our writer reference to the new transaction */
>  	tp->t_flags |= XFS_TRANS_NO_WRITECOUNT;
>  	ntp->t_ticket = xfs_log_ticket_get(tp->t_ticket);
> @@ -272,6 +273,8 @@ xfs_trans_alloc(
>  	 */
>  	WARN_ON(resp->tr_logres > 0 &&
>  		mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
> +	ASSERT(!(flags & XFS_TRANS_RES_FDBLKS) ||
> +	       xfs_sb_version_haslazysbcount(&mp->m_sb));
>  
>  	tp->t_magic = XFS_TRANS_HEADER_MAGIC;
>  	tp->t_flags = flags;
> @@ -365,6 +368,20 @@ xfs_trans_mod_sb(
>  			tp->t_blk_res_used += (uint)-delta;
>  			if (tp->t_blk_res_used > tp->t_blk_res)
>  				xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +		} else if (delta > 0 && (tp->t_flags & XFS_TRANS_RES_FDBLKS)) {
> +			int64_t	blkres_delta;
> +
> +			/*
> +			 * Return freed blocks directly to the reservation
> +			 * instead of the global pool, being careful not to
> +			 * overflow the trans counter. This is used to preserve
> +			 * reservation across chains of transaction rolls that
> +			 * repeatedly free and allocate blocks.
> +			 */
> +			blkres_delta = min_t(int64_t, delta,
> +					     UINT_MAX - tp->t_blk_res);
> +			tp->t_blk_res += blkres_delta;
> +			delta -= blkres_delta;
>  		}
>  		tp->t_fdblocks_delta += delta;
>  		if (xfs_sb_version_haslazysbcount(&mp->m_sb))
> -- 
> 2.21.1
> 
