Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:57760 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726966AbfHLQvw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 12:51:52 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CGmiml167750
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:51:51 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2u9nbt8whw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:51:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CGmgWn118453
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:51:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2u9k1vdrce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:51:50 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7CGpodJ022530
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:51:50 GMT
Date: Mon, 12 Aug 2019 09:51:49 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 18/18] xfs: Add delayed attributes error tag
Message-ID: <20190812165149.GH7138@magnolia>
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190809213726.32336-19-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809213726.32336-19-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Collins <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Aug 09, 2019 at 02:37:26PM -0700, Allison Collins wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> This patch adds an error tag that we can use to test
> delayed attribute recovery and replay
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_errortag.h | 4 +++-
>  fs/xfs/xfs_attr_item.c       | 8 ++++++++
>  fs/xfs/xfs_error.c           | 3 +++
>  3 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> index 79e6c4f..85d5850 100644
> --- a/fs/xfs/libxfs/xfs_errortag.h
> +++ b/fs/xfs/libxfs/xfs_errortag.h
> @@ -55,7 +55,8 @@
>  #define XFS_ERRTAG_FORCE_SCRUB_REPAIR			32
>  #define XFS_ERRTAG_FORCE_SUMMARY_RECALC			33
>  #define XFS_ERRTAG_IUNLINK_FALLBACK			34
> -#define XFS_ERRTAG_MAX					35
> +#define XFS_ERRTAG_DELAYED_ATTR				35
> +#define XFS_ERRTAG_MAX					36
>  
>  /*
>   * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> @@ -95,5 +96,6 @@
>  #define XFS_RANDOM_FORCE_SCRUB_REPAIR			1
>  #define XFS_RANDOM_FORCE_SUMMARY_RECALC			1
>  #define XFS_RANDOM_IUNLINK_FALLBACK			(XFS_RANDOM_DEFAULT/10)
> +#define XFS_RANDOM_DELAYED_ATTR				1
>  
>  #endif /* __XFS_ERRORTAG_H_ */
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 6693880..045d23a 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -33,6 +33,8 @@
>  #include "libxfs/xfs_da_format.h"
>  #include "xfs_inode.h"
>  #include "xfs_quota.h"
> +#include "xfs_error.h"
> +#include "xfs_errortag.h"
>  
>  
>  /*
> @@ -74,6 +76,11 @@ xfs_trans_attr(
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
> @@ -87,6 +94,7 @@ xfs_trans_attr(
>  		error = -EFSCORRUPTED;
>  	}
>  
> +out:
>  	/*
>  	 * Mark the transaction dirty, even on error. This ensures the
>  	 * transaction is aborted, which:
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 544c948..9b2de63 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -53,6 +53,7 @@ static unsigned int xfs_errortag_random_default[] = {
>  	XFS_RANDOM_FORCE_SCRUB_REPAIR,
>  	XFS_RANDOM_FORCE_SUMMARY_RECALC,
>  	XFS_RANDOM_IUNLINK_FALLBACK,
> +	XFS_RANDOM_DELAYED_ATTR,
>  };
>  
>  struct xfs_errortag_attr {
> @@ -162,6 +163,7 @@ XFS_ERRORTAG_ATTR_RW(buf_lru_ref,	XFS_ERRTAG_BUF_LRU_REF);
>  XFS_ERRORTAG_ATTR_RW(force_repair,	XFS_ERRTAG_FORCE_SCRUB_REPAIR);
>  XFS_ERRORTAG_ATTR_RW(bad_summary,	XFS_ERRTAG_FORCE_SUMMARY_RECALC);
>  XFS_ERRORTAG_ATTR_RW(iunlink_fallback,	XFS_ERRTAG_IUNLINK_FALLBACK);
> +XFS_ERRORTAG_ATTR_RW(delayed_attr,	XFS_ERRTAG_DELAYED_ATTR);
>  
>  static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(noerror),
> @@ -199,6 +201,7 @@ static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(force_repair),
>  	XFS_ERRORTAG_ATTR_LIST(bad_summary),
>  	XFS_ERRORTAG_ATTR_LIST(iunlink_fallback),
> +	XFS_ERRORTAG_ATTR_LIST(delayed_attr),
>  	NULL,
>  };
>  
> -- 
> 2.7.4
> 
