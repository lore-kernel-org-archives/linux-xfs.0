Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D813C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Feb 2021 19:20:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2929464E31
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Feb 2021 19:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbhBVTTx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Feb 2021 14:19:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:50554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233014AbhBVTQ1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Feb 2021 14:16:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FDD9650AE;
        Mon, 22 Feb 2021 18:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614019171;
        bh=qT8ZeYdrk8QUQW+gf0TjAN6smsy8jrNbT3wISCeC0As=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qsBLpFUQh3NKcBKy7QUYCwacZnaSb2RsDPF/KxfFdQuouxw37cuE4DqIbxqaUD8nF
         zyafBSldfC6Vkp/VBHVxa9l3CRp8sKsyOlshEQdN4q5fIrpK1E9Nh4I3lz5Rc06u1B
         N/HbM9liU8LrNfEOsRgLMbMht6sPWqMeP8K7/InOFAf85l9BYQUGYU7c4XvMjAJPrc
         sWgbRy8iRtval0F+Xc9EzbKXrzkXUdLGT2DmB1AspEyCuVE596ihDl1lxcAZEiCiic
         95z1h3xZ1MpHmRbAH0iz2PEind7FDzzYtJ2AxFnCamlADwyC7BDqoVw3SECfAqMcqa
         AxPnwQh4xvHNg==
Date:   Mon, 22 Feb 2021 10:39:31 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Bastian Germann <bastiangermann@fishpost.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] debian: Build-depend on libinih-dev with udeb
 package
Message-ID: <20210222183931.GC7272@magnolia>
References: <20210221093946.3473-1-bastiangermann@fishpost.de>
 <20210221093946.3473-3-bastiangermann@fishpost.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210221093946.3473-3-bastiangermann@fishpost.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Feb 21, 2021 at 10:39:46AM +0100, Bastian Germann wrote:
> The first libinih Debian package version with udeb binary package is 53-1.
> Debian bug #981662 documents the need for it:
> xfsprogs-udeb depends on libinih1, not libinih1-udeb
> 
> Link: https://bugs.debian.org/981662
> Signed-off-by: Bastian Germann <bastiangermann@fishpost.de>

Oops, yeah... :(

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  debian/changelog | 3 +++
>  debian/control   | 2 +-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/debian/changelog b/debian/changelog
> index 679fbf03..8738ab90 100644
> --- a/debian/changelog
> +++ b/debian/changelog
> @@ -3,6 +3,9 @@ xfsprogs (5.11.0-rc0-1) experimental; urgency=medium
>    [ Steve Langasek ]
>    * Regenerate config.guess using debhelper
>  
> +  [ Bastian Germann ]
> +  * Build-depend on libinih-dev with udeb package
> +
>   -- Bastian Germann <bastiangermann@fishpost.de>  Sat, 20 Feb 2021 11:57:31 +0100
>  
>  xfsprogs (5.10.0-3) unstable; urgency=medium
> diff --git a/debian/control b/debian/control
> index 1da8093d..e4ec897c 100644
> --- a/debian/control
> +++ b/debian/control
> @@ -3,7 +3,7 @@ Section: admin
>  Priority: optional
>  Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
>  Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>, Bastian Germann <bastiangermann@fishpost.de>
> -Build-Depends: libinih-dev, uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, pkg-config
> +Build-Depends: libinih-dev (>= 53), uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, pkg-config
>  Standards-Version: 4.0.0
>  Homepage: https://xfs.wiki.kernel.org/
>  
> -- 
> 2.30.1
> 
