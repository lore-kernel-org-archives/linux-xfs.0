Return-Path: <SRS0=Dhh5=63=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEFFBC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 15:27:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 089BC20809
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 15:27:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ET8JGosz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729573AbgEMP1q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 May 2020 11:27:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35598 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729257AbgEMP1p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 May 2020 11:27:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04DFH75K029519;
        Wed, 13 May 2020 15:27:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=e8K69gt4wLfsQ9g/RyCwRvIs0cRJ5SzYyF5mnmlY8EU=;
 b=ET8JGoszwyaqomfo3GEB5wyPvFfWiM1yJCACdCCiL/0JSOhjQGGWrdZhxjjJxu4U4khT
 KV2IkGn8uHkOPWNyuDBb5zJ2W5pdopoEjhi8jZ9KC8Bxkq2SaWyQoHK67H+0R9c4S99g
 i76ZfUXHnnOm/sYlap2L1R2yh9xOAgLoT5cW6nS26k4HH96VEzbABqNnN1pSKk/wUcLs
 bFOyW705wT07ogaZhSl0aS/BWLR1DnxTkdph5BdrYjwoe7EiGhQkAbRatrHEvH/j2xsq
 xiHo0VuU0/WREj+8Rm/+AYwp5Y7qW/AENkd1XqrpJBcZmkoWL9ApkF8slcrTvr/8TAba 0w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 3100xwmwg0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 13 May 2020 15:27:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04DFHvVu096281;
        Wed, 13 May 2020 15:27:33 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 3100yaqvmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 May 2020 15:27:33 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04DFRWSI030846;
        Wed, 13 May 2020 15:27:32 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 May 2020 08:27:31 -0700
