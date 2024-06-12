Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D9184A51
	for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2024 20:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718222612; cv=none; b=RLcsP5zAxsZWC9RhIJvxw3Xcltcqad/nDpmeI8aNSeCORS2XIrF1oFXRejn71fv632Lwbl/IpT7bpOdw7X0gXhcqZnCaln2URPSf9hdhsvQuFq9A08AhFTxpyjIxTYNIuRtXjfEDSMQ30eKRg00mnaFQonfWwfRAOouzDJOiXh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718222612; c=relaxed/simple;
	bh=9rNAuVVpTnqfQa2miXyPtIveJQ8z2Lu8feZkg/7sA4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EN6+szJLPVYICZfIItOIQcdfNpJI2sobk0wW11JPyNO6VxM2MQJBuIR1Pwaq604pbh0l6wyJ4ZCw8SQ+vChTTcliKCfZagnEBIQOBvRmubBICxPkbUhpoLUACMdYJsDXNfxjrIXZqC4e+qmD71zeTOE2aaHr2Dx+E1yUN9qxrpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QbrHo1z5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QbrHo1z5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B57C116B1;
	Wed, 12 Jun 2024 20:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718222611;
	bh=9rNAuVVpTnqfQa2miXyPtIveJQ8z2Lu8feZkg/7sA4g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QbrHo1z5d7ghVRRnx9QD4caMzeYYfmnaZS9WY5b+MDC1T2Yb9wHzBSjqUyAjuAFRa
	 /bFThLOIpFKB+AOkm0uDWJAb/jsHFAaweXIObPIjG4btmE/LHxcA42Cv8zvr2SUcnf
	 0kvdG0UZdvZUC+o69zEJvTNZCm5QT1t2krLZgcbb+pXOSvV4cn0A087xdYaEa/RL2P
	 YvyXYmrwg7aAAxsxoRwdyAV5ka3WJfPpY0dMbp19FZTrQIBBXgwmPi/NcuzshbECYH
	 ZgO1mMSOApmoQhAXvXYCXqZLB1CvP6nff2x0giWddwehKJER5VmJF6y8yG2R5UIHLE
	 jQKztNybEgg+A==
Date: Wed, 12 Jun 2024 13:03:30 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chris Hofstaedtler <zeha@debian.org>
Cc: linux-xfs@vger.kernel.org, Bastian Germann <bage@debian.org>
Subject: Re: [PATCH v2 1/1] Install files into UsrMerged layout
Message-ID: <20240612200330.GG2764752@frogsfrogsfrogs>
References: <20240612173551.6510-2-bage@debian.org>
 <xs47xj5jfbbap3324fwt753eimbe265i6wa2uhafcz5hsi6wnt@k6m3cwfvi4zh>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xs47xj5jfbbap3324fwt753eimbe265i6wa2uhafcz5hsi6wnt@k6m3cwfvi4zh>

On Wed, Jun 12, 2024 at 09:00:19PM +0200, Chris Hofstaedtler wrote:
> From: Chris Hofstaedtler <zeha@debian.org>
> 
> Signed-off-by: Chris Hofstaedtler <zeha@debian.org>

Hmm.  From what I can tell from the systemd.pc file in (Debian) sid, all
the systemd services and udev files will get put in
/usr/lib/systemd/system/ and /usr/lib/udev/.  Since those directories
are picked up by the xfsprogs build system via pkgconfig, there's no
need to patch that separately, right?

Also, this commit could use a brief message to acknowledge that we're
breaking the usecase of / and /usr being different filesystems:

"Always install binaries and other files under /usr, not /.  This will
break any distribution that hasn't yet merged the two, which are
vanishingly small these days.  This breaks the usecase of needing to
repair the /usr partition when there is no initramfs or livecd
available and / is the only option."

If the answer to the first question is 'yes' and the commit message is
acceptable,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> V1 -> V2: remove root_sbindir, root_libdir, PKG_ROOT_SBIN_DIR,
>           PKG_ROOT_LIB_DIR
> 
>  configure.ac                | 21 ---------------------
>  debian/Makefile             |  4 ++--
>  debian/local/initramfs.hook |  2 +-
>  fsck/Makefile               |  4 ++--
>  include/builddefs.in        |  2 --
>  include/buildmacros         | 20 ++++++++++----------
>  mkfs/Makefile               |  4 ++--
>  repair/Makefile             |  4 ++--
>  8 files changed, 19 insertions(+), 42 deletions(-)
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
