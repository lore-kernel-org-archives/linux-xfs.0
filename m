Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FFB1C379B
	for <linux-xfs@vger.kernel.org>; Fri, 16 Aug 2024 20:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723839645; cv=none; b=BSQBDTrvNPGkwDPRlT/zo7i8ZUfc57b7bpuru3hqqo8IQx9N7n7Ff2yvjCVB4xC5fMc31zV5yFATUDqoIvxHSWAT0ntUbqx0zurR0G1NR1BTt19gDlicH26KLgCkmFrjrEF469hMSbb66dMVJSHCar0x2OS/VMcVNuVspYcgYk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723839645; c=relaxed/simple;
	bh=cf2kERppoeJXMqZfpcsa1c4xGdF0Af81dvJHnl3X8r4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ft09QkNrrOl+/aiCmQpgOCaexHHOYOsYr1fBdEaLi1Z1wSjWom5lrdv2Tj1TE9ZHxh899wGw4oaUX9KVPUqRfXWfHlyk0REttzTi83CAmM/l3Uj+UnD7oQu+ysZSk+RehaIqM+D7TDvsw9FbrfxpeNTnVUurbqg4qXSPTTNZ91Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dex/n1Gg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dex/n1Gg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723839642;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5raG1x55RqjeNqx0AfD53Bd1NQ2lCM/9urit9MOUpMg=;
	b=dex/n1GgZek3Xc4Trkq8ek4jk7qhxuNbNYzce75zRzvsP7yKqGauQwVX9kSgXZPyNv+iwy
	mv5uI3Fiwv1uBoHSGaoAvoB/OcVCH5IAaHHzMF+mZqacFwbQEd6Afi8MBgVlLyYla7CHUn
	ZxZUbKU0R1LMaH+cokrGQXHm3pOgRx4=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-156-dyWNbQFMN8W3i5ujbeQMXw-1; Fri,
 16 Aug 2024 16:20:40 -0400
X-MC-Unique: dyWNbQFMN8W3i5ujbeQMXw-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D85F719560AD;
	Fri, 16 Aug 2024 20:20:38 +0000 (UTC)
Received: from redhat.com (unknown [10.22.65.50])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 95A721955F38;
	Fri, 16 Aug 2024 20:20:37 +0000 (UTC)
Date: Fri, 16 Aug 2024 15:20:34 -0500
From: Bill O'Donnell <bodonnel@redhat.com>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, ebiggers@google.com, wbx@openadk.org
Subject: Re: [PATCH] xfs_io: Fix fscrypt macros ordering
Message-ID: <Zr-0kuyHlKBW25Yd@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Fri, Aug 16, 2024 at 09:39:38PM +0200, cem@kernel.org wrote:
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
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>

> ---
>  io/encrypt.c | 64 ++++++++++++++++++++++++++--------------------------
>  1 file changed, 32 insertions(+), 32 deletions(-)
> 
> diff --git a/io/encrypt.c b/io/encrypt.c
> index 79061b07c..97abb964e 100644
> --- a/io/encrypt.c
> +++ b/io/encrypt.c
> @@ -35,35 +35,6 @@
>  #define FS_IOC_GET_ENCRYPTION_POLICY		_IOW('f', 21, struct fscrypt_policy)
>  #endif
>  
> -/*
> - * Since the log2_data_unit_size field was added later than fscrypt_policy_v2
> - * itself, we may need to override the system definition to get that field.
> - * And also fscrypt_get_policy_ex_arg since it contains fscrypt_policy_v2.
> - */
> -#if !defined(FS_IOC_GET_ENCRYPTION_POLICY_EX) || \
> -	defined(OVERRIDE_SYSTEM_FSCRYPT_POLICY_V2)
> -#undef fscrypt_policy_v2
> -struct fscrypt_policy_v2 {
> -	__u8 version;
> -	__u8 contents_encryption_mode;
> -	__u8 filenames_encryption_mode;
> -	__u8 flags;
> -	__u8 log2_data_unit_size;
> -	__u8 __reserved[3];
> -	__u8 master_key_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE];
> -};
> -
> -#undef fscrypt_get_policy_ex_arg
> -struct fscrypt_get_policy_ex_arg {
> -	__u64 policy_size; /* input/output */
> -	union {
> -		__u8 version;
> -		struct fscrypt_policy_v1 v1;
> -		struct fscrypt_policy_v2 v2;
> -	} policy; /* output */
> -};
> -#endif
> -
>  /*
>   * Second batch of ioctls (Linux headers v5.4+), plus some renamings from FS_ to
>   * FSCRYPT_.  We don't bother defining the old names here.
> @@ -106,9 +77,6 @@ struct fscrypt_policy_v1 {
>  
>  #define FSCRYPT_MAX_KEY_SIZE		64
>  
> -#define FS_IOC_GET_ENCRYPTION_POLICY_EX		_IOWR('f', 22, __u8[9]) /* size + version */
> -/* struct fscrypt_get_policy_ex_arg was defined earlier */
> -
>  #define FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR	1
>  #define FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER	2
>  struct fscrypt_key_specifier {
> @@ -152,6 +120,38 @@ struct fscrypt_get_key_status_arg {
>  
>  #endif /* !FS_IOC_GET_ENCRYPTION_POLICY_EX */
>  
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
> +
>  /*
>   * Since the key_id field was added later than struct fscrypt_add_key_arg
>   * itself, we may need to override the system definition to get that field.
> -- 
> 2.46.0
> 
> 

