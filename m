Return-Path: <SRS0=guuR=DN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB473C4363D
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 04:26:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 840F520757
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 04:26:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Boge381w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgJFE0e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Oct 2020 00:26:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55364 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbgJFE0d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Oct 2020 00:26:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0964QUHs056525;
        Tue, 6 Oct 2020 04:26:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=8um8rPZcGEcpBbls336aQMBoD5miDmDPlilkGsvsIbk=;
 b=Boge381wYbaVQQMmLqLDbPBiClcGREFRVH/cxU7IjKdeE5iECOXd2caH6ikGQXHyFhDZ
 ZIbnw+VYbBTf4rBpsAa/lcHw/cs2c7Z9IFWaPZ9YXaMFF5vdmJP5EQc+a+8PmKOiILQP
 jM+aj8aDqfDFnJYCiXfGcOarFbWZ0PBhltHCsZHFkgk1l9VwIi5Cxap9pM9Et9cWd9py
 bzX6b297qB4OMTFJ+iavhhseDMrisVuXT6YUJm5Hgv1Yfj0wl9c/vgmInXVakQtFSB/b
 tCLlqdLZwCEKHRXF9C7Jx0OPYd8SxZjdhu37YH7Fe6o6kGifEwNvuBVcSZ+gdwul0Ffg QQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33xhxmsq2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 06 Oct 2020 04:26:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0964K6mC064218;
        Tue, 6 Oct 2020 04:24:30 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 33y37want6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Oct 2020 04:24:30 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0964OT6g006243;
        Tue, 6 Oct 2020 04:24:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 05 Oct 2020 21:24:29 -0700
Date:   Mon, 5 Oct 2020 21:24:26 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V5 10/12] xfs: Introduce error injection to reduce
 maximum inode fork extent count
Message-ID: <20201006042426.GP49547@magnolia>
References: <20201003055633.9379-1-chandanrlinux@gmail.com>
 <20201003055633.9379-11-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201003055633.9379-11-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 malwarescore=0 suspectscore=1 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=1 phishscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060025
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Oct 03, 2020 at 11:26:31AM +0530, Chandan Babu R wrote:
> This commit adds XFS_ERRTAG_REDUCE_MAX_IEXTENTS error tag which enables
> userspace programs to test "Inode fork extent count overflow detection"
> by reducing maximum possible inode fork extent count to 10.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Looks decent,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_errortag.h   | 4 +++-
>  fs/xfs/libxfs/xfs_inode_fork.c | 4 ++++
>  fs/xfs/xfs_error.c             | 3 +++
>  3 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> index 53b305dea381..1c56fcceeea6 100644
> --- a/fs/xfs/libxfs/xfs_errortag.h
> +++ b/fs/xfs/libxfs/xfs_errortag.h
> @@ -56,7 +56,8 @@
>  #define XFS_ERRTAG_FORCE_SUMMARY_RECALC			33
>  #define XFS_ERRTAG_IUNLINK_FALLBACK			34
>  #define XFS_ERRTAG_BUF_IOERROR				35
> -#define XFS_ERRTAG_MAX					36
> +#define XFS_ERRTAG_REDUCE_MAX_IEXTENTS			36
> +#define XFS_ERRTAG_MAX					37
>  
>  /*
>   * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> @@ -97,5 +98,6 @@
>  #define XFS_RANDOM_FORCE_SUMMARY_RECALC			1
>  #define XFS_RANDOM_IUNLINK_FALLBACK			(XFS_RANDOM_DEFAULT/10)
>  #define XFS_RANDOM_BUF_IOERROR				XFS_RANDOM_DEFAULT
> +#define XFS_RANDOM_REDUCE_MAX_IEXTENTS			1
>  
>  #endif /* __XFS_ERRORTAG_H_ */
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 8d48716547e5..e080d7e07643 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -24,6 +24,7 @@
>  #include "xfs_dir2_priv.h"
>  #include "xfs_attr_leaf.h"
>  #include "xfs_types.h"
> +#include "xfs_errortag.h"
>  
>  kmem_zone_t *xfs_ifork_zone;
>  
> @@ -745,6 +746,9 @@ xfs_iext_count_may_overflow(
>  
>  	max_exts = (whichfork == XFS_ATTR_FORK) ? MAXAEXTNUM : MAXEXTNUM;
>  
> +	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
> +		max_exts = 10;
> +
>  	nr_exts = ifp->if_nextents + nr_to_add;
>  	if (nr_exts < ifp->if_nextents || nr_exts > max_exts)
>  		return -EFBIG;
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 7f6e20899473..3780b118cc47 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -54,6 +54,7 @@ static unsigned int xfs_errortag_random_default[] = {
>  	XFS_RANDOM_FORCE_SUMMARY_RECALC,
>  	XFS_RANDOM_IUNLINK_FALLBACK,
>  	XFS_RANDOM_BUF_IOERROR,
> +	XFS_RANDOM_REDUCE_MAX_IEXTENTS,
>  };
>  
>  struct xfs_errortag_attr {
> @@ -164,6 +165,7 @@ XFS_ERRORTAG_ATTR_RW(force_repair,	XFS_ERRTAG_FORCE_SCRUB_REPAIR);
>  XFS_ERRORTAG_ATTR_RW(bad_summary,	XFS_ERRTAG_FORCE_SUMMARY_RECALC);
>  XFS_ERRORTAG_ATTR_RW(iunlink_fallback,	XFS_ERRTAG_IUNLINK_FALLBACK);
>  XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
> +XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
>  
>  static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(noerror),
> @@ -202,6 +204,7 @@ static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(bad_summary),
>  	XFS_ERRORTAG_ATTR_LIST(iunlink_fallback),
>  	XFS_ERRORTAG_ATTR_LIST(buf_ioerror),
> +	XFS_ERRORTAG_ATTR_LIST(reduce_max_iextents),
>  	NULL,
>  };
>  
> -- 
> 2.28.0
> 
