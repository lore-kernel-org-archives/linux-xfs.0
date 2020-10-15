Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A555C433E7
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 17:12:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3132F22254
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 17:12:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WsMk7gQK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390205AbgJORMp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 13:12:45 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:42468 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390208AbgJORMo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 13:12:44 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09FH8bvZ193305;
        Thu, 15 Oct 2020 17:12:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=9h48zxhrk8n7aN+pFzcHA1ojfH6taaWrkBYr0YJUkOs=;
 b=WsMk7gQKDKRIoMFIrjkcCIihFf8oZnns3OO/u6nqRC7PaRKIVx7/e9peJdWZfk3gt3ri
 WWYFzbOCykW7rlay6UvQquoh/uN+Ye9keYfbZ6go41sUh7gGDJXbaljRKjdSI7axcSdQ
 dIE/2pXO1YmfdUq85FBrDw7YL4hc6R6n9oSGuYmQ3gZHf8Z4hdSEZQN9pcfbyRfT9DvN
 z1hEFIV9UZYaqPNL85FSuxQfidM+bOygm0sGittW86h077WioutLtGHK+1zUukiqDzUf
 jnwJ5v5cXRxvI2vn/96wDzNmAVb+/A1zIqpjIz2qSsc6In6WnUfonKai/9rYMFKRlYGW /g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 346g8gk2pu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Oct 2020 17:12:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09FHAeTW168071;
        Thu, 15 Oct 2020 17:12:41 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 343pw0nf8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Oct 2020 17:12:41 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09FHCej9000408;
        Thu, 15 Oct 2020 17:12:41 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 15 Oct 2020 10:12:40 -0700
Date:   Thu, 15 Oct 2020 10:12:39 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/27] xfsprogs: convert use-once buffer reads to
 uncached IO
