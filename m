Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14CEBC77B75
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 18:07:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238090AbjEWSHI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 14:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237360AbjEWSHH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 14:07:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7694CA
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 11:07:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 638E56189A
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 18:07:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE27C433D2;
        Tue, 23 May 2023 18:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684865221;
        bh=IYwNIN6C+PjxIHjKaegltCmPFlIx0NvcUknHegj2u7A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=surf8MlLQ5yBG0EYqNheiQcl/oFynA0qRMIPB25bTaRaAB2nKcy0+349DYY8c9n9j
         hpsT3ATFCKQnlNH+3oZSt4GOA6/aaFZgVK6K4vyDPYV9uBuQOBAM9MN6iBDA6x4qzg
         MP6t2WEAxpHASGMBMbSSys4kWQZLqHRNHkgLDhsxXhNbBC3Xv3qa6Z2vwYiuskVCRq
         YqLjzxf1U06v+H76EEeBltyWHqw50oqVhVaHIhot3fkkZgo9m7SzDjkXPeIq6wAQHB
         vPB7cscRFRu4M0evO4B7+YGcxL1ccXRUQ19h/K6+W0KDLVzNoK8QoRFKf7t/SiJ05a
         ZiKEQypGoyFdg==
Date:   Tue, 23 May 2023 11:07:01 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/24] mdrestore: Extract target device size verification
 into a function
Message-ID: <20230523180701.GB11620@frogsfrogsfrogs>
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-22-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523090050.373545-22-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


"No functional changes" ?

With a better commit message,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

On Tue, May 23, 2023 at 02:30:47PM +0530, Chandan Babu R wrote:
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  mdrestore/xfs_mdrestore.c | 43 +++++++++++++++++++++++----------------
>  1 file changed, 26 insertions(+), 17 deletions(-)
> 
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index 52081a6ca..615ecdc77 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -86,6 +86,30 @@ open_device(
>  	return fd;
>  }
>  
> +static void
> +verify_device_size(
> +	int		dev_fd,
> +	bool		is_file,
> +	xfs_rfsblock_t	nr_blocks,
> +	uint32_t	blocksize)
> +{
> +	if (is_file) {
> +		/* ensure regular files are correctly sized */
> +		if (ftruncate(dev_fd, nr_blocks * blocksize))
> +			fatal("cannot set filesystem image size: %s\n",
> +				strerror(errno));
> +	} else {
> +		/* ensure device is sufficiently large enough */
> +		char		lb[XFS_MAX_SECTORSIZE] = { 0 };
> +		off64_t		off;
> +
> +		off = nr_blocks * blocksize - sizeof(lb);
> +		if (pwrite(dev_fd, lb, sizeof(lb), off) < 0)
> +			fatal("failed to write last block, is target too "
> +				"small? (error: %s)\n", strerror(errno));
> +	}
> +}
> +
>  static int
>  read_header_v1(
>  	void			*header,
> @@ -179,23 +203,8 @@ restore_v1(
>  
>  	((struct xfs_dsb*)block_buffer)->sb_inprogress = 1;
>  
> -	if (is_target_file)  {
> -		/* ensure regular files are correctly sized */
> -
> -		if (ftruncate(data_fd, sb.sb_dblocks * sb.sb_blocksize))
> -			fatal("cannot set filesystem image size: %s\n",
> -				strerror(errno));
> -	} else  {
> -		/* ensure device is sufficiently large enough */
> -
> -		char		lb[XFS_MAX_SECTORSIZE] = { 0 };
> -		off64_t		off;
> -
> -		off = sb.sb_dblocks * sb.sb_blocksize - sizeof(lb);
> -		if (pwrite(data_fd, lb, sizeof(lb), off) < 0)
> -			fatal("failed to write last block, is target too "
> -				"small? (error: %s)\n", strerror(errno));
> -	}
> +	verify_device_size(data_fd, is_target_file, sb.sb_dblocks,
> +			sb.sb_blocksize);
>  
>  	bytes_read = 0;
>  
> -- 
> 2.39.1
> 
