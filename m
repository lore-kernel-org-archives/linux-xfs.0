Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333A2299943
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 03:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764300210; cv=none; b=t00UP+526VHTRhYRcXor5F9fIozyBPSTl9NPkw+uU1uOo2RLu15pAk4bVYtkZaHIc0sT8yF6MgyMKKsU/NLH6r6iUeG/Ihs95LTDoiauC9qoRKPSNToew2yk7BqBFCnrcofySAkl/sUwSqI3h5BSPcp3xLn1bs4FGvhjcaW4qDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764300210; c=relaxed/simple;
	bh=PNeIkz45DuQRho1DwPL9oWfBnWeiTTntIhb6ZT/FME0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AHVBOwIGpk41MeO/SCsllx0IfPCG5PrWRgfgdQSDeIQPyPnpOXI9na16iWDwzAsYHDCYXCZ70bP9Tep01fhiqSzbnAYDmNQrLcJbDIqCIRdHaArkT89v2cn2djEBFZ1O6jKKtJKJjUTZ/LKG+xCts53BSuZy+cCw0U2OyI5dslM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DpkHGpND; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DpkHGpND"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4ee257e56aaso14221141cf.0
        for <linux-xfs@vger.kernel.org>; Thu, 27 Nov 2025 19:23:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764300206; x=1764905006; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QO8NwmkkI9mg0Fvr/iDdQ4VLLlyo+WunqlauIGsbobw=;
        b=DpkHGpNDLc5Cfb6GsZh+AOYXR5iDvq0Bmv4bpABu5/JSlFvWeYcy+ihgZJNNUzWSM2
         9DNANOUsk973b8Zz+hxcTJ5ytr55twdA7136oTSQo5j9FANDOFY/wzDlZBdrG21oC4+d
         dNnf+6V52a/WJAtLsCboxsWZTJIN76Pabe6cT+Pcf2DZL6ofF9PuQNUAAFEPztRiYFu3
         zzCjiFrhvmno/k+16oryW97z0lTIJZ0GLgoRb4HQtgVdC9yqPkmr0s5atJsBkFMn/24n
         FMDnAs96T4ZJ0zq2VRDBnpSUrreSE6NHG20y5D1/ox+Fe8sRf2mlX+GV8ycGv9y7c7Gy
         Tliw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764300206; x=1764905006;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QO8NwmkkI9mg0Fvr/iDdQ4VLLlyo+WunqlauIGsbobw=;
        b=tuNCGlfohyN+eVanmRln4psVpV4iVXd8i4ELCPZ2s7s3UZH7QX8Ykaqte+3se5SAtw
         NH6iWVoN1uv2bT+ATVcGY+mo73jm+06klsHyKQVosifPs8kiGd6HF2sss2TtSklz3dpp
         00wLvbJZxTZP82iccBfPLJFDP1UWEQRiJTCUsq7/NH5iVPRi4aqyS7MCKLHSHG0oNeNg
         fWgQbqcPyfT7ez4ojmIfL6BJxBSD315ulOKdmcga0mLQVwSoQOva6bcWAsFfT7qrlo6j
         60YtmpylH1b2S+xngzoQs+haCPUTTUqpJ79SfDuvGWTerO40/u3w5ll2dn+vsZCTkX9x
         raYA==
X-Forwarded-Encrypted: i=1; AJvYcCXA0iwngjACfDaWdY1J6CUya50/+A47VqW6EiF0XDsz+erdOkALT0QRjrvaMWx9eg0O+9G50jyx8u4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLOvVTKb7mRcw0emCUvCI1hkgQiHjxtVAnfWKAx3rmMxcBVryV
	pm/jIvwQkDBuOnhDbgPYqcMo9Ma/Gok171Kz8ABWDJkitjqbCFpyTDvX7fGMpnwo0gFswiWRXVm
	hHCyYhKZ8gyswMN/fZYVcro2JHk2B0CI8+C4llgM=
X-Gm-Gg: ASbGncsxfTBWh9alv7THqo1se2nZPMzRDjOj6HClSZmnRk496avGUb8ShD/TnJot5vV
	Q9JWkkSKQsGDDxFQVpMEIgih3zyUOEXffWQHxQQ40GuKsdF0lankXpqTUGm0Tf1oMM22ky4irQJ
	Kjt3fupIcVxqSJa3rvPA3RffyVOxPmZ6U9Zmx8As5udgZRD1GZwBqagqxC1JCnwppI6ipCpu6i6
	YGSxe5C816tVk3iZib3qPEz0Z37+o6hrQshPUTFuckU7R1MiPEw0hpoCXosW3nAISc4Nvo=
