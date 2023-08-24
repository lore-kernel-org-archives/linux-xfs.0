Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D35BAC27C40
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Aug 2023 16:15:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238770AbjHXQPB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Aug 2023 12:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242415AbjHXQOb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2023 12:14:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D54719A9
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 09:14:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF6D965DCE
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 16:14:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C817C433C9;
        Thu, 24 Aug 2023 16:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692893669;
        bh=7yui3oWO0pUPs74v8rngWmNwSZGnXMwMwAdZUUmPTnc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Com2Lf5XCxBvc6YM9UL09Ard+d1YgWshPGl3bKhCFYtm5aWqVDnvxm1IjQtIAfJ3K
         VKvNCv0jag9EhN/WmkUVvwF/fxLZzheoeRthsFz9cYmGSFfRw9IAsjdWrETTj6anTq
         UD68GyajoPouKIdXEP48zwEQwmDAB46+Ww/dVD2lPs6B0EettSdmBJx+WSFjBsHxoV
         pXATblKh0NhPCvuKImSR4lTTG8FlyXVktwymFte9UJOb9q8jFZkdVvwUoNeEOWtsKU
         EduVho5+35ivnpIrVyKc7a6MEFSVVp7aDKGCs7icrkThE2XCidyZyA+xp2QavONzMl
         NAPc91EoFyA6g==
Date:   Thu, 24 Aug 2023 09:14:28 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com,
        kent.overstreet@linux.dev, dchinner@redhat.com
Subject: Re: [PATCH -next] xfs: remove unnecessary check in xfile_create()
Message-ID: <20230824161428.GO11263@frogsfrogsfrogs>
References: <20230824091537.1072956-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230824091537.1072956-1-yangyingliang@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 24, 2023 at 05:15:37PM +0800, Yang Yingliang wrote:
> shmem_file_setup() returns ERR_PTR() when it fails,
> so remove the unnecessary null pointer check.

Technically correct, but what harm is there in leaving a null check in
case the shmem_file_setup function ever /does/ start returning NULL?

--D

> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
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
> 2.25.1
> 
