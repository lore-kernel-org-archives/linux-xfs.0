Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AF4DC433DB
	for <linux-xfs@archiver.kernel.org>; Sun, 21 Feb 2021 04:00:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C6F064E04
	for <linux-xfs@archiver.kernel.org>; Sun, 21 Feb 2021 04:00:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbhBUEAb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 20 Feb 2021 23:00:31 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:50066 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230162AbhBUEAb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 Feb 2021 23:00:31 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 623411040C67;
        Sun, 21 Feb 2021 14:59:44 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lDfuJ-00EYZb-Hu; Sun, 21 Feb 2021 14:59:43 +1100
Date:   Sun, 21 Feb 2021 14:59:43 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Bastian Germann <bastiangermann@fishpost.de>
Cc:     linux-xfs@vger.kernel.org, Dimitri John Ledkov <xnox@ubuntu.com>
Subject: Re: [PATCH 2/4] debian: Enable CET on amd64
Message-ID: <20210221035943.GJ4662@dread.disaster.area>
References: <20210220121610.3982-1-bastiangermann@fishpost.de>
 <20210220121610.3982-3-bastiangermann@fishpost.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210220121610.3982-3-bastiangermann@fishpost.de>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=fxJcL_dCAAAA:8 a=7-415B0cAAAA:8
        a=ljfmuPdE62EP-0x0UAoA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Feb 20, 2021 at 01:16:07PM +0100, Bastian Germann wrote:
> This is a change introduced in 5.6.0-1ubuntu3.
> 
> Reported-by: Dimitri John Ledkov <xnox@ubuntu.com>
> Signed-off-by: Bastian Germann <bastiangermann@fishpost.de>
> ---
>  debian/changelog | 1 +
>  debian/rules     | 8 +++++++-
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/debian/changelog b/debian/changelog
> index 8320a2e8..c77f04ab 100644
> --- a/debian/changelog
> +++ b/debian/changelog
> @@ -2,6 +2,7 @@ xfsprogs (5.11.0-rc0-1) experimental; urgency=medium
>  
>    [ Dimitri John Ledkov ]
>    * Drop trying to create upstream distribution
> +  * Enable CET on amd64
>  
>   -- Bastian Germann <bastiangermann@fishpost.de>  Sat, 20 Feb 2021 11:57:31 +0100
>  
> diff --git a/debian/rules b/debian/rules
> index 8a3345b6..dd093f2c 100755
> --- a/debian/rules
> +++ b/debian/rules
> @@ -23,8 +23,14 @@ pkgdev = DIST_ROOT=`pwd`/$(dirdev); export DIST_ROOT;
>  pkgdi  = DIST_ROOT=`pwd`/$(dirdi); export DIST_ROOT;
>  stdenv = @GZIP=-q; export GZIP;
>  
> +ifeq ($(target),amd64)
> +export DEB_CFLAGS_MAINT_APPEND=-fcf-protection
> +export DEB_LDFLAGS_MAINT_APPEND=-fcf-protection
> +endif
> +include /usr/share/dpkg/default.mk
> +
>  options = export DEBUG=-DNDEBUG DISTRIBUTION=debian \
> -	  INSTALL_USER=root INSTALL_GROUP=root \
> +	  INSTALL_USER=root INSTALL_GROUP=root LDFLAGS='$(LDFLAGS)' \
>  	  LOCAL_CONFIGURE_OPTIONS="--enable-editline=yes --enable-blkid=yes --disable-ubsan --disable-addrsan --disable-threadsan --enable-lto" ;
>  diopts  = $(options) \
>  	  export OPTIMIZER=-Os LOCAL_CONFIGURE_OPTIONS="--enable-gettext=no --disable-ubsan --disable-addrsan --disable-threadsan --enable-lto" ;

No. This is not the way to turn on build wide compiler/linker
options/protections.

IOWs, if you want to turn on control flow protections to make ROP
exploits harder (why that actually matters for xfsprogs is beyond
me), then it you need to add a configure option similar to
--enable-lto. Then it can actually be enabled and used by other
distros, not just Ubuntu, and it will also ensure that builds will
fail at configure time if the compiler/linker does not support this
functionality.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
