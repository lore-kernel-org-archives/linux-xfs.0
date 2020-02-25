Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD89CC35E04
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 16:24:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94D002082F
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 16:24:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FT040huk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730374AbgBYQYb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 11:24:31 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58340 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729817AbgBYQYa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 11:24:30 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PGNRUk142086;
        Tue, 25 Feb 2020 16:24:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=FdlU013jYC76ZlQE5DtRKYCQaWTa5/jeQa+3YNIOLiI=;
 b=FT040hukHJ1os+LB7P+ozkFjwRUp72MzcBDA++s2fBIV4oNPRTazrLh2n2jF2XqsTKw4
 GdX8i9S6ubtVnqDoNyL+YOM1+y0hEMATHSsXslSfOOwATYY1kzie9ztN1c1aqvKJNxxE
 JlY4YMtMn4gK5I9zaH71kfSJ6u3RwZsBp36CeXqaQ2zeBlazgVqlYTMl3EnNyzxqdmN1
 LKwBxZj3MlPTnXtGHEK0Q2MCND7C7yivziNtb75i7FLuAecorYoJ2YcQuSN7S6PGgp0n
 TNgChgW+PmxPOHopuNZ0DPVGYi2TJjDzFCjZPjMGeyGeZSAeluyMxUumRNb6kqn2IsR3 mw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2yd0njjhkv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 16:24:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PGENRM059236;
        Tue, 25 Feb 2020 16:24:23 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2yd09awtax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 16:24:23 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01PGOLFT009826;
        Tue, 25 Feb 2020 16:24:21 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Feb 2020 08:24:21 -0800
Date:   Tue, 25 Feb 2020 08:24:20 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Rajendra <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        chandan@linux.ibm.com, bfoster@redhat.com, amir73il@gmail.com
Subject: Re: [PATCH V4 RESEND 6/7] xfs: Make xfs_attr_calc_size() non-static
Message-ID: <20200225162420.GH6740@magnolia>
References: <20200224040044.30923-1-chandanrlinux@gmail.com>
 <20200224040044.30923-7-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224040044.30923-7-chandanrlinux@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002250124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 malwarescore=0 priorityscore=1501 impostorscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002250124
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 09:30:43AM +0530, Chandan Rajendra wrote:
> A future commit will cause xfs_attr_calc_size() to be invoked from a function
> defined in another file. Hence this commit makes xfs_attr_calc_size() as
> non-static.
> 
> Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 58 ++++++++++++++++++++--------------------
>  fs/xfs/libxfs/xfs_attr.h |  2 ++
>  2 files changed, 31 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index f781724bf85ce..1d62ce80d7949 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -133,10 +133,38 @@ xfs_attr_get(
>  	return error;
>  }
>  
> +STATIC int
> +xfs_attr_try_sf_addname(

Why does this function move?

--D

> +	struct xfs_inode	*dp,
> +	struct xfs_da_args	*args)
> +{
> +
> +	struct xfs_mount	*mp = dp->i_mount;
> +	int			error, error2;
> +
> +	error = xfs_attr_shortform_addname(args);
> +	if (error == -ENOSPC)
> +		return error;
> +
> +	/*
> +	 * Commit the shortform mods, and we're done.
> +	 * NOTE: this is also the error path (EEXIST, etc).
> +	 */
> +	if (!error && !(args->op_flags & XFS_DA_OP_NOTIME))
> +		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
> +
> +	if (mp->m_flags & XFS_MOUNT_WSYNC)
> +		xfs_trans_set_sync(args->trans);
> +
> +	error2 = xfs_trans_commit(args->trans);
> +	args->trans = NULL;
> +	return error ? error : error2;
> +}
> +
>  /*
>   * Calculate how many blocks we need for the new attribute,
>   */
> -STATIC void
> +void
>  xfs_attr_calc_size(
>  	struct xfs_mount		*mp,
>  	struct xfs_attr_set_resv	*resv,
> @@ -176,34 +204,6 @@ xfs_attr_calc_size(
>  		resv->bmbt_blks;
>  }
>  
> -STATIC int
> -xfs_attr_try_sf_addname(
> -	struct xfs_inode	*dp,
> -	struct xfs_da_args	*args)
> -{
> -
> -	struct xfs_mount	*mp = dp->i_mount;
> -	int			error, error2;
> -
> -	error = xfs_attr_shortform_addname(args);
> -	if (error == -ENOSPC)
> -		return error;
> -
> -	/*
> -	 * Commit the shortform mods, and we're done.
> -	 * NOTE: this is also the error path (EEXIST, etc).
> -	 */
> -	if (!error && !(args->op_flags & XFS_DA_OP_NOTIME))
> -		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
> -
> -	if (mp->m_flags & XFS_MOUNT_WSYNC)
> -		xfs_trans_set_sync(args->trans);
> -
> -	error2 = xfs_trans_commit(args->trans);
> -	args->trans = NULL;
> -	return error ? error : error2;
> -}
> -
>  /*
>   * Set the attribute specified in @args.
>   */
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index dc08bdfbc9615..0e387230744c3 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -104,5 +104,7 @@ int xfs_attr_set(struct xfs_da_args *args);
>  int xfs_attr_set_args(struct xfs_da_args *args);
>  int xfs_attr_remove_args(struct xfs_da_args *args);
>  bool xfs_attr_namecheck(const void *name, size_t length);
> +void xfs_attr_calc_size(struct xfs_mount *mp, struct xfs_attr_set_resv *resv,
> +		int namelen, int valuelen, int *local);
>  
>  #endif	/* __XFS_ATTR_H__ */
> -- 
> 2.19.1
> 
