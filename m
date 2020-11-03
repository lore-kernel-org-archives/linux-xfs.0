Return-Path: <SRS0=RpwR=EJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7045C388F2
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 18:50:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50CF422226
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 18:50:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gzBQit9E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729002AbgKCSub (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Nov 2020 13:50:31 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:60498 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728959AbgKCSub (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Nov 2020 13:50:31 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A3Ij2uL083277;
        Tue, 3 Nov 2020 18:50:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=/M6JciM9dxpBJQFFxjBVfk4PCq4FxLyeI2SBjwh2fkE=;
 b=gzBQit9EdPNK6Yv+6Lng6o04kKmnKo++w//tu/0s7QZtnQ2rW1dFunWEuvmu8hiZB0Ad
 hjXoRb73nucEQ+ILLQOuZIePWgWKtB6C2oltT7e6DJGTJfI+Ksu/R6NWcRpXcSaWg1Kw
 3zgONW0rbktzE6HbDFEjEsUZeCk6cxStcv0MEhQ6+oUn2M0Va8K4y2wav6EC/t7TVvnX
 FNA3t8r74zCXAIxA7ZIDi+8O9dlb/eLmRnzGpEXSIf74hgtRSRv7vGA28DPAezboyBkT
 KI+EViYsRPWJE0enDneasAunrZy1q5n/ZoRjmTr4JUg0H039/BUJeU/kMbwYqbvbqBhX hQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34hhw2jx9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 03 Nov 2020 18:50:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A3IkS4c173761;
        Tue, 3 Nov 2020 18:50:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 34hw0he3qy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Nov 2020 18:50:25 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A3IoOAn016562;
        Tue, 3 Nov 2020 18:50:24 GMT
Received: from localhost (/10.159.234.173)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Nov 2020 10:50:24 -0800
Date:   Tue, 3 Nov 2020 10:50:23 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Fengfei Xi <fengfei_xi@126.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Drop useless comments
Message-ID: <20201103185023.GJ7123@magnolia>
References: <1604275396-4565-1-git-send-email-fengfei_xi@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1604275396-4565-1-git-send-email-fengfei_xi@126.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9794 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 bulkscore=0
 mlxscore=0 suspectscore=5 spamscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011030126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9794 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=5 clxscore=1011 priorityscore=1501 impostorscore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011030126
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 02, 2020 at 08:03:16AM +0800, Fengfei Xi wrote:
> The names of functions xfs_buf_get_maps and _xfs_buf_free_pages

xfs_buf_get_maps?  I don't see any changes for that function...?

--D

> can fully express their roles. So their comments are redundant.
> We could drop them entirely.
> 
> Signed-off-by: Fengfei Xi <fengfei_xi@126.com>
> ---
>  fs/xfs/xfs_buf.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 4e4cf91..2aeed30 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -197,9 +197,6 @@
>  	return 0;
>  }
>  
> -/*
> - *	Frees b_pages if it was allocated.
> - */
>  static void
>  xfs_buf_free_maps(
>  	struct xfs_buf	*bp)
> @@ -297,9 +294,6 @@
>  	return 0;
>  }
>  
> -/*
> - *	Frees b_pages if it was allocated.
> - */
>  STATIC void
>  _xfs_buf_free_pages(
>  	xfs_buf_t	*bp)
> -- 
> 1.9.1
> 
