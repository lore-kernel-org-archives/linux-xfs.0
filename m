Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28698F66
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jul 2024 02:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719801260; cv=none; b=LR/2JQxoMLtxyeE/iCgZ7rw83p/X6k+S3t63BQfF3TfLaqQ/3+UaLRUnD1trgCTv7S+GajiOF+jPJN1DPpt1DqbBcixYHzPPgqRl0cTwE2w0CCvNg/+jMR5GjAwXbm+BaUbLzaG4ShMeEzOhl/3H5rEKQiqE1iFOCiBxAYZLeLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719801260; c=relaxed/simple;
	bh=Bf7qvXvOfxSYVxXvw5f+Wqy+aRyboDpvp6TfbZFHb+A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iwd/GcaA2HLOoVZE6BhlW0q95bYpR2Q2KPm5lYggXg+4FenTV1HoO60zjopocchiqnEfwNoNSLI12pifqFktqWIHB9c9wqiNoLahqysi4eLumN9sY8NlVjZ8fDEaKyLCchWW1+GxlptkSJmSgj8YagMnMTZ5QXw+QWV1cOz3JoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=QoYW8AT7; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="QoYW8AT7"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-3d561e564d0so1578662b6e.1
        for <linux-xfs@vger.kernel.org>; Sun, 30 Jun 2024 19:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1719801258; x=1720406058; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QA3WiA5BkOYuP93eXhly5M9069HlqMUx74jdW74bq/w=;
        b=QoYW8AT7tK3n3Ja/9hWFt4fTTXLIINixFQqAebS+/BISQsidCbSFcG1HkOEsN3dHbQ
         TuI4xxg7t6qBCeopJ6kdDVrk34lFmbsqDOHE4GLdsvAJV77OJKlXjyx3AVEfJeHJkMqM
         rltcfaDXiMzxRZdgwSEQWuR+VmIqkgVGDOs2Wp5VobnoLFVR50eqyBUNWU35hM/mwgme
         UOcPzy9S+jt/8mZsIXh1AZ7BJMPr2+ODcE5uFXvj0k7yToKL4WOXBR1QfCKDVyUsqBHf
         /xL8VfQHCBthDUScoFIeaMNfFSYg1ue+E75CT4zV4iJKdXt5hSppyulywR+ggwyvSZEd
         Q+7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719801258; x=1720406058;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QA3WiA5BkOYuP93eXhly5M9069HlqMUx74jdW74bq/w=;
        b=tdzTDsJnB6NnyM7NUy+BZA+n5/jMxGlFCijffYu/IwQFPDo5iiVsgrtcdxQFHqiPyq
         dKOORBWzb+NIFcdv2V6sqtkyoiJlLhUKt1mwqBX+1JWnZexDWx12/+VmSXXAMs065PeY
         qo4w+ERgup2oQGD8LxeHyHBWJpH03ZBFs0FJVs6ojbw1HMGJ53/hqTp3n4nMqPIBAvR6
         LBIHxeEdM3QlvP8YaceCkHYCy7FEUJKURJVy4cdZVrV6UihIurauOv5Tas1kfaxc4fn3
         oSUmOC82K0+4x4c7jEOgbzUHoXS0eyilcXGvJQU3yTMZmCrpobD2druUVjC2/ucO8Frn
         Qf7g==
X-Forwarded-Encrypted: i=1; AJvYcCUedOXyHGHpcemI1bU7pbYiBFY8rzqajNAgXU1HYJBhksoPpoxTmifUg/wbaWspv8qh3a1PWkAJJXsKmFpm7hFqpGIEO91KcVix
X-Gm-Message-State: AOJu0Ywco2uZY873xCNSmJ5PHZ+aBvKXcHZIEQOyzSaS2JdAA4lwBv0p
	5r6ByPr78GJweRET2uY0sewbyOI+pWdconnh4fHmBN4/GA8lBzxEtZv87UpxVUs=
X-Google-Smtp-Source: AGHT+IEhF1WaXX7e3DF7d8gDsYzeuaQr19iyJwzavDsUGQdMwQeS4CXpEwNMn23ORea7Cbyz40JGYA==
X-Received: by 2002:a05:6808:1909:b0:3d5:1eba:10b5 with SMTP id 5614622812f47-3d6b2b24eb2mr7205732b6e.12.1719801257454;
        Sun, 30 Jun 2024 19:34:17 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70802664d6dsm5312897b3a.80.2024.06.30.19.34.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jun 2024 19:34:17 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sO6ru-00HQzW-10;
	Mon, 01 Jul 2024 12:34:14 +1000
Date: Mon, 1 Jul 2024 12:34:14 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: willy@infradead.org, chandan.babu@oracle.com, djwong@kernel.org,
	brauner@kernel.org, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, yang@os.amperecomputing.com,
	linux-mm@kvack.org, john.g.garry@oracle.com,
	linux-fsdevel@vger.kernel.org, hare@suse.de, p.raghav@samsung.com,
	mcgrof@kernel.org, gost.dev@samsung.com, cl@os.amperecomputing.com,
	linux-xfs@vger.kernel.org, hch@lst.de, Zi Yan <zi.yan@sent.com>
Subject: Re: [PATCH v8 09/10] xfs: make the calculation generic in
 xfs_sb_validate_fsb_count()
Message-ID: <ZoIVpskbpjVz6zfI@dread.disaster.area>
References: <20240625114420.719014-1-kernel@pankajraghav.com>
 <20240625114420.719014-10-kernel@pankajraghav.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240625114420.719014-10-kernel@pankajraghav.com>

On Tue, Jun 25, 2024 at 11:44:19AM +0000, Pankaj Raghav (Samsung) wrote:
> From: Pankaj Raghav <p.raghav@samsung.com>
> 
> Instead of assuming that PAGE_SHIFT is always higher than the blocklog,
> make the calculation generic so that page cache count can be calculated
> correctly for LBS.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  fs/xfs/xfs_mount.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 09eef1721ef4..3949f720b535 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -132,11 +132,16 @@ xfs_sb_validate_fsb_count(
>  	xfs_sb_t	*sbp,
>  	uint64_t	nblocks)
>  {
> +	uint64_t		max_bytes;
> +
>  	ASSERT(PAGE_SHIFT >= sbp->sb_blocklog);
>  	ASSERT(sbp->sb_blocklog >= BBSHIFT);
>  
> +	if (check_shl_overflow(nblocks, sbp->sb_blocklog, &max_bytes))
> +		return -EFBIG;
> +
>  	/* Limited by ULONG_MAX of page cache index */
> -	if (nblocks >> (PAGE_SHIFT - sbp->sb_blocklog) > ULONG_MAX)
> +	if (max_bytes >> PAGE_SHIFT > ULONG_MAX)
>  		return -EFBIG;
>  	return 0;

looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
