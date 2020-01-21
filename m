Return-Path: <SRS0=uPG+=3K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51498C2D0CE
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 23:24:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B2A224125
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 23:24:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qw1GNhxU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbgAUXYN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 18:24:13 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:33976 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgAUXYN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 18:24:13 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LNInkI054913
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 23:24:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=pycB640fuuAg4bRFvtRm0fm57thfzvyAQtTqQvR+m/M=;
 b=qw1GNhxUb0gnQ4XHIR08yGGb66lGwz5ZjazvgpLuPycSkHBkLab32KoPjj6U/NR4Bsba
 sY3yc3F/IG8WrluFxKVNMX3fjj0L2ryKehlFGBgZOpn1CC2Drr/tUulICUeNaV8ycFHc
 0+xMemJzqcDuBib5ATN+ICSHPMFd83yH9XCfhAYIczrZhExV+FRzTFUmLCtYrY7KtlhV
 LCEfNJmjw0AR3GUM1zr+CXjFmN0VV88iBHxFd70gdGmi76KT7KajkaswNpcWVj6gx4zj
 +xihEW76M4xkNLd/toCeL8Ik7kFtpELlUMT+XHYUsD0w7y54WyCrBkl67TG95uDxpHOS jg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2xkseugh53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 23:24:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LNJTeV097426
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 23:24:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2xnpfpyfeq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 23:24:10 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00LNO9ZG024616
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 23:24:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 15:24:09 -0800
Date:   Tue, 21 Jan 2020 15:24:08 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v6 13/16] xfs: Add helper function xfs_attr_rmtval_unmap
Message-ID: <20200121232408.GM8247@magnolia>
References: <20200118225035.19503-1-allison.henderson@oracle.com>
 <20200118225035.19503-14-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200118225035.19503-14-allison.henderson@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 18, 2020 at 03:50:32PM -0700, Allison Collins wrote:
> This function is similar to xfs_attr_rmtval_remove, but adapted to
> return. EAGAIN for new transactions. We will use this later when we

"..to return -EAGAIN"?

> introduce delayed attributes
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr_remote.c | 27 +++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_attr_remote.h |  1 +
>  2 files changed, 28 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 9b4fa2a..f2ee0b8 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -684,3 +684,30 @@ xfs_attr_rmtval_remove(
>  	}
>  	return 0;
>  }
> +
> +/*
> + * Unmap value blocks for this attr.  This is similar to
> + * xfs_attr_rmtval_remove, but adapted to to return EAGAIN for new transactions

Do you have to scan for and invalidate any incore buffers for the remote
value?  Or will that be performed by another step?  Hard to tell because
this function doesn't have any callers.

> + */
> +int
> +xfs_attr_rmtval_unmap(
> +	struct xfs_da_args	*args)
> +{
> +	int	error, done;
> +
> +	/*
> +	 * Unmap value blocks for this attr.  This is similar to
> +	 * xfs_attr_rmtval_remove, but open coded here to return EAGAIN
> +	 * for new transactions
> +	 */
> +	error = xfs_bunmapi(args->trans, args->dp,
> +		    args->rmtblkno, args->rmtblkcnt,
> +		    XFS_BMAPI_ATTRFORK, 1, &done);
> +	if (error)
> +		return error;
> +
> +	if (!done)
> +		return -EAGAIN;

return done ? 0 : -EAGAIN; ?

--D

> +
> +	return 0;
> +}
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
> index 85f2593..7ab3770 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.h
> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> @@ -12,4 +12,5 @@ int xfs_attr_rmtval_get(struct xfs_da_args *args);
>  int xfs_attr_rmtval_set(struct xfs_da_args *args);
>  int xfs_attr_rmtval_remove(struct xfs_da_args *args);
>  int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
> +int xfs_attr_rmtval_unmap(struct xfs_da_args *args);
>  #endif /* __XFS_ATTR_REMOTE_H__ */
> -- 
> 2.7.4
> 
