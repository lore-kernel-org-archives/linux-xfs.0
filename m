Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEF11DED4C;
	Mon, 30 Jun 2025 14:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751295562; cv=none; b=k8UPe4mbNje5Tz5RAeJnbJ7hAxUK55znvsGfh19V6bfNUOYgYkqXZapCkRd0ioH7oDXF4uu4w9VznnhoS1AjfjYI99JN/KpL5JuJZXniG0uCBvt+MaDFwkFRvINXWD9faPWxjlzgkiNtjmFQQhMYtHoJkmYrjwCm4lFq/TOfFqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751295562; c=relaxed/simple;
	bh=43rNiA51/TeLusP6uv48EbTOblgkVWDS6WjwFw3QFzw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SorERJH5V7Dzhe56dXVPIb77TA5zRCsN/rnZvnDJlNwj33F8f/cFl5DzmULN61pcYe+on57QpSpOp+GtjsuK/KsKQFWaRp5iohliRlJzyczcpxRFCBeGAD+jES3YXjMijJLkZa2cA87bZ6/lwpZr33tHSf+hjSK3SFHzdydooxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fg9jB0Ye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fg9jB0Ye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623DCC4CEE3;
	Mon, 30 Jun 2025 14:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751295562;
	bh=43rNiA51/TeLusP6uv48EbTOblgkVWDS6WjwFw3QFzw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fg9jB0YeIfAHHzU9mKiDgamVrZjy/Jlj5EjWk7u1R45lbeSWZ0dT4fZlGfIv77o9F
	 KIMH6BzX9fFFN5VwsmM25M7w8PzGR4ia+EWzElHlM2XG1Xv+sfyytY1tbne0g9AFWw
	 CV8y5PkMTYOYbqL6UbIUxlwnfiBhDTM8stxDp3yFBt0eM4n1stDIs1t+8WMk0sgk3h
	 R9GXdim6g27kYjXHg/PLhYXv6ZL1wq+Wc8BnWEd9ltSWNcv0EL1l/zRl4bK/RaNszS
	 GaXgLFyap/SpIlnlKlTB1qoVw1EnP0C8iuKC6euCRYA1PpEWX5gWXT7XzHMJ7OAq8s
	 T8bjAyPPEYPwg==
Date: Mon, 30 Jun 2025 07:59:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Pranav Tyagi <pranav.tyagi03@gmail.com>
Cc: cem@kernel.org, skhan@linuxfoundation.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev
Subject: Re: [PATCH] xfs: replace strncpy with memcpy in xattr listing
Message-ID: <20250630145921.GA10009@frogsfrogsfrogs>
References: <20250617131446.25551-1-pranav.tyagi03@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250617131446.25551-1-pranav.tyagi03@gmail.com>

On Tue, Jun 17, 2025 at 06:44:46PM +0530, Pranav Tyagi wrote:
> Use memcpy() in place of strncpy() in __xfs_xattr_put_listent().
> The length is known and a null byte is added manually.
> 
> No functional change intended.
> 
> Signed-off-by: Pranav Tyagi <pranav.tyagi03@gmail.com>

'tis better than the three previous attempts at this (compliments on
working out that *name isn't a null terminated string!), so

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_xattr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index 0f641a9091ec..ac5cecec9aa1 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -243,7 +243,7 @@ __xfs_xattr_put_listent(
>  	offset = context->buffer + context->count;
>  	memcpy(offset, prefix, prefix_len);
>  	offset += prefix_len;
> -	strncpy(offset, (char *)name, namelen);			/* real name */
> +	memcpy(offset, (char *)name, namelen);			/* real name */
>  	offset += namelen;
>  	*offset = '\0';
>  
> -- 
> 2.49.0
> 
> 
