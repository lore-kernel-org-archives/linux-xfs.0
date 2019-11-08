Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55A80FC6196
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 21:19:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D61A20869
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 21:19:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DBZCNhql"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387468AbfKHVTY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 16:19:24 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:38426 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387601AbfKHVTY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 16:19:24 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8L9BxB175018
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 21:19:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=C5D0/rks9tskzgOuax52eQ/JSvyz+aBYfVpgVhPqyTw=;
 b=DBZCNhqlcZ3YojHSzcYhTK1BY1MRup/MegA9dJ7kJT8tKX1nGYG/0xpKl8V9w+Uk4Fi6
 1SVPHJbILsrl0HH+gPzsd7eEljuhOt9nHwgw+KZLcD1gai/Q7pL7io7KfnX+vhG2oFA5
 yUZa1Ctqz+4dhFfw/NbQGecKYtekQJoEMRiWHpgAqk8Yk5uw1byPgEiba4MUFWEw/xCe
 ap3H3yykk2ip6JFa6yGRSuFdoM8i9p8G8hLCyYMB8lalFnTXVOy0zZA235+z3eGqmCzK
 oc10b0xcG0vud4kwh5u2+Awuh+cJEq7dzUIyzUarEPqXI+LPqT/KbvAf3hCYyJXR9wH9 Bg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2w41w17r1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 21:19:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8L9742174257
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 21:19:21 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2w5bmqd3y0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 21:19:21 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA8LJKHk025243
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 21:19:20 GMT
Received: from localhost (/10.159.140.196)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Nov 2019 13:19:09 -0800
Date:   Fri, 8 Nov 2019 13:19:09 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 12/17] xfs: Factor out xfs_attr_rmtval_invalidate
Message-ID: <20191108211909.GC6219@magnolia>
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-13-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107012801.22863-13-allison.henderson@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080204
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080204
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 06, 2019 at 06:27:56PM -0700, Allison Collins wrote:
> Because new delayed attribute routines cannot roll
> transactions, we carve off the parts of
> xfs_attr_rmtval_remove that we can use.  This will help to
> reduce repetitive code later when we introduce delayed
> attributes.

Looks good.
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D


> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_attr_remote.c | 30 +++++++++++++++++++++---------
>  fs/xfs/libxfs/xfs_attr_remote.h |  1 +
>  2 files changed, 22 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index db51388..1544138 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -588,21 +588,14 @@ xfs_attr_rmtval_set_value(
>  	return 0;
>  }
>  
> -/*
> - * Remove the value associated with an attribute by deleting the
> - * out-of-line buffer that it is stored on.
> - */
>  int
> -xfs_attr_rmtval_remove(
> +xfs_attr_rmtval_invalidate(
>  	struct xfs_da_args	*args)
>  {
>  	struct xfs_mount	*mp = args->dp->i_mount;
>  	xfs_dablk_t		lblkno;
>  	int			blkcnt;
>  	int			error;
> -	int			done;
> -
> -	trace_xfs_attr_rmtval_remove(args);
>  
>  	/*
>  	 * Roll through the "value", invalidating the attribute value's blocks.
> @@ -644,13 +637,32 @@ xfs_attr_rmtval_remove(
>  		lblkno += map.br_blockcount;
>  		blkcnt -= map.br_blockcount;
>  	}
> +	return 0;
> +}
>  
> +/*
> + * Remove the value associated with an attribute by deleting the
> + * out-of-line buffer that it is stored on.
> + */
> +int
> +xfs_attr_rmtval_remove(
> +	struct xfs_da_args      *args)
> +{
> +	xfs_dablk_t		lblkno;
> +	int			blkcnt;
> +	int			error = 0;
> +	int			done = 0;
> +
> +	trace_xfs_attr_rmtval_remove(args);
> +
> +	error = xfs_attr_rmtval_invalidate(args);
> +	if (error)
> +		return error;
>  	/*
>  	 * Keep de-allocating extents until the remote-value region is gone.
>  	 */
>  	lblkno = args->rmtblkno;
>  	blkcnt = args->rmtblkcnt;
> -	done = 0;
>  	while (!done) {
>  		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
>  				    XFS_BMAPI_ATTRFORK, 1, &done);
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
> index cd7670d..b6fd35a 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.h
> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> @@ -11,6 +11,7 @@ int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
>  int xfs_attr_rmtval_get(struct xfs_da_args *args);
>  int xfs_attr_rmtval_set(struct xfs_da_args *args);
>  int xfs_attr_rmtval_remove(struct xfs_da_args *args);
> +int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
>  int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
>  int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
>  #endif /* __XFS_ATTR_REMOTE_H__ */
> -- 
> 2.7.4
> 
