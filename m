Return-Path: <SRS0=eyVf=CG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0421C433E2
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Aug 2020 16:02:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 849C9208C9
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Aug 2020 16:02:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="unmg91qr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725979AbgH1QCN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Aug 2020 12:02:13 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35962 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728295AbgH1QCK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Aug 2020 12:02:10 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07SFs8oA155499
        for <linux-xfs@vger.kernel.org>; Fri, 28 Aug 2020 16:02:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=8XD1bLvdNgi67Cox8Q1TcFTK/EPnj9g0C6xo5qYyqvs=;
 b=unmg91qrz0pdyyUP3X76M5mEYborA859y2SiyUByo83MFb6MBGDdOkfFZ+wqFTbpTrvi
 aId+HLrPqHTT//Gj6Bs8oNdNvvS6I18CzTWGCf8ewBpKj4BUVRMTPjk9zwI0crZElrRc
 Sjg9UO/gFpNNzYJ4H5KW9Yr0WC2Vd9drqIKDpJacbSbULfMfQiGfxO3MicvN6hGC7xHg
 p22SNQc2ghqGgrRHMT9EumR4N3VsZ5yO6kWVva8WuUKriZYHG4pHI64johKdOtuCz5RG
 cLC3A18g7g0oCSsiAdwlw9POZiJfvdnNfqt9nV3qK0BBVpvnrfP/fXP508J45jGDxqKY 4Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 333dbscr9x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 28 Aug 2020 16:02:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07SFtFNH025378
        for <linux-xfs@vger.kernel.org>; Fri, 28 Aug 2020 16:02:09 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 333r9ptyej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 28 Aug 2020 16:02:08 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07SG28GA017959
        for <linux-xfs@vger.kernel.org>; Fri, 28 Aug 2020 16:02:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Aug 2020 09:02:08 -0700
Date:   Fri, 28 Aug 2020 09:02:07 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v12 8/8] xfs_io: Add delayed attributes error tag
Message-ID: <20200828160207.GY6096@magnolia>
References: <20200827003518.1231-1-allison.henderson@oracle.com>
 <20200827003518.1231-9-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200827003518.1231-9-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9727 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008280120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9727 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=1
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008280120
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 26, 2020 at 05:35:18PM -0700, Allison Collins wrote:
> This patch adds an error tag that we can use to test delayed attribute
> recovery and replay
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>

FWIW the subject line for this patch ought to start with 'xfs:', not
'xfs_io:'.

--D

> ---
>  fs/xfs/libxfs/xfs_errortag.h | 4 +++-
>  fs/xfs/xfs_attr_item.c       | 8 ++++++++
>  fs/xfs/xfs_error.c           | 3 +++
>  3 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> index 53b305d..cb38cbf 100644
> --- a/fs/xfs/libxfs/xfs_errortag.h
> +++ b/fs/xfs/libxfs/xfs_errortag.h
> @@ -56,7 +56,8 @@
>  #define XFS_ERRTAG_FORCE_SUMMARY_RECALC			33
>  #define XFS_ERRTAG_IUNLINK_FALLBACK			34
>  #define XFS_ERRTAG_BUF_IOERROR				35
> -#define XFS_ERRTAG_MAX					36
> +#define XFS_ERRTAG_DELAYED_ATTR				36
> +#define XFS_ERRTAG_MAX					37
>  
>  /*
>   * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> @@ -97,5 +98,6 @@
>  #define XFS_RANDOM_FORCE_SUMMARY_RECALC			1
>  #define XFS_RANDOM_IUNLINK_FALLBACK			(XFS_RANDOM_DEFAULT/10)
>  #define XFS_RANDOM_BUF_IOERROR				XFS_RANDOM_DEFAULT
> +#define XFS_RANDOM_DELAYED_ATTR				1
>  
>  #endif /* __XFS_ERRORTAG_H_ */
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 923c288..ed71003 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -35,6 +35,8 @@
>  #include "xfs_quota.h"
>  #include "xfs_log_priv.h"
>  #include "xfs_log_recover.h"
> +#include "xfs_error.h"
> +#include "xfs_errortag.h"
>  
>  static const struct xfs_item_ops xfs_attri_item_ops;
>  static const struct xfs_item_ops xfs_attrd_item_ops;
> @@ -310,6 +312,11 @@ xfs_trans_attr(
>  	if (error)
>  		return error;
>  
> +	if (XFS_TEST_ERROR(false, args->dp->i_mount, XFS_ERRTAG_DELAYED_ATTR)) {
> +		error = -EIO;
> +		goto out;
> +	}
> +
>  	switch (op_flags) {
>  	case XFS_ATTR_OP_FLAGS_SET:
>  		args->op_flags |= XFS_DA_OP_ADDNAME;
> @@ -324,6 +331,7 @@ xfs_trans_attr(
>  		break;
>  	}
>  
> +out:
>  	/*
>  	 * Mark the transaction dirty, even on error. This ensures the
>  	 * transaction is aborted, which:
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 7f6e208..fc551cb 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -54,6 +54,7 @@ static unsigned int xfs_errortag_random_default[] = {
>  	XFS_RANDOM_FORCE_SUMMARY_RECALC,
>  	XFS_RANDOM_IUNLINK_FALLBACK,
>  	XFS_RANDOM_BUF_IOERROR,
> +	XFS_RANDOM_DELAYED_ATTR,
>  };
>  
>  struct xfs_errortag_attr {
> @@ -164,6 +165,7 @@ XFS_ERRORTAG_ATTR_RW(force_repair,	XFS_ERRTAG_FORCE_SCRUB_REPAIR);
>  XFS_ERRORTAG_ATTR_RW(bad_summary,	XFS_ERRTAG_FORCE_SUMMARY_RECALC);
>  XFS_ERRORTAG_ATTR_RW(iunlink_fallback,	XFS_ERRTAG_IUNLINK_FALLBACK);
>  XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
> +XFS_ERRORTAG_ATTR_RW(delayed_attr,	XFS_ERRTAG_DELAYED_ATTR);
>  
>  static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(noerror),
> @@ -202,6 +204,7 @@ static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(bad_summary),
>  	XFS_ERRORTAG_ATTR_LIST(iunlink_fallback),
>  	XFS_ERRORTAG_ATTR_LIST(buf_ioerror),
> +	XFS_ERRORTAG_ATTR_LIST(delayed_attr),
>  	NULL,
>  };
>  
> -- 
> 2.7.4
> 
