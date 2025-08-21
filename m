Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A91C1DF74F;
	Thu, 21 Aug 2025 09:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755769162; cv=none; b=FDVvDAwtsqXf1iT4Hz2+AS7Z7Q5s6eoaJWyYGtFkZL/Y2qN9aUDAXVLCWhs9cUO/k3HQjaNnSOXDN31EVxg+FQcTk0hp+hPjqwZvZs4CVHRSpKNDd1El+KSkbq9dCyVr+HHusaSSZ0Qf7A6G2hDdlXGuxsjaDTBWBymIOu3r7mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755769162; c=relaxed/simple;
	bh=IuJOtF7eaZduGiWztK8eENJiMaksfl3fY1lNtweEcxg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h77g6wDGLfX5IV3mW6duplF9UQ9cB8ZPNo0CMUJ2SO6fF/Ki3s8dEhWCpUEglYxi+2tXHdhXM+2bAnkjKpmyhENUC2ENx9pNfsJ4Yv0/oig8YsSVEYAnjfp1oVXODmfydq9Dli9LnfU4+7ntuHqb0NJ3ALnMf+jLvnOagJXa01E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fh7yl23h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fh7yl23h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A06DC4CEEB;
	Thu, 21 Aug 2025 09:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755769161;
	bh=IuJOtF7eaZduGiWztK8eENJiMaksfl3fY1lNtweEcxg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fh7yl23hsLjV5BUxFqr0Syhg1evfWkarXnmnQpe/h35u/jjjXGUL2Sh6gd4aimZnL
	 /StXkKBJqgTYi3N+UiNxX0dnMO04a4qztL6Ty3Swzs7j2myuX7gPtADzhnSHw0K+1a
	 sd68regcui1Wr5i3v9ZCmTVF+pLl7X9qipTpZXSIdGWwLBqwgrI/dOt5m/nesF7Zr8
	 OUUvB1yvZFvFzP2rOE1d1S9nkqPlRg0xN/vOGg389My2HZsmWCKBfJkHw2kJ+WE5JF
	 aM4YLnt6N7PDnCUUw/gs0/t7FhKTlsRIv79HhVKKL24oDmQQxndBvtHNmOEJugHN1u
	 DSkjrz89nj9dw==
Date: Thu, 21 Aug 2025 11:39:17 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Marcelo Moreira <marcelomoreira1905@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	skhan@linuxfoundation.org, linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH v2] xfs: Replace strncpy with memcpy
Message-ID: <hi2bosmnbbqbsrxydjqh4w7ovzggfdvpafubqbzdovuwzwqlfh@z2wbwjaqizzk>
References: <DgC9ldLgYmvzXaAZpH-XsBCKhwKSRirv1SdyNKAyWkv0buVk8ZXruCVWp7pYeSa6Ogg-jj6hxYTLAxC0m0FYeg==@protonmail.internalid>
 <20250817155053.15856-1-marcelomoreira1905@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250817155053.15856-1-marcelomoreira1905@gmail.com>

Hi.

On Sun, Aug 17, 2025 at 12:50:41PM -0300, Marcelo Moreira wrote:
> Following a suggestion from Dave and everyone who contributed to v1, this
> changes modernizes the code by aligning it with current kernel best practices.
> It improves code clarity and consistency, as strncpy is deprecated as explained
> in Documentation/process/deprecated.rst. Furthermore, this change was tested
> by xfstests

> and as it was not an easy task I decided to document on my blog
> the step by step of how I did it https://meritissimo1.com/blog/2-xfs-tests :).

The above line does not belong to the commit description. I'm glad
you've tested everything as we suggested and got to the point to run
xfstests which indeed is not a single-click button. But the patch
description is not a place to document it.

> 
> This change does not alter the functionality or introduce any behavioral
> changes.

^ This should be in the description...

> 
> Changes include:
>  - Replace strncpy with memcpy.

^ This is unnecessary. It's a plain copy/paste from the subject, no need
to write yet again.

> 
> ---

^ Keep a single --- in the patch... This is used as metadata, everything
  below the first --- is ignored by git.

> Changelog:
> 
> Changes since v1:
> - Replace strncpy with memcpy instead of strscpy.
> - The change was tested using xfstests.
> 
> Link to v1: https://lore.kernel.org/linux-kernel-mentees/CAPZ3m_jXwp1FfsvtR2s3nwATT3fER=Mc6qj+GzKuUhY5tjQFNQ@mail.gmail.com/T/#t
> 

^ All those Changelog metadata should be below the ---, so they don't
get into the commit message, but...

> Suggested-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Marcelo Moreira <marcelomoreira1905@gmail.com>

^ Those should be before the '---' otherwise, as I mentioned, git will
ignore those.

> ---
>  fs/xfs/scrub/symlink_repair.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/symlink_repair.c b/fs/xfs/scrub/symlink_repair.c
> index 953ce7be78dc..5902398185a8 100644
> --- a/fs/xfs/scrub/symlink_repair.c
> +++ b/fs/xfs/scrub/symlink_repair.c
> @@ -185,7 +185,7 @@ xrep_symlink_salvage_inline(
>  		return 0;
> 
>  	nr = min(XFS_SYMLINK_MAXLEN, xfs_inode_data_fork_size(ip));
> -	strncpy(target_buf, ifp->if_data, nr);
> +	memcpy(target_buf, ifp->if_data, nr);
>  	return nr;

The change looks fine. Once you fix the above points:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

Cheers,
Carlos

>  }
> 
> --
> 2.50.1
> 
> 
