Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5FBE3B71B2;
	Wed, 15 Jul 2026 17:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784136740; cv=none; b=i55jFNa5azBQ9vpqvVnCr4whUv5wkxuuSM9PsP2w1JXw4AEzGM897TnLSygNmSbbrG/wD7rjbrqXa9ipzxKOuJJmDNio/jbfQrEvNPn/ZQxmjIVhRU634zZfJx2pgXfCLUVcNmCnnLEWv4DIKFXtM04LxLT27HXGzL8idqhl5jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784136740; c=relaxed/simple;
	bh=IWwPIa/eGoid4/Bqrp92BXRx3SUMvwwNgfoT6O7rUbc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UiBuGcwMDYy59JjVcHb3nj5g3j20ftZ08kKosHc+BSid4b703O24NNu85MLRcNOCj2c/RhJm749phD1ro5hVMFz13f+z6J/QGkgzDnUJ6tCWJOedZZ/Jnq0XCZUSS/hCM/ue+vyQpy2cuDbeHSAvmcITIC4kRzl68/6egqpWd6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kzJ326f2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kzJ326f2"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D96981F000E9;
	Wed, 15 Jul 2026 17:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784136736;
	bh=8khBmw9Kzh4k0NzvnapL6hUHpquKP+vRcibB+6wdl8U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kzJ326f2coYbdKpyYoiqagY9u6Ls+JWst9dQndTA7GpUB9PctWDMAK8LgnfwkAKWC
	 VuhM5SRJByF1CabP/wLYX0o9J9Jjgiq1JshqY5gnxuLNmKIV//FESvZIcG9LsKSMRT
	 9a29q/8mobeo/bFU/qhhRFPRCZt4QsbAQBPrN5CW7VLoYgX9iE+POtQ/Ql+YCtFOIZ
	 KQfTMmCFYfIHr3VRuqTx0vH5jUmlwizqrphgo9oNIQH0pGcxrgB7F4VqSzhvZ1Lobj
	 DuSnBAfxjFmq1+zSNm/DT3jZbFJYvco0WbEUssT3dB3VV0NvMRkZh3Z/8p8KCe7oqj
	 bOb4f5TJ8REjg==
Date: Wed, 15 Jul 2026 10:32:16 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Qiang Ma <maqianga@uniontech.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: clear zapped attr fork state when bmap repair finds
 no attr fork
Message-ID: <20260715173216.GO7380@frogsfrogsfrogs>
References: <20260715103026.1701559-1-maqianga@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715103026.1701559-1-maqianga@uniontech.com>

On Wed, Jul 15, 2026 at 06:30:26PM +0800, Qiang Ma wrote:
> xfstests xfs/377 can make xfs_scrub repeatedly check and repair the
> attr block map after inode repair zaps an attr fork.
> 
> When inode repair zaps an attr fork, it records
> XFS_SICK_INO_BMBTA_ZAPPED so that scrub/repair can revisit the attr fork
> block map.  If the fork has been reset to an empty state and removed,
> BMBTA repair has no attr fork mappings to rebuild and can return success.
> 
> The post-repair scrub then runs with XREP_ALREADY_FIXED set, which means
> xchk_file_looks_zapped() deliberately ignores the stale zapped health bit
> and asks xchk_bmap() to check the current attr fork.  For an absent attr
> fork, xchk_bmap() returns -ENOENT.  Returning that error prevents
> xchk_bmap_attr() from marking XFS_SICK_INO_BMBTA_ZAPPED healthy, leaving
> the zapped health state behind even though there are no attr fork mappings
> left to check.
> 
> Treat -ENOENT during post-repair BMBTA revalidation as a clean result for
> the zapped attr fork: clear XFS_SICK_INO_BMBTA_ZAPPED and return success.
> Keep the existing -ENOENT behavior for ordinary scrubs of absent attr
> forks.
> 
> Fixes: d9041681dd2f ("xfs: set inode sick state flags when we zap either ondisk fork")
> Signed-off-by: Qiang Ma <maqianga@uniontech.com>
> ---
>  fs/xfs/scrub/bmap.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index 70028da1aacc7..0cee51d4338e4 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -1170,6 +1170,11 @@ xchk_bmap_attr(
>  	}
>  
>  	error = xchk_bmap(sc, XFS_ATTR_FORK);
> +	if (error == -ENOENT && (sc->flags & XREP_ALREADY_FIXED)) {
> +		/* A repaired, empty attr fork no longer has mappings to check. */
> +		xchk_mark_healthy_if_clean(sc, XFS_SICK_INO_BMBTA_ZAPPED);
> +		return 0;
> +	}

That makes sense.

Cc: <stable@vger.kernel.org> # v6.8
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  	if (error)
>  		return error;
>  
> -- 
> 2.20.1
> 
> 
> 
