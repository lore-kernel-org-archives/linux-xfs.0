Return-Path: <SRS0=vvgS=W4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A28AC3A5A4
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Sep 2019 20:55:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E541C233A2
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Sep 2019 20:55:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lzwcjQHq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728942AbfIAUzR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 1 Sep 2019 16:55:17 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50520 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728941AbfIAUzR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 1 Sep 2019 16:55:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x81KsLxb148952;
        Sun, 1 Sep 2019 20:55:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=wf7gE3mKkRsc4VDdqYkGpk336cF5orVYmXTWfkwM9Ak=;
 b=lzwcjQHq5ob2nJeQApPDKXp+GL9rjK4rz1wDoTxq1U5viq1AGo88u9r128Hz3d8KUELT
 ldOtMj8AdwzLOuB8Uj5rhxUIhF9sm/7xqZo+Gsb2Y0fj0zQxZGHMKvKGM17m9y3bhcp3
 t9wKzE7gzBkgAYk5SOq0EZDnqCPtnmub5yFcAbaEKBVum3xUCWTNbBj/kv93cOO1HgmW
 ssi/HPatoOZNJ8ZGvXJlRqdnTRawErLgnlvjoedFfIlh1gQGlKLm5IXd8pNa2456Lx8+
 GPP28GEznX3dHN5Ji6T1PWjrV6w2Se4ygC5yQCKWgTu5lAs6p8FhmPkcsLcY+/ts7qy6 OA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2urne7r00q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 01 Sep 2019 20:55:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x81Ks9gw078533;
        Sun, 1 Sep 2019 20:55:14 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2uqg827qgw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 01 Sep 2019 20:55:14 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x81KtDc8012485;
        Sun, 1 Sep 2019 20:55:13 GMT
Received: from [192.168.1.9] (/67.1.183.122)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 01 Sep 2019 13:55:13 -0700
From:   Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 8/9] libfrog: create xfd_open function
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
References: <156713882070.386621.8501281965010809034.stgit@magnolia>
 <156713887587.386621.8656028056753211579.stgit@magnolia>
