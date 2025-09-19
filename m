Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4273322532
	for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 17:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758304716; cv=none; b=MMyTgx/2M7ooFFVo9ejSM2U38VT3ZEbPoyVxXwujxzc0KwPXtWIA6SO54FlUSGZzfpwKW4wOY6Y2u0LBHVG42gSJBpw6GzR3Y3FBsHbWFauszLT3kvjTse153fvCG6+iPZ5n8+htghuw5ZSJ34k0hWX37SOBTKlAx2fcHF6eXa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758304716; c=relaxed/simple;
	bh=38Gs1Qar33XAo1Y7OS66uYvLqXMX9a7h0GZW0uT6IT8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qzz+3UY8N3pY+JdEkaobwvSQh3JDCajbutjLN5+FGU1n2Cl9mGBCZPALLnFRyAA68H8dOVpq2Y4VLnGDrfxLvFIaDPQsixSxC00nLaQhZI94/b7gnJSSI5lGKyeIHinkwvRHM5W1sFevpVe1ygavnZ7sU7fBaXg9aB3uwWJUqr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RAUgVkn6; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RAUgVkn6"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4b5f7fe502dso13598441cf.0
        for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 10:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758304713; x=1758909513; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tKiAXDkgrX2LUhD4TKk8v5QGpSKY+EpT1ETvTouA6rM=;
        b=RAUgVkn6+ALoQ7bm9NktTxKD4MtFhDkRZbPkjbKVNgh6f1b/Ti6L+dxlX8HBLxF6MQ
         eg6b1wm6zmGouG7khVZxVAzLFtdHpovQaAFnkm7obdnX9X7EDaJ9SVyR3wDhbVTFLcrb
         RlyXZdxpSaK46afYxtAZNbSeyjLrrlT+BK8I6cap9Vd6CF6LcY17Gc11c9+13dfiJK/V
         09IWOojy221xl3LgdPIj4cFcBoZZduF072lkLTEGCKwyx3nJHLdNJA9XWJyq4q1Ig7ER
         cTIPGvboG8zpy70+QqHkvnWDliEbF6BoJBYlYtUspPHcSYHEYIG1z+uZeWxkdzH9xnji
         YLOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758304713; x=1758909513;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tKiAXDkgrX2LUhD4TKk8v5QGpSKY+EpT1ETvTouA6rM=;
        b=PVi8qFJpA2Dhi8rvDuwqPo/t6dZAnFMXR1uMwhPihwIFTAY6lhPJHAZX1KPUnpzOVh
         3TynYwVZwvwFCAeAyOolZCukvHGZh3RM1RI7bprNF1N5ZUQgWXNfavmlKfbyVZps4/eu
         3dhvzoNc6ecBo3mDYtYbZLVLbwOs0/qpQ1vhyCIPD2fCtbwGhMKIHPVhWEDLQY1ZEe/a
         ucj8PaUeUAuHsmZc8Ef+Sj/JanTjia0IlsW6yNBvAKb3a5ZHn/DyFPxjfweQyT/2f9D7
         cRT5JgEqlKIWAA2oa7cCjW6IZ2DJs3EMld2rAVVQwxQtZh8ctmvpOGxzHa5f1xAsjeQn
         ndIg==
X-Forwarded-Encrypted: i=1; AJvYcCXpNuBhQlFhchEWkjb6AMIACGdN4bAoVXN0ANwTd6wil8dhF48DMwrw/vHDSwyqzhB2rwzuWtYwSQ0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAMJLtt9cWt59wYgcti8AqTSREIjkW2nIquiM7V5GoLCztJOD4
	mM/w4nnIjoSmGYYFkbLumV4wbYlHqmkDIeZ5q7AK7CktrUWvNgkFco0PiQdCmxrvTne+IIlQDo9
	Zrj2F3VQNSBzyCJPodZw+fucoKC4geRo=
X-Gm-Gg: ASbGncsMkzg54tjU/3rRYOJr3Shm03y57IIYIoAf31shjcDZDPgfB4ov6JVoTg3CRS4
	t9XmxbKZY+H28P9siJipGT5GXUh8m9ThmmuTtiyDXQS8WxX9bq7rR471gM1vhlWV0zOaBD3zGxo
	cMqjXBvxB/WRtVcIghavmvAsXR2+AHzb4cNMLq7mD5TNvlFNPATqp2TYxJ1Ldga0Lg75DtvGcxW
	mGfZlvln2sA1Ahf4aXK8RH/mDRbfVwnZZt1fRDN
