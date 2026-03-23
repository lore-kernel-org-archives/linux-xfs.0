Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7243C660A;
	Mon, 23 Mar 2026 18:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774290299; cv=none; b=INCsCFCQaYqIDhCz4AIRh3P5z1CLJbUZcPzgBGvX2vqEzWCTMWas2SuA2kNGUV7ljc+aSJp65ySgEgyIlujK7zDfZ3BcPoxyHMjQ58U2K+0qKowXVBz4kfUMBbFbObKtFncBaLYjZRo41N1z0Gfppxu5sTuF72oq3qn2DIue/lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774290299; c=relaxed/simple;
	bh=+OfivGD4//8uRVSauZcaTW7iKNbZsdG6fOv6bQX/GrE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YJ5/HTF0/oCt38XUXZvSDePIpt4+lDeHGpklVNfBPDwQaSaEaRxcabaWm4aNZH8KRvxFFYQHkULWdK0djVjej+zuYlGvkg3p1SOn9knyCwHsLVC3ywoc9GhqG/GSFPNMLyl3yk5CQ5RDL/7CUfW/LpkpK43W2feAdYC6YoNOLFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qQbjJlcF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qQbjJlcF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F87C4CEF7;
	Mon, 23 Mar 2026 18:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774290299;
	bh=+OfivGD4//8uRVSauZcaTW7iKNbZsdG6fOv6bQX/GrE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qQbjJlcFtH2TNyGOhnrT4b80vGlfZkwYNy7ToPdhq7NwjihQA5f5NoFayCzRGm+Re
	 WRnfkMySklfDO7iSNbvUEnkD4hPhSnDl+crlY5Y6izqV2VZgRi/9zDGqgL3/MtXekA
	 qeoCSt44SdbLa7issXHDsSSStRrnPnCLg2w3Zs9LUH1VYFTDZJt8cFJgeo79w1LusO
	 +AzaIRxYvIML1k9bSBqqKBSZbm9ML1AX9AApUTQlsclxEU6zKqQegWWB/3JHDSRjH0
	 P6RzG/ZEZjYZnB9x8Vk5CQO+w443xW3pldVd0sKvVTD68b5fJshCZ1jfNOkU/WT69A
	 yMaLxqwCUNonA==
Date: Mon, 23 Mar 2026 11:24:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>,
	Andrey Albershteyn <aalbersh@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] xfs: Replace strncpy() with strscpy_pad() in tracepoint
 error paths
Message-ID: <20260323182458.GI6223@frogsfrogsfrogs>
References: <20260323172204.work.979-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323172204.work.979-kees@kernel.org>

On Mon, Mar 23, 2026 at 10:22:09AM -0700, Kees Cook wrote:
> Replace the deprecated[1] strncpy() with strscpy_pad() in the
> xfile_create and xmbuf_create tracepoints.
> 
> Both tracepoints use file_path() to resolve a pathname into
> __entry->pathname (a char[MAXNAMELEN] trace ring buffer field). On
> failure, the error path overwrites the buffer with the string literal
> "(unknown)" via strncpy(). The original strncpy() zero-pads the
> remaining 246 bytes (MAXNAMELEN is 256, "(unknown)" is 10 bytes
> including NUL).
> 
> strscpy_pad() preserves this zero-padding, which matters because the
> destination is a trace ring buffer entry: ring buffer slots are not
> zeroed on allocation, and the raw buffer is readable by userspace via
> tracefs. The zero-padding ensures no stale data remains in the
> buffer after the error path overwrites it.
> 
> The source is a 10-byte string literal into a 256-byte destination,
> so there is no behavioral change.
> 
> Link: https://github.com/KSPP/linux/issues/90 [1]
> Signed-off-by: Kees Cook <kees@kernel.org>

Seems fine to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/scrub/trace.h | 3 +--
>  fs/xfs/xfs_trace.h   | 3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> index 39ea651cbb75..46c420f51129 100644
> --- a/fs/xfs/scrub/trace.h
> +++ b/fs/xfs/scrub/trace.h
> @@ -980,8 +980,7 @@ TRACE_EVENT(xfile_create,
>  		__entry->ino = file_inode(xf->file)->i_ino;
>  		path = file_path(xf->file, __entry->pathname, MAXNAMELEN);
>  		if (IS_ERR(path))
> -			strncpy(__entry->pathname, "(unknown)",
> -					sizeof(__entry->pathname));
> +			strscpy_pad(__entry->pathname, "(unknown)");
>  	),
>  	TP_printk("xfino 0x%lx path '%s'",
>  		  __entry->ino,
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 813e5a9f57eb..9f9fb86097ed 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -5101,8 +5101,7 @@ TRACE_EVENT(xmbuf_create,
>  		__entry->ino = file_inode(file)->i_ino;
>  		path = file_path(file, __entry->pathname, MAXNAMELEN);
>  		if (IS_ERR(path))
> -			strncpy(__entry->pathname, "(unknown)",
> -					sizeof(__entry->pathname));
> +			strscpy_pad(__entry->pathname, "(unknown)");
>  	),
>  	TP_printk("dev %d:%d xmino 0x%lx path '%s'",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> -- 
> 2.34.1
> 
> 
