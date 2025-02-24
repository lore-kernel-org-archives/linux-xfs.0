Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01603261388
	for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 15:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740412266; cv=none; b=Mm+vI1bmYBtwqfqlAHUMV96L5WIqzKq2lBJX/FwFbsYPSvmj2jyTjNgZVVgFTKcJJLVmNjWzXTpBHdvq9pTFpnB6iBUoTqoRFSpaiTUZS2BvfaIm8Oj9bl/BgPKJcvGCJwyhGXTODrWpHfPH0G+p+jl1+o0QHFUhpzwsXJS4Fkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740412266; c=relaxed/simple;
	bh=urNcMCOkBjYvvIoGcK0YzOhzgaamAKhLhgVqydGZQaE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XchzdRdl3rPujqJjWZXSvabPN8F34/MPKYzD69Gzp/sPokOfo5s5jeFFNDNtX4Rg0koGZ8ovzaT6QJud6JYg7Bp6MMJRu5ts/2p8F/DrBj0EWsKnMoPRj4ydhuPNgNZSlH+KRRaFlGQ1uxq6wbq7NQsYrxSnc/UusFpzvTrLWH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=scylladb.com; spf=pass smtp.mailfrom=scylladb.com; dkim=pass (2048-bit key) header.d=scylladb.com header.i=@scylladb.com header.b=VkZScC5I; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=scylladb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scylladb.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=scylladb.com header.i=@scylladb.com header.b="VkZScC5I"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2211cd4463cso91206575ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 07:51:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb.com; s=google; t=1740412264; x=1741017064; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oVE5zIf7xhMQy/EVfU5iI/JQVcppTl6NRC/QrFSALCE=;
        b=VkZScC5IWVJVKLavnNA1FYU++DeOzmhtV3MApAyk2Bx5TJvvmq71HYzVShaixYtFP8
         hc9g4hO+JMp+eqR9qEDlCExqT5ZSQR6i7MKzUdOaXNjU2QgIsCJdrmJwySoQXUQKk+mG
         4rI28NBoBl95Q4nPH6ziK/y+FjYfD4Iy0ju16xIcB4y3gE0SjgYuQ0MEHGVICm5zzPKk
         jPoI2HQRrHtiEfvWzaObIsBX9qQwA9QFe4o1joZWPO8iy6ebDBHcR8XMgrammnfEXaWi
         Ba89cLXW1GDiGBAkJjRgnUrhsCvLF93yGBcvY304+g7HgpxHAssih9RIeR9q1zuSr4V0
         pxmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740412264; x=1741017064;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oVE5zIf7xhMQy/EVfU5iI/JQVcppTl6NRC/QrFSALCE=;
        b=NPL7m52St5HLrHqRVa0n+u8S05FW37IpRRqrE0haJ5bAFEQ0B/wl4f40w/IRjuFOXr
         /ZZbT05ggRKtnVQf27iDi3Mqs6WccYhI1aZzI4tZJrJt3uce3kvWu9Hl3qaX5JxKYzh8
         K+Hm6Pb86ic/nynngTCg/d8ZiSiGPgqc4ss+UxVJtJRe1uWwYkiFfFmbNXS0v5CYXdVM
         D3Lw0WuphoT2ruRdNu+ojzckfHQwiMxwmwdw9LImFhv4MFEUvKfxx7qIzSLWY3cvQHVe
         narolWAVmJGIlK1vYJKdcFy8HuELInBfx6w2uKqvtBeRK+IumqBYaqLptx/Tc1K1+wfr
         ixIg==
X-Forwarded-Encrypted: i=1; AJvYcCUDGt/MiNMA+DoctVnRtf5bNq2ykfgk5AEZ6JCAo8CPYdWDxoe0o1JHUb1DE4xR8AFZNH7yDB0rGpY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZ5BMTFcE01x4erb3nZyv6FgNKWPedE2Aye+dymYpTYf2EtYLP
	OMBsO74K6RgBmpCU7WmvcvOpw+ef+3r/wY87BSOF17IY5wP9mctvKVd4mqUpzfS5cH0+Ts5hjxQ
	BRcsCm0xNQJ3IJSBEt+0lb+PCoahhXfJeNXwtf03JHjk/ievzo6Su3KMOiNCGreWMJNN1EjCJ9c
	82hFYWtkaVXppnLDHTaGMYt+yUEEdErTKgiQGz2yCazYnbi2vlgksv1ZiNBhUgbX2NsGXIy3I4j
	RsJGYqaHTIlyhP2csWO6hX0lNx+B4ONz6jQOyntjyAoYl7UjiFZPnxBy0D5+BanrVRCx9h5IN7x
	MRsXnTOHVgYG1MArJb28RmG3dWoxNblIZPDiX3+SZBfdRLpaQesilIyk/JgRsGCnDk7ujQ+BTRK
	dl+VTPELl
