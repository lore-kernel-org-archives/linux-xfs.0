Return-Path: <SRS0=SLm5=XN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48AC8C4CEC9
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 20:56:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 177BE21848
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 20:56:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MYZR2A3b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729868AbfIRU4U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Sep 2019 16:56:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52150 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728764AbfIRU4U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Sep 2019 16:56:20 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IKtS16051784;
        Wed, 18 Sep 2019 20:56:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=QHyo1v6qO7pM8Z5yHOj+OrXKxDWtodWvJkdEsdtK3Fg=;
 b=MYZR2A3bbgio2z5xCr6TNMSoAmF27AoaQ24OInL79fso159usixZOBUvbGc4Bi2e1oSH
 rdoczXMVgIyTamtgHmEnjRy6+uBC3gg+3k+WoiMeerOMY2RiomLs3oX7mO9ZNZEW+fe2
 A14cfEgturaWoC4RW1pNJvvy6zU7rr0myjyidN02bFxtoaQRLTff5AVFlBlO+849OEwO
 d/R3Ksyyxck+LC2P8vXWT0GhN8dbY6ZCcN4fw1/+0x4eLUn1uUC80Tz04QjoRma+cRKW
 5xAYorKQhitpe5nRMUoHMAIAQFbRlW5e47lkb0z+D3XciytijH/yQkVQOVUQxiIko9MS Mw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2v385dxg0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 20:56:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IKssiJ047573;
        Wed, 18 Sep 2019 20:56:03 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2v37mnasa9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 20:56:03 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8IKu2G1023273;
        Wed, 18 Sep 2019 20:56:02 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Sep 2019 13:56:02 -0700
Date:   Wed, 18 Sep 2019 13:56:01 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 10/11] xfs: factor out tree fixup logic into helper
Message-ID: <20190918205601.GY2229799@magnolia>
References: <20190916121635.43148-1-bfoster@redhat.com>
 <20190916121635.43148-11-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916121635.43148-11-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909180180
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909180180
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 16, 2019 at 08:16:34AM -0400, Brian Foster wrote:
> Lift the btree fixup path into a helper function.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.c | 42 +++++++++++++++++++++++++++++----------
>  fs/xfs/xfs_trace.h        |  1 +
>  2 files changed, 33 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 6f7e4666250c..381a08257aaf 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -883,6 +883,36 @@ xfs_alloc_cur_check(
>  	return 0;
>  }
>  
> +/*
> + * Complete an allocation of a candidate extent. Remove the extent from both
> + * trees and update the args structure.
> + */
> +STATIC int
> +xfs_alloc_cur_finish(
> +	struct xfs_alloc_arg	*args,
> +	struct xfs_alloc_cur	*acur)
> +{
> +	int			error;
> +
> +	ASSERT(acur->cnt && acur->bnolt);
> +	ASSERT(acur->bno >= acur->rec_bno);
> +	ASSERT(acur->bno + acur->len <= acur->rec_bno + acur->rec_len);
> +	ASSERT(acur->rec_bno + acur->rec_len <=
> +	       be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
> +
> +	error = xfs_alloc_fixup_trees(acur->cnt, acur->bnolt, acur->rec_bno,
> +				      acur->rec_len, acur->bno, acur->len, 0);
> +	if (error)
> +		return error;
> +
> +	args->agbno = acur->bno;
> +	args->len = acur->len;
> +	args->wasfromfl = 0;
> +
> +	trace_xfs_alloc_cur(args);
> +	return 0;
> +}
> +
>  /*
>   * Deal with the case where only small freespaces remain. Either return the
>   * contents of the last freespace record, or allocate space from the freelist if
> @@ -1352,7 +1382,6 @@ xfs_alloc_ag_vextent_near(
>  	} else if (error) {
>  		goto out;
>  	}
> -	args->wasfromfl = 0;
>  
>  	/*
>  	 * First algorithm.
> @@ -1433,15 +1462,8 @@ xfs_alloc_ag_vextent_near(
>  	}
>  
>  alloc:
> -	args->agbno = acur.bno;
> -	args->len = acur.len;
> -	ASSERT(acur.bno >= acur.rec_bno);
> -	ASSERT(acur.bno + acur.len <= acur.rec_bno + acur.rec_len);
> -	ASSERT(acur.rec_bno + acur.rec_len <=
> -	       be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
> -
> -	error = xfs_alloc_fixup_trees(acur.cnt, acur.bnolt, acur.rec_bno,
> -				      acur.rec_len, acur.bno, acur.len, 0);
> +	/* fix up btrees on a successful allocation */
> +	error = xfs_alloc_cur_finish(args, &acur);
>  
>  out:
>  	xfs_alloc_cur_close(&acur, error);
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 2e57dc3d4230..b8b93068efe7 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1642,6 +1642,7 @@ DEFINE_ALLOC_EVENT(xfs_alloc_exact_notfound);
>  DEFINE_ALLOC_EVENT(xfs_alloc_exact_error);
>  DEFINE_ALLOC_EVENT(xfs_alloc_near_nominleft);
>  DEFINE_ALLOC_EVENT(xfs_alloc_near_first);
> +DEFINE_ALLOC_EVENT(xfs_alloc_cur);
>  DEFINE_ALLOC_EVENT(xfs_alloc_cur_right);
>  DEFINE_ALLOC_EVENT(xfs_alloc_cur_left);
>  DEFINE_ALLOC_EVENT(xfs_alloc_near_error);
> -- 
> 2.20.1
> 
