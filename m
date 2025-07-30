Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBEA481A3
	for <linux-xfs@vger.kernel.org>; Wed, 30 Jul 2025 15:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753888327; cv=none; b=iA2f5QW04jEFRa3sojtKyQBkwKtIZ/vlLZeu14k08BLnpqSQvjBhu3L0szuetSG9U6wjoj9Mt0sUHr5g50QfrvHQTSj/P3jU032Ti8VLVzK4A7fr5htqC8dNAzPxyfJ81VzA8lNuqAiEnS4c9ZRh9CtvoVHTLaDOph8EU1i5sHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753888327; c=relaxed/simple;
	bh=pd9a2HrcoZlQHRD4BnFCf5WXbgxLlcXBPNyT15Vbrdo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VfRxPF7XL3N73LGHE+RkgWjM+u2QPjqIP0+vPeSIboG8MA94WfhN8r6WEfQirPupDkcpcrLaiiuWSgBUr2hAAYhLjwIUd2sK5AmJtvAdHLhuj2gXhs1YiX76dnDc7HS8sB8WU4r4rBPgHPhyqmoYshldTdhFCBU2AVc25PVfNt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K+58b8Ih; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K+58b8Ih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00EF8C4CEE3;
	Wed, 30 Jul 2025 15:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753888327;
	bh=pd9a2HrcoZlQHRD4BnFCf5WXbgxLlcXBPNyT15Vbrdo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K+58b8Ih0AHY42ZSTYyNQF2sP/40SzXPPjh/LU9NmIQOY/e5siC+7l2JQtWNHYG6E
	 y0QRr1WjO5FkILVHgCLELo3tSyB6fn5DSu7fQNO5x17XkOPRx8rnpSRd/cvhV6ZBbd
	 b+sZnpfHVzAo2xhz39f2dWTeaVGiYKvljF8khi4H8re79UcfB16EG41xkW/Fcm6DLz
	 WuTPlsVkNCTrLRAQp7ERZdubmp/4lI2oetEe8lXIlEc9Elbgt0vXQceOQqmZKKWXDR
	 j8+chOSSmsGIU9RtIqNgA+/IhAEwgo6117QEVhzrFe6XVEzYB350JRcS029a6S03uk
	 5O8LwlAGAFnBQ==
Date: Wed, 30 Jul 2025 08:12:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] mkfs: require reflink for max_atomic_write option
Message-ID: <20250730151206.GQ2672049@frogsfrogsfrogs>
References: <20250730101320.2091895-1-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250730101320.2091895-1-john.g.garry@oracle.com>

On Wed, Jul 30, 2025 at 10:13:20AM +0000, John Garry wrote:
> For max_atomic_write option to be set, it means that the user wants to
> support atomic writes up to that size.
> 
> However, to support this we must have reflink, so enforce that this is
> available.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> Suggested-by: "Darrick J. Wong" <djwong@kernel.org>

Yeah, makes sense to me :P
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index b889c0de..8cd4ccd7 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3101,6 +3101,12 @@ _("metadir not supported without exchange-range support\n"));
>  		cli->sb_feat.exchrange = true;
>  	}
>  
> +	if (cli_opt_set(&iopts, I_MAX_ATOMIC_WRITE) && !cli->sb_feat.reflink) {
> +		fprintf(stderr,
> +_("max_atomic_write option not supported without reflink support\n"));
> +		usage();
> +	}
> +
>  	/*
>  	 * Copy features across to config structure now.
>  	 */
> -- 
> 2.43.5
> 
> 
