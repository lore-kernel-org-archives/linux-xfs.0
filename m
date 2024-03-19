Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E990B40853
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 06:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710831181; cv=none; b=e1bDWAxyr21e/oUCb4MAg6fpXNny0yEN25eGASX7slYJxHUveg2lL5Fmd+Pfi72lqfaFiFXzPDWIYTu/rQplx46viMcK2hIS2IvPtryniW3sBZnJ2lTyr9dGR6sQbDE4D7uxAdpsInRfNao+qGONgOmvhzZTfPobC9ns2UiCRMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710831181; c=relaxed/simple;
	bh=D6myTODQ8YoDeztgF2N0+mn50wrXgtj6ng/eX7RiQas=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VdGFlaX1ZaoeIRQuNAkc6SDGmwg7Gc4X0EgUYIqEdhSzwlGjk/AOeA7z3dauLnuQQWZzjEug0BN1Z+w1+7agwRgQjvQ93LIBY4HD4yqNMBNljw9iQa6FfxIrU9kiwtuvjuSujet2LC/LVfBtP9dQSITJuOo2TmDxe4sLkNb4ILQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=rYgaByIG; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="rYgaByIG"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6e704078860so2397390b3a.0
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 23:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1710831179; x=1711435979; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R0jAGRBCCL7xwEeUUZT0p1D2sLgA0EeZylHhMbzzJT4=;
        b=rYgaByIG8jXdC2oiU9AJlQvVq6OQoOyWJwltd+Ib/vMHXVU/6MxScqQHdt72My5gFI
         BT/8fqhe5eXOSeG3+UFPFEjmFfMToOaFGmWSCw86W8QG5hKC+liN9bR9LQ441DickC18
         boYc+r2WvVOqi+ffjflu9WgJiRapAgCFHWyoVudoDfOMf6qSwN/z6a6m09CTxrOh8HG3
         vRhHRBYmSfD9X6rl5cC3OpMJAooLUf+XnHWRdmnZe9ro/HhRLdWNSFgiEMEz3KXvyBGg
         tiPGnnA8yNnV1wOOScn2HEZxMbQz3+5BKaMhT5snDJS2CddXxc71vtx2bobjDMWnu5cr
         cgjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710831179; x=1711435979;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R0jAGRBCCL7xwEeUUZT0p1D2sLgA0EeZylHhMbzzJT4=;
        b=p8PFdcuXaMHllIB9MDdjdr6pLsV0pRn8oOvpdhpryLML2eQ15aapcO5bD/ishuQRvV
         orz3vPW4M3ZYfhJSxIA8CQqTiQMsG0wDW5CuVkFnRXH4Jaw5WQMPJot/ng2EB8i6Q2mX
         L9GCfkzHvPgvYi74ZNwJKOIfLYNweLWIZq+nVs72Obj4H/IBRnNxwKgXvtvci5EY3AbQ
         mXgKflPf2Hw1k6OhEDhO5YMtNiYR3m7f9ShX+tErHLKFXWK8wontnhyIRl5cLpwo2i/I
         P5/18glYrPjVjVygHHzCaDUVO/nSk5s+YYNf6mrBBYSS25xjcLZDGp1NjWdM79mLQcr1
         ee/A==
X-Gm-Message-State: AOJu0YzbWZvW48rg8b8Vyd8+o31lYnpyy6kDd5CBSktzuwSi4k5aGEb5
	IA1q/BNl49yfTczq0eUk2kFceoAg310nLD04wG2U3DqxkMXmAMk5jG7wvjJEO1m65t+osM4Wfju
	N
X-Google-Smtp-Source: AGHT+IF+XzR3o8JW7a2S5KMgH9A1Eyn5yF9v/k6GTFK5fI2oFmEQ+c6jqAneLbifAIJbxpv1OsgQ7Q==
X-Received: by 2002:a05:6a21:99a7:b0:1a3:55d2:1484 with SMTP id ve39-20020a056a2199a700b001a355d21484mr7888669pzb.5.1710831179090;
        Mon, 18 Mar 2024 23:52:59 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-185-123.pa.nsw.optusnet.com.au. [49.180.185.123])
        by smtp.gmail.com with ESMTPSA id i15-20020a170902c94f00b001e02c15f30fsm2916876pla.86.2024.03.18.23.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 23:52:58 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rmTLE-003xNH-09;
	Tue, 19 Mar 2024 17:52:56 +1100
Date: Tue, 19 Mar 2024 17:52:56 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: use folios in the buffer cache
Message-ID: <Zfk2SLDs7qg/7ioG@dread.disaster.area>
References: <20240318224715.3367463-1-david@fromorbit.com>
 <20240318224715.3367463-3-david@fromorbit.com>
 <Zfky8I5dPLQ7gV9O@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zfky8I5dPLQ7gV9O@infradead.org>

On Mon, Mar 18, 2024 at 11:38:40PM -0700, Christoph Hellwig wrote:
> On Tue, Mar 19, 2024 at 09:45:53AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Convert the use of struct pages to struct folio everywhere. This
> > is just direct API conversion, no actual logic of code changes
> > should result.
> > 
> > Note: this conversion currently assumes only single page folios are
> > allocated, and because some of the MM interfaces we use take
> > pointers to arrays of struct pages, the address of single page
> > folios and struct pages are the same. e.g alloc_pages_bulk_array(),
> > vm_map_ram(), etc.
> 
> .. and this goes away by the end of the series.  Maybe that's worth
> mentioning here?

Ah, yeah. I remembered to update the cover letter with this
information, so 1 out of 2 ain't bad :)

> Otherwise this looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
