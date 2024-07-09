Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76EF3153824
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jul 2024 09:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720518513; cv=none; b=KE+PRqAzRqDhbzPxm01Z4Y2txOXnwgWzso50rzM2bKcLHHOGAdHEegf2jEI+ITxQGSNenGvA1iaHdAEw7Z2pFVrqwQJh2MAW8FVWh5WeLwi60SpE3Xt2UFg8evZLaQu/YIQrG1vRJX2HdF6ACaWtrCn+yl51r7ADkdZ9ezbXCRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720518513; c=relaxed/simple;
	bh=i8zt4DAnWtOXimsaVZjikxi0p1/GN50isftCI114Zpo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RBfsG2hA2FE98s/a5al06+78r/zvsYTb3kB6f+guCC8Vf9lrx1hQwKrmWiVMrd7rCTHYi4BnsrIbRoyRNWOCWmusAwsQDbpF87b4wWfu6QLCoEPsojxldb+lNneQacL9ARGbrt8vjDxCvAMN4AkZxGqnUCXxBc7goz6ItfF+RsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=lY3A5Dzv; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="lY3A5Dzv"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-70b4a8a5587so149188b3a.2
        for <linux-xfs@vger.kernel.org>; Tue, 09 Jul 2024 02:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1720518511; x=1721123311; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=n8P8BhJ/KagIZvInbiBh6jabDNh9gowUgzOmEdjkYkM=;
        b=lY3A5DzvpVfu9orNOjX1lZXswDV006o3g/a6ciVqubKH9xsjVR+egoc5FibCqRsSP0
         xPyM7y6IvmdeoHzOosovzqA+I6sdtJdSsyK5uT0cPH5Evtbd3t9AcQwpkUpZdAGLP6mz
         AipjFFLnlusKt0gbvlZEAIlU2+puOaEVi626jRfrcaa6bQUpB959wnTormW/tC2lm3/8
         Yn42qNRTTZlhj6tFwdPgEkV7Vk4mtPo65kvfG5gfTGdCT/qehMwKClRzH7pUqAj3W6rq
         ZOTPEPoIlr42/t/9Ok+UnIbcEIE1Fxu9K093WTnK3ih2i3jT/AHfdPsYIdLidYyFwXJf
         f8VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720518511; x=1721123311;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n8P8BhJ/KagIZvInbiBh6jabDNh9gowUgzOmEdjkYkM=;
        b=a4R9N1LUuxDoEktf4AQJ6if4FwtDiSpGdUgppTW44lVI7YkVwY807GNVwrLIdAdwiw
         sxwiFoN6NeEeOcF3o17riaOkc94xEsPVGAdx53tfQkMtRKzr1K689qv+xrbqhOVoIhO3
         vIoisuFfV045MT3fgdAf5BoJGc2zcQGZZuEup/8tNF1Q+R+5Z+8LfqEt8q0lmrtvqDs/
         ogn93a59oWOuB41OpoPBc7m9LAp4GMF8p0hEZexR4VoO2cB27pANnyhbxSTrcxdPsVvl
         J0/vRctg8671PcqIMvwCNp51uvGxm9ha0oUmv+QfZBwbbSvlyBqSLq0i5Nd1q+mMfN+o
         dT7w==
X-Forwarded-Encrypted: i=1; AJvYcCXUTTpcAWQqFWonV4Slyoo+AFE8ZKvGvRj/AZSf7phVTYHrVZ2UL6cvBOpIqI29hbFwDx/iYq9akG3mwCLBw+s46vhFt8V5y7EY
X-Gm-Message-State: AOJu0Yy7znX4iOZv+Omo1pjYgMIhVW1mqeEyprfESf68HnvvClSiwNUc
	sW2bA0oixsy/icVHf5dn92Sj1H2r1uC/JEUe3cmTavte1K1hypvKab5p98hb+5JqbIRpND/ZKj6
	B
X-Google-Smtp-Source: AGHT+IGy3P86/LRYaPxfo6lZdqPZkMj4TTo84Oi4SJeUfk80I4Ocamb+8luUE0yGqfaUj7vNLTDWow==
X-Received: by 2002:a05:6a00:23c6:b0:705:c029:c9a7 with SMTP id d2e1a72fcca58-70b4357d888mr2560459b3a.15.1720518510785;
        Tue, 09 Jul 2024 02:48:30 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b438e6d4fsm1413836b3a.91.2024.07.09.02.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jul 2024 02:48:30 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sR7SV-009Ybk-2G;
	Tue, 09 Jul 2024 19:48:27 +1000
Date: Tue, 9 Jul 2024 19:48:27 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] libxfs: remove duplicate rtalloc declarations in
 libxfs.h
Message-ID: <Zo0Ha9nSs7UrKhSz@dread.disaster.area>
References: <20240709073444.3023076-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240709073444.3023076-1-hch@lst.de>

On Tue, Jul 09, 2024 at 09:34:31AM +0200, Christoph Hellwig wrote:
> These already come from xfs_rtbitmap.h.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
> 
> Changes since v1:
>  - now without spurious man page removal
> 
>  include/libxfs.h | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/include/libxfs.h b/include/libxfs.h
> index fb8efb696..40e41ea77 100644
> --- a/include/libxfs.h
> +++ b/include/libxfs.h
> @@ -220,11 +220,6 @@ libxfs_bmbt_disk_get_all(
>  		irec->br_state = XFS_EXT_NORM;
>  }
>  
> -/* XXX: this is clearly a bug - a shared header needs to export this */
> -/* xfs_rtalloc.c */
> -int libxfs_rtfree_extent(struct xfs_trans *, xfs_rtblock_t, xfs_extlen_t);
> -bool libxfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
> -
>  #include "xfs_attr.h"
>  #include "topology.h"

Looks good now.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
