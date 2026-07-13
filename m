Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FF1286AC
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2026 06:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783923646; cv=pass; b=I4mt+q+qqvyHw7XzWnnReegr83x1E5E5sKaUwynlKMtagCDustE3TGumd6ZgELuJYTO227Q2jeZW432pDTi3rtd3TZ+lReMISltlvN6qCrqD7lB5dX8b/n0n+PhLpm+FElHKmijPWoxpZRJhGmgGxuumr0RPQH2qoKmzOgm07kM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783923646; c=relaxed/simple;
	bh=Dl00t0sTPTTNIe1F1AeAkJ9tIHZdpr1d2BfLCfv4jN8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IVIfNrbkOPMGzhCkvtJ0YrhvaZsbPtAr4q7i9Df51ucVJrAY4Ere8qLleaz8Yj7X71UPTCdtlkIYJcbm9+a0yLFMJH7uLdj4ZHE56AKteXuz5a1Q5Jl+WQ6z8ckeGdmAMU35G6XakQxt4ozujN77BX3jJOhG9fn79kdFz35LYbI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BRDEILVX; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ITEAQ9bi; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BRDEILVX";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ITEAQ9bi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783923644;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gxA65uUxZAfMtKCg598lz1sPq4jlI3qphd55hf68xpU=;
	b=BRDEILVX5LIGDpUtk0lrsHd6uBNlHae+J/VN/vf9OjE7oxDHZpTss8yATZV7r/ftUpykqO
	8w9bqKJtKCC9eHrLTf3MEAKvcf9ZHUSrw41XHswpMC2QNjcbC4yKqNcCAQcfjCOVpfvxRI
	XLBKmnGuKxK3NRqVFR7svjUVZdJ+prM=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-OaLnP4oiOEigXUx1F5qIVg-1; Mon, 13 Jul 2026 02:20:42 -0400