X-Google-Smtp-Source: AGHT+IG5Mo3h/1ff88PwcUapAIlS2YVGSiLxAR3AL07FsknEHK18lG+gFQCk2zfPCcdMXf1hLVttPVUfviUqt89STrs=
X-Received: by 2002:ac8:7f4f:0:b0:4b5:fc2a:f37c with SMTP id
 d75a77b69052e-4c074b076d7mr48411081cf.74.1758304712602; Fri, 19 Sep 2025
 10:58:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250908185122.3199171-1-joannelkoong@gmail.com>
 <20250908185122.3199171-13-joannelkoong@gmail.com> <aMKzG3NUGsQijvEg@infradead.org>
 <CAJnrk1Z2JwUKKoaqExh2gPDxtjRbzSPxzHi3YdBWXKvygGuGFA@mail.gmail.com>
 <CAJnrk1YmxMbT-z9SLxrnrEwagLeyT=bDMzaONYAO6VgQyFHJOQ@mail.gmail.com> <aM1w77aJZrQPq8Hw@infradead.org>
In-Reply-To: <aM1w77aJZrQPq8Hw@infradead.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 19 Sep 2025 10:58:20 -0700
X-Gm-Features: AS18NWA4Ectn5ref1Zm-F0jRvHV38iLjidkioHaeJy9w2W9ibGS--sEYKpZ7E2Y
Message-ID: <CAJnrk1bKijv8cce+NdLV-bOvdU=HdZEb5M=pE5KhqCWX0dAOWA@mail.gmail.com>
Subject: Re: [PATCH v2 12/16] iomap: add bias for async read requests
To: Christoph Hellwig <hch@infradead.org>
Cc: brauner@kernel.org, miklos@szeredi.hu, djwong@kernel.org, 
	hsiangkao@linux.alibaba.com, linux-block@vger.kernel.org, 
	gfs2@lists.linux.dev, linux-fsdevel@vger.kernel.org, kernel-team@meta.com, 
	linux-xfs@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 19, 2025 at 8:04=E2=80=AFAM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> On Tue, Sep 16, 2025 at 12:14:05PM -0700, Joanne Koong wrote:
> > > I think you're right, this is probably clearer without trying to shar=
e
> > > the function.
> > >
> > > I think maybe we can make this even simpler. Right now we mark the
> > > bitmap uptodate every time a range is read in but I think instead we
> > > can just do one bitmap uptodate operation for the entire folio when
> > > the read has completely finished.  If we do this, then we can make
> > > "ifs->read_bytes_pending" back to an atomic_t since we don't save one
> > > atomic operation from doing it through a spinlock anymore (eg what
> > > commit f45b494e2a "iomap: protect read_bytes_pending with the
> > > state_lock" optimized). And then this bias thing can just become:
> > >
> > > if (ifs) {
> > >     if (atomic_dec_and_test(&ifs->read_bytes_pending))
> > >         folio_end_read(folio, !ret);
> > >     *cur_folio_owned =3D true;
> > > }
> > >
> >
> > This idea doesn't work unfortunately because reading in a range might f=
ail.
>
> As in the asynchronous read generats an error, but finishes faster
> than the submitting context calling the atomic_dec_and_test here?
>
> Yes, that is possible, although rare.  But having a way to pass
> that information on somehow.  PG_uptodate/folio uptodate would make

We could use the upper bit of read_bytes_pending to track if any error
occurred, but that still means if there's an error we'd miss marking
the ranges that were successfully read in as uptodate. But that's a
great point, maybe that's fine since that should not happen often
anyways.

> sense for that, but right now we expect folio_end_read to set that.
> And I fail to understand the logic folio_end_read - it should clear
> the locked bit and add the updatodate one, but I have no idea how
> it makes that happen.
>
I think that happens in the folio_xor_flags_has_waiters() ->
xor_unlock_is_negative_byte() call, which does an xor using the
PG_locked/PG_uptodate mask, but the naming of the function kind of
obfuscates that.
