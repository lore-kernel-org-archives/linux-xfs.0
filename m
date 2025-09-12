Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C904831B124
	for <linux-xfs@vger.kernel.org>; Fri, 12 Sep 2025 17:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757698592; cv=none; b=fwhAMn82l3a8rEMANaWlt0eNXM7oEL9JTXj2E+vsHXDN/GxpQRSV2g2lq79c9c3QGlahlifxJAPAOMTISPBW4ItY+lNnTzVOWlzICo2rItmpcwLm71s72P6zA7pIkNG3JRc74rCeJ8b97o2DlBkEzjqynl02kb/cD2aX9CnieXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757698592; c=relaxed/simple;
	bh=yK0tz6ECng/GkzGWo1PQRHtl9PMBAN4W2lEev0pJQG8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iEW4hjEhC2P92338fXvVrBqqUAtzCbdwFEGxgpp7B5Agf8bqtmu3HNL2nJmugGNx5nWhee8hjeTB3FqIuZf+RzagZf6jb8umsaQKhN8SRooQ3kl9PB9TGiSIy5kpkIwyqua5qwKdKBWGi4QZEYHQ7UtyYVhaDsscmZfBULYXyyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fSrwdj2h; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fSrwdj2h"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4b548745253so33484231cf.0
        for <linux-xfs@vger.kernel.org>; Fri, 12 Sep 2025 10:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757698589; x=1758303389; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iaoWmn122bkATHsMm2TW6koAeUnmN4wL024VSWi/QfE=;
        b=fSrwdj2h4HxBV0EQ5JI59iDya2AujG1smsOrVLSzq+AOqqKP2Od/OSmumRgPy1lgej
         aWI/JS9eE9CuBihOeiiuh+KH9UmsjoAq3shPuJv8STt+VBaCoZW5vNa++l5moePpPU2H
         Iqe5y7QyKcxO2HIb+wX9Ce1LpL7HrBPvEiJTq0Q0ndGvnWf5GVcz8NRZI8sbZf1NTN/i
         ndJSFDXies3ZQbzCPjSN6k3f3OBxY1Gsd0L0CJf4vaj+6GTqSjBqoD1cJhlFovTfzG43
         fbVTu2k266wjJMq33X6XQDhzpVC3M3WuBSHVAVH1wE73tKua79oQPp+VyRxQdQo385Pe
         1vsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757698589; x=1758303389;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iaoWmn122bkATHsMm2TW6koAeUnmN4wL024VSWi/QfE=;
        b=Jp4gdyQro0BBHtIcvJJZolXhDbcrqBKgzBIKeUDKS9EFXDYeeztxNm3L1dpaAF9/Fl
         o8kC88GZAGYn3pu7nXPjo3IAfxGFi+ckyNF4amz/2nuQJLDzW+cdVLx2FBHlSGIbR/Y9
         heRDBtfi+qGkSJI6BZxdO/ZKzGKSxXLMlB1cDN5U6U8kKnoRnkPyBmkf/4FmvYb/v1H4
         zg5r5LsfP3LbrWnf/ZuH2zWjKIWu5kcEuqBgAH/LoWVFrXD3WSNsXeTsXPcVTVs3SNB8
         3qTQJ6ZoAtdUn5YeuIq90oMPLsi+x/sie6Fr260O7fjq2SBykL6EninfNrcAUXbsdRIo
         j/og==
X-Forwarded-Encrypted: i=1; AJvYcCXjSDtuOyeZFo/qfdnHwHno7vzn+tAAYri3yWFO2hRKoKkkVq9bgl1IhjKcDV15xX+A2RfRbVjr3JQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzg6f45o0GSpG9NQRDc8JpqNrxEm+waMKoJ27NgggZwgrdM50aF
	KUr6WhlMsO5eDAr3/BgWFGHJoGh6ODCJ+LGgPeMq9mryLFUcxELZQQ59FnY7ayxPChBrOzrXyGx
	DInZqyx4OSO3YiRfCE2HFTznNdbnz56c=
