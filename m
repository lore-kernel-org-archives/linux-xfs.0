Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4470CC636CC
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 02:40:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbjBICk6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Feb 2023 21:40:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjBICk5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Feb 2023 21:40:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D3F21281
        for <linux-xfs@vger.kernel.org>; Wed,  8 Feb 2023 18:40:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0853B81FE2
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 02:40:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B200C433EF;
        Thu,  9 Feb 2023 02:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675910453;
        bh=kWgQlo/CbKY6V16zQy9ztIKFblteF4xpl8D71DZ9Rzk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n4EVM3O4xpZPypxA+qv5qbNiiEiOk+CARBbvoe5uOaN1SiFDfr+HKV8/SEWcZQWdM
         wNHXfbJ5/JTHA4zgZvd9mRJ5TNiNldIoubxs3j0xr7dTELuCKvWj7herxTu5XaXOmq
         NfG9xH1CKWSyXBbP2erkhXEEK/yY2cTVyXdVmHu/4SiVUIUdnmwPxk6WnuYPpjbAtf
         S5XbhgZIcDfinjYClhbx+/fbcncCFAR0kxqNCrZCu3moEuwK+5706N69H6XjBJctHL
         fbg0q5UZaC3OmPPL35viovUI/6RebakMIxcPta5A8ITWBWAD2Sc4aGZkNfWux0oNXj
         azFHXzmotQ0Xg==
Date:   Wed, 8 Feb 2023 18:40:52 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Donald Douwsma <ddouwsma@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3] xfs: allow setting full range of panic tags
Message-ID: <Y+RdNLTtjBtYCIif@magnolia>
References: <20230207062209.1806104-1-ddouwsma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207062209.1806104-1-ddouwsma@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 07, 2023 at 05:22:09PM +1100, Donald Douwsma wrote:
> xfs will not allow combining other panic masks with
> XFS_PTAG_VERIFIER_ERROR.
> 
>  # sysctl fs.xfs.panic_mask=511
>  sysctl: setting key "fs.xfs.panic_mask": Invalid argument
>  fs.xfs.panic_mask = 511
> 
> Update to the maximum value that can be set to allow the full range of
> masks. Do this using a mask of possible values to prevent this happening
> again as suggested by Darrick.
> 
> Fixes: d519da41e2b7 ("xfs: Introduce XFS_PTAG_VERIFIER_ERROR panic mask")
> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>

Looks good to me, thanks!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  Documentation/admin-guide/xfs.rst |  2 +-
>  fs/xfs/xfs_error.h                | 12 +++++++++++-
>  fs/xfs/xfs_globals.c              |  3 ++-
>  3 files changed, 14 insertions(+), 3 deletions(-)
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
> diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
> index dbe6c37dc697..0b9c5ba8a598 100644
> --- a/fs/xfs/xfs_error.h
> +++ b/fs/xfs/xfs_error.h
> @@ -75,7 +75,7 @@ extern int xfs_errortag_clearall(struct xfs_mount *mp);
>  
>  /*
>   * XFS panic tags -- allow a call to xfs_alert_tag() be turned into
> - *			a panic by setting xfs_panic_mask in a sysctl.
> + *			a panic by setting fs.xfs.panic_mask in a sysctl.
>   */
>  #define		XFS_NO_PTAG			0u
>  #define		XFS_PTAG_IFLUSH			(1u << 0)
> @@ -88,6 +88,16 @@ extern int xfs_errortag_clearall(struct xfs_mount *mp);
>  #define		XFS_PTAG_FSBLOCK_ZERO		(1u << 7)
>  #define		XFS_PTAG_VERIFIER_ERROR		(1u << 8)
>  
> +#define		XFS_PTAG_MASK	(XFS_PTAG_IFLUSH | \
> +				 XFS_PTAG_LOGRES | \
> +				 XFS_PTAG_AILDELETE | \
> +				 XFS_PTAG_ERROR_REPORT | \
> +				 XFS_PTAG_SHUTDOWN_CORRUPT | \
> +				 XFS_PTAG_SHUTDOWN_IOERROR | \
> +				 XFS_PTAG_SHUTDOWN_LOGERROR | \
> +				 XFS_PTAG_FSBLOCK_ZERO | \
> +				 XFS_PTAG_VERIFIER_ERROR)
> +
>  #define XFS_PTAG_STRINGS \
>  	{ XFS_NO_PTAG,			"none" }, \
>  	{ XFS_PTAG_IFLUSH,		"iflush" }, \
> diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
> index 4d0a98f920ca..9edc1f2bc939 100644
> --- a/fs/xfs/xfs_globals.c
> +++ b/fs/xfs/xfs_globals.c
> @@ -4,6 +4,7 @@
>   * All Rights Reserved.
>   */
>  #include "xfs.h"
> +#include "xfs_error.h"
>  
>  /*
>   * Tunable XFS parameters.  xfs_params is required even when CONFIG_SYSCTL=n,
> @@ -15,7 +16,7 @@ xfs_param_t xfs_params = {
>  			  /*	MIN		DFLT		MAX	*/
>  	.sgid_inherit	= {	0,		0,		1	},
>  	.symlink_mode	= {	0,		0,		1	},
> -	.panic_mask	= {	0,		0,		256	},
> +	.panic_mask	= {	0,		0,		XFS_PTAG_MASK},
>  	.error_level	= {	0,		3,		11	},
>  	.syncd_timer	= {	1*100,		30*100,		7200*100},
>  	.stats_clear	= {	0,		0,		1	},
> -- 
> 2.31.1
> 
