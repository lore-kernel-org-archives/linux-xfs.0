Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF9A43E9C9
	for <linux-xfs@vger.kernel.org>; Mon, 20 Jul 2026 17:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784567340; cv=pass; b=V6XLvj1PiMsWuqoSElRPkmxghfVNaNOx9Zck6o9MimO+zQVJFZQR2rBN3yo2ov0SEgz2DwX+azas2A3L9ECygtHMhWYpDecokK3kmhtXyKPk07PTtcGKdG5M9ZDAYFzRMsezgPN4efSwF4AAH7Nx4/GWDbTV4TOILaKdeZ4KavA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784567340; c=relaxed/simple;
	bh=WWr3oWdkA9thr3mPmTFX24PTXG4y9Bqi7LDApv0gSHU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RpU3yiTk6wn/C20dxCxbbhcRS6RD43m/hLRNGqZPV1DfCBWOOCpURXr13UB/jKV8NELcyx26rPZp0Ykmfz09hnH3DLTZwfW1tN8AWPqvl23ayaKJP42gpoEuIvRgtaWQotyaQ513noNyvXcgLvtIZahO1QU4du5DJDs48481r/8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VeoSX/dT; arc=pass smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VeoSX/dT"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4954afac04bso28439965e9.0
        for <linux-xfs@vger.kernel.org>; Mon, 20 Jul 2026 10:08:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784567336; cv=none;
        d=google.com; s=arc-20260327;
        b=eW2tylZ/b4ksrhlUI3pMWVqcqgihGsut96oZUxNkQyl+sMDHs/H2CrkROdICOBgWzo
         qUrAR95fFTlrnWeP1fKUssUrxNeUekh2xbb9CGS+c/VQqA4GJ7wB5r/9/PbBars2U4bt
         ZdV/V0/HKw7cZ0c4QvV/TlS0359YqvYpB9Gw6MWSd0Ts69vYeTkCIGf6CHpX5Fjin974
         CjUMGISmiUqQW70GUkbmzJWwa2pXGFYDYBz1MyvkcgqfZyW3tRedFrNeMEUvbS62Fa6P
         wjDVGt/gPZsN69oFa4W3AcTLLTmMQC/laRh11OtcobhW1/D0Jf6GWYPyB7P1Dwp32zAG
         6Cbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MLZfeSNfk0GyJFPhRPnsJJeloRm+Q/IBJupsdVxyw2M=;
        fh=SSu4I0lMzwuMhhUzJ42WRxD51QZKto1jWTBUiCCsvWY=;
        b=YiJ/WS/M5AnpGyzPQvxQ6+DAWgfkm7e4JQtq7k65WPwLXgA8RwZjHBoNWITcTKU9VD
         SP9bg6a2r4eQpbNpe7DCZ37q/N/wcyXjcxyyd7dj8uO8EF9jq9Ai+1ywDhE0Q3SpGMkx
         M/kr1gK988XipsrTPzm4gVGB4oMHaJ4AHfusxXYk8R2Nzyi29goaf8yYdxL8ZXmHNxlo
         TedPmFMa08cmlqokhf2pWVcNXSvy3SGU+Gmv0EfBg1aZxs+UuohYcnyoUCuWYo+kbBPq
         OMTFs4gEcYOO3YQS5kq5VJKUjunKq3sMH/D0ZLt+tSA8lpps6h0joW3sbPA44ObfdGEw
         oiaA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784567336; x=1785172136; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MLZfeSNfk0GyJFPhRPnsJJeloRm+Q/IBJupsdVxyw2M=;
        b=VeoSX/dT5/spe7F5u90VISsxP1MM9YkgWuL/8/PRDEOu29ToTeOSWarHskNhgJk4Ey
         4uz2d5RCF0HlO0AQ6Ogwm80Amo2GXD5bg7qMF2z74mjnqZpaDvB+4AIE9+s6qDtpwyl4
         gAtM31aLLFKejp/nVSqbmNzJu4SqFaDyTA58gJ7FYUWqKNwmGYDxe+Lm/XvczL82OWFq
         czYYGfIPFvGz60OlrmIfhDW2WK1vGqYLXlv8uow/BXXcdCR+RshWegRixwVpt3yhRV6j
         WNzGNo/JHttx1zYFZWF4bnpr4DUCmpypGXq4+pKw9icfiDtDMLmnmMvfGBn4JocJVdkb
         fUlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784567336; x=1785172136;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MLZfeSNfk0GyJFPhRPnsJJeloRm+Q/IBJupsdVxyw2M=;
        b=Mjku/CLE/PgwsGEGT6hIaqeavXMOMNKuupZ+tQg3K0P3QQqPuJGFh/GbuqUqjlXEjD
         VF3NasODALHCcX+gNODRD+5hWu3QXGOQeAW08mslf3QiSHrjUlqNzklQ5pnKRjYVNpRN
         UXMSYb32hpvmfI6BEnX+DCGVlKAJSkiuCbpiVt6QvswJCzxcg8LQ/6qMKt2YSgfaBOWI
         ZzIwmk0tQaq3a3KO2Wp9qjOTw7PppX3yl//oMSzUl8ESv+NIsS8078WnrVh1uG8cwnuf
         Bab8AqzCy1EQqksKihkbTuf2EB/i6Nx7QAZ0BSjeYsRkMPhxAv2Ogio8vxY9qh0QDCL3
         pekA==
