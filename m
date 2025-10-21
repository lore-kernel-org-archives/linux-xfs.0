Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD57260586;
	Tue, 21 Oct 2025 07:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761030161; cv=none; b=e3qCz+ecUKdctdYtriANDijdQkgZa0bd2uIe5H8PDZA/MEzvNvv+3jQE43WPm1qT2HHmXsZI/Amt59TDw0JMbosVA11wYyWrTw8uxUJvpQKw7L9cEJTq3Gbrg3a/cA445GFWqUsyVVCUyip8TbiXa/b1BWNxIUDTpE/Hc/FTTkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761030161; c=relaxed/simple;
	bh=6lEWOnbf4y1y98HAP+LxVFokT9voRQdo4MPMdq5hVac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bEELyo4GuZqRcv+FNCELEbJSrfmvd4hyNfL//SSd2ctM21/J3aTySQzrmi5qqH9fbJOmxA7JyDHs+xn+mu6w3AvN1DcTpc9/CnG16PMEBPxCqRvtg42AJMeVk2XJcxua+ufZd5mSV6sXtJ676Plo4yrs+KwGdKPqhRyyCLc1Llk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=erXKkGm/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="erXKkGm/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4EE8C4CEF1;
	Tue, 21 Oct 2025 07:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761030160;
	bh=6lEWOnbf4y1y98HAP+LxVFokT9voRQdo4MPMdq5hVac=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=erXKkGm/laR+wHFojIbkxwSIaRuI9hXLjpyDKcKZW+TmUpzofZpqRzjSBAMTLIH1H
	 XT8LBljnrDjiC0cqnRajY4uJf8O6hyvpkHqKP0/zvJNaIgXMXcFAAmQxLkGKdv0GJ+
	 cbXoYAzDoPB5YBUYUXdlUCueOCcxvBkF8WSR1qWgj3JHJRgZwOEK0LLu6CCg2rOHpt
	 cVp+PD7kLMWDtK3utBCD27VhpnlJmPDuO6d3ErusEKjwk2+Z/yUaGSbj7LxglSXKU2
	 ZuWThaCUBUIG9BYp8hrrWfCRcQNiM3ylGgNDM6fvxTaGga8dbHjYPZQMnQBK4RVkKL
	 +8Pv993bJnFnQ==
Date: Tue, 21 Oct 2025 09:02:35 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Kriish Sharma <kriish.sharma2006@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kernel-mentees@lists.linuxfoundation.org, skhan@linuxfoundation.org, david.hunter.linux@gmail.com
Subject: Re: [PATCH] xfs: use kmalloc_array() instead of kmalloc() for map
 allocation
Message-ID: <qw64zhza44fxxtoripp2nu7d4tny7wy7dyqapilhxyxmng5jsk@fxyxlisrbcls>
References: <eeslnTm4EeKA2atDj3UKUcXAaGwgiPzioO9tR3Kf0pBEyUjxEO_9DaFIpNYIlc_9ey63h8gqdBsIt9Xjgn7AkA==@protonmail.internalid>
 <20251018194528.1871298-1-kriish.sharma2006@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251018194528.1871298-1-kriish.sharma2006@gmail.com>

Hello.

On Sat, Oct 18, 2025 at 07:45:28PM +0000, Kriish Sharma wrote:
> Using kmalloc_array() better reflects the intent to allocate an array of
> map entries, and improves consistency with similar allocations across the
> kernel.
> 
> No functional change intended.

Thanks for the patch.
Have you ran xfstests against this patch? All patches sent to xfs should
at least pass basic testing via xfstests. I.e. ensure there is no new
failure between an unpatched kernel and a kernel with your patch.

If you did, please send me the results summary, if you did not, please
run it, and send a V2 of this patch  including in the patch description
the summary of the results.

Any changes includes risk, and so every patch sent to xfs should be at
least basically tested against xfstests auto group.

Thanks,
Carlos

> 
> Signed-off-by: Kriish Sharma <kriish.sharma2006@gmail.com>
> ---
>  fs/xfs/xfs_qm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 23ba84ec919a..34ec61e455ff 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1218,7 +1218,7 @@ xfs_qm_reset_dqcounts_buf(
>  	if (qip->i_nblocks == 0)
>  		return 0;
> 
> -	map = kmalloc(XFS_DQITER_MAP_SIZE * sizeof(*map),
> +	map = kmalloc_array(XFS_DQITER_MAP_SIZE, sizeof(*map),
>  			GFP_KERNEL | __GFP_NOFAIL);
> 
>  	lblkno = 0;
> --
> 2.34.1
> 
