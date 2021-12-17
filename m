Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2A33C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Dec 2021 20:30:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234328AbhLQUaF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Dec 2021 15:30:05 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54864 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233195AbhLQUaF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Dec 2021 15:30:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD2A4623BC
        for <linux-xfs@vger.kernel.org>; Fri, 17 Dec 2021 20:30:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 106D4C36AE2;
        Fri, 17 Dec 2021 20:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639773004;
        bh=8wxac0vsEbiC+LeN7Qt13rtbkELBYP992XUZVyherF8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tpW0+FqjA41q9uwghERmg7JPEyZEUDnzt+PFacFtwGt+U8OlBuwpiwtM75Hs3Ze2c
         lUpUpG4NadD0c/68cCnaCybsJLc31AT4DB0VspL/VO4fpoumNneQW2U9RgwgxlEHkj
         Qv05Zjow+Tp4L/NPrKSawRX0btQ5aVJClBgGUxKvZ3gKpVpOJ7isRXbF0aZgFmXoDe
         CEdaLBLMBD368vGS3uk/bnaQrXJjVg26rrff+ib6E1Y3nL1Y/lttXoi5cZMmT0zL8x
         28bzXivLUT9NtCghgEbjipf+Ng9f0FWs7EAGwCA+dIBWL9TGDCUFR9P5SViliMOisE
         CkyMtpnTgO9Iw==
Date:   Fri, 17 Dec 2021 12:30:03 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] mkfs: add configuration files for the last few LTS
 kernels
Message-ID: <20211217203003.GO27664@magnolia>
References: <20211217191046.GM27664@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211217191046.GM27664@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 17, 2021 at 11:10:46AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add some sample mkfs configuration files that capture the mkfs feature
> defaults at the time of the release of the last three upstream LTS
> kernels.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  include/builddefs.in |    1 +
>  mkfs/Makefile        |    6 +++++-
>  mkfs/lts_4.19.conf   |   13 +++++++++++++
>  mkfs/lts_5.10.conf   |   13 +++++++++++++
>  mkfs/lts_5.15.conf   |   13 +++++++++++++

NAK, this is missing a config file for 5.4.

Also Eric prodded me to add a comment to the default feature config
structure definition reminding people to keep the conffiles up to date.

v2 on its way...

--D

>  5 files changed, 45 insertions(+), 1 deletion(-)
>  create mode 100644 mkfs/lts_4.19.conf
>  create mode 100644 mkfs/lts_5.10.conf
>  create mode 100644 mkfs/lts_5.15.conf
> 
> diff --git a/include/builddefs.in b/include/builddefs.in
> index f10d1796..ca4b5fcc 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -66,6 +66,7 @@ DK_INC_DIR	= @includedir@/disk
>  PKG_MAN_DIR	= @mandir@
>  PKG_DOC_DIR	= @datadir@/doc/@pkg_name@
>  PKG_LOCALE_DIR	= @datadir@/locale
> +PKG_DATA_DIR	= @datadir@/@pkg_name@
>  
>  CC		= @cc@
>  BUILD_CC	= @BUILD_CC@
> diff --git a/mkfs/Makefile b/mkfs/Makefile
> index 811ba9db..04d17fdb 100644
> --- a/mkfs/Makefile
> +++ b/mkfs/Makefile
> @@ -9,19 +9,23 @@ LTCOMMAND = mkfs.xfs
>  
>  HFILES =
>  CFILES = proto.c xfs_mkfs.c
> +CFGFILES = lts_4.19.conf lts_5.10.conf lts_5.15.conf
>  
>  LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBPTHREAD) $(LIBBLKID) \
>  	$(LIBUUID) $(LIBINIH) $(LIBURCU)
>  LTDEPENDENCIES += $(LIBXFS) $(LIBXCMD) $(LIBFROG)
>  LLDFLAGS = -static-libtool-libs
>  
> -default: depend $(LTCOMMAND)
> +default: depend $(LTCOMMAND) $(CFGFILES)
>  
>  include $(BUILDRULES)
>  
>  install: default
>  	$(INSTALL) -m 755 -d $(PKG_ROOT_SBIN_DIR)
>  	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_ROOT_SBIN_DIR)
> +	$(INSTALL) -m 755 -d $(PKG_DATA_DIR)/mkfs
> +	$(INSTALL) -m 644 $(CFGFILES) $(PKG_DATA_DIR)/mkfs
> +
>  install-dev:
>  
>  -include .dep
> diff --git a/mkfs/lts_4.19.conf b/mkfs/lts_4.19.conf
> new file mode 100644
> index 00000000..74144790
> --- /dev/null
> +++ b/mkfs/lts_4.19.conf
> @@ -0,0 +1,13 @@
> +# V5 features that were the mkfs defaults when the upstream Linux 4.19 LTS
> +# kernel was released at the end of 2019.
> +
> +[metadata]
> +bigtime=0
> +crc=1
> +finobt=1
> +inobtcount=0
> +reflink=0
> +rmapbt=0
> +
> +[inode]
> +sparse=1
> diff --git a/mkfs/lts_5.10.conf b/mkfs/lts_5.10.conf
> new file mode 100644
> index 00000000..ac00960e
> --- /dev/null
> +++ b/mkfs/lts_5.10.conf
> @@ -0,0 +1,13 @@
> +# V5 features that were the mkfs defaults when the upstream Linux 5.10 LTS
> +# kernel was released at the end of 2020.
> +
> +[metadata]
> +bigtime=0
> +crc=1
> +finobt=1
> +inobtcount=0
> +reflink=1
> +rmapbt=0
> +
> +[inode]
> +sparse=1
> diff --git a/mkfs/lts_5.15.conf b/mkfs/lts_5.15.conf
> new file mode 100644
> index 00000000..32082958
> --- /dev/null
> +++ b/mkfs/lts_5.15.conf
> @@ -0,0 +1,13 @@
> +# V5 features that were the mkfs defaults when the upstream Linux 5.15 LTS
> +# kernel was released at the end of 2021.
> +
> +[metadata]
> +bigtime=1
> +crc=1
> +finobt=1
> +inobtcount=1
> +reflink=1
> +rmapbt=0
> +
> +[inode]
> +sparse=1
