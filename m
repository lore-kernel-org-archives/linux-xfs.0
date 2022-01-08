Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B614C433EF
	for <linux-xfs@archiver.kernel.org>; Sat,  8 Jan 2022 23:23:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbiAHXXl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 8 Jan 2022 18:23:41 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40698 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbiAHXXl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 8 Jan 2022 18:23:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F9FF60EA9
        for <linux-xfs@vger.kernel.org>; Sat,  8 Jan 2022 23:23:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78296C36AE9;
        Sat,  8 Jan 2022 23:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641684220;
        bh=iGxN0NFemHXe6rtknE8RkcJDEQ+nI+Hka/OCK+F3gB4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hHkbry4t+s05Upqr9mcbkJrBfSeJgk2NB/b+RWp5iDmf+IHtzk9jxLtbb/0qyyFaY
         215BokWkF9WYfN0bnd6ivr9dS5nMXoux8MZ3wBcBA5Dqjy9aYT/i7Y2gVfb9gsbuwE
         j3uOi40j8cSf31oA99X+eECeZOFi5MGS+kJWKgSxXTIrIvT76ur/HbKW9/lQWB9UaO
         v0I03it7qaYvVB0K3cIkXt6br1GnolK1OnetEfiWoPL5w0Q5h0kLL1d5qJYLj5pGAT
         yZt1uNc6vFQHJklMGsXa0wEEdytteSRRS78XKycvZpMT72ESI1cdZTahttVuN9aDIr
         qQpCwySaWfojg==
