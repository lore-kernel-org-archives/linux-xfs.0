Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A2E19F103
	for <linux-xfs@vger.kernel.org>; Sun,  9 Mar 2025 22:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741557838; cv=none; b=a5Tj/RIYygDTEIgKDk9gGAJV4wVMTNDeVLT5V+KkhjocJ5H3ldYvru8H8HeXH6oqpz7F5JVWO59YhmtnF7LHhIzpkOXKU/VJwgj1h8ML1K71R0n4yfqWpAGPLu/ZJ8Zrk7ye/J56pwY4nDoZqEtWJSg3gV8PsPYtytFIscyX/lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741557838; c=relaxed/simple;
	bh=JQLHE5htqxDYXrr3QIScKSn+/HYlywKSaeUU+2okPcU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uu/3pReWM13NR7IiWAOVKIJH6Q4tMwUdweT8VEP4lZfByiA16GO1bWZq5ObOezSf1EluCb2CryL6HlfZDZcanFt5Q3F4NsDYFMFWOb9/C99rbQn10/ItoysUSR+YQR93vbW0eFd2m/OXKNbU5CcfGuo/D2qexyENTT+vgkCRKY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=ll43LU1b; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="ll43LU1b"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2241053582dso48574605ad.1
        for <linux-xfs@vger.kernel.org>; Sun, 09 Mar 2025 15:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1741557836; x=1742162636; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hIVTntw+6S/j1ajpJsjlP3frsHftTY0cBdO3R42IMlg=;
        b=ll43LU1bXZEzSHG31syp3/u1KtqXGWnqNXo4+/NowRduZ8faC3R44O86Y7ViHhcU5f
         PMMLfuk3m7wRuJ2RkBd+hz1XESN2NJMiwNR5DLWdxEoKv/aetFovHGpiLeODnn3ala6k
         omsffJQFHJINszzt0y3ROVGIJsdr9UWTtcSDazyBoTJ7jboGIqNBvV88qloCCKNOt6N9
         Ddtb93qp5cmY/6hcWPDQZqSBNYSY1rEXqKvSHnnKXDhJqYBtAVVMjQoMS9CES1GgdTfa
         Szz994YEILL8qlpxI5gsvP/jtWAQ0NXzjGjtRIucBpuA/7pc7zGQcB6Up/Y6yWhcoLZ3
         Le4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741557836; x=1742162636;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hIVTntw+6S/j1ajpJsjlP3frsHftTY0cBdO3R42IMlg=;
        b=S4KdGl1FY/6rKoyFz80UR3zRTP7P0fhaJ+qaJBvh6OWLjgntFDSYEhDFjtc9whz1yO
         m+Y8fSiVbJVP1j1vVWAw/XKJX0aVCgE2nx+E2oGAfWXnN7oHeWA59VutD6yV3oRVffQn
         HBZHAz57lpWc3KlaXGOJrVYrQKcudfEcAMQI1vGFdlA2UnjB7iozeMWjgxHcmzOQf9AN
         L2Of60nJV2EtcRy/0h3BDv6y7q+wuaZOIKzQcTe02/H/b9Uy2IWhQnuRcE1eOmjVKuPX
         8508g0dvHpsj3T2SdUoZYACObRNRsVmoGO0wiYMCoxFxRi5lSZuLn8Rx1DK/9mGWZG9M
         FVIA==
X-Forwarded-Encrypted: i=1; AJvYcCV0Q4GwSnURYNB4dGvuzn3M9smo1BP3549MyHCOjw6WJJQCYfbnu+eA9thpPtQ6A9LTHMj2LodL3PA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy53p02avocGu9ljBSEv/Z2DeY9rsMVHzMFBzT23nUqaNznmXGl
	tXqXO28tJO+XFPEAUYIt1AgNA6chr5H5sunhx+fiexxB3RG1LvLQGoVjwt3Pg2M=
X-Gm-Gg: ASbGncsMoeV/h8H+qaynMW4x1nxk+Wqq6S6c73hpXfIG6PEtX4oBAs0dtpq5Z0RM4+l
	/L5i8+pe2dcAdIx1miZTJeviif5PRJFRHUvkqAhG9wA9awo0clUUVLrGm4nM3O1+eapVcB1d2sb
	hMYo4RKBVxfZCjOGHQhax00uDlRvU9CJXzRc8Gu5qK7ByiFUaLDU0oxYE9Qgo8LlMci7l2DsZ4I
	/6f/iRn5v1O4oHMbVu8Gxs9qzU6s1HbkPGGOOOHpIVTXzeISEdPS79JbboviCqni6YI+BKDHSBo
	CyJ4PsduwfgZGQafVEXa3gQhB53d5tu0rthaHRQ5vZsdbLQBLxmOXkDdzC9bNDm2Ms9gRUtORq6
	UNVPkmq6Vxc+FAfsDkLRXCOZLnWRg9jc=
