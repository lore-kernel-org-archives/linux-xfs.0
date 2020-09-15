Return-Path: <SRS0=4rV+=CY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD34AC43461
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 22:33:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8156D20872
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 22:33:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbgIOWdx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Sep 2020 18:33:53 -0400
Received: from sandeen.net ([63.231.237.45]:45356 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727047AbgIOWdv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 Sep 2020 18:33:51 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 644BF504E17;
        Tue, 15 Sep 2020 17:33:03 -0500 (CDT)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Brian Foster <bfoster@redhat.com>
References: <20200911164311.GU7955@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v3] xfs: deprecate the V4 format
Message-ID: <08bc8f6d-edb8-740f-1804-9f2c63344ea4@sandeen.net>
Date:   Tue, 15 Sep 2020 17:33:46 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200911164311.GU7955@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/11/20 11:43 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The V4 filesystem format contains known weaknesses in the on-disk format
> that make metadata verification diffiult.  In addition, the format will

Editorial nitpicks you are free to take or leave:

drop "will" 

> does not support dates past 2038 and will not be upgraded to do so.
> Therefore, we should start the process of retiring the old format to
> close off attack surfaces and to encourage users to migrate onto V5.
> 
> Therefore, make XFS V4 support a configurable option.  For the first

Too many "Therefores":

"This patch makes XFS V4 support a ..."

> period it will be default Y in case some distributors want to withdraw
> support early; for the second period it will be default N so that anyone
> who wishes to continue support can do so; and after that, support will
> be removed from the kernel.

Maybe something like:

"Dates for these events are added to the XFS documentation in the kernel."

In any case,

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v3: be a little more helpful about old xfsprogs and warn more loudly
> about deprecation
> v2: define what is a V4 filesystem, update the administrator guide
> ---
>  Documentation/admin-guide/xfs.rst |   23 +++++++++++++++++++++++
>  fs/xfs/Kconfig                    |   24 ++++++++++++++++++++++++
>  fs/xfs/xfs_super.c                |   13 +++++++++++++
>  3 files changed, 60 insertions(+)
> 
> diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
> index f461d6c33534..b6deea9ec073 100644
> --- a/Documentation/admin-guide/xfs.rst
> +++ b/Documentation/admin-guide/xfs.rst
> @@ -210,6 +210,28 @@ When mounting an XFS filesystem, the following options are accepted.
>  	inconsistent namespace presentation during or after a
>  	failover event.
>  
> +Deprecation of V4 Format
> +========================
> +
> +The V4 filesystem format lacks certain features that are supported by
> +the V5 format, such as metadata checksumming, strengthened metadata
> +verification, and the ability to store timestamps past the year 2038.
> +Because of this, the V4 format is deprecated.  All users should upgrade
> +by backing up their files, reformatting, and restoring from the backup.
> +
> +Administrators and users can detect a V4 filesystem by running xfs_info
> +against a filesystem mountpoint and checking for a string beginning with
> +"crc=".  If no such string is found, please upgrade xfsprogs to the
> +latest version and try again.
> +
> +The deprecation will take place in two parts.  Support for mounting V4
> +filesystems can now be disabled at kernel build time via Kconfig option.
> +The option will default to yes until September 2025, at which time it
> +will be changed to default to no.  In September 2030, support will be
> +removed from the codebase entirely.
> +
> +Note: Distributors may choose to withdraw V4 format support earlier than
> +the dates listed above.
>  
>  Deprecated Mount Options
>  ========================
> @@ -217,6 +239,7 @@ Deprecated Mount Options
>  ===========================     ================
>    Name				Removal Schedule
>  ===========================     ================
> +Mounting with V4 filesystem     September 2030
>  ===========================     ================
>  
>  
> diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
> index e685299eb3d2..5422227e9e93 100644
> --- a/fs/xfs/Kconfig
> +++ b/fs/xfs/Kconfig
> @@ -22,6 +22,30 @@ config XFS_FS
>  	  system of your root partition is compiled as a module, you'll need
>  	  to use an initial ramdisk (initrd) to boot.
>  
> +config XFS_SUPPORT_V4
> +	bool "Support deprecated V4 (crc=0) format"
> +	default y
> +	help
> +	  The V4 filesystem format lacks certain features that are supported
> +	  by the V5 format, such as metadata checksumming, strengthened
> +	  metadata verification, and the ability to store timestamps past the
> +	  year 2038.  Because of this, the V4 format is deprecated.  All users
> +	  should upgrade by backing up their files, reformatting, and restoring
> +	  from the backup.
> +
> +	  Administrators and users can detect a V4 filesystem by running
> +	  xfs_info against a filesystem mountpoint and checking for a string
> +	  beginning with "crc=".  If the string "crc=0" is found, the
> +	  filesystem is a V4 filesystem.  If no such string is found, please
> +	  upgrade xfsprogs to the latest version and try again.
> +
> +	  This option will become default N in September 2025.  Support for the
> +	  V4 format will be removed entirely in September 2030.  Distributors
> +	  can say N here to withdraw support earlier.
> +
> +	  To continue supporting the old V4 format (crc=0), say Y.
> +	  To close off an attack surface, say N.
> +
>  config XFS_QUOTA
>  	bool "XFS Quota support"
>  	depends on XFS_FS
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index febd61ba071d..e2250c6d7251 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1451,6 +1451,19 @@ xfs_fc_fill_super(
>  	if (error)
>  		goto out_free_sb;
>  
> +	/* V4 support is undergoing deprecation. */
> +	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
> +#ifdef CONFIG_XFS_SUPPORT_V4
> +		xfs_warn_once(mp,
> +	"Deprecated V4 format (crc=0) will not be supported after September 2030.");
> +#else
> +		xfs_warn(mp,
> +	"Deprecated V4 format (crc=0) not supported by kernel.");
> +		error = -EINVAL;
> +		goto out_free_sb;
> +#endif
> +	}
> +
>  	/*
>  	 * XFS block mappings use 54 bits to store the logical block offset.
>  	 * This should suffice to handle the maximum file size that the VFS
> 