Date:   Sat, 8 Jan 2022 15:23:38 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsprogs: fix static build problems caused by liburcu
Message-ID: <20220108232338.GV656707@magnolia>
References: <20220108195739.1212901-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220108195739.1212901-1-tytso@mit.edu>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 08, 2022 at 02:57:39PM -0500, Theodore Ts'o wrote:
> The liburcu library has a dependency on pthreads.  Hence, in order for
> static builds of xfsprogs to work, $(LIBPTHREAD) needs to appear
> *after* $(LUBURCU) in LLDLIBS.  Otherwise, static links of xfs_* will
> fail due to undefined references of pthread_create, pthread_exit,
> et. al.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Ugh, I keep forgetting that ld wants library dependencies in reverse
order nowadays...

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  copy/Makefile      | 4 ++--
>  db/Makefile        | 4 ++--
>  growfs/Makefile    | 4 ++--
>  logprint/Makefile  | 4 ++--
>  mdrestore/Makefile | 3 +--
>  mkfs/Makefile      | 4 ++--
>  repair/Makefile    | 2 +-
>  scrub/Makefile     | 4 ++--
>  8 files changed, 14 insertions(+), 15 deletions(-)
> 
> diff --git a/copy/Makefile b/copy/Makefile
> index 1b00cd0d..55160f84 100644
> --- a/copy/Makefile
> +++ b/copy/Makefile
> @@ -9,8 +9,8 @@ LTCOMMAND = xfs_copy
>  CFILES = xfs_copy.c
>  HFILES = xfs_copy.h
>  
> -LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBPTHREAD) $(LIBRT) \
> -	  $(LIBURCU)
> +LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBURCU) \
> +	  $(LIBPTHREAD)
>  LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG) $(LIBFROG)
>  LLDFLAGS = -static-libtool-libs
>  
> diff --git a/db/Makefile b/db/Makefile
> index 5c017898..b2e01174 100644
> --- a/db/Makefile
> +++ b/db/Makefile
> @@ -18,8 +18,8 @@ CFILES = $(HFILES:.h=.c) btdump.c btheight.c convert.c info.c namei.c \
>  	timelimit.c
>  LSRCFILES = xfs_admin.sh xfs_ncheck.sh xfs_metadump.sh
>  
> -LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD) \
> -	  $(LIBURCU)
> +LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBURCU) \
> +	  $(LIBPTHREAD)
>  LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG) $(LIBFROG)
>  LLDFLAGS += -static-libtool-libs
>  
> diff --git a/growfs/Makefile b/growfs/Makefile
> index 08601de7..2f4cc66a 100644
> --- a/growfs/Makefile
> +++ b/growfs/Makefile
> @@ -9,8 +9,8 @@ LTCOMMAND = xfs_growfs
>  
>  CFILES = xfs_growfs.c
>  
> -LLDLIBS = $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD) \
> -	  $(LIBURCU)
> +LLDLIBS = $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBURCU) \
> +	  $(LIBPTHREAD)
>  
>  ifeq ($(ENABLE_EDITLINE),yes)
>  LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
> diff --git a/logprint/Makefile b/logprint/Makefile
> index cdedbd0d..bbbed5d2 100644
> --- a/logprint/Makefile
> +++ b/logprint/Makefile
> @@ -12,8 +12,8 @@ CFILES = logprint.c \
>  	 log_copy.c log_dump.c log_misc.c \
>  	 log_print_all.c log_print_trans.c log_redo.c
>  
> -LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD) \
> -	  $(LIBURCU)
> +LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBURCU) \
> +	  $(LIBPTHREAD)
>  LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG) $(LIBFROG)
>  LLDFLAGS = -static-libtool-libs
>  
> diff --git a/mdrestore/Makefile b/mdrestore/Makefile
> index 8f28ddab..4a932efb 100644
> --- a/mdrestore/Makefile
> +++ b/mdrestore/Makefile
> @@ -8,8 +8,7 @@ include $(TOPDIR)/include/builddefs
>  LTCOMMAND = xfs_mdrestore
>  CFILES = xfs_mdrestore.c
>  
> -LLDLIBS = $(LIBXFS) $(LIBFROG) $(LIBRT) $(LIBPTHREAD) $(LIBUUID) \
> -	  $(LIBURCU)
> +LLDLIBS = $(LIBXFS) $(LIBFROG) $(LIBRT) $(LIBUUID) $(LIBURCU) $(LIBPTHREAD)
>  LTDEPENDENCIES = $(LIBXFS) $(LIBFROG)
>  LLDFLAGS = -static
>  
> diff --git a/mkfs/Makefile b/mkfs/Makefile
> index 811ba9db..9f6a4fad 100644
> --- a/mkfs/Makefile
> +++ b/mkfs/Makefile
> @@ -10,8 +10,8 @@ LTCOMMAND = mkfs.xfs
>  HFILES =
>  CFILES = proto.c xfs_mkfs.c
>  
> -LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBPTHREAD) $(LIBBLKID) \
> -	$(LIBUUID) $(LIBINIH) $(LIBURCU)
> +LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBBLKID) \
> +	$(LIBUUID) $(LIBINIH) $(LIBURCU) $(LIBPTHREAD)
>  LTDEPENDENCIES += $(LIBXFS) $(LIBXCMD) $(LIBFROG)
>  LLDFLAGS = -static-libtool-libs
>  
> diff --git a/repair/Makefile b/repair/Makefile
> index 47536ca1..2c40e59a 100644
> --- a/repair/Makefile
> +++ b/repair/Makefile
> @@ -72,7 +72,7 @@ CFILES = \
>  	xfs_repair.c
>  
>  LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBXCMD) $(LIBFROG) $(LIBUUID) $(LIBRT) \
> -	$(LIBPTHREAD) $(LIBBLKID) $(LIBURCU)
> +	$(LIBBLKID) $(LIBURCU) $(LIBPTHREAD)
>  LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG) $(LIBXCMD) $(LIBFROG)
>  LLDFLAGS = -static-libtool-libs
>  
> diff --git a/scrub/Makefile b/scrub/Makefile
> index 849e3afd..fd6bb679 100644
> --- a/scrub/Makefile
> +++ b/scrub/Makefile
> @@ -71,8 +71,8 @@ spacemap.c \
>  vfs.c \
>  xfs_scrub.c
>  
> -LLDLIBS += $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD) $(LIBICU_LIBS) $(LIBRT) \
> -	$(LIBURCU)
> +LLDLIBS += $(LIBHANDLE) $(LIBFROG) $(LIBICU_LIBS) $(LIBRT) $(LIBURCU) \
> +	$(LIBPTHREAD)
>  LTDEPENDENCIES += $(LIBHANDLE) $(LIBFROG)
>  LLDFLAGS = -static
>  
> -- 
> 2.31.0
> 
