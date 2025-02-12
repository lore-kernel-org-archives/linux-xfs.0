Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27F7202F99
	for <linux-xfs@vger.kernel.org>; Wed, 12 Feb 2025 21:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739395218; cv=none; b=mrYDq3KMglGGoWpPUML4zOJ8h3VD+YTG9mwLa+llrAHVPXNbzmsZG9BN8/SXKyFUF8YAc+jbUlsHRms6u50O9+MnxPboLtsx9zP5L8OJ2hjKK0++cp01M+sX7x08/fuw4hx+0p2WWtOysDRKtdEtWkKtM3Uk+VQ1T5JyispBubU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739395218; c=relaxed/simple;
	bh=rBLQ/xBNNogSjz/XH7knmHpqbrwXgJEWEak/5azmV7Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k5H+MTTUuUT3q85d4AMHef0NwuDU34+smmLxE/FFNL0vRchIkrGc2lw+Z26npE5QXwIaktDjspYc6rU6eYLFalPO8mA8XtifctntCRdKp8j8qDPz8Jk1gzYvSWAOY/TgOLHMerwoN1vdbuIQC7bgR78d/9bl0qBefvwVVypBvOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m04Zcuku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m04Zcuku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27CDEC4CEE5;
	Wed, 12 Feb 2025 21:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739395218;
	bh=rBLQ/xBNNogSjz/XH7knmHpqbrwXgJEWEak/5azmV7Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m04ZcukuzCpLfe+6s160PvV4rK8PiPIF7SrNi8eSfKdivINJzPSp0300IlxK4ib45
	 FJOXSTN3d9qrQlOPlO1/a0hfT9STjrUr0R098qVaa47/ItpZOfCHDYYilHHhAGnkam
	 e7mokVUs1EWMzCZTz/KQmst16N3fZMMxT38ldi1g72wQZDgrcygRk5ofTXmYYN87du
	 qA6Zujt5i8axTixeSqCQkSRJUv3GogCviGyfgqjYiYyyIuk6OZel6qbKnv3q7DxOOW
	 NnhFMXIh9tuNDj/4HqYdRWGFbmNj4G9g70qLgf6jdK7j6A0e+KrOumwE4JTtCIJrrG
	 Q0zK4AS6oj7+A==
Date: Wed, 12 Feb 2025 13:20:17 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Alyssa Ross <hi@alyssa.is>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH xfsprogs] configure: additionally get icu-uc from
 pkg-config
Message-ID: <20250212212017.GK21808@frogsfrogsfrogs>
References: <20250212081649.3502717-1-hi@alyssa.is>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250212081649.3502717-1-hi@alyssa.is>

On Wed, Feb 12, 2025 at 09:16:49AM +0100, Alyssa Ross wrote:
> This fixes the following build error with icu 76, also seen by
> Fedora[1]:
> 
> 	/nix/store/9g4gsby96w4cx1i338kplaap0x37apdf-binutils-2.43.1/bin/ld: unicrash.o: undefined reference to symbol 'uiter_setString_76'
> 	/nix/store/9g4gsby96w4cx1i338kplaap0x37apdf-binutils-2.43.1/bin/ld: /nix/store/jbnm36wq89c7iws6xx6xvv75h0drv48x-icu4c-76.1/lib/libicuuc.so.76: error adding symbols: DSO missing from command line
> 	collect2: error: ld returned 1 exit status
> 	make[2]: *** [../include/buildrules:65: xfs_scrub] Error 1
> 	make[1]: *** [include/buildrules:35: scrub] Error 2
> 
> Link: https://src.fedoraproject.org/rpms/xfsprogs/c/624b0fdf7b2a31c1a34787b04e791eee47c97340 [1]
> Signed-off-by: Alyssa Ross <hi@alyssa.is>

Interesting that this pulls in libicuuc just fine without including
icu-uc.pc, at least on Debian 12:

$ grep LIBICU_LIBS build-x86_64/
build-x86_64/include/builddefs:222:LIBICU_LIBS = -licui18n -licuuc -licudata

Debian sid has the same icu 76 and (AFAICT) it still pulls in the
dependency:

Name: icu-i18n
Requires: icu-uc

Is there something different in Fedora nowadays?

I'm not opposed to this change, I'm wondering why there's a build
failure and how adding it explicitly to AC_HAVE_LIBICU fixes it.

--D

> ---
>  m4/package_icu.m4 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/m4/package_icu.m4 b/m4/package_icu.m4
> index 3ccbe0cc..6b89c874 100644
> --- a/m4/package_icu.m4
> +++ b/m4/package_icu.m4
> @@ -1,5 +1,5 @@
>  AC_DEFUN([AC_HAVE_LIBICU],
> -  [ PKG_CHECK_MODULES([libicu], [icu-i18n], [have_libicu=yes], [have_libicu=no])
> +  [ PKG_CHECK_MODULES([libicu], [icu-i18n icu-uc], [have_libicu=yes], [have_libicu=no])
>      AC_SUBST(have_libicu)
>      AC_SUBST(libicu_CFLAGS)
>      AC_SUBST(libicu_LIBS)
> 
> base-commit: 90d6da68ee54e6d4ef99eca4a82cac6036a34b00
> -- 
> 2.47.0
> 
> 
