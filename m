Return-Path: <SRS0=3PXQ=AL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D66B7C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 17:54:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE58320774
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 17:54:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xfiBpMsY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731187AbgF3Ryl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 13:54:41 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49348 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgF3Ryk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 13:54:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UHqLbl081315;
        Tue, 30 Jun 2020 17:54:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Rn/r2rmuFgWPalj2s1L6XBXFMqEvqTz6JE9Ylc88RcE=;
 b=xfiBpMsYKATUNQ6tS2Fkd9VfKW5bdEvFNrDMyS48Hobu5LSD0VHGx11h0MUqq7mzv7TZ
 g4IlKHRYDLnWwrhqyX/ZsiILfwjt4dO3iyI6xB6HHE9Y83T6PhaOrfxQ8CkTAybwlMmh
 PaIUawoaJspf4QZyHjaDnnXNpoxJGKsnjPw2jpud6iUGXViimYQCCUph18MhM1zUIGCh
 R2LmdPjVxhNLq5wCHVsAYJy2Toy9mOb/JlMQTfLynC7FxqH5Y/iycoKlDBAv2je2jpCA
 u/4VtrHKcmSK57xNr6Saw1n7389C6ioGt+ly5jC6+3ZAvRJ02EG1KC15FRtvSYY80g61 5g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31xx1dtws2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 30 Jun 2020 17:54:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UHqiM5038615;
        Tue, 30 Jun 2020 17:54:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 31xg140twx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jun 2020 17:54:34 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05UHsXom001382;
        Tue, 30 Jun 2020 17:54:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 17:54:33 +0000
Date:   Tue, 30 Jun 2020 10:54:32 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/15] xfs: move the di_flags2 field to struct xfs_inode
Message-ID: <20200630175432.GI7606@magnolia>
References: <20200620071102.462554-1-hch@lst.de>
 <20200620071102.462554-13-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200620071102.462554-13-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=5 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006300123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=5 mlxlogscore=999 cotscore=-2147483648 lowpriorityscore=0
 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006300123
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 20, 2020 at 09:10:59AM +0200, Christoph Hellwig wrote:
> In preparation of removing the historic icinode struct, move the flags2