Message-ID: <98cd2e1b-17d9-617a-87f4-d5c46bf231ab@oracle.com>
Date:   Sun, 1 Sep 2019 13:55:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <156713887587.386621.8656028056753211579.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9367 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909010241
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9367 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909010241
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/29/19 9:21 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a helper to open a file and initialize the xfd structure.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fsr/xfs_fsr.c    |   26 ++++++--------------------
>   include/xfrog.h  |    1 +
>   libfrog/fsgeom.c |   22 ++++++++++++++++++++++
>   quota/quot.c     |    7 ++++---
>   scrub/phase1.c   |   25 ++++++++-----------------
>   5 files changed, 41 insertions(+), 40 deletions(-)
> 
> 
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index 36402252..e8d41aaf 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -592,18 +592,10 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
>   		return -1;
>   	}
>   
> -	if ((fsxfd.fd = open(mntdir, O_RDONLY)) < 0) {
> -		fsrprintf(_("unable to open: %s: %s\n"),
> -		          mntdir, strerror( errno ));
> -		free(fshandlep);
> -		return -1;
> -	}
> -
> -	ret = xfd_prepare_geometry(&fsxfd);
> +	ret = xfd_open(&fsxfd, mntdir, O_RDONLY);
>   	if (ret) {
> -		fsrprintf(_("Skipping %s: could not get XFS geometry\n"),
> -			  mntdir);
> -		xfd_close(&fsxfd);
> +		fsrprintf(_("unable to open XFS file: %s: %s\n"),
> +		          mntdir, strerror(ret));
>   		free(fshandlep);
>   		return -1;
>   	}
> @@ -725,16 +717,10 @@ fsrfile(
>   	 * Need to open something on the same filesystem as the
>   	 * file.  Open the parent.
>   	 */
> -	fsxfd.fd = open(getparent(fname), O_RDONLY);
> -	if (fsxfd.fd < 0) {
> -		fsrprintf(_("unable to open sys handle for %s: %s\n"),
> -			fname, strerror(errno));
> -		goto out;
> -	}
> -
> -	error = xfd_prepare_geometry(&fsxfd);
> +	error = xfd_open(&fsxfd, getparent(fname), O_RDONLY);
>   	if (error) {
> -		fsrprintf(_("Unable to get geom on fs for: %s\n"), fname);
> +		fsrprintf(_("unable to open sys handle for XFS file %s: %s\n"),
> +			fname, strerror(error));
>   		goto out;
>   	}
>   
> diff --git a/include/xfrog.h b/include/xfrog.h
> index 7bda9810..3a49acc3 100644
> --- a/include/xfrog.h
> +++ b/include/xfrog.h
> @@ -52,6 +52,7 @@ struct xfs_fd {
>   #define XFS_FD_INIT_EMPTY	XFS_FD_INIT(-1)
>   
>   int xfd_prepare_geometry(struct xfs_fd *xfd);
> +int xfd_open(struct xfs_fd *xfd, const char *pathname, int flags);
>   int xfd_close(struct xfs_fd *xfd);
>   
>   /* Convert AG number and AG inode number into fs inode number. */
> diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
> index cf9323c1..47644dc3 100644
> --- a/libfrog/fsgeom.c
> +++ b/libfrog/fsgeom.c
> @@ -117,6 +117,28 @@ xfd_prepare_geometry(
>   	return 0;
>   }
>   
> +/* Open a file on an XFS filesystem.  Returns zero or a positive error code. */
> +int
> +xfd_open(
> +	struct xfs_fd		*xfd,
> +	const char		*pathname,
> +	int			flags)
> +{
> +	int			ret;
> +
> +	xfd->fd = open(pathname, O_RDONLY);
> +	if (xfd->fd < 0)
> +		return errno;
> +
> +	ret = xfd_prepare_geometry(xfd);
> +	if (ret) {
> +		xfd_close(xfd);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
>   /*
>    * Release any resources associated with this xfs_fd structure.  Returns zero
>    * or a positive error code.
> diff --git a/quota/quot.c b/quota/quot.c
> index 1e970819..4614f684 100644
> --- a/quota/quot.c
> +++ b/quota/quot.c
> @@ -131,7 +131,7 @@ quot_bulkstat_mount(
>   	struct xfs_bstat	*buf;
>   	uint64_t		last = 0;
>   	uint32_t		count;
> -	int			i, sts;
> +	int			i, sts, ret;
>   	du_t			**dp;
>   
>   	/*
> @@ -146,8 +146,9 @@ quot_bulkstat_mount(
>   			*dp = NULL;
>   	ndu[0] = ndu[1] = ndu[2] = 0;
>   
> -	fsxfd.fd = open(fsdir, O_RDONLY);
> -	if (fsxfd.fd < 0) {
> +	ret = xfd_open(&fsxfd, fsdir, O_RDONLY);
> +	if (ret) {
> +		errno = ret;
>   		perror(fsdir);
>   		return;
>   	}
> diff --git a/scrub/phase1.c b/scrub/phase1.c
> index cbdbd010..15e67e37 100644
> --- a/scrub/phase1.c
> +++ b/scrub/phase1.c
> @@ -84,13 +84,17 @@ xfs_setup_fs(
>   	 * CAP_SYS_ADMIN, which we probably need to do anything fancy
>   	 * with the (XFS driver) kernel.
>   	 */
> -	ctx->mnt.fd = open(ctx->mntpoint, O_RDONLY | O_NOATIME | O_DIRECTORY);
> -	if (ctx->mnt.fd < 0) {
> -		if (errno == EPERM)
> +	error = xfd_open(&ctx->mnt, ctx->mntpoint,
> +			O_RDONLY | O_NOATIME | O_DIRECTORY);
> +	if (error) {
> +		if (error == EPERM)
>   			str_info(ctx, ctx->mntpoint,
>   _("Must be root to run scrub."));
> +		else if (error == ENOTTY)
> +			str_error(ctx, ctx->mntpoint,
> +_("Not an XFS filesystem."));
>   		else
> -			str_errno(ctx, ctx->mntpoint);
> +			str_liberror(ctx, error, ctx->mntpoint);
>   		return false;
>   	}
>   
> @@ -110,12 +114,6 @@ _("Must be root to run scrub."));
>   		return false;
>   	}
>   
> -	if (!platform_test_xfs_fd(ctx->mnt.fd)) {
> -		str_info(ctx, ctx->mntpoint,
> -_("Does not appear to be an XFS filesystem!"));
> -		return false;
> -	}
> -
>   	/*
>   	 * Flush everything out to disk before we start checking.
>   	 * This seems to reduce the incidence of stale file handle
> @@ -127,13 +125,6 @@ _("Does not appear to be an XFS filesystem!"));
>   		return false;
>   	}
>   
> -	/* Retrieve XFS geometry. */
> -	error = xfd_prepare_geometry(&ctx->mnt);
> -	if (error) {
> -		str_liberror(ctx, error, _("Retrieving XFS geometry"));
> -		return false;
> -	}
> -
>   	if (!xfs_action_lists_alloc(ctx->mnt.fsgeom.agcount,
>   				&ctx->action_lists)) {
>   		str_error(ctx, ctx->mntpoint, _("Not enough memory."));
> 
