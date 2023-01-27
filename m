Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F88EC38142
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Jan 2023 16:27:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233708AbjA0Q1Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Jan 2023 11:27:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232974AbjA0Q1P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Jan 2023 11:27:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 895ED80F8F
        for <linux-xfs@vger.kernel.org>; Fri, 27 Jan 2023 08:27:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F300B82159
        for <linux-xfs@vger.kernel.org>; Fri, 27 Jan 2023 16:27:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B00C433D2;
        Fri, 27 Jan 2023 16:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674836831;
        bh=ZNIqWcxH6ClJJvBuUICQzkIKTi9pslg/QgOfZIb18bY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V7gaXbWtSGTNH9xwuy22ioBwxL3MAAFvFQTlU7vsGEybOyW2OsNq3EvbjfViN0L8a
         zqKXwW7X24ddp4kamxPK5PJSwECWTVnalv0B3XUIHmBCDOqL14R5P6R23XKq1o0oP2
         tZAO5j3h8628zY/fPsk2p5ysWnI/mJB4mfpwTKWN1LVie8/NQ3I6glwi+kYruLPsbY
         OePHuqKj+R0ufx9WqkhYdGPS8gFYIX8ZRBoZLCupvpAqUNyut29MN/tzntf4EETjbz
         3pf46vFIFZeH4wLj8tE+dE/k/hbzYziv5+c0HHVYF/OTCimFjCViWGL7tM1NHHb2l5
         kfY1dkgea0e7Q==
Date:   Fri, 27 Jan 2023 08:27:11 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Donald Douwsma <ddouwsma@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: allow setting full range of panic tags
Message-ID: <Y9P7X6GnLA/iJuIa@magnolia>
References: <20230126052910.588098-1-ddouwsma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126052910.588098-1-ddouwsma@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 26, 2023 at 04:29:10PM +1100, Donald Douwsma wrote:
> xfs will not allow combining other panic masks with
> XFS_PTAG_VERIFIER_ERROR.
> 
>  sysctl fs.xfs.panic_mask=511
>  sysctl: setting key "fs.xfs.panic_mask": Invalid argument
>  fs.xfs.panic_mask = 511
> 
> Update to the maximum value that can be set to allow the full range of
> masks.
> 
> Fixes: d519da41e2b7 ("xfs: Introduce XFS_PTAG_VERIFIER_ERROR panic mask")
> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
> ---
>  Documentation/admin-guide/xfs.rst |  2 +-
>  fs/xfs/xfs_error.h                | 13 ++++++++++++-
>  fs/xfs/xfs_globals.c              |  3 ++-
>  3 files changed, 15 insertions(+), 3 deletions(-)
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
> index dbe6c37dc697..a015f7b370dc 100644
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
> @@ -88,6 +88,17 @@ extern int xfs_errortag_clearall(struct xfs_mount *mp);
>  #define		XFS_PTAG_FSBLOCK_ZERO		(1u << 7)
>  #define		XFS_PTAG_VERIFIER_ERROR		(1u << 8)
>  
> +#define		XFS_MAX_PTAG ( \

The ptag values are a bitmask, not a continuous integer range, so the
name should have "MASK" in it, e.g.

#define			XFS_PTAG_MASK	(XFS_PTAG_IFLUSH | \
					 XFS_PTAG_LOGRES | \
					...

and follow the customary style where the macro definition lines are
indented from the name.

Otherwise this looks fine.

--D

> +			XFS_PTAG_IFLUSH | \
> +			XFS_PTAG_LOGRES | \
> +			XFS_PTAG_AILDELETE | \
> +			XFS_PTAG_ERROR_REPORT | \
> +			XFS_PTAG_SHUTDOWN_CORRUPT | \
> +			XFS_PTAG_SHUTDOWN_IOERROR | \
> +			XFS_PTAG_SHUTDOWN_LOGERROR | \
> +			XFS_PTAG_FSBLOCK_ZERO | \
> +			XFS_PTAG_VERIFIER_ERROR)
> +
>  #define XFS_PTAG_STRINGS \
>  	{ XFS_NO_PTAG,			"none" }, \
>  	{ XFS_PTAG_IFLUSH,		"iflush" }, \
> diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
> index 4d0a98f920ca..ff129acce8e6 100644
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
> +	.panic_mask	= {	0,		0,		XFS_MAX_PTAG},
>  	.error_level	= {	0,		3,		11	},
>  	.syncd_timer	= {	1*100,		30*100,		7200*100},
>  	.stats_clear	= {	0,		0,		1	},
> -- 
> 2.31.1
> 
