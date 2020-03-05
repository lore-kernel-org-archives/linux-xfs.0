Return-Path: <SRS0=4NJG=4W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5C1FC3F2CE
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 02:08:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FCAD20842
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 02:08:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xC+Xchil"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725807AbgCECII (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 21:08:08 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44502 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbgCECII (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 21:08:08 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0251rsDD034827;
        Thu, 5 Mar 2020 02:08:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Pv0ff1yE1hd9EUjzZuHqwHnIfh5Qg38gC2bPa81uZjk=;
 b=xC+XchilN71p7iItw9vY583C2iHs3C4U9O5GkGhJ5MzODlGxYL/JD78Ka6Y5WB1xg5r1
 VFftZd9q4Qsp5pUc7Swbito73FUr232K66ZEvwH/CgdJte2ZhdaqDntC4fMaSNMFzRhE
 ncn4XThKgQxvfO11Q6WmH6bUR4tnqrOZwfiirDUN9TqjpS81Esly/T29YyoWgrqR/6Tn
 geQuD48A99pA6ZT2A7iSWgX56wmzMtNyYyuwzZ0DhWyh1R2dzTF/9VzKxTAtXIxKE5yO
 Qv2jF7PK2IxC+aCMnE5Bimow0wISYtgayv9oU5VWqHbMuRRS6642W1HSVAlUgJBPKWNw OA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2yffcutama-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Mar 2020 02:08:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0251qhpC156194;
        Thu, 5 Mar 2020 02:08:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2yg1ercxne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Mar 2020 02:08:06 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 025285KX029475;
        Thu, 5 Mar 2020 02:08:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 04 Mar 2020 18:08:05 -0800
Date:   Wed, 4 Mar 2020 18:08:04 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: rename btree cursur private btree member flags
Message-ID: <20200305020804.GO8045@magnolia>
References: <20200305014537.11236-1-david@fromorbit.com>
 <20200305014537.11236-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305014537.11236-5-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9550 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003050008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9550 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 adultscore=0 suspectscore=0 spamscore=0 malwarescore=0 impostorscore=0
 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003050008
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 05, 2020 at 12:45:34PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> BPRV is not longer appropriate because bc_private is going away.
> Script:
> 
> $ sed -i 's/BTCUR_BPRV/BC_BT/g' fs/xfs/*[ch] fs/xfs/*/*[ch]

I kinda hate the name though... BTCUR_BMBT?

(Also 'cursor' is misspelled in the subject line)

--D

> With manual cleanup to the definitions in fs/xfs/libxfs/xfs_btree.h
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c       | 8 ++++----
>  fs/xfs/libxfs/xfs_bmap_btree.c | 4 ++--
>  fs/xfs/libxfs/xfs_btree.c      | 2 +-
>  fs/xfs/libxfs/xfs_btree.h      | 4 ++--
>  4 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 81a8e70c6957..c5d0cbff3780 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -690,7 +690,7 @@ xfs_bmap_extents_to_btree(
>  	 * Need a cursor.  Can't allocate until bb_level is filled in.
>  	 */
>  	cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
> -	cur->bc_bt.flags = wasdel ? XFS_BTCUR_BPRV_WASDEL : 0;
> +	cur->bc_bt.flags = wasdel ? XFS_BC_BT_WASDEL : 0;
>  	/*
>  	 * Convert to a btree with two levels, one record in root.
>  	 */
> @@ -1528,7 +1528,7 @@ xfs_bmap_add_extent_delay_real(
>  
>  	ASSERT(!isnullstartblock(new->br_startblock));
>  	ASSERT(!bma->cur ||
> -	       (bma->cur->bc_bt.flags & XFS_BTCUR_BPRV_WASDEL));
> +	       (bma->cur->bc_bt.flags & XFS_BC_BT_WASDEL));
>  
>  	XFS_STATS_INC(mp, xs_add_exlist);
>  
> @@ -2752,7 +2752,7 @@ xfs_bmap_add_extent_hole_real(
>  	struct xfs_bmbt_irec	old;
>  
>  	ASSERT(!isnullstartblock(new->br_startblock));
> -	ASSERT(!cur || !(cur->bc_bt.flags & XFS_BTCUR_BPRV_WASDEL));
> +	ASSERT(!cur || !(cur->bc_bt.flags & XFS_BC_BT_WASDEL));
>  
>  	XFS_STATS_INC(mp, xs_add_exlist);
>  
> @@ -4188,7 +4188,7 @@ xfs_bmapi_allocate(
>  
>  	if (bma->cur)
>  		bma->cur->bc_bt.flags =
> -			bma->wasdel ? XFS_BTCUR_BPRV_WASDEL : 0;
> +			bma->wasdel ? XFS_BC_BT_WASDEL : 0;
>  
>  	bma->got.br_startoff = bma->offset;
>  	bma->got.br_startblock = bma->blkno;
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index 909cc02256f5..bcf0e19f57d6 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -230,7 +230,7 @@ xfs_bmbt_alloc_block(
>  	}
>  
>  	args.minlen = args.maxlen = args.prod = 1;
> -	args.wasdel = cur->bc_bt.flags & XFS_BTCUR_BPRV_WASDEL;
> +	args.wasdel = cur->bc_bt.flags & XFS_BC_BT_WASDEL;
>  	if (!args.wasdel && args.tp->t_blk_res == 0) {
>  		error = -ENOSPC;
>  		goto error0;
> @@ -644,7 +644,7 @@ xfs_bmbt_change_owner(
>  	cur = xfs_bmbt_init_cursor(ip->i_mount, tp, ip, whichfork);
>  	if (!cur)
>  		return -ENOMEM;
> -	cur->bc_bt.flags |= XFS_BTCUR_BPRV_INVALID_OWNER;
> +	cur->bc_bt.flags |= XFS_BC_BT_INVALID_OWNER;
>  
>  	error = xfs_btree_change_owner(cur, new_owner, buffer_list);
>  	xfs_btree_del_cursor(cur, error);
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 142497032df4..d54b4a3273a4 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -1743,7 +1743,7 @@ xfs_btree_lookup_get_block(
>  
>  	/* Check the inode owner since the verifiers don't. */
>  	if (xfs_sb_version_hascrc(&cur->bc_mp->m_sb) &&
> -	    !(cur->bc_bt.flags & XFS_BTCUR_BPRV_INVALID_OWNER) &&
> +	    !(cur->bc_bt.flags & XFS_BC_BT_INVALID_OWNER) &&
>  	    (cur->bc_flags & XFS_BTREE_LONG_PTRS) &&
>  	    be64_to_cpu((*blkp)->bb_u.l.bb_owner) !=
>  			cur->bc_bt.ip->i_ino)
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index bd5a2bfca64e..93063479264c 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -220,8 +220,8 @@ typedef struct xfs_btree_cur
>  			short		forksize;	/* fork's inode space */
>  			char		whichfork;	/* data or attr fork */
>  			char		flags;		/* flags */
> -#define	XFS_BTCUR_BPRV_WASDEL		(1<<0)		/* was delayed */
> -#define	XFS_BTCUR_BPRV_INVALID_OWNER	(1<<1)		/* for ext swap */
> +#define	XFS_BC_BT_WASDEL	(1 << 0)		/* was delayed */
> +#define	XFS_BC_BT_INVALID_OWNER	(1 << 1)		/* for ext swap */
>  		} b;
>  	}		bc_private;	/* per-btree type data */
>  #define bc_ag	bc_private.a
> -- 
> 2.24.0.rc0
> 
