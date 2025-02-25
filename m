Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E262186E2F
	for <linux-xfs@vger.kernel.org>; Tue, 25 Feb 2025 16:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740499465; cv=none; b=YRfR4jRwg8uqIir09M5e7cyfvYBVT3jgzNYzKdlI2axcrbsr2Wupt2bi6VvbFQS9HQP6EY8QNk3XoXvTOlqu9yRzjYDjka0FXnO02tkI1cKj099qH9XaBEIoi7vrKCrNqcjEpKr3xQqLDhOmFa2PbyWcu8hojbd1kwoC+wOOJ38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740499465; c=relaxed/simple;
	bh=VTW1IS7i/OjNtZuLaIVXuuL/aHNYaFf4pMMoQV0ML5s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F6UY5yCpXvbjh5Sbi4OlScOpWy2t2eQ4/vDx1DVJYKv6WSBZ5UXTqEOLl9lETnavc8i5KiNUyEc35l8UVTWlAX5zyil/s6T+lrzlzZ8kYFMxHU+5HTO7BnGqtCwZ9a4sylrWIphdBFOBNzl86vHtu9ezGK6io95KXKcp565kyNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=scylladb.com; spf=pass smtp.mailfrom=scylladb.com; dkim=pass (2048-bit key) header.d=scylladb.com header.i=@scylladb.com header.b=n6l0kFEB; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=scylladb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scylladb.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=scylladb.com header.i=@scylladb.com header.b="n6l0kFEB"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2fbffe0254fso11696407a91.3
        for <linux-xfs@vger.kernel.org>; Tue, 25 Feb 2025 08:04:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb.com; s=google; t=1740499463; x=1741104263; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hRKvkOnD9TtTQxj3HCyksPuAKJutP4jLh4PJeGhnrRw=;
        b=n6l0kFEBaw1y+hHHRWpmuP2QrM99f7jt54Os7OTwZDGjWpuEiCGMbJfjDRceyhwWc5
         V0pOgELXXjut4AOQ7Ofgys+m7IVOIX4rXStLHTpxlpuMf0lVSfbV/v0IsOloOvoTDbmL
         Nlu2Zn/qqd2TdvJeQO/+AoeH3X09RKEVsW1TAbn+5X4Et/i65/c8U4cwA0J8u5VnOscN
         gUIYbpe3SQQt2KLATEN7VEt+JAZUmlk1muwj7+xDH7wF07JAPArYWnpzlp9EWrLA6jgt
         4Hw1GEW3isNIJVCdyev3YAoWCoZ80208HErHcXHbzzliUlm1XFb9KTwVRxylClvpCkDo
         vXTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740499463; x=1741104263;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hRKvkOnD9TtTQxj3HCyksPuAKJutP4jLh4PJeGhnrRw=;
        b=G5UYx3xagV1SJn4dxBGipePlpRfukJ8EXu8jVzfNdbBqPtRM3dI1zlIeUDPr5vZmpr
         EJRVfhN1EADj1rinvket7bKrODcTp/NNQAxC7sFtqbGL+WBu+OG9Od97QNtZm6LyFlGb
         dwupBbD5WIFJzB1hXK66KAukvSkZk/uUCSukc2yElrHVbMsZ58ydB+8ZVNniv3GBQNtx
         Z5jqoGTLzbWpok2dgODNp/GaZ22UvQXRxDvBzXUs97tq0v8QYvAugWlbnls62/cvZFiO
         LaqPl8kz/uBwX2CUKmRzxTSlPYOLT0icISL+ixe3i88s3k4DCFS70GV1Dxtoaei/emjQ
         8PSQ==
X-Forwarded-Encrypted: i=1; AJvYcCUfFmwOV9Xn038H0iRuReh1vWCRKgSOMDjd0oaDSIdP5QvWntKkOpL9UbYYBgmRUGGYoZ2cWdNBuek=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/fOJY/1JdC/tgQMQwzd4vlA/5HalHLKCeXacKzCm0e/hedzIe
	7JmOpVahVQoAVwB9a7lqFnjwgeLFfcfWwZqCmptvay3ayXeA5np09GYK+aoLzb8Tsy99Y01jDBp
	g4ZmU3T+weCQUXvu64cCUT2xVXXaPOgrlGJFs6VxR/i0ZVHKxaiaHDl4UyMslpfEbZIuQSx9i+O
	+ZattCqDYUlsHrHQmsaJ4+DqIIAqSDp5vdcPtyOs3Kvz/mPVSDjS2VHmaGtMoa9todbi48lWZcT
	zuzAgIPuZiaRtEHxvelyZFnFmYwyDsvVg3BAzLZhErTu2HXsXl8zbCb7+vq+xVpoz96K+zGAh0D
	GfBrZiaWZOq2g5YiZnR5Mx7wWyj8X3TbDyG2KgYevaHJkzmrkZzRM8xi7DmPfNjJppdE9oxyS3A
	sdnHuaqov
