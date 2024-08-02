Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662D047A64
	for <linux-xfs@vger.kernel.org>; Fri,  2 Aug 2024 23:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722640981; cv=none; b=lzDWVy+YEtAHIUpqGVubT9Vc0f/iHapYcvxjpUbunN6//PaPDDAFe+1JA3WdSmqO7RWfwmHbp0l6ju03EeC8yemDKzXc1A1+FvhMVKit/WxIeD10feo6mZfqxcq44RWu4Y1wuyVPdKHwSmKZBO4bwLPcHvrWnxQAJzeWzkMcX2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722640981; c=relaxed/simple;
	bh=i73i73LY+kOOtE7vinhCFo0dbdQzcD/aY0anBwJftnQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rfTLdWKmPLOSz6y0L05IjFWpN0+yyunjvYBhc4fT3pvKN8kWqMIbSPBjf5T6LYc5hXiKd4GzQGt0CRHJBp2zWbIPwnhdArwnTT63tPsP9ByfsinMjcGnnJePNGh9WbykDDob+n9X4FvKNXIpdlwY8yS7hHeks1k2hn2eR0oQPvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vMLB+41G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vMLB+41G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E742FC32782;
	Fri,  2 Aug 2024 23:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722640981;
	bh=i73i73LY+kOOtE7vinhCFo0dbdQzcD/aY0anBwJftnQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vMLB+41GlJ39uY+wqAQZhuvPoBi6RlRg1t54k94Sl8hTYVaHvnmDV4XuwgBNpYUo8
	 s+/QTlJ2WlhLd8wzU4SF9NaLXohXPDPO4tRWHnICYVMw4R6f4IO/XdnD9EBtgQwLxg
	 vAOmfR4/iOVlUBh3vUQJgy4wssGqhIHq1FBYlKdy7lXWN9pUDZ1wbAoy1aNYFZIuUX
	 efHGHTaNbPxdMBAOXZlFenjnZTmHJTdyBObzV6eHn0V8lj/PS/kmlZtVojwclbW0l5
	 Q82B1+ODRQtwsHX/psMhqrdkEhZEsUDhXaKDjfQfQY5hgRIt3LW7u9tomDqkxgvLxk
	 EcumqL3QKlcDg==
Date: Fri, 2 Aug 2024 16:23:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Bill O'Donnell <bodonnel@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH] xfs_db: release ip resource before returning from
 get_next_unlinked()
Message-ID: <20240802232300.GK6374@frogsfrogsfrogs>
References: <20240802222552.64389-1-bodonnel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240802222552.64389-1-bodonnel@redhat.com>

On Fri, Aug 02, 2024 at 05:25:52PM -0500, Bill O'Donnell wrote:
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
> ---
>  db/iunlink.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/db/iunlink.c b/db/iunlink.c
> index d87562e3..3b2417c5 100644
> --- a/db/iunlink.c
> +++ b/db/iunlink.c
> @@ -72,6 +72,7 @@ get_next_unlinked(
>  	dip = xfs_buf_offset(ino_bp, ip->i_imap.im_boffset);
>  	ret = be32_to_cpu(dip->di_next_unlinked);
>  	libxfs_buf_relse(ino_bp);
> +	libxfs_irele(ip);

I think this needs to cover the error return for libxfs_imap_to_bp too,
doesn't it?

--D

>  
>  	return ret;
>  bad:
> -- 
> 2.45.2
> 
