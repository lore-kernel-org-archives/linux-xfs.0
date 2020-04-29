Return-Path: <SRS0=Q7ae=6N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65920C83000
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 23:05:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3241D206D9
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 23:05:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dajqklij"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgD2XFo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 19:05:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47478 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbgD2XFo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 19:05:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03TN3CEC040190
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 23:05:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=iV7/vM6jLGRYuhswjUzufIM/4JfcQSiHKe5DU1fsckI=;
 b=dajqklijMvhNqAKiVgNa1MJ/NKM2dRRBT9IvfywEku+HZJ+kIm5oCm2ZtLuOpI3/8iWa
 9VpE6nJl/VyE/3JQ04Y0TG/cbQ9lR1f83GydY2pVEU9kkRMDafsgHZzc3L3q+HkFIQkB
 jLldTaCwauB7Q+Y97rppcwUfRLkBOsxPBBSsokXzko96NsrVxqZxsT4SJUWwqGssbDX0
 r6Z694yxXJ0mI8nsMrooQUTYwoHowLSEQ3YEi/HHFJBZlLfKmer03/Rx4tnINoq641tt
 aS7N+oGirl0Wd3yWmeavxjCpMtq5vevjdTZYCBdjH+SQiEPgaipHDP+OlceJteDHwSnz oQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30nucg8g5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 23:05:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03TN2nhg182066
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 23:05:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30mxpm3w9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 23:05:42 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03TN5f7o025134
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 23:05:41 GMT
Received: from localhost (/10.159.128.65)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 Apr 2020 16:05:41 -0700
Date:   Wed, 29 Apr 2020 16:05:40 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v8 10/20] xfs: Add helper function
 __xfs_attr_rmtval_remove
Message-ID: <20200429230540.GV6742@magnolia>
References: <20200403221229.4995-1-allison.henderson@oracle.com>
 <20200403221229.4995-11-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200403221229.4995-11-allison.henderson@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290168
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 03, 2020 at 03:12:19PM -0700, Allison Collins wrote:
> This function is similar to xfs_attr_rmtval_remove, but adapted to
> return EAGAIN for new transactions. We will use this later when we
> introduce delayed attributes.  This function will eventually replace
> xfs_attr_rmtval_remove
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

Seems reasonable, but oh my the transaction roll hoisting is complex...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr_remote.c | 25 +++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_attr_remote.h |  1 +
>  2 files changed, 26 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 4d51969..fd4be9d 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -711,3 +711,28 @@ xfs_attr_rmtval_remove(
>  	}
>  	return 0;
>  }
> +
> +/*
> + * Remove the value associated with an attribute by deleting the out-of-line
> + * buffer that it is stored on. Returns EAGAIN for the caller to refresh the
> + * transaction and recall the function
> + */
> +int
> +__xfs_attr_rmtval_remove(
> +	struct xfs_da_args	*args)
> +{
> +	int	error, done;
> +
> +	/*
> +	 * Unmap value blocks for this attr.
> +	 */
> +	error = xfs_bunmapi(args->trans, args->dp, args->rmtblkno,
> +			    args->rmtblkcnt, XFS_BMAPI_ATTRFORK, 1, &done);
> +	if (error)
> +		return error;
> +
> +	if (!done)
> +		return -EAGAIN;
> +
> +	return 0;
> +}
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
> index eff5f95..ee3337b 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.h
> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> @@ -14,4 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
>  int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
>  		xfs_buf_flags_t incore_flags);
>  int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
> +int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
>  #endif /* __XFS_ATTR_REMOTE_H__ */
> -- 
> 2.7.4
> 
