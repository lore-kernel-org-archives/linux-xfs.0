Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E38C3C54E94
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Jan 2023 16:13:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234565AbjAYQNc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Jan 2023 11:13:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbjAYQNc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jan 2023 11:13:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A8583C29D
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jan 2023 08:13:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8AB760ACA
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jan 2023 16:13:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39680C433EF;
        Wed, 25 Jan 2023 16:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674663210;
        bh=eGmbiC2SfdT3Imge4RaN5TdYk3xNSc6+qey2UmncvTQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ErfQR1hy5UjkZohBQnOAGWHAAUu4kzcrlLdLG4yhS8iNXzmrgpR/hMyT9l44smc4H
         xdEPJC8oQ5mEOt07v2rmekT82gWMTH+hHFMxKhqlv688LRAIPndmdtS0s2YYhdoRON
         NI7m7FG7nfNNm6pN6fx2EUR1RM6jz5A3gajGCPR3BXaah53CR6Om4SMaDHisQYpGUM
         pErnLvKvCuvfKEqLZTImzfvwbSVys5DJoEYezKhfMZJV7uc/WC1Y9MyQwktHxrs2KK
         t7H/ZNej3qZHOddhc+4APLE5dRKwOTlGVFJFCUJ+6+lJd5iP1PSs6zs6XI8X4GLGRc
         BdYH23m+0PUvQ==
Date:   Wed, 25 Jan 2023 08:13:29 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Donald Douwsma <ddouwsma@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: allow setting full range of panic tags
Message-ID: <Y9FVKelYL38Ka2mY@magnolia>
References: <20230125050138.372749-1-ddouwsma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230125050138.372749-1-ddouwsma@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 25, 2023 at 04:01:38PM +1100, Donald Douwsma wrote:
> xfs will not allow combining other panic values with XFS_PTAG_VERIFIER_ERROR.
> 
>  sysctl fs.xfs.panic_mask=511
>  sysctl: setting key "fs.xfs.panic_mask": Invalid argument
>  fs.xfs.panic_mask = 511
> 
> Update to the maximum value that can be set to allow the full range of masks.
> 
> Fixes: d519da41e2b78 ("xfs: Introduce XFS_PTAG_VERIFIER_ERROR panic mask")
> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
> ---
>  Documentation/admin-guide/xfs.rst | 2 +-
>  fs/xfs/xfs_globals.c              | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
> index 8de008c0c5ad..e2561416391c 100644
> --- a/Documentation/admin-guide/xfs.rst
> +++ b/Documentation/admin-guide/xfs.rst
> @@ -296,7 +296,7 @@ The following sysctls are available for the XFS filesystem:
>  		XFS_ERRLEVEL_LOW:       1
>  		XFS_ERRLEVEL_HIGH:      5
>  
> -  fs.xfs.panic_mask		(Min: 0  Default: 0  Max: 256)
> +  fs.xfs.panic_mask		(Min: 0  Default: 0  Max: 511)
>  	Causes certain error conditions to call BUG(). Value is a bitmask;
>  	OR together the tags which represent errors which should cause panics:
>  
> diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
> index 4d0a98f920ca..e0e9494a8251 100644
> --- a/fs/xfs/xfs_globals.c
> +++ b/fs/xfs/xfs_globals.c
> @@ -15,7 +15,7 @@ xfs_param_t xfs_params = {
>  			  /*	MIN		DFLT		MAX	*/
>  	.sgid_inherit	= {	0,		0,		1	},
>  	.symlink_mode	= {	0,		0,		1	},
> -	.panic_mask	= {	0,		0,		256	},
> +	.panic_mask	= {	0,		0,		511	},

Why not fix this by defining an XFS_PTAG_ALL_MASK that combines all
valid flags and use that here?  That way we eliminate this class of bug.

Looking at d519da41e2b78, the maintainers suck at noticing these kinds
of mistakes.

--D

>  	.error_level	= {	0,		3,		11	},
>  	.syncd_timer	= {	1*100,		30*100,		7200*100},
>  	.stats_clear	= {	0,		0,		1	},
> -- 
> 2.31.1
> 
