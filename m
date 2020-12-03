Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6DC3C4361A
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 19:09:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FE6421D95
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 19:09:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgLCTJP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 14:09:15 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43494 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgLCTJP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 14:09:15 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3IwM0d160694;
        Thu, 3 Dec 2020 19:08:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=uimChc3D9LBOpe4H/4kfDMrpVj4jORFX8H6D3X3Sd9U=;
 b=ywS0KY40KH6EdIF9I76NJ9Dxp8Kv2dJZeraKJD4aP5rxpwp4dcDGq4Zj9ue6vp9IxT1J
 dLrR8A7brkLayc/5dEl+eW7VG96KP2Qn/C0Ptv5b3JY6bSROFr4sAt10ZVuAvRXfFZGW
 qf0ZwGyS0zgHwNKD7VgBwchjuiJGXHCtfNPywGDUkficmYEGDMBLscY40pW1sr+E7Ehy
 efyhJNpRstdZY/2vIY9AyPtjyqeIQLnePnf/1zRkJrqrYkGFPsOvzlfr9IzgnB1d6one
 YScC68Zn9hGGyxBxrWiPSjUivV8Xpzuiepn8WXn2B3hca5hrR/HwPM+u6PehuGPq36Gp fA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 353dyqyt6y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Dec 2020 19:08:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3IuD0M101453;
        Thu, 3 Dec 2020 19:08:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3540f29hvd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Dec 2020 19:08:25 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B3J8O9q029797;
        Thu, 3 Dec 2020 19:08:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 11:08:24 -0800
Date:   Thu, 3 Dec 2020 11:08:23 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 6/6] xfs: kill ialloced in xfs_dialloc()
Message-ID: <20201203190823.GD106272@magnolia>
References: <20201203161028.1900929-1-hsiangkao@redhat.com>
 <20201203161028.1900929-7-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203161028.1900929-7-hsiangkao@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=1 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012030110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=1 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030110
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 04, 2020 at 12:10:28AM +0800, Gao Xiang wrote:
> It's enough to just use return code, and get rid of an argument.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

LGTM,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 24 +++++++++---------------
>  1 file changed, 9 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 597629353d4d..ec63afb59156 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -607,13 +607,13 @@ xfs_inobt_insert_sprec(
>  
>  /*
>   * Allocate new inodes in the allocation group specified by agbp.
> - * Return 0 for success, else error code.
> + * Returns 0 if inodes were allocated in this AG; 1 if there was no space
> + * in this AG; or the usual negative error code.
>   */
>  STATIC int
>  xfs_ialloc_ag_alloc(
>  	struct xfs_trans	*tp,
> -	struct xfs_buf		*agbp,
> -	int			*alloc)
> +	struct xfs_buf		*agbp)
>  {
>  	struct xfs_agi		*agi;
>  	struct xfs_alloc_arg	args;
> @@ -795,10 +795,9 @@ xfs_ialloc_ag_alloc(
>  		allocmask = (1 << (newlen / XFS_INODES_PER_HOLEMASK_BIT)) - 1;
>  	}
>  
> -	if (args.fsbno == NULLFSBLOCK) {
> -		*alloc = 0;
> -		return 0;
> -	}
> +	if (args.fsbno == NULLFSBLOCK)
> +		return 1;
> +
>  	ASSERT(args.len == args.minlen);
>  
>  	/*
> @@ -903,7 +902,6 @@ xfs_ialloc_ag_alloc(
>  	 */
>  	xfs_trans_mod_sb(tp, XFS_TRANS_SB_ICOUNT, (long)newlen);
>  	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, (long)newlen);
> -	*alloc = 1;
>  	return 0;
>  }
>  
> @@ -1749,7 +1747,6 @@ xfs_dialloc_select_ag(
>  	struct xfs_buf		*agbp;
>  	xfs_agnumber_t		agno;
>  	int			error;
> -	int			ialloced;
>  	bool			noroom = false;
>  	xfs_agnumber_t		start_agno;
>  	struct xfs_perag	*pag;
> @@ -1823,17 +1820,14 @@ xfs_dialloc_select_ag(
>  		if (!okalloc)
>  			goto nextag_relse_buffer;
>  
> -
> -		error = xfs_ialloc_ag_alloc(*tpp, agbp, &ialloced);
> -		if (error) {
> +		error = xfs_ialloc_ag_alloc(*tpp, agbp);
> +		if (error < 0) {
>  			xfs_trans_brelse(*tpp, agbp);
>  
>  			if (error == -ENOSPC)
>  				error = 0;
>  			break;
> -		}
> -
> -		if (ialloced) {
> +		} else if (error == 0) {
>  			/*
>  			 * We successfully allocated some inodes, so roll the
>  			 * transaction and return the locked AGI buffer to the
> -- 
> 2.18.4
> 
