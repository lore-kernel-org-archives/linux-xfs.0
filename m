Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20464C64E7A
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 16:57:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE3E420758
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 16:57:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="yz4QemZj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388821AbgLAQ5V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Dec 2020 11:57:21 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:47636 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388184AbgLAQ5V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 11:57:21 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1GtLrf161342;
        Tue, 1 Dec 2020 16:56:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=N8901k35r16nO1pr/e2pClLcdTOjoPFQLRotmoFDod8=;
 b=yz4QemZjhtwPqpCwiljU8eHlOHB7v2xa8FScyyTU5uW9a4ML3P/OnLvLCinw8jQ/e3r8
 sQoVtcBx3FY6IcWgsW4uphcwzCRTVoadBYpjp3msN91AFoOjUNJvPHNIFYxrv9jiO+LA
 uXuCy+ZhXW2y00jFwdHvYVm+lmPLQe8NfPE7JQcGklGeyYXkN7sV+5F2zcCoIfFFndUY
 HRlIJQvGpuFQLNkkFHzvjrPAgGPqcO44SZ/sYtxqeGDXDsWmTxMkZyMi9hUq/N7WoNFV
 ucuBnd4QgvpnGpvNlgtPEcBct+QBgKNi6bnqkvp7vrRMbZ82IjGUr7JdUEADMUApbFM9 /w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 353c2autd0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 16:56:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1Gu6b5036099;
        Tue, 1 Dec 2020 16:56:38 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3540ey7rnc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 16:56:38 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B1GubfJ010973;
        Tue, 1 Dec 2020 16:56:37 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 08:56:37 -0800
Date:   Tue, 1 Dec 2020 08:56:36 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: convert noroom, okalloc in xfs_dialloc() to bool
Message-ID: <20201201165636.GF143045@magnolia>
References: <20201124155130.40848-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201124155130.40848-1-hsiangkao@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=1 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010104
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010104
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 24, 2020 at 11:51:28PM +0800, Gao Xiang wrote:
> Boolean is preferred for such use.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

Looks simple enough,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 974e71bc4a3a..45cf7e55f5ee 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -1716,11 +1716,11 @@ xfs_dialloc(
>  	xfs_agnumber_t		agno;
>  	int			error;
>  	int			ialloced;
> -	int			noroom = 0;
> +	bool			noroom = false;
>  	xfs_agnumber_t		start_agno;
>  	struct xfs_perag	*pag;
>  	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
> -	int			okalloc = 1;
> +	bool			okalloc = true;
>  
>  	if (*IO_agbp) {
>  		/*
> @@ -1753,8 +1753,8 @@ xfs_dialloc(
>  	if (igeo->maxicount &&
>  	    percpu_counter_read_positive(&mp->m_icount) + igeo->ialloc_inos
>  							> igeo->maxicount) {
> -		noroom = 1;
> -		okalloc = 0;
> +		noroom = true;
> +		okalloc = false;
>  	}
>  
>  	/*
> -- 
> 2.18.4
> 