X-Google-Smtp-Source: AGHT+IG9mqJdVZgQj3BVyXnihjqxo6smpev5tsviBeKxWgS8ADskcY34A+TMMILps/HKlL0xyNYCt0kJ8fD8XQas0U8=
X-Received: by 2002:ac8:5e4c:0:b0:4ed:a6b0:5c14 with SMTP id
 d75a77b69052e-4ee4b54fd07mr426909921cf.23.1764300205954; Thu, 27 Nov 2025
 19:23:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251121081748.1443507-1-zhangshida@kylinos.cn>
 <20251121081748.1443507-2-zhangshida@kylinos.cn> <aSA_dTktkC85K39o@infradead.org>
 <CAHc6FU7NpnmbOGZB8Z7VwOBoZLm8jZkcAk_2yPANy9=DYS67-A@mail.gmail.com>
In-Reply-To: <CAHc6FU7NpnmbOGZB8Z7VwOBoZLm8jZkcAk_2yPANy9=DYS67-A@mail.gmail.com>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Fri, 28 Nov 2025 11:22:49 +0800
X-Gm-Features: AWmQ_blj83ISfyC32dpt8HHM0xujFYlidvaYOqxvcTwKucopW11tVoED-TPviuI
Message-ID: <CANubcdXzxPuh9wweeW0yjprsQRZuBWmJwnEBcihqtvk6n7b=bQ@mail.gmail.com>
Subject: Re: [PATCH 1/9] block: fix data loss and stale date exposure problems
 during append write
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, nvdimm@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, 
	gfs2@lists.linux.dev, ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org, 
	zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Andreas Gruenbacher <agruenba@redhat.com> =E4=BA=8E2025=E5=B9=B411=E6=9C=88=
22=E6=97=A5=E5=91=A8=E5=85=AD 00:13=E5=86=99=E9=81=93=EF=BC=9A
>
> On Fri, Nov 21, 2025 at 11:38=E2=80=AFAM Christoph Hellwig <hch@infradead=
.org> wrote:
> > On Fri, Nov 21, 2025 at 04:17:40PM +0800, zhangshida wrote:
> > > From: Shida Zhang <zhangshida@kylinos.cn>
> > >
> > > Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> > > ---
> > >  block/bio.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/block/bio.c b/block/bio.c
> > > index b3a79285c27..55c2c1a0020 100644
> > > --- a/block/bio.c
> > > +++ b/block/bio.c
> > > @@ -322,7 +322,7 @@ static struct bio *__bio_chain_endio(struct bio *=
bio)
> > >
> > >  static void bio_chain_endio(struct bio *bio)
> > >  {
> > > -     bio_endio(__bio_chain_endio(bio));
> > > +     bio_endio(bio);
> >
> > I don't see how this can work.  bio_chain_endio is called literally
> > as the result of calling bio_endio, so you recurse into that.
>
> Hmm, I don't actually see where: bio_endio() only calls
> __bio_chain_endio(), which is fine.
>
> Once bio_chain_endio() only calls bio_endio(), it can probably be
> removed in a follow-up patch.
>
> Also, loosely related, what I find slightly odd is this code in
> __bio_chain_endio():
>
>         if (bio->bi_status && !parent->bi_status)
>                 parent->bi_status =3D bio->bi_status;
>
> I don't think it really matters whether or not parent->bi_status is
> already set here?
>
> Also, multiple completions can race setting bi_status, so shouldn't we
> at least have a WRITE_ONCE() here and in the other places that set
> bi_status?
>

I'm considering whether we need to add a WRITE_ONCE() in version 2
 of this series.

From my understanding, WRITE_ONCE() prevents write merging and
tearing by ensuring the write operation is performed as a single, atomic
access. For instance, it stops the compiler from splitting a 32-bit write
into multiple 8-bit writes that could be interleaved with reads from other
CPUs.

However, since we're dealing with a single-byte (u8/blk_status_t) write,
it's naturally atomic at the hardware level. The CPU won't tear a byte-size=
d
write into separate bit-level operations.

Therefore, we could potentially change it to::

        if (bio->bi_status && !READ_ONCE(parent->bi_status))
                parent->bi_status =3D bio->bi_status;

But as you mentioned, the check might not be critical here. So ultimately,
we can simplify it to:

        if (bio->bi_status)
                parent->bi_status =3D bio->bi_status;

Thanks,
shida

> Thanks,
> Andreas
>
