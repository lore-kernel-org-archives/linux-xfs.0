Return-Path: <SRS0=Mbmt=WN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A029BC3A59D
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Aug 2019 00:52:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60EFD205F4
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Aug 2019 00:52:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ib/8L3Mr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbfHQAwD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Aug 2019 20:52:03 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49294 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfHQAwD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Aug 2019 20:52:03 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7H0nASh151042;
        Sat, 17 Aug 2019 00:51:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=FULevhIUHq9s4zgwLAAbSY2549bSArYXKEE45p+CBGw=;
 b=ib/8L3Mrx6lOYdQnYwCYcTv2ynT++OSmeYa92DC6MYZeUUAYFXx4NvvANWLzrEyYo/Q2
 6LF5WTx7kcP30MED76J5kk/dqYA3CXXY6vILoXx6r2gl942bOpm/gYLVhhYLFDdyU3n7
 zYPk5jQUj33eG0daBYrTiZP8DFw2jPkkHnoJYpNHv31xkZmV8u4RYqPkNeOMH0nSQOIE
 MU90ZcQ45SmtvkyAWWlyqBaMC+jUTE91/Eqtwo+bPYJHx7skttoMGax30eXUfwoIKl8c
 jGrCJ4q3bGgtQE3dIWtVKz0gl2n+t/18VlpdFtOBQ8wxFdhge/6rlzdVUSS0h4cArJDu LQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2u9nbu3669-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 17 Aug 2019 00:51:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7H0lwPa116846;
        Sat, 17 Aug 2019 00:51:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2udyfvcr4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 17 Aug 2019 00:51:51 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7H0poo6004134;
        Sat, 17 Aug 2019 00:51:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 16 Aug 2019 17:51:50 -0700
Date:   Fri, 16 Aug 2019 17:51:49 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 1/4] xfs: track active state of allocation btree
 cursors
Message-ID: <20190817005149.GA752159@magnolia>
References: <20190815125538.49570-1-bfoster@redhat.com>
 <20190815125538.49570-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190815125538.49570-2-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9351 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908170005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9351 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908170005
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 15, 2019 at 08:55:35AM -0400, Brian Foster wrote:
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
> index 372ad55631fc..6340f59ac3f4 100644
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
> +	cur->bc_private.a.priv.abt.active = *stat;

<urk> Not really a fan of mixing types (even if they are bool and int),
how hard would it be to convert some of these *stat to bool?

Does abt.active have a use outside of the struct xfs_alloc_cur in the
next patch?

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
> +	cur->bc_private.a.priv.abt.active = *stat;
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
> +	cur->bc_private.a.priv.abt.active = *stat;
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
> index fa3cd8ab9aba..a66063c356cc 100644
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
