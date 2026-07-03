Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E1C21A447
	for <linux-xfs@vger.kernel.org>; Fri,  3 Jul 2026 01:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783041676; cv=pass; b=Aihy3dmMImtEWdW8H3xx+3IdSCgfWiUWJ3m2YtlsSxmCEf39Vu7G8Juq1ybIbDKhW09zlNqX5kXBj/6f2Kvjk5kWJ4yONJ9/gaB6Ci4Ao4BxErQ+5aA/z9oPmr7faLcOB5uWBti2t/Rmov64n+bfDwrLUYr/RaRjdzTadYHT/IA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783041676; c=relaxed/simple;
	bh=0nVvzoF5elz2h4q+/Nfneso36ZIRcR/16AhC0hzhbdY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aVZdYM/kbx3X/iSXy6od1mSGN6B4TNHNIDAJ2VzRv1GfkAPIXsR4pH03oM/NFr2v7QWhDlJwx62Lrh4UjiS/jeHUpyk5J/4XfkeAiizi52Zrt1tubG5VwHd8/O6rdHt2vyKdXhrfvtZhDySiBWiuSjU6PLeeF1dd6JrMNHCQrfk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lIZI8qWS; arc=pass smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lIZI8qWS"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4728c12ba97so30383f8f.0
        for <linux-xfs@vger.kernel.org>; Thu, 02 Jul 2026 18:21:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783041673; cv=none;
        d=google.com; s=arc-20260327;
        b=BwgH8xItBGSRVMWzIOAEDSgyavIFseKEAGoq61OTZZ+TPVoxE0V357n1YktAs5+hpW
         mZPFO9OQkzd0C9q9wGagxUGANo50fwdv8GELA3peFQ6PnqaN329AWhjkYSB4nnBNEpkk
         emv6Yw4UQoOFajrt3uEcyEWVNQSaFz2hHIH2iM79IvBumJnSNFKXY5Lp9ZWz4ELhk760
         2FSC2Osm2tcUIznD9YA4hnfMWbQpEassOWfNnkcNnOIhgCuvStMNzC6r5+1N82MhHtWM
         eQHtNbZqgJ7/3ypdarVEwkj4g7hgptg/54r7K88GIDka25wjmMOAMyz1/J/DpVc6AmaS
         5e1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=W/PEiwUP7AW5qZ8cAtUeh4Al98sJv81sG43cdiuY0nk=;
        fh=iA0ni+fzQTcujQREsZugZlaFpTEazsTaHvcok8gi0CQ=;
        b=BB22VkcXiAT0Bt2803xWBadaND2+ZsKvbhl15uhkUupSIktDjLx2MbDyVcK3ghksBr
         znfetCWxpz/khcQB1cGVqsKeM/JUZulsfsDnR7fzK75VXz82IN0FIs/HyRqASfvWYwEU
         MrtPd3oXH8xrJARW/Pb0vQOqMd0EtuqwVr926uatRRVj/3eWrVb7yTM5AhevXbSr3bwf
         ue1pW2XYUecDOOn8mn18JL55c/+SqIYZP80XondSzNSZyueH2TKM09m1daeZkhmiamwE
         W+91Bmi1ZBLmg/Dxfs3Ulb7fhYf4//fcJA8vjnM4Qbydrnpz5oC7MxQUdb7HgDv1jZjK
         Fetg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783041673; x=1783646473; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W/PEiwUP7AW5qZ8cAtUeh4Al98sJv81sG43cdiuY0nk=;
        b=lIZI8qWSmUfZwRi22jFhtqtAapPw8PDVIbVgqA+kjwLlSazKHR45O5rRrcxmcQVliy
         M5t10rv0T3KjnfObqSigxVBqvsVgEVdJK2Bodpkbposw97M3uiRx3oc2jGMCb3oYQqF6
         jgzRfJZYjO4Q8d9ygExdp93z+mOKDSfziP2U8bbAfqNKP43h6S78EznL5DF3XcRHQITJ
         UWQBEhnNs+jXldlX2/rczDebMki7W+QB2mB/JuoGzDYBuM7h3tzb8dV/UYp5JGGkG9Y/
         1iNc+CP7Xn0D9XJABf+RvNq/xSjxibtgfv/CYl7N0udx47ToVgvOQoY1WEpYydnPwrph
         Kr6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783041673; x=1783646473;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=W/PEiwUP7AW5qZ8cAtUeh4Al98sJv81sG43cdiuY0nk=;
        b=gcR1gV7QSW3pLXVrCWxtwgPcquwCNuqltDF62VJpyphr2Fxe8ZL6oM6Dg0wUyPFfQ7
         f333gIuAFK9n2AXoHxDRn8oIwSAceviJAwhwLEpHjSXCjjhAEhtUNZGDOb7pVZ5kf849
         nEus537bmQP7h6Xp6ILV/ajlPvW6f0s483oFf38/mYQMCFFtLBVZ6V1LsmDjS43d0gRD
         6+3ivP7dzjX6zr2vuCPrsMehZ0xo1gb2w13V/6yJsFoIXd8jmMQNzdE4OVJIGMyZOmgB
         XKu2Yo/BX4N+NAAkUbJWqm3d5HQ0F6oDi+HuCh8E6M+APKDTTYLrofTHWFzcnEnmUQoz
         7yNg==
