Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C1119D8BC
	for <linux-xfs@vger.kernel.org>; Wed, 24 Sep 2025 18:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758737910; cv=none; b=Rhv3ZD7fKBljwhof2xmFoRghz5zyyRlceoOhWOf0PCndpm4MU7RZ46y3w1/OKR5sFI+NQZhz+bq3cxWlokBk5oS+IeQZJrAUchzBFZoG8O+md23JYCTYoU1XqfNFlHdBaP7kV6L0PfUgd6J0RB8/o1/ChMGefEO9UO0SC6DAMpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758737910; c=relaxed/simple;
	bh=ory5+NJ9BvZxsIZXubXLKy+nuRKqeT+Cb3ahLLWzLuw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N77vWtb14m2VLYAHXkm0jKkkvrsJfl7K11uR6wZ4fPLk5uG7kHIbrkwNStdh2bbtXauuGRrx/IRvmhga3oPNfO47T5+RWgr4iyEaHDRFgkG7qcjnkzX2bY27T7qX8V9d9vxOInrCTXqKg5uAf4GF4o57GWLAYgGRNYGpkHTbxCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N+zXtPln; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N+zXtPln"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4b38d4de61aso2064481cf.0
        for <linux-xfs@vger.kernel.org>; Wed, 24 Sep 2025 11:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758737907; x=1759342707; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oFTnrBy9ZUzyqzejBWKFr/WfTb6nZweuI2MfFnrt50Y=;
        b=N+zXtPlnVvENpWQkYMqEDebqaXajeS1Vcq+J4Z7zlTqQBOxMMK3IDg+CtL0yDUcADT
         +I6XC67pvMv9FF3/SYh72hqp4oiYPzpRyjkrB/GQO3rypASWhVZ+xMRE4ZKnKbL7CtUu
         Jc9Jhk551hvxEbAKk+2RJCm4nD9nuk+iNatqokdNbWxaSr7IO6JLWaxJRJ+f9X52ZH8q
         B4Ro4uN7ARVJ7/OAsD7l6b36x85gxzb4ESopn0PS3wEraF6enZPGlX/7UDb3h0eCd6u0
         VEdVyJjM/LNYJxaSkQCgeCYSNcw1O+ArMwc3mtPMVh/qExEIvr/4YlcwW2DYv9SM1jdR
         QJEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758737907; x=1759342707;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oFTnrBy9ZUzyqzejBWKFr/WfTb6nZweuI2MfFnrt50Y=;
        b=fxVHWhD2XZE+UzUeR+i2arK9vQ6n5SDAIYRlEEuCfoMPCzbRra3OLjLz1h0kRi3zte
         AO0EoT3qC8tpm0TZ4A8AmeCnEeoe69kLiDzSYRL6FzkzcgAXJhM4VCOX9PS/lefQ3U7r
         UvEAnNuCRbwDdysCS6tDJfJpfzTQAnQDEpHzqMznQ8Kd3Y1bhRq91wB/GKlKxb/SXJkh
         ucer52bkGzJd+PeY4pUrS+p7HScBe3Rf5vhGk2NndaEaOGAQ/tgYNd5K+5ozUsddpLAo
         zKI/56/9tykrSSFCt+S+VjQMaUKGRIXXivhw5rjBQFu2f0kDim9pAfOm/b63vqoBj9ha
         o/+w==
X-Forwarded-Encrypted: i=1; AJvYcCUQD/0SsEORB3Nab8xVaNFYfQKpHvs5cGQl01y+pGMHsR/0Ojc11gykOp0tev+vJ/urIrJlqtg3WNw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhCX51QdKxLkXc5dbiU4UTnOhf6w5Uo1i18bcfemBgf4qhvo1Y
	22+uAnEykla6WyMoUbtp2PNERlfWHHmAmqhGWG52MJQc0LO2I0buHtyC4N1vNqFu5agfvB/gsig
	NwKJxScDsbSkBlui6DRkTFaTOxMn7uJ0=
X-Gm-Gg: ASbGnctlACZuNwt2ncoriY3QIOKhchWojorl0P2VBeutjJaGgSeFfndGLYKRx9yb/XD
	39krU/E0yZhaIx5sYDGhp1+OHDwFnFCXUhW2Nat59puDGfSNUQzCd6wusncHAHoAKTg1j59iiTZ
	C265jfnUq/vDn7r6pOmA119z/bP9JO/7m0jA7QqnqOcKoUwDPgvsNsTtdLa+XKAEHiBakjE1djg
	r1nbXX8pIJXczZDA+Q4KsR2P+5rgNFhul4ZzWm2
