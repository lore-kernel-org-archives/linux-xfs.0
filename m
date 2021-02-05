Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB54EC433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Feb 2021 00:49:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CD6264F3F
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Feb 2021 00:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbhBEAtU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Feb 2021 19:49:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:58878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232240AbhBEAtR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Feb 2021 19:49:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0A8364F3F;
        Fri,  5 Feb 2021 00:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612486116;
        bh=pRxpQKs2JRphwv7JZspzEZCOcOeZ08I7l60JpmYl0oA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oZ4xjmuSmciQXvq2hyJ8rTMaR/fuCN9SIHDz5XR/+2uxPNgK+ciUVXQ2BYGPkZVUL
         Oa+h9qpPnEGbUYiKPhCBJDBjsna9tqRnmAa49S1ejmls/GFEo+Xy/VURg4xAz7+LIz
         QaDCIhY6EbgaZBn3l45aMl/77A7/CPqoxzfQPRdZ3GlMNEGXvbWBIskHBEgHs4XH15
         jFrG3tu7G9jtmjxZ8JdVIlhCdjj9UmQBUo9MNJHkBtosmKrOSTWxdqA0be6Fn3QUbp
         THnuzQ8CBWBXA+5Bm33ArZRqkxVx8uEZ9p7MCASWuNv5n5YjS6cTuw7RgqErO+qLRb
         8DIwQvKFGjzkw==
Date:   Thu, 4 Feb 2021 16:48:32 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Bastian Germann <bastiangermann@fishpost.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] debian: Only build for Linux
Message-ID: <20210205004832.GI7193@magnolia>
References: <20210205003125.24463-1-bastiangermann@fishpost.de>
 <20210205003125.24463-3-bastiangermann@fishpost.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210205003125.24463-3-bastiangermann@fishpost.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 05, 2021 at 01:31:24AM +0100, Bastian Germann wrote:
> Use architecture linux-any to exclude kfreebsd and hurd from building
> the package. Those will always fail.
> 
> Signed-off-by: Bastian Germann <bastiangermann@fishpost.de>

Yep, we dropped support for hurd and bsd and macos a while ago...

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  debian/changelog | 1 +
>  debian/control   | 6 +++---
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/debian/changelog b/debian/changelog
> index 7b0120c2..2da58f30 100644
> --- a/debian/changelog
> +++ b/debian/changelog
> @@ -1,6 +1,7 @@
>  xfsprogs (5.10.0-3) unstable; urgency=medium
>  
>    * Drop unused dh-python from Build-Depends (Closes: #981361)
> +  * Only build for Linux
>  
>   -- Bastian Germann <bastiangermann@fishpost.de>  Fri, 05 Feb 2021 00:18:31 +0100
>  
> diff --git a/debian/control b/debian/control
> index 8975bd13..1da8093d 100644
> --- a/debian/control
> +++ b/debian/control
> @@ -13,7 +13,7 @@ Provides: fsck-backend
>  Suggests: xfsdump, acl, attr, quota
>  Breaks: xfsdump (<< 3.0.0)
>  Replaces: xfsdump (<< 3.0.0)
> -Architecture: any
> +Architecture: linux-any
>  Description: Utilities for managing the XFS filesystem
>   A set of commands to use the XFS filesystem, including mkfs.xfs.
>   .
> @@ -31,7 +31,7 @@ Package: xfslibs-dev
>  Section: libdevel
>  Depends: libc6-dev | libc-dev, uuid-dev, xfsprogs (>= 3.0.0), ${misc:Depends}
>  Breaks: xfsprogs (<< 3.0.0)
> -Architecture: any
> +Architecture: linux-any
>  Description: XFS filesystem-specific static libraries and headers
>   xfslibs-dev contains the libraries and header files needed to
>   develop XFS filesystem-specific programs.
> @@ -49,7 +49,7 @@ Description: XFS filesystem-specific static libraries and headers
>  Package: xfsprogs-udeb
>  Package-Type: udeb
>  Section: debian-installer
> -Architecture: any
> +Architecture: linux-any
>  Depends: ${shlibs:Depends}, ${misc:Depends}
>  Description: A stripped-down version of xfsprogs, for debian-installer
>   This package is an xfsprogs package built for reduced size, so that it
> -- 
> 2.30.0
> 
