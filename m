Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526261B86E8
	for <linux-xfs@vger.kernel.org>; Fri, 16 Aug 2024 20:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723838737; cv=none; b=U1gGBJ/4HKzQYqfnuTpbixV802+J9v2SjiovQxZdS/Km8tsJQzEXReLcM4Dn4iWh9TXhM+SDvMONu0NsJu99tOPX862eKQitqoJucrJGZbd9vCcN3Y7tx8eONlkm+7sAo6daqwQ6IYxvpn8+Xi90zn3PLEpM4+gi7JgjrqQo7fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723838737; c=relaxed/simple;
	bh=NNqGhAdm4qTeO9pVQhBZOL5gNqXShDIqmcOlZvdvtR0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LPV0zAkRepyY576/T4Igc1IUWPhrEQ+Pp6qwDBaR9pdcimpAkzlWOAJn99YUipRJOBmpyGa/8URloadip1bHBS29B7Jg9LDkM3h9rEorpc1ZqIoMR8LIyqxGh6HtxrvCmV4uUvknuI18CEJmevF8hYLtthJT4n6IRnotSKzBnRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QcTr8p5I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QcTr8p5I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB16C32782;
	Fri, 16 Aug 2024 20:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723838736;
	bh=NNqGhAdm4qTeO9pVQhBZOL5gNqXShDIqmcOlZvdvtR0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QcTr8p5IPYdj7dlMrGcMVkWro+uX8Ou4hsYQKRcCrxRR23CBTKXoeW6xbRPfILkui
	 PMyj6T9YusuqfPXYWh7UkDQgY/K1UyKSXDXydxCgTbHNfUQT068oQxCUYRCx2T0I48
	 1cSqfcaRU4gxfAvHxsAZ7qjBLfKCd77WV8CnahhEdTfDtS/Y+tGO4FgPx8uEt3Gg/m
	 mheixK/wUO4Z2A3lMxpKSPt++3aZlP2jItl0ZnHw8ToCGROvY0bfU8KEGqlcdL9DtS
	 vUq8qi7mLAFwZ+1Eyl2/1Sna06xDwE5tqf3qlZexwsFGLVSLnAu1DJ5uP9XXoE7moa
	 Iu6FUmeGNr6QA==
Date: Fri, 16 Aug 2024 13:05:35 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, wbx@openadk.org
Subject: Re: [PATCH] xfs_io: Fix fscrypt macros ordering
Message-ID: <20240816200535.GA15887@sol.localdomain>
References: <20240816193957.42626-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240816193957.42626-1-cem@kernel.org>

On Fri, Aug 16, 2024 at 09:39:38PM +0200, cem@kernel.org wrote:
>  #define FSCRYPT_POLICY_V2		2
>  #define FSCRYPT_KEY_IDENTIFIER_SIZE	16
>  /* struct fscrypt_policy_v2 was defined earlier */

The above comment needs to be removed.

> +/*
> + * Since the log2_data_unit_size field was added later than fscrypt_policy_v2
> + * itself, we may need to override the system definition to get that field.
> + * And also fscrypt_get_policy_ex_arg since it contains fscrypt_policy_v2.
> + */
> +#if !defined(FS_IOC_GET_ENCRYPTION_POLICY_EX) || \
> +	defined(OVERRIDE_SYSTEM_FSCRYPT_POLICY_V2)
> +#undef fscrypt_policy_v2
> +struct fscrypt_policy_v2 {
> +	__u8 version;
> +	__u8 contents_encryption_mode;
> +	__u8 filenames_encryption_mode;
> +	__u8 flags;
> +	__u8 log2_data_unit_size;
> +	__u8 __reserved[3];
> +	__u8 master_key_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE];
> +};
> +
> +#undef fscrypt_get_policy_ex_arg
> +struct fscrypt_get_policy_ex_arg {
> +	__u64 policy_size; /* input/output */
> +	union {
> +		__u8 version;
> +		struct fscrypt_policy_v1 v1;
> +		struct fscrypt_policy_v2 v2;
> +	} policy; /* output */
> +};
> +
> +#define FS_IOC_GET_ENCRYPTION_POLICY_EX		_IOWR('f', 22, __u8[9]) /* size + version */
> +
> +#endif

FS_IOC_GET_ENCRYPTION_POLICY_EX needs to be guarded by an ifdef that checks only
itself, like FS_IOC_ADD_ENCRYPTION_KEY is below.

> +
>  /*
>   * Since the key_id field was added later than struct fscrypt_add_key_arg
>   * itself, we may need to override the system definition to get that field.
>   */
>  #if !defined(FS_IOC_ADD_ENCRYPTION_KEY) || \
>  	defined(OVERRIDE_SYSTEM_FSCRYPT_ADD_KEY_ARG)
>  #undef fscrypt_add_key_arg
>  struct fscrypt_add_key_arg {
>  	struct fscrypt_key_specifier key_spec;
>  	__u32 raw_size;
>  	__u32 key_id;
>  	__u32 __reserved[8];
>  	__u8 raw[];
>  };
>  #endif
>  
>  #ifndef FS_IOC_ADD_ENCRYPTION_KEY
>  #  define FS_IOC_ADD_ENCRYPTION_KEY		_IOWR('f', 23, struct fscrypt_add_key_arg)
>  #endif

Otherwise this looks good, thanks.  Sorry for the trouble.  It might be time to
find a way to build the file without <linux/fs.h> included --- then the local
definitions can just be used unconditionally.

- Eric
