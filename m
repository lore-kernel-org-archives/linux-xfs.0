Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 503CBC77B75
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 16:36:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234248AbjEWQgt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 12:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232954AbjEWQgs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 12:36:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C08E9
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 09:36:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 861DB6200D
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 16:36:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5E8C433EF;
        Tue, 23 May 2023 16:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684859798;
        bh=L6dMtsNVgU3XJUt0caR3xWSMGUjfr7GKZAPmMd06XVg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OwrscN6rxZSQzGxgX/cmdg2mfT2LRvEj8DsMl1p5l4VtV3BZCy8FdijfLUFT2WyUQ
         NGsJ5xa1N6o549Z26FWJJaV3fODepUdjeWojQfAT5fXnM8QQMymSMzKABIUY4eGji4
         v+4WG8TJbqI4EGRiGO7B18GNKSjzSjoji4Zu3T/9W5f9kmkB+s8U9CuXYuHLPGK0Z1
         hYC1ULiQdCOoM/R8CAeuUwJhAh3zgxpOxbZ23C2McQ/MIl4TlTSAVG2Mayh1a9aeWp
         XMM4XmmrTIp/w/uXJWs13ng4GJ22j2Q7Woz3Oi7mzuUP4DTDuBH23F1jSGiWpiODsO
         CLyhZ1UAg/m/w==
Date:   Tue, 23 May 2023 09:36:38 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/24] metadump: Add initialization and release functions
Message-ID: <20230523163638.GK11620@frogsfrogsfrogs>
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-5-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523090050.373545-5-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 02:30:30PM +0530, Chandan Babu R wrote:
> Move metadump initialization and release functionality into corresponding
> functions.

"No functional changes"?

> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  db/metadump.c | 88 ++++++++++++++++++++++++++++++---------------------
>  1 file changed, 52 insertions(+), 36 deletions(-)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index 806cdfd68..e7a433c21 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -2984,6 +2984,54 @@ done:
>  	return !write_buf(iocur_top);
>  }
>  
> +static int
> +init_metadump(void)
> +{
> +	metadump.metablock = (xfs_metablock_t *)calloc(BBSIZE + 1, BBSIZE);
> +	if (metadump.metablock == NULL) {
> +		print_warning("memory allocation failure");
> +		return -1;
> +	}
> +	metadump.metablock->mb_blocklog = BBSHIFT;
> +	metadump.metablock->mb_magic = cpu_to_be32(XFS_MD_MAGIC);
> +
> +	/* Set flags about state of metadump */
> +	metadump.metablock->mb_info = XFS_METADUMP_INFO_FLAGS;
> +	if (metadump.obfuscate)
> +		metadump.metablock->mb_info |= XFS_METADUMP_OBFUSCATED;
> +	if (!metadump.zero_stale_data)
> +		metadump.metablock->mb_info |= XFS_METADUMP_FULLBLOCKS;
> +	if (metadump.dirty_log)
> +		metadump.metablock->mb_info |= XFS_METADUMP_DIRTYLOG;
> +
> +	metadump.block_index = (__be64 *)((char *)metadump.metablock +
> +				sizeof(xfs_metablock_t));
> +	metadump.block_buffer = (char *)(metadump.metablock) + BBSIZE;
> +	metadump.num_indices = (BBSIZE - sizeof(xfs_metablock_t)) / sizeof(__be64);
> +
> +	/*
> +	 * A metadump block can hold at most num_indices of BBSIZE sectors;
> +	 * do not try to dump a filesystem with a sector size which does not
> +	 * fit within num_indices (i.e. within a single metablock).
> +	 */
> +	if (mp->m_sb.sb_sectsize > metadump.num_indices * BBSIZE) {
> +		print_warning("Cannot dump filesystem with sector size %u",
> +			      mp->m_sb.sb_sectsize);
> +		free(metadump.metablock);
> +		return -1;
> +	}
> +
> +	metadump.cur_index = 0;
> +
> +        return 0;

Tabs, not spaces.

With that fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> +}
> +
> +static void
> +release_metadump(void)
> +{
> +	free(metadump.metablock);
> +}
> +
>  static int
>  metadump_f(
>  	int 		argc,
> @@ -3076,48 +3124,16 @@ metadump_f(
>  		pop_cur();
>  	}
>  
> -	metadump.metablock = (xfs_metablock_t *)calloc(BBSIZE + 1, BBSIZE);
> -	if (metadump.metablock == NULL) {
> -		print_warning("memory allocation failure");
> -		return -1;
> -	}
> -	metadump.metablock->mb_blocklog = BBSHIFT;
> -	metadump.metablock->mb_magic = cpu_to_be32(XFS_MD_MAGIC);
> -
> -	/* Set flags about state of metadump */
> -	metadump.metablock->mb_info = XFS_METADUMP_INFO_FLAGS;
> -	if (metadump.obfuscate)
> -		metadump.metablock->mb_info |= XFS_METADUMP_OBFUSCATED;
> -	if (!metadump.zero_stale_data)
> -		metadump.metablock->mb_info |= XFS_METADUMP_FULLBLOCKS;
> -	if (metadump.dirty_log)
> -		metadump.metablock->mb_info |= XFS_METADUMP_DIRTYLOG;
> -
> -	metadump.block_index = (__be64 *)((char *)metadump.metablock +
> -					sizeof(xfs_metablock_t));
> -	metadump.block_buffer = (char *)metadump.metablock + BBSIZE;
> -	metadump.num_indices = (BBSIZE - sizeof(xfs_metablock_t)) /
> -		sizeof(__be64);
> -
> -	/*
> -	 * A metadump block can hold at most num_indices of BBSIZE sectors;
> -	 * do not try to dump a filesystem with a sector size which does not
> -	 * fit within num_indices (i.e. within a single metablock).
> -	 */
> -	if (mp->m_sb.sb_sectsize > metadump.num_indices * BBSIZE) {
> -		print_warning("Cannot dump filesystem with sector size %u",
> -			      mp->m_sb.sb_sectsize);
> -		free(metadump.metablock);
> +	ret = init_metadump();
> +	if (ret)
>  		return 0;
> -	}
>  
>  	start_iocur_sp = iocur_sp;
>  
>  	if (strcmp(argv[optind], "-") == 0) {
>  		if (isatty(fileno(stdout))) {
>  			print_warning("cannot write to a terminal");
> -			free(metadump.metablock);
> -			return 0;
> +			goto out;
>  		}
>  		/*
>  		 * Redirect stdout to stderr for the duration of the
> @@ -3194,7 +3210,7 @@ metadump_f(
>  	while (iocur_sp > start_iocur_sp)
>  		pop_cur();
>  out:
> -	free(metadump.metablock);
> +	release_metadump();
>  
>  	return 0;
>  }
> -- 
> 2.39.1
> 
