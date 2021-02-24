Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4831C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 21:48:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CD5464F06
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 21:48:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbhBXVsU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 16:48:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:52480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230330AbhBXVsU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Feb 2021 16:48:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50C3A64EFA;
        Wed, 24 Feb 2021 21:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614203259;
        bh=EYjMMnCXCMC7+MCMT0m9cS8G1JebHh1Bfb/Qltd2aFE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MRLkVIGLU4p1LrH9UgHNP2yKvS2jAN1fUYMTmGB5YsiUlRYauWRHZEb7AFRJjZqep
         C8kIxE630fASCyrjten9F1njmdVXjdLlBOCfv4qvJgF+K0q7BFWs/3ceF1X3XNq5a+
         TMKUsmmEL52NEaD3pHEzG9F3t3mC1SEjYiELGbIWqloe0Lhmr2CYrC+T2ubaUuVozs
         Qy/uOR/wqXYp8eLcvE++9gM0A6aA20Daz+iK98pr3Cy+9pjp+67sMwHtrQsSGMDCDV
         joen1sVUozYmSdTdXEvkPWe3nNCmOaAAfK4AsbZNc/s/hmhU+b+fbWz50z/wStuCWP
         29TZS5tq8wfZg==
Date:   Wed, 24 Feb 2021 13:47:38 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: No need for inode number error injection in
 __xfs_dir3_data_check
Message-ID: <20210224214738.GD7272@magnolia>
References: <20210223054748.3292734-1-david@fromorbit.com>
 <20210223054748.3292734-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223054748.3292734-3-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 23, 2021 at 04:47:47PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We call xfs_dir_ino_validate() for every dir entry in a directory
> when doing validity checking of the directory. It calls
> xfs_verify_dir_ino() then emits a corruption report if bad or does
> error injection if good. It is extremely costly:
> 
>   43.27%  [kernel]  [k] xfs_dir3_leaf_check_int
>   10.28%  [kernel]  [k] __xfs_dir3_data_check
>    6.61%  [kernel]  [k] xfs_verify_dir_ino
>    4.16%  [kernel]  [k] xfs_errortag_test
>    4.00%  [kernel]  [k] memcpy
>    3.48%  [kernel]  [k] xfs_dir_ino_validate
> 
> 7% of the cpu usage in this directory traversal workload is
> xfs_dir_ino_validate() doing absolutely nothing.
> 
> We don't need error injection to simulate a bad inode numbers in the
> directory structure because we can do that by fuzzing the structure
> on disk.
> 
> And we don't need a corruption report, because the
> __xfs_dir3_data_check() will emit one if the inode number is bad.
> 
> So just call xfs_verify_dir_ino() directly here, and get rid of all
> this unnecessary overhead:
> 
>   40.30%  [kernel]  [k] xfs_dir3_leaf_check_int
>   10.98%  [kernel]  [k] __xfs_dir3_data_check
>    8.10%  [kernel]  [k] xfs_verify_dir_ino
>    4.42%  [kernel]  [k] memcpy
>    2.22%  [kernel]  [k] xfs_dir2_data_get_ftype
>    1.52%  [kernel]  [k] do_raw_spin_lock
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Heh, yeah, this one has filled up the fuzzer test results for a while...

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_dir2_data.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index 375b3edb2ad2..e67fa086f2c1 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -218,7 +218,7 @@ __xfs_dir3_data_check(
>  		 */
>  		if (dep->namelen == 0)
>  			return __this_address;
> -		if (xfs_dir_ino_validate(mp, be64_to_cpu(dep->inumber)))
> +		if (!xfs_verify_dir_ino(mp, be64_to_cpu(dep->inumber)))
>  			return __this_address;
>  		if (offset + xfs_dir2_data_entsize(mp, dep->namelen) > end)
>  			return __this_address;
> -- 
> 2.28.0
> 
