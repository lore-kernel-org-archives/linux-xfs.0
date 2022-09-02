Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0A58C6FA82
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Sep 2022 20:45:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiIBUpn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Sep 2022 16:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiIBUpm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Sep 2022 16:45:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99986D9D42;
        Fri,  2 Sep 2022 13:45:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 002F3B82D95;
        Fri,  2 Sep 2022 20:45:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987ADC433C1;
        Fri,  2 Sep 2022 20:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662151538;
        bh=KGoUJ0TF++94l7S9+Rc4qmXzMOED8i2XymramZvVqns=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O+VX8dLdxnujJYY7GKXyy1bEdukAvoz4+T6qua3yydLI50r9eLeZG2czIobySyJoS
         5e1To6ljAq+wesfpcssrGLjoJjWM9Q0eisH5aEyk+q8CkfvR44YhwrMRAhCcj4KVuE
         q86MyxBXtMQ40T+PHnhID4667vXMPWnB0ewGo1aQZqSRpqAHDUOwgaDsnLLgUfLJ+N
         eUoEleQGPeqeqA+XkRIgTWGNVOnUkY1oc6uwq4Z2S0YL6sMdWEGMkt10RVjxxtQ3ws
         nhoed9f+fZkUP4PDPFJ3nebbztpBhxZJ8wzUu4r0BtXQC1uh/69s8euh3j5FvRuRQx
         dz94FAT/3CEow==
Date:   Fri, 2 Sep 2022 13:45:38 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cgel.zte@gmail.com
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, ye xingchen <ye.xingchen@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] xfs: Remove the unneeded result variable
Message-ID: <YxJrchChFK7vv+cX@magnolia>
References: <20220902073232.319601-1-ye.xingchen@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220902073232.319601-1-ye.xingchen@zte.com.cn>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 02, 2022 at 07:32:32AM +0000, cgel.zte@gmail.com wrote:
> From: ye xingchen <ye.xingchen@zte.com.cn>
> 
> Return the value xfs_dir_cilookup_result() directly instead of storing it
> in another redundant variable.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>

LGTM.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_dir2_sf.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index 003812fd7d35..8cd37e6e9d38 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -865,7 +865,6 @@ xfs_dir2_sf_lookup(
>  	struct xfs_inode	*dp = args->dp;
>  	struct xfs_mount	*mp = dp->i_mount;
>  	int			i;		/* entry index */
> -	int			error;
>  	xfs_dir2_sf_entry_t	*sfep;		/* shortform directory entry */
>  	xfs_dir2_sf_hdr_t	*sfp;		/* shortform structure */
>  	enum xfs_dacmp		cmp;		/* comparison result */
> @@ -929,8 +928,7 @@ xfs_dir2_sf_lookup(
>  	if (!ci_sfep)
>  		return -ENOENT;
>  	/* otherwise process the CI match as required by the caller */
> -	error = xfs_dir_cilookup_result(args, ci_sfep->name, ci_sfep->namelen);
> -	return error;
> +	return xfs_dir_cilookup_result(args, ci_sfep->name, ci_sfep->namelen);
>  }
>  
>  /*
> -- 
> 2.25.1
