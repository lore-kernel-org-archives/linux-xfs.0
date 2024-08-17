Received: from helium.openadk.org (helium.openadk.org [89.238.66.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A09513E033
	for <linux-xfs@vger.kernel.org>; Sat, 17 Aug 2024 11:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.238.66.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723893463; cv=none; b=ioaBPcVRuGe/p3/QKQ0gVWCMjaVGlJhDubZDqtQVQb7TLX+E+jDGCEhqEnToL5+JYR/L3yOZG1UB7ITbeh60qD46b+8Fsg6+EeZUy1fjKWtZPtsk3YCVDGAtup1XVrVfYepAd9bqHgJCdOD9L8EMdFNtdBDWBHlP5nEQgQg2P9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723893463; c=relaxed/simple;
	bh=CdV6D/6TlW/8JcHjWsVKKFDGPXcpX3u0jLk29dogMl0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NkMbJM/7D/Hbn4+Y1g4epd4+kYHtnPGNjMtkoH/gwXtmvxBYcc0IoZLWUwXGBQGAW9YrANEhNDSq+GE8+vUnkSOq3fXJYNyM0JpOcNd0dOe2gq1GFrIyt86OeGzamNQeShp/5KUrlTHhydbXBc1GB5vAPakbWse/cBXogyiG+VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=openadk.org; spf=pass smtp.mailfrom=openadk.org; dkim=pass (2048-bit key) header.d=openadk.org header.i=@openadk.org header.b=LyKSs8Ir; arc=none smtp.client-ip=89.238.66.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=openadk.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openadk.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=openadk.org header.i=@openadk.org header.b="LyKSs8Ir"
Received: by helium.openadk.org (Postfix, from userid 1000)
	id 30594353640B; Sat, 17 Aug 2024 13:17:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=openadk.org; s=2022;
	t=1723893452; bh=CdV6D/6TlW/8JcHjWsVKKFDGPXcpX3u0jLk29dogMl0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LyKSs8Ir7saObKGoI27jcZZfqst4GFPblJSRiTcsumf724i1b76YVOW8NPjSyhs8o
	 Cld+P7iGGryEMpvPw0zt0HvHXy++QL4zfWiVNKWDg4DHkkPnvc/MjeGHXnaYL5pJhW
	 jny2+oLG/9Yx+Tu7CoHXPWV46YAU6uBzSHcRQB7+G5l14wAF3VpDVCKrxK9HtBHBqj
	 a8FGeKg+3wTfAUx6nIoGumC6dKCyYsHuMiO6mwbxNa7NMHkdMTX8xXJTAxkP08bVCg
	 xZeZoQDtA+Erwmj0u204pnjsgK7yesaDJdkLMmQJRR36KqrPFXk9BqPDhrXRYnkcYL
	 kR1EpLv5zDFbg==
Date: Sat, 17 Aug 2024 13:17:32 +0200
From: Waldemar Brodkorb <wbx@openadk.org>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, ebiggers@google.com, wbx@openadk.org
Subject: Re: [PATCH V2] xfs_io: Fix fscrypt macros ordering
Message-ID: <ZsCGzJ1tR5YhT4Bp@waldemar-brodkorb.de>
References: <20240817093256.222226-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240817093256.222226-1-cem@kernel.org>
X-Operating-System: Linux 5.10.0-31-amd64 x86_64

Hi Carlos,
cem@kernel.org wrote,

> From: Carlos Maiolino <cem@kernel.org>
> 
> We've been reported a failure to build xfsprogs within buildroot's
> environment when they tried to upgrade xfsprogs from 6.4 to 6.9:
> 
> encrypt.c:53:36: error: 'FSCRYPT_KEY_IDENTIFIER_SIZE' undeclared
> here (not in a function)
>         53 |         __u8
> master_key_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE];
>            |
> ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>      encrypt.c:61:42: error: field 'v1' has incomplete type
>         61 |                 struct fscrypt_policy_v1 v1;
>            |                                          ^~
> 
> They were using a kernel version without FS_IOC_GET_ENCRYPTION_POLICY_EX
> set and OVERRIDE_SYSTEM_FSCRYPT_POLICY_V2 was unset.
> This combination caused xfsprogs to attempt to define fscrypt_policy_v2
> locally, which uses:
> 	__u8 master_key_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE];
> 
> The problem is FSCRYPT_KEY_IDENTIFIER_SIZE is only after this block of
> code, so we need to define it earlier.
> 
> This also attempts to use fscrypt_policy_v1, which is defined only
> later.
> 
> To fix this, just reorder both ifdef blocks, but we need to move the
> definition of FS_IOC_GET_ENCRYPTION_POLICY_EX to the later, otherwise,
> the later definitions won't be enabled causing havoc.
> 
> Fixes: e97caf714697a ("xfs_io/encrypt: support specifying crypto data unit size")
> Reported-by: Waldemar Brodkorb <wbx@openadk.org>
> Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> V2:
> 	- Remove dangling leftover comment
> 	- define FS_IOC_GET_ENCRYPTION_POLICY_EX on it's own block.

Thanks for the V2. I tested it on the failing toolchains and it
works now. You can add a 
Tested-by: Waldemar Brodkorb <wbx@openadk.org>

best regards
 Waldemar
