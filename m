Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0F01C4361B
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 19:21:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94C81221EC
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 19:21:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731064AbgLCTU5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 14:20:57 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:42686 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726915AbgLCTU5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 14:20:57 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3JJc4R030063;
        Thu, 3 Dec 2020 19:20:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=HBa1f5oqghUGGalf5BMmMP23SAhykHNE9JKKn4FmiLE=;
 b=fbCw3Ni3JaDpMdAkPKzFlsSDLfMnTrNNTpp/KDH/UDsNMiIksBSeKAZeb7zEAzuqVXsS
 q0sL5nFyRgBm3nmPUPsXijMUKJN1MNCKkldWSP+B/h41WdMWLa0z8n0STaY18kXRuRlf
 0Ux4pXtlgeehNjXPdP64zc6+EThUTkikfPnw+ELKVWyIWzI3ikhqhDdg2PYOsWClPoSe
 99fBx316Wxjyx46uV8a47I6CHoboYdO4tf8+VOiSCCTgX6hnwIS7nA3j6C7UZZGmfSGd
 6IuLrPr8eBG1Jqtpfx7hVCJDhNX7EUb81buT7X3+9CCfH6cGeFeMnlEtadiVG9PWSjHl lg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 353dyqyuyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Dec 2020 19:20:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3ItSqb120999;
        Thu, 3 Dec 2020 19:20:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 3540g2a28w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Dec 2020 19:20:08 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B3JK6UF027206;
        Thu, 3 Dec 2020 19:20:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 19:20:05 +0000
Date:   Thu, 3 Dec 2020 11:20:04 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v2 2/6] xfs: introduce xfs_dialloc_roll()
Message-ID: <20201203192004.GE106272@magnolia>
References: <20201203161028.1900929-1-hsiangkao@redhat.com>
 <20201203161028.1900929-3-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203161028.1900929-3-hsiangkao@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1011 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=1 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030111
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 04, 2020 at 12:10:24AM +0800, Gao Xiang wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Introduce a helper to make the on-disk inode allocation rolling
> logic clearer in preparation of the following cleanup.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 45 ++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_ialloc.h |  6 +++++
>  fs/xfs/xfs_inode.c         | 39 +--------------------------------
>  3 files changed, 52 insertions(+), 38 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 45cf7e55f5ee..d5dc3167e2ff 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -1682,6 +1682,51 @@ xfs_dialloc_ag(
>  	return error;
>  }
>  
> +int
> +xfs_dialloc_roll(
> +	struct xfs_trans	**tpp,
> +	struct xfs_buf		*agibp)
> +{
> +	struct xfs_trans	*tp = *tpp;
> +	void			*dqinfo = NULL;

struct xfs_dquot_acct instead of void?

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

Assuming Eric's ok with adding a dummy t_dqinfo to struct xfs_trans in
userspace, this seems fine to me.

--D

> +		tp->t_dqinfo = NULL;
> +		tflags = tp->t_flags & XFS_TRANS_DQ_DIRTY;
> +		tp->t_flags &= ~(XFS_TRANS_DQ_DIRTY);
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
> +	if (error) {
> +		xfs_buf_relse(agibp);
> +		return error;
> +	}
> +	xfs_trans_bjoin(tp, agibp);
> +	return 0;
> +}
> +
>  /*
>   * Allocate an inode on disk.
>   *
> diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
> index 72b3468b97b1..a145e2a72530 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.h
> +++ b/fs/xfs/libxfs/xfs_ialloc.h
> @@ -32,6 +32,12 @@ xfs_make_iptr(struct xfs_mount *mp, struct xfs_buf *b, int o)
>  	return xfs_buf_offset(b, o << (mp)->m_sb.sb_inodelog);
>  }
>  
> +/* XXX: will be removed in the following patch */
> +int
> +xfs_dialloc_roll(
> +	struct xfs_trans	**tpp,
> +	struct xfs_buf		*agibp);
> +
>  /*
>   * Allocate an inode on disk.
>   * Mode is used to tell whether the new inode will need space, and whether
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 2bfbcf28b1bd..4ebfb1a18f0f 100644
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
> @@ -1003,46 +1001,11 @@ xfs_dir_ialloc(
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
> -			xfs_buf_relse(ialloc_context);
> -			*tpp = tp;
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
