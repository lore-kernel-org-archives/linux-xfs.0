Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C500212A14C
	for <linux-xfs@vger.kernel.org>; Wed,  7 Aug 2024 18:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723055504; cv=none; b=JhNMSxk+XHHSlvqxBx/tOj2R+CVWTp19yuMx0tlYnP1Q/4Zz0XZ9yDneWGpRY73sx64zrgiGlkSvURz16xEeT2QbI1kKze7f3xTzKrf6xpkJ6FlpKLML1dIRtoiymC44aG5lzF4naUsVuHVTg/QNrIrdGHSXYvc8xM/CsclsWaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723055504; c=relaxed/simple;
	bh=PR+qY2zRHihHDAj/DLUFelVcq4lcOMY6o10yjTzCLUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qjzRJYsb/rE7ZpJ+zJiqxncQz+mM/O0V9VsdJ2v5bPA+4EJ3g6UAIAXqz2hJnCisrOJlnXNShNZhlGacX2WIrZjgDVjiIIAh/S54+qVXf1+2JE5ZiSKce3aRVYSW3qC/hYLM6KjygN/Y9WSlvDwGcq1pJxhjuLI3Zk2H05aU+Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HLwaBHvS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HLwaBHvS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A744C32781;
	Wed,  7 Aug 2024 18:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723055504;
	bh=PR+qY2zRHihHDAj/DLUFelVcq4lcOMY6o10yjTzCLUU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HLwaBHvSjV2LfGwtfMDsSFGt/Tgs6ltXS/q2I3uVwYNTvP52UK6kr8yTT18ipV7PQ
	 1AfPE4wQDqp+1g9eTR3DIgPd0I7eoC9XIh491RW5qHVwg77oZ71iL4KjOtSihqXLPO
	 CSJfW2Kovqkv+TL/mkt6BwC5B3EwaUgNfpkb3t8KIf/roIt40ot6HyeRpiPivydyIg
	 daBcE1B/FMkXHm0fPccT061s4hgyPyAUzP3rmTl3Ac0N4DrJjp3ckPhnFH4w62j3w8
	 qNehzUfRzcXeucXR6CD8FGiVi0RA5f5n07jZs+Bby7mzVSmPqAyMTq1Ovq9Btpm5+M
	 OV0FDY9XU8IiQ==
Date: Wed, 7 Aug 2024 11:31:43 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Bill O'Donnell <bodonnel@redhat.com>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net, cem@kernel.org
Subject: Re: [PATCH v2] xfs_db: release ip resource before returning from
 get_next_unlinked()
Message-ID: <20240807183143.GL6051@frogsfrogsfrogs>
References: <20240807181553.243646-2-bodonnel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240807181553.243646-2-bodonnel@redhat.com>

On Wed, Aug 07, 2024 at 01:15:54PM -0500, Bill O'Donnell wrote:
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
> v2: cover the error case.
> ---
>  db/iunlink.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/db/iunlink.c b/db/iunlink.c
> index d87562e3..bd973600 100644
> --- a/db/iunlink.c
> +++ b/db/iunlink.c
> @@ -72,9 +72,12 @@ get_next_unlinked(
>  	dip = xfs_buf_offset(ino_bp, ip->i_imap.im_boffset);
>  	ret = be32_to_cpu(dip->di_next_unlinked);
>  	libxfs_buf_relse(ino_bp);
> +	libxfs_irele(ip);
>  
>  	return ret;
>  bad:
> +	libxfs_buf_relse(ino_bp);

What if we got here via the first 'goto bad' in this function?  We'll be
feeding an uninitialized variable into libxfs_buf_relse.

--D

> +	libxfs_irele(ip);
>  	dbprintf(_("AG %u agino %u: %s\n"), agno, agino, strerror(error));
>  	return NULLAGINO;
>  }
> -- 
> 2.45.2
> 
> 
