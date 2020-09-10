Return-Path: <SRS0=NqjT=CT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F1FDC43461
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Sep 2020 21:40:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3033020829
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Sep 2020 21:40:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725777AbgIJVkf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Sep 2020 17:40:35 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:59680 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728070AbgIJVj5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Sep 2020 17:39:57 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 706523A8ABB;
        Fri, 11 Sep 2020 07:39:52 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kGUIJ-0005Pk-9I; Fri, 11 Sep 2020 07:39:51 +1000
Date:   Fri, 11 Sep 2020 07:39:51 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: deprecate the V4 format
Message-ID: <20200910213951.GU12131@dread.disaster.area>
References: <20200910182706.GD7964@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910182706.GD7964@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=XJ9OtjpE c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=kj9zAlcOel0A:10 a=reM5J-MqmosA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=OESHbMLS_L9yciFrRzgA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 10, 2020 at 11:27:06AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The V4 filesystem format contains known weaknesses in the on-disk format
> that make metadata verification diffiult.  In addition, the format will
> does not support dates past 2038 and will not be upgraded to do so.
> Therefore, we should start the process of retiring the old format to
> close off attack surfaces and to encourage users to migrate onto V5.
> 
> Therefore, make XFS V4 support a configurable option.  For the first
> period it will be default Y in case some distributors want to withdraw
> support early; for the second period it will be default N so that anyone
> who wishes to continue support can do so; and after that, support will
> be removed from the kernel.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/Kconfig     |   18 ++++++++++++++++++
>  fs/xfs/xfs_mount.c |   11 +++++++++++
>  2 files changed, 29 insertions(+)
> 
> diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
> index e685299eb3d2..db54ca9914c7 100644
> --- a/fs/xfs/Kconfig
> +++ b/fs/xfs/Kconfig
> @@ -22,6 +22,24 @@ config XFS_FS
>  	  system of your root partition is compiled as a module, you'll need
>  	  to use an initial ramdisk (initrd) to boot.
>  
> +config XFS_SUPPORT_V4
> +	bool "Support deprecated V4 format"
> +	default y
> +	help
> +	  The V4 filesystem format lacks certain features that are supported
> +	  by the V5 format, such as metadata checksumming, strengthened
> +	  metadata verification, and the ability to store timestamps past the
> +	  year 2038.  Because of this, the V4 format is deprecated.  All users
> +	  should upgrade by backing up their files, reformatting, and restoring
> +	  from the backup.
> +
> +	  This option will become default N in September 2025.  Support for the
> +	  V4 format will be removed entirely in September 2030.  Distributors
> +	  can say N here to withdraw support earlier.
> +
> +	  To continue supporting the old V4 format, say Y.
> +	  To close off an attack surface, say N.
> +
>  config XFS_QUOTA
>  	bool "XFS Quota support"
>  	depends on XFS_FS
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index ed69c4bfda71..48c0175b9457 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -315,6 +315,17 @@ xfs_readsb(
>  		goto release_buf;
>  	}
>  
> +#ifndef CONFIG_XFS_SUPPORT_V4
> +	/* V4 support is undergoing deprecation. */
> +	if (!xfs_sb_version_hascrc(sbp)) {
> +		if (loud)
> +			xfs_warn(mp,
> +	"Deprecated V4 format not supported by kernel.");
> +		error = -EINVAL;
> +		goto release_buf;
> +	}
> +#endif

Fine by me.

You forgot to add the V4 format to the deprecation schedule in
Documentation/filesystems/.....

<nggggh>

(where TF has this bit of XFS documentation been moved to???)

in Documentation/admin-guide/xfs.rst.

-Dave.

[ Why did that file get moved rather than just linked from it's
original spot in all the -filesystem- documentation?  Can we move it
back, please, like all the other <filesystem>.rst files in
Documentation/filesystems/ ? ]


-- 
Dave Chinner
david@fromorbit.com
