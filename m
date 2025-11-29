Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F9636D4FD
	for <linux-xfs@vger.kernel.org>; Sat, 29 Nov 2025 02:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764383598; cv=none; b=dDEMRRnWf4Dm3I0Il01lrLNhigUakyHTtdIs3ryLpaQhK6RwDFx5c+CoChOZWz9QEZ+NnYcXOYFzNpMlzTZS1Wxwv34ZsjOq5nNvR2vJ040zL+lja9eM/X2x8uzyEp8aVZ1LhIUPGJUS646ME1B2PAQiQjLzhjQu3/Hc0eKprWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764383598; c=relaxed/simple;
	bh=gNmObkaIZK3VlWDhqKE4t58k5wTLOfMWXzJHLja63YI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oQtq0CA9sKA7ykT3euB3WUTLe94Pn3jJ7Jlxhs+9qEvKLoBCYdaCJf041fuKiyc7NQk5QTI869VuXJw2yOpUD9cf764lBbY2IP7/yoR1dMjdWWEnMlF/k0ztA8sbNJDO8VEKjJc4pKRnH+SAMapYTrjr2RDSWzu7L/wIaRU1NAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hmqzAmJt; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hmqzAmJt"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4ed82ee9e57so31780601cf.0
        for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 18:33:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764383594; x=1764988394; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Salk+Bq7Bto6CaKtKUn0rvQi1HOfk6akFnXhArcYZw=;
        b=hmqzAmJtMjR2rJnt1NZ+GidcZrYheDR86S9CFt0GVGy/cLTl/4AvzPDtCWm9XUDi0g
         CwUGnX6tL7XKHBHrrNTcNvu3ipaNP5EN0e0vj4v57UCE690TwSAsTlxA89ePBwlmMKl2
         eXibW6uJInJ1N87QmT7F4Aj92qXcxdNMoIWn3Yyz4mJk9PKM185IEV1N8vk/rLE9G0xg
         yUFgm2ysA3v8+rop2rfHHbXcXtbF2y7FVQDiGwsmDXgH00vJz7uJnkodYA7D8ohPzYDo
         qMJfMByiynrcFInzAgsZim0ZNXcA9K8DfeUwZeHJUGX+DeFD2FUJurXyuIvdaZ2AGBQ6
         Be8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764383594; x=1764988394;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4Salk+Bq7Bto6CaKtKUn0rvQi1HOfk6akFnXhArcYZw=;
        b=bVHzef7qPZlORg9QyOGJo6WS1h3HDNiUgawKIdifLPyO1bK+QhddJkfTtLmERLZylO
         2h0Ls5BOxOdkDtEvBhqUI1q/cX9woPUmU4FyQrBpFegV26DL6dnu93H34PLgxcqSvO7T
         n2uqcFgcia0tydUELXReqxLlwOa+DMbi1tyaj4Q3txDabXasGZnowpuUHD/6w4o+nJa8
         zydW/dotihiNxtRTjM3vZFhh/rdLgmer/z2qhT77r6mRyDbi/TKBZHA/lfmeIqAQtBuf
         4BAMrmA4AhJ6mGW0h5BOLVXgmCE5hxCG1+dJMYF/7a65zUN6ms6jVtlMaHAToFDSju8q
         EpqA==
X-Forwarded-Encrypted: i=1; AJvYcCVclBUt2KztcRIegFW4n96HIW0gcQIx4nd/JMTp6owevZgINGXBpxndCGq0vyrfNJrOFmoKbbCuhw8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxpWuNFlMKiXVspKEklGbzD7qgjrNYNLG4tpQL//eHoM1XvWKu2
	OtRo2R6UxeP9LmLhZ2kjxA0hlZw1J9t5D77K41Hjfo8M/XHljPgMq6vMlW8wtsSdquDq9tJzAQi
	2d4+5xgt2PbSpQoo2MgyvY1QvSchahu8=
X-Gm-Gg: ASbGncs9jOMu+9qzM66u+vxRFpCxPIDWIabikR4q9F6vfnK/asIBR2Lk9Og7+ajy+y8
	tjbMwxkeF/cZjFtGTSQEw8c164XDPYt5SyptK3/95UVFsVTZ4gXk2+wFeds3+Fk9UjG0bpPc47O
	jJMgf6yI9p+YvWaQfWR1UAYCxnAC258vr3Vr2VxIxzn50bqJp+wimTxZ19DND5MCFgCQJnJZaXg
	/KiKqVhO6/KEbxqUuVR04nYI19DTFHWn/d3ta4335eMFetaLf4y2kagF7Jus/1uPtvk4A==
