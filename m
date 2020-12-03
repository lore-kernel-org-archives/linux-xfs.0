Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F005C197BF
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 19:26:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EEAE221F5
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 19:26:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727761AbgLCT0k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 14:26:40 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:55724 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731741AbgLCT0j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 14:26:39 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3JJjOn030131;
        Thu, 3 Dec 2020 19:25:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=KG77wZ2z6AZBxSHthwRMyS7AxUnNpsEXCWOQ5pQIvKE=;
 b=czMZISLDEujAyhtpEY5YodKI6sZl2CKIYs2+SjAxkfs95wLJ+OEbsM88rKrcyAqjADzc
 s7OsPmsWkc/vWOG7x6AgYKYZtqSRBCqWfVg3swheLufwx/HIv+DlVZt1Rm+I+CQVVGob
 kUXnmjR1LKuWDMgVmhlbIYaTQncW4hTnw/Biz4lVjlz4Igxq2M+6BcY8RFos55yDirVq
 FxwmHROkaMrT++aR8jbF9x2H73IykkVmcTw6bBAA8mWovLoN7dhRWV8nx+2+kD6vYG9J
 6GDvtfTzeie26m/Abcc4rg7+OYAGJigPEK/H0XQdy4iD2PrFzkpZXSNqhfNu3TJI50fp WA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 353dyqyvqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Dec 2020 19:25:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3JKVVh128764;
        Thu, 3 Dec 2020 19:25:49 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 35404r9w2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Dec 2020 19:25:49 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B3JPlHA030176;
        Thu, 3 Dec 2020 19:25:47 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 11:25:46 -0800
Date:   Thu, 3 Dec 2020 11:25:46 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v2 4/6] xfs: move xfs_dialloc_roll() into xfs_dialloc()
Message-ID: <20201203192546.GG106272@magnolia>
References: <20201203161028.1900929-1-hsiangkao@redhat.com>
 <20201203161028.1900929-5-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203161028.1900929-5-hsiangkao@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030111
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=5 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030111
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 04, 2020 at 12:10:26AM +0800, Gao Xiang wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Get rid of the confusing ialloc_context and failure handling around
> xfs_dialloc() by moving xfs_dialloc_roll() into xfs_dialloc().
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

