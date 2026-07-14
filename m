Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CE542BC51
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 20:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784061957; cv=none; b=r/+3cbgWgDpOJ2ruRgMZk9MA7njELeNUejJN4uOKaM0Vf82FN84N68vhq1QTB4cDDAv0xFWHSvN6wR/r6TCpRjOSFWWajGDulO1sUqFcFW29pdCfRwrcoJ8GxizOHmSB1lcbSPDjHSOI3ks0Lv5u2ryTHan7I0vZ0Idl3zH0D6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784061957; c=relaxed/simple;
	bh=+A+anX6DCIeBdihYc/xSGP6z0wl60OuothgimM9rKUc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tK0dmdiA5wuDg2OhyHkWMaEGP9Prw0A9lkH8MW9cSpQTW7bclfChLYqYYE8/++Ut5ZBRvGBIsWWMN0G0uyR6KX7ifK511OOGVYqQcLjGPax0s07CP/c9T1zlSwxD5qV/jQpPc3e+nY29nkXs17R7ny31eg24knb13hD8Kd1L91k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YIVMBedd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YIVMBedd"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 945F21F000E9;
	Tue, 14 Jul 2026 20:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784061955;
	bh=R59nvVFHFL3ToGOOs/O8R5cS0hI4YCZEtXl7cgqO+Kk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YIVMBeddF2m4ZuD9KlPLbBzEWh4oiwuk0f6sJEuFpiM7bL+jVKDWniUuLmtph4hq7
	 HCOUP4Rod8giZzSc4R0qJY4HTVev0+HNn2l1UkUslCE/iY+AsCmerUkJP4POfLWOWC
	 1MhyL2HtAfABs3qH/fxNug4MDylVu9x2+2MbVHJsngxVGzQ8pUe8mKmSPne3ofMGVw
	 AOUbTe47+ihMwQOA2Ssbvv+iFgB4o2/2mDHck+oxMxPxnCO96pqIEcjs2SeU0ncflv
	 rKi4Fiq++WE1GhwBk3+JLzGFguQ9wcXfS18bxoKCq4mcbIgysEHME2AINIimIq3L8p
	 oAGZ9O0/M4/6A==
Date: Tue, 14 Jul 2026 13:45:54 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Allen Hewes <rallenh@hotmail.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: xfsprogs 7.1.0 LTINSTALL fix
Message-ID: <20260714204554.GK7380@frogsfrogsfrogs>
References: <465ea336301aafed0e392d668a23e34cca2e4324.camel@hotmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465ea336301aafed0e392d668a23e34cca2e4324.camel@hotmail.com>

On Tue, Jul 14, 2026 at 05:18:37PM +0000, Allen Hewes wrote:
> Hi!
> 
> I am not a member of the list.
> 
> I got local mock build error with xfsprogs 7.1.0:
> Installing healer-install
> ../install-sh -o root -g mock -m 755 -d /usr/libexec/xfsprogs
> /bin/sh ../libtool --quiet --mode=install ../install-sh -o root -g mock
> -m 755 xfs_healer xfs_healer_start /usr/libexec/xfsprogs
> Usage: /builddir/build/BUILD/xfsprogs-7.1.0-build/xfsprogs-
> 7.1.0/libtool [OPTION]... [MODE-ARG]...
> Try 'libtool --help' for more information.
> libtool:   error: '/usr/libexec/xfsprogs' is not a directory
> gmake[1]: *** [Makefile:72: install-healer] Error 1
> make: *** [Makefile:135: healer-install] Error 2
> error: Bad exit status from /var/tmp/rpm-tmp.YMwAaj (%install)
>     Bad exit status from /var/tmp/rpm-tmp.YMwAaj (%install)
> 
> RPM build errors:
> 
> I tracked this down to a recent change
> https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/commit/?id=79551362141a051faf9c3d504fe18ee34ca800f8
> and then worked from there.
> 
> It appears that LTINSTALL need a single target and not multiple
> targets. Here's a patch that let me mock build xfsprogs 7.1.0:

I guess that means libtool no longer just calls ../install-sh with
whatever parameters it's given?  Or perhaps just yours?  On my system:

$ libtool --version
libtool (GNU libtool) 2.5.4 Debian-2.5.4-4

It would be good to know if this is the result of gnu libtool changing
their CLI in a newer version; or some other libtool clone is in use; or
something else.

> diff -Nuarp xfsprogs-7.1.0.a/healer/Makefile xfsprogs-
> 7.1.0.b/healer/Makefile
> --- xfsprogs-7.1.0.a/healer/Makefile    2026-07-10 07:06:28.000000000 -
> 0400
> +++ xfsprogs-7.1.0.b/healer/Makefile    2026-07-14 13:08:18.106217736 -
> 0400
> @@ -69,7 +69,9 @@ install: $(INSTALL_HEALER)
>  
>  install-healer: default
>         $(INSTALL) -m 755 -d $(PKG_LIBEXEC_DIR)
> -       $(LTINSTALL) -m 755 $(BUILD_TARGETS) $(PKG_LIBEXEC_DIR)
> +       for f in $(BUILD_TARGETS); do \
> +               $(LTINSTALL) -m 755 $$f $(PKG_LIBEXEC_DIR); \
> +       done
>  
>  install-systemd: default
>         $(INSTALL) -m 755 -d $(SYSTEMD_SYSTEM_UNIT_DIR)
> 
> I will send as an attachment.
> 
> Thanks!

Thank you for sending a patch, but it needs a proper Signed-off-by: tag
before anyone can look at it.

https://docs.kernel.org/process/submitting-patches.html#developer-s-certificate-of-origin-1-1

--D

> 
> /allen

> diff -Nuarp xfsprogs-7.1.0.a/healer/Makefile xfsprogs-7.1.0.b/healer/Makefile
> --- xfsprogs-7.1.0.a/healer/Makefile	2026-07-10 07:06:28.000000000 -0400
> +++ xfsprogs-7.1.0.b/healer/Makefile	2026-07-14 13:08:18.106217736 -0400
> @@ -69,7 +69,9 @@ install: $(INSTALL_HEALER)
>  
>  install-healer: default
>  	$(INSTALL) -m 755 -d $(PKG_LIBEXEC_DIR)
> -	$(LTINSTALL) -m 755 $(BUILD_TARGETS) $(PKG_LIBEXEC_DIR)
> +	for f in $(BUILD_TARGETS); do \
> +		$(LTINSTALL) -m 755 $$f $(PKG_LIBEXEC_DIR); \
> +	done
>  
>  install-systemd: default
>  	$(INSTALL) -m 755 -d $(SYSTEMD_SYSTEM_UNIT_DIR)