X-Forwarded-Encrypted: i=1; AHgh+RqM83Fz4WDogiGBvcwfX2UgYqNXzrr26gNuxo0dCcFS+70+WhU2AGYki1CsBmFNgvOU3GaZgJzD1TM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXhof0RCaShA3oqm76HE/ywoxvrFaFz6z/B1lDjvgwFHINNfF/
	JncZNFSWdzSQaBFwG3nAJCOSmUaFhrJcWgKLc2PQ4ceSuqE1yD0aptvGq5JeNqUfuJfqBhPgwv3
	LfCWtPnqCAQGYDo0jIfRiIFuz1Mnpoxo=
X-Gm-Gg: AfdE7cnOnXQ3zY3Y4OxA7S13xAqSldmwaExZ//OBrXCAl+mnlvXWMZ0KZPEDemSCMvt
	zyEa5LwSQ0QXTvaRfIx1rbPrNsrPU3uNBISJIWADAh16rHHsRbm0F0XHMBURRwU4t7kDfwCjmls
	Y6bx+iYXbGbvj2a2CsyBmi6vqRra5KCzcvCRkbeeSFXAHW+k5uvWZs2S0TQuYAwDv7dfyl1JIIZ
	sQW9UHxQdJx23Tszka9c8M7FlqvcklX+sUo/1tIT+7s3a4ewnr+F8AcHvwPuLWK1p0FMFjzf0CJ
	3yR0r/24ElbhhVaWOR/RgThw2tzg4jssntJx5hbFZw==
X-Received: by 2002:a05:600c:3b9e:b0:493:c1bc:79bd with SMTP id
 5b1f17b1804b1-4954a41150fmr169137625e9.20.1784567335995; Mon, 20 Jul 2026
 10:08:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
 <20260701000949.1666714-3-joannelkoong@gmail.com> <20260702164339.GI9392@frogsfrogsfrogs>
 <CAJnrk1ZRQaFseAnz3zm31oR3KmQWje5HDJjhNbAQSAQyK9_PMA@mail.gmail.com>
 <CAJnrk1bj4pLpAzLhehrbDJuKWa=WMq-3XOAm9dhsEVDF9WCBPQ@mail.gmail.com>
 <CAJnrk1YkAEUhjw6mNEx70ojN7UMQT__oHn5m1Ng2Lz7FoLRhrA@mail.gmail.com>
 <20260717175552.GT7380@frogsfrogsfrogs> <CAJnrk1bjA+Y5V-87AhNGR5-ss7gUJWwLkjouwic1Mckd2QRH7Q@mail.gmail.com>
 <20260720082023.GC18764@lst.de>
In-Reply-To: <20260720082023.GC18764@lst.de>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 20 Jul 2026 10:08:44 -0700
X-Gm-Features: AUfX_myxykdq5BmH_ibLMFKTMx3f4TAodjFz2tFl3aRbdQZ0aLX2i2ATdYiHhLs
Message-ID: <CAJnrk1ZfQxp0SfnuPe_n0dE8vd2XCuiG8ZWRZWSkDwbiV814-w@mail.gmail.com>
Subject: Re: [PATCH v2 02/18] xfs: convert iomap ops to ->iomap_next()
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, brauner@kernel.org, willy@infradead.org, 
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>, 
	open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 20, 2026 at 1:20=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> > static int
> > xfs_seek_iomap_next(
> >        const struct iomap_iter *iter,
> >        struct iomap            *iomap,
> >        struct iomap            *srcmap)
> > {
> >        return iomap_iter_next(iter, iomap, srcmap, xfs_seek_iomap_begin=
, NULL);
> > }
>
> Looks fine.  And this might also be on of the rare case where a littl mac=
ro
> magic to generate this might fine.  I.e. turn this into:
>
> static DEFINE_IOMAP_ITER_NEXT(xfs_read_iomap_next, xfs_seek_iomap_begin);
> static DEFINE_IOMAP_ITER_NEXT(xfs_seek_iomap_next, xfs_read_iomap_begin);
>
> and
>
> static DEFINE_IOMAP_ITER_NEXT_END(xfs_buffered_write_iomap_next,
>                 xfs_buffered_write_iomap_begin, xfs_buffered_write_iomap_=
end);
>
> (could be shorted with string concatenations, but those are really annoyi=
ng..)
>

Sounds good, I'll add this to v3.

Thanks,
Joanne