Message-ID: <20201015171239.GV9832@magnolia>
References: <20201015072155.1631135-1-david@fromorbit.com>
 <20201015072155.1631135-13-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015072155.1631135-13-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9775 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 suspectscore=1 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010150114
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9775 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 suspectscore=1
 priorityscore=1501 phishscore=0 clxscore=1015 spamscore=0 adultscore=0
 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010150114
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 15, 2020 at 06:21:40PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  db/init.c     |  2 +-
>  libxfs/init.c | 93 ++++++++++++++++++++++++++++++---------------------
>  2 files changed, 55 insertions(+), 40 deletions(-)
> 
> diff --git a/db/init.c b/db/init.c
> index 19f0900a862b..f797df8a768b 100644
> --- a/db/init.c
> +++ b/db/init.c
> @@ -153,7 +153,7 @@ init(
>  	 */
>  	if (sbp->sb_rootino != NULLFSINO &&
>  	    xfs_sb_version_haslazysbcount(&mp->m_sb)) {
> -		int error = -libxfs_initialize_perag_data(mp, sbp->sb_agcount);
> +		error = -libxfs_initialize_perag_data(mp, sbp->sb_agcount);

Er... this and the xfs_check_sizes hoisting below don't have anything to
do with uncached io conversion...?

>  		if (error) {
>  			fprintf(stderr,
>  	_("%s: cannot init perag data (%d). Continuing anyway.\n"),
> diff --git a/libxfs/init.c b/libxfs/init.c
> index fe784940c299..fc30f92d6fb2 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -419,7 +419,7 @@ done:
>   */
>  static int
>  rtmount_init(
> -	xfs_mount_t	*mp,	/* file system mount structure */
> +	struct xfs_mount *mp,
>  	int		flags)
>  {
>  	struct xfs_buf	*bp;	/* buffer for last block of subvolume */
> @@ -473,8 +473,9 @@ rtmount_init(
>  			(unsigned long long) mp->m_sb.sb_rblocks);
>  		return -1;
>  	}
> -	error = libxfs_buf_read(mp->m_rtdev, d - XFS_FSB_TO_BB(mp, 1),
> -			XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
> +	error = libxfs_buf_read_uncached(mp->m_rtdev_targp,
> +					d - XFS_FSB_TO_BB(mp, 1),
> +					XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
>  	if (error) {
>  		fprintf(stderr, _("%s: realtime size check failed\n"),
>  			progname);
> @@ -657,6 +658,52 @@ libxfs_buftarg_init(
>  	mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, rtdev);
>  }
>  
> +/*
> + * Check that the data (and log if separate) is an ok size.
> + *
> + * XXX: copied from kernel, needs to be moved to shared code

Ah, because you want to share this function with the kernel.

Hmm... what do you think about putting it in libxfs/xfs_sb.c ?

--D

> + */
> +STATIC int
> +xfs_check_sizes(
> +        struct xfs_mount *mp)
> +{
> +	struct xfs_buf	*bp;
> +	xfs_daddr_t	d;
> +	int		error;
> +
> +	d = (xfs_daddr_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
> +	if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_dblocks) {
> +		xfs_warn(mp, "filesystem size mismatch detected");
> +		return -EFBIG;
> +	}
> +	error = libxfs_buf_read_uncached(mp->m_ddev_targp,
> +					d - XFS_FSS_TO_BB(mp, 1),
> +					XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
> +	if (error) {
> +		xfs_warn(mp, "last sector read failed");
> +		return error;
> +	}
> +	libxfs_buf_relse(bp);
> +
> +	if (mp->m_logdev_targp == mp->m_ddev_targp)
> +		return 0;
> +
> +	d = (xfs_daddr_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
> +	if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_logblocks) {
> +		xfs_warn(mp, "log size mismatch detected");
> +		return -EFBIG;
> +	}
> +	error = libxfs_buf_read_uncached(mp->m_logdev_targp,
> +					d - XFS_FSB_TO_BB(mp, 1),
> +					XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
> +	if (error) {
> +		xfs_warn(mp, "log device read failed");
> +		return error;
> +	}
> +	libxfs_buf_relse(bp);
> +	return 0;
> +}
> +
>  /*
>   * Mount structure initialization, provides a filled-in xfs_mount_t
>   * such that the numerous XFS_* macros can be used.  If dev is zero,
> @@ -673,7 +720,6 @@ libxfs_mount(
>  {
>  	struct xfs_buf		*bp;
>  	struct xfs_sb		*sbp;
> -	xfs_daddr_t		d;
>  	bool			debugger = (flags & LIBXFS_MOUNT_DEBUGGER);
>  	int			error;
>  
> @@ -704,16 +750,6 @@ libxfs_mount(
>  	xfs_rmapbt_compute_maxlevels(mp);
>  	xfs_refcountbt_compute_maxlevels(mp);
>  
> -	/*
> -	 * Check that the data (and log if separate) are an ok size.
> -	 */
> -	d = (xfs_daddr_t) XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
> -	if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_dblocks) {
> -		fprintf(stderr, _("%s: size check failed\n"), progname);
> -		if (!(flags & LIBXFS_MOUNT_DEBUGGER))
> -			return NULL;
> -	}
> -
>  	/*
>  	 * We automatically convert v1 inodes to v2 inodes now, so if
>  	 * the NLINK bit is not set we can't operate on the filesystem.
> @@ -755,30 +791,9 @@ libxfs_mount(
>  		return mp;
>  
>  	/* device size checks must pass unless we're a debugger. */
> -	error = libxfs_buf_read(mp->m_dev, d - XFS_FSS_TO_BB(mp, 1),
> -			XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
> -	if (error) {
> -		fprintf(stderr, _("%s: data size check failed\n"), progname);
> -		if (!debugger)
> -			return NULL;
> -	} else
> -		libxfs_buf_relse(bp);
> -
> -	if (mp->m_logdev_targp->bt_bdev &&
> -	    mp->m_logdev_targp->bt_bdev != mp->m_ddev_targp->bt_bdev) {
> -		d = (xfs_daddr_t) XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
> -		if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_logblocks ||
> -		    libxfs_buf_read(mp->m_logdev_targp,
> -				d - XFS_FSB_TO_BB(mp, 1), XFS_FSB_TO_BB(mp, 1),
> -				0, &bp, NULL)) {
> -			fprintf(stderr, _("%s: log size checks failed\n"),
> -					progname);
> -			if (!debugger)
> -				return NULL;
> -		}
> -		if (bp)
> -			libxfs_buf_relse(bp);
> -	}
> +	error = xfs_check_sizes(mp);
> +	if (error && !debugger)
> +		return NULL;
>  
>  	/* Initialize realtime fields in the mount structure */
>  	if (rtmount_init(mp, flags)) {
> @@ -795,7 +810,7 @@ libxfs_mount(
>  	 * read the first one and let the user know to check the geometry.
>  	 */
>  	if (sbp->sb_agcount > 1000000) {
> -		error = libxfs_buf_read(mp->m_dev,
> +		error = libxfs_buf_read_uncached(mp->m_ddev_targp,
>  				XFS_AG_DADDR(mp, sbp->sb_agcount - 1, 0), 1,
>  				0, &bp, NULL);
>  		if (error) {
> -- 
> 2.28.0
> 
