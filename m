Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B23F2DD5F3
	for <linux-xfs@vger.kernel.org>; Fri, 12 Dec 2025 16:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765558568; cv=none; b=r372MUPDakcH7XkjUZABiQ/fZQRPSz4v3HQcSXPYTbAfvS8oTsaZHf39Y9iHy329XObGzrugRPBnon5ffaNNnKne8RvT3p1hvApEkYCP2oamVPb/MoROSdZRsJ+qjApotJ3mDXZ2AZ32ppH5QJdnNph6V/Cd4QFFhoDY5IiRP/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765558568; c=relaxed/simple;
	bh=xJjBk7ou17DdQiFO5tjAaXt5YidyV2u3NMl7RZ89mzk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t3D60C+sy65Z9ln58sRdOldmj71Yol9jElf/jkaORwUfW+ywLb9RgSVx6ay0LnlPHG30UILTq4tBQq5byh+7/VblW1WMitFveS15Kl9k/ikdPL/ho4C2zEKuoNndN7QqeqnDNdA12sWdgnPky2yvtOahIdCwslQCIBO/McsctGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O8H6dTOo; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O8H6dTOo"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4775e891b5eso6988675e9.2
        for <linux-xfs@vger.kernel.org>; Fri, 12 Dec 2025 08:56:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765558564; x=1766163364; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+Y1wc+TRrYIV5H1PxMwnXsXLrJlYXmWzBuLTasJP3pU=;
        b=O8H6dTOo3oekzJgRWp21tBHt7ezmWRlmbQZzI0X5GYfOfIi473vYyiSl2n00K0Fe71
         8bpfKfto/RW2u5WQfQIQFJLImdLA3YtslOyHYRG9m/eCxBMy32tz0nOLrRCa7K7aURt1
         EjPAjopPVqNmPgAI2cmwIqlUFK44fSgCKX1ui1hqq13m/oCBszE+0N7hPvs3Xm6WcuH3
         d9Q5x79TFggv19rr9TPSKFeql1eFrLAedlgoEG5Gvw6xFtF4myQCfBzM/D3e0huvEwL5
         U8JDjNT65QSxSZW1pcfYmMsxMmfFVt8Ko1BXf7nlZXcfQ0JdRanElPmJzoZIOcVzLD6W
         Bx/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765558564; x=1766163364;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+Y1wc+TRrYIV5H1PxMwnXsXLrJlYXmWzBuLTasJP3pU=;
        b=J3pyN4mj910K1wr2aRN4ZszfBstk6E9ol3CSn+kY42GcgI6QNDvB16O1EFGR1tCAmt
         tOhrIZRr2yc1L4qjKk7HPhYH0Dmn3oGwP419WVSziAVMycxPK1yo8qr0fa40Zwqpb2KY
         Z++kLvnkJNTz/nzUI5TLNBIkEYTjU0PoQCb9EyMeQSXpXydGRFhMDDh2BiULh6ZL0mTp
         CAK9C2eXqja03Y5oIidT2kiVFqBJ5ZRi7OROiYPYlRlZ8/FOJhYnvLwyWzARJskbMvGD
         JzaA76WvdVCnRkmmt7cdwRqBddknG65T+MgYAfzojN0g6Im67srxEhrIOIdtmIV1IVkK
         E4aQ==
X-Gm-Message-State: AOJu0YxE4cTd0oOn7SffIwYINs2DyGuMbpr15bOtmZXtU3m+fCUbSKBi
	Xs2Q+xBlnW4TmVZAAK6Vg6Ify2MQeRtArzT/7XJLZsYjLYuAKcwzxRma
X-Gm-Gg: AY/fxX43Dn5i8WVIkSHohaaKKWsTOo/y+rBadE9STcddFdsbhfUmrjWnNcP+SoYC+eY
	4+yjPIUbKhFT85j35pXx8NbgquU4Z9LHt7elfg+PE00khvFyx7t9K6pVPuLnc0Jepzcpgg77eF9
	RWg3Mkc6lyE0Zd/0wXki3fJq3YOKhrkflylraY2ZA4gyQbuy8oy1oTLsNxFBlyFKXDj3h16AFSr
	+DuTEkWFMsXbQhJd7pMWaFoKe6nXZGoFbNZzACh6P9nTS/VFMe4digMzIISK3028/0wTKa/SI+n
	mpIvIbbJmfAyeRe6VT8wGEkgRyOvlKgQr947q+bSHHA+UgOZ8rcYIJoqN3/tsAfHDicRPwE0eYW
	3Abgak31697jnPfdozwJgvGOU7c+WrcFpR0m3tKn/DtWtV9cYfs4rUs2LF/VU+QwCsLNgwAJB9l
	YBMfg=
X-Google-Smtp-Source: AGHT+IGtimRGjdCY8KOyGafoHm8C8EF0CDcbVbwJSk2tsONOAJZSC+8ESzfGxfjmehYdgEbxFbGfVg==
X-Received: by 2002:a05:600c:524b:b0:477:bb0:751b with SMTP id 5b1f17b1804b1-47a8f90d716mr28228955e9.27.1765558564174;
        Fri, 12 Dec 2025 08:56:04 -0800 (PST)
Received: from f13 ([2a01:e11:3:1ff0:dd42:7144:9aa4:2bfc])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a8f6f3a46sm42818345e9.15.2025.12.12.08.56.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 08:56:03 -0800 (PST)
Date: Fri, 12 Dec 2025 17:56:02 +0100
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev, 
	smoser@chainguard.dev, djwong@kernel.org
Subject: Re: [PATCH v1] xfs: test reproducible builds
Message-ID: <sgb56cw7mzdeebmugn5czivs7ei3g23bfosir6bb66pytuidyo@4irrwmmz4rel>
References: <20251211172531.334474-1-luca.dimaio1@gmail.com>
 <aTun4Qs_X1NpNoij@infradead.org>
 <hxcrjuiglg4qjn4qzgnwdtxpcv6v47rpjrkxaxhmanhxvvwzpx@rz4ytlnsjlcm>
 <aTvOQqfpiJDCw7e5@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTvOQqfpiJDCw7e5@infradead.org>

On Fri, Dec 12, 2025 at 12:11:46AM -0800, Christoph Hellwig wrote:
> On Fri, Dec 12, 2025 at 09:09:56AM +0100, Luca Di Maio wrote:
> > > > +# Compute hash of the image file
> > > > +_hash_image()
> > > > +{
> > > > +	md5sum "$1" | awk '{print $1}'
> > > 
> > > md5sum is pretty outdated.  But we're using it in all kinds of other
> > > places in xfstests, so I think for now this is the right thing to use
> > > here.  Eventually we should switch everything over to a more modern
> > > checksum.
> > 
> > Will move to sha256sum
> 
> I mean stick to md5sum for now.  We should eventually migrate
> all md5sum user over when introducing a new dependency anyway.
> Combine that with proper helpers.  If that's something you want
> to do it would be great work, but it should not be requirement
> for this.
> 

Sorry read this too late and v2 I've moved to sha256sum
Hopefully it's ok?

L.
