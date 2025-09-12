Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7D7273D8D
	for <linux-xfs@vger.kernel.org>; Fri, 12 Sep 2025 17:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757698248; cv=none; b=XTmQFFWx9MllOllGlCNu+CVPtIdU4FtXFzhxMn90wcWWg2pu9gIyP3v9/UTWL1jQJHgA2ZiwN5BQlQOtqVM9A+oe+ecsXTlhxIR+J8eUw26ZKaxfk98pwtcl882InQ264wbi0rUFuYoo1hmoOmOBVpa7dFaVUvP0l6NixnG1y7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757698248; c=relaxed/simple;
	bh=o20p7GmDi8+ZFGPUj4WAT9L80iQUq9XRuj2nEHhmdqI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gAuHZ7x7Er7BiMnf//Tnl2evyhJwoFVZRtEKwNxm7wV8Ab0xlSTriCry7Md3gmIBP2P06m3ITRum/m1y7MR9//jP5JgFwguu7JZihYxbokgFPmGaz4R3x0eRCTJhDYxF2UdB0VeF+pCLKeR/rgBZG5Fvdi7YU3fd0TO4JK7PZjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T5e2Qev9; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T5e2Qev9"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4b5f7fe502dso11830591cf.0
        for <linux-xfs@vger.kernel.org>; Fri, 12 Sep 2025 10:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757698246; x=1758303046; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oIIexxQJuuGcppYfGlH23qFT2xQkXBrd7Hq3B7cHXU8=;
        b=T5e2Qev9f+0vQDmCT/6qKmuwEl9B9YY7nU8UX+l7Rw7BCD13SiFpkEPSQ0CrTV1Tvs
         FVHYpHiTnu/OZgAcUkFdxpFS92yIf8ulrY9zYqi985Pdk9QifHcUHTHOa1sUotSvzcO3
         kqem5KiLNCxN3U8xtOTBMjZQnR39wEAYHwdnjg+Kfo/fw8ZB0fzZvwuOkYSmqozUfDpz
         WzdnBdCmeHl2kmWPTYnl6gcvqVJXBennvPESITsiClyzNLwIlYdpscaBOweJlLylZf9P
         reI6tfhFDJdw6PYTNcoO9U/f9JXNh+jGi9MbzLQrOQij22jn0F+BhLE/1/Byoj8Ks0fJ
         XvrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757698246; x=1758303046;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oIIexxQJuuGcppYfGlH23qFT2xQkXBrd7Hq3B7cHXU8=;
        b=UCwkYSRhcNJD/PpiEST376v/750rY9ltiaohJ/Zolor9Omoasl7GaQOCj6rzfmNV1K
         xZebb8M8w3Ukhr4Qjv2IUyVNrhFj6hWGHCUxEOHw+AhQhMZJfxePrIdNGMRXktiabgUh
         0hChoObC3JJS+oBMhtKm49HNMCpBwuj/M/hZHBddk5fZp2oIjL4yMPgTBkgU5PL0Zl9q
         9u3f+PiONyMEoJ2gcNzUYxJ5rIhczdCDfhE6Qf3xhxnr3quBsfElKuQu0OPHU5/VyHi3
         +XSTM4gJbGTYYfgn8KS5DF0HI1gttSiwCKaffgZ7vuvBgP9JyDgihaH5aGUlg59kzlGu
         xSuQ==
X-Forwarded-Encrypted: i=1; AJvYcCWfGa/Kc1YRX8mugA+8XAivzRFfD3GDO/x6TyzJQ9ygjEDEdSAqCfkLxxYSqDq8ILd55Wm3wTrApng=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIGBFhdRxQOAFAWhoU/FbbxOed9MuUalM722cm0fKV5pQQ89zl
	OA3kkru89yoFEEhfcShZSnLpkonkcboeMmt/ZLXL4NnYYkeitGRUSiRSXkekPA5hiqL+DAJ8pRf
	MdW76gpQUWcKD8CRn6MuKO396jMGjmzc=
