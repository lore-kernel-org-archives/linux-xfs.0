Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04CDA4071E3
	for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2026 17:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654913; cv=pass; b=qBYiRMOeGl+GSBgS98zD+MrtyYhcWvffJtqCjZy4EYkskZBp8wZV7K3i3i6gEERW0L/eSna9UoEoG62of8r8FMKtKts5fklgTP5rrgm/crXJSXI6kyrm6ifldtxlJJMdzatKPUu+uBRoTUbFnUfczc1D1e4hDt4vVyao/cb3Ueo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654913; c=relaxed/simple;
	bh=WjClDNSarC5QjzoostKn8ApH6JwQOJ4VlSQLjZNFJ74=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SUZwjBtL6hylw9TLyZZCF7eJlGI6aiCYQzmdCMoHAKTUnlDWa3qHIVv+3E9myObJgEvMkIVzIjpJ+dMOJDqEIyFRwBmI/WClw8KIsKjjGUsyQ/ALlLiqSXjygUnBvy7oNuYgRsRG2wXrbtAu3mV5GxmO+DcfX2ASCo+VqoLmRsk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=m1UMgNPJ; arc=pass smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="m1UMgNPJ"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c9e30214d8fso8288641a12.3
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2026 10:28:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784654911; cv=none;
        d=google.com; s=arc-20260327;
        b=Lct/9OSnhggBMb8lztdywMaZNNTpqUs/9fFspG+OY+OLOZTLwJ5jMXOeQUZOGCLHff
         tNhySts32gkMiTkSfFJvvw1+GPVE882uRdK2Gj41+CZDhCmqp9sBQDrsjkoLLNdQsF/+
         GeHlOr5tTEmhfnRFSQBijTaHiC1kgNkojRKWFDWQGMcfr9NuXIhRkGR0awG5U5j6W5Wz
         nLn8FhifrV4LmsTkCaQRoijWvt1Gy2IQHuD43s49BavPto0na9wbq+CwgvjP0aaMYhXK
         OiqjtiE6azMmIbSPZz3tqYVp+knwJDlteo/ZeiD2bO1QG3Lc6U5oVb6MzHYV/JwSx1m6
         e9lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sEpucA6cJ+wFKkMEgPwzn/PVy5HptrOhm/qxg/NLr6w=;
        fh=czvnWh6J6eeE3tjMyn/rtos/aSFYZC0LHf/DdlZ5lDs=;
        b=arC3ZZrq1wtsjUp19B6pJufuUQ1YESazHEX8hiF/H1QBxjbAlCuXHIOfQkX6TmMyFb
         X/DhhCgFp7heArvwKMaod6TIuGkdT7I+7qvwkUjmVG+FnYptbJ7aJcr01h0534Vc5IJl
         UakpvBf1UPdaGQro1+f+9R0mYwyg1fT78X/jQOiVz2Gzgfq0zXz+QACfRDZAmqvKMiQ+
         WgicHE0Fn3BwxMiuC6EiZx1IATt+qpANmdNPQvDFaxp5D3GyJ4RFcfOaFfriJUVm+xqQ
         wBjWBj17yEXKnTRxdtC6CEsI+DKDUw/s5hEKYio6YfDVgJMJTy/4LT1LLA+YHObqs3lf
         jIHw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1784654911; x=1785259711; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sEpucA6cJ+wFKkMEgPwzn/PVy5HptrOhm/qxg/NLr6w=;
        b=m1UMgNPJs2Op6PWWJNnyP0xAuS3lVjlTjxuo29aVj9W3g0FWhhuKUDQMyXOpEbnnDz
         zzAVM8HJ9qV9jrKBS6AkraftM+Z8KtleiEw4Q3A4Zi0M4eczJQl47WPHgGlfFFDQUNLJ
         AvhS2ylrghZ5Bu7mVhrLBIe1V1yPTGtanKr8TruC3uIGM7so5AfXQSQ53rxxqTRv7J1R
         ERsTGbaPMkcMGp6Y1MFUmxvjxqT/IwE3VfshtnRaYVbrnBAc52eC4izj9JimJQhxAu/B
         i2Tio6JxacU5sH1MXiD0SdS2yxYFPUAg+hg8NEkj7kx9/8TnBZQMtb2wQ2Hml3xoELUc
         9zHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784654911; x=1785259711;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sEpucA6cJ+wFKkMEgPwzn/PVy5HptrOhm/qxg/NLr6w=;
        b=b0PuASGY0RJrDFiKjpGYZTooVOyAaLdqBLiSyT4KLBlh2cK1MKzfLOvKDbM7UtMYF5
         NL/2pstQI0qhrni55HHWwWvPv5gnnwRBvOHWjkDrgb6btD4nA+ToYdjZR/yZoAlSi2hg
         yH35DOITwueA51ALqx846hcA4ZKVEfrI2ToVLRBKJLUfZW12RauCx5EBVPN0OLi2vcRN
         nXvezvB9IbnjQpNo51+JLy4LrQJPGCeItJZA7hAlcFvlH6V3GAG3Lwwxzf0vpbcyk3Qr
         LMDfYI7/QJEU1qoGoY1ZyVN/cZIW73R6xx1V0tXPo0m2O78HqLxIpbzrrxYqZjmPQJB/
         NlSA==