X-Google-Smtp-Source: AGHT+IG0FJNATbowUCK2eCqu4TqdYgCRhA5RU6qsAcXIKcqgqCh/NZfG2X/A/r97ZJ/R+fCGywFmFYaqz9S0mvEbQig=
X-Received: by 2002:ac8:7d8e:0:b0:4d3:cc12:34ec with SMTP id
 d75a77b69052e-4da4c39d3d8mr9807261cf.55.1758737906418; Wed, 24 Sep 2025
 11:18:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250923002353.2961514-1-joannelkoong@gmail.com>
 <20250923002353.2961514-10-joannelkoong@gmail.com> <20250924002654.GM1587915@frogsfrogsfrogs>
In-Reply-To: <20250924002654.GM1587915@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 24 Sep 2025 11:18:14 -0700
X-Gm-Features: AS18NWDaLLz-85vyq1nHgT9THLWtQpVfc8Btmf12YhZ9wZJaiXl5Sn6PA4p4yN0
Message-ID: <CAJnrk1bYAaJofNBpYYKB2fWGVw-9BPrOUBy_ivmfnjR=49BmNQ@mail.gmail.com>
Subject: Re: [PATCH v4 09/15] iomap: add caller-provided callbacks for read
 and readahead
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: brauner@kernel.org, miklos@szeredi.hu, hch@infradead.org, 
	linux-block@vger.kernel.org, gfs2@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-doc@vger.kernel.org, hsiangkao@linux.alibaba.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 23, 2025 at 5:26=E2=80=AFPM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> On Mon, Sep 22, 2025 at 05:23:47PM -0700, Joanne Koong wrote:
> > Add caller-provided callbacks for read and readahead so that it can be
> > used generically, especially by filesystems that are not block-based.
> >
> > In particular, this:
> > * Modifies the read and readahead interface to take in a
> >   struct iomap_read_folio_ctx that is publicly defined as:
> >
> >   struct iomap_read_folio_ctx {
> >       const struct iomap_read_ops *ops;
> >       struct folio *cur_folio;
> >       struct readahead_control *rac;
> >       void *read_ctx;
> >   };
>
> I'm starting to wonder if struct iomap_read_ops should contain a struct
> iomap_ops object, but that might result in more churn through this
> patchset.
>
> <shrug> What do you think?

Lol I thought the same thing a while back for "struct iomap_write_ops"
but I don't think Christoph liked the idea [1]

[1] https://lore.kernel.org/linux-fsdevel/20250618044344.GE28041@lst.de/

>
> >
> >   where struct iomap_read_ops is defined as:
> >
> >   struct iomap_read_ops {
> >       int (*read_folio_range)(const struct iomap_iter *iter,
> >                              struct iomap_read_folio_ctx *ctx,
> >                              size_t len);
> >       void (*read_submit)(struct iomap_read_folio_ctx *ctx);
> >   };
> >
> >   read_folio_range() reads in the folio range and is required by the
> >   caller to provide. read_submit() is optional and is used for
> >   submitting any pending read requests.
> >
> > * Modifies existing filesystems that use iomap for read and readahead t=
o
> >   use the new API, through the new statically inlined helpers
> >   iomap_bio_read_folio() and iomap_bio_readahead(). There is no change
> >   in functinality for those filesystems.
>
> Nit: functionality

