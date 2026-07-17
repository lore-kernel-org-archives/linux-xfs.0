Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E61A34676F
	for <linux-xfs@vger.kernel.org>; Fri, 17 Jul 2026 16:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784306986; cv=pass; b=OK2GcZNq0eebjuh/D4TKC0TRN9BqRxODvY3IyezVDrn9vqLmSgJtP/S426L+HuvCOn4dNmfyryadwP36GdKcReQBZ31/FO+iwzve20Idt4wqijBLCPp53B6R4gY8N6980/MENKjxvkiYCZ7/CLpr/WIjyHlX8LY1rQxqPyDRZt4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784306986; c=relaxed/simple;
	bh=9CdHPsUZAy8Yo0MKXff0kgEmv/B+FhNhAg47sPzRDDc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RPBQCN8ik4JnWvpg1YY24u9LzgAIqVYrr+2/SU2iw3nnK+qwcfyrhDa82LFLZMcBWqSozNZbxkpZ+km0F5FURBYu6aFkR1uQFU9NThdaOKzXch0lMwx3ZkTtlNq/Mv7Ah+oETF9QJk5Xggsh1xeZotGl2S3cK7dtt7rx5v3lDWs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FioXWF1U; arc=pass smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FioXWF1U"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-4798bea72f9so4235791f8f.1
        for <linux-xfs@vger.kernel.org>; Fri, 17 Jul 2026 09:49:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784306983; cv=none;
        d=google.com; s=arc-20260327;
        b=IUN+B3hKinRB0ku8aLCHfn2WntlZWxIhjVJcLVahVscA0f9duz7efAQhPYjyuFfA0E
         gO4MTqU7O+rWyVDB0/3uihoeQMtBc5rUWGFvg5IbnmnZQ8DZ+u+6iWHmQVxev2SrLKOp
         H5kmjgVQt4FHo32egpORoaMpPM1jj5dtiU0tbdR2JMx9paKjbOP+6GvruTFBEpoTIDMV
         7cbe1zXh8dOi8sNDuvj1OejyamdBTmGPZ2MEjh1OVSkcjDuCzeshVHFJGVkqNiTafnve
         K0AohBqkAkaIqFH1uqdqfYRoIt57hVUObnjtTblLgoS4z+wlzuQ6kyu+PkX8AQEVzUaj
         Y+vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7lLuKKfJwb6KqGr3DuEUOFXs3XGlGNHq9ltG+hEfEQQ=;
        fh=yE/bkt9IlP/HFTqMNMteXtu//vfkTg1mqtfVYHAOlvs=;
        b=QUj7pprPDrC6Jw8RjJneshjK5zM20i2yJ0Irkmn4LEb817hgEVH+in3qCmsNNPXzlm
         aAuJDOPmI9Gwm7ry2vzZ/ToCROYgtzkxkzsTsb1LR5RDNQBqJ1F/WJ5ghc16OQzN365e
         aKVGurDQ8lPz/pdVHU+liZBuNTnqqG1BhfcVXOrrCPEu1MYgpGKUIgmNfA+3cxvlvMVQ
         LN4kjSLcT0tOk8Dun/ise5SuI9aAKNklQPP/JcvJyxd4QscKxQiiWkyagzprf4UlMaOT
         UAmeB16efhmJ0F9K9hr6ajkW+k3KIAX4tzoQIIGBgEPhqCYl2j64ODXvvVdJHfVQYcv3
         Gldw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784306983; x=1784911783; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7lLuKKfJwb6KqGr3DuEUOFXs3XGlGNHq9ltG+hEfEQQ=;
        b=FioXWF1U1EcyYvW/neBuRivUFuUM/dGN6vdNX6I2drbDfhEDe00oW1TcyhBSLUEKvS
         Y7BeYfddENcxbqUtR6WAvwjESkfGLxf2EX8dM00nlplQPOrBEVnXMlCBcefLKfK2fzKy
         0ToeUe4T6UQk7HveduFGVR8ziX4CNYbzHo/n4az/UqosHKNPBTyldb9hY70AIaiF+jFs
         rLgRjEruPv6rzwL+dkiaL3hVgmb6axTAJ6Lcq/m8v3pncHLMlci+yerBWziYFIr55q5i
         Hcb3mwnn9ltdHU3c6QEinNYOpnVxGeXWDqs3F3EzU8AmRQ2B8d1YyhiLO4TYBu6LRV44
         SuJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784306983; x=1784911783;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7lLuKKfJwb6KqGr3DuEUOFXs3XGlGNHq9ltG+hEfEQQ=;
        b=MLKzj8aipTBjcRQd7eLhMnJ8ysB5zNMT+4QN4UOcO7g46aO9Bv2slNe2bBf/FjO50z
         sSp6VL25F2V4uPHMkEQt0XhwAe4krxlK0SnYoUX+gwD4WuK6GEzzSMY6MdgUhoyiWc3k
         Y1woe4WodT3LlomHQTJxz7PkxsXaPV4u1/N9ztH1RmN72L9Fdkefof5MXkJ5cFYaC2x3
         nBls/Kx0AdgKzWv2TFhNi5XLse/z42qkx+0ryqVeQAy3Dvaal34WMPQaves2Z+icIMMw
         VLhreYP8JDMnB3R6HEd/LI7fTcs43a3VhseIMQWG1boQS1wtMNQNfeLJ5ilnad77koWC
         8o5Q==
