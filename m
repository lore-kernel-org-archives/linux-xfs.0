Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49022 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753328AbeBLUw2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Feb 2018 15:52:28 -0500
Subject: Re: [PATCH 4/7] xfs_scrub: reclassify runtime errors
References: <151787293446.3743.11110014829952400444.stgit@magnolia>
 <151787295918.3743.2659991069709220643.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <edf80281-7d01-4742-e390-cf1306a7d518@sandeen.net>
Date: Mon, 12 Feb 2018 14:52:27 -0600
MIME-Version: 1.0
In-Reply-To: <151787295918.3743.2659991069709220643.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org



On 2/5/18 5:22 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If the program encounters runtime errors, these should be noted as
> information.  Because these errors abort the execution flow (which is
> counted as a runtime error), we need only call str_info to log the
> event.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Ok.  Again I wonder if eventually str_error should turn into
scrub_log_fs_corruption() and str_info into scrub_log_runtime_error()
or something...

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  scrub/fscounters.c  |    4 ++--
>  scrub/inodes.c      |    4 ++--
>  scrub/phase1.c      |    8 ++++----
>  scrub/phase2.c      |    6 +++---
>  scrub/phase3.c      |    2 +-
>  scrub/phase6.c      |    2 +-
>  scrub/read_verify.c |    2 +-
>  scrub/scrub.c       |    8 ++++----
>  scrub/spacemap.c    |    8 ++++----
>  scrub/vfs.c         |    6 +++---
>  10 files changed, 25 insertions(+), 25 deletions(-)
> 
> 
> diff --git a/scrub/fscounters.c b/scrub/fscounters.c
> index 4294bf3..ecdf4c6 100644
> --- a/scrub/fscounters.c
> +++ b/scrub/fscounters.c
> @@ -139,14 +139,14 @@ xfs_count_all_inodes(
>  			scrub_nproc_workqueue(ctx));
>  	if (ret) {
>  		moveon = false;
> -		str_error(ctx, ctx->mntpoint, _("Could not create workqueue."));
> +		str_info(ctx, ctx->mntpoint, _("Could not create workqueue."));
>  		goto out_free;
>  	}
>  	for (agno = 0; agno < ctx->geo.agcount; agno++) {
>  		ret = workqueue_add(&wq, xfs_count_ag_inodes, agno, ci);
>  		if (ret) {
>  			moveon = false;
> -			str_error(ctx, ctx->mntpoint,
> +			str_info(ctx, ctx->mntpoint,
>  _("Could not queue AG %u icount work."), agno);
>  			break;
>  		}
> diff --git a/scrub/inodes.c b/scrub/inodes.c
> index 23ec704..57b773e 100644
> --- a/scrub/inodes.c
> +++ b/scrub/inodes.c
> @@ -266,7 +266,7 @@ xfs_scan_all_inodes(
>  	ret = workqueue_create(&wq, (struct xfs_mount *)ctx,
>  			scrub_nproc_workqueue(ctx));
>  	if (ret) {
> -		str_error(ctx, ctx->mntpoint, _("Could not create workqueue."));
> +		str_info(ctx, ctx->mntpoint, _("Could not create workqueue."));
>  		return false;
>  	}
>  
> @@ -274,7 +274,7 @@ xfs_scan_all_inodes(
>  		ret = workqueue_add(&wq, xfs_scan_ag_inodes, agno, &si);
>  		if (ret) {
>  			si.moveon = false;
> -			str_error(ctx, ctx->mntpoint,
> +			str_info(ctx, ctx->mntpoint,
>  _("Could not queue AG %u bulkstat work."), agno);
>  			break;
>  		}
> diff --git a/scrub/phase1.c b/scrub/phase1.c
> index 82c8022..6cd5442 100644
> --- a/scrub/phase1.c
> +++ b/scrub/phase1.c
> @@ -134,7 +134,7 @@ _("Must be root to run scrub."));
>  	}
>  
>  	if (!platform_test_xfs_fd(ctx->mnt_fd)) {
> -		str_error(ctx, ctx->mntpoint,
> +		str_info(ctx, ctx->mntpoint,
>  _("Does not appear to be an XFS filesystem!"));
>  		return false;
>  	}
> @@ -191,7 +191,7 @@ _("Kernel metadata repair facility is not available.  Use -n to scrub."));
>  	errno = 0;
>  	fsp = fs_table_lookup(ctx->mntpoint, FS_MOUNT_POINT);
>  	if (!fsp) {
> -		str_error(ctx, ctx->mntpoint,
> +		str_info(ctx, ctx->mntpoint,
>  _("Unable to find XFS information."));
>  		return false;
>  	}
> @@ -199,12 +199,12 @@ _("Unable to find XFS information."));
>  
>  	/* Did we find the log and rt devices, if they're present? */
>  	if (ctx->geo.logstart == 0 && ctx->fsinfo.fs_log == NULL) {
> -		str_error(ctx, ctx->mntpoint,
> +		str_info(ctx, ctx->mntpoint,
>  _("Unable to find log device path."));
>  		return false;
>  	}
>  	if (ctx->geo.rtblocks && ctx->fsinfo.fs_rt == NULL) {
> -		str_error(ctx, ctx->mntpoint,
> +		str_info(ctx, ctx->mntpoint,
>  _("Unable to find realtime device path."));
>  		return false;
>  	}
> diff --git a/scrub/phase2.c b/scrub/phase2.c
> index 32e2752..edf66df 100644
> --- a/scrub/phase2.c
> +++ b/scrub/phase2.c
> @@ -94,7 +94,7 @@ xfs_scan_metadata(
>  	ret = workqueue_create(&wq, (struct xfs_mount *)ctx,
>  			scrub_nproc_workqueue(ctx));
>  	if (ret) {
> -		str_error(ctx, ctx->mntpoint, _("Could not create workqueue."));
> +		str_info(ctx, ctx->mntpoint, _("Could not create workqueue."));
>  		return false;
>  	}
>  
> @@ -111,7 +111,7 @@ xfs_scan_metadata(
>  		ret = workqueue_add(&wq, xfs_scan_ag_metadata, agno, &moveon);
>  		if (ret) {
>  			moveon = false;
> -			str_error(ctx, ctx->mntpoint,
> +			str_info(ctx, ctx->mntpoint,
>  _("Could not queue AG %u scrub work."), agno);
>  			goto out;
>  		}
> @@ -123,7 +123,7 @@ _("Could not queue AG %u scrub work."), agno);
>  	ret = workqueue_add(&wq, xfs_scan_fs_metadata, 0, &moveon);
>  	if (ret) {
>  		moveon = false;
> -		str_error(ctx, ctx->mntpoint,
> +		str_info(ctx, ctx->mntpoint,
>  _("Could not queue filesystem scrub work."));
>  		goto out;
>  	}
> diff --git a/scrub/phase3.c b/scrub/phase3.c
> index f4117b0..a0ee5d9 100644
> --- a/scrub/phase3.c
> +++ b/scrub/phase3.c
> @@ -137,7 +137,7 @@ xfs_scan_inodes(
>  	ictx.moveon = true;
>  	ictx.icount = ptcounter_init(scrub_nproc(ctx));
>  	if (!ictx.icount) {
> -		str_error(ctx, ctx->mntpoint, _("Could not create counter."));
> +		str_info(ctx, ctx->mntpoint, _("Could not create counter."));
>  		return false;
>  	}
>  
> diff --git a/scrub/phase6.c b/scrub/phase6.c
> index 9795bf3..f985950 100644
> --- a/scrub/phase6.c
> +++ b/scrub/phase6.c
> @@ -485,7 +485,7 @@ xfs_scan_blocks(
>  			xfs_check_rmap_ioerr, disk_heads(ctx->datadev));
>  	if (!ve.readverify) {
>  		moveon = false;
> -		str_error(ctx, ctx->mntpoint,
> +		str_info(ctx, ctx->mntpoint,
>  _("Could not create media verifier."));
>  		goto out_rbad;
>  	}
> diff --git a/scrub/read_verify.c b/scrub/read_verify.c
> index e816688..ae2e85f 100644
> --- a/scrub/read_verify.c
> +++ b/scrub/read_verify.c
> @@ -187,7 +187,7 @@ read_verify_queue(
>  
>  	ret = workqueue_add(&rvp->wq, read_verify, 0, tmp);
>  	if (ret) {
> -		str_error(rvp->ctx, rvp->ctx->mntpoint,
> +		str_info(rvp->ctx, rvp->ctx->mntpoint,
>  _("Could not queue read-verify work."));
>  		free(tmp);
>  		return false;
> diff --git a/scrub/scrub.c b/scrub/scrub.c
> index bc0e2f0..ff5357c 100644
> --- a/scrub/scrub.c
> +++ b/scrub/scrub.c
> @@ -219,7 +219,7 @@ xfs_check_metadata(
>  			return CHECK_DONE;
>  		case ESHUTDOWN:
>  			/* FS already crashed, give up. */
> -			str_error(ctx, buf,
> +			str_info(ctx, buf,
>  _("Filesystem is shut down, aborting."));
>  			return CHECK_ABORT;
>  		case EIO:
> @@ -235,7 +235,7 @@ _("Filesystem is shut down, aborting."));
>  			 * The first two should never escape the kernel,
>  			 * and the other two should be reported via sm_flags.
>  			 */
> -			str_error(ctx, buf,
> +			str_info(ctx, buf,
>  _("Kernel bug!  errno=%d"), code);
>  			/* fall through */
>  		default:
> @@ -568,7 +568,7 @@ __xfs_scrub_test(
>  	if (debug_tweak_on("XFS_SCRUB_NO_KERNEL"))
>  		return false;
>  	if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR") && !injected) {
> -		str_error(ctx, "XFS_SCRUB_FORCE_REPAIR", "Not supported.");
> +		str_info(ctx, "XFS_SCRUB_FORCE_REPAIR", "Not supported.");
>  		return false;
>  	}
>  
> @@ -726,7 +726,7 @@ _("Filesystem is busy, deferring repair."));
>  			return CHECK_RETRY;
>  		case ESHUTDOWN:
>  			/* Filesystem is already shut down, abort. */
> -			str_error(ctx, buf,
> +			str_info(ctx, buf,
>  _("Filesystem is shut down, aborting."));
>  			return CHECK_ABORT;
>  		case ENOTTY:
> diff --git a/scrub/spacemap.c b/scrub/spacemap.c
> index 2dc6e2b..f631913 100644
> --- a/scrub/spacemap.c
> +++ b/scrub/spacemap.c
> @@ -217,7 +217,7 @@ xfs_scan_all_spacemaps(
>  	ret = workqueue_create(&wq, (struct xfs_mount *)ctx,
>  			scrub_nproc_workqueue(ctx));
>  	if (ret) {
> -		str_error(ctx, ctx->mntpoint, _("Could not create workqueue."));
> +		str_info(ctx, ctx->mntpoint, _("Could not create workqueue."));
>  		return false;
>  	}
>  	if (ctx->fsinfo.fs_rt) {
> @@ -225,7 +225,7 @@ xfs_scan_all_spacemaps(
>  				ctx->geo.agcount + 1, &sbx);
>  		if (ret) {
>  			sbx.moveon = false;
> -			str_error(ctx, ctx->mntpoint,
> +			str_info(ctx, ctx->mntpoint,
>  _("Could not queue rtdev fsmap work."));
>  			goto out;
>  		}
> @@ -235,7 +235,7 @@ _("Could not queue rtdev fsmap work."));
>  				ctx->geo.agcount + 2, &sbx);
>  		if (ret) {
>  			sbx.moveon = false;
> -			str_error(ctx, ctx->mntpoint,
> +			str_info(ctx, ctx->mntpoint,
>  _("Could not queue logdev fsmap work."));
>  			goto out;
>  		}
> @@ -244,7 +244,7 @@ _("Could not queue logdev fsmap work."));
>  		ret = workqueue_add(&wq, xfs_scan_ag_blocks, agno, &sbx);
>  		if (ret) {
>  			sbx.moveon = false;
> -			str_error(ctx, ctx->mntpoint,
> +			str_info(ctx, ctx->mntpoint,
>  _("Could not queue AG %u fsmap work."), agno);
>  			break;
>  		}
> diff --git a/scrub/vfs.c b/scrub/vfs.c
> index 573a2d0..0c5b353 100644
> --- a/scrub/vfs.c
> +++ b/scrub/vfs.c
> @@ -145,7 +145,7 @@ scan_fs_dir(
>  			pthread_mutex_unlock(&sft->lock);
>  			error = workqueue_add(wq, scan_fs_dir, 0, new_sftd);
>  			if (error) {
> -				str_error(ctx, ctx->mntpoint,
> +				str_info(ctx, ctx->mntpoint,
>  _("Could not queue subdirectory scan work."));
>  				sft->moveon = false;
>  				break;
> @@ -203,12 +203,12 @@ scan_fs_tree(
>  	ret = workqueue_create(&wq, (struct xfs_mount *)ctx,
>  			scrub_nproc_workqueue(ctx));
>  	if (ret) {
> -		str_error(ctx, ctx->mntpoint, _("Could not create workqueue."));
> +		str_info(ctx, ctx->mntpoint, _("Could not create workqueue."));
>  		goto out_free;
>  	}
>  	ret = workqueue_add(&wq, scan_fs_dir, 0, sftd);
>  	if (ret) {
> -		str_error(ctx, ctx->mntpoint,
> +		str_info(ctx, ctx->mntpoint,
>  _("Could not queue directory scan work."));
>  		goto out_free;
>  	}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
