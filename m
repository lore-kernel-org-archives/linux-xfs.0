Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18FDE173
	for <linux-xfs@vger.kernel.org>; Thu, 28 May 2026 05:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779944459; cv=none; b=aI70vR3BIbrzo4EzXuAr9RXycFyDrXm6Vl8mwHtQqExbjyBDNSwyfdhvEPURGzNow4itqRMK8LZBH89tSNxq3cnbO1evT6m7djUuVJjGyjYfGN9LTTx/+9QU6XPmSFXod3oSxOGXzqTjtqfdzVltThJgBPVeuIbtHvS5s0fM2Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779944459; c=relaxed/simple;
	bh=1pQXO+UuP2jg1u0sA4ElE6h1EY6ZHESGSwypD4uu62w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hr1eZvbvhIcv6kMni+N67rXBukcdy6T51uzgynZQHzNU8E46vgxeZfuNiINCDlkYq/SoHRzhPeq9Y4u6G+yrFAmaOMKgcZGyITQra9LcXnb57PIpBEzLJN9AdrVQIB8UGndHzfOMf6emdsVmt2L+xH17umejum0sitSKuVZf6yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Smfj17Zg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Smfj17Zg"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A307E1F000E9;
	Thu, 28 May 2026 05:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779944457;
	bh=JNY5nBgSdW+P7F0wS7nsNSCl1S3ptDjSjdA4bdaecgE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Smfj17Zg2g2GoH6imQwpLf1CUN+JeGUbPJSc7Z6SgTrqd5rs0MiJhwyl/lm/lhJ3+
	 4XXOmoOlr0CKc8+PrhSTgpozku3KRoD4i9CyxvL9i4xIT0+hN2b7vDvdCeOSHD5tUw
	 HxB0hxIjbyCN/1NKyt7K/lUnAcMriPseFWFhLzyKRoKoBI8U0Ia+8jmR2+qpEu8aLx
	 SZLErUtA42d0BOKJM4FhnAn6Aa5Bg5N5ibIZ3Aqi35q3EeteZJevguWjatVU1XCAI6
	 QOpwCgtiS0IArZayHheRQ3iEidjPf56SDvf1POhPCWsDVGurFbDy5Q7BJb2Hkjob5L
	 UFeqf2vZnU/Og==
Date: Wed, 27 May 2026 22:00:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: sandeen@sandeen.net, aalbersh@kernel.org, dgc@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH v2 4/5] xfs_admin: add -d option to manage default
 mkfs config file
Message-ID: <20260528050057.GF6078@frogsfrogsfrogs>
References: <20260525075752.4159504-1-lukas@herbolt.com>
 <20260525075752.4159504-5-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260525075752.4159504-5-lukas@herbolt.com>