X-Forwarded-Encrypted: i=1; AHgh+Rpl2t8jQ951/aJr7h5euL/1U9pFH5pLc9nDbbgpwEhDcnKcmCyqfrv9BDBnCF5bMWPu8dK9OiPXfDk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFf1ZJQ3lgXhmd8dcSjCUYnXF/JMXiae4q3mXR0qQ0xcpfLF5+
	QTJaeE1k+3wAAyTpd9UV31p4mHqERO3bpNNzOOEYX81tcX7FjJ1aeD+/3k8ypm7Z4bGBa/g7ptc
	lwFSAYyfujTUXKF6LUNC/V2e4VHwiWKQ=
X-Gm-Gg: AfdE7cmmh68WsGOwtYmv17eidwRYZYjyjw0pnJfYUjiMcPl2ovZrj5fQ31K4lgq2/1T
	QwN08X2IyxLfJ6U6D1rbhFkymolMwzBXQgRtDwPwH8lhaMgJWIvuOvL937pqjKjebZiz2zktept
	C4W1C6Jwo0YEwQ0cmjpR/Uc1HZHE6fQLRadKnvKLnquVFcVhgIzfzA2ZQdk+2CKMS2lEd8nkPR6
	qOHRiDhCCG8mxZNyy1/i/rFJMhGIMopxe2ATroqtY4uP/FFMtmRf2HHxfIQ1pyxGppc1QjF7cK9
	UIsp9chqjk4cF+aCTUvuRjPVzkJp7pZjbZug7wx78A==
X-Received: by 2002:a05:6000:188f:b0:47e:81b1:74aa with SMTP id
 ffacd0b85a97d-47f6233419fmr4831356f8f.42.1784306982525; Fri, 17 Jul 2026
 09:49:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
 <20260701000949.1666714-3-joannelkoong@gmail.com> <20260702164339.GI9392@frogsfrogsfrogs>
 <CAJnrk1ZRQaFseAnz3zm31oR3KmQWje5HDJjhNbAQSAQyK9_PMA@mail.gmail.com> <CAJnrk1bj4pLpAzLhehrbDJuKWa=WMq-3XOAm9dhsEVDF9WCBPQ@mail.gmail.com>
In-Reply-To: <CAJnrk1bj4pLpAzLhehrbDJuKWa=WMq-3XOAm9dhsEVDF9WCBPQ@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 17 Jul 2026 09:49:30 -0700
X-Gm-Features: AUfX_mwBLTjYZBsmrkzBHbWUlNQxbiDGEEKR9rvM2xEKSv_VHq7AM_IkTmwM4go
Message-ID: <CAJnrk1YkAEUhjw6mNEx70ojN7UMQT__oHn5m1Ng2Lz7FoLRhrA@mail.gmail.com>
Subject: Re: [PATCH v2 02/18] xfs: convert iomap ops to ->iomap_next()
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: brauner@kernel.org, hch@lst.de, willy@infradead.org, 
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>, 
	open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 2, 2026 at 6:21=E2=80=AFPM Joanne Koong <joannelkoong@gmail.com=
> wrote:
>
> On Thu, Jul 2, 2026 at 4:59=E2=80=AFPM Joanne Koong <joannelkoong@gmail.c=
om> wrote:
> >
> > On Thu, Jul 2, 2026 at 9:43=E2=80=AFAM Darrick J. Wong <djwong@kernel.o=
rg> wrote:
> > >
> > > On Tue, Jun 30, 2026 at 05:09:17PM -0700, Joanne Koong wrote:
> > > > Convert xfs iomap_ops to the new ->iomap_next() callback. This uses=
 the
