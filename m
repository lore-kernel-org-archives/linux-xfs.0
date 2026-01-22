Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7694D38F952
	for <linux-xfs@vger.kernel.org>; Thu, 22 Jan 2026 02:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769049869; cv=pass; b=s2eYLR1jT/axdiKozo9VHU8Bf7Lg/OSCBuxti6rnvzCSw5vC8J9m+hafYO7x7WijjiS/Iyu9iJ5n/2dovwPhyDCDg9P2SeMwb+l+0Q0+CWReCsdgDqzq2H43rWg4877+LSjshKtp8/3F+xUSb9Arj+Y3bYIxQknAnjbsQ+EYTB0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769049869; c=relaxed/simple;
	bh=UR97j5oS5KW66h4wusIQPc7uR0tPcNE6widZpyUVWkQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SgBgi/t/jKMvw5BE4f4gP8nkkuwBThfw4S+Yo0RUuo1bAeF5Utqmi8cK1lZrn6v3TCgCwfNMw4NtLaNFqVIE2scpU6bXhZpSmxl+y+K5Srdi/WzkhAaTBlsA7DLDv4IGHkYUn1xg6b0txTUxM2GOYTgGLUYKK04Cl33FqsaB1cc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H7Epsi75; arc=pass smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H7Epsi75"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-502a4e3e611so4400961cf.0
        for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 18:44:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769049863; cv=none;
        d=google.com; s=arc-20240605;
        b=CTVY98VBomv4wrJnqDRWR1jb2VNUZ7bXTnsOLTPSjrM69hlMkNU9ZEbTcwbURzmpzL
         m3k+8WmwS1QY7yB16AJQzfHUuRcw36SSm92A5VHW8+o+bCxw/7LlgT2+F1PqDObJdv/b
         AqWOPWXMqvjaIgw4i6eBI3X9r8E74mn1p2j942iL+tOGeV2vzC6QzhNO4PSKjvcVo9Xq
         QIbqGX+JFXTRQ+h/WXi7mB7Pe1EuTkhaUIFxZxaCoDDDb1/CANSGKarFchoy2rQpL7U1
         v6rTrHtrEIF6ga5zKBEbX+u6a1T+/wFUDnORRlNMxDkYrfvd43ESl/N7rDWELWRmUD3h
         RIOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eAtbLcPlbXwcqSlVRBCKJrrca7k4pIWb0vsbKliyQro=;
        fh=0hALDfTMsws2007qwUYvzXqqXA846jst+VWgd7BXuUA=;
        b=VcOa+9DHlvYcxSZOy1cO/TrJokW8MqeBOSFXRIg6u8ygLFD2+2PPeCJxA+u+91T3kL
         0pPoK/F6tETN/PsERzhEj8DaRlNvYRMpIInWuwpa7Ek/Jj2Vm+r0JPZ2oq2dIElo+qe8
         4aM/PD41S9LHWRQEnO9DRfIHMNcaRlWYIUip37EOkyCXESbJZuXBJ0z5qKOQP1YjRWA6
         NxPM4arfZGzaM3/5EKXUt5t/LqNY2BlBc+EyfPkmQMYxHWvuLc0sxDVugG5i09CUxkSe
         Dvb1/DTmOH6LXB2k3JLx26jIpCAMeVJlJztQ36cTxRaD8MrRziatTkebM9EDIkcMjeB+
         0s6Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769049863; x=1769654663; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eAtbLcPlbXwcqSlVRBCKJrrca7k4pIWb0vsbKliyQro=;
        b=H7Epsi75Rhhe3nOnSKPNhy+aGuyneoCLXvwxkcCaSBJWM3fnwt9ZpqEnBXNSH3kXj2
         bU1A8VXiG6VkfoILDNo91BUSR09z/F/UI1rc5npHSqteJkJBrad/i+1uHDsNPqoK9mqE
         jucFluvAejkTaGTolTPXa0MYtCjeIDisagMfuzYtjo3+/vTsxx45LiE9+H6jm/NMTmzo
         w8KFQecrL/Nr/RODNxytPumaA8QduwKH5oNWk3DJlylLw0uy4A6+Ontha4K+WTFb1T8x
         3PNx+C6kREeQSc1VMfvfA+EzHBUKWjScpb5f8lkIPx6uMF0d77H4JSVx7BHxLZWD7xxQ
         Ig6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769049863; x=1769654663;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eAtbLcPlbXwcqSlVRBCKJrrca7k4pIWb0vsbKliyQro=;
        b=NByYdddpV5PkxSJdlC2LYlsQmngE6aFYmd0GhI6cvZuT28CexnEk9qs0dQ4VduxOmV
         6WgW3AgObzHPEpJFKtN66Xb7yb7szR9AjuHQF/oZ9trnmzP/mTMF38NOvujy4PWdIbxW
         NXh6eoEAfGqJYCr6uQJ0DxB6LoHC8BdIjttOoN23mvXtDu1HYphfeFgKeKTiFkc74J6v
         snkPy30g1oX7fhoJ0oQsJ1j+gUSwLN4157jAyfSuMqOPbR0qQNUthrRWhAWwFSf1YzVy
         g5762ixRog4nvw0SYFeDJ2YZDjFwO2FlWjSWZbzusyzlKwKkRsYyv6kvcwRy4ZJUO6IT
         ko7A==