"icdinode" (hmm I guess I hadn't noticed that until now...)

> field into the containing xfs_inode structure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

With that fixed up (in this patch and the others),
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_buf.c |  4 ++--
>  fs/xfs/libxfs/xfs_inode_buf.h |  2 --
>  fs/xfs/xfs_bmap_util.c        | 24 ++++++++++++------------
>  fs/xfs/xfs_file.c             |  4 ++--
>  fs/xfs/xfs_inode.c            | 22 ++++++++++------------
>  fs/xfs/xfs_inode.h            |  3 ++-
>  fs/xfs/xfs_inode_item.c       |  2 +-
>  fs/xfs/xfs_ioctl.c            | 23 +++++++++++------------
>  fs/xfs/xfs_iops.c             |  2 +-
>  fs/xfs/xfs_itable.c           |  2 +-
>  fs/xfs/xfs_reflink.c          |  8 ++++----
>  11 files changed, 46 insertions(+), 50 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index bb9c4775ecaa5c..79e470933abfa8 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -255,7 +255,7 @@ xfs_inode_from_disk(
>  					   be64_to_cpu(from->di_changecount));
>  		to->di_crtime.tv_sec = be32_to_cpu(from->di_crtime.t_sec);
>  		to->di_crtime.tv_nsec = be32_to_cpu(from->di_crtime.t_nsec);
> -		to->di_flags2 = be64_to_cpu(from->di_flags2);
> +		ip->i_diflags2 = be64_to_cpu(from->di_flags2);
>  		ip->i_cowextsize = be32_to_cpu(from->di_cowextsize);
>  	}
>  
> @@ -321,7 +321,7 @@ xfs_inode_to_disk(
>  		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
>  		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.tv_sec);
>  		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.tv_nsec);
> -		to->di_flags2 = cpu_to_be64(from->di_flags2);
> +		to->di_flags2 = cpu_to_be64(ip->i_diflags2);
>  		to->di_cowextsize = cpu_to_be32(ip->i_cowextsize);
>  		to->di_ino = cpu_to_be64(ip->i_ino);
>  		to->di_lsn = cpu_to_be64(lsn);
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index 5c6a6ac521b11d..4bfad6d6d5710a 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -19,8 +19,6 @@ struct xfs_icdinode {
>  	uint32_t	di_dmevmask;	/* DMIG event mask */
>  	uint16_t	di_dmstate;	/* DMIG state info */
>  
> -	uint64_t	di_flags2;	/* more random flags */
> -
>  	struct timespec64 di_crtime;	/* time created */
>  };
>  
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 0b944aad75e618..8f85a4131983a6 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1332,9 +1332,9 @@ xfs_swap_extent_rmap(
>  	 * rmap functions when we go to fix up the rmaps.  The flags
>  	 * will be switch for reals later.
>  	 */
> -	tip_flags2 = tip->i_d.di_flags2;
> -	if (ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK)
> -		tip->i_d.di_flags2 |= XFS_DIFLAG2_REFLINK;
> +	tip_flags2 = tip->i_diflags2;
> +	if (ip->i_diflags2 & XFS_DIFLAG2_REFLINK)
> +		tip->i_diflags2 |= XFS_DIFLAG2_REFLINK;
>  
>  	offset_fsb = 0;
>  	end_fsb = XFS_B_TO_FSB(ip->i_mount, i_size_read(VFS_I(ip)));
> @@ -1405,12 +1405,12 @@ xfs_swap_extent_rmap(
>  		offset_fsb += ilen;
>  	}
>  
> -	tip->i_d.di_flags2 = tip_flags2;
> +	tip->i_diflags2 = tip_flags2;
>  	return 0;
>  
>  out:
>  	trace_xfs_swap_extent_rmap_error(ip, error, _RET_IP_);
> -	tip->i_d.di_flags2 = tip_flags2;
> +	tip->i_diflags2 = tip_flags2;
>  	return error;
>  }
>  
> @@ -1708,13 +1708,13 @@ xfs_swap_extents(
>  		goto out_trans_cancel;
>  
>  	/* Do we have to swap reflink flags? */
> -	if ((ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK) ^
> -	    (tip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK)) {
> -		f = ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK;
> -		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
> -		ip->i_d.di_flags2 |= tip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK;
> -		tip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
> -		tip->i_d.di_flags2 |= f & XFS_DIFLAG2_REFLINK;
> +	if ((ip->i_diflags2 & XFS_DIFLAG2_REFLINK) ^
> +	    (tip->i_diflags2 & XFS_DIFLAG2_REFLINK)) {
> +		f = ip->i_diflags2 & XFS_DIFLAG2_REFLINK;
> +		ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
> +		ip->i_diflags2 |= tip->i_diflags2 & XFS_DIFLAG2_REFLINK;
> +		tip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
> +		tip->i_diflags2 |= f & XFS_DIFLAG2_REFLINK;
>  	}
>  
>  	/* Swap the cow forks. */
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 4f08793f3d6db4..193352df48f6bd 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1052,9 +1052,9 @@ xfs_file_remap_range(
>  	 */
>  	cowextsize = 0;
>  	if (pos_in == 0 && len == i_size_read(inode_in) &&
> -	    (src->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) &&
> +	    (src->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) &&
>  	    pos_out == 0 && len >= i_size_read(inode_out) &&
> -	    !(dest->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
> +	    !(dest->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE))
>  		cowextsize = src->i_cowextsize;
>  
>  	ret = xfs_reflink_update_dest(dest, pos_out + len, cowextsize,
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 479342ac8851f4..593e8c5c2fd658 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -81,7 +81,7 @@ xfs_get_cowextsz_hint(
>  	xfs_extlen_t		a, b;
>  
>  	a = 0;
> -	if (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
> +	if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
>  		a = ip->i_cowextsize;
>  	b = xfs_get_extsz_hint(ip);
>  
> @@ -671,9 +671,7 @@ uint
>  xfs_ip2xflags(
>  	struct xfs_inode	*ip)
>  {
> -	struct xfs_icdinode	*dic = &ip->i_d;
> -
> -	return _xfs_dic2xflags(ip->i_diflags, dic->di_flags2, XFS_IFORK_Q(ip));
> +	return _xfs_dic2xflags(ip->i_diflags, ip->i_diflags2, XFS_IFORK_Q(ip));
>  }
>  
>  /*
> @@ -841,7 +839,7 @@ xfs_ialloc(
>  
>  	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
>  		inode_set_iversion(inode, 1);
> -		ip->i_d.di_flags2 = 0;
> +		ip->i_diflags2 = 0;
>  		ip->i_cowextsize = 0;
>  		ip->i_d.di_crtime = tv;
>  	}
> @@ -898,13 +896,13 @@ xfs_ialloc(
>  
>  			ip->i_diflags |= di_flags;
>  		}
> -		if (pip && (pip->i_d.di_flags2 & XFS_DIFLAG2_ANY)) {
> -			if (pip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) {
> -				ip->i_d.di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
> +		if (pip && (pip->i_diflags2 & XFS_DIFLAG2_ANY)) {
> +			if (pip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) {
> +				ip->i_diflags2 |= XFS_DIFLAG2_COWEXTSIZE;
>  				ip->i_cowextsize = pip->i_cowextsize;
>  			}
> -			if (pip->i_d.di_flags2 & XFS_DIFLAG2_DAX)
> -				ip->i_d.di_flags2 |= XFS_DIFLAG2_DAX;
> +			if (pip->i_diflags2 & XFS_DIFLAG2_DAX)
> +				ip->i_diflags2 |= XFS_DIFLAG2_DAX;
>  		}
>  		/* FALLTHROUGH */
>  	case S_IFLNK:
> @@ -1456,7 +1454,7 @@ xfs_itruncate_clear_reflink_flags(
>  	dfork = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
>  	cfork = XFS_IFORK_PTR(ip, XFS_COW_FORK);
>  	if (dfork->if_bytes == 0 && cfork->if_bytes == 0)
> -		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
> +		ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
>  	if (cfork->if_bytes == 0)
>  		xfs_inode_clear_cowblocks_tag(ip);
>  }
> @@ -2756,7 +2754,7 @@ xfs_ifree(
>  
>  	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
>  	ip->i_diflags = 0;
> -	ip->i_d.di_flags2 = 0;
> +	ip->i_diflags2 = 0;
>  	ip->i_d.di_dmevmask = 0;
>  	ip->i_forkoff = 0;		/* mark the attr fork not in use */
>  	ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 7673c841d89154..709f04fadde65e 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -65,6 +65,7 @@ typedef struct xfs_inode {
>  	};
>  	uint8_t			i_forkoff;	/* attr fork offset >> 3 */
>  	uint16_t		i_diflags;	/* XFS_DIFLAG_... */
> +	uint64_t		i_diflags2;	/* XFS_DIFLAG2_... */
>  
>  	struct xfs_icdinode	i_d;		/* most of ondisk inode */
>  
> @@ -193,7 +194,7 @@ xfs_get_initial_prid(struct xfs_inode *dp)
>  
>  static inline bool xfs_is_reflink_inode(struct xfs_inode *ip)
>  {
> -	return ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK;
> +	return ip->i_diflags2 & XFS_DIFLAG2_REFLINK;
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 6af8e829dd0172..04e671d2957ca2 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -342,7 +342,7 @@ xfs_inode_to_log_dinode(
>  		to->di_changecount = inode_peek_iversion(inode);
>  		to->di_crtime.t_sec = from->di_crtime.tv_sec;
>  		to->di_crtime.t_nsec = from->di_crtime.tv_nsec;
> -		to->di_flags2 = from->di_flags2;
> +		to->di_flags2 = ip->i_diflags2;
>  		to->di_cowextsize = ip->i_cowextsize;
>  		to->di_ino = ip->i_ino;
>  		to->di_lsn = lsn;
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 326991f4d98096..d05b86e7930e84 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1110,7 +1110,7 @@ xfs_fill_fsxattr(
>  	simple_fill_fsxattr(fa, xfs_ip2xflags(ip));
>  	fa->fsx_extsize = XFS_FSB_TO_B(mp, ip->i_extsize);
>  	if (xfs_sb_version_has_v3inode(&mp->m_sb) &&
> -	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
> +	    (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE))
>  		fa->fsx_cowextsize = XFS_FSB_TO_B(mp, ip->i_cowextsize);
>  	fa->fsx_projid = ip->i_projid;
>  	if (ifp && (ifp->if_flags & XFS_IFEXTENTS))
> @@ -1183,15 +1183,14 @@ xfs_flags2diflags2(
>  	struct xfs_inode	*ip,
>  	unsigned int		xflags)
>  {
> -	uint64_t		di_flags2 =
> -		(ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK);
> +	uint64_t		i_flags2 = (ip->i_diflags2 & XFS_DIFLAG2_REFLINK);
>  
>  	if (xflags & FS_XFLAG_DAX)
> -		di_flags2 |= XFS_DIFLAG2_DAX;
> +		i_flags2 |= XFS_DIFLAG2_DAX;
>  	if (xflags & FS_XFLAG_COWEXTSIZE)
> -		di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
> +		i_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
>  
> -	return di_flags2;
> +	return i_flags2;
>  }
>  
>  static int
> @@ -1201,7 +1200,7 @@ xfs_ioctl_setattr_xflags(
>  	struct fsxattr		*fa)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> -	uint64_t		di_flags2;
> +	uint64_t		i_flags2;
>  
>  	/* Can't change realtime flag if any extents are allocated. */
>  	if ((ip->i_df.if_nextents || ip->i_delayed_blks) &&
> @@ -1217,19 +1216,19 @@ xfs_ioctl_setattr_xflags(
>  
>  	/* Clear reflink if we are actually able to set the rt flag. */
>  	if ((fa->fsx_xflags & FS_XFLAG_REALTIME) && xfs_is_reflink_inode(ip))
> -		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
> +		ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
>  
>  	/* Don't allow us to set DAX mode for a reflinked file for now. */
>  	if ((fa->fsx_xflags & FS_XFLAG_DAX) && xfs_is_reflink_inode(ip))
>  		return -EINVAL;
>  
>  	/* diflags2 only valid for v3 inodes. */
> -	di_flags2 = xfs_flags2diflags2(ip, fa->fsx_xflags);
> -	if (di_flags2 && !xfs_sb_version_has_v3inode(&mp->m_sb))
> +	i_flags2 = xfs_flags2diflags2(ip, fa->fsx_xflags);
> +	if (i_flags2 && !xfs_sb_version_has_v3inode(&mp->m_sb))
>  		return -EINVAL;
>  
>  	ip->i_diflags = xfs_flags2diflags(ip, fa->fsx_xflags);
> -	ip->i_d.di_flags2 = di_flags2;
> +	ip->i_diflags2 = i_flags2;
>  
>  	xfs_diflags_to_iflags(ip, false);
>  	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
> @@ -1575,7 +1574,7 @@ xfs_ioctl_setattr(
>  	else
>  		ip->i_extsize = 0;
>  	if (xfs_sb_version_has_v3inode(&mp->m_sb) &&
> -	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
> +	    (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE))
>  		ip->i_cowextsize = fa->fsx_cowextsize >> mp->m_sb.sb_blocklog;
>  	else
>  		ip->i_cowextsize = 0;
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index f37154fc9828fd..3642f9935cae3f 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1265,7 +1265,7 @@ xfs_inode_should_enable_dax(
>  		return false;
>  	if (ip->i_mount->m_flags & XFS_MOUNT_DAX_ALWAYS)
>  		return true;
> -	if (ip->i_d.di_flags2 & XFS_DIFLAG2_DAX)
> +	if (ip->i_diflags2 & XFS_DIFLAG2_DAX)
>  		return true;
>  	return false;
>  }
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 7937af9f2ea779..4d1509437c3576 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -111,7 +111,7 @@ xfs_bulkstat_one_int(
>  	buf->bs_version = XFS_BULKSTAT_VERSION_V5;
>  
>  	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
> -		if (dic->di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
> +		if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
>  			buf->bs_cowextsize_blks = ip->i_cowextsize;
>  	}
>  
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 0e07fa7e43117e..476ba54d84a9a3 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -882,7 +882,7 @@ xfs_reflink_set_inode_flag(
>  	if (!xfs_is_reflink_inode(src)) {
>  		trace_xfs_reflink_set_inode_flag(src);
>  		xfs_trans_ijoin(tp, src, XFS_ILOCK_EXCL);
> -		src->i_d.di_flags2 |= XFS_DIFLAG2_REFLINK;
> +		src->i_diflags2 |= XFS_DIFLAG2_REFLINK;
>  		xfs_trans_log_inode(tp, src, XFS_ILOG_CORE);
>  		xfs_ifork_init_cow(src);
>  	} else
> @@ -894,7 +894,7 @@ xfs_reflink_set_inode_flag(
>  	if (!xfs_is_reflink_inode(dest)) {
>  		trace_xfs_reflink_set_inode_flag(dest);
>  		xfs_trans_ijoin(tp, dest, XFS_ILOCK_EXCL);
> -		dest->i_d.di_flags2 |= XFS_DIFLAG2_REFLINK;
> +		dest->i_diflags2 |= XFS_DIFLAG2_REFLINK;
>  		xfs_trans_log_inode(tp, dest, XFS_ILOG_CORE);
>  		xfs_ifork_init_cow(dest);
>  	} else
> @@ -943,7 +943,7 @@ xfs_reflink_update_dest(
>  
>  	if (cowextsize) {
>  		dest->i_cowextsize = cowextsize;
> -		dest->i_d.di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
> +		dest->i_diflags2 |= XFS_DIFLAG2_COWEXTSIZE;
>  	}
>  
>  	xfs_trans_log_inode(tp, dest, XFS_ILOG_CORE);
> @@ -1463,7 +1463,7 @@ xfs_reflink_clear_inode_flag(
>  
>  	/* Clear the inode flag. */
>  	trace_xfs_reflink_unset_inode_flag(ip);
> -	ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
> +	ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
>  	xfs_inode_clear_cowblocks_tag(ip);
>  	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
>  
> -- 
> 2.26.2
> 