X-Gm-Gg: ASbGncvEqZWyrFGLGN076ks55P0jetdHq3Sw6cCoVdIsDe6+HbHxxd2hjl0SbZuFCA+
	jLzh/E01fKiS7s6BUyrqK2ha9p6oaONRuvoutDaU9CrPiiK/mMlcEj2uADKjiJ/iX/H+mjYJFKo
	Yggr96w0QReVQFGUOgkZ16Lg==
X-Google-Smtp-Source: AGHT+IHsCvINcnxQOW+o8QVQCqF8jaKtkYNtzFqeavOaYusjaInUVxxswqCBiGDf3YmqmSw3z9D/HguiBZIpB3uQlwQ=
X-Received: by 2002:a17:90b:2252:b0:2ee:4513:f1d1 with SMTP id
 98e67ed59e1d1-2fce7b2caf9mr19601973a91.23.1740412264171; Mon, 24 Feb 2025
 07:51:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250224081328.18090-1-raphaelsc@scylladb.com>
 <20250224141744.GA1088@lst.de> <Z7yRSe-nkfMz4TS2@casper.infradead.org>
 <CAKhLTr1s9t5xThJ10N9Wgd_M0RLTiy5gecvd1W6gok3q1m4Fiw@mail.gmail.com> <Z7yVB0w7YoY_DrNz@casper.infradead.org>
In-Reply-To: <Z7yVB0w7YoY_DrNz@casper.infradead.org>
From: "Raphael S. Carvalho" <raphaelsc@scylladb.com>
Date: Mon, 24 Feb 2025 12:50:48 -0300
X-Gm-Features: AWEUYZmCaVei4AAfqe3vnNodRbnQHoRP0SLFpgUKuQd_na8KPtvHoJlGT8fEx1Y
Message-ID: <CAKhLTr26AEbwyTrTgw0GF4_FSxfKC2rdJ79vsAwqwrWG8bakwg@mail.gmail.com>
Subject: Re: [PATCH v2] mm: Fix error handling in __filemap_get_folio() with FGP_NOWAIT
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, djwong@kernel.org, 
	Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-CLOUD-SEC-AV-Sent: true
X-CLOUD-SEC-AV-Info: scylladb,google_mail,monitor
X-Gm-Spam: 0
X-Gm-Phishy: 0
X-CLOUD-SEC-AV-Sent: true
X-CLOUD-SEC-AV-Info: scylla,google_mail,monitor
X-Gm-Spam: 0
X-Gm-Phishy: 0

On Mon, Feb 24, 2025 at 12:49=E2=80=AFPM Matthew Wilcox <willy@infradead.or=
g> wrote:
>
> On Mon, Feb 24, 2025 at 12:45:21PM -0300, Raphael S. Carvalho wrote:
> > On Mon, Feb 24, 2025 at 12:33=E2=80=AFPM Matthew Wilcox <willy@infradea=
d.org> wrote:
> > >
> > > On Mon, Feb 24, 2025 at 03:17:44PM +0100, Christoph Hellwig wrote:
> > > > On Mon, Feb 24, 2025 at 05:13:28AM -0300, Raphael S. Carvalho wrote=
:
> > > > > +           if (err) {
> > > > > +                   /* Prevents -ENOMEM from escaping to user spa=
ce with FGP_NOWAIT */
> > > > > +                   if ((fgp_flags & FGP_NOWAIT) && err =3D=3D -E=
NOMEM)
> > > > > +                           err =3D -EAGAIN;
> > > > >                     return ERR_PTR(err);
> > > >
> > > > I don't think the comment is all that useful.  It's also overly lon=
g.
> > > >
> > > > I'd suggest this instead:
> > > >
> > > >                       /*
> > > >                        * When NOWAIT I/O fails to allocate folios t=
his could
> > > >                        * be due to a nonblocking memory allocation =
and not
> > > >                        * because the system actually is out of memo=
ry.
> > > >                        * Return -EAGAIN so that there caller retrie=
s in a
> > > >                        * blocking fashion instead of propagating -E=
NOMEM
> > > >                        * to the application.
> > > >                        */
> > >
> > > I don't think it needs a comment at all, but the memory allocation
> > > might be for something other than folios, so your suggested comment
> > > is misleading.
> >
> > Isn't it all in the context of allocating or adding folio? The reason
> > behind a comment is to prevent movements in the future that could
> > cause a similar regression, and also to inform the poor reader that
> > might be left wondering why we're converting -ENOMEM into -EAGAIN with
> > FGP_NOWAIT. Can it be slightly adjusted to make it more correct? Or
> > you really think it's better to remove it completely?
>
> I really don't think the comment is needed.  This is a common mistake
> when fixing a bug.

Ok, so I will proceed with v4 now, removing the comment.