X-Forwarded-Encrypted: i=1; AHgh+Ro+aUR8lqJZUBwwgqsWo0z0IgGvkKql8gWYwjiLX8/QjcbZWihyAWPe572weu8A0GdhBjPVlC0HZCM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzds7k8hl0okm1CvDVH+nzDBzyPBO+6eYyyIVOKhyklLC1xp3gl
	ZSo3z/ut9/ZBOIr00noIJScG6Egv1I0GehnE8lTZw/hc8sk84kwOwwpF33Yf4JDcBqmaj69QiFY
	YAUQd9+DMC73ru80zqP8vMY7CMlDU1S8=
X-Gm-Gg: AfdE7cmn5f5R5VhD3LKeCiOLD4IrbS43HZ7CssJ/OKB3nrRESjcaZDKO+2rFCMN3kkl
	t9XUFirjxugeBZbCwBgkENwNGqyZcSHG9vwy4B40YWEczHb985JQHNrCynJs/yaZfnHrWTXf7i4
	/6b+SpEEXh+ZW4noOkwFQCUNQAJpZMf8xsgp4Q/K8oFqbOEmK8r7NRi6/nb8ZFlvJ5MmBTTTxkt
	vUn10lgjKTJfhEOxSDMht8Z2rYnLBVom1Mj/xNYuIfRbcwOfiwfp8Kxd9B/6liKGmFtUhNfN0i+
	kYOgHoaJco1zTqwhsT4PeMmEzPNk/OhtXgAeZrovTzoZwHqv5GnU
X-Received: by 2002:a05:6000:310a:b0:46d:d6b2:3959 with SMTP id
 ffacd0b85a97d-477595687c3mr11592672f8f.46.1783041673292; Thu, 02 Jul 2026
 18:21:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
 <20260701000949.1666714-3-joannelkoong@gmail.com> <20260702164339.GI9392@frogsfrogsfrogs>
 <CAJnrk1ZRQaFseAnz3zm31oR3KmQWje5HDJjhNbAQSAQyK9_PMA@mail.gmail.com>
In-Reply-To: <CAJnrk1ZRQaFseAnz3zm31oR3KmQWje5HDJjhNbAQSAQyK9_PMA@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 2 Jul 2026 18:21:00 -0700
X-Gm-Features: AVVi8CdpsRpxX2zcAJ3Qh58xlRfu6FM1kcs6vvqwCB4h9cAFLYsYD49l-klWp8s
Message-ID: <CAJnrk1bj4pLpAzLhehrbDJuKWa=WMq-3XOAm9dhsEVDF9WCBPQ@mail.gmail.com>
Subject: Re: [PATCH v2 02/18] xfs: convert iomap ops to ->iomap_next()
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: brauner@kernel.org, hch@lst.de, willy@infradead.org, 
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>, 
	open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 2, 2026 at 4:59=E2=80=AFPM Joanne Koong <joannelkoong@gmail.com=
