Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E190F3ABD8D
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 21:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782942109; cv=none; b=nVKXvKczYg0rX3+vtbJ5UNTTfwhz401Cl9/IX9TvGpPZH/jJq9wikcxtdKzXZCxfXhjtO6xR6NQETYJsdwdY5Flx5UhFVrgR6UqUVBlmDk7mZOY4WiZKojumDMkHJVIQQ1+hWGJ0EC+3zW/oNiEtXs+SHJy3cV9iFyLCymYKt/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782942109; c=relaxed/simple;
	bh=ZmpflNiwzFEzFxTAOdAyA9mMK+jfHws5nrh3EEEu5UY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xx9kbZd3DMlRsqghl0Qw8qtc/BjieBj+s6XfM2OL7ZCIyb/dNGB98rvYpeckI9UsVN6I24Vi1ksPMMpLJnwpqI3cg9zT42tBLN9Ho8pSFQZi7culuBgfsntVAHW20mKntiFr8zixnVUgqnYRP5qMghrtvLpoV635+VG1eD0cRpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GFrbgh+W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GFrbgh+W"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 60B261F000E9;
	Wed,  1 Jul 2026 21:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782942108;
	bh=FF56WHXX5zDwVohlpczGlpG5hcsTgRBksOwpehJXIWE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GFrbgh+WsvOTC0rRNfJ1tM/4p8L/xRecwUjagL953Czxx5TOuNpKiaSovpNR+ntgK
	 qkl2Eq8olApTXIzKGOw4Uo/zhPHCDCXbysB3fIt5gNveWEhP1kqTeC46qvcDuo5Uda
	 p6zRIdqQLKz1zQ0HzcSannV7wHmCpaOHgTZc5P6c1VU1/YY/MBgaMjUhWhq3OnV5Oq
	 aKsazJ3RQS7r44C+B1pwv6BC6kMXmdrHBOLHxAVN523h6KNXKnO2ZU5NLpUDLKXrYA
	 4D9/kze5ck/1yPUAo+Z7wNJwYcDS7fhCRh4uSjCybwcljICrZkjIj99ZnCt7F3V7fW
	 8ExImNh3gFoeA==
Date: Wed, 1 Jul 2026 14:41:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Weiming Shi <bestswngs@gmail.com>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@infradead.org>, Xiang Mei <xmei5@asu.edu>
Subject: Re: [PATCH v2 1/3] xfs: drop ASSERT(0) on unrecognized log item type
Message-ID: <20260701214147.GG6526@frogsfrogsfrogs>
References: <20260701153833.3155514-2-bestswngs@gmail.com>
 <20260701153833.3155514-3-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701153833.3155514-3-bestswngs@gmail.com>

On Wed, Jul 01, 2026 at 08:38:31AM -0700, Weiming Shi wrote:
> The item type passed to ITEM_TYPE() comes from the on-disk log, so a
> fuzzed or crafted image can reach the "unrecognized type" path in
> xlog_recover_reorder_trans() and trip its ASSERT(0) on a
> CONFIG_XFS_DEBUG kernel.  The -EFSCORRUPTED return handles it fine; drop
> the assert.
> 
> Signed-off-by: Weiming Shi <bestswngs@gmail.com>

<nod> this is a validation of ondisk artifacts, so no assertions

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log_recover.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 5f984bf5698a..a1b373c68f0e 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1912,7 +1912,6 @@ xlog_recover_reorder_trans(
>  			xfs_warn(log->l_mp,
>  				"%s: unrecognized type of log operation (%d)",
>  				__func__, ITEM_TYPE(item));
> -			ASSERT(0);
>  			/*
>  			 * return the remaining items back to the transaction
>  			 * item list so they can be freed in caller.
> -- 
> 2.43.0
> 
> 