X-MC-Unique: OaLnP4oiOEigXUx1F5qIVg-1
X-Mimecast-MFC-AGG-ID: OaLnP4oiOEigXUx1F5qIVg_1783923642
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-81cb01c07b2so44103937b3.1
        for <linux-xfs@vger.kernel.org>; Sun, 12 Jul 2026 23:20:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783923642; cv=none;
        d=google.com; s=arc-20260327;
        b=UQ+jleNbvmQw2pHio+8Nd/+lS3ve/xYHJcoprDG7zvdsG2bE0u/UbD9u0LXEb5b83z
         OUEu45j72Bv9qhcFtc4w9cp3AhHgfZHeBLs2RsjztA86y9uFXcsxhSMo4T6LTJYou/0u
         frkwlrUXL4y0mCbnioT/lxzIZQvVTM3eHB4OfVQqhee31OSkroa6sVRsSHyB1xUZpVJ3
         IHqrnBrADI5NKA1fyAxsZRs+rTwGIAMicl8tA4jTRn3O9+J/gyAejMYdNcN/AE3ED94c
         n/9dXOv8t0aa2M5+NMxS9uyu3K43wu6iuwDrNRBoahfQFPsU4K9nbuS7Eq2u7xkr7GCb
         I7Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gxA65uUxZAfMtKCg598lz1sPq4jlI3qphd55hf68xpU=;
        fh=PpET1O5T+QomJYVWxv1UZ+mM1A0yDKeakHlxBuk9Llk=;
        b=njDtgpm8qmfBqSW+E3UvFd4sU8cSYRKrIloZzQh9bli1quNso2GCgDR3z5hrKEpXoO
         EdTv+7iHK1zFqGwIhHd3W6d4A7NnuCg6pGUcKPHh3n4+cRxpwYL+IUoAon7lHfkwpUeY
         Y+lVPefr46QTYLSVUxZdf6pJ1cJOpEHUDTwnB8taSqZEts4qhSCo4dDsNA0kieNgWWlN
         gRAszOdBMoTA94aZ0a/FU8NzQA8LDRj6kSe5tXIlMziqwt/bajOz7TnqZVTs7X+9dvi5
         eYTWdUwGDurAs50n2jhUj8CUnDG0roaNY6jZ+CE30s+aef5PqM07gAneeqJKqHGIF+xw
         5lxw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1783923642; x=1784528442; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gxA65uUxZAfMtKCg598lz1sPq4jlI3qphd55hf68xpU=;
        b=ITEAQ9bifv4rOrQRAzt1wqLbYL1AONYLjVTnqr1kDNj0GQ8mCjCPUQc0+Hn1YT9NPw
         jiMgwOw70eFD7XRJw4RSRMcYoZNqshlI6IwSnQEIudywNOWha6dSlhjHHkkSSySkzVtb
         ZQLG7svA423bM1OfjqxgfyfwI/Kj2F++dli9/qpz7VnekstEBjqJWBkjjy5Ufdh0NSY4
         I//gftCOSeVK5D5W7cxK2kH+KufEJuOp3o4ROeakzU4fY3/+3MNG5eTN9T02rGVQBkkJ
         ZtIHYZfmFknM1KV5OfInC/26KZ+/IaaWByEPJSG6Q1LSxNOLhu6U+APMAu3uDlYO+o1Y
         PhYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783923642; x=1784528442;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gxA65uUxZAfMtKCg598lz1sPq4jlI3qphd55hf68xpU=;
        b=A2/B5lgb6k9U61juNVoQJtaHLajWThEWqdSp2CbqoT/TIlKjSjny825p9SWK9hwbRe
         GHwRzYc3INk+NdDeQ0Yg0MlswyB8O9L+ZL31WxvbKlNcYl2dcZ8pEnrY/tZYT9IvCw5W
         iBTHrCDZTFtMLl3LZVTpuNhwuUozlRm5uDQElvt039WOE0ErN6wpB8JEleuhm2k5modn
         do4lb/UixFFlxn8IvzgbP0iMonf1G7tfrCCKstFMSh8LJkP/0xfrsGr03+uoxKlRqFw5
         GO0DmQqi3VI6kJWq6MpYi3S85g2aTPEmOsNTiMRGz/xWxi5vcUvLqX27nad+24goQsIm
         4OqA==
X-Gm-Message-State: AOJu0YzzOaHRnIuTIIJhkhXgsIlDRu1GfO+rgfrbcCzCFt4V0zDlKwk2
	/hlOGGULR2YtfJKo3uLKItVbnTdNocUSK+UQUFkqrThsX737vb24wEmccutt2tCwmr0K4tXo3Xn
	KjuUqGWWdC6LxR8Hp13/Su7Xeku5Mk+5TXEc59QnwER7ll38D+zW7AhHrmWm+fqEdOonm8Wsniz
	8SgbfLomZb8Vsx7+4xVYae6xdFb8AILuGsf9IYMYxG64Ff
X-Gm-Gg: AfdE7cksjmdHUE9micRxvYYjLD8NgCSMtRFbUq3qJY8hZG54twpYRnt2zzP2SGtR6dm
	uIMW3z2l5zqH/zqZfhMgxUlOugy9968ZBKkSjif1txElukJ51izZrAj2X5Badew1WPb1UJwBqIO
	uYxxtHhTj6OqjdLJu7GXt2YoEoGbfwzXqJGffxzyJFGbUm9B9LAB4x1qVgvNN9jrWHLiHOKA==
X-Received: by 2002:a05:690e:1590:20b0:664:d162:6b79 with SMTP id 956f58d0204a3-667d7cec9abmr4391040d50.77.1783923642058;
        Sun, 12 Jul 2026 23:20:42 -0700 (PDT)
X-Received: by 2002:a05:690e:1590:20b0:664:d162:6b79 with SMTP id
 956f58d0204a3-667d7cec9abmr4391032d50.77.1783923641666; Sun, 12 Jul 2026
 23:20:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260709103915.275363-1-msinguru@redhat.com> <20260709143305.GC15210@frogsfrogsfrogs>
