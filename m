Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B5F1AF69B
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 18:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718908446; cv=none; b=ppeZ7wTGLHhpg/BJea9IdXmY6MUePCQ+/ywWUiNJfcOQgdRwKad94gAoHZIm0AiieuJcbfdvA3i7oSEdoH5DtOfXIkd4Tgf4nKkIShlOKLYzSxRaxYOh4dgLs/YrLrPZLURi7aBWTid/pWpnZ1UMY9kBsdIZWmv2ZiSKNWkiR5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718908446; c=relaxed/simple;
	bh=B+Ef4n7JxGZ4hML7SaMybbMQZExbvSin9crIwm15KkI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BVUZ1+JRvMde1+XNxxDRmmJYTGrAcWeRcK6DcpZHv3iXjhzd74meQ3uREBOBVnKAsnKGuKQQ1wNCrOJZGsav+oIPnEhdXiGmdGFQsObf/1m/WZaNCskCy4i/SH/2enN+STst3bzwcowH4JsXeijE+yAmLZi4e1wbsa3nARxbB2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RDhMhIGA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RDhMhIGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2BDC4AF0B;
	Thu, 20 Jun 2024 18:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718908445;
	bh=B+Ef4n7JxGZ4hML7SaMybbMQZExbvSin9crIwm15KkI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RDhMhIGAjjRHUnkFR5xSaqtkppM2C/SHYEa4WbpfjFMxrBv4mTWtn3ejslXOBskuQ
	 PRmyadMRyxFgPj39CGs+puQriHj8eRzWieYwZxXXbxrwx02MfmEF+AN/+FI4fy9MGt
	 l/hA99qeeBJmqjiqCxesJuALEztJoO9icPqYrWsaNuo4hEMwFvEcGLmp+tBtqFfY2c
	 isjH01KHdRFa0+J3zYPTfuOKtHLDrqVZ1L3YNO901fwtPpmSByc+4SQxTNo4UQ6+SM
	 ZshtLq0Mm2QMwvw0N4h6TqVdbKBId3o2jZ+TNkMqL7YtLvDEjOk5JxosOuGNGwDKJI
	 vTtvP+EePXk2Q==
Date: Thu, 20 Jun 2024 11:34:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chris Hofstaedtler <zeha@debian.org>
Cc: linux-xfs@vger.kernel.org, Bastian Germann <bage@debian.org>
Subject: Re: [PATCH v3] Remove support for split-/usr installs
Message-ID: <20240620183404.GX103034@frogsfrogsfrogs>
References: <20240612200330.GG2764752@frogsfrogsfrogs>
 <20240619214843.183235-1-zeha@debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240619214843.183235-1-zeha@debian.org>

On Wed, Jun 19, 2024 at 11:48:43PM +0200, Chris Hofstaedtler wrote:
> Always install binaries and other files under /usr, not /.  This will
> break any distribution that hasn't yet merged the two, which are
> vanishingly small these days.  This breaks the usecase of needing to
> repair the /usr partition when there is no initramfs or livecd
> available and / is the only option.
> 
> Signed-off-by: Chris Hofstaedtler <zeha@debian.org>

