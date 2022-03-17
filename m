Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5A38C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Mar 2022 02:39:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239154AbiCQCkl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Mar 2022 22:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358486AbiCQCkh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Mar 2022 22:40:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B9F205CE;
        Wed, 16 Mar 2022 19:39:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD326B81C82;
        Thu, 17 Mar 2022 02:39:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7C7C340E9;
        Thu, 17 Mar 2022 02:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647484754;
        bh=wMZ9inhRWFEfPrcdc66zpT2fjYM9bMm6nSvlT/ZcBbQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MunDs90O0cc8tFAoAAHPDHvO0L/Oh4gOWfE5Hg0jXOeVFtYPqOJxsY2vlwGTOwP2X
         teNAU38QlthojX/bD/OPJ9LtGEGDhUbsCJSY45/EDT+LfLuU99MFsYZXoyxGRTfdYN
         s+f+0xGa6+mpM2sNsjIi+t6DD2/GOGXP030p8td8Uqoo11+l7i9XDK0MRRxIFt9uuR
         7GScmLFs5kgCdfS556vXIKPC/25dbgjv60lKDZPsy8viUxq1zzNRgmcTh4u542rYoS
         Q9z4qE4Ati8hKTj+hw41t6JY8Ed3prsXB6ii1iSw8M2XpQ2nGO/LJa+Cg6NEbAzPsr
         6kJv4Xo4fDo9g==
Date:   Wed, 16 Mar 2022 19:39:14 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH] xfs: Fix missing error code in
 xfs_reflink_end_cow_extent()
Message-ID: <20220317023914.GX8224@magnolia>
References: <20220317013930.124432-1-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317013930.124432-1-jiapeng.chong@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 17, 2022 at 09:39:30AM +0800, Jiapeng Chong wrote:
> The error code is missing in this code scenario, add the error code
> '-EINVAL' to the return value 'error'.
> 
> Eliminate the follow smatch warning:
> 
> fs/xfs/xfs_reflink.c:634 xfs_reflink_end_cow_extent() warn: missing
> error code 'error'.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  fs/xfs/xfs_reflink.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 54e68e5693fd..7265f8850f65 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -631,6 +631,7 @@ xfs_reflink_end_cow_extent(
>  	if (!xfs_iext_lookup_extent_before(ip, ifp, end_fsb, &icur, &got) ||
>  	    got.br_startoff + got.br_blockcount <= offset_fsb) {
>  		*end_fsb = offset_fsb;
> +		error = -EINVAL;

Why would we return EINVAL for the case where there's no work left to
do?

--D

>  		goto out_cancel;
>  	}
>  
> -- 
> 2.20.1.7.g153144c
> 
