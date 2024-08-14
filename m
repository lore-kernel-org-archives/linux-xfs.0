Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0417513ACC
	for <linux-xfs@vger.kernel.org>; Wed, 14 Aug 2024 02:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723600823; cv=none; b=sYpStbbCyDtiXsWWxjdnyxUnUNVT9nDp9iwIDQnCTiUNrHxQUbQv0ZadQictbTF+lANBH9Q0zI0WNQRBQrWI4vqg52pFbutHOJ8cRWEsjcazwcQ6WmaCHGX5BkVDVePwXG6l2NagOTUd6x7TiQ0XhTl+oeN3y2l3qm2+grmjS4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723600823; c=relaxed/simple;
	bh=zoquOoGYjq3/v8cEA3Dl00Nv/YwyMxi299rPdgg2sC4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SN6oQ1yWQTHwq6HkPDxXUoBgJHfblKvv2KB5SN0Ly8ILj7+plTehsoCVNVV73GjCrIwMBssfDyN/xgm07WJH2ik4Ojo3XQv8nVkdvzA6uvfr2RovSL5+/t2S84OVF2CHhKBFq6d7n89iwjrx9ZH8K105QBlzIrrhhC9GWZe7Jew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R/IkrmUW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R/IkrmUW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30B9C32782;
	Wed, 14 Aug 2024 02:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723600822;
	bh=zoquOoGYjq3/v8cEA3Dl00Nv/YwyMxi299rPdgg2sC4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R/IkrmUWQatJbRiWW3uwY+fe4GA/Dx4EsUkV1T5euMiYxxObWmypCxfSUKeW3HxE+
	 Swwoa5d254AE6iGM93zKvgfwJhARQ5auYj0ZWAJLB9COUEzQNdKgjpqy9uocoF2cwk
	 Wc/6nz9puwlJ1k3E7vRZSrUSkDK7nTLxUAjRAKX4rLXOjk0eHdXMDfT7u4hIn6poqQ
	 3xI16+whERWZe/2JXHhhmzIT/Qwm1Dm8x+mxFZDiyKpRO1eTOh6VtQPS68+4cTVsbN
	 ySz4Jvm0CgpDyQMaQUDDNW4ZtnzyXNXa7xpDezadSuBM2/sd+YkW2X0GnUMS+cssTo
	 IpiP8jwRdjp+A==
Date: Tue, 13 Aug 2024 19:00:22 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Bill O'Donnell <bodonnel@redhat.com>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net, cem@kernel.org
Subject: Re: [PATCH v5] xfs_db: release ip resource before returning from
 get_next_unlinked()
Message-ID: <20240814020022.GG6051@frogsfrogsfrogs>
References: <20240809171541.360496-2-bodonnel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240809171541.360496-2-bodonnel@redhat.com>

On Fri, Aug 09, 2024 at 12:15:42PM -0500, Bill O'Donnell wrote:
> Fix potential memory leak in function get_next_unlinked(). Call
> libxfs_irele(ip) before exiting.
> 
> Details:
> Error: RESOURCE_LEAK (CWE-772):
> xfsprogs-6.5.0/db/iunlink.c:51:2: alloc_arg: "libxfs_iget" allocates memory that is stored into "ip".
> xfsprogs-6.5.0/db/iunlink.c:68:2: noescape: Resource "&ip->i_imap" is not freed or pointed-to in "libxfs_imap_to_bp".
> xfsprogs-6.5.0/db/iunlink.c:76:2: leaked_storage: Variable "ip" going out of scope leaks the storage it points to.
> #   74|   	libxfs_buf_relse(ino_bp);
> #   75|
> #   76|-> 	return ret;
> #   77|   bad:
> #   78|   	dbprintf(_("AG %u agino %u: %s\n"), agno, agino, strerror(error));
> 
> Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> v2: cover error case.
> v3: fix coverage to not release unitialized variable.
> v4: add logic to cover error case when ip is not attained.
> v5: no need to release a NULL tp in the first error case.
> ---
>  db/iunlink.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/db/iunlink.c b/db/iunlink.c
> index d87562e3..35dbc3a0 100644
> --- a/db/iunlink.c
> +++ b/db/iunlink.c
> @@ -66,12 +66,15 @@ get_next_unlinked(
>  	}
>  
>  	error = -libxfs_imap_to_bp(mp, NULL, &ip->i_imap, &ino_bp);
> -	if (error)
> +	if (error) {
> +		libxfs_irele(ip);
>  		goto bad;
> +	}
>  
>  	dip = xfs_buf_offset(ino_bp, ip->i_imap.im_boffset);
>  	ret = be32_to_cpu(dip->di_next_unlinked);
>  	libxfs_buf_relse(ino_bp);
> +	libxfs_irele(ip);
>  
>  	return ret;
>  bad:
> -- 
> 2.46.0
> 
> 
