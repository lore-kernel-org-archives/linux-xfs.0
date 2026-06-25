Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B534720E702
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 22:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782428281; cv=none; b=RM1JF7uTyyEQ14Q9HouhcT3S9E306cs4RvAVHQeCLo7dc4J6yRueG+tufhvM9gk+n4QQt9Hi3uj2ipcsd34ArI1lGQIVg0LnXKoNbfwfLLmMKXTji3O/4BcdH2O53T+bZdg9KbfJE62WbxvH3Fiv832498yQdbuVjheq+2HDuOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782428281; c=relaxed/simple;
	bh=n+e1+y2LyIABo6XUAA7bGRaxcrDi9FBAQ4fuPE9uSos=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aWLfFUXXcsizGyRrMoQ/lC3LSjyXwsMiWGxlrgDMvJim7mygdo8LlW4vo+yyKccOy7SEAdJPafhL5qF2KDw5wqSetV1nMK4mjYrp0cd3BFHR5q2zwwpUwsrmCuWoJfkx1MU5m4fyMtMp0g146z2QVfegP+QC5Zw/cv5kKEmhNe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MTQG7hfK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MTQG7hfK"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4EDEA1F000E9;
	Thu, 25 Jun 2026 22:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782428279;
	bh=0trF6vaacZTCAUiEbQRbGrJ3OCS34Krd87FmxptT3kc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MTQG7hfKe7NdS03KLW5T2BFtxobRjMFwCY3TGCsIYfHjOOPaQGPdRJWIgKxmxAXI8
	 kmKHpIDu/OdZftFPbgjeXpWiW/XaQEt8fCvnyYxd63+QKga0Dz/ol6vBg2EvgBfCOJ
	 2o6fM2hqP5s+tljwzLhPrik3ALiujFAVlgJU3eaBV/7pyNfSD6TskGLwIMM5xQmaqB
	 fdum2EDYDBh5m+Rco+P0f+yo3l4webOHpiVtNefOMcNYQLi9RapBo8n+AzlJT9QCuH
	 IU04H7zZPELiAe78H+nXRXZIiDaJmyWoNzDq2TkfWkEoyxXI9Bd2kQz6vws8WUQYrJ
	 doYoAn5N67YOw==
Date: Thu, 25 Jun 2026 15:57:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: vmfunc <celeste@collar.sh>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH] xfsdump: avoid false-positive __strcpy_chk abort on long
 dirent names
Message-ID: <20260625225758.GN6078@frogsfrogsfrogs>
References: <20260625222337.54449-1-celeste@collar.sh>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625222337.54449-1-celeste@collar.sh>

On Thu, Jun 25, 2026 at 03:23:37PM -0700, vmfunc wrote:
> direnthdr_t and direnthdr_v1_t end in dh_name[6], which is used as a
> trailing variable-length buffer rather than a fixed six-byte field.
> dump_dirent() allocates each record with malloc(sz), where
> 
> 	sz = offsetofmember(direnthdr*_t, dh_name) + namelen + 1
> 
> (rounded up to DIRENTHDR_ALIGN), and the "sz > direntbufsz" check ahead
> of the copy guarantees the allocation is large enough to hold the name.
> The declared [6] is part of the on-media record layout: DIRENTHDR_SZ and
> the arch translation paths depend on it, so it cannot simply be turned
> into a [] flexible array member.
> 
> When xfsdump is built with _FORTIFY_SOURCE together with
> -fstrict-flex-arrays (increasingly the default in distributions), the
> trailing dh_name[6] is no longer treated as a flexible array.
> __builtin_object_size() sizes it to 6, strcpy() is rewritten to
> __strcpy_chk(dst, src, 6), and dumping any directory entry whose name is
> longer than five bytes aborts at runtime:
> 
> 	*** buffer overflow detected ***: terminated
> 	#4  __fortify_fail
> 	#5  __chk_fail
> 	#6  __strcpy_chk
> 	#7  dump_dirent
> 
> The copy is in fact safe; only fortify's notion of the destination size
> is wrong. Write the name through the byte offset dump_dirent() already
> computes, (char *)dhdrp + name_offset, instead of through the sized
> dh_name lvalue. The destination is then a plain char * into the malloc'd
> record, which fortify cannot sub-object-size, so the spurious check is
> dropped while the rest of the binary keeps its hardening.
> 
> Signed-off-by: vmfunc <celeste@collar.sh>
> ---
> Andrey Albershteyn (Cc'd) tested this with fstests on the downstream
> report and asked that it be sent upstream; the discussion and original
> backtrace are at https://github.com/NixOS/nixpkgs/pull/533325 .
> 
>  dump/content.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/dump/content.c b/dump/content.c
> index 6462267..8d482cc 100644
> --- a/dump/content.c
> +++ b/dump/content.c
> @@ -5151,14 +5151,14 @@ dump_dirent(drive_t *drivep,
>  		dhdrp->dh_sz = (uint16_t)sz;
>  		dhdrp->dh_gen = (uint16_t)(gen & DENTGENMASK);
>  		if (name) {
> -			strcpy(dhdrp->dh_name, name);
> +			strcpy((char *)dhdrp + name_offset, name);
>  		}
>  
>  		dhdrp->dh_checksum = calc_checksum(dhdrp, DIRENTHDR_SZ);
>  
>  		xlate_direnthdr_v1(dhdrp, tmpdhdrp, 1);
>  		if (name) {
> -			strcpy(tmpdhdrp->dh_name, name);
> +			strcpy((char *)tmpdhdrp + name_offset, name);

Why wouldn't you fix the structure definitions to use the proper VLA
syntax (dh_name[]) instead of making the code less readable?

--D

>  		}
>  	} else {
>  		direnthdr_t *dhdrp = (direnthdr_t *)contextp->cc_mdirentbufp;
> @@ -5169,14 +5169,14 @@ dump_dirent(drive_t *drivep,
>  		dhdrp->dh_gen = gen;
>  		dhdrp->dh_sz = (uint16_t)sz;
>  		if (name) {
> -			strcpy(dhdrp->dh_name, name);
> +			strcpy((char *)dhdrp + name_offset, name);
>  		}
>  
>  		dhdrp->dh_checksum = calc_checksum(dhdrp, DIRENTHDR_SZ);
>  
>  		xlate_direnthdr(dhdrp, tmpdhdrp, 1);
>  		if (name) {
> -			strcpy(tmpdhdrp->dh_name, name);
> +			strcpy((char *)tmpdhdrp + name_offset, name);
>  		}
>  	}
>  
> -- 
> 2.54.0
> 
> 
