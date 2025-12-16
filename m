Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6816C33EB00
	for <linux-xfs@vger.kernel.org>; Tue, 16 Dec 2025 21:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765921443; cv=none; b=QzrkHsPOV+C7NA8m6BYwW8H27jCdaCkem6lKyFdIDjYKTFcw2byaELP9equnWDjGa5mDB/bgESBVlttMhvsgqtSJifRUISFihG+Awk2OdRYATpDFvpeW+OK2nlf4q7CbOiLxAhDRQrsubdVzxGodxeujlbbnPAGLBllu6ldkqks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765921443; c=relaxed/simple;
	bh=XtZ5GgYk1HRptYsA0TXx3Glj4YELW22rS8Yfaw2xZTM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KM9y3B/ihhwfKXlwVMlBs/tsJKSGce9Yx2Cmd3rfB0uGAOrMu03DScHo7iCQZxcvkxmJ8LkVJ4seiZBhxJ8xWTiVhxqJ5Dd57JaYYuhzyVg/2GMvvZfagXPRWyafCLjuaQkgJMBrzg/6nLK2elRH7mfp8UJs11T+4jtxO0Vk44U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=tJOqLuqQ; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="tJOqLuqQ"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2a0833b5aeeso54980175ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 16 Dec 2025 13:43:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1765921431; x=1766526231; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0F/gzJpNzc7Lwar204iZEdU4283haW9z1mGqUFJA0/Y=;
        b=tJOqLuqQLC0OKmWkZMCzK9SiMt25yyJiLFuyrqu0iRzHEXItBJ7Jy42ONdRZvj7ORt
         WHIgdZC7z5wn5gzCaXSefQVwqMmBKrauS/W52OWo/+mpHZsEfGaDBUxZyw0F9h8DPNPV
         chFTsMtLFe8eWqWsDIydwdiPM4lNL+WPuCg1pK2rhEBgB0NNEcblO0CEZKMyEEYrAKe/
         eKhehRiUMCRvDXdJT0qQ7PbA2uVHbLhRT6FVaZMCCxMbkQKukaoAhpndfK8PcQbecj0g
         p/fqC8A5kf3dx2+7TWRrAxTuvOYx423OR+6GeWUG1jq+SY4Dtz5KmfvgtinR1MSXH69s
         juJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765921431; x=1766526231;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0F/gzJpNzc7Lwar204iZEdU4283haW9z1mGqUFJA0/Y=;
        b=b4p2mu1pYsE/7WlL+wt+UkW8TSK0yZWlll6sLZlmiIXishTD90ZCImexOi2zx/fEpl
         4giLeNri4nRT7RVoWiIdtu2lpld+ZCzI+ln/l/mpV6DvZYKF204ver4uHvtbYjNLLEqW
         6hHy4ti9qNt+3tJbJpWOc5OGtibY5HyETDQ8+fg/2f8dtQqssV/kj1ajaKP9/sGF52CZ
         +Ftt7YrWSUnuyDPm022sDnfJjMGHufVgyQsc60UTNxjPCE5CAm+N9vROLlmfA8QJ1Z2U
         K3mrKOQ4oV/qLFeqjaW2hj/vk57w3u3I42flA+m8KiPyA3DOpJ/cxHEH5tZgaOzFDRzJ
         BiGw==
X-Forwarded-Encrypted: i=1; AJvYcCUUAy6H+4ekNnmhN/k7efWVvQrrRkBGSUogNf9oQg2WQILCI1SDRgxSYmElAPgNKIiikuocVvr4cdc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWFHojL0lHyR8n/qzsYu34pLhG7PWdU6GCeASUclmfhpi8cNRi
	mZEFI5FbcSoOWWEKjdIYiYMjqAiJBnOUljZufa0YD76zkTzjkFDmwJNNGsJBIuS4clw=
X-Gm-Gg: AY/fxX67QX7F0Zp98XWQ6OZPs5hlgvYfOeTrqXzjjzF7nIRBiAPsaHWO3OKe3lBYho2
	VTAl4Xba264Hb4iu4h4IkSTRZGRiKAEUwZ+2mvEsdAzDbtt/3p6/TyMkin2gT7i0O8x5gtJhh58
	PVEqT29WAPQAyuOo4nUF9Zvy3iB2uDChtd6HWTVbDOCuNSvN6NpWCjke52RnBTTtaKyDe+0vIkf
	jkoKHZaxPpbtrzKzNsNhryec/EPmUsbBC5qtYhUxfP122aks9bwpkGjPbP1gmodq0jWs6RuTg3s
	We7B8kapBkFTJE2nFfeUSdOlJoOgFLwNatlXzPqmdR76AbSjUaucCky/XqAPtvBp2WBrRVF5dhH
	C6BnW4SfbmPThdO8jzyhhCzXpQusiaK8Kp19bzaqzWdEiHOeOkXaBELXfeycbT9ekwO7wY/AA5B
	XbVcpaMTRNOxiXS/xtN2iECvCiMLKq2ksnq7ZY/1w20tlNcgQf
X-Google-Smtp-Source: AGHT+IEORefIx7V5vOCcRI8oHBRWbgC5qLt37LqT5Hfblo+QC1sBoQsfdaAytBu56gcdUrpk+bzSuA==
X-Received: by 2002:a17:903:8cc:b0:295:2276:6704 with SMTP id d9443c01a7336-29f24385a97mr134400745ad.51.1765921430519;
        Tue, 16 Dec 2025 13:43:50 -0800 (PST)
Received: from dread.disaster.area (pa49-195-10-63.pa.nsw.optusnet.com.au. [49.195.10.63])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29ee9d38ad1sm173298785ad.29.2025.12.16.13.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 13:43:50 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vVcpf-00000003iuA-3qPp;
	Wed, 17 Dec 2025 08:43:47 +1100
Date: Wed, 17 Dec 2025 08:43:47 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Luca Di Maio <luca.dimaio1@gmail.com>, linux-xfs@vger.kernel.org,
	djwong@kernel.org
Subject: Re: [PATCH v4] xfs: test reproducible builds
Message-ID: <aUHSk4SqAS2RS0Xy@dread.disaster.area>
References: <20251215193313.2098088-1-luca.dimaio1@gmail.com>
 <aUCSSuowzrs480pw@dread.disaster.area>
 <aUDryjk9wdZZQ5dz@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUDryjk9wdZZQ5dz@infradead.org>

On Mon, Dec 15, 2025 at 09:19:06PM -0800, Christoph Hellwig wrote:
> On Tue, Dec 16, 2025 at 09:57:14AM +1100, Dave Chinner wrote:
> > > +_cleanup() {
> > > +	rm -r -f "$PROTO_DIR" "$IMG_FILE"
> > > +}
> > 
> > After test specific cleanup, this needs to call _generic_cleanup()
> > to handle all the internal test state cleanup requirements.
> 
> There's no such thing as _generic_cleanup, and none of the
> _cleanup()-using tests that I've looked at recently hooks into any
> kind of generic cleanup routine.

I forgot to mention: the lack of _generic_cleanup() doesn't mean my
review comment should be ignored - the new custom _cleanup()
function above still needs to do the relevant generic cleanup work
that is done in common/preamble::_cleanup()...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
