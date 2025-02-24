Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A4D282EE
	for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 08:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740384009; cv=none; b=HfsTP1bqwuG0WB+vd4wFk9dC5dk1S+Us8ja4boNV1uFLf2vWnIuT0LlAgyrl/fsTPQsxEkeRNulgkJa/xC1Q4AJO6RJNI3OqYGXI0eL37t8CFsDei8gYa2OsXh4rZAVMenZTEquuX+/64MWzhUsgskkCwhQ1KzKkeOrUNRr1pO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740384009; c=relaxed/simple;
	bh=DSSp61QUIymzYrWYGlGupfHXP31daiD2lgNbLtACtSI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nhIHryqpbQVveqL01PmH1B5o5fClkmMKCY+/LgpHRNJ93dpriFYt2zrQ7hiNedJmvvt9SEDPfT/1ahse1XcBXz4HFYKEbYDnTkUOGZQoul+tli6PmiZ/afJFPPnlMwCkHXIm+dL+CasxqXrEWzQrDH68EZgcAQFtqGNben3IslA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=scylladb.com; spf=pass smtp.mailfrom=scylladb.com; dkim=pass (2048-bit key) header.d=scylladb.com header.i=@scylladb.com header.b=zPZ/dDvC; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=scylladb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scylladb.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=scylladb.com header.i=@scylladb.com header.b="zPZ/dDvC"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2fc0bd358ccso8326083a91.2
        for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 00:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb.com; s=google; t=1740384006; x=1740988806; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SVoA3KBTslaxKUJAlPiAwxSQFPk6ze1iD/cIE02/gTk=;
        b=zPZ/dDvCftY6X1O1f+B+qACYkGlxrkRdm0flk4vBKgoQ2e6kvuC67qAE1zKm+1uCm4
         E9FN2e0wa2jagjh6s7iAUXUB4j0wBcYD32y/Rnmnad9HKzmxtVq4sjw6u/8MVGSt/ciI
         pslah7HGA6y+mJCwmoDoyzEPuMz6k+/791x7C662bw3GXDb3vaxSafEwUaU+BvTfyulW
         wlBJL2EO9N+P9yBBqe8sQmTI9yNjR9L0f/UOK3kH/HAxfZ9y6BhJFf0aK0HZttIFRAA0
         ER2oEBxiEsbCoW7R8Zk24HZUUjwwbRqWg333PdEdOsi8XsgJR/G2QllmGNVSAiArYYH4
         4trw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740384006; x=1740988806;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SVoA3KBTslaxKUJAlPiAwxSQFPk6ze1iD/cIE02/gTk=;
        b=BvXlHKYyCV85+xUF4OvcSAT0JgvHpPd1oxHoQ+2tQbm33T8YvEdpYEc7yVtrabgkF6
         ibtWs/U7wjP6uU+Ptgg06sBmKDUbyQc9zBO8ysp7Mv5OlcG9HLJ/9zlapmYvT5rqD1TI
         mAvB6PkdcWn1PJJgl8Gsh/S1wFyp9PKB4S+/z2S1rPaoom9Axflud68Gjj2XgOax4zQu
         p0jWVSKAuIF0AvG8z5tW+KHRjGOsurGu8Ezme4oWx1txtoCZp+vkVFJBmWO8ZE3KqJnA
         zz1uW/SCNGUWLey1vUqyMbf/ASo4ec82Y70adFmWHDrOlZ5f2O1KH49u0PE3dWDldz75
         gVgA==
X-Forwarded-Encrypted: i=1; AJvYcCWVzE4qxeX+TpjhYSAA9cVZi4cL/RyOZG9eEpu9jNsWJm9aJ292vBkijRwa3REmFZxds4u3yhybEsA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHsFZOmzCKxpDNIs7vCFqkiReb3Be+Q+cYlg7RrVZa52Gco3aQ
	Qx86ZHExHgpGcD/xeMsXtA2a+45R1kRcdoKZz30Qlih8bWljWf9X4ZDndaJvQbZmtTKMXZStSGX
	yaj9/XsBkxBY62PFyZb8JKDk15+QvthzddE7Rd38qes4YniFipx8BHZdZDAT/Oz7uif0wJyweKl
	wMvpxVCw5QxB+czC3/crn7RaVr340kTfz6d+ADrJX90oOR4SRWcu2RJtKb0sLfhQmzF19Ksk1Yt
	EMmxmS6J6exFE3kRTLPHv492kFTNLnURXN/ttjFZcPfBaEf/hZ5ZGDdf1ddQBzwJmRXZ/cSiHtv
	gvbhxgWk7h0Okgfq8erZH5IeghY2EMKBmCZ7c33F8Y4cDDZYMphNrGy3OPiiVAdSiKi5dhL9ddx
	RLC5L+ZUS
X-Gm-Gg: ASbGncsYuJFXz7TMjYRC2ElkTKb5qJ0t+dcP+K1aNt0gX/pBfiCaJByfxAOZ6vD4s7t
	Ef5icdfdjm3x8SK/rDAHUoPy14McUlpnOhK8JRGWco6McxARCjn285BqlUf9EevCecqJc+goqYr
	KB1cNUkogkkkV1wvUZRfvg+0KT