Sorry I missed that on the first run... the new xfslibs-dev/xfsprogs
package paths are comparable to what got built before this patch.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> 
> V1 -> V2: remove root_sbindir, root_libdir, PKG_ROOT_SBIN_DIR,
>           PKG_ROOT_LIB_DIR
> 
> V2 -> V3: fix debian-specific installation logic, i.e. do not
>           delete /usr/lib in xfslibs-dev
> 
>  configure.ac                | 21 ---------------------
>  debian/Makefile             |  4 ++--
>  debian/local/initramfs.hook |  2 +-
>  debian/rules                |  5 ++---
>  fsck/Makefile               |  4 ++--
>  include/builddefs.in        |  2 --
>  include/buildmacros         | 20 ++++++++++----------
>  mkfs/Makefile               |  4 ++--
>  repair/Makefile             |  4 ++--
>  9 files changed, 21 insertions(+), 45 deletions(-)
> 
> diff --git a/configure.ac b/configure.ac
> index da30fc5c..4530f387 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -113,27 +113,6 @@ esac
>  #
>  test -n "$multiarch" && enable_lib64=no
>  
> -#
> -# Some important tools should be installed into the root partitions.
> -#
> -# Check whether exec_prefix=/usr: and install them to /sbin in that
> -# case.  If the user chooses a different prefix assume they just want
> -# a local install for testing and not a system install.
> -#
> -case $exec_prefix:$prefix in
> -NONE:NONE | NONE:/usr | /usr:*)
> -  root_sbindir='/sbin'
> -  root_libdir="/${base_libdir}"
> -  ;;
> -*)
> -  root_sbindir="${sbindir}"
> -  root_libdir="${libdir}"
> -  ;;
> -esac
> -
> -AC_SUBST([root_sbindir])
> -AC_SUBST([root_libdir])
> -
>  # Find localized files.  Don't descend into any "dot directories"
>  # (like .git or .pc from quilt).  Strangely, the "-print" argument
>  # to "find" is required, to avoid including such directories in the
> diff --git a/debian/Makefile b/debian/Makefile
> index cafe8bbb..2f9cd38c 100644
> --- a/debian/Makefile
> +++ b/debian/Makefile
> @@ -31,6 +31,6 @@ endif
>  
>  install-d-i: default
>  ifeq ($(PKG_DISTRIBUTION), debian)
> -	$(INSTALL) -m 755 -d $(PKG_ROOT_SBIN_DIR)
> -	$(INSTALL) -m 755 $(BOOT_MKFS_BIN) $(PKG_ROOT_SBIN_DIR)/mkfs.xfs
> +	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
> +	$(INSTALL) -m 755 $(BOOT_MKFS_BIN) $(PKG_SBIN_DIR)/mkfs.xfs
>  endif
> diff --git a/debian/local/initramfs.hook b/debian/local/initramfs.hook
> index 5b24eaec..eac7e79e 100644
> --- a/debian/local/initramfs.hook
> +++ b/debian/local/initramfs.hook
> @@ -45,7 +45,7 @@ rootfs_type() {
>  . /usr/share/initramfs-tools/hook-functions
>  
>  if [ "$(rootfs_type)" = "xfs" ]; then
> -	copy_exec /sbin/xfs_repair
> +	copy_exec /usr/sbin/xfs_repair
>  	copy_exec /usr/sbin/xfs_db
>  	copy_exec /usr/sbin/xfs_metadump
>  fi
> diff --git a/debian/rules b/debian/rules
> index 0c1cef92..0db0ed8e 100755
> --- a/debian/rules
> +++ b/debian/rules
> @@ -105,9 +105,8 @@ binary-arch: checkroot built
>  	$(pkgme)  $(MAKE) dist
>  	install -D -m 0755 debian/local/initramfs.hook debian/xfsprogs/usr/share/initramfs-tools/hooks/xfs
>  	rmdir debian/xfslibs-dev/usr/share/doc/xfsprogs
> -	rm -f debian/xfslibs-dev/lib/$(DEB_HOST_MULTIARCH)/libhandle.la
> -	rm -f debian/xfslibs-dev/lib/$(DEB_HOST_MULTIARCH)/libhandle.a
> -	rm -fr debian/xfslibs-dev/usr/lib
> +	rm -f debian/xfslibs-dev/usr/lib/$(DEB_HOST_MULTIARCH)/libhandle.la
> +	rm -f debian/xfslibs-dev/usr/lib/$(DEB_HOST_MULTIARCH)/libhandle.a
>  	dh_installdocs -XCHANGES
>  	dh_installchangelogs
>  	dh_strip
> diff --git a/fsck/Makefile b/fsck/Makefile
> index da9b6ded..5ca529f5 100644
> --- a/fsck/Makefile
> +++ b/fsck/Makefile
> @@ -12,6 +12,6 @@ default: $(LTCOMMAND)
>  include $(BUILDRULES)
>  
>  install: default
> -	$(INSTALL) -m 755 -d $(PKG_ROOT_SBIN_DIR)
> -	$(INSTALL) -m 755 xfs_fsck.sh $(PKG_ROOT_SBIN_DIR)/fsck.xfs
> +	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
> +	$(INSTALL) -m 755 xfs_fsck.sh $(PKG_SBIN_DIR)/fsck.xfs
>  install-dev:
> diff --git a/include/builddefs.in b/include/builddefs.in
> index 644ed1cb..6ac36c14 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -48,8 +48,6 @@ datarootdir	= @datarootdir@
>  top_builddir	= @top_builddir@
>  
>  PKG_SBIN_DIR	= @sbindir@
> -PKG_ROOT_SBIN_DIR = @root_sbindir@
> -PKG_ROOT_LIB_DIR= @root_libdir@@libdirsuffix@
>  PKG_LIB_DIR	= @libdir@@libdirsuffix@
>  PKG_LIBEXEC_DIR	= @libexecdir@/@pkg_name@
>  PKG_INC_DIR	= @includedir@/xfs
> diff --git a/include/buildmacros b/include/buildmacros
> index 6f34d7c5..9183e5bc 100644
> --- a/include/buildmacros
> +++ b/include/buildmacros
> @@ -50,16 +50,16 @@ LTINSTALL = $(LIBTOOL) --quiet --mode=install $(INSTALL)
>  LTCOMPILE = $(LIBTOOL) --quiet --tag=CC --mode=compile $(CCF)
>  
>  ifeq ($(ENABLE_SHARED),yes)
> -LTLDFLAGS += -rpath $(PKG_ROOT_LIB_DIR)
> +LTLDFLAGS += -rpath $(PKG_LIB_DIR)
>  LTLDFLAGS += -version-info $(LTVERSION)
>  endif
>  
>  ifeq ($(ENABLE_SHARED),yes)
>  INSTALL_LTLIB = \
>  	cd $(TOPDIR)/$(LIBNAME)/.libs; \
> -	../$(INSTALL) -m 755 -d $(PKG_ROOT_LIB_DIR); \
> -	../$(INSTALL) -m 755 -T so_dot_version $(LIBNAME).lai $(PKG_ROOT_LIB_DIR); \
> -	../$(INSTALL) -T so_dot_current $(LIBNAME).lai $(PKG_ROOT_LIB_DIR)
> +	../$(INSTALL) -m 755 -d $(PKG_LIB_DIR); \
> +	../$(INSTALL) -m 755 -T so_dot_version $(LIBNAME).lai $(PKG_LIB_DIR); \
> +	../$(INSTALL) -T so_dot_current $(LIBNAME).lai $(PKG_LIB_DIR)
>  endif
>  
>  # Libtool thinks the static and shared libs should be in the same dir, so
> @@ -74,13 +74,13 @@ INSTALL_LTLIB_DEV = \
>  	../$(INSTALL) -m 755 -d $(PKG_LIB_DIR); \
>  	../$(INSTALL) -m 644 -T old_lib $(LIBNAME).lai $(PKG_LIB_DIR); \
>  	../$(INSTALL) -m 644 $(LIBNAME).lai $(PKG_LIB_DIR)/$(LIBNAME).la ; \
> -	../$(INSTALL) -m 755 -d $(PKG_ROOT_LIB_DIR); \
> -	../$(INSTALL) -T so_base $(LIBNAME).lai $(PKG_ROOT_LIB_DIR); \
> +	../$(INSTALL) -m 755 -d $(PKG_LIB_DIR); \
> +	../$(INSTALL) -T so_base $(LIBNAME).lai $(PKG_LIB_DIR); \
>  	if [ "x$(shell readlink -f $(PKG_LIB_DIR))" != \
> -	     "x$(shell readlink -f $(PKG_ROOT_LIB_DIR))" ]; then \
> -		../$(INSTALL) -S $(PKG_LIB_DIR)/$(LIBNAME).a $(PKG_ROOT_LIB_DIR)/$(LIBNAME).a; \
> -		../$(INSTALL) -S $(PKG_LIB_DIR)/$(LIBNAME).la $(PKG_ROOT_LIB_DIR)/$(LIBNAME).la; \
> -		../$(INSTALL) -S $(PKG_ROOT_LIB_DIR)/$(LIBNAME).so $(PKG_LIB_DIR)/$(LIBNAME).so; \
> +	     "x$(shell readlink -f $(PKG_LIB_DIR))" ]; then \
> +		../$(INSTALL) -S $(PKG_LIB_DIR)/$(LIBNAME).a $(PKG_LIB_DIR)/$(LIBNAME).a; \
> +		../$(INSTALL) -S $(PKG_LIB_DIR)/$(LIBNAME).la $(PKG_LIB_DIR)/$(LIBNAME).la; \
> +		../$(INSTALL) -S $(PKG_LIB_DIR)/$(LIBNAME).so $(PKG_LIB_DIR)/$(LIBNAME).so; \
>  	fi
>  else
>  INSTALL_LTLIB_DEV = $(INSTALL_LTLIB_STATIC)
> diff --git a/mkfs/Makefile b/mkfs/Makefile
> index a0c168e3..a6173083 100644
> --- a/mkfs/Makefile
> +++ b/mkfs/Makefile
> @@ -28,8 +28,8 @@ default: depend $(LTCOMMAND) $(CFGFILES)
>  include $(BUILDRULES)
>  
>  install: default
> -	$(INSTALL) -m 755 -d $(PKG_ROOT_SBIN_DIR)
> -	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_ROOT_SBIN_DIR)
> +	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
> +	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
>  	$(INSTALL) -m 755 -d $(MKFS_CFG_DIR)
>  	$(INSTALL) -m 644 $(CFGFILES) $(MKFS_CFG_DIR)
>  
> diff --git a/repair/Makefile b/repair/Makefile
> index e5014deb..c5b0d4cb 100644
> --- a/repair/Makefile
> +++ b/repair/Makefile
> @@ -99,8 +99,8 @@ include $(BUILDRULES)
>  #CFLAGS += ...
>  
>  install: default
> -	$(INSTALL) -m 755 -d $(PKG_ROOT_SBIN_DIR)
> -	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_ROOT_SBIN_DIR)
> +	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
> +	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
>  install-dev:
>  
>  -include .dep
> -- 
> 2.39.2
> 
> 
