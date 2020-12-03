Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECABFC433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 19:30:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 840E6221F0
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 19:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgLCTaS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 14:30:18 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:43284 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbgLCTaS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 14:30:18 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3JTVcX087190;
        Thu, 3 Dec 2020 19:29:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=6eHnkUEfIA2BEld0LA7OU0PDK+WNxIiVShMaWPlnUAA=;
 b=gQkvo/JO+TfzOcCL3aVqdHfOayVnxMFQK0/261asEwNR32OS/+HEkkc7QwdTUlE3cB/h
 L3YY2z1P9P5RNkn79TOLyOR+1ExbxeRIaBCZbgFy9UJTb99wl+zcXT3cX+Gxlg+LKqPL
 EKL0GjvHl7/tiUe5sEUZdYu424Kej7Nt6oXg1DL+CP+BD0h81ETpdhl8G5C52iTE0AAi
 bNOWfjjdcvzf/UspmTz+fqypekiU8mMLmxFmNvfqDJCqmbt8k0ql0WSez/A/cLOlb4UP
 RbbG+EnT2vjHYbQWFCwR49okDKcbYwssVEwcKywg27QhJI8ksSEdBS5sXUzZbYK3XaAF kg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 353egkyteg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Dec 2020 19:29:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3JPSEw017051;
        Thu, 3 Dec 2020 19:29:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 3540g2acjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Dec 2020 19:29:30 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B3JTS4s013649;
        Thu, 3 Dec 2020 19:29:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 11:29:27 -0800
Date:   Thu, 3 Dec 2020 11:29:26 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v2 5/6] xfs: spilt xfs_dialloc() into 2 functions
Message-ID: <20201203192926.GH106272@magnolia>
References: <20201203161028.1900929-1-hsiangkao@redhat.com>
 <20201203161028.1900929-6-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203161028.1900929-6-hsiangkao@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=5
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=5
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012030112
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 04, 2020 at 12:10:27AM +0800, Gao Xiang wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This patch explicitly separates free inode chunk allocation and
> inode allocation into two individual high level operations.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

