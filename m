Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9193C7691
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 22:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783032093; cv=pass; b=hwBc4oxcraQT0KMGqZVWbWhiV1ZchZAGtd3rLHVU1D4ua7r/L0QZ9C2S3AOVhDFbvAngvuM5fZuMwU5l9AQN7qoDOWdbZYIYM8otqocf5J1VR2SonXTQQ5FEicsZ4TwVl/Am3wPENgdGOz/kVTi6Rbo1hVr4LOBJkaIPPL/TLt4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783032093; c=relaxed/simple;
	bh=WIAOw+mwvcTYeXCgk6/3W7/rb4zmiahpFKaV0/jt0YU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b/N1h7Pv4eOqRYaP3/nKbEjFGQ3Y0546cZKrPGK+WyWPHK3DCaOjLkm8moaA5txB7B3ki1odDPPZl9oNnaaVP8wecuTd6OCMlQzxluMgmL/RnCBjWglTvgs2REJL/+CTWdGSG7sDCoa1/Tf0y+cy75h5Wv7Vf0M/vC6WFQ7o/xg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YqosHtCU; arc=pass smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YqosHtCU"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-493c55d5c7aso11674765e9.1
        for <linux-xfs@vger.kernel.org>; Thu, 02 Jul 2026 15:41:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783032088; cv=none;
        d=google.com; s=arc-20260327;
        b=oTT+tDSK49NuLayXGLhparLd8KZX/lFUxKreKfKo4JuFHvTx+E9/681YVxUVYWFga8
         EfpTSceQtLndkAy3EfLmeNR9PCJD4cR6/bzweVtHQ2eVWexQs3HjNN7CHIYXWJM8VHJF
         m+L6JVYPcauff0mt8GFCmePA35YlTAc3WkbDvqSGYvx2YWUnDlKReEQT7TBQPsYqFnnz
         DsAW0f4UAiq/f7BzKyIPSiAOu9JVbshJljfOr372YPgLXOnhJi7TTMfr6j3npb8ROVmX
         m8AGckH0qAausdlD621KgaJj4wrKuCcMOAlag4DyAhPIx1nFefP5wjgKroX1XB2O9Mri
         /sMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=h9a02slDLUgWwDo+yKrdEPAIuAXAqNrHLiCEZt+6Lmg=;
        fh=DWrQ/o5ELFQE9vA8U17pHxTwbO3h2HqetR2pdjSIM/o=;
        b=KWfr2ymBcPLUpVUGn1MQqe0NO0Q+MZuXPPCmed/+idKJ9fpgCCdfIHGHV7+gV4/ilg
         p6VX9foU5JJuMQLPosXFu3lbZlOKl3oL/YjZD5RIn9B1BQnp+OI2FGZ5Ijn4QFZE7ENu
         h69ZyoFuSG3gkqKS9pPk3t3IU2d0kC4VDt7cjb5gMmPxBDYqCktxaAEw/qXfYEt1S1x+
         pV4m2U9hX/yshMG0WKg4rcUEOCewKG+Z4j8J4QE3pYUB6UtVdKJgCckQimk/8F1rMeuN
         Ee/+tyUR5AxTMaYNjKLjojrTv2lZyjMo2Q1qsLtngWuKIj4LyE/oOMp6T0L2VqYNBuTl
         NN/Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783032088; x=1783636888; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h9a02slDLUgWwDo+yKrdEPAIuAXAqNrHLiCEZt+6Lmg=;
        b=YqosHtCUXNzXfWUzNNlHrQf51o9AW413o3K7p4zaIw34/4ZuK2aEFAhm1/IVmUGR0Z
         8e3t/5uSeJwHAflA9cHsPJqYd4AuE7d94ljSpndkHSd5GoC/dfHFK7BU8yc4X0EEIMGm
         0MHnIVPrtn9AhoyBsKW1mkeE7m2HAijVu9AVyRIi7Aia++iHmJqev4LWKfdgD/tYfuhf
         WMvTxzqWF28Ptc8QQN2gHd0hscbIpy0/lXSjXacD8jKKViyVnN/H5TA39jCmaWVOi6zg
         diot39qwe8DwfIYsLTFdP4wGRIOEijiVNQnp0BCrN9MBYUkyK7Niv3HsTdqJVC0cN/CN
         Gvaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783032088; x=1783636888;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h9a02slDLUgWwDo+yKrdEPAIuAXAqNrHLiCEZt+6Lmg=;
        b=Pmcus02AgLtuWrxbQSwbuyN+YoFTERsDHBlv/eB5KDJ7BQ9vBs/noVl2I8I845ePVQ
         yQqnht9RouA9vtYh5vKWL0uSjcPWDrC6rmfYNMK6XUkiOAV4us7WtwWttmBPnfnUeSQJ
         eugo/FK21jHN2EgULduEWacddsqmnTcKDN089E4YnHQkvnhZq2qDi0wRIxW/WNt+0X06
         AWHKQiI4TywASyw8YTH6H10aLlKlKcGemIVS1d+TsgOevQpwjtY+zTE1ORgPbHAmwh4k
         WLyhzkCLwmHvJ4fkAz1/Pq5BCYSRhIzndLsg6pJglFS7zAXV8w1ovd1iM7nBwHmU09qS
         BVAw==
X-Forwarded-Encrypted: i=1; AFNElJ+c17NJ3pZTAT8Ac5+TCtdcOWS3MOttCBJ/NUa+fNwiwy7tSFAHACM8/L6pAl+bqR23MwFiZGk9YiI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyynQ6lZO0JGHKHH3+SllYMwj9FAXMd17psdsTvqGJCfvl07rtB
	UN2Y+x8jjGxMCqfUuKIlarlAy5ALBqyyxIlB0+DUiNJPJOAXiDo3eZD5vTNLa5SNofpepDqGoUP
	wnn1gHJ2JM+0G4OgmV9Io+c0z1tz6o2H5V5K6