Date:   Wed, 13 May 2020 08:27:31 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] scrub: remove xfs_ prefixes from various function
Message-ID: <20200513152731.GW6714@magnolia>
References: <20200513140333.2479519-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513140333.2479519-1-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9620 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=5 mlxscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005130137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9620 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 cotscore=-2147483648 bulkscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 spamscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 suspectscore=5 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005130137
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 13, 2020 at 04:03:32PM +0200, Christoph Hellwig wrote:
> Don't prefix tool private functions.  We'll use the xfs_* namespace for
> the shared libxfs functions soon, and want to be able to easily verify
> that the callers handle return negative errors for them.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  scrub/common.c    |   2 +-
>  scrub/common.h    |   2 +-
>  scrub/filemap.c   |   2 +-
>  scrub/inodes.c    |   2 +-
>  scrub/phase1.c    |   8 ++--
>  scrub/phase2.c    |   8 ++--
>  scrub/phase3.c    |  18 ++++----
>  scrub/phase4.c    |   2 +-
>  scrub/phase5.c    |   2 +-
>  scrub/phase7.c    |   2 +-
>  scrub/repair.c    |   2 +-
>  scrub/scrub.c     | 106 +++++++++++++++++++++++-----------------------
>  scrub/scrub.h     |  42 +++++++++---------
>  scrub/spacemap.c  |   2 +-
>  scrub/vfs.c       |   2 +-
>  scrub/xfs_scrub.c |   4 +-
>  16 files changed, 103 insertions(+), 103 deletions(-)
> 
> diff --git a/scrub/common.c b/scrub/common.c
> index 29d08f3e..c4699b6a 100644
> --- a/scrub/common.c
> +++ b/scrub/common.c
> @@ -30,7 +30,7 @@ extern char		*progname;
>  
>  /* Too many errors? Bail out. */
>  bool
> -xfs_scrub_excessive_errors(
> +scrub_excessive_errors(
>  	struct scrub_ctx	*ctx)
>  {
>  	unsigned long long	errors_seen;
> diff --git a/scrub/common.h b/scrub/common.h
> index cfd9f186..13b5f309 100644
> --- a/scrub/common.h
> +++ b/scrub/common.h
> @@ -13,7 +13,7 @@
>   */
>  #define DESCR_BUFSZ	256
>  
> -bool xfs_scrub_excessive_errors(struct scrub_ctx *ctx);
> +bool scrub_excessive_errors(struct scrub_ctx *ctx);
>  
>  enum error_level {
>  	S_ERROR	= 0,
> diff --git a/scrub/filemap.c b/scrub/filemap.c
> index bad2e9e1..0b914ef6 100644
> --- a/scrub/filemap.c
> +++ b/scrub/filemap.c
> @@ -93,7 +93,7 @@ scrub_iterate_filemaps(
>  			ret = fn(ctx, fd, whichfork, &fsx, &bmap, arg);
>  			if (ret)
>  				goto out;
> -			if (xfs_scrub_excessive_errors(ctx))
> +			if (scrub_excessive_errors(ctx))
>  				goto out;
>  		}
>  
> diff --git a/scrub/inodes.c b/scrub/inodes.c
> index 099489d8..5ef752fe 100644
> --- a/scrub/inodes.c
> +++ b/scrub/inodes.c
> @@ -193,7 +193,7 @@ _("Changed too many times during scan; giving up."));
>  			default:
>  				goto err;
>  			}
> -			if (xfs_scrub_excessive_errors(ctx)) {
> +			if (scrub_excessive_errors(ctx)) {
>  				si->aborted = true;
>  				goto out;
>  			}
> diff --git a/scrub/phase1.c b/scrub/phase1.c
> index 6125d324..4f028249 100644
> --- a/scrub/phase1.c
> +++ b/scrub/phase1.c
> @@ -140,10 +140,10 @@ _("Not an XFS filesystem."));
>  	}
>  
>  	/* Do we have kernel-assisted metadata scrubbing? */
> -	if (!xfs_can_scrub_fs_metadata(ctx) || !xfs_can_scrub_inode(ctx) ||
> -	    !xfs_can_scrub_bmap(ctx) || !xfs_can_scrub_dir(ctx) ||
> -	    !xfs_can_scrub_attr(ctx) || !xfs_can_scrub_symlink(ctx) ||
> -	    !xfs_can_scrub_parent(ctx)) {
> +	if (!can_scrub_fs_metadata(ctx) || !can_scrub_inode(ctx) ||
> +	    !can_scrub_bmap(ctx) || !can_scrub_dir(ctx) ||
> +	    !can_scrub_attr(ctx) || !can_scrub_symlink(ctx) ||
> +	    !can_scrub_parent(ctx)) {
>  		str_error(ctx, ctx->mntpoint,
>  _("Kernel metadata scrubbing facility is not available."));
>  		return ECANCELED;
> diff --git a/scrub/phase2.c b/scrub/phase2.c
> index c40d9d3b..8f82e2a6 100644
> --- a/scrub/phase2.c
> +++ b/scrub/phase2.c
> @@ -44,7 +44,7 @@ scan_ag_metadata(
>  	 * First we scrub and fix the AG headers, because we need
>  	 * them to work well enough to check the AG btrees.
>  	 */
> -	ret = xfs_scrub_ag_headers(ctx, agno, &alist);
> +	ret = scrub_ag_headers(ctx, agno, &alist);
>  	if (ret)
>  		goto err;
>  
> @@ -54,7 +54,7 @@ scan_ag_metadata(
>  		goto err;
>  
>  	/* Now scrub the AG btrees. */
> -	ret = xfs_scrub_ag_metadata(ctx, agno, &alist);
> +	ret = scrub_ag_metadata(ctx, agno, &alist);
>  	if (ret)
>  		goto err;
>  
> @@ -108,7 +108,7 @@ scan_fs_metadata(
>  		return;
>  
>  	action_list_init(&alist);
> -	ret = xfs_scrub_fs_metadata(ctx, &alist);
> +	ret = scrub_fs_metadata(ctx, &alist);
>  	if (ret) {
>  		*aborted = true;
>  		return;
> @@ -141,7 +141,7 @@ phase2_func(
>  	 * anything else.
>  	 */
>  	action_list_init(&alist);
> -	ret = xfs_scrub_primary_super(ctx, &alist);
> +	ret = scrub_primary_super(ctx, &alist);
>  	if (ret)
>  		goto out;
>  	ret = action_list_process_or_defer(ctx, 0, &alist);
> diff --git a/scrub/phase3.c b/scrub/phase3.c
> index 223f1caf..c7ce0ada 100644
> --- a/scrub/phase3.c
> +++ b/scrub/phase3.c
> @@ -84,7 +84,7 @@ scrub_inode(
>  	}
>  
>  	/* Scrub the inode. */
> -	error = scrub_fd(ctx, xfs_scrub_inode_fields, bstat, &alist);
> +	error = scrub_fd(ctx, scrub_inode_fields, bstat, &alist);
>  	if (error)
>  		goto out;
>  
> @@ -93,13 +93,13 @@ scrub_inode(
>  		goto out;
>  
>  	/* Scrub all block mappings. */
> -	error = scrub_fd(ctx, xfs_scrub_data_fork, bstat, &alist);
> +	error = scrub_fd(ctx, scrub_data_fork, bstat, &alist);
>  	if (error)
>  		goto out;
> -	error = scrub_fd(ctx, xfs_scrub_attr_fork, bstat, &alist);
> +	error = scrub_fd(ctx, scrub_attr_fork, bstat, &alist);
>  	if (error)
>  		goto out;
> -	error = scrub_fd(ctx, xfs_scrub_cow_fork, bstat, &alist);
> +	error = scrub_fd(ctx, scrub_cow_fork, bstat, &alist);
>  	if (error)
>  		goto out;
>  
> @@ -109,22 +109,22 @@ scrub_inode(
>  
>  	if (S_ISLNK(bstat->bs_mode)) {
>  		/* Check symlink contents. */
> -		error = xfs_scrub_symlink(ctx, bstat->bs_ino, bstat->bs_gen,
> +		error = scrub_symlink(ctx, bstat->bs_ino, bstat->bs_gen,
>  				&alist);
>  	} else if (S_ISDIR(bstat->bs_mode)) {
>  		/* Check the directory entries. */
> -		error = scrub_fd(ctx, xfs_scrub_dir, bstat, &alist);
> +		error = scrub_fd(ctx, scrub_dir, bstat, &alist);
>  	}
>  	if (error)
>  		goto out;
>  
>  	/* Check all the extended attributes. */
> -	error = scrub_fd(ctx, xfs_scrub_attr, bstat, &alist);
> +	error = scrub_fd(ctx, scrub_attr, bstat, &alist);
>  	if (error)
>  		goto out;
>  
>  	/* Check parent pointers. */
> -	error = scrub_fd(ctx, xfs_scrub_parent, bstat, &alist);
> +	error = scrub_fd(ctx, scrub_parent, bstat, &alist);
>  	if (error)
>  		goto out;
>  
> @@ -181,7 +181,7 @@ phase3_func(
>  	if (err)
>  		goto free;
>  
> -	xfs_scrub_report_preen_triggers(ctx);
> +	scrub_report_preen_triggers(ctx);
>  	err = ptcounter_value(ictx.icount, &val);
>  	if (err) {
>  		str_liberror(ctx, err, _("summing scanned inode counter"));
> diff --git a/scrub/phase4.c b/scrub/phase4.c
> index af9b493e..6ed7210f 100644
> --- a/scrub/phase4.c
> +++ b/scrub/phase4.c
> @@ -119,7 +119,7 @@ phase4_func(
>  	 * counters, so counter repairs have to be put on the list now so that
>  	 * they get fixed before we stop retrying unfixed metadata repairs.
>  	 */
> -	ret = xfs_scrub_fs_summary(ctx, &ctx->action_lists[0]);
> +	ret = scrub_fs_summary(ctx, &ctx->action_lists[0]);
>  	if (ret)
>  		return ret;
>  
> diff --git a/scrub/phase5.c b/scrub/phase5.c
> index fcd5ba27..ee1e5d6c 100644
> --- a/scrub/phase5.c
> +++ b/scrub/phase5.c
> @@ -402,7 +402,7 @@ _("Filesystem has errors, skipping connectivity checks."));
>  	if (aborted)
>  		return ECANCELED;
>  
> -	xfs_scrub_report_preen_triggers(ctx);
> +	scrub_report_preen_triggers(ctx);
>  	return 0;
>  }
>  
> diff --git a/scrub/phase7.c b/scrub/phase7.c
> index 75cf088c..96876f7c 100644
> --- a/scrub/phase7.c
> +++ b/scrub/phase7.c
> @@ -119,7 +119,7 @@ phase7_func(
>  
>  	/* Check and fix the fs summary counters. */
>  	action_list_init(&alist);
> -	error = xfs_scrub_fs_summary(ctx, &alist);
> +	error = scrub_fs_summary(ctx, &alist);
>  	if (error)
>  		return error;
>  	error = action_list_process(ctx, ctx->mnt.fd, &alist,
> diff --git a/scrub/repair.c b/scrub/repair.c
> index 1604e252..2c1644c3 100644
> --- a/scrub/repair.c
> +++ b/scrub/repair.c
> @@ -258,7 +258,7 @@ action_list_process(
>  		}
>  	}
>  
> -	if (xfs_scrub_excessive_errors(ctx))
> +	if (scrub_excessive_errors(ctx))
>  		return ECANCELED;
>  	return 0;
>  }
> diff --git a/scrub/scrub.c b/scrub/scrub.c
> index 81a9ca85..aec2d5d5 100644
> --- a/scrub/scrub.c
> +++ b/scrub/scrub.c
> @@ -96,7 +96,7 @@ static inline bool needs_repair(struct xfs_scrub_metadata *sm)
>  
>  /* Warn about strange circumstances after scrub. */
>  static inline void
> -xfs_scrub_warn_incomplete_scrub(
> +scrub_warn_incomplete_scrub(
>  	struct scrub_ctx		*ctx,
>  	struct descr			*dsc,
>  	struct xfs_scrub_metadata	*meta)
> @@ -184,7 +184,7 @@ _("Filesystem is shut down, aborting."));
>  	}
>  
>  	/* Complain about incomplete or suspicious metadata. */
> -	xfs_scrub_warn_incomplete_scrub(ctx, &dsc, meta);
> +	scrub_warn_incomplete_scrub(ctx, &dsc, meta);
>  
>  	/*
>  	 * If we need repairs or there were discrepancies, schedule a
> @@ -229,7 +229,7 @@ _("Optimization is possible."));
>  
>  /* Bulk-notify user about things that could be optimized. */
>  void
> -xfs_scrub_report_preen_triggers(
> +scrub_report_preen_triggers(
>  	struct scrub_ctx		*ctx)
>  {
>  	int				i;
> @@ -249,7 +249,7 @@ _("Optimizations of %s are possible."), _(xfrog_scrubbers[i].descr));
>  
>  /* Save a scrub context for later repairs. */
>  static int
> -xfs_scrub_save_repair(
> +scrub_save_repair(
>  	struct scrub_ctx		*ctx,
>  	struct action_list		*alist,
>  	struct xfs_scrub_metadata	*meta)
> @@ -290,7 +290,7 @@ xfs_scrub_save_repair(
>   * return a positive error code.
>   */
>  static int
> -xfs_scrub_meta_type(
> +scrub_meta_type(
>  	struct scrub_ctx		*ctx,
>  	unsigned int			type,
>  	xfs_agnumber_t			agno,
> @@ -313,7 +313,7 @@ xfs_scrub_meta_type(
>  	case CHECK_ABORT:
>  		return ECANCELED;
>  	case CHECK_REPAIR:
> -		ret = xfs_scrub_save_repair(ctx, alist, &meta);
> +		ret = scrub_save_repair(ctx, alist, &meta);
>  		if (ret)
>  			return ret;
>  		/* fall through */
> @@ -331,7 +331,7 @@ xfs_scrub_meta_type(
>   * XFROG_SCRUB_TYPE_INODE or for checking summary metadata.
>   */
>  static bool
> -xfs_scrub_all_types(
> +scrub_all_types(
>  	struct scrub_ctx		*ctx,
>  	enum xfrog_scrub_type		scrub_type,
>  	xfs_agnumber_t			agno,
> @@ -349,7 +349,7 @@ xfs_scrub_all_types(
>  		if (sc->flags & XFROG_SCRUB_DESCR_SUMMARY)
>  			continue;
>  
> -		ret = xfs_scrub_meta_type(ctx, type, agno, alist);
> +		ret = scrub_meta_type(ctx, type, agno, alist);
>  		if (ret)
>  			return ret;
>  	}
> @@ -364,49 +364,49 @@ xfs_scrub_all_types(
>   * return nonzero.
>   */
>  int
> -xfs_scrub_primary_super(
> +scrub_primary_super(
>  	struct scrub_ctx		*ctx,
>  	struct action_list		*alist)
>  {
> -	return xfs_scrub_meta_type(ctx, XFS_SCRUB_TYPE_SB, 0, alist);
> +	return scrub_meta_type(ctx, XFS_SCRUB_TYPE_SB, 0, alist);
>  }
>  
>  /* Scrub each AG's header blocks. */
>  int
> -xfs_scrub_ag_headers(
> +scrub_ag_headers(
>  	struct scrub_ctx		*ctx,
>  	xfs_agnumber_t			agno,
>  	struct action_list		*alist)
>  {
> -	return xfs_scrub_all_types(ctx, XFROG_SCRUB_TYPE_AGHEADER, agno, alist);
> +	return scrub_all_types(ctx, XFROG_SCRUB_TYPE_AGHEADER, agno, alist);
>  }
>  
>  /* Scrub each AG's metadata btrees. */
>  int
> -xfs_scrub_ag_metadata(
> +scrub_ag_metadata(
>  	struct scrub_ctx		*ctx,
>  	xfs_agnumber_t			agno,
>  	struct action_list		*alist)
>  {
> -	return xfs_scrub_all_types(ctx, XFROG_SCRUB_TYPE_PERAG, agno, alist);
> +	return scrub_all_types(ctx, XFROG_SCRUB_TYPE_PERAG, agno, alist);
>  }
>  
>  /* Scrub whole-FS metadata btrees. */
>  int
> -xfs_scrub_fs_metadata(
> +scrub_fs_metadata(
>  	struct scrub_ctx		*ctx,
>  	struct action_list		*alist)
>  {
> -	return xfs_scrub_all_types(ctx, XFROG_SCRUB_TYPE_FS, 0, alist);
> +	return scrub_all_types(ctx, XFROG_SCRUB_TYPE_FS, 0, alist);
>  }
>  
>  /* Scrub FS summary metadata. */
>  int
> -xfs_scrub_fs_summary(
> +scrub_fs_summary(
>  	struct scrub_ctx		*ctx,
>  	struct action_list		*alist)
>  {
> -	return xfs_scrub_meta_type(ctx, XFS_SCRUB_TYPE_FSCOUNTERS, 0, alist);
> +	return scrub_meta_type(ctx, XFS_SCRUB_TYPE_FSCOUNTERS, 0, alist);
>  }
>  
>  /* How many items do we have to check? */
> @@ -440,7 +440,7 @@ scrub_estimate_ag_work(
>   * return nonzero.
>   */
>  static int
> -__xfs_scrub_file(
> +__scrub_file(
>  	struct scrub_ctx		*ctx,
>  	uint64_t			ino,
>  	uint32_t			gen,
> @@ -464,87 +464,87 @@ __xfs_scrub_file(
>  	if (fix == CHECK_DONE)
>  		return 0;
>  
> -	return xfs_scrub_save_repair(ctx, alist, &meta);
> +	return scrub_save_repair(ctx, alist, &meta);
>  }
>  
>  int
> -xfs_scrub_inode_fields(
> +scrub_inode_fields(
>  	struct scrub_ctx	*ctx,
>  	uint64_t		ino,
>  	uint32_t		gen,
>  	struct action_list	*alist)
>  {
> -	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_INODE, alist);
> +	return __scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_INODE, alist);
>  }
>  
>  int
> -xfs_scrub_data_fork(
> +scrub_data_fork(
>  	struct scrub_ctx	*ctx,
>  	uint64_t		ino,
>  	uint32_t		gen,
>  	struct action_list	*alist)
>  {
> -	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_BMBTD, alist);
> +	return __scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_BMBTD, alist);
>  }
>  
>  int
> -xfs_scrub_attr_fork(
> +scrub_attr_fork(
>  	struct scrub_ctx	*ctx,
>  	uint64_t		ino,
>  	uint32_t		gen,
>  	struct action_list	*alist)
>  {
> -	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_BMBTA, alist);
> +	return __scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_BMBTA, alist);
>  }
>  
>  int
> -xfs_scrub_cow_fork(
> +scrub_cow_fork(
>  	struct scrub_ctx	*ctx,
>  	uint64_t		ino,
>  	uint32_t		gen,
>  	struct action_list	*alist)
>  {
> -	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_BMBTC, alist);
> +	return __scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_BMBTC, alist);
>  }
>  
>  int
> -xfs_scrub_dir(
> +scrub_dir(
>  	struct scrub_ctx	*ctx,
>  	uint64_t		ino,
>  	uint32_t		gen,
>  	struct action_list	*alist)
>  {
> -	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_DIR, alist);
> +	return __scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_DIR, alist);
>  }
>  
>  int
> -xfs_scrub_attr(
> +scrub_attr(
>  	struct scrub_ctx	*ctx,
>  	uint64_t		ino,
>  	uint32_t		gen,
>  	struct action_list	*alist)
>  {
> -	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_XATTR, alist);
> +	return __scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_XATTR, alist);
>  }
>  
>  int
> -xfs_scrub_symlink(
> +scrub_symlink(
>  	struct scrub_ctx	*ctx,
>  	uint64_t		ino,
>  	uint32_t		gen,
>  	struct action_list	*alist)
>  {
> -	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_SYMLINK, alist);
> +	return __scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_SYMLINK, alist);
>  }
>  
>  int
> -xfs_scrub_parent(
> +scrub_parent(
>  	struct scrub_ctx	*ctx,
>  	uint64_t		ino,
>  	uint32_t		gen,
>  	struct action_list	*alist)
>  {
> -	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_PARENT, alist);
> +	return __scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_PARENT, alist);
>  }
>  
>  /*
> @@ -553,7 +553,7 @@ xfs_scrub_parent(
>   * return false.
>   */
>  static bool
> -__xfs_scrub_test(
> +__scrub_test(
>  	struct scrub_ctx		*ctx,
>  	unsigned int			type,
>  	bool				repair)
> @@ -606,59 +606,59 @@ _("Kernel %s %s facility not detected."),
>  }
>  
>  bool
> -xfs_can_scrub_fs_metadata(
> +can_scrub_fs_metadata(
>  	struct scrub_ctx	*ctx)
>  {
> -	return __xfs_scrub_test(ctx, XFS_SCRUB_TYPE_PROBE, false);
> +	return __scrub_test(ctx, XFS_SCRUB_TYPE_PROBE, false);
>  }
>  
>  bool
> -xfs_can_scrub_inode(
> +can_scrub_inode(
>  	struct scrub_ctx	*ctx)
>  {
> -	return __xfs_scrub_test(ctx, XFS_SCRUB_TYPE_INODE, false);
> +	return __scrub_test(ctx, XFS_SCRUB_TYPE_INODE, false);
>  }
>  
>  bool
> -xfs_can_scrub_bmap(
> +can_scrub_bmap(
>  	struct scrub_ctx	*ctx)
>  {
> -	return __xfs_scrub_test(ctx, XFS_SCRUB_TYPE_BMBTD, false);
> +	return __scrub_test(ctx, XFS_SCRUB_TYPE_BMBTD, false);
>  }
>  
>  bool
> -xfs_can_scrub_dir(
> +can_scrub_dir(
>  	struct scrub_ctx	*ctx)
>  {
> -	return __xfs_scrub_test(ctx, XFS_SCRUB_TYPE_DIR, false);
> +	return __scrub_test(ctx, XFS_SCRUB_TYPE_DIR, false);
>  }
>  
>  bool
> -xfs_can_scrub_attr(
> +can_scrub_attr(
>  	struct scrub_ctx	*ctx)
>  {
> -	return __xfs_scrub_test(ctx, XFS_SCRUB_TYPE_XATTR, false);
> +	return __scrub_test(ctx, XFS_SCRUB_TYPE_XATTR, false);
>  }
>  
>  bool
> -xfs_can_scrub_symlink(
> +can_scrub_symlink(
>  	struct scrub_ctx	*ctx)
>  {
> -	return __xfs_scrub_test(ctx, XFS_SCRUB_TYPE_SYMLINK, false);
> +	return __scrub_test(ctx, XFS_SCRUB_TYPE_SYMLINK, false);
>  }
>  
>  bool
> -xfs_can_scrub_parent(
> +can_scrub_parent(
>  	struct scrub_ctx	*ctx)
>  {
> -	return __xfs_scrub_test(ctx, XFS_SCRUB_TYPE_PARENT, false);
> +	return __scrub_test(ctx, XFS_SCRUB_TYPE_PARENT, false);
>  }
>  
>  bool
>  xfs_can_repair(
>  	struct scrub_ctx	*ctx)
>  {
> -	return __xfs_scrub_test(ctx, XFS_SCRUB_TYPE_PROBE, true);
> +	return __scrub_test(ctx, XFS_SCRUB_TYPE_PROBE, true);
>  }
>  
>  /* General repair routines. */
> @@ -776,7 +776,7 @@ _("Read-only filesystem; cannot make changes."));
>  	}
>  
>  	if (repair_flags & XRM_COMPLAIN_IF_UNFIXED)
> -		xfs_scrub_warn_incomplete_scrub(ctx, &dsc, &meta);
> +		scrub_warn_incomplete_scrub(ctx, &dsc, &meta);
>  	if (needs_repair(&meta)) {
>  		/*
>  		 * Still broken; if we've been told not to complain then we
> diff --git a/scrub/scrub.h b/scrub/scrub.h
> index 161e694f..537a2ebe 100644
> --- a/scrub/scrub.h
> +++ b/scrub/scrub.h
> @@ -16,39 +16,39 @@ enum check_outcome {
>  
>  struct action_item;
>  
> -void xfs_scrub_report_preen_triggers(struct scrub_ctx *ctx);
> -int xfs_scrub_primary_super(struct scrub_ctx *ctx, struct action_list *alist);
> -int xfs_scrub_ag_headers(struct scrub_ctx *ctx, xfs_agnumber_t agno,
> +void scrub_report_preen_triggers(struct scrub_ctx *ctx);
> +int scrub_primary_super(struct scrub_ctx *ctx, struct action_list *alist);
> +int scrub_ag_headers(struct scrub_ctx *ctx, xfs_agnumber_t agno,
>  		struct action_list *alist);
> -int xfs_scrub_ag_metadata(struct scrub_ctx *ctx, xfs_agnumber_t agno,
> +int scrub_ag_metadata(struct scrub_ctx *ctx, xfs_agnumber_t agno,
>  		struct action_list *alist);
> -int xfs_scrub_fs_metadata(struct scrub_ctx *ctx, struct action_list *alist);
> -int xfs_scrub_fs_summary(struct scrub_ctx *ctx, struct action_list *alist);
> +int scrub_fs_metadata(struct scrub_ctx *ctx, struct action_list *alist);
> +int scrub_fs_summary(struct scrub_ctx *ctx, struct action_list *alist);
>  
> -bool xfs_can_scrub_fs_metadata(struct scrub_ctx *ctx);
> -bool xfs_can_scrub_inode(struct scrub_ctx *ctx);
> -bool xfs_can_scrub_bmap(struct scrub_ctx *ctx);
> -bool xfs_can_scrub_dir(struct scrub_ctx *ctx);
> -bool xfs_can_scrub_attr(struct scrub_ctx *ctx);
> -bool xfs_can_scrub_symlink(struct scrub_ctx *ctx);
> -bool xfs_can_scrub_parent(struct scrub_ctx *ctx);
> +bool can_scrub_fs_metadata(struct scrub_ctx *ctx);
> +bool can_scrub_inode(struct scrub_ctx *ctx);
> +bool can_scrub_bmap(struct scrub_ctx *ctx);
> +bool can_scrub_dir(struct scrub_ctx *ctx);
> +bool can_scrub_attr(struct scrub_ctx *ctx);
> +bool can_scrub_symlink(struct scrub_ctx *ctx);
> +bool can_scrub_parent(struct scrub_ctx *ctx);
>  bool xfs_can_repair(struct scrub_ctx *ctx);
>  
> -int xfs_scrub_inode_fields(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
> +int scrub_inode_fields(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
>  		struct action_list *alist);
> -int xfs_scrub_data_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
> +int scrub_data_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
>  		struct action_list *alist);
> -int xfs_scrub_attr_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
> +int scrub_attr_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
>  		struct action_list *alist);
> -int xfs_scrub_cow_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
> +int scrub_cow_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
>  		struct action_list *alist);
> -int xfs_scrub_dir(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
> +int scrub_dir(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
>  		struct action_list *alist);
> -int xfs_scrub_attr(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
> +int scrub_attr(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
>  		struct action_list *alist);
> -int xfs_scrub_symlink(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
> +int scrub_symlink(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
>  		struct action_list *alist);
> -int xfs_scrub_parent(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
> +int scrub_parent(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
>  		struct action_list *alist);
>  
>  /* Repair parameters are the scrub inputs and retry count. */
> diff --git a/scrub/spacemap.c b/scrub/spacemap.c
> index d427049f..9653916d 100644
> --- a/scrub/spacemap.c
> +++ b/scrub/spacemap.c
> @@ -62,7 +62,7 @@ scrub_iterate_fsmap(
>  			error = fn(ctx, p, arg);
>  			if (error)
>  				goto out;
> -			if (xfs_scrub_excessive_errors(ctx))
> +			if (scrub_excessive_errors(ctx))
>  				goto out;
>  		}
>  
> diff --git a/scrub/vfs.c b/scrub/vfs.c
> index 76920923..577eb6dc 100644
> --- a/scrub/vfs.c
> +++ b/scrub/vfs.c
> @@ -182,7 +182,7 @@ scan_fs_dir(
>  			break;
>  		}
>  
> -		if (xfs_scrub_excessive_errors(ctx)) {
> +		if (scrub_excessive_errors(ctx)) {
>  			sft->aborted = true;
>  			break;
>  		}
> diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
> index 33b876f2..1edeb150 100644
> --- a/scrub/xfs_scrub.c
> +++ b/scrub/xfs_scrub.c
> @@ -493,7 +493,7 @@ _("Scrub aborted after phase %d."),
>  			break;
>  
>  		/* Too many errors? */
> -		if (xfs_scrub_excessive_errors(ctx)) {
> +		if (scrub_excessive_errors(ctx)) {
>  			ret = ECANCELED;
>  			break;
>  		}
> @@ -761,7 +761,7 @@ main(
>  	 * We don't want every thread yelling that into the output, so check
>  	 * if we hit the threshold and tell the user *once*.
>  	 */
> -	if (xfs_scrub_excessive_errors(&ctx))
> +	if (scrub_excessive_errors(&ctx))
>  		str_info(&ctx, ctx.mntpoint, _("Too many errors; aborting."));
>  
>  	if (debug_tweak_on("XFS_SCRUB_FORCE_ERROR"))
> -- 
> 2.26.2
> 
