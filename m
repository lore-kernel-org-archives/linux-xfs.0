Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C92A627FC
	for <linux-xfs@vger.kernel.org>; Tue, 13 Feb 2024 22:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707862198; cv=none; b=Cwdkzd3TIdoVRcMidJDs7A8IgLAXCWlPzlBUSQ0kHhju5b4B28kk7hcNDxmxXpEC2M9fQgrMhYzxYjFTFyg/K7TO11I8pEo2QB/Pw8Ew3PUvE1VKL+wo6YZjxlo2E2pN66LuWXhwgldtXWH4DkIrrYOyA+hst0Mx9Q5iUX5CvQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707862198; c=relaxed/simple;
	bh=W8CKXLRXzCPIbeiYhYvLTtnfDtGO8TmN5pF7T5jBlOE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hS7UvTO87II3WgTipksaGmB8S/kNtJBzbdFkake5MJKOfadkmsIXV4Y1VQmOLLJxFS4GxVXmf9yTmGHo60UEjpNZEW73U4SEuheaMxZcXhKFnzWpDGrjj1x6YNzjbROXHyJcvULcjUm3Re+0oNpZ7glESa94eFo5M4oVBEy+JsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=ErAo2G/h; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="ErAo2G/h"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1d51ba18e1bso47412685ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 13 Feb 2024 14:09:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1707862196; x=1708466996; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KHrAkUvYa6loZ8pQ9MvgMBm7Y/FcJKqjouZpJd3Deg4=;
        b=ErAo2G/hJ/ZxmlbuU9tjLAdCWW2ovpypumay2kxa3Q4ub7fwWqDo94g2yvKnIrlZG8
         eCCec52cAgWrPjktmrsyQqTbFm+lCLeW8GJfPmQi6ekECy4qrXtGKc/XgQICTzaNqYfY
         LwVBbXwijBQR7+Bq1HCkbdaj101v2hC7wMYESLg7FuYSGh7KWkPMeK/fLri4DZb38mGR
         Co06+kfrnFyjim5orX5wksGvdzVyN5NvF45lMsb4D6wHE9AvbPBMcgsW25Nv42awDlak
         jrbjUdD72BLFExhEtghrcyK9kFNBDoxc3iv11fFQpvtnJngncV8BMiGjn45IVsp5ptsr
         9puQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707862196; x=1708466996;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KHrAkUvYa6loZ8pQ9MvgMBm7Y/FcJKqjouZpJd3Deg4=;
        b=C43qF5EEYvRutHqh/ds//kVilwS4DxD0bmtRs1AGBq6ibecAc2tnLuCTi+UZvQTRoM
         34OXhl6TKDN9i+e7hONO621aXRzgaolVuZVGLpvATFw/bttVI85Cyy9jLTTp8qjzbc9b
         S7RtoKGinIYd85EBD9EeynhzyXB1SV4xOlr98WUh+QNMGh78F8door8ytZ7wg7rLmDiH
         I5hLh2Kc3xcpW45Q0gwvcaF3yWDvfuaaidn01tbQG7sxI66icUuQnxnykzcU99vKE/yp
         iZTGM20xztJAM7zNFIrj2DF7+LLnTDnKAKtJP3T/D6b0b/sso+3t+tuAEZU6NxnXFMgY
         Cmqw==
X-Gm-Message-State: AOJu0YyNaYtbx9QdpaIdZcPhsVClrc26BnwJxq0xtJjgCQ9MZ5ptFCO0
	cH9lLmIeYBorsovfWDt9RBpYH+/bhfD1CpN7BI6NOqFmNbUUqvFZZeGJnMKUlQI=
X-Google-Smtp-Source: AGHT+IGgqUUsjn257/XY2P22HF+jK6l4KCqtveCToMslA6YTTEIfSnRD2gkjjAU8E2S7/q7gFf6VFw==
X-Received: by 2002:a17:902:e5d0:b0:1d9:14fb:d142 with SMTP id u16-20020a170902e5d000b001d914fbd142mr1287192plf.32.1707862196652;
        Tue, 13 Feb 2024 14:09:56 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU0ESVTZZSVdnxEus9YiyUaZmdXAgx/Xl1gU3CR6MVu9J4mZ+RaM5oZScWBYV6lzac7Dd70RSYsCsBl6RjMuqdB1SViohyMqK9AjP/0Nubsg9spL66O5OJ9Ilh7PBEprTOECIhR4U6k6dNjIhuTIXL/2IwZhep/x5ggajcUnMC/bk5OAyhKaCOSKT/Fhh0h9gzWNpDTA1yDdR0F3fWjhBlbaaNq9IE4qPiAV6YN6DHzTGkL0o98qmyE1stg1SerRm983++Xdcd9i9cIKm6UmxT76yjpRoBGWL4/rDpAF6zXb4cbDPR+ZUd4YdnTtJs5vpMd34GoiUONqcfhPSbbZ7BjT1L6j/ImosHNqAYul6ynTtmVdRe1uBCKFj0KHY0Z7CP/NUPO++Ga4G3eJACOq5GzM8gHlKkeW/vvvzQ=
Received: from dread.disaster.area (pa49-181-38-249.pa.nsw.optusnet.com.au. [49.181.38.249])
        by smtp.gmail.com with ESMTPSA id jc19-20020a17090325d300b001db2ff16acasm1894517plb.128.2024.02.13.14.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Feb 2024 14:09:56 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1ra0yP-0067hn-1k;
	Wed, 14 Feb 2024 09:09:53 +1100
Date: Wed, 14 Feb 2024 09:09:53 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	mcgrof@kernel.org, gost.dev@samsung.com, akpm@linux-foundation.org,
	kbusch@kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
	p.raghav@samsung.com, linux-kernel@vger.kernel.org, hare@suse.de,
	willy@infradead.org, linux-mm@kvack.org
Subject: Re: [RFC v2 04/14] readahead: set file_ra_state->ra_pages to be at
 least mapping_min_order
Message-ID: <ZcvosYG9F0ImM9OS@dread.disaster.area>
References: <20240213093713.1753368-1-kernel@pankajraghav.com>
 <20240213093713.1753368-5-kernel@pankajraghav.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240213093713.1753368-5-kernel@pankajraghav.com>

On Tue, Feb 13, 2024 at 10:37:03AM +0100, Pankaj Raghav (Samsung) wrote:
> From: Luis Chamberlain <mcgrof@kernel.org>
> 
> Set the file_ra_state->ra_pages in file_ra_state_init() to be at least
> mapping_min_order of pages if the bdi->ra_pages is less than that.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  mm/readahead.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/mm/readahead.c b/mm/readahead.c
> index 2648ec4f0494..4fa7d0e65706 100644
> --- a/mm/readahead.c
> +++ b/mm/readahead.c
> @@ -138,7 +138,12 @@
>  void
>  file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping)
>  {
> +	unsigned int min_nrpages = mapping_min_folio_nrpages(mapping);
> +	unsigned int max_pages = inode_to_bdi(mapping->host)->io_pages;
> +
>  	ra->ra_pages = inode_to_bdi(mapping->host)->ra_pages;
> +	if (ra->ra_pages < min_nrpages && min_nrpages < max_pages)
> +		ra->ra_pages = min_nrpages;

Why do we want to clamp readahead in this case to io_pages?

We're still going to be allocating a min_order folio in the page
cache, but it is far more efficient to initialise the entire folio
all in a single readahead pass than it is to only partially fill it
with data here and then have to issue and wait for more IO to bring
the folio fully up to date before we can read out data out of it,
right?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