X-Forwarded-Encrypted: i=1; AJvYcCXvaHesiUrFmdrFxlgZMyNS72IWINSv3BunwapW2XUSsAbxzo30v0qDYupHMrolKRhRltD1/tqXc2g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz77Jc+iCanldngCOZmjBi40GPC3uc3XkrYdgLkrpjnryKstxaD
	ZteZqbdae351fkY+Jky521M86nf3ZM0q00anXyKHPdLUEpTGueparLNLCtnVAvqHMB9L7gZf69Z
	uB2/3jspZSg4BmIXs+D7blRroQsXoeoU=
X-Gm-Gg: AZuq6aI88TKKBVG+IckIQ32xvrbVw94Mi+d4oBqvdr7JgOvAMFDSwZE+LLRmmf19sYU
	q4jtJXVSuWguy54Xn1uRju1tzcL6+RYA73CiLqOHAIyaid7mZPHC/bYcCyydVFnSJrsMNYjK0gU
	qYEuibAbkm7rjHEXKGdzUPObg4HRciVx3RZnMFH/DdVImfsyRzbN8X6D7zv63UHCB38ASpdZ5ua
	30Ic84TXvhFHKD1wQsd8tBPZISB9A3BqFoTPsRQ/X0neRILtut5TojCW5TygqsEcal63Q==
X-Received: by 2002:ac8:7c43:0:b0:4ed:bc0a:88c3 with SMTP id
 d75a77b69052e-502eb5b14b5mr24575241cf.33.1769049863440; Wed, 21 Jan 2026
 18:44:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260121064339.206019-1-hch@lst.de> <20260121064339.206019-11-hch@lst.de>
 <20260122004451.GN5945@frogsfrogsfrogs>
In-Reply-To: <20260122004451.GN5945@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 21 Jan 2026 18:44:12 -0800
X-Gm-Features: AZwV_Qg4LxBvht9EBcr0hoT1-gc5FWfx00BC6aQnC2V2vC-gMfVpk6AU_v2RXiM
Message-ID: <CAJnrk1YAbcODi8pkG9XawciDpaHqdbZE+ucji73D_F=Jv1kQXg@mail.gmail.com>
Subject: Re: [PATCH 10/15] iomap: only call into ->submit_read when there is a read_ctx
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>, 
	Carlos Maiolino <cem@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 21, 2026 at 4:44=E2=80=AFPM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> On Wed, Jan 21, 2026 at 07:43:18AM +0100, Christoph Hellwig wrote:
> > Move the NULL check into the callers to simplify the callees.  Not sure
> > how fuse worked before, given that it was missing the NULL check.

In fuse, ctx->read_ctx is always valid. It gets initialized to point
to a local struct before it calls into
iomap_read_folio()/iomap_readahead()

>
> Let's cc Joanne to find out then...? [done]
>
> --D
>
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/iomap/bio.c         | 5 +----
> >  fs/iomap/buffered-io.c | 4 ++--
> >  2 files changed, 3 insertions(+), 6 deletions(-)
> >
> > diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
> > index cb60d1facb5a..80bbd328bd3c 100644
> > --- a/fs/iomap/bio.c
> > +++ b/fs/iomap/bio.c
> > @@ -21,10 +21,7 @@ static void iomap_read_end_io(struct bio *bio)
> >  static void iomap_bio_submit_read(const struct iomap_iter *iter,
> >               struct iomap_read_folio_ctx *ctx)
> >  {
> > -     struct bio *bio =3D ctx->read_ctx;
> > -
> > -     if (bio)
> > -             submit_bio(bio);
> > +     submit_bio(ctx->read_ctx);
> >  }
> >
> >  static void iomap_read_alloc_bio(const struct iomap_iter *iter,
> > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > index 4a15c6c153c4..6367f7f38f0c 100644
> > --- a/fs/iomap/buffered-io.c
> > +++ b/fs/iomap/buffered-io.c
> > @@ -572,7 +572,7 @@ void iomap_read_folio(const struct iomap_ops *ops,
> >               iter.status =3D iomap_read_folio_iter(&iter, ctx,
> >                               &bytes_submitted);
> >
> > -     if (ctx->ops->submit_read)
> > +     if (ctx->read_ctx && ctx->ops->submit_read)
> >               ctx->ops->submit_read(&iter, ctx);
> >
> >       iomap_read_end(folio, bytes_submitted);
> > @@ -636,7 +636,7 @@ void iomap_readahead(const struct iomap_ops *ops,
> >               iter.status =3D iomap_readahead_iter(&iter, ctx,
> >                                       &cur_bytes_submitted);
> >
> > -     if (ctx->ops->submit_read)
> > +     if (ctx->read_ctx && ctx->ops->submit_read)
> >               ctx->ops->submit_read(&iter, ctx);

I wonder if it makes sense to just have submit_read() take in the void
*read_ctx directly instead of it taking in the entire struct
iomap_read_folio_ctx. afaict, the other fields aren't used/necessary.

This patch as-is makes sense to me though.

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>

Thanks,
Joanne

> >
> >       if (ctx->cur_folio)
> > --
> > 2.47.3
> >
> >