X-Google-Smtp-Source: AGHT+IFtdbQ6U/YKuWHB7yqDwwuNE/bSc7IlcjqeG5sANxT1TCSNg1dNn8Tz99FJjQDWn5yBteVeobg3lGuJU2hNAM0=
X-Received: by 2002:a17:90b:4ec6:b0:2ee:ad18:b309 with SMTP id
 98e67ed59e1d1-2fce779bc1fmr18989604a91.3.1740384005725; Mon, 24 Feb 2025
 00:00:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250223235719.66576-1-raphaelsc@scylladb.com> <Z7vyEdJ3SqjFkE9q@casper.infradead.org>
In-Reply-To: <Z7vyEdJ3SqjFkE9q@casper.infradead.org>
From: "Raphael S. Carvalho" <raphaelsc@scylladb.com>
Date: Mon, 24 Feb 2025 04:59:48 -0300
X-Gm-Features: AWEUYZkvHapCZa_nWwzLdLpvhKFl_jgkyrG-YnMTBsTUmmQGjHUIcJRbVqK-hSE
Message-ID: <CAKhLTr0UA42AC2yCyFtDbFoS34vvg05EVnf5J4MSit_Sr7JETw@mail.gmail.com>
Subject: Re: [PATCH] mm: Fix error handling in __filemap_get_folio() with FGP_NOWAIT
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, djwong@kernel.org, 
	Dave Chinner <david@fromorbit.com>, hch@lst.de
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

On Mon, Feb 24, 2025 at 1:14=E2=80=AFAM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Sun, Feb 23, 2025 at 08:57:19PM -0300, Raphael S. Carvalho wrote:
> > This is likely a regression caused by 66dabbb65d67 ("mm: return an ERR_=
PTR
> > from __filemap_get_folio"), which performed the following changes:
> >     --- a/fs/iomap/buffered-io.c
> >     +++ b/fs/iomap/buffered-io.c
> >     @@ -468,19 +468,12 @@ EXPORT_SYMBOL_GPL(iomap_is_partially_uptodate=
);
> >     struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos)
> >     {
> >             unsigned fgp =3D FGP_LOCK | FGP_WRITE | FGP_CREAT | FGP_STA=
BLE | FGP_NOFS;
> >     -       struct folio *folio;
> >
> >             if (iter->flags & IOMAP_NOWAIT)
> >                     fgp |=3D FGP_NOWAIT;
> >
> >     -       folio =3D __filemap_get_folio(iter->inode->i_mapping, pos >=
> PAGE_SHIFT,
> >     +       return __filemap_get_folio(iter->inode->i_mapping, pos >> P=
AGE_SHIFT,
> >                             fgp, mapping_gfp_mask(iter->inode->i_mappin=
g));
> >     -       if (folio)
> >     -               return folio;
> >     -
> >     -       if (iter->flags & IOMAP_NOWAIT)
> >     -               return ERR_PTR(-EAGAIN);
> >     -       return ERR_PTR(-ENOMEM);
> >     }
>
> We don't usually put this in the changelog ...
>
> > Essentially, that patch is moving error picking decision to
> > __filemap_get_folio, but it missed proper FGP_NOWAIT handling, so ENOME=
M
> > is being escaped to user space. Had it correctly returned -EAGAIN with =
NOWAIT,
> > either io_uring or user space itself would be able to retry the request=
.
> > It's not enough to patch io_uring since the iomap interface is the one
> > responsible for it, and pwritev2(RWF_NOWAIT) and AIO interfaces must re=
turn
> > the proper error too.
> >
> > The patch was tested with scylladb test suite (its original reproducer)=
, and
> > the tests all pass now when memory is pressured.
> >
> > Signed-off-by: Raphael S. Carvalho <raphaelsc@scylladb.com>
>
> Instead, we add:
>
> Fixes: 66dabbb65d67 (mm: return an ERR_PTR from __filemap_get_folio)

Thanks, will fix it in v2.

>
> > ---
> >  mm/filemap.c | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/filemap.c b/mm/filemap.c
> > index 804d7365680c..b06bd6eedaf7 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -1986,8 +1986,15 @@ struct folio *__filemap_get_folio(struct address=
_space *mapping, pgoff_t index,
> >
> >               if (err =3D=3D -EEXIST)
> >                       goto repeat;
> > -             if (err)
> > +             if (err) {
> > +                     /*
> > +                      * Presumably ENOMEM, either from when allocating=
 or
> > +                      * adding folio (this one for xarray node)
> > +                      */
>
> I don't like the comment.  Better to do that in code:
>

Initially I was doing exactly what you proposed above, but after
reading do_read_cache_folio() and the patch the introduces the
regression, which transforms failure to get a folio (a NULL) with
FGP_NOWAIT into NOAGAIN, I decided to do this, but it's indeed better
to remove assumptions. Not ideal for the long run. Will change in v2.
thanks.