X-Gm-Gg: AfdE7cmgPL718mNwBPe+zVB7utGm8bwz+C9r+ZpK8esuC8BlcuQtvYzXb2BaB82Nd97
	7loZQw/I6LI4lrcluiBgEuvdGffSlO7sQ/4DNm04/tb8rkp2dpB//n1iGL7/sT6VQXjPSXzoDaq
	vaRLgSMpInyJV7aBKNIk/aGPlGbxbbcec0SY/izWgww3eSyT5de1v5RpJSr0MEgdxE5AgLQC4So
	T+iPlriHHE9UCTu2Fv9POwhjLvpDsFzaaLmUUsQ2FSVdFX65GuwLD2cHiumQYJeGPNqorOyHibM
	Pfyvg6oOWFzj9+76im3UtsOLzE387JC3RvAz2oQyBurVEkEGhkcM
X-Received: by 2002:a05:600c:4f94:b0:493:adc3:cced with SMTP id
 5b1f17b1804b1-493c2b9826fmr112815045e9.34.1783032087995; Thu, 02 Jul 2026
 15:41:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
 <20260701000949.1666714-2-joannelkoong@gmail.com> <20260702162308.GH9392@frogsfrogsfrogs>
In-Reply-To: <20260702162308.GH9392@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 2 Jul 2026 15:41:15 -0700
X-Gm-Features: AVVi8CcF6CmN9sR8NoQCdzue53Nqs4TLr02dXcvyfMRXcWTVkIDv2UbgUVh2ijY
Message-ID: <CAJnrk1a2ZT8DRgw5nS1G_9-QpDcA323iebsxZ9cn_BP9XTRvVw@mail.gmail.com>
Subject: Re: [PATCH v2 01/18] iomap: add ->iomap_next() and iomap_process() helper
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: brauner@kernel.org, hch@lst.de, willy@infradead.org, 
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 2, 2026 at 9:23=E2=80=AFAM Darrick J. Wong <djwong@kernel.org> =
wrote:
>
> On Tue, Jun 30, 2026 at 05:09:16PM -0700, Joanne Koong wrote:
> > Have one ->iomap_next() callback instead of ->iomap_begin() and
> > ->iomap_end(). ->iomap_next() finishes the previous mapping if needed,
> > and produces the next mapping. This lets performance-critical callers
> > inline the iteration with a fixed callback, which the compiler is able
> > to call directly instead of indirectly.
>
> Er... what is being called directly here?  The iomap_{begin,end}
> functions?  It looks to me like ->iomap_next is still an indirect call
> even at the end of the series, right?  That's still a net reduction of
> indirect calls at least.
>
> Oh, wait, it's the __always_inline iomap_process function that a smart
> compiler can use to turn the indirect calls into direct ones, isn't it?
> It might be useful to add a comment to that function saying that out
> loud so that dolts like me will pick up on why it's critical for it to
> be an inline function.

Ahh the sentence was confusingly / ambiguously worded, sorry about
that - I was trying to say that it lets callers have the ability to
inline iomap_iter() with passing a const iomap_next callback as an arg
which lets the iomap_next callback be a plain direct call. But your
interpretation of it is also true. I'll add the comment you suggested
to spell what you mentioned out and reword the commit message to make
what I was trying to say more clear.

>
> I like how this is going. :)
>
> > iomap_iter() uses ->iomap_next() when the filesystem provides that
> > callback and otherwise falls back to the ->iomap_begin()/->iomap_end()
> > path, so filesystems can be converted one at a time.
>
> > Add a iomap_process() inline helper that does most of the logic needed
> > in an ->iomap_next() implementation.
> >
> > Suggested-by: Christoph Hellwig <hch@lst.de>
> > Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  fs/iomap/iter.c       | 113 ++++++++++++++++++++++++++++++++++++------
> >  include/linux/iomap.h |  91 +++++++++++++++++++++++++++-------
> >  2 files changed, 171 insertions(+), 33 deletions(-)
> >
> > diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
> > index e4a29829591a..1062e4e34c38 100644
> > --- a/fs/iomap/iter.c
> > +++ b/fs/iomap/iter.c
> > +
> > +/**
> > + * iomap_iter_continue - decide whether iteration should continue
> > + * @iter: iteration structure
> > + * @iomap: the mapping that was just processed
> > + * @srcmap: the source mapping that was just processed
> > + *
> > + * Helper for ->iomap_next() implementations, normally called via
> > + * iomap_process().  Called after the previous mapping has been finish=
ed to
> > + * determine whether there is more of the file range left to process.
> > + *
> > + * Returns 1 if there is more work to do, in which case @iomap and @sr=
cmap are
> > + * cleared so the caller can produce the next mapping; zero if the ran=
ge is
> > + * fully consumed; or a negative errno on error.  Any folio batch atta=
ched to
> > + * the mapping is released before returning.
> > + */
> > +int iomap_iter_continue(const struct iomap_iter *iter, struct iomap *i=
omap,
> > +             struct iomap *srcmap, int ret)
> > +{
> > +     bool stale =3D iomap->flags & IOMAP_F_STALE;
> > +     ssize_t advanced =3D iter->pos - iter->iter_start_pos;
>
> These both could be const, right?
>

I'll mark these as const. Thanks for looking at these patches!

Thanks,
Joanne
