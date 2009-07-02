Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n625O3B4067890 for <xfs@oss.sgi.com>; Thu, 2 Jul 2009 00:24:03 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5A86A30407B
	for <xfs@oss.sgi.com>; Wed,  1 Jul 2009 22:24:33 -0700 (PDT)
Message-Id: <D9EAEFB5-6B95-43BC-A2CF-A75561A7AAE2@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <4A4C3407.60501@sandeen.net>
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH V3] xfs_repair: fix agcount*agblocks overflows
Date: Thu, 2 Jul 2009 00:24:31 -0500
References: <4A4BC7FF.6050004@sandeen.net> <4A4BE005.3000102@sandeen.net>
	<4A4C3407.60501@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jesse Stroik <jstroik@ssec.wisc.edu>, xfs-oss <xfs@oss.sgi.com>


On Jul 1, 2009, at 11:13 PM, Eric Sandeen wrote:

> (V3: found another spot with this problem)
>
> The last test in verify_ag_bno() may overflow:
>
> return (agbno >= (sbp->sb_dblocks -
> 		((sbp->sb_agcount - 1) * sbp->sb_agblocks)));
>
> because sb_agcount & sb_agblocks are 32-bit integers; this
> may then miss corrupt agbnos for the last ag, which can in
> turn lead to out of bounds memory accesses later, for example
> when the block nr is used to offset in set_agbno_state():
>
> 	addr = ba_bmap[(agno)] + (ag_blockno)/XR_BB_NUM;
>
> Similar problems in mk_incore_fstree
>
> Reported-by: Jesse Stroik <jstroik@ssec.wisc.edu>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Reviewed-by: Felix Blyakher <felixb@sgi.com>

>
> ---
>
> diff --git a/repair/dinode.c b/repair/dinode.c
> index fdf52db..84e1d05 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -319,7 +319,8 @@ verify_ag_bno(xfs_sb_t *sbp,
> 		return (agbno >= sbp->sb_agblocks);
> 	if (agno == (sbp->sb_agcount - 1))
> 		return (agbno >= (sbp->sb_dblocks -
> -				((sbp->sb_agcount - 1) * sbp->sb_agblocks)));
> +				((xfs_drfsbno_t)(sbp->sb_agcount - 1) *
> +				 sbp->sb_agblocks)));
> 	return 1;
> }
>
> diff --git a/repair/phase5.c b/repair/phase5.c
> index 2c243b6..77c7363 100644
> --- a/repair/phase5.c
> +++ b/repair/phase5.c
> @@ -113,7 +113,8 @@ mk_incore_fstree(xfs_mount_t *mp, xfs_agnumber_t  
> agno)
> 		ag_end = mp->m_sb.sb_agblocks;
> 	else
> 		ag_end = mp->m_sb.sb_dblocks -
> -			mp->m_sb.sb_agblocks * (mp->m_sb.sb_agcount - 1);
> +			(xfs_drfsbno_t)mp->m_sb.sb_agblocks *
> +                        (mp->m_sb.sb_agcount - 1);
>
> 	/*
> 	 * ok, now find the number of extents, keep track of the
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