In-Reply-To: <20260709143305.GC15210@frogsfrogsfrogs>
From: Manognya Singuru <msinguru@redhat.com>
Date: Mon, 13 Jul 2026 11:50:29 +0530
X-Gm-Features: AVVi8CeBUtpOGkoHnTmQ4EqWUK_HTk5lN3KhHfwO4OYuE3Mw9UQQhV6RW2VxtHU
Message-ID: <CAOq9M7dSueX_sPzzVYsjVDHfKc_vR1_Z4M1P9ejsmKVWS60Bkg@mail.gmail.com>
Subject: Re: [PATCH] mdrestore: fix extent length overflow in v2 restore path
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, aalbersh@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 9, 2026 at 8:11=E2=80=AFPM Darrick J. Wong <djwong@kernel.org> =
wrote:
>
> On Thu, Jul 09, 2026 at 04:09:15PM +0530, Manognya Singuru wrote:
> > Aisle Research reported that a crafted metadump v2 extent
> > length can overflow the signed int used for length,
> > leading to incorrect size calculations and a
> > potential heap buffer over-read in restore_meta_extent().
> >
> > Change the length type to uint64_t and ensure all size
> > arithmetic in 64-bit before converting to size_t for I/O
> > calls.
> >
> > Signed-off-by: Manognya Singuru <msinguru@redhat.com>
> > ---
> >  mdrestore/xfs_mdrestore.c | 12 +++++-------
> >  1 file changed, 5 insertions(+), 7 deletions(-)
> >
> > diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> > index f10c4bef..9c7f77e0 100644
> > --- a/mdrestore/xfs_mdrestore.c
> > +++ b/mdrestore/xfs_mdrestore.c
> > @@ -395,11 +395,9 @@ restore_meta_extent(
> >       char            *device,
> >       void            *buf,
> >       uint64_t        offset,
> > -     int             len)
> > +     uint64_t                len)
>
> Please make the indentation consistent with the existing code here and
> elsewhere in the patch.
>

Sure, I have made the indentation consistent and sent PATCH v2.

> >  {
> > -     int             io_size;
> > -
> > -     io_size =3D min(len, MDR_IO_BUF_SIZE);
> > +     size_t io_size =3D min(len, MDR_IO_BUF_SIZE);
> >
> >       do {
> >               if (fread(buf, io_size, 1, md_fp) !=3D 1)
> > @@ -428,7 +426,7 @@ restore_v2(
> >       int64_t                 mb_read =3D 0;
> >       int64_t                 bytes_read;
> >       uint64_t                offset;
> > -     int                     len;
> > +     uint64_t                        len;
> >
> >       block_buffer =3D malloc(MDR_IO_BUF_SIZE);
> >       if (block_buffer =3D=3D NULL)
> > @@ -442,7 +440,7 @@ restore_v2(
> >                       XME_ADDR_DATA_DEVICE)
> >               fatal("Invalid superblock disk address/length\n");
> >
> > -     len =3D BBTOB(be32_to_cpu(xme.xme_len));
> > +     len =3D BBTOB((uint64_t)be32_to_cpu(xme.xme_len));
>
> /me wonders if BBTOB ought to cast its parameter to uint64_t but this
> change here avoids shift truncation if xme_len is large, so
>

Yes, my thinking was that casting to uint64_t would force BBTOB() to
perform the shift in 64-bit arithmetic and avoid shift truncation.


> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
>
> --D
>
> >
> >       if (fread(block_buffer, len, 1, md_fp) !=3D 1)
> >               fatal("error reading from metadump file\n");
> > @@ -503,7 +501,7 @@ restore_v2(
> >                       break;
> >               }
> >
> > -             len =3D BBTOB(be32_to_cpu(xme.xme_len));
> > +             len =3D BBTOB((uint64_t)be32_to_cpu(xme.xme_len));
> >
> >               restore_meta_extent(md_fp, fd, device, block_buffer, offs=
et,
> >                               len);
> > --
> > 2.54.0
> >
> >
>

