Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0C46C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 00:40:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356435AbiD0Ann (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 20:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356443AbiD0Anm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 20:43:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B94815FC5
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 17:40:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5AA06B823FC
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 00:40:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA08C385A0;
        Wed, 27 Apr 2022 00:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651020028;
        bh=XFaPAvdVIPCE++DwdReUXEAv8Fb2uqF9lhs43999zIY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K7hsg2kXZ1bYtmp7iUSY0Chgr6MDIBDG1V+fBbWfyY0y0t5RfOKRDftYhjfJvl4R4
         SCkAUxTrfCip7yk/m3Ji4t2C40zLpA/9dqycGtrPJrZjEKGvSa/G8KdbVN07xL2CmW
         8djYW72AGQZWXdzK67gREModz380GotgNnTiyyoCdt2AIE+nHG6eug8GYs8jIzjXnF
         nWV6aP4AoALh0ypj/0RaWENXMgr+lqKjMycqsXctKOuutw9g01GCmJY3dW3zVAe1tw
         4V5HgHX+vHWjdD38oRpSDrKuHiu9IwLGQjD7nH8XRyOUrxmXknq3Ogv4LrLxrNc2Zs
         jqJ388jhrK5Tg==
Date:   Tue, 26 Apr 2022 17:40:27 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] metadump: be careful zeroing corrupt inode forks
Message-ID: <20220427004027.GX17025@magnolia>
References: <20220426234453.682296-1-david@fromorbit.com>
 <20220426234453.682296-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426234453.682296-3-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 27, 2022 at 09:44:51AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When a corrupt inode fork is encountered, we can zero beyond the end
> of the inode if the fork pointers are sufficiently trashed. We
> should not trust the fork pointers when corruption is detected and
> skip the zeroing in this case. We want metadump to capture the
> corruption and so skipping the zeroing will give us the best chance
> of preserving the corruption in a meaningful state for diagnosis.
> 
> Reported-by: Sean Caron <scaron@umich.edu>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Hmm.  I /think/ the only real change here is the addition of the
DFORK_DSIZE > LITINO warning, right?  The rest is just reindenting the
loop body?

If so, LGTM.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  db/metadump.c | 49 +++++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 39 insertions(+), 10 deletions(-)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index a21baa2070d9..3948d36e4d5c 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -2308,18 +2308,34 @@ process_inode_data(
>  {
>  	switch (dip->di_format) {
>  		case XFS_DINODE_FMT_LOCAL:
> -			if (obfuscate || zero_stale_data)
> -				switch (itype) {
> -					case TYP_DIR2:
> -						process_sf_dir(dip);
> -						break;
> +			if (!(obfuscate || zero_stale_data))
> +				break;
> +
> +			/*
> +			 * If the fork size is invalid, we can't safely do
> +			 * anything with this fork. Leave it alone to preserve
> +			 * the information for diagnostic purposes.
> +			 */
> +			if (XFS_DFORK_DSIZE(dip, mp) > XFS_LITINO(mp)) {
> +				print_warning(
> +"Invalid data fork size (%d) in inode %llu, preserving contents!",
> +						XFS_DFORK_DSIZE(dip, mp),
> +						(long long)cur_ino);
> +				break;
> +			}
>  
> -					case TYP_SYMLINK:
> -						process_sf_symlink(dip);
> -						break;
> +			switch (itype) {
> +				case TYP_DIR2:
> +					process_sf_dir(dip);
> +					break;
>  
> -					default: ;
> -				}
> +				case TYP_SYMLINK:
> +					process_sf_symlink(dip);
> +					break;
> +
> +				default:
> +					break;
> +			}
>  			break;
>  
>  		case XFS_DINODE_FMT_EXTENTS:
> @@ -2341,6 +2357,19 @@ process_dev_inode(
>  				      (unsigned long long)cur_ino);
>  		return;
>  	}
> +
> +	/*
> +	 * If the fork size is invalid, we can't safely do anything with
> +	 * this fork. Leave it alone to preserve the information for diagnostic
> +	 * purposes.
> +	 */
> +	if (XFS_DFORK_DSIZE(dip, mp) > XFS_LITINO(mp)) {
> +		print_warning(
> +"Invalid data fork size (%d) in inode %llu, preserving contents!",
> +				XFS_DFORK_DSIZE(dip, mp), (long long)cur_ino);
> +		return;
> +	}
> +
>  	if (zero_stale_data) {
>  		unsigned int	size = sizeof(xfs_dev_t);
>  
> -- 
> 2.35.1
> 