Thanks, will fix this!
>
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  .../filesystems/iomap/operations.rst          | 45 ++++++++++++
> >  block/fops.c                                  |  5 +-
> >  fs/erofs/data.c                               |  5 +-
> >  fs/gfs2/aops.c                                |  6 +-
> >  fs/iomap/buffered-io.c                        | 68 +++++++++++--------
> >  fs/xfs/xfs_aops.c                             |  5 +-
> >  fs/zonefs/file.c                              |  5 +-
> >  include/linux/iomap.h                         | 62 ++++++++++++++++-
> >  8 files changed, 158 insertions(+), 43 deletions(-)
> >
> > diff --git a/Documentation/filesystems/iomap/operations.rst b/Documenta=
tion/filesystems/iomap/operations.rst
> > index 067ed8e14ef3..dbb193415c0e 100644
> > --- a/Documentation/filesystems/iomap/operations.rst
> > +++ b/Documentation/filesystems/iomap/operations.rst
> > @@ -135,6 +135,29 @@ These ``struct kiocb`` flags are significant for b=
uffered I/O with iomap:
> >
> >   * ``IOCB_DONTCACHE``: Turns on ``IOMAP_DONTCACHE``.
> >
> > +``struct iomap_read_ops``
> > +--------------------------
> > +
> > +.. code-block:: c
> > +
> > + struct iomap_read_ops {
> > +     int (*read_folio_range)(const struct iomap_iter *iter,
> > +                             struct iomap_read_folio_ctx *ctx, size_t =
len);
> > +     void (*submit_read)(struct iomap_read_folio_ctx *ctx);
> > + };
> > +
> > +iomap calls these functions:
> > +
> > +  - ``read_folio_range``: Called to read in the range. This must be pr=
ovided
> > +    by the caller. The caller is responsible for calling
> > +    iomap_start_folio_read() and iomap_finish_folio_read() before and =
after
> > +    reading in the folio range. This should be done even if an error i=
s
> > +    encountered during the read. This returns 0 on success or a negati=
ve error
> > +    on failure.
> > +
> > +  - ``submit_read``: Submit any pending read requests. This function i=
s
> > +    optional.
> > +
> >  Internal per-Folio State
> >  ------------------------
> >
> > @@ -182,6 +205,28 @@ The ``flags`` argument to ``->iomap_begin`` will b=
e set to zero.
> >  The pagecache takes whatever locks it needs before calling the
> >  filesystem.
> >
> > +Both ``iomap_readahead`` and ``iomap_read_folio`` pass in a ``struct
> > +iomap_read_folio_ctx``:
> > +
> > +.. code-block:: c
> > +
> > + struct iomap_read_folio_ctx {
> > +    const struct iomap_read_ops *ops;
> > +    struct folio *cur_folio;
> > +    struct readahead_control *rac;
> > +    void *read_ctx;
> > + };
> > +
> > +``iomap_readahead`` must set:
> > + * ``ops->read_folio_range()`` and ``rac``
> > +
> > +``iomap_read_folio`` must set:
> > + * ``ops->read_folio_range()`` and ``cur_folio``
>
> Hrmm, so we're multiplexing read and readahead through the same
> iomap_read_folio_ctx.  Is there ever a case where cur_folio and rac can
> both be used by the underlying machinery?  I think the answer to that
> question is "no" but I don't think the struct definition makes that
> obvious.

In the ->read_folio_range() callback, both rac and cur_folio are used
for readahead, but in passing in the "struct iomap_read_folio_ctx" to
the main iomap_read_folio()/iomap_readahead() entrypoint, no both rac
and cur_folio do not get set at the same time.

We could change the signature back to something like:
int iomap_read_folio(struct folio *folio, const struct iomap_ops *ops,
const struct iomap_read_ops *ops, void *read_ctx);
void iomap_readahead(struct readahead_control *rac, const struct
iomap_ops *ops, const struct iomap_read_ops *ops, void *read_ctx);

but I think it might get a bit much if/when "void *private" needs to
get added too for iomap iter metadata, though maybe that's okay now
that the private read data has been renamed to read_ctx.


>
> > +
> >  static int iomap_read_folio_iter(struct iomap_iter *iter,
> >               struct iomap_read_folio_ctx *ctx, bool *folio_owned)
> >  {
> > @@ -436,7 +438,7 @@ static int iomap_read_folio_iter(struct iomap_iter =
*iter,
> >       loff_t length =3D iomap_length(iter);
> >       struct folio *folio =3D ctx->cur_folio;
> >       size_t poff, plen;
> > -     loff_t count;
> > +     loff_t pos_diff;
> >       int ret;
> >
> >       if (iomap->type =3D=3D IOMAP_INLINE) {
> > @@ -454,12 +456,16 @@ static int iomap_read_folio_iter(struct iomap_ite=
r *iter,
> >               iomap_adjust_read_range(iter->inode, folio, &pos, length,=
 &poff,
> >                               &plen);
> >
> > -             count =3D pos - iter->pos + plen;
> > -             if (WARN_ON_ONCE(count > length))
> > +             pos_diff =3D pos - iter->pos;
> > +             if (WARN_ON_ONCE(pos_diff + plen > length))
> >                       return -EIO;
>
> Er, can these changes get their own patch describing why the count ->
> pos_diff change was made?

I will separate this out into its own patch. The reasoning behind this
is so that the ->read_folio_range() callback doesn't need to take in a
pos arg but instead can get it from iter->pos [1]

[1] https://lore.kernel.org/linux-fsdevel/aMKt52YxKi1Wrw4y@infradead.org/

Thanks for looking at this patchset!

Thanks,
Joanne
>
> --D
>
