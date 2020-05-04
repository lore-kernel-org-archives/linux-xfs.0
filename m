Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F9A4C47257
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 18:47:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 704462073E
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 18:47:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CwuIOVOk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgEDSrX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 14:47:23 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52506 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727870AbgEDSrW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 14:47:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044IfPvE134613
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 18:47:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=RqFbmeyLqLtcRy3CExrSkWMcqujYPC5hD9WhyLZsDKo=;
 b=CwuIOVOkDKRhX+aIkGOU6228QORZ4csIs6P3tKnJnkWz7HN+U16u22ZK6OurPQVLCy/t
 X6OEEc/aunX4YR0VUnWJ7HHOOhmp6p7eg4vPaVB+mHQw9zLq7JfHKG5aknku/WNPROjN
 14nsTJOQovVcSL3PTV3uzEcMVBz2nHfQknWpyNWoCSxdB1zDmmSosIo6yocNVZG9LYH3
 HUOATPIZTEBcWRzEddoU5xWTL/Wgsst3fXK0l+x9cGK9qiKZV66qz2nRzxN17JrLd69b
 HIwRgkd2tczAWj7Kx/ChC/ha7PYT4R2AJb92nMgCkRws+rak3M2zSNVe8aA+JdDBaHsF uw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30s09r0rm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 18:47:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044IbbTI121605
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 18:47:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30t1r2xjxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 18:47:19 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 044IlIEP015923
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 18:47:19 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 11:47:18 -0700
Date:   Mon, 4 May 2020 11:47:17 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v9 15/24] xfs: Add helper function
 xfs_attr_leaf_mark_incomplete
Message-ID: <20200504184717.GB5703@magnolia>
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-16-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430225016.4287-16-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9610 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=1
 spamscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9610 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=1
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040145
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 30, 2020 at 03:50:07PM -0700, Allison Collins wrote:
> This patch helps to simplify xfs_attr_node_removename by modularizing
> the code around the transactions into helper functions.  This will make
> the function easier to follow when we introduce delayed attributes.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

LGTM,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 41 +++++++++++++++++++++++++++--------------
>  1 file changed, 27 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index d112910..df77a3c 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1148,6 +1148,32 @@ xfs_attr_node_shrink(
>  }
>  
>  /*
> + * Mark an attribute entry INCOMPLETE and save pointers to the relevant buffers
> + * for later deletion of the entry.
> + */
> +STATIC int
> +xfs_attr_leaf_mark_incomplete(
> +	struct xfs_da_args	*args,
> +	struct xfs_da_state	*state)
> +{
> +	int			error;
> +
> +	/*
> +	 * Fill in disk block numbers in the state structure
> +	 * so that we can get the buffers back after we commit
> +	 * several transactions in the following calls.
> +	 */
> +	error = xfs_attr_fillstate(state);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Mark the attribute as INCOMPLETE
> +	 */
> +	return xfs_attr3_leaf_setflag(args);
> +}
> +
> +/*
>   * Remove a name from a B-tree attribute list.
>   *
>   * This will involve walking down the Btree, and may involve joining
> @@ -1178,20 +1204,7 @@ xfs_attr_node_removename(
>  	ASSERT(blk->bp != NULL);
>  	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>  	if (args->rmtblkno > 0) {
> -		/*
> -		 * Fill in disk block numbers in the state structure
> -		 * so that we can get the buffers back after we commit
> -		 * several transactions in the following calls.
> -		 */
> -		error = xfs_attr_fillstate(state);
> -		if (error)
> -			goto out;
> -
> -		/*
> -		 * Mark the attribute as INCOMPLETE, then bunmapi() the
> -		 * remote value.
> -		 */
> -		error = xfs_attr3_leaf_setflag(args);
> +		error = xfs_attr_leaf_mark_incomplete(args, state);
>  		if (error)
>  			goto out;
>  
> -- 
> 2.7.4
> 
