Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 268CAC64E7B
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 17:05:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEDE6206B7
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 17:05:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GdvivVsl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388821AbgLARFH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Dec 2020 12:05:07 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:60336 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387407AbgLARFH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 12:05:07 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1GtHwn010607;
        Tue, 1 Dec 2020 17:04:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=mFAymsUaGzHqfO2e1CaAb2lzDc0TH82l4y//GXrjzEQ=;
 b=GdvivVslH15jbEVCzWG8KdYDY64ViqiVAhjYrrvsb31kQnSaEm/xA+HGuFWzXKCuMCH1
 rvy13lg22fh8O52Wzxjpha7CsFrmIai7xOyRxAfI2Js/IEXDra3hPMp9Qp9eMcovIf02
 j4wxk3e9DSY1SsXkpqw5K3zjCEM3tVIibcnHGIHB4H64nf1uwo7maQRU54bLBOho76H1
 n+hgrYoecYzvgKyeMA5VAkOx35Q97mJjcRAwG2BpCbJPX6oxyBvuJ7uDPHNq7GlZpXfA
 VpGdeAHfohyNB4eI6Sb6nM8dkSJ8NLJ7B/AWDQhrEUq/sVJ2V5Hsk8ulOSqLet6FMvKd lw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 353dyqkr5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 17:04:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1GuGVD049687;
        Tue, 1 Dec 2020 17:04:23 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3540asns4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 17:04:23 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B1H4MEd027323;
        Tue, 1 Dec 2020 17:04:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 09:04:22 -0800
Date:   Tue, 1 Dec 2020 09:04:20 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: kill ialloced in xfs_dialloc()
Message-ID: <20201201170420.GG143045@magnolia>
References: <20201124155130.40848-1-hsiangkao@redhat.com>
 <20201124155130.40848-2-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201124155130.40848-2-hsiangkao@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=1
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010104
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=1 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010104
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 24, 2020 at 11:51:29PM +0800, Gao Xiang wrote:
> It's enough to just use return code, and get rid of an argument.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 45cf7e55f5ee..5c8b0210aad3 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -607,13 +607,14 @@ xfs_inobt_insert_sprec(
>  
>  /*
>   * Allocate new inodes in the allocation group specified by agbp.
> - * Return 0 for success, else error code.
> + * Return 0 for successfully allocating some inodes in this AG;
> + *        1 for skipping to allocating in the next AG;
> + *      < 0 for error code.
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
> @@ -795,10 +796,9 @@ xfs_ialloc_ag_alloc(
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
> @@ -903,7 +903,6 @@ xfs_ialloc_ag_alloc(
>  	 */
>  	xfs_trans_mod_sb(tp, XFS_TRANS_SB_ICOUNT, (long)newlen);
>  	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, (long)newlen);
> -	*alloc = 1;
>  	return 0;
>  }
>  
> @@ -1715,7 +1714,6 @@ xfs_dialloc(
>  	struct xfs_buf		*agbp;
>  	xfs_agnumber_t		agno;
>  	int			error;
> -	int			ialloced;
>  	bool			noroom = false;
>  	xfs_agnumber_t		start_agno;
>  	struct xfs_perag	*pag;
> @@ -1799,8 +1797,8 @@ xfs_dialloc(
>  			goto nextag_relse_buffer;
>  
>  
> -		error = xfs_ialloc_ag_alloc(tp, agbp, &ialloced);
> -		if (error) {
> +		error = xfs_ialloc_ag_alloc(tp, agbp);
> +		if (error < 0) {
>  			xfs_trans_brelse(tp, agbp);
>  
>  			if (error != -ENOSPC)
> @@ -1811,7 +1809,7 @@ xfs_dialloc(
>  			return 0;
>  		}
>  
> -		if (ialloced) {
> +		if (!error) {

I wonder if this should be "if (error == 0)" because the comment
for _ialloc_ag_alloc says that 0 and 1 have specific meanings?

Otherwise looks fine to me.

--D

>  			/*
>  			 * We successfully allocated some inodes, return
>  			 * the current context to the caller so that it
> -- 
> 2.18.4
> 
