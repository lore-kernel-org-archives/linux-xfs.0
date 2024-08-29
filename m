Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DECC1DDC9
	for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 02:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724896850; cv=none; b=OAAFnMUoWhNvnwRtv+FgvAsUUYx+YaGHVnBznC60tZHsytlZr/uNWaFmMZ2PSfwTll/opci9Ak4tp4bHM8SmPtwne6cgZrQ983kHUWtqiGcgAh3Bwng3CnXrqRo4+Bza5Jxz5ihsitJITxgSW4XdZcqYTjf0w5chZdcXRROT7c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724896850; c=relaxed/simple;
	bh=TMz+DvR0+s71CaYNLz4QFaKgEdfTpOiPrlK+fqzhjzQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EX70hFnK796bp8nuH0M053TtdoHzgcdsBTlYSqlbjATu7bocfheuGSsMveWPlCl/7dMip0wqgRm3Q7TbUJ7Yo4sDCQD1vZKMHm0UZ0z+2c/w4BwT+KL2ZcXyult7VJnbJ0ZXyCMpx1o7HQNkHIAqOYotmf2R81x37yWjjW/v7x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=KluZO9e1; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="KluZO9e1"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-202089e57d8so980035ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2024 19:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724896848; x=1725501648; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1T1G3R/1Y+xMkPjyj/M1zWoJn+B65gOohEWACVxTtxM=;
        b=KluZO9e1BRzwpt4eOzkOo/Jsd7e0eos60nLgdzIJcYl/3J7B5fN75PJnYLPUtBQBFh
         ETEJxECFOgl3z3FNOrZBp9sm/PhYG8659aeTegXVtnBOMrw9LhxSeXTSbU3Mo8LnbqHr
         z+8VYjlBq0SNsAfSSksNAzEUPKK7IcPeS4sOLS6rKlJ15vOPIpemy4XV4aLprlfY1Se/
         oV1s929Bq3v6sVJf945VAr3ztwNsoRTUtvARK3uVIppflP7Bz2kH6Yq5Wch7IvsrZOSW
         3QdAdmc5xercMOt0UEJdesEf7pCMX74B8oYwhYGw1ykKJ8cVyaRUS6rELVrd+KUeC2rK
         +YWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724896848; x=1725501648;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1T1G3R/1Y+xMkPjyj/M1zWoJn+B65gOohEWACVxTtxM=;
        b=Q1FGqnlHC4F66zkAxXKIITymenRn1cgyecRePAhN9S5iezxHyyRwNBIo4BhjDVxuvd
         UhI6CiXAMackGob7b0qtwRDepOujprci2sw2arZa14kLEYb01s9jYBi4Nl4C1Jz140ga
         lEqPKVly9rYPFfU6lAFcdWDLHN0Gy7nDueKvYJYzUTO1ccDVCtouUfMT+77feyRBwVMU
         3PVA912fHcp/+PIkYdKTyR+SSQq7uTiW4jXCnIm6S0Q6yjqAU0YN7xPDIZrY2HpkuWaC
         Ika7H1u0tk0Fd4AHkT4QC+d5m3XEwaeBlf2JbnaAj3kxqQk52MJo15cIVrbawW8fG/A3
         L9bQ==
X-Gm-Message-State: AOJu0YyghxYuLepRS9U0FVwuvfcWj4ANIrYa3C8XrXfvVWxtY7Gl3j2B
	1VOsRzlb0cgWcjY4j9PWbxnJk1nbQPOZAV+S3A3SrtchzIqyUkW7YJlZ+MTMGy4C6qHwa18N0XI
	8
X-Google-Smtp-Source: AGHT+IFZJnSKT6lQsN8GLdbMpJyc4J9YKSOjBNEwjdRbiXD+Epn7+xsUXhaKt0kl9m6m5cSpQP9Q8A==
X-Received: by 2002:a17:902:f642:b0:1fa:1be4:1e48 with SMTP id d9443c01a7336-2050e97bedamr13641495ad.11.1724896848329;
        Wed, 28 Aug 2024 19:00:48 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-65.pa.nsw.optusnet.com.au. [49.179.0.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20515537813sm1209705ad.156.2024.08.28.19.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2024 19:00:47 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sjUSp-00GOxj-2j;
	Thu, 29 Aug 2024 12:00:43 +1000
Date: Thu, 29 Aug 2024 12:00:43 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 04/10] xfs: replace shouty XFS_BM{BT,DR} macros
Message-ID: <Zs/WSw6fm4SyyyW4@dread.disaster.area>
References: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs>
 <172480131573.2291268.11692699884722779994.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172480131573.2291268.11692699884722779994.stgit@frogsfrogsfrogs>

On Tue, Aug 27, 2024 at 04:34:45PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Replace all the shouty bmap btree and bmap disk root macros with actual
> functions, and fix a type handling error in the xattr code that the
> macros previously didn't care about.

I don't see a type handling fix in the xattr code in the patch.

If there is one, can you please split it out to make it obvious?

....

> -#define XFS_BMDR_REC_ADDR(block, index) \
> -	((xfs_bmdr_rec_t *) \
> -		((char *)(block) + \
> -		 sizeof(struct xfs_bmdr_block) + \
> -	         ((index) - 1) * sizeof(xfs_bmdr_rec_t)))

> +
> +static inline struct xfs_bmbt_rec *
> +xfs_bmdr_rec_addr(
> +	struct xfs_bmdr_block	*block,
> +	unsigned int		index)
> +{
> +	return (struct xfs_bmbt_rec *)
> +		((char *)(block + 1) +
> +		 (index - 1) * sizeof(struct xfs_bmbt_rec));
> +}

There's a logic change in these BMDR conversions - why does the new
version use (block + 1) and the old one use a (block + sizeof())
calculation?

I *think* they are equivalent, but now as I read the code I have to
think about casts and pointer arithmetic and work out what structure
we are taking the size of in my head rather than it being straight
forward and obvious from the code. 

It doesn't change the code that is generated, so I think that the
existing "+ sizeof()" variants is better than this mechanism because
everyone is familiar with the existing definitions....


> +static inline struct xfs_bmbt_key *
> +xfs_bmdr_key_addr(
> +	struct xfs_bmdr_block	*block,
> +	unsigned int		index)
> +{
> +	return (struct xfs_bmbt_key *)
> +		((char *)(block + 1) +
> +		 (index - 1) * sizeof(struct xfs_bmbt_key));
> +}
> +
> +static inline xfs_bmbt_ptr_t *
> +xfs_bmdr_ptr_addr(
> +	struct xfs_bmdr_block	*block,
> +	unsigned int		index,
> +	unsigned int		maxrecs)
> +{
> +	return (xfs_bmbt_ptr_t *)
> +		((char *)(block + 1) +
> +		 maxrecs * sizeof(struct xfs_bmbt_key) +
> +		 (index - 1) * sizeof(xfs_bmbt_ptr_t));
> +}

Same for these.

> +/*
> + * Compute the space required for the incore btree root containing the given
> + * number of records.
> + */
> +static inline size_t
> +xfs_bmap_broot_space_calc(
> +	struct xfs_mount	*mp,
> +	unsigned int		nrecs)
> +{
> +	return xfs_bmbt_block_len(mp) + \
> +	       (nrecs * (sizeof(struct xfs_bmbt_key) + sizeof(xfs_bmbt_ptr_t)));
> +}

stray '\' remains in that conversion.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
