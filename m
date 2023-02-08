Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D37C4C05027
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Feb 2023 16:35:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbjBHQfI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Feb 2023 11:35:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbjBHQfI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Feb 2023 11:35:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357724C6E2
        for <linux-xfs@vger.kernel.org>; Wed,  8 Feb 2023 08:34:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 889DC6172A
        for <linux-xfs@vger.kernel.org>; Wed,  8 Feb 2023 16:34:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE47EC433D2;
        Wed,  8 Feb 2023 16:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675874088;
        bh=FIF4aXs9ASyDJZ+d0wLabNiU1Ext/usAcpi+HVZQs3o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pLST+KUIEyVLCncAMuLreaRXfv9fpJ0S8B22iYCMWr6jSS4BS2t+QWMXZ5SN8cYBF
         CNG1zdARiBuutvvKL/ZeXkrfElCu8LoHZMYaKnFr4ouRlsSTzqjMZphA0r/aPqyYoE
         8T3Xi5woDRPJSdEyOf1C3Foh6a2fFk5dFOVOIPx5IWUDEnxj2zbBsCCpe9JkrBc/UX
         4MXLnkwWo9XtlZboDE8YN6C32RRuFHEUYbCP/fWs2y1RI5WI1X7yaVRkzhlqSglSt2
         kos2Wg9riMI5go0SB2NvnZMqFrXqJGv5WOiImfDr1+b0jyITR+ey6y4/suBY0RbkyG
         VVegBcp+qHD3A==
Date:   Wed, 8 Feb 2023 08:34:48 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Arjun Shankar <arjun@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] Remove several implicit function declarations
Message-ID: <Y+PPKBlzv6+DNfBf@magnolia>
References: <20230208143416.425941-1-arjun@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208143416.425941-1-arjun@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 08, 2023 at 03:34:16PM +0100, Arjun Shankar wrote:
> During configure, several ioctl checks omit the corresponding include
> and a pwritev2 check uses the wrong feature test macro.
> This commit fixes the same.
> 
> Signed-off-by: Arjun Shankar <arjun@redhat.com>
> ---
> We ran into these when trying to port Fedora to modern C:
> 
> https://fedoraproject.org/wiki/Changes/PortingToModernC
> https://fedoraproject.org/wiki/Toolchain/PortingToModernC
> 
> v2 notes: Removed the changes to unicrash.c;
>           it was already fixed by 5ead2de386d879
> ---
>  m4/package_libcdev.m4 | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
> index bb1ab49c..f987aa4a 100644
> --- a/m4/package_libcdev.m4
> +++ b/m4/package_libcdev.m4
> @@ -117,6 +117,7 @@ AC_DEFUN([AC_HAVE_FIEMAP],
>  #define _GNU_SOURCE
>  #include <linux/fs.h>
>  #include <linux/fiemap.h>
> +#include <sys/ioctl.h>
>  	]], [[
>  struct fiemap *fiemap;
>  ioctl(0, FS_IOC_FIEMAP, (unsigned long)fiemap);
> @@ -153,7 +154,7 @@ AC_DEFUN([AC_HAVE_PWRITEV2],
>    [ AC_MSG_CHECKING([for pwritev2])
>      AC_LINK_IFELSE(
>      [	AC_LANG_PROGRAM([[
> -#define _BSD_SOURCE
> +#define _GNU_SOURCE

Could you update the pwritev2 manpage to document that _GNU_SOURCE is
the feature test macro for pwritev2?

>  #include <sys/uio.h>
>  	]], [[
>  pwritev2(0, 0, 0, 0, 0);
> @@ -454,6 +455,7 @@ AC_DEFUN([AC_HAVE_SG_IO],
>      AC_COMPILE_IFELSE(
>      [	AC_LANG_PROGRAM([[
>  #include <scsi/sg.h>
> +#include <sys/ioctl.h>
>  	]], [[
>  struct sg_io_hdr hdr;
>  ioctl(0, SG_IO, &hdr);
> @@ -471,7 +473,8 @@ AC_DEFUN([AC_HAVE_HDIO_GETGEO],
>    [ AC_MSG_CHECKING([for struct hd_geometry ])
>      AC_COMPILE_IFELSE(
>      [	AC_LANG_PROGRAM([[
> -#include <linux/hdreg.h>,

Gosh, how did that ever work with the trailing comma??

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +#include <linux/hdreg.h>
> +#include <sys/ioctl.h>
>  	]], [[
>  struct hd_geometry hdr;
>  ioctl(0, HDIO_GETGEO, &hdr);
> -- 
> 2.38.1
> 
