Return-Path: <SRS0=NqjT=CT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEE11C433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Sep 2020 20:47:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F8DF20829
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Sep 2020 20:47:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbgIJUr3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Sep 2020 16:47:29 -0400
Received: from sandeen.net ([63.231.237.45]:53548 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726913AbgIJUrW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 10 Sep 2020 16:47:22 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 7A8E9EF1;
        Thu, 10 Sep 2020 15:46:46 -0500 (CDT)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>
References: <20200910182706.GD7964@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfs: deprecate the V4 format
Message-ID: <f1cb76c7-9a23-36ab-4a25-a3bd344f77db@sandeen.net>
Date:   Thu, 10 Sep 2020 15:47:21 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200910182706.GD7964@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/10/20 1:27 PM, Darrick J. Wong wrote:
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

As Arekm pointed out, nobody outside of our clique knows what "V4" and "V5" means.

(there is no mention of such things in the mkfs.xfs(8) or xfs(5), for example)

admin-facing statements should probably reference CRC capability, not "V4/5"

-Eric

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
> +
>  	/*
>  	 * We must be able to do sector-sized and sector-aligned IO.
>  	 */
> 
