Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 278B8C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Jan 2022 02:10:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S3417651AbiAYCKa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jan 2022 21:10:30 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37058 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3412107AbiAYAfr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jan 2022 19:35:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FB6BB810A8
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jan 2022 00:35:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23374C340E4;
        Tue, 25 Jan 2022 00:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643070944;
        bh=79eRaG3OOqvJkPY/zMHOfgoHIUM/ZEpgZdkspxVOXKs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p60gHMQQpZnZHJiutZmN/oh/ZiAHzNpIrNOCeN7Jo/CfjUGBFU7xTwQ5T709Zvgck
         y+dDdF7mMOHPAPrBtFHvMFqckC6FDe1Bbs5/J6pGTWyKHvEfE4iLAgkPlm2fGGeq2g
         pmsGLRLEOk32lJ072ExxSbfbzxLLm/YLmuUusNRrFqKV43e4iQBciiW/DW5yav2K/u
         Xi/8M2yhq4xxKl9kexuJIOiiW1cTZ/G2yr59PoA7X8OOLw6OH2xY8h/+RGzYUIMdF6
         5LmaLVEVEp6+CfJqARhJtdr3+tSIinWrAW6ePQ5S70BQSdEkOEL6Hterr99yzSgDs7
         etsCsnPVwRhJA==
Date:   Mon, 24 Jan 2022 16:35:43 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V5 19/20] xfsprogs: Add support for upgrading to NREXT64
 feature
Message-ID: <20220125003543.GY13540@magnolia>
References: <20220121052019.224605-1-chandan.babu@oracle.com>
 <20220121052019.224605-20-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220121052019.224605-20-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> xfsprogs: Add support for upgrading to NREXT64 feature

Please shorten the subject line of this patch as well:

"xfs_repair: add suppport for upgrading to nrext64 feature"

On Fri, Jan 21, 2022 at 10:50:18AM +0530, Chandan Babu R wrote:
> This commit adds support to xfs_repair to allow upgrading an existing
> filesystem to support per-inode large extent counters.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  man/man8/xfs_admin.8 |  7 +++++++
>  repair/globals.c     |  1 +
>  repair/globals.h     |  1 +
>  repair/phase2.c      | 24 ++++++++++++++++++++++++
>  repair/xfs_repair.c  | 11 +++++++++++
>  5 files changed, 44 insertions(+)
> 
> diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
> index ad28e0f6..d64ed45b 100644
> --- a/man/man8/xfs_admin.8
> +++ b/man/man8/xfs_admin.8
> @@ -149,6 +149,13 @@ Upgrade a filesystem to support larger timestamps up to the year 2486.
>  The filesystem cannot be downgraded after this feature is enabled.
>  Once enabled, the filesystem will not be mountable by older kernels.
>  This feature was added to Linux 5.10.
> +.TP 0.4i
> +.B nrext64
> +Upgrade a filesystem to support large per-inode extent counters. Maximum data

Nit: sentence needs an article, e.g.

"The maximum data fork extent count..."

With that fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +fork extent count will be 2^48 while the maximum attribute fork extent count
> +will be 2^32. The filesystem cannot be downgraded after this feature is
> +enabled. Once enabled, the filesystem will not be mountable by older kernels.
> +This feature was added to Linux 5.18.
>  .RE
>  .TP
>  .BI \-U " uuid"
> diff --git a/repair/globals.c b/repair/globals.c
> index f8d4f1e4..c4084985 100644
> --- a/repair/globals.c
> +++ b/repair/globals.c
> @@ -51,6 +51,7 @@ int	lazy_count;		/* What to set if to if converting */
>  bool	features_changed;	/* did we change superblock feature bits? */
>  bool	add_inobtcount;		/* add inode btree counts to AGI */
>  bool	add_bigtime;		/* add support for timestamps up to 2486 */
> +bool	add_nrext64;
>  
>  /* misc status variables */
>  
> diff --git a/repair/globals.h b/repair/globals.h
> index 0f98bd2b..b65e4a2d 100644
> --- a/repair/globals.h
> +++ b/repair/globals.h
> @@ -92,6 +92,7 @@ extern int	lazy_count;		/* What to set if to if converting */
>  extern bool	features_changed;	/* did we change superblock feature bits? */
>  extern bool	add_inobtcount;		/* add inode btree counts to AGI */
>  extern bool	add_bigtime;		/* add support for timestamps up to 2486 */
> +extern bool	add_nrext64;
>  
>  /* misc status variables */
>  
> diff --git a/repair/phase2.c b/repair/phase2.c
> index 4c315055..979e281d 100644
> --- a/repair/phase2.c
> +++ b/repair/phase2.c
> @@ -181,6 +181,28 @@ set_bigtime(
>  	return true;
>  }
>  
> +static bool
> +set_nrext64(
> +	struct xfs_mount	*mp,
> +	struct xfs_sb		*new_sb)
> +{
> +	if (!xfs_has_crc(mp)) {
> +		printf(
> +	_("Nrext64 only supported on V5 filesystems.\n"));
> +		exit(0);
> +	}
> +
> +	if (xfs_has_nrext64(mp)) {
> +		printf(_("Filesystem already supports nrext64.\n"));
> +		exit(0);
> +	}
> +
> +	printf(_("Adding nrext64 to filesystem.\n"));
> +	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NREXT64;
> +	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
> +	return true;
> +}
> +
>  struct check_state {
>  	struct xfs_sb		sb;
>  	uint64_t		features;
> @@ -380,6 +402,8 @@ upgrade_filesystem(
>  		dirty |= set_inobtcount(mp, &new_sb);
>  	if (add_bigtime)
>  		dirty |= set_bigtime(mp, &new_sb);
> +	if (add_nrext64)
> +		dirty |= set_nrext64(mp, &new_sb);
>  	if (!dirty)
>  		return;
>  
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index de8617ba..c4705cf2 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -67,6 +67,7 @@ enum c_opt_nums {
>  	CONVERT_LAZY_COUNT = 0,
>  	CONVERT_INOBTCOUNT,
>  	CONVERT_BIGTIME,
> +	CONVERT_NREXT64,
>  	C_MAX_OPTS,
>  };
>  
> @@ -74,6 +75,7 @@ static char *c_opts[] = {
>  	[CONVERT_LAZY_COUNT]	= "lazycount",
>  	[CONVERT_INOBTCOUNT]	= "inobtcount",
>  	[CONVERT_BIGTIME]	= "bigtime",
> +	[CONVERT_NREXT64]	= "nrext64",
>  	[C_MAX_OPTS]		= NULL,
>  };
>  
> @@ -324,6 +326,15 @@ process_args(int argc, char **argv)
>  		_("-c bigtime only supports upgrades\n"));
>  					add_bigtime = true;
>  					break;
> +				case CONVERT_NREXT64:
> +					if (!val)
> +						do_abort(
> +		_("-c nrext64 requires a parameter\n"));
> +					if (strtol(val, NULL, 0) != 1)
> +						do_abort(
> +		_("-c nrext64 only supports upgrades\n"));
> +					add_nrext64 = true;
> +					break;
>  				default:
>  					unknown('c', val);
>  					break;
> -- 
> 2.30.2
> 
