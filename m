Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B7C6CA0EEB
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Sep 2023 15:38:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236248AbjILPi3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 11:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233996AbjILPi3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Sep 2023 11:38:29 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E0C10DE;
        Tue, 12 Sep 2023 08:38:25 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB53C433C9;
        Tue, 12 Sep 2023 15:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694533104;
        bh=JX2M//UEtbXXtWy9skglEBEoG5GsJrmIdJJVT3ZixzQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qQ+jI73xLqI7U1svOYCfGRsOg5ha+HQbSiY9j88dE/qTRUWRX1yMiTtyHP34qOsu8
         JMRbWTKgtgoHyq5K/mDx4ebcp4zmDJPbElLXhgevZAsUMN3dXIj/4TxDKP7jIpJLes
         9ZSgTQhDS+6NzCv9VMwpEd9v9trnJIS6zP+xOTIIm0v3PYLh6j9T9CaRZQhfGm5p1Q
         E0e+Jb6KiZXL9oAteY93g3dH5Q5dh/s0/at7FhczUxoQUrNl2nTPL9sUzoTy+m8WDJ
         mC8SraqiUiAc7BzsC2e5fVEUmLX6Kpk/Z5eut7scT4vHtv9H+sq5CH0OnOvu3wD9L8
         e7kZn0zeGRQWQ==
Date:   Tue, 12 Sep 2023 08:38:24 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Kent Overstreet <kent.overstreet@linux.dev>,
        linux-xfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] xfs: delete some dead code in xfile_create()
Message-ID: <20230912153824.GB28186@frogsfrogsfrogs>
References: <1429a5db-874d-45f4-8571-7854d15da58d@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1429a5db-874d-45f4-8571-7854d15da58d@moroto.mountain>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 12, 2023 at 06:18:45PM +0300, Dan Carpenter wrote:
> The shmem_file_setup() function can't return NULL so there is no need
> to check and doing so is a bit confusing.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
> No fixes tag because this is not a bug, just some confusing code.

Please don't re-send patches that have already been presented here.
https://lore.kernel.org/linux-xfs/20230824161428.GO11263@frogsfrogsfrogs/

--D

>  fs/xfs/scrub/xfile.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
> index d98e8e77c684..71779d81cad7 100644
> --- a/fs/xfs/scrub/xfile.c
> +++ b/fs/xfs/scrub/xfile.c
> @@ -70,8 +70,6 @@ xfile_create(
>  		return -ENOMEM;
>  
>  	xf->file = shmem_file_setup(description, isize, 0);
> -	if (!xf->file)
> -		goto out_xfile;
>  	if (IS_ERR(xf->file)) {
>  		error = PTR_ERR(xf->file);
>  		goto out_xfile;
> -- 
> 2.39.2
> 
