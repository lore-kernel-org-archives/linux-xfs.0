Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80AAB1F12E0
	for <linux-xfs@vger.kernel.org>; Tue,  3 Feb 2026 15:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770132830; cv=none; b=FgYBDWEHkp1Xn1W1DemUB2Chfm9RWGwsCw3vn/IiVf4ywf8CUwcSv6x9JbcbCfmlsXQ1y5LaPFz2zJ6NoEr11SGsD18uQ5F2RXoTlAsjGfoA4m/eSsjiDj4nB7V7zxI6wkYHpfK9v/NinJW53xiX0flJOBWUL+wq8FrjbbIzADo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770132830; c=relaxed/simple;
	bh=5xVjCrtQqtlm9aRHAHP5Czrp0s5omQq94yiWqKXs9LI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DfVymC9sec8nZqqktYFeLBOC0nTarMgtHisvX3cBpIjVWPzwxf3F7gXOL6pWkowXfu3E3ZsjYUOqUFTSj56B1qcMoDo6nFF25iMk5gI80WRnqKTQZq7FJknrxqXwQph928yb1OWCbMwf+Q57fRcTGuZfWFhblfjiNjQuJ1znjvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q5p2lNsD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q5p2lNsD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D6DC116D0;
	Tue,  3 Feb 2026 15:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770132830;
	bh=5xVjCrtQqtlm9aRHAHP5Czrp0s5omQq94yiWqKXs9LI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q5p2lNsDl/CGFrZ0HehUNskOc5h0ug1odFTue4v7ZfGhcemeHyBhCNzA7YWsh0e8b
	 8cAPYkniTjlP7rv4Y5m/16rIi8rrZUv8Bk8JwODwp5iEwmWNKPCXmFVYJdO5db4WGn
	 Dy/lxbMxT3zDuwj+XVo0pF5qsybfRuCuBR/yIGBSHSUjsAQ2mRO1it/OdQJWcQ+o+I
	 fZUY8ihkx5CtuQCGQiwA5ahRWC4XFjlaIsnml7o8QkLq9PFVQxzId0ccZQQQatYlhD
	 CNnRnbohRpGrxzx9jJuHSebKHTWCZhSVfoWLG0t9jDk14xevi30MJVkY04z0iml3FQ
	 lE062QIhp7Aag==
Date: Tue, 3 Feb 2026 07:33:49 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: hch@infradead.org, cem@kernel.org, linux-xfs@vger.kernel.org,
	ritesh.list@gmail.com, ojaswin@linux.ibm.com
Subject: Re: [patch v3 1/2] xfs: Move ASSERTion location in
 xfs_rtcopy_summary()
Message-ID: <20260203153349.GM7712@frogsfrogsfrogs>
References: <cover.1770121544.git.nirjhar.roy.lists@gmail.com>
 <476789408083fc88c5fc57eb3e76309439c48a80.1770121544.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476789408083fc88c5fc57eb3e76309439c48a80.1770121544.git.nirjhar.roy.lists@gmail.com>

On Tue, Feb 03, 2026 at 08:24:28PM +0530, Nirjhar Roy (IBM) wrote:
> We should ASSERT on a variable before using it, so that we
> don't end up using an illegal value.
> 
> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> ---
>  fs/xfs/xfs_rtalloc.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index a12ffed12391..727582b98b27 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -112,6 +112,11 @@ xfs_rtcopy_summary(
>  			error = xfs_rtget_summary(oargs, log, bbno, &sum);
>  			if (error)
>  				goto out;
> +			if (sum < 0) {

Oh, heh.  I never replied to your question about XFS_IS_CORRUPT.
That's the macro helper to report metadata corruptions that aren't
caught by the verifiers (e.g. you expected a nonzero summary counter,
but it was zero) because verifiers only look for discrepancies within a
block.

IOWs, this would be fine:

			if (XFS_IS_CORRUPT(oargs->mp, sum < 0)) {
				error = -EFSCORRUPTED;
				goto out;
			}

--D

> +				ASSERT(0);
> +				error = -EFSCORRUPTED;
> +				goto out;
> +			}
>  			if (sum == 0)
>  				continue;
>  			error = xfs_rtmodify_summary(oargs, log, bbno, -sum);
> @@ -120,7 +125,6 @@ xfs_rtcopy_summary(
>  			error = xfs_rtmodify_summary(nargs, log, bbno, sum);
>  			if (error)
>  				goto out;
> -			ASSERT(sum > 0);
>  		}
>  	}
>  	error = 0;
> -- 
> 2.43.5
> 
> 