On Mon, May 25, 2026 at 09:57:51AM +0200, Lukas Herbolt wrote:
> Add -d <file> to install a config file as the system-wide mkfs.xfs
> default, and -d clear to remove it. The default config directory is
> substituted at build time from the configured sysconfdir. The
> xfs_admin.sh is now generated from xfs_admin.sh.in to set the default
> config file location bsed on the ./configure.
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> ---
>  .gitignore                           |  3 +++
>  db/Makefile                          | 11 ++++++++--
>  db/{xfs_admin.sh => xfs_admin.sh.in} | 30 ++++++++++++++++++++++++++--
>  3 files changed, 40 insertions(+), 4 deletions(-)
>  rename db/{xfs_admin.sh => xfs_admin.sh.in} (70%)
> 
> diff --git a/.gitignore b/.gitignore
> index eb3decd108be..fc695dbbd0b1 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -89,3 +89,6 @@ cscope.*
>  # docs
>  /man/man8/mkfs.xfs.8
>  /man/man8/xfs_scrub_all.8
> +
> +#generated bash
> +db/xfs_admin.sh
> diff --git a/db/Makefile b/db/Makefile
> index e36e775eee60..b9016d2a057b 100644
> --- a/db/Makefile
> +++ b/db/Makefile
> @@ -67,7 +67,8 @@ CFILES = $(HFILES:.h=.c) \
>  	iunlink.c \
>  	rdump.c \
>  	timelimit.c
> -LSRCFILES = xfs_admin.sh xfs_ncheck.sh xfs_metadump.sh
> +LSRCFILES = xfs_admin.sh.in xfs_ncheck.sh xfs_metadump.sh
> +LDIRT = xfs_admin.sh
>  
>  LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBURCU) \
>  	  $(LIBPTHREAD)
> @@ -79,10 +80,16 @@ LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
>  CFLAGS += -DENABLE_EDITLINE
>  endif
>  
> -default: depend $(LTCOMMAND)
> +default: depend $(LTCOMMAND) xfs_admin.sh
>  
>  include $(BUILDRULES)
>  
> +xfs_admin.sh: xfs_admin.sh.in $(TOPDIR)/include/builddefs
> +	@echo "    [SED]    $@"
> +	$(Q)$(SED) -e "s|@mkfs_syscfg_dir@|$(MKFS_SYSCFG_DIR)|g" \
> +		< $< > $@
> +	$(Q)chmod a+x $@
> +
>  install: default
>  	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
>  	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
> diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh.in
> similarity index 70%
> rename from db/xfs_admin.sh
> rename to db/xfs_admin.sh.in
> index 52a658ba4a54..e87a64467662 100755
> --- a/db/xfs_admin.sh
> +++ b/db/xfs_admin.sh.in
> @@ -13,11 +13,37 @@ REPAIR_OPTS=""
>  IO_OPTS=""
>  REPAIR_DEV_OPTS=""
>  LOG_OPTS=""
> -USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-O v5_feature] [-r rtdev] [-U uuid] device [logdev]"
> +MKFS_DEFAULT_CFGDIR="@mkfs_syscfg_dir@"
> +MKFS_DEFAULT_CFGFILE="$MKFS_DEFAULT_CFGDIR/default.conf"
> +USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-d file|clear] [-L label] [-O v5_feature] [-r rtdev] [-U uuid] device [logdev]"
>  
> -while getopts "c:efjlL:O:pr:uU:V" c
> +while getopts "c:d:efjlL:O:pr:uU:V" c
>  do
>  	case $c in
> +	d)	if [ "$OPTARG" = "clear" ]; then

I wish this were a long option (e.g. xfs_admin --set-defaults /root/my.cfg)
but I don't have a clue how to do this in bash.

> +			rm -f "$MKFS_DEFAULT_CFGFILE"
> +			status=$?
> +			if [ $status -eq 0 ]; then
> +				echo "Removed $MKFS_DEFAULT_CFGFILE"
> +			else
> +				echo "xfs_admin: failed to remove $MKFS_DEFAULT_CFGFILE" 1>&2
> +			fi
> +		else
> +			if [ ! -f "$OPTARG" ]; then
> +				echo "xfs_admin: cannot read '$OPTARG'" 1>&2

Shouldn't this be -r(eadable) not -f(ile path exists) given the error
message?

This new functionality also needs a manpage update.

--D

> +				exit 2
> +			fi
> +			mkdir -p "$MKFS_DEFAULT_CFGDIR" &&
> +			cp "$OPTARG" "$MKFS_DEFAULT_CFGFILE"
> +			status=$?
> +			if [ $status -eq 0 ]; then
> +				echo "Installed $OPTARG as $MKFS_DEFAULT_CFGFILE"
> +			else
> +				echo "xfs_admin: failed to install $MKFS_DEFAULT_CFGFILE" 1>&2
> +			fi
> +		fi
> +		exit $status
> +		;;
>  	c)	REPAIR_OPTS=$REPAIR_OPTS" -c lazycount="$OPTARG
>  		require_offline=1
>  		;;
> -- 
> 2.54.0
> 
> 