X-Gm-Gg: ASbGncsj7OLYtCEPr6xJ4v9aFMlymICdgmjjrbKSqUxb6Ic9qMAE09YEMEaxouQ3XvU
	De7WTMfPdTjDc4Ag2Kl2uZgkjTU/Mc14g7ATPq5bDq6kk4P9LEZaJWNUfloPA57oEq2LQMEYRBK
	Qu/7yR+ySgpuOvCXbTjAbwkwjfJOLm5PQg1byNauiQXkOl0hPA8GXCsjh3T/5uEYKqn4lAsPmTc
	C14xegWL7QUKJHWiR2sn6DHqseLgM8ktwRV9DmJ/vJE9liBgFC8
X-Google-Smtp-Source: AGHT+IH7GMrBmyVYd7mK7Xmpyd9r7k7cyb03zWtnoaxVf5aKJ9xehKSBV/1hqSTeEYXKWJdrlpEgvVzc7a+DG2b03cg=
X-Received: by 2002:a05:622a:581a:b0:4b5:4874:4f92 with SMTP id
 d75a77b69052e-4b77d0137b3mr62431321cf.13.1757698588919; Fri, 12 Sep 2025
 10:36:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250908185122.3199171-1-joannelkoong@gmail.com>
 <20250908185122.3199171-12-joannelkoong@gmail.com> <aMKx23I3oh5fN-F8@infradead.org>
In-Reply-To: <aMKx23I3oh5fN-F8@infradead.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 12 Sep 2025 13:36:18 -0400
X-Gm-Features: Ac12FXza_WwHTwR6ZN8SwpAjhAiC4oowkVj8eON9gC8viGDNCKpw6hOW6Wr675M
Message-ID: <CAJnrk1aKiKSTB3+c8BRbt+h9L5eq_Yy2y143fPUcUM04VTjd_Q@mail.gmail.com>
Subject: Re: [PATCH v2 11/16] iomap: add caller-provided callbacks for read
 and readahead
To: Christoph Hellwig <hch@infradead.org>
Cc: brauner@kernel.org, miklos@szeredi.hu, djwong@kernel.org, 
	hsiangkao@linux.alibaba.com, linux-block@vger.kernel.org, 
	gfs2@lists.linux.dev, linux-fsdevel@vger.kernel.org, kernel-team@meta.com, 
	linux-xfs@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 11, 2025 at 7:26=E2=80=AFAM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> On Mon, Sep 08, 2025 at 11:51:17AM -0700, Joanne Koong wrote:
> > +  - ``read_folio_range``: Called to read in the range (read can be don=
e
> > +    synchronously or asynchronously). This must be provided by the cal=
ler.
>
> As far as I can tell, the interface is always based on an asynchronous
> operation, but doesn't preclude completing it right away.  So the above
> is a little misleading.
>
> > +     struct iomap_read_folio_ctx ctx =3D {
> > +             .ops =3D &iomap_read_bios_ops,
> > +             .cur_folio =3D folio,
> > +     };
> >
> > +     return iomap_read_folio(&blkdev_iomap_ops, &ctx);
>
> > +     struct iomap_read_folio_ctx ctx =3D {
> > +             .ops =3D &iomap_read_bios_ops,
> > +             .rac =3D rac,
> > +     };
> > +
> > +     iomap_readahead(&blkdev_iomap_ops, &ctx);
>
> Can you add iomap_bio_read_folio and iomap_bio_readahead inline helpers
> to reduce this boilerplate code duplicated in various file systems?
>
> > -static void iomap_submit_read_bio(struct iomap_read_folio_ctx *ctx)
> > +static int iomap_submit_read_bio(struct iomap_read_folio_ctx *ctx)
> >  {
> >       struct bio *bio =3D ctx->private;
> >
> >       if (bio)
> >               submit_bio(bio);
> > +
> > +     return 0;
>
> Submission interfaces that can return errors both synchronously and
> asynchronously are extremely error probe. I'd be much happier if this
> interface could not return errors.

Sounds great, I will make these changes you suggested here and in your
comments on the other patches too.

Thank you for reviewing this patchset.

>
> > +const struct iomap_read_ops iomap_read_bios_ops =3D {
> > +     .read_folio_range =3D iomap_read_folio_range_bio_async,
> > +     .read_submit =3D iomap_submit_read_bio,
> > +};
>
> Please use tabs to align struct initializers before the '=3D'.
>
