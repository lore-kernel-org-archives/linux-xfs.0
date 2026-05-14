Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3D7175A68
	for <linux-xfs@vger.kernel.org>; Thu, 14 May 2026 00:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778718578; cv=none; b=Lqae2DJod/NT8AmEXgjsCcgc4qXYK/8BpDTP1zFcvGyB6JuYAOWIjuFXkvPMhtHNWFKc3vYagBoOlJhAGMQD+bPvYDiZs3fe4BrGQOMBpEput5lU4uFq1KLZysEzlKI9Fw1dkKhi2mBl8RDGbONnSuUBhkxr8nlf+zBDrvDsufk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778718578; c=relaxed/simple;
	bh=45PubCvz7edQCuU+bq41QOkNYpN9MTTzXIFn2gIYl14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sfhVwN8I4mBzI4BoxCTRCWn4g72phNUNNmxqlw5eoUmj6nct7OQMKUYCzX8gm8ZH6QfFF5GEXV/Pmz3tUzCAlhJq7GtqpCYscGK0choZDOXHnf4fIJPJ9r6uQtrm/g8DHcvXH7EYOOlmkswrUZgv+7BFjCygnTM79uKNi56CoAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UpD3yijD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UpD3yijD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80976C19425;
	Thu, 14 May 2026 00:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778718577;
	bh=45PubCvz7edQCuU+bq41QOkNYpN9MTTzXIFn2gIYl14=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UpD3yijDooGzKiMxxT8g5k9JqwpCBaiRqxqznamKMvo7oUPgGDyAD98tAWbkv3qiN
	 HJ6j5T0J9joIMLhzPEBfivlgQnUZVi2s1Ib+jijR0X1C4OFP3J9l+YytKk/A6OwPB7
	 FgsNv3Agv3rVtI1kEKZj4SHG/mhYuZG4iMsUHgm12XAgVz4pTReOWaqy1aWQUWdW1h
	 +rmVZPaM0PqopbaNbUPbfZ4oTYTvTUvmkTIBFjk8bZZQ5+8wqi0rfQtkQ2JR6eLIQv
	 amatLR6u+u1YnSzuLR/tBWxCPz5R0k8jkDTmDJ5hUHPwZCowWxqJV+ja9k0ff7Te8B
	 hh15adIV5a/Dg==
Date: Wed, 13 May 2026 17:29:37 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Anthony Iliopoulos <ailiop@suse.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] libfrog: add fallback stubs for libfrog_statmount
 and fstatmount
Message-ID: <20260514002937.GU9555@frogsfrogsfrogs>
References: <20260513193040.2130-1-ailiop@suse.com>
 <20260513193040.2130-4-ailiop@suse.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513193040.2130-4-ailiop@suse.com>

On Wed, May 13, 2026 at 09:30:39PM +0200, Anthony Iliopoulos wrote:
> Add stubs for libfrog_statmount and fstatmount to enable compilation of
> xfs_healer on systems that lack listmount support. Without these stubs,
> statmount.c is not compiled, causing compilation errors due to missing
> definitions. The stubs allow xfs_healer to fall back to walking the mount
> table in userspace.
> 
> Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>

Seems fine to me, though I wonder if we should just bite the bullet and
have a separate HAVE_STATMOUNT?

(Eh, maybe when we develop a need for one without the other)

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  libfrog/statmount.h | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/libfrog/statmount.h b/libfrog/statmount.h
> index b6f1338830a0..13aaad3a99dc 100644
> --- a/libfrog/statmount.h
> +++ b/libfrog/statmount.h
> @@ -98,11 +98,23 @@ struct statmount {
>  int libfrog_listmount(uint64_t mnt_id, int mnt_ns_fd, uint64_t *cursor,
>  		uint64_t *mnt_ids, size_t nr_mnt_ids);
>  
> +#ifdef HAVE_LISTMOUNT
>  int libfrog_statmount(uint64_t mnt_id, int mnt_ns_fd, uint64_t statmount_flags,
>  		struct statmount *smbuf, size_t smbuf_size);
> -
>  int libfrog_fstatmount(int fd, uint64_t statmount_flags,
>  		struct statmount *smbuf, size_t smbuf_size);
> +#else
> +static inline int libfrog_statmount(uint64_t mnt_id, int mnt_ns_fd, uint64_t statmount_flags,
> +		struct statmount *smbuf, size_t smbuf_size)
> +{
> +	return -ENOSYS;
> +}
> +static inline int libfrog_fstatmount(int fd, uint64_t statmount_flags,
> +		struct statmount *smbuf, size_t smbuf_size)
> +{
> +	return -ENOSYS;
> +}
> +#endif
>  
>  static inline size_t libfrog_statmount_sizeof(size_t strings_bytes)
>  {
> -- 
> 2.49.0
> 
> 