X-Google-Smtp-Source: AGHT+IFPyQ3Ox8QMkCC+AFAT7oHRFHqyjDP2jn77IYnsfuFY8QOZCQOTUo4k7dkGxBUwkR6gi0usD4185jOYTHNWGHI=
X-Received: by 2002:ac8:7f47:0:b0:4ee:14c3:4e6e with SMTP id
 d75a77b69052e-4ee58a44b9cmr406211541cf.2.1764383594116; Fri, 28 Nov 2025
 18:33:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251128083219.2332407-1-zhangshida@kylinos.cn>
 <20251128083219.2332407-3-zhangshida@kylinos.cn> <CADUfDZqBYdygou9BSgpC+Mg+6+vaE2q-K=i1WJB1+KAeBkS1dg@mail.gmail.com>
 <CANubcdUmUJKeabgagPTWhBd42vzOqx9oxG23FefFJVCcVa_t5A@mail.gmail.com>
In-Reply-To: <CANubcdUmUJKeabgagPTWhBd42vzOqx9oxG23FefFJVCcVa_t5A@mail.gmail.com>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Sat, 29 Nov 2025 10:32:38 +0800
X-Gm-Features: AWmQ_bkv6yGPO014px4Ar0BXIBRCkLv-alSslcloxzSsXTYX1dEXbtGPSH-grNc
Message-ID: <CANubcdU2f1+fCL9sYsrwXz-W0dzEsm_+Bds1m3W8=o_sQX30Hw@mail.gmail.com>
Subject: Re: [PATCH v2 02/12] block: prevent race condition on bi_status in __bio_chain_endio
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, gruenba@redhat.com, 
	ming.lei@redhat.com, linux-block@vger.kernel.org, 
	linux-bcache@vger.kernel.org, nvdimm@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, 
	gfs2@lists.linux.dev, ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn, 
	Andreas Gruenbacher <agruenba@redhat.com>, Gao Xiang <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Stephen Zhang <starzhangzsd@gmail.com> =E4=BA=8E2025=E5=B9=B411=E6=9C=8829=
=E6=97=A5=E5=91=A8=E5=85=AD 09:47=E5=86=99=E9=81=93=EF=BC=9A
>
> Caleb Sander Mateos <csander@purestorage.com> =E4=BA=8E2025=E5=B9=B411=E6=
=9C=8829=E6=97=A5=E5=91=A8=E5=85=AD 03:44=E5=86=99=E9=81=93=EF=BC=9A
> >
> > On Fri, Nov 28, 2025 at 12:34=E2=80=AFAM zhangshida <starzhangzsd@gmail=
.com> wrote:
> > >
> > > From: Shida Zhang <zhangshida@kylinos.cn>
> > >
> > > Andreas point out that multiple completions can race setting
> > > bi_status.
> > >
> > > The check (parent->bi_status) and the subsequent write are not an
> > > atomic operation. The value of parent->bi_status could have changed
> > > between the time you read it for the if check and the time you write
> > > to it. So we use cmpxchg to fix the race, as suggested by Christoph.
> > >
> > > Suggested-by: Andreas Gruenbacher <agruenba@redhat.com>
> > > Suggested-by: Christoph Hellwig <hch@infradead.org>
> > > Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> > > ---
> > >  block/bio.c | 7 +++++--
> > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/block/bio.c b/block/bio.c
> > > index 55c2c1a0020..aa43435c15f 100644
> > > --- a/block/bio.c
> > > +++ b/block/bio.c
> > > @@ -313,9 +313,12 @@ EXPORT_SYMBOL(bio_reset);
> > >  static struct bio *__bio_chain_endio(struct bio *bio)
> > >  {
> > >         struct bio *parent =3D bio->bi_private;
> > > +       blk_status_t *status =3D &parent->bi_status;
> >
> > nit: this variable seems unnecessary, just use &parent->bi_status
> > directly in the one place it's needed?
> >
>
> Thanks, Caleb and Andreas. I will integrate your suggestions to:
>
>       if (!bio->bi_status)
>                cmpxchg(&parent->bi_status, 0, bio->bi_status);
>

Sorry, it should be:
      if (bio->bi_status)
              cmpxchg(&parent->bi_status, 0, bio->bi_status);

Thanks,
Shida

> Thanks,
> Shida
>
> > Best,
> > Caleb
> >
> > > +       blk_status_t new_status =3D bio->bi_status;
> > > +
> > > +       if (new_status !=3D BLK_STS_OK)
> > > +               cmpxchg(status, BLK_STS_OK, new_status);
> > >
> > > -       if (bio->bi_status && !parent->bi_status)
> > > -               parent->bi_status =3D bio->bi_status;
> > >         bio_put(bio);
> > >         return parent;
> > >  }
> > > --
> > > 2.34.1
> > >
> > >