FWIW I thought about doing some similar things with the xfs_dir_ialloc
in the metadata directory tree patchset, so this makes sense to me (and
will probably simplify things) so:

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 59 +++++++++++++++++---------------------
>  fs/xfs/libxfs/xfs_ialloc.h | 20 +++++++++----
>  fs/xfs/xfs_inode.c         | 19 ++++++++----
>  3 files changed, 55 insertions(+), 43 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index d2d7378abf49..597629353d4d 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -1570,7 +1570,7 @@ xfs_dialloc_ag_update_inobt(
>   * The caller selected an AG for us, and made sure that free inodes are
>   * available.
>   */
> -STATIC int
> +int
>  xfs_dialloc_ag(
>  	struct xfs_trans	*tp,
>  	struct xfs_buf		*agbp,
> @@ -1728,21 +1728,22 @@ xfs_dialloc_roll(
>  }
>  
>  /*
> - * Allocate an inode on disk.
> + * Select and prepare an AG for inode allocation.
>   *
> - * Mode is used to tell whether the new inode will need space, and whether it
> - * is a directory.
> + * Mode is used to tell whether the new inode is a directory and hence where to
> + * locate it.
>   *
> - * Once we successfully pick an inode its number is returned and the on-disk
> - * data structures are updated.  The inode itself is not read in, since doing so
> - * would break ordering constraints with xfs_reclaim.
> + * This function will ensure that the selected AG has free inodes available to
> + * allocate from. The selected AGI will be returned locked to the caller, and it
> + * will allocate more free inodes if required. If no free inodes are found or
> + * can be allocated, no AGI will be returned.
>   */
>  int
> -xfs_dialloc(
> +xfs_dialloc_select_ag(
>  	struct xfs_trans	**tpp,
>  	xfs_ino_t		parent,
>  	umode_t			mode,
> -	xfs_ino_t		*inop)
> +	struct xfs_buf		**IO_agbp)
>  {
>  	struct xfs_mount	*mp = (*tpp)->t_mountp;
>  	struct xfs_buf		*agbp;
> @@ -1755,15 +1756,15 @@ xfs_dialloc(
>  	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
>  	bool			okalloc = true;
>  
> +	*IO_agbp = NULL;
> +
>  	/*
>  	 * We do not have an agbp, so select an initial allocation
>  	 * group for inode allocation.
>  	 */
>  	start_agno = xfs_ialloc_ag_select(*tpp, parent, mode);
> -	if (start_agno == NULLAGNUMBER) {
> -		*inop = NULLFSINO;
> +	if (start_agno == NULLAGNUMBER)
>  		return 0;
> -	}
>  
>  	/*
>  	 * If we have already hit the ceiling of inode blocks then clear
> @@ -1796,7 +1797,7 @@ xfs_dialloc(
>  		if (!pag->pagi_init) {
>  			error = xfs_ialloc_pagi_init(mp, *tpp, agno);
>  			if (error)
> -				goto out_error;
> +				break;
>  		}
>  
>  		/*
> @@ -1811,11 +1812,12 @@ xfs_dialloc(
>  		 */
>  		error = xfs_ialloc_read_agi(mp, *tpp, agno, &agbp);
>  		if (error)
> -			goto out_error;
> +			break;
>  
>  		if (pag->pagi_freecount) {
>  			xfs_perag_put(pag);
> -			goto out_alloc;
> +			*IO_agbp = agbp;
> +			return 0;
>  		}
>  
>  		if (!okalloc)
> @@ -1826,19 +1828,17 @@ xfs_dialloc(
>  		if (error) {
>  			xfs_trans_brelse(*tpp, agbp);
>  
> -			if (error != -ENOSPC)
> -				goto out_error;
> -
> -			xfs_perag_put(pag);
> -			*inop = NULLFSINO;
> -			return 0;
> +			if (error == -ENOSPC)
> +				error = 0;
> +			break;
>  		}
>  
>  		if (ialloced) {
>  			/*
> -			 * We successfully allocated some inodes, roll the
> -			 * transaction so they can allocate one of the free
> -			 * inodes we just prepared for them.
> +			 * We successfully allocated some inodes, so roll the
> +			 * transaction and return the locked AGI buffer to the
> +			 * caller so they can allocate one of the free inodes we
> +			 * just prepared for them.
>  			 */
>  			ASSERT(pag->pagi_freecount > 0);
>  			xfs_perag_put(pag);
> @@ -1847,8 +1847,8 @@ xfs_dialloc(
>  			if (error)
>  				return error;
>  
> -			*inop = NULLFSINO;
> -			goto out_alloc;
> +			*IO_agbp = agbp;
> +			return 0;
>  		}
>  
>  nextag_relse_buffer:
> @@ -1857,15 +1857,10 @@ xfs_dialloc(
>  		xfs_perag_put(pag);
>  		if (++agno == mp->m_sb.sb_agcount)
>  			agno = 0;
> -		if (agno == start_agno) {
> -			*inop = NULLFSINO;
> +		if (agno == start_agno)
>  			return noroom ? -ENOSPC : 0;
> -		}
>  	}
>  
> -out_alloc:
> -	return xfs_dialloc_ag(*tpp, agbp, parent, inop);
> -out_error:
>  	xfs_perag_put(pag);
>  	return error;
>  }
> diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
> index 13810ffe4af9..3511086a7ae1 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.h
> +++ b/fs/xfs/libxfs/xfs_ialloc.h
> @@ -37,16 +37,26 @@ xfs_make_iptr(struct xfs_mount *mp, struct xfs_buf *b, int o)
>   * Mode is used to tell whether the new inode will need space, and whether
>   * it is a directory.
>   *
> - * Once we successfully pick an inode its number is returned and the
> - * on-disk data structures are updated.  The inode itself is not read
> - * in, since doing so would break ordering constraints with xfs_reclaim.
> + * There are two phases to inode allocation: selecting an AG and ensuring
> + * that it contains free inodes, followed by allocating one of the free
> + * inodes. xfs_dialloc_select_ag() does the former and returns a locked AGI
> + * to the caller, ensuring that followup call to xfs_dialloc_ag() will
> + * have free inodes to allocate from. xfs_dialloc_ag() will return the inode
> + * number of the free inode we allocated.
>   */
>  int					/* error */
> -xfs_dialloc(
> +xfs_dialloc_select_ag(
>  	struct xfs_trans **tpp,		/* double pointer of transaction */
>  	xfs_ino_t	parent,		/* parent inode (directory) */
>  	umode_t		mode,		/* mode bits for new inode */
> -	xfs_ino_t	*inop);		/* inode number allocated */
> +	struct xfs_buf	**IO_agbp);
> +
> +int
> +xfs_dialloc_ag(
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		*agbp,
> +	xfs_ino_t		parent,
> +	xfs_ino_t		*inop);
>  
>  /*
>   * Free disk inode.  Carefully avoids touching the incore inode, all
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index c039fc56b396..d0ae0d6ee892 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -908,10 +908,11 @@ xfs_dir_ialloc(
>  	xfs_inode_t	**ipp)		/* pointer to inode; it will be
>  					   locked. */
>  {
> -	xfs_inode_t	*ip;
> -	xfs_ino_t	pino = dp ? dp->i_ino : 0;
> -	xfs_ino_t	ino;
> -	int		error;
> +	struct xfs_buf		*agibp;
> +	struct xfs_inode	*ip;
> +	xfs_ino_t		pino = dp ? dp->i_ino : 0;
> +	xfs_ino_t		ino;
> +	int			error;
>  
>  	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
>  	*ipp = NULL;
> @@ -927,13 +928,19 @@ xfs_dir_ialloc(
>  	 * commit so that no other process can steal the inode(s) that we've
>  	 * just allocated.
>  	 */
> -	error = xfs_dialloc(tpp, pino, mode, &ino);
> +	error = xfs_dialloc_select_ag(tpp, pino, mode, &agibp);
>  	if (error)
>  		return error;
>  
> -	if (ino == NULLFSINO)
> +	if (!agibp)
>  		return -ENOSPC;
>  
> +	/* Allocate an inode from the selected AG */
> +	error = xfs_dialloc_ag(*tpp, agibp, pino, &ino);
> +	if (error)
> +		return error;
> +	ASSERT(ino != NULLFSINO);
> +
>  	/* Initialise the newly allocated inode. */
>  	ip = xfs_ialloc(*tpp, dp, ino, mode, nlink, rdev, prid);
>  	if (IS_ERR(ip))
> -- 
> 2.18.4
> 