> > > > iomap_process() helper, which finishes the previous mapping if need=
ed
> > > > and produces the next one. No functional changes are intended.
> > > >
> > > > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > > > ---
> > > >  fs/xfs/xfs_file.c  |  4 +-
> > > >  fs/xfs/xfs_iomap.c | 96 +++++++++++++++++++++++++++++++++++++++++-=
----
> > > >  2 files changed, 88 insertions(+), 12 deletions(-)
> > > >
> > > > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > > > index 845a97c9b063..7f8bef1a9954 100644
> > > > --- a/fs/xfs/xfs_file.c
> > > > +++ b/fs/xfs/xfs_file.c
> > > > @@ -857,9 +857,9 @@ xfs_file_dio_write_atomic(
> > > >                       NULL, 0);
> > > >
> > > >       /*
> > > > -      * The retry mechanism is based on the ->iomap_begin method r=
eturning
> > > > +      * The retry mechanism is based on the ->iomap_next method re=
turning
> > > >        * -ENOPROTOOPT, which would be when the REQ_ATOMIC-based wri=
te is not
> > > > -      * possible. The REQ_ATOMIC-based method typically not be pos=
sible if
> > > > +      * possible. The REQ_ATOMIC-based method is typically not pos=
sible if
> > > >        * the write spans multiple extents or the disk blocks are mi=
saligned.
> > > >        */
> > > >       if (ret =3D=3D -ENOPROTOOPT && dops =3D=3D &xfs_direct_write_=
iomap_ops) {
> > > > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > > > index 225c3de88d03..4fa1a5c985db 100644
> > > > --- a/fs/xfs/xfs_iomap.c
> > > > +++ b/fs/xfs/xfs_iomap.c
> > > > @@ -1037,8 +1037,18 @@ xfs_direct_write_iomap_begin(
> > > >       return error;
> > > >  }
> > > >
> > > > +static int
> > > > +xfs_direct_write_iomap_next(
> > > > +     const struct iomap_iter *iter,
> > > > +     struct iomap            *iomap,
> > > > +     struct iomap            *srcmap)
> > >
> > > <unvarnished brainstream ahead>
> > >
> > > Now that I see the callsites, I think the "next" name could use some
> > > bikeshedding <cough>.  The purpose of this function is either
> > >
> > > (a) to look up the first mapping to start iterating;
> > > (b) to release whatever resources were attached during the current
> > >     iteration and look up the next mapping to continue iterating; or
> > > (c) to decide that it's time to stop iterating.
> > >
> > > From that it seems obvious to me that xfs_direct_write_iomap_next yie=
lds
> > > iomaps for iteration.  In Python those are called generator functions=
;
> > > in Rust they're called objects that implement the Iterator trait (or
> > > iterators for short).
> > >
> > > How about s/iomap_next/iomap_iter/ ?
> > >
> > > Then this function would be called xfs_direct_write_iomap_iter, which
> > > IMO is a closer description of what the function does, which is to sa=
y
> > > iterates iomaps for direct writes.
> > >
> > > (Yes, my brain might be polluted with thinking that "iomap next" refe=
rs
> > > to a major shift, in the sense of "linux next". :P)
> >
> > Thanks for sharing your thoughts. The idea makes sense to me in theory
> > but I think in rust and python the "iter" naming is reserved for the
> > iterator object itself and the method / callback for advancing and
> > yielding the next item in the iteration is named "next" (eg
> > Iterator::next in rust and __next__() in python)? I wonder if the
> > s/_next/_iter gets confusing with multiple things in iomap already
> > called iter (eg the struct iomap_iter, the iomap_iter() function). I'm
> > not sure, I'm happy to rename this if that's the preference.
> >
>
> Ahh okay, I think I see the point you were trying to make. The
> callsite functions are like:
>
> ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *fr=
om,
>                 iomap_next_fn iomap_next,
>                 const struct iomap_write_ops *write_ops, void *private);
>
> int iomap_fsverity_write(struct file *file, loff_t pos, size_t length,
>                 const void *buf, iomap_next_fn iomap_next,
>                 const struct iomap_write_ops *write_ops);
>
> void iomap_read_folio(iomap_next_fn iomap_next,
>                 struct iomap_read_folio_ctx *ctx, void *private);
>
> void iomap_readahead(iomap_next_fn iomap_next,
>                 struct iomap_read_folio_ctx *ctx, void *private);
>
> etc, so it's not clear from the "iomap_next_fn iomap_next" naming that
> it handles per-iteration logic, whereas renaming it to "iomap_iter_fn
> iomap_iter" makes it more explicit. Am I interpreting this correctly?

Going back to this... "iomap_iter_fn iomap_iter" doesn't feel quite
right. I think there's too much naming collision with iomap_iter() and
struct iomap_iter, and I like how in general ->next() matches the
orthodox naming scheme for advancing an iterator. I think
"iomap_iter_next_fn next" would be the best of both worlds - I'll
change it to this for v3. But if you don't agree with this, please let
me know.

Thanks,
Joanne

>
> I think this is a good idea. If no one has an objection, I'll make
> this change for v3.
>
> Thanks,
> Joanne
>
> >
> > >
> > > > +{
> > > > +     return iomap_process(iter, iomap, srcmap, xfs_direct_write_io=
map_begin,
> > > > +                     NULL);
> > >
> > > But then "iomap_iter" sets up a new problem: should iomap_process hav=
e a
> > > new name that goes along with that?  iomap_iter is already taken for =
the
> > > legacy path.  If we were emulating python I'd suggest iomap_iter_yiel=
d
> > > but this is C so we get to reinvent everything from scratch so who
> > > knows.
> > >
> > > --D
> > >
