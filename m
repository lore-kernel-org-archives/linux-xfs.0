Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F8F8C433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Oct 2021 18:27:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7917061350
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Oct 2021 18:27:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238536AbhJDS3G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Oct 2021 14:29:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:45408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238408AbhJDS3F (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Oct 2021 14:29:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A5C261251;
        Mon,  4 Oct 2021 18:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633372036;
        bh=8JV65sOclkNQ2qNAy8qV3I5iLlxJid7VCXdqKISgAOs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UfZeb2mDA6B98lLgOqZPK0Eu8tgeDii4B+R8sjRApoZNEctA8Qys7u+1mzAh6GCQ0
         SqXH61zXRBskLXxfCXtOo1ex37zUB2rnapycj0TF+537jam4NORCYz018aszbIi7+O
         6GbBmYMSJIbCOcKg7Eo393IIl2y8ZPWnmsyfJZ6wLA7P+BLGy08K9my8Qkrg1ybq6M
         iqJ6QqnQHBdf/ecRYPRknCMl0xQU0zeUfGXKUrMle4UJOI+3JnPcYnJBAURIQIzeZo
         wBBbEs9IdcP5PFbJhZHHA1zXllnnx8cuJHIsJGuQV81j10R7qLd+l2nQiWAtmM6Og+
         5O6LcqaXQaG/w==
Date:   Mon, 4 Oct 2021 11:27:16 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Bastian Germann <bastiangermann@fishpost.de>
Cc:     linux-xfs@vger.kernel.org, Bastian Germann <bage@debian.org>,
        Helmut Grohne <helmut@subdivi.de>
Subject: Re: [PATCH 2/3] debian: Pass --build and --host to configure
Message-ID: <20211004182716.GC24307@magnolia>
References: <20210928002552.10517-1-bage@debian.org>
 <20210928002552.10517-3-bage@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928002552.10517-3-bage@debian.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 27, 2021 at 02:25:51AM +0200, Bastian Germann wrote:
> xfsprogs fails to cross build because it fails to pass --host to configure.
> Thus it selects the build architecture as host architecture and fails
> configure, because the requested libraries are only installed for the host
> architecture.
> 
> Link: https://bugs.debian.org/794158
> Reported-by: Helmut Grohne <helmut@subdivi.de>
> Signed-off-by: Bastian Germann <bage@debian.org>

Thanks for fixing this longstanding bug. :/

/me has had a similar patch (that keeps falling out of my tree because I
don't do cross builds all that often) so...

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  debian/changelog | 8 ++++++++
>  debian/rules     | 9 +++++++--
>  2 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/debian/changelog b/debian/changelog
> index 4f09e2ca..8b5c6037 100644
> --- a/debian/changelog
> +++ b/debian/changelog
> @@ -1,3 +1,11 @@
> +xfsprogs (5.13.0-2) unstable; urgency=medium
> +
> +  [ Helmut Grohne ]
> +  * Fix FTCBFS (Closes: #794158)
> +    + Pass --build and --host to configure
> +
> + -- Bastian Germann <bage@debian.org>  Tue, 28 Sep 2021 00:42:50 +0200
> +
>  xfsprogs (5.13.0-1) unstable; urgency=medium
>  
>    * New upstream release
> diff --git a/debian/rules b/debian/rules
> index fe9a1c3a..e12814b3 100755
> --- a/debian/rules
> +++ b/debian/rules
> @@ -11,6 +11,9 @@ package = xfsprogs
>  develop = xfslibs-dev
>  bootpkg = xfsprogs-udeb
>  
> +DEB_BUILD_GNU_TYPE ?= $(shell dpkg-architecture -qDEB_BUILD_GNU_TYPE)
> +DEB_HOST_GNU_TYPE ?= $(shell dpkg-architecture -qDEB_HOST_GNU_TYPE)
> +
>  version = $(shell dpkg-parsechangelog | grep ^Version: | cut -d ' ' -f 2 | cut -d '-' -f 1)
>  target ?= $(shell dpkg-architecture -qDEB_HOST_ARCH)
>  udebpkg = $(bootpkg)_$(version)_$(target).udeb
> @@ -23,11 +26,13 @@ pkgdev = DIST_ROOT=`pwd`/$(dirdev); export DIST_ROOT;
>  pkgdi  = DIST_ROOT=`pwd`/$(dirdi); export DIST_ROOT;
>  stdenv = @GZIP=-q; export GZIP;
>  
> +configure_options = --build=$(DEB_BUILD_GNU_TYPE) --host=$(DEB_HOST_GNU_TYPE)
> +
>  options = export DEBUG=-DNDEBUG DISTRIBUTION=debian \
>  	  INSTALL_USER=root INSTALL_GROUP=root \
> -	  LOCAL_CONFIGURE_OPTIONS="--enable-editline=yes --enable-blkid=yes --disable-ubsan --disable-addrsan --disable-threadsan --enable-lto" ;
> +	  LOCAL_CONFIGURE_OPTIONS="$(configure_options) --enable-editline=yes --enable-blkid=yes --disable-ubsan --disable-addrsan --disable-threadsan --enable-lto" ;
>  diopts  = $(options) \
> -	  export OPTIMIZER=-Os LOCAL_CONFIGURE_OPTIONS="--enable-gettext=no --disable-ubsan --disable-addrsan --disable-threadsan --enable-lto" ;
> +	  export OPTIMIZER=-Os LOCAL_CONFIGURE_OPTIONS="$(configure_options) --enable-gettext=no --disable-ubsan --disable-addrsan --disable-threadsan --enable-lto" ;
>  checkdir = test -f debian/rules
>  
>  build: build-arch build-indep
> -- 
> 2.33.0
> 
