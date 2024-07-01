Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062F08F45
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jul 2024 02:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719801437; cv=none; b=dGERYGHe9Q0YY4/ZB+k5HCz3UY5TmoEjLFK9bL/5IxIytyrL7vQ3OHaKRZfDUTlZYeCsFs3SrSusFmo+HqEC7yJuDk76D1sxbtRqe6J20RJ1v0FwURimaLPkl2oWDP5KofB2Q0OtnKLNjMTuv4R/y8/CNWnnENmTqvtE5LJ7J9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719801437; c=relaxed/simple;
	bh=lqwELc+8R6n7oIAYBPBASK/w4I25XITcOSCEwq6tAxw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ahyJRsdEYRnO2kjGN91vXgXip+oStN3z4nS+VeemsrYayRIeKY/E8LFZ7BUFGsILMMJ3qiZc2OfuLaAWIRDtCsuzMNyvVlGh4GQP/KYhmdWyVDf8Ruo9BM4T0sdIa3jT9Ia1n+gxjdXLQ6o+HstY5cFX+P1hR8TXeAzkLk6BJnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=NrV5CDNg; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="NrV5CDNg"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-5c4498dcc27so363705eaf.1
        for <linux-xfs@vger.kernel.org>; Sun, 30 Jun 2024 19:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1719801434; x=1720406234; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=m0rcRCi2FGvgQgr9Zpkb36TAwmq6Gr7fbHDsnURXNUg=;
        b=NrV5CDNgIRrGPzcNNOjfnQ/zuIwjUg9MzCf8pvoPTUMDsp46T4C5UmZgSoqCwY6Jky
         qcKzIGy9GohMuMkwp/8leAYEGBDDRzSekcEXYK2+aco3iGs3QkUJc4AVZTFDpK9gLREx
         etFTC47NGkOr3rj8sHbMbB5b2H75gN3eiJqnDUxQcU2alRcRvHqZXIF2jJhxJ0eapaMm
         eCrlJo46a/7Mcspx0wneCyA7jFTZ27W1iYI8EeakGzYIxlCTDaYWOKeQE2jTkZKoAjgw
         O9i4WY6d1p0xBom9g9Wd+SIg8RCsPwsmAJJWFE+FqmL1WCEszljK5sPvXx285sEz5yEc
         3XYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719801434; x=1720406234;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m0rcRCi2FGvgQgr9Zpkb36TAwmq6Gr7fbHDsnURXNUg=;
        b=p2EV9u8sr39AjBRieDfS1wvQbfnEPak+mQ0Hx+dd/MxWKPB9B4Y3t8Fhig01Msw7Vz
         lVtJCsRi5YE68096uOgQ6vEJ6n8pxXcU39zF/jcHBn1G6eV9Qhgd4gfkxEM7kuZsR0yk
         gVqQst4BJpFA9NIkCSr+i5zjxz/hbmNGBlcxa92nG2qJnANwQiJSlTjT3pt7XweET273
         3rX9hBn92wPBWHgpSu6BgYaVkCxOwPAM5iUQQpvgKW98Advem5EzIcgn6HJ9ANLorCPl
         UacOKVwkU2A1yLPuYhN4eFdO8Ce6X+iquLj8U+opocBcQtiIbduwFBindHp6Pr6xyW0X
         qJqA==
X-Forwarded-Encrypted: i=1; AJvYcCXdNDRoN1rRKifuuEyJJMQdzsiWO+wzK/douum2ZjEKotT5XFgGKrP3rOyzm55f0x8pvwg5g8QNFgS2g7zIvN3NPL8TdKArKr+F
X-Gm-Message-State: AOJu0Yy2DAfEUAyhKYgpuzJmDEeTmsgtSCn+rCrPAwJnezSV9OW+LhwL
	wFyq4o3OzDnD1S5A4AIYwsolp+cAFDvC+Eni3LzvZeQMG8xsuWbTrTE4Hf4ToK4=
X-Google-Smtp-Source: AGHT+IEKU7/ErAzsurHPsktSpR5wwiSvxcXhKtFFLIUsLHdEdFgaLynxClPU/fi5/wA2tx9Ll0sAmg==
X-Received: by 2002:a05:6358:9201:b0:1a4:b69d:a197 with SMTP id e5c5f4694b2df-1a6acef5ae5mr474319155d.29.1719801434005;
        Sun, 30 Jun 2024 19:37:14 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c91ce17a77sm5548654a91.6.2024.06.30.19.37.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jun 2024 19:37:13 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sO6uk-00HR7V-2U;
	Mon, 01 Jul 2024 12:37:10 +1000
Date: Mon, 1 Jul 2024 12:37:10 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: willy@infradead.org, chandan.babu@oracle.com, djwong@kernel.org,
	brauner@kernel.org, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, yang@os.amperecomputing.com,
	linux-mm@kvack.org, john.g.garry@oracle.com,
	linux-fsdevel@vger.kernel.org, hare@suse.de, p.raghav@samsung.com,
	mcgrof@kernel.org, gost.dev@samsung.com, cl@os.amperecomputing.com,
	linux-xfs@vger.kernel.org, hch@lst.de, Zi Yan <zi.yan@sent.com>
Subject: Re: [PATCH v8 06/10] iomap: fix iomap_dio_zero() for fs bs > system
 page size
Message-ID: <ZoIWVthXmtZKesSO@dread.disaster.area>
References: <20240625114420.719014-1-kernel@pankajraghav.com>
 <20240625114420.719014-7-kernel@pankajraghav.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240625114420.719014-7-kernel@pankajraghav.com>

On Tue, Jun 25, 2024 at 11:44:16AM +0000, Pankaj Raghav (Samsung) wrote:
> From: Pankaj Raghav <p.raghav@samsung.com>
> 
> iomap_dio_zero() will pad a fs block with zeroes if the direct IO size
> < fs block size. iomap_dio_zero() has an implicit assumption that fs block
> size < page_size. This is true for most filesystems at the moment.
> 
> If the block size > page size, this will send the contents of the page
> next to zero page(as len > PAGE_SIZE) to the underlying block device,
> causing FS corruption.
> 
> iomap is a generic infrastructure and it should not make any assumptions
> about the fs block size and the page size of the system.
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Looks fine, so:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

but....

> +/*
> + * Used for sub block zeroing in iomap_dio_zero()
> + */
> +#define ZERO_PAGE_64K_SIZE (65536)
> +#define ZERO_PAGE_64K_ORDER (get_order(ZERO_PAGE_64K_SIZE))
> +static struct page *zero_page_64k;

.....

> @@ -753,3 +765,17 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  	return iomap_dio_complete(dio);
>  }
>  EXPORT_SYMBOL_GPL(iomap_dio_rw);
> +
> +static int __init iomap_dio_init(void)
> +{
> +	zero_page_64k = alloc_pages(GFP_KERNEL | __GFP_ZERO,
> +				    ZERO_PAGE_64K_ORDER);
> +
> +	if (!zero_page_64k)
> +		return -ENOMEM;
> +
> +	set_memory_ro((unsigned long)page_address(zero_page_64k),
> +		      1U << ZERO_PAGE_64K_ORDER);
                      ^^^^^^^^^^^^^^^^^^^^^^^^^
isn't that just ZERO_PAGE_64K_SIZE?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
