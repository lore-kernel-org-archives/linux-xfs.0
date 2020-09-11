Return-Path: <SRS0=CRyL=CU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0F94C43461
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Sep 2020 11:34:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A7AC21D79
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Sep 2020 11:34:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HNH/qdCR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725831AbgIKLez (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Sep 2020 07:34:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52828 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725779AbgIKLer (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Sep 2020 07:34:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599824049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8SjSwIK33bUa0ftIiXKgs4Cd9bFABsgB+IkJ7BMailc=;
        b=HNH/qdCR7BDMTNLscN5hUZdU1Y/qUdbQMmtEU8Wn81yGIi/E90ESUXZMTt9/EKO9rVOV1H
        xG9SostAjQCdjvGW7TyCkzvJ35S2uDSSVBkZOI+pBWf7pzeCNzZKyqM+93Iz1yeWpB0tJs
        cHQuKZ5wXGPZPtcoBA58yDFqisQtKz0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-IMO4gDv9OL2iuYi6gKrPHA-1; Fri, 11 Sep 2020 07:32:05 -0400
X-MC-Unique: IMO4gDv9OL2iuYi6gKrPHA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 027841009445;
        Fri, 11 Sep 2020 11:32:04 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7FED15C1BD;
        Fri, 11 Sep 2020 11:32:00 +0000 (UTC)
Date:   Fri, 11 Sep 2020 07:31:58 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v2] xfs: deprecate the V4 format
Message-ID: <20200911113158.GA1194939@bfoster>
References: <20200910224842.GR7955@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910224842.GR7955@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 10, 2020 at 03:48:42PM -0700, Darrick J. Wong wrote:
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
> v2: define what is a V4 filesystem, update the administrator guide
> ---

Seems reasonable to me...

>  Documentation/admin-guide/xfs.rst |   20 ++++++++++++++++++++
>  fs/xfs/Kconfig                    |   23 +++++++++++++++++++++++
>  fs/xfs/xfs_mount.c                |   11 +++++++++++
>  3 files changed, 54 insertions(+)
> 
> diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
> index f461d6c33534..68d69733a1df 100644
> --- a/Documentation/admin-guide/xfs.rst
> +++ b/Documentation/admin-guide/xfs.rst
> @@ -210,6 +210,25 @@ When mounting an XFS filesystem, the following options are accepted.
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
> +"crc=".  If the string "crc=0" is found, or no "crc=" string is found,
> +the filesystem is a V4 filesystem.
> +
> +The deprecation will take place in two parts.  Support for mounting V4
> +filesystems can now be disabled at kernel build time via Kconfig option.
> +The option will default to yes until September 2025, at which time it
> +will be changed to default to no.  In September 2030, support will be
> +removed from the codebase entirely.
>  
>  Deprecated Mount Options
>  ========================
> @@ -217,6 +236,7 @@ Deprecated Mount Options
>  ===========================     ================
>    Name				Removal Schedule
>  ===========================     ================
> +Mounting with V4 filesystem     September 2030
>  ===========================     ================
>  
>  
> diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
> index e685299eb3d2..5970d0f77db9 100644
> --- a/fs/xfs/Kconfig
> +++ b/fs/xfs/Kconfig
> @@ -22,6 +22,29 @@ config XFS_FS
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
> +	  beginning with "crc=".  If the string "crc=0" is found, or no "crc="
> +	  string is found, the filesystem is a V4 filesystem.
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
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index ed69c4bfda71..3678dfeecd64 100644
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
> +	"Deprecated V4 format (crc=0) not supported by kernel.");
> +		error = -EINVAL;
> +		goto release_buf;
> +	}
> +#endif
> +

Should we not have a (oneshot?) warning for systems that choose to
continue to support and use v4 filesystems? ISTM that's the best way to
ensure there's feedback on this change earlier rather than later, or
otherwise encourage such users to reformat with v5 at the next available
opportunity...

BTW, any reason this is in xfs_readsb() vs. xfs_fc_fill_super() where we
have various other version/feature checks and warnings?

Brian

>  	/*
>  	 * We must be able to do sector-sized and sector-aligned IO.
>  	 */
> 

