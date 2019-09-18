Return-Path: <SRS0=SLm5=XN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D0E0C4CEC4
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 18:39:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4389321924
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 18:39:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G+0PhEx4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbfIRSjZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Sep 2019 14:39:25 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59482 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbfIRSjZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Sep 2019 14:39:25 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IIcw2K150780;
        Wed, 18 Sep 2019 18:39:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=3bPrb2DBx3ehg4ysiPeudwn+jybzlL4QJRtIaA6J1UY=;
 b=G+0PhEx4CCyKy3g8tBARZX1HJ/PsY5kJbigHlbDFZ/OPoH1h+fEyrZYxMmiWVWSdpVHE
 /4rn8tEiu634Inz3OV4Q1xDG4jYYx4M4GiEK/eCXaPSV8rdsROMz5qMSvhkMulXd6J3J
 lixHIXR4FA5Zw0SWhRnNc2AirdpozBz1l4NRQcCwfLmhNIREWTJlyeTw85XKcZrrztfl
 4EQ+2ZrtTzpzoGoyUC+w+Lvsw+yX7N1ji80dgdiG6U1T3HXCcGXEU0RgpJqcVzi7rzDw
 wiLICJYc+MHEyhBReLYjpy3kKHMkafAgBAySdS261Vrq4kEvYsn6oyuyS6OYtAmZF2gU /g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2v385dwsxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 18:39:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IId2Gu122988;
        Wed, 18 Sep 2019 18:39:08 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2v37mn4etm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 18:39:07 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8IIcJ5F029669;
        Wed, 18 Sep 2019 18:38:19 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Sep 2019 11:38:19 -0700
Date:   Wed, 18 Sep 2019 11:38:18 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 01/11] xfs: track active state of allocation btree
 cursors
Message-ID: <20190918183818.GP2229799@magnolia>
References: <20190916121635.43148-1-bfoster@redhat.com>
 <20190916121635.43148-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916121635.43148-2-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909180163
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909180163
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 16, 2019 at 08:16:25AM -0400, Brian Foster wrote:
> The upcoming allocation algorithm update searches multiple
> allocation btree cursors concurrently. As such, it requires an
> active state to track when a particular cursor should continue
> searching. While active state will be modified based on higher level
> logic, we can define base functionality based on the result of
> allocation btree lookups.
> 
> Define an active flag in the private area of the btree cursor.
> Update it based on the result of lookups in the existing allocation
> btree helpers. Finally, provide a new helper to query the current
> state.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c       | 24 +++++++++++++++++++++---
>  fs/xfs/libxfs/xfs_alloc_btree.c |  1 +
>  fs/xfs/libxfs/xfs_btree.h       |  3 +++
>  3 files changed, 25 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 533b04aaf6f6..512a45888e06 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -146,9 +146,13 @@ xfs_alloc_lookup_eq(
>  	xfs_extlen_t		len,	/* length of extent */
>  	int			*stat)	/* success/failure */
>  {
> +	int			error;
> +
>  	cur->bc_rec.a.ar_startblock = bno;
>  	cur->bc_rec.a.ar_blockcount = len;
> -	return xfs_btree_lookup(cur, XFS_LOOKUP_EQ, stat);
> +	error = xfs_btree_lookup(cur, XFS_LOOKUP_EQ, stat);
> +	cur->bc_private.a.priv.abt.active = *stat == 1 ? true : false;

I think "cur->bc_private.a.priv.abt.active = (*stat == 1);" would have
sufficed for these, right?  (Yeah, sorry, picking at nits here...)

--D

> +	return error;
>  }
>  
>  /*
> @@ -162,9 +166,13 @@ xfs_alloc_lookup_ge(
>  	xfs_extlen_t		len,	/* length of extent */
>  	int			*stat)	/* success/failure */
>  {
> +	int			error;
> +
>  	cur->bc_rec.a.ar_startblock = bno;
>  	cur->bc_rec.a.ar_blockcount = len;
> -	return xfs_btree_lookup(cur, XFS_LOOKUP_GE, stat);
> +	error = xfs_btree_lookup(cur, XFS_LOOKUP_GE, stat);
> +	cur->bc_private.a.priv.abt.active = *stat == 1 ? true : false;
> +	return error;
>  }
>  
>  /*
> @@ -178,9 +186,19 @@ xfs_alloc_lookup_le(
>  	xfs_extlen_t		len,	/* length of extent */
>  	int			*stat)	/* success/failure */
>  {
> +	int			error;
>  	cur->bc_rec.a.ar_startblock = bno;
>  	cur->bc_rec.a.ar_blockcount = len;
> -	return xfs_btree_lookup(cur, XFS_LOOKUP_LE, stat);
> +	error = xfs_btree_lookup(cur, XFS_LOOKUP_LE, stat);
> +	cur->bc_private.a.priv.abt.active = *stat == 1 ? true : false;
> +	return error;
> +}
> +
> +static inline bool
> +xfs_alloc_cur_active(
> +	struct xfs_btree_cur	*cur)
> +{
> +	return cur && cur->bc_private.a.priv.abt.active;
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index 2a94543857a1..279694d73e4e 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> @@ -507,6 +507,7 @@ xfs_allocbt_init_cursor(
>  
>  	cur->bc_private.a.agbp = agbp;
>  	cur->bc_private.a.agno = agno;
> +	cur->bc_private.a.priv.abt.active = false;
>  
>  	if (xfs_sb_version_hascrc(&mp->m_sb))
>  		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index ced1e65d1483..b4e3ec1d7ff9 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -183,6 +183,9 @@ union xfs_btree_cur_private {
>  		unsigned long	nr_ops;		/* # record updates */
>  		int		shape_changes;	/* # of extent splits */
>  	} refc;
> +	struct {
> +		bool		active;		/* allocation cursor state */
> +	} abt;
>  };
>  
>  /*
> -- 
> 2.20.1
> 