X-Forwarded-Encrypted: i=1; AHgh+RpxH7DlZLQhnOQ+LHo0nXhSq09o20o7Mht1Dus7LDusdQ7/Z2DuslYrKzqcjzQd/HaqYzKjfEbEG8E=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywnt60CAtLZQAqoD/K7gxIiUbHItkd0acEaJ3BibJN7pVxvCeSo
	X6Pv+KnjPgCBZgh8tNbDxZHsDrwb9LWbM2OPdFz6t5n99iqsG4NLdfU2m9aaSGvPfQgwaQv/CBh
	5xSx2ZtLQ2hvI6i5pOXMCU5N43K/rU10J9fxco17cKwqylGuvGB/8Gxwn
X-Gm-Gg: AR+sD13pHM2KhlTh1HoM/1kqlrpRkN0W1nTgimXtSQS37kENLasZXjvpt0zOFV6ob2T
	yCyeRtMUUCRJ/Y+ytglpdABZDg1Da1IFD3UzeVurOFLMWTckjyKs9ci+hSmR5/tDgtvcIpzBVww
	nqWOWxg0jfJAn2cnVjTHVH7mkyaU+XdjBpqVXNfbNN/Pm4MC0FLEO30kXx+99UBVKRncQQfSbJV
	Z5KAfn43SHIzJsGZCkLrxkjLZkHb3DmClEf7l0J1c/GVoZ0W7MAmkPEYnJm5B/co0BWxGOvnFQw
	Od8KoPMmT7ALIXRvhwlSTZ+BAdGv
X-Received: by 2002:a05:6a20:a124:b0:3c3:875d:c538 with SMTP id
 adf61e73a8af0-3c3ad78cd25mr21412312637.8.1784654911423; Tue, 21 Jul 2026
 10:28:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260714215612.1528518-1-xmei5@asu.edu> <178463069007.324722.5307902735949232521.b4-ty@b4>
In-Reply-To: <178463069007.324722.5307902735949232521.b4-ty@b4>
From: Xiang Mei <xmei5@asu.edu>
Date: Tue, 21 Jul 2026 10:28:19 -0700
X-Gm-Features: AUfX_mxnCz-fE8BkgnQH--dbpmQvBuka8snMaXdhAoSerY_uAy5pY24BHX5m-EM
Message-ID: <CAPpSM+R_LvAZdmimzs32ETWf_LYrhP2r+7A9xOecpRnYUWdwCA@mail.gmail.com>
Subject: Re: [PATCH v2] xfs: fix off-by-one in rtrefcount btree root level validation
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, bestswngs@gmail.com, stable@vger.kernel.org, 
	Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 21, 2026 at 3:44=E2=80=AFAM Carlos Maiolino <cem@kernel.org> wr=
ote:
>
> On Tue, 14 Jul 2026 14:56:12 -0700, Xiang Mei wrote:
> > xfs_rtrefcountbt_compute_maxlevels() sets
> >
> >       mp->m_rtrefc_maxlevels =3D min(d_maxlevels, r_maxlevels) + 1;
> >
> > where the trailing "+ 1" already accounts for the inode-root level, so =
the
> > deepest valid on-disk root level is m_rtrefc_maxlevels - 1 and a cursor=
 must
> > satisfy bc_nlevels <=3D bc_maxlevels (=3D m_rtrefc_maxlevels).
> >
> > [...]
>
> Applied to for-next, thanks!
>
> [1/1] xfs: fix off-by-one in rtrefcount btree root level validation
>       commit: fde50b32183f19041b4bab66c8f07b1cc38f8e26
>
> Best regards,
> --
> Carlos Maiolino <cem@kernel.org>
>
Thank you for your review!

Xiang