Heh.  I sent my comments about to patch 4 as a reply to patch 3. :(

Well, at least the critical part is the same between both:

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 57 ++++++++++++--------------------------
>  fs/xfs/libxfs/xfs_ialloc.h | 22 +--------------
>  fs/xfs/xfs_inode.c         | 24 +---------------
>  3 files changed, 20 insertions(+), 83 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index d5dc3167e2ff..d2d7378abf49 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -1682,7 +1682,7 @@ xfs_dialloc_ag(
>  	return error;
>  }
>  
> -int
> +static int
>  xfs_dialloc_roll(
>  	struct xfs_trans	**tpp,
>  	struct xfs_buf		*agibp)
> @@ -1733,30 +1733,18 @@ xfs_dialloc_roll(
>   * Mode is used to tell whether the new inode will need space, and whether it
>   * is a directory.
>   *
> - * This function is designed to be called twice if it has to do an allocation
> - * to make more free inodes.  On the first call, *IO_agbp should be set to NULL.
> - * If an inode is available without having to performn an allocation, an inode
> - * number is returned.  In this case, *IO_agbp is set to NULL.  If an allocation
> - * needs to be done, xfs_dialloc returns the current AGI buffer in *IO_agbp.
> - * The caller should then commit the current transaction, allocate a
> - * new transaction, and call xfs_dialloc() again, passing in the previous value
> - * of *IO_agbp.  IO_agbp should be held across the transactions. Since the AGI
> - * buffer is locked across the two calls, the second call is guaranteed to have
> - * a free inode available.
> - *
>   * Once we successfully pick an inode its number is returned and the on-disk
>   * data structures are updated.  The inode itself is not read in, since doing so
>   * would break ordering constraints with xfs_reclaim.
>   */
>  int
>  xfs_dialloc(
> -	struct xfs_trans	*tp,
> +	struct xfs_trans	**tpp,
>  	xfs_ino_t		parent,
>  	umode_t			mode,
> -	struct xfs_buf		**IO_agbp,
>  	xfs_ino_t		*inop)
>  {
> -	struct xfs_mount	*mp = tp->t_mountp;
> +	struct xfs_mount	*mp = (*tpp)->t_mountp;
>  	struct xfs_buf		*agbp;
>  	xfs_agnumber_t		agno;
>  	int			error;
> @@ -1767,21 +1755,11 @@ xfs_dialloc(
>  	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
>  	bool			okalloc = true;
>  
> -	if (*IO_agbp) {
> -		/*
> -		 * If the caller passes in a pointer to the AGI buffer,
> -		 * continue where we left off before.  In this case, we
> -		 * know that the allocation group has free inodes.
> -		 */
> -		agbp = *IO_agbp;
> -		goto out_alloc;
> -	}
> -
>  	/*
>  	 * We do not have an agbp, so select an initial allocation
>  	 * group for inode allocation.
>  	 */
> -	start_agno = xfs_ialloc_ag_select(tp, parent, mode);
> +	start_agno = xfs_ialloc_ag_select(*tpp, parent, mode);
>  	if (start_agno == NULLAGNUMBER) {
>  		*inop = NULLFSINO;
>  		return 0;
> @@ -1816,7 +1794,7 @@ xfs_dialloc(
>  		}
>  
>  		if (!pag->pagi_init) {
> -			error = xfs_ialloc_pagi_init(mp, tp, agno);
> +			error = xfs_ialloc_pagi_init(mp, *tpp, agno);
>  			if (error)
>  				goto out_error;
>  		}
> @@ -1831,7 +1809,7 @@ xfs_dialloc(
>  		 * Then read in the AGI buffer and recheck with the AGI buffer
>  		 * lock held.
>  		 */
> -		error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
> +		error = xfs_ialloc_read_agi(mp, *tpp, agno, &agbp);
>  		if (error)
>  			goto out_error;
>  
> @@ -1844,9 +1822,9 @@ xfs_dialloc(
>  			goto nextag_relse_buffer;
>  
>  
> -		error = xfs_ialloc_ag_alloc(tp, agbp, &ialloced);
> +		error = xfs_ialloc_ag_alloc(*tpp, agbp, &ialloced);
>  		if (error) {
> -			xfs_trans_brelse(tp, agbp);
> +			xfs_trans_brelse(*tpp, agbp);
>  
>  			if (error != -ENOSPC)
>  				goto out_error;
> @@ -1858,21 +1836,23 @@ xfs_dialloc(
>  
>  		if (ialloced) {
>  			/*
> -			 * We successfully allocated some inodes, return
> -			 * the current context to the caller so that it
> -			 * can commit the current transaction and call
> -			 * us again where we left off.
> +			 * We successfully allocated some inodes, roll the
> +			 * transaction so they can allocate one of the free
> +			 * inodes we just prepared for them.
>  			 */
>  			ASSERT(pag->pagi_freecount > 0);
>  			xfs_perag_put(pag);
>  
> -			*IO_agbp = agbp;
> +			error = xfs_dialloc_roll(tpp, agbp);
> +			if (error)
> +				return error;
> +
>  			*inop = NULLFSINO;
> -			return 0;
> +			goto out_alloc;
>  		}
>  
>  nextag_relse_buffer:
> -		xfs_trans_brelse(tp, agbp);
> +		xfs_trans_brelse(*tpp, agbp);
>  nextag:
>  		xfs_perag_put(pag);
>  		if (++agno == mp->m_sb.sb_agcount)
> @@ -1884,8 +1864,7 @@ xfs_dialloc(
>  	}
>  
>  out_alloc:
> -	*IO_agbp = NULL;
> -	return xfs_dialloc_ag(tp, agbp, parent, inop);
> +	return xfs_dialloc_ag(*tpp, agbp, parent, inop);
>  out_error:
>  	xfs_perag_put(pag);
>  	return error;
> diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
> index a145e2a72530..13810ffe4af9 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.h
> +++ b/fs/xfs/libxfs/xfs_ialloc.h
> @@ -32,40 +32,20 @@ xfs_make_iptr(struct xfs_mount *mp, struct xfs_buf *b, int o)
>  	return xfs_buf_offset(b, o << (mp)->m_sb.sb_inodelog);
>  }
>  
> -/* XXX: will be removed in the following patch */
> -int
> -xfs_dialloc_roll(
> -	struct xfs_trans	**tpp,
> -	struct xfs_buf		*agibp);
> -
>  /*
>   * Allocate an inode on disk.
>   * Mode is used to tell whether the new inode will need space, and whether
>   * it is a directory.
>   *
> - * To work within the constraint of one allocation per transaction,
> - * xfs_dialloc() is designed to be called twice if it has to do an
> - * allocation to make more free inodes.  If an inode is
> - * available without an allocation, agbp would be set to the current
> - * agbp and alloc_done set to false.
> - * If an allocation needed to be done, agbp would be set to the
> - * inode header of the allocation group and alloc_done set to true.
> - * The caller should then commit the current transaction and allocate a new
> - * transaction.  xfs_dialloc() should then be called again with
> - * the agbp value returned from the previous call.
> - *
>   * Once we successfully pick an inode its number is returned and the
>   * on-disk data structures are updated.  The inode itself is not read
>   * in, since doing so would break ordering constraints with xfs_reclaim.
> - *
> - * *agbp should be set to NULL on the first call, *alloc_done set to FALSE.
>   */
>  int					/* error */
>  xfs_dialloc(
> -	struct xfs_trans *tp,		/* transaction pointer */
> +	struct xfs_trans **tpp,		/* double pointer of transaction */
>  	xfs_ino_t	parent,		/* parent inode (directory) */
>  	umode_t		mode,		/* mode bits for new inode */
> -	struct xfs_buf	**agbp,		/* buf for a.g. inode header */
>  	xfs_ino_t	*inop);		/* inode number allocated */
>  
>  /*
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 34eca1624397..c039fc56b396 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -909,7 +909,6 @@ xfs_dir_ialloc(
>  					   locked. */
>  {
>  	xfs_inode_t	*ip;
> -	xfs_buf_t	*ialloc_context = NULL;
>  	xfs_ino_t	pino = dp ? dp->i_ino : 0;
>  	xfs_ino_t	ino;
>  	int		error;
> @@ -928,31 +927,10 @@ xfs_dir_ialloc(
>  	 * commit so that no other process can steal the inode(s) that we've
>  	 * just allocated.
>  	 */
> -	error = xfs_dialloc(*tpp, pino, mode, ialloc_context, &ino);
> +	error = xfs_dialloc(tpp, pino, mode, &ino);
>  	if (error)
>  		return error;
>  
> -	/*
> -	 * If the AGI buffer is non-NULL, then we were unable to get an
> -	 * inode in one operation.  We need to commit the current
> -	 * transaction and call xfs_ialloc() then.  It is guaranteed
> -	 * to succeed the second time.
> -	 */
> -	if (ialloc_context) {
> -		error = xfs_dialloc_roll(tpp, ialloc_context);
> -		if (error)
> -			return error;
> -		/*
> -		 * Call dialloc again. Since we've locked out all other
> -		 * allocations in this allocation group, this call should
> -		 * always succeed.
> -		 */
> -		error = xfs_dialloc(*tpp, pino, mode, ialloc_context, &ino);
> -		if (error)
> -			return error;
> -		ASSERT(!ialloc_context);
> -	}
> -
>  	if (ino == NULLFSINO)
>  		return -ENOSPC;
>  
> -- 
> 2.18.4
> 
