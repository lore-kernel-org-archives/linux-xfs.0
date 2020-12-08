Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86B6AC433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Dec 2020 23:10:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5ABBC23B16
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Dec 2020 23:10:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731615AbgLHXKF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Dec 2020 18:10:05 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37056 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731591AbgLHXKF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Dec 2020 18:10:05 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B8N3KOm177549;
        Tue, 8 Dec 2020 23:09:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=iCEmwogxDjUNkVUp6gYZWbZvrnyvtuBYHiwoJFZbhV4=;
 b=TgzI7anv2qiM/5XeLyPlsnJzyWEeL8tZ8GUJ3Q5ip1t/Mx2JnNYi9hLPYG39jQkvDdDj
 4Cnyq8TbtDmacZLImiGWWIItjXONXGfdBqcBm6+5op0KZtsqlob8fYcxwLx2sxlC9U7n
 Gx/Ibzo7sd9MSfwsmAoAI2HP7qyPdpJNK3fFJLYiZR7NL6iaIX4RnACir/c9GimNuuQd
 egV7v3n7oGjLb/y0OiEl0x5ADLi1N9RE4pOXOpXsAuAe5vJ7CHOZk2pAgW1wPHY2S+vp
 NyTjbSbyfS1xSQCvQS/W/HzgXeinYCcrsr/fty1fcbTvV8GB3/Ydb9y8jHX+qs+QFwoI AA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 35825m5fdn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 08 Dec 2020 23:09:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B8N6Vhl182296;
        Tue, 8 Dec 2020 23:09:16 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 358m3ydfxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Dec 2020 23:09:16 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B8N9FlA030743;
        Tue, 8 Dec 2020 23:09:15 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Dec 2020 15:09:14 -0800
Date:   Tue, 8 Dec 2020 15:09:13 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v4 2/6] xfs: introduce xfs_dialloc_roll()
Message-ID: <20201208230913.GF1943235@magnolia>
References: <20201208122003.3158922-1-hsiangkao@redhat.com>
 <20201208122003.3158922-3-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208122003.3158922-3-hsiangkao@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=1 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012080145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012080145
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 08, 2020 at 08:19:59PM +0800, Gao Xiang wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Introduce a helper to make the on-disk inode allocation rolling
> logic clearer in preparation of the following cleanup.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 43 ++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_ialloc.h |  5 +++++
>  fs/xfs/xfs_inode.c         | 37 +-------------------------------
>  3 files changed, 49 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 45cf7e55f5ee..23e94d43acb2 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -1682,6 +1682,49 @@ xfs_dialloc_ag(
>  	return error;
>  }
>  
> +int
> +xfs_dialloc_roll(
> +	struct xfs_trans	**tpp,
> +	struct xfs_buf		*agibp)
> +{
> +	struct xfs_trans	*tp = *tpp;
> +	struct xfs_dquot_acct	*dqinfo = NULL;
> +	unsigned int		tflags = 0;
> +	int			error;
> +
> +	/*
> +	 * Hold to on to the agibp across the commit so no other allocation can
> +	 * come in and take the free inodes we just allocated for our caller.
> +	 */
> +	xfs_trans_bhold(tp, agibp);
> +
> +	/*
> +	 * We want the quota changes to be associated with the next transaction,
> +	 * NOT this one. So, detach the dqinfo from this and attach it to the
> +	 * next transaction.
> +	 */
> +	if (tp->t_dqinfo) {
> +		dqinfo = tp->t_dqinfo;
> +		tp->t_dqinfo = NULL;
> +		tflags = tp->t_flags & XFS_TRANS_DQ_DIRTY;
> +		tp->t_flags &= ~XFS_TRANS_DQ_DIRTY;

FWIW, one of xiakaixu's cleanup patches removes XFS_TRANS_DQ_DIRTY on
the grounds that there seemed to be a 1:1 correlation between the dqinfo
being set and the flag being set.  That creates a minor merge conflict
that I can fix at commit time.  The rest looks fine, so

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D


> +	}
> +
> +	error = xfs_trans_roll(&tp);
> +
> +	/* Re-attach the quota info that we detached from prev trx. */
> +	if (dqinfo) {
> +		tp->t_dqinfo = dqinfo;
> +		tp->t_flags |= tflags;
> +	}
> +
> +	*tpp = tp;
> +	if (error)
> +		return error;
> +	xfs_trans_bjoin(tp, agibp);
> +	return 0;
> +}
> +
>  /*
>   * Allocate an inode on disk.
>   *
> diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
> index 72b3468b97b1..bd6e0db9e23c 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.h
> +++ b/fs/xfs/libxfs/xfs_ialloc.h
> @@ -32,6 +32,11 @@ xfs_make_iptr(struct xfs_mount *mp, struct xfs_buf *b, int o)
>  	return xfs_buf_offset(b, o << (mp)->m_sb.sb_inodelog);
>  }
>  
> +int
> +xfs_dialloc_roll(
> +	struct xfs_trans	**tpp,
> +	struct xfs_buf		*agibp);
> +
>  /*
>   * Allocate an inode on disk.
>   * Mode is used to tell whether the new inode will need space, and whether
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 2bfbcf28b1bd..76282da7a05c 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -958,8 +958,6 @@ xfs_dir_ialloc(
>  	xfs_inode_t	*ip;
>  	xfs_buf_t	*ialloc_context = NULL;
>  	int		code;
> -	void		*dqinfo;
> -	uint		tflags;
>  
>  	tp = *tpp;
>  	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
> @@ -1003,46 +1001,13 @@ xfs_dir_ialloc(
>  	 * to succeed the second time.
>  	 */
>  	if (ialloc_context) {
> -		/*
> -		 * Normally, xfs_trans_commit releases all the locks.
> -		 * We call bhold to hang on to the ialloc_context across
> -		 * the commit.  Holding this buffer prevents any other
> -		 * processes from doing any allocations in this
> -		 * allocation group.
> -		 */
> -		xfs_trans_bhold(tp, ialloc_context);
> -
> -		/*
> -		 * We want the quota changes to be associated with the next
> -		 * transaction, NOT this one. So, detach the dqinfo from this
> -		 * and attach it to the next transaction.
> -		 */
> -		dqinfo = NULL;
> -		tflags = 0;
> -		if (tp->t_dqinfo) {
> -			dqinfo = (void *)tp->t_dqinfo;
> -			tp->t_dqinfo = NULL;
> -			tflags = tp->t_flags & XFS_TRANS_DQ_DIRTY;
> -			tp->t_flags &= ~(XFS_TRANS_DQ_DIRTY);
> -		}
> -
> -		code = xfs_trans_roll(&tp);
> -
> -		/*
> -		 * Re-attach the quota info that we detached from prev trx.
> -		 */
> -		if (dqinfo) {
> -			tp->t_dqinfo = dqinfo;
> -			tp->t_flags |= tflags;
> -		}
> -
> +		code = xfs_dialloc_roll(&tp, ialloc_context);
>  		if (code) {
>  			xfs_buf_relse(ialloc_context);
>  			*tpp = tp;
>  			*ipp = NULL;
>  			return code;
>  		}
> -		xfs_trans_bjoin(tp, ialloc_context);
>  
>  		/*
>  		 * Call ialloc again. Since we've locked out all
> -- 
> 2.18.4
> 
