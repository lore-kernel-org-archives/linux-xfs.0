Return-Path: <SRS0=aFxQ=X2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14D40C388F3
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Oct 2019 05:35:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D739B2168B
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Oct 2019 05:35:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SusVUBcR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbfJAFfn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Oct 2019 01:35:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60576 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbfJAFfn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Oct 2019 01:35:43 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x915XveZ034386;
        Tue, 1 Oct 2019 05:35:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=a4H517b8Q/r9Wyu3fVqUbzF0LeFs+lTaoxsRVD+WJAg=;
 b=SusVUBcRzqE2BH/PvX1NR5M4DzaTkJOIl24v6KDaaCspf2zceSQyAVadwdaTgStQop4J
 1v4vQQx51KTLC1ob363fYFUkoGzJkbYHaiVxhT/yDHD2qC+WKAZnNH0e/ef/Nd/grqgM
 dOkWCZdm7r4zaNHdk/ejQdQfmZxpl5tE7osUACzmZK8QlxDCKNTY24EhydHDHQMskadr
 p8CMVrLlR0CTfprjn95cIb8Z19mOkFxDmeb8Spgh/q/jIRAEpCX4coAqr65A1mLsOixL
 6jm/yOpE/sUu2JVZ+Y22c1/cS4cyBFRh8OSBl9N8g41yz9OIP4ZBjQLR28UzOKnwd/PC Tw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2va05rk8n7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 05:35:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x915Xx12001189;
        Tue, 1 Oct 2019 05:35:30 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2vbqd072ee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 05:35:30 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x915ZTD6024484;
        Tue, 1 Oct 2019 05:35:29 GMT
Received: from localhost (/67.161.8.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Sep 2019 22:35:29 -0700
Date:   Mon, 30 Sep 2019 22:35:28 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 01/11] xfs: track active state of allocation btree
 cursors
Message-ID: <20191001053528.GF13108@magnolia>
References: <20190927171802.45582-1-bfoster@redhat.com>
 <20190927171802.45582-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190927171802.45582-2-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910010054
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010054
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 27, 2019 at 01:17:52PM -0400, Brian Foster wrote:
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

Looks good to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.c       | 24 +++++++++++++++++++++---
>  fs/xfs/libxfs/xfs_alloc_btree.c |  1 +
>  fs/xfs/libxfs/xfs_btree.h       |  3 +++
>  3 files changed, 25 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 533b04aaf6f6..0ecc142c833b 100644
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
> +	cur->bc_private.a.priv.abt.active = (*stat == 1);
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
> +	cur->bc_private.a.priv.abt.active = (*stat == 1);
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
> +	cur->bc_private.a.priv.abt.active = (*stat == 1);
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