> wrote:
>
> On Thu, Jul 2, 2026 at 9:43=E2=80=AFAM Darrick J. Wong <djwong@kernel.org=
> wrote:
> >
> > On Tue, Jun 30, 2026 at 05:09:17PM -0700, Joanne Koong wrote:
> > > Convert xfs iomap_ops to the new ->iomap_next() callback. This uses t=
he
> > > iomap_process() helper, which finishes the previous mapping if needed
> > > and produces the next one. No functional changes are intended.
> > >
> > > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > > ---
> > >  fs/xfs/xfs_file.c  |  4 +-
> > >  fs/xfs/xfs_iomap.c | 96 +++++++++++++++++++++++++++++++++++++++++---=
--
> > >  2 files changed, 88 insertions(+), 12 deletions(-)
> > >
> > > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > > index 845a97c9b063..7f8bef1a9954 100644
> > > --- a/fs/xfs/xfs_file.c
> > > +++ b/fs/xfs/xfs_file.c
> > > @@ -857,9 +857,9 @@ xfs_file_dio_write_atomic(
> > >                       NULL, 0);
> > >
> > >       /*
> > > -      * The retry mechanism is based on the ->iomap_begin method ret=
urning
> > > +      * The retry mechanism is based on the ->iomap_next method retu=
rning
> > >        * -ENOPROTOOPT, which would be when the REQ_ATOMIC-based write=
 is not
> > > -      * possible. The REQ_ATOMIC-based method typically not be possi=
ble if
> > > +      * possible. The REQ_ATOMIC-based method is typically not possi=
ble if
> > >        * the write spans multiple extents or the disk blocks are misa=
ligned.
> > >        */
> > >       if (ret =3D=3D -ENOPROTOOPT && dops =3D=3D &xfs_direct_write_io=
map_ops) {
> > > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > > index 225c3de88d03..4fa1a5c985db 100644
> > > --- a/fs/xfs/xfs_iomap.c
> > > +++ b/fs/xfs/xfs_iomap.c
> > > @@ -1037,8 +1037,18 @@ xfs_direct_write_iomap_begin(
> > >       return error;
> > >  }
> > >
> > > +static int
> > > +xfs_direct_write_iomap_next(
> > > +     const struct iomap_iter *iter,
> > > +     struct iomap            *iomap,
> > > +     struct iomap            *srcmap)
> >
> > <unvarnished brainstream ahead>
> >
> > Now that I see the callsites, I think the "next" name could use some
> > bikeshedding <cough>.  The purpose of this function is either
> >
> > (a) to look up the first mapping to start iterating;
> > (b) to release whatever resources were attached during the current
> >     iteration and look up the next mapping to continue iterating; or
> > (c) to decide that it's time to stop iterating.
> >
> > From that it seems obvious to me that xfs_direct_write_iomap_next yield=
s
> > iomaps for iteration.  In Python those are called generator functions;
> > in Rust they're called objects that implement the Iterator trait (or
> > iterators for short).
> >
> > How about s/iomap_next/iomap_iter/ ?
> >
> > Then this function would be called xfs_direct_write_iomap_iter, which
> > IMO is a closer description of what the function does, which is to say
> > iterates iomaps for direct writes.
> >
> > (Yes, my brain might be polluted with thinking that "iomap next" refers
> > to a major shift, in the sense of "linux next". :P)
>
> Thanks for sharing your thoughts. The idea makes sense to me in theory
> but I think in rust and python the "iter" naming is reserved for the
> iterator object itself and the method / callback for advancing and
> yielding the next item in the iteration is named "next" (eg
> Iterator::next in rust and __next__() in python)? I wonder if the
> s/_next/_iter gets confusing with multiple things in iomap already
> called iter (eg the struct iomap_iter, the iomap_iter() function). I'm
> not sure, I'm happy to rename this if that's the preference.
>

Ahh okay, I think I see the point you were trying to make. The
callsite functions are like:

ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from=
,
                iomap_next_fn iomap_next,
                const struct iomap_write_ops *write_ops, void *private);

int iomap_fsverity_write(struct file *file, loff_t pos, size_t length,
                const void *buf, iomap_next_fn iomap_next,
                const struct iomap_write_ops *write_ops);

void iomap_read_folio(iomap_next_fn iomap_next,
                struct iomap_read_folio_ctx *ctx, void *private);

void iomap_readahead(iomap_next_fn iomap_next,
                struct iomap_read_folio_ctx *ctx, void *private);

etc, so it's not clear from the "iomap_next_fn iomap_next" naming that
it handles per-iteration logic, whereas renaming it to "iomap_iter_fn
iomap_iter" makes it more explicit. Am I interpreting this correctly?

I think this is a good idea. If no one has an objection, I'll make
this change for v3.

Thanks,
Joanne

>
> >
> > > +{
> > > +     return iomap_process(iter, iomap, srcmap, xfs_direct_write_ioma=
p_begin,
> > > +                     NULL);
> >
> > But then "iomap_iter" sets up a new problem: should iomap_process have =
a
> > new name that goes along with that?  iomap_iter is already taken for th=
e
> > legacy path.  If we were emulating python I'd suggest iomap_iter_yield
> > but this is C so we get to reinvent everything from scratch so who
> > knows.
> >
> > --D
> >