X-Gm-Gg: ASbGnctakCjjY8E0SvdNI/c/m7UyAnnfFEerzUi8mEKWs3Ea36FkwGpgjiNIE91wsem
	Mb9fXxiZjdVQMshuuOM+i056Ri5w2rPakSxH41VhcUtK7Wpa3eTCK3fKWQKr5zYTbKr6Rod2qr1
	WRS0bG1+L3k0aCNuvrc9l/tWNM1yg/6DakhoDlv9Q8L9fUrkJfSIpWJCXePrr7yXr0CLj4NGWzA
	3/kjicyA7Q6ns9yzhjKeAhrN2geriG7pZVPiayRCY2jNzwg7DYf
X-Google-Smtp-Source: AGHT+IEcdCSZjZDX72w4oinaB7XT6QqmpJZk3VMxTChZFpoYvtCeUS7bDJlGiyqj98thpHZJTlGF9yw6Sf32KJ6S4V8=
X-Received: by 2002:a05:622a:5c98:b0:4b2:8ac4:ef93 with SMTP id
 d75a77b69052e-4b77d0ff805mr50626621cf.78.1757698245900; Fri, 12 Sep 2025
 10:30:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250908185122.3199171-1-joannelkoong@gmail.com>
 <20250908185122.3199171-13-joannelkoong@gmail.com> <aMKzG3NUGsQijvEg@infradead.org>
In-Reply-To: <aMKzG3NUGsQijvEg@infradead.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 12 Sep 2025 13:30:35 -0400
X-Gm-Features: Ac12FXwnGYyLDAMLNpwS8zmPZj5g0R1lO_gh0yPx8OPOW_t5xNmOKu_QWWNBsIc
Message-ID: <CAJnrk1Z2JwUKKoaqExh2gPDxtjRbzSPxzHi3YdBWXKvygGuGFA@mail.gmail.com>
Subject: Re: [PATCH v2 12/16] iomap: add bias for async read requests
To: Christoph Hellwig <hch@infradead.org>
Cc: brauner@kernel.org, miklos@szeredi.hu, djwong@kernel.org, 
	hsiangkao@linux.alibaba.com, linux-block@vger.kernel.org, 
	gfs2@lists.linux.dev, linux-fsdevel@vger.kernel.org, kernel-team@meta.com, 
	linux-xfs@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 11, 2025 at 7:31=E2=80=AFAM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> > +static void __iomap_finish_folio_read(struct folio *folio, size_t off,
> > +             size_t len, int error, bool update_bitmap)
> >  {
> >       struct iomap_folio_state *ifs =3D folio->private;
> >       bool uptodate =3D !error;
> > @@ -340,7 +340,7 @@ void iomap_finish_folio_read(struct folio *folio, s=
ize_t off, size_t len,
> >               unsigned long flags;
> >
> >               spin_lock_irqsave(&ifs->state_lock, flags);
> > -             if (!error)
> > +             if (!error && update_bitmap)
> >                       uptodate =3D ifs_set_range_uptodate(folio, ifs, o=
ff, len);
>
> This code sharing keeps confusing me a bit.  I think it's technically
> perfectly fine, but not helpful for readability.  We'd solve that by
> open coding the !update_bitmap case in iomap_read_folio_iter.  Which
> would also allow to use spin_lock_irq instead of spin_lock_irqsave there
> as a nice little micro-optimization.  If we'd then also get rid of the
> error return from ->read_folio_range and always do asynchronous error
> returns it would be even simpler.
>
> Or maybe I just need to live with the magic bitmap update, but the
> fact that "len" sometimes is an actual length, and sometimes just a
> counter for read_bytes_pending keeps confusing me
>

I think you're right, this is probably clearer without trying to share
the function.

I think maybe we can make this even simpler. Right now we mark the
bitmap uptodate every time a range is read in but I think instead we
can just do one bitmap uptodate operation for the entire folio when
the read has completely finished.  If we do this, then we can make
"ifs->read_bytes_pending" back to an atomic_t since we don't save one
atomic operation from doing it through a spinlock anymore (eg what
commit f45b494e2a "iomap: protect read_bytes_pending with the
state_lock" optimized). And then this bias thing can just become:

if (ifs) {
    if (atomic_dec_and_test(&ifs->read_bytes_pending))
        folio_end_read(folio, !ret);
    *cur_folio_owned =3D true;
}


Thanks,
Joanne
