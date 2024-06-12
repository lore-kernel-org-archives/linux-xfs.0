Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7ED61822DD
	for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2024 18:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718215724; cv=none; b=WvB80XburNHK4yR5v5lucDS1GBpiVaQBB8iYU4CaNYqjgpaAbFWgP7OXNiCXHPO3iRDgTZ/o6r39s1eTSwHEKQL2abXryEqx6UQBBaaPB1fPasks4t7qUhpG6uyY5TbARfGmO2A/ExkpMcw/859GwZ9KTKw9kQ3qmhQfhD+ggbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718215724; c=relaxed/simple;
	bh=mmNsv6dd2F4COLLX36lo0cwJCpfE8O2h9nAom7doC+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l2Chi61OpIACFu1AyvCTyMHnz8X1+DrJckhK22t5GyVEuJ2qJgJkMtwWfaiYxS6oGfl17uGUibihmTLzHEl+cpxVkNT2KQx2LfNRSpqCAqg2XefR3qfW9KKW3tzunepcDPss33UW6uETJYh1EBLSESbVieq+CO+fvT/aPlB6VlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OWatKE51; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OWatKE51"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF83C116B1;
	Wed, 12 Jun 2024 18:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718215724;
	bh=mmNsv6dd2F4COLLX36lo0cwJCpfE8O2h9nAom7doC+E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OWatKE5107xtMRbltUb7NudK+02gqy0DDMGHG3ZSAeH91fe+Vnm7oDkR+9mWaD5Bq
	 9FIksh9v1sHp3r5302Z9poE9KwJslOrnLd7IivtVmmaqdaTIB+79I0ZBODKSzlGIiO
	 K8SY12gbmZluji8NBxPSMcPV6azWgTnVkEV1ooyeOd4Eon6ivnjkY6Yhnv3Z1f6yck
	 axlPlB3mwxcmSsAgN0Tti7cxejMwf2up5PmaLGTSs0D4q0b/6O7iUB9sCscB1bsuNv
	 Nzu4t8MT32j8NABlcFaFOnTgmOd0bYl/5CWNvobEc8/4fTmMfhb5KYAcRyZbNowGXG
	 vJB6p9/SmgGjQ==
Date: Wed, 12 Jun 2024 11:08:43 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Bastian Germann <bage@debian.org>
Cc: linux-xfs@vger.kernel.org, Chris Hofstaedtler <zeha@debian.org>
Subject: Re: [PATCH 1/1] Install files into UsrMerged layout
Message-ID: <20240612180843.GE2764752@frogsfrogsfrogs>
References: <20240612173551.6510-1-bage@debian.org>
 <20240612173551.6510-2-bage@debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240612173551.6510-2-bage@debian.org>

On Wed, Jun 12, 2024 at 07:35:05PM +0200, Bastian Germann wrote:
> From: Chris Hofstaedtler <zeha@debian.org>
> 
> Signed-off-by: Chris Hofstaedtler <zeha@debian.org>
> Signed-off-by: Bastian Germann <bage@debian.org>
> ---
>  configure.ac                | 19 ++-----------------
>  debian/local/initramfs.hook |  2 +-
>  2 files changed, 3 insertions(+), 18 deletions(-)
> 
> diff --git a/configure.ac b/configure.ac
> index da30fc5c..a532d90d 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -113,23 +113,8 @@ esac
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
> +root_sbindir="${sbindir}"
> +root_libdir="${libdir}"

Should we get rid of $root_sbindir, $root_libdir, PKG_ROOT_LIB_DIR, and
PKG_ROOT_SBIN_DIR while we're at it?  That will break anyone who hasn't
done the /usr merge yet, but how many distros still want
/sbin/xfs_repair?  opensuse and the rhel variants seem to have moved
that to /usr/sbin/ years ago.

--D

>  
>  AC_SUBST([root_sbindir])
>  AC_SUBST([root_libdir])
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
> -- 
> 2.45.2
> 
> 