X-Gm-Gg: ASbGncspBcNGelUQFCpr7NuzetYGwgvpMTzkFFX5SpNQzsbJ/xzqVRz2WDqsDepzOC2
	OIArSd6XZ2UUmG8KrhcLUDGXCa5jqoer21fj1cfLbYCaQ6+v572KHG+/w6Z0wBBWEopNnNvYyyp
	WkBKHgqLLE/ues55/UiCJdfwT/
X-Google-Smtp-Source: AGHT+IGyh1jWG7kvXPe8EQRd9GcQQNFYExzpyCfQNpHjeoLN1FUP/xzECarfl4fqw7bw9I5wDY/K15SD3y8rUQxdngU=
X-Received: by 2002:a17:90a:ec8d:b0:2f6:f32e:90ac with SMTP id
 98e67ed59e1d1-2fce78a9aeamr31654991a91.11.1740499461044; Tue, 25 Feb 2025
 08:04:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250224081328.18090-1-raphaelsc@scylladb.com>
 <20250224141744.GA1088@lst.de> <Z7yRSe-nkfMz4TS2@casper.infradead.org>
 <20250224160209.GA4701@lst.de> <CAKhLTr0bG6Xxvvjai0UQTfEnR53sU2EMWQKsC033QAfbW1OugQ@mail.gmail.com>
In-Reply-To: <CAKhLTr0bG6Xxvvjai0UQTfEnR53sU2EMWQKsC033QAfbW1OugQ@mail.gmail.com>
From: "Raphael S. Carvalho" <raphaelsc@scylladb.com>
Date: Tue, 25 Feb 2025 13:04:04 -0300
X-Gm-Features: AWEUYZnSwsts3AlnyMyPnDoZIO5Ek4gNZJVOo4qq2rXtoP6hhryN1CYaV-mMojI
Message-ID: <CAKhLTr1HtH7gnSKSE+8LR9+MpNGYK0PYr8NGSTav-0sgf4y+gw@mail.gmail.com>
Subject: Re: [PATCH v2] mm: Fix error handling in __filemap_get_folio() with FGP_NOWAIT
To: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	djwong@kernel.org, Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-CLOUD-SEC-AV-Sent: true
X-CLOUD-SEC-AV-Info: scylladb,google_mail,monitor
X-Gm-Spam: 0
X-Gm-Phishy: 0
X-CLOUD-SEC-AV-Sent: true
X-CLOUD-SEC-AV-Info: scylla,google_mail,monitor
X-Gm-Spam: 0
X-Gm-Phishy: 0

On Mon, Feb 24, 2025 at 1:15=E2=80=AFPM Raphael S. Carvalho
<raphaelsc@scylladb.com> wrote:
>
> On Mon, Feb 24, 2025 at 1:02=E2=80=AFPM Christoph Hellwig <hch@lst.de> wr=
ote:
> >
> > On Mon, Feb 24, 2025 at 03:33:29PM +0000, Matthew Wilcox wrote:
> > > I don't think it needs a comment at all, but the memory allocation
> > > might be for something other than folios, so your suggested comment
> > > is misleading.
> >
> > Then s/folio/memory/
>
> The context of the comment is error handling. ENOMEM can come from
> either folio allocation / addition (there's an allocation for xarray
> node). So is it really wrong to say folios given the context of the
> comment? It's not supposed to be a generic comment, but rather one
> that applies to its context.
>
> Maybe this change:
> -                         * When NOWAIT I/O fails to allocate folios this=
 could
> +                         * When NOWAIT I/O fails to allocate memory for =
folio
>
> Or perhaps just what hch suggested.

Matthew, please let me know what you think, so we can move forward
with this. Thanks.
