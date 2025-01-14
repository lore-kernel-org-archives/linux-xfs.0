Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBD824022A
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jan 2025 04:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736829809; cv=none; b=eJF/jWR+v12kdBCBCgAl19QUxafMprIqeDVSLoi4e8MlaEJXg9Qhe+sjI+LSR4hv2x7nPCF4RWJGX0+WoxVkVTLswv7ceWt+vC6Rvzsk6Rj86XoKUUrp1IZXFLgsqHsgMAKjYTLghmyVra+sAawQ7+dcbpgWSBCHjS3htsLfYKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736829809; c=relaxed/simple;
	bh=nO5AagkuvG0CHgpgTF/sFlqC52MFQQuVw34NJHOjQUE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KPbdf+Xltp11hrIfRjJ4BJPPQ13aekIg32KzfJ0FymUYuNRQmbxAS0mjd6mue4iz6MQoZb6EiKqX6eEwhU1p/ex+WVtEu1SDHB+hcTyFDJasr03/tKdXJJQxjyX06xrzk/AzXN4D+ITqgpOu9t7C/3AJM40vwTx8oYgYN/ngr6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=OYXMMdQ5; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="OYXMMdQ5"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2156e078563so74853745ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 20:43:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1736829806; x=1737434606; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FOdtzYCF4PXzJzLjRup3D8rICLmH9SzW0xMwOnYJEX4=;
        b=OYXMMdQ5XZ7qQ1XF4L2h3ZAJcvy2RW2mgaLED3Wtk9/2CDKZ8EMwgQX8m6zg+a6TQN
         FhjLl0bkmasBbC81IQRaOkHpYxcmDAGY3w+O7Z73rFjPFK192rJiklBSoUGq4OFS37/b
         RZOTMVDjf/Hl5wtCpugEMQ6CWOvSKbuETIBfE342DJLgyqTccCeCUBJl/LfUrH9gn77f
         PEUHr0YVaB9+MxgEFbe4iw0TYVGVlPUwl/3ms41Yz90WqtQaAcR7TRtxyXG3MSt1mmZq
         ijwieZtrH5ROIeBN3avKcYwLQB6ORexbfyEpXA1Oz+Lsk3EisEQzGz993uHbumu6obOm
         669g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736829806; x=1737434606;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FOdtzYCF4PXzJzLjRup3D8rICLmH9SzW0xMwOnYJEX4=;
        b=pbDKmEZZvNFekdliD+XHuM1p1T08APvW94bDGduzpy+Coba/yQALF/O9DSJCnPgCTE
         cI8obes4R4Sy4h1+K6Yc1XvDqxdmuYAtJFWbuZqtZhz9UmXqSqugAxu2uOaOPIkZdx85
         uN20EzWXCCB1BHAl/KECAw3l2tIhhTe20d/vjIuHiEeEGGRSD2UUkXI/GcwjmJ8EpCHb
         7wLxKdetLNgcUlItSi3d3C2pBiNYe6PjwCCIbzXA1DpvzIz1MZo9xGRRLIlTY6xvZ/Gz
         7S1mAzjsVMAF+o1Zg/cNbXGF7CHrNoN/2PFrTzwUFofe0A2oRN8xGAjhAQMCJUk3NQ9L
         ay6w==
X-Forwarded-Encrypted: i=1; AJvYcCWw4Oh5Czwkj2qBgvZesbuYdHko444ou4xs91Ds5xqeamqJ4zRVhqHeIZDOSZ5i1z8EfkB2reD21uo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgZL3XIFiKg3/ZeHgN/L8h5f6Xv6hqIN0tdFwBtk6FCrwsFN9j
	ldoBXxrZ+A3zUlZ4AbDge4pbuf19xmIDv3L56deqzoehXMWLOaBSIUJ6rhKPU3M=
X-Gm-Gg: ASbGncvrssJH0XwomMRRJcHlX62Bur3wPX7KYne9zzOoUiQgwT/YqsH8B+k9tDEDg8Z
	FkmwoBsVW0PkANqj38iQoKBMuA+9uCquoAxZOoFGrYCbsYFuyAqkwEr/H1L3rnePEG2qiMzCA1j
	MRuzbO+2dflVBqQ9vPpCsWyKsSu9cxgilYp0AZmlR3pIeWFPnbyXd5ZeOGcjPEB4ISaFi/ds/eN
	MNdlOS33d7QhuK5/9dCrFCedQlqxGlnu0kZQevvovXRB4m5D8DfXk2xrMn4rrdiCctKJizFmTcS
	vYh0b9bjokVOC7nqvYZlUg==
X-Google-Smtp-Source: AGHT+IFIYoO10KXTw0TKOC2xQh5bB6yv5WT3SHul1tP+v8nfNDVO8DNOzTyw/VSP/0d5X2siEOlP2Q==
X-Received: by 2002:a17:902:ecc5:b0:215:7dbf:f3de with SMTP id d9443c01a7336-21a83f5e4e5mr361278165ad.28.1736829806581;
        Mon, 13 Jan 2025 20:43:26 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f22d0fcsm60480815ad.161.2025.01.13.20.43.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2025 20:43:26 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tXYlu-00000005cfW-3hFx;
	Tue, 14 Jan 2025 15:43:22 +1100
Date: Tue, 14 Jan 2025 15:43:22 +1100
From: Dave Chinner <david@fromorbit.com>
To: John Garry <john.g.garry@oracle.com>
Cc: brauner@kernel.org, djwong@kernel.org, cem@kernel.org,
	dchinner@redhat.com, hch@lst.de, ritesh.list@gmail.com,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH 1/4] iomap: Lift blocksize restriction on atomic writes
Message-ID: <Z4XranZM2tCFbqZc@dread.disaster.area>
References: <20241204154344.3034362-1-john.g.garry@oracle.com>
 <20241204154344.3034362-2-john.g.garry@oracle.com>
 <Z1C9IfLgB_jDCF18@dread.disaster.area>
 <3ab6000e-030d-435a-88c3-9026171ae9f1@oracle.com>
 <Z1IX2dFida3coOxe@dread.disaster.area>
 <ef979627-52dc-4a15-896b-c848ab703cd6@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef979627-52dc-4a15-896b-c848ab703cd6@oracle.com>

On Mon, Jan 13, 2025 at 09:35:01PM +0000, John Garry wrote:
> Dave,
> 
> I provided an proposal to solve this issue in
> https://lore.kernel.org/lkml/20241210125737.786928-3-john.g.garry@oracle.com/
> (there is also a v3, which is much the same.
> 
> but I can't make progress, as there is no agreement upon how this should be
> implemented, if at all. Any input there would be appreciated...

I've been on PTO since mid december. I'm trying to catch up now.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