X-Google-Smtp-Source: AGHT+IH/powE1N2CCtK7Ml2mLRBsL6fzJEMihCFIpP3W69gTDvwEB08TAGMnpbJmG62pqfj+ytkESg==
X-Received: by 2002:a05:6a00:4b4a:b0:736:5c8e:baaa with SMTP id d2e1a72fcca58-736aa9bc0e9mr16487541b3a.2.1741557836403;
        Sun, 09 Mar 2025 15:03:56 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736be0ae3desm3435489b3a.12.2025.03.09.15.03.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Mar 2025 15:03:55 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1trOkR-0000000B2kg-3jwt;
	Mon, 10 Mar 2025 09:03:51 +1100
Date: Mon, 10 Mar 2025 09:03:51 +1100
From: Dave Chinner <david@fromorbit.com>
To: John Garry <john.g.garry@oracle.com>
Cc: brauner@kernel.org, djwong@kernel.org, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, ojaswin@linux.ibm.com,
	ritesh.list@gmail.com, martin.petersen@oracle.com, tytso@mit.edu,
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH v4 12/12] xfs: Allow block allocator to take an alignment
 hint
Message-ID: <Z84QRx_yEDEDUxr5@dread.disaster.area>
References: <20250303171120.2837067-1-john.g.garry@oracle.com>
 <20250303171120.2837067-13-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250303171120.2837067-13-john.g.garry@oracle.com>

On Mon, Mar 03, 2025 at 05:11:20PM +0000, John Garry wrote:
> When issuing an atomic write by the CoW method, give the block allocator a
> hint to align to the extszhint.
> 
> This means that we have a better chance to issuing the atomic write via
> HW offload next time.
> 
> It does mean that the inode extszhint should be set appropriately for the
> expected atomic write size.
> 
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 7 ++++++-
>  fs/xfs/libxfs/xfs_bmap.h | 6 +++++-
>  fs/xfs/xfs_reflink.c     | 8 ++++++--
>  3 files changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 0ef19f1469ec..9bfdfb7cdcae 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3454,6 +3454,12 @@ xfs_bmap_compute_alignments(
>  		align = xfs_get_cowextsz_hint(ap->ip);
>  	else if (ap->datatype & XFS_ALLOC_USERDATA)
>  		align = xfs_get_extsz_hint(ap->ip);
> +
> +	if (align > 1 && ap->flags & XFS_BMAPI_EXTSZALIGN)

needs () around the & logic.

	if (align > 1 && (ap->flags & XFS_BMAPI_EXTSZALIGN))

> +		args->alignment = align;
> +	else
> +		args->alignment = 1;

When is  args->alignment not already initialised to 1?

> +
>  	if (align) {
>  		if (xfs_bmap_extsize_align(mp, &ap->got, &ap->prev, align, 0,
>  					ap->eof, 0, ap->conv, &ap->offset,
> @@ -3782,7 +3788,6 @@ xfs_bmap_btalloc(
>  		.wasdel		= ap->wasdel,
>  		.resv		= XFS_AG_RESV_NONE,
>  		.datatype	= ap->datatype,
> -		.alignment	= 1,
>  		.minalignslop	= 0,
>  	};

Oh, you removed the initialisation to 1, so now we have the
possibility of getting args->alignment = 0 anywhere in the
allocation stack?

FWIW, we've been trying to get rid of that case - args->alignment should
always be 1 if no alignment is necessary so we don't ahve to special
case alignment of 0  (meaning no alignemnt) anywhere. This seems
like a step backwards from that perspective...



>  	xfs_fileoff_t		orig_offset;
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index 4b721d935994..e6baa81e20d8 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -87,6 +87,9 @@ struct xfs_bmalloca {
>  /* Do not update the rmap btree.  Used for reconstructing bmbt from rmapbt. */
>  #define XFS_BMAPI_NORMAP	(1u << 10)
>  
> +/* Try to align allocations to the extent size hint */
> +#define XFS_BMAPI_EXTSZALIGN	(1u << 11)

Don't we already do that?

Or is this doing something subtle and non-obvious like overriding
stripe width alignment for large atomic writes?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
