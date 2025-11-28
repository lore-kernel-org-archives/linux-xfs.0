Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598292D0618
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 06:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764311243; cv=none; b=N4M4dLIsPULmaNGbhOLX3sMx4QIUcijImfwb4YvVl1Oh9OV9qgS30NdApRV+x0dd/tJqVBnROY243QPocoKot9tEAerjuAycI/IVOHd3ZHq3VE8hIgXAuPZcEIJFEqWMP6Bm+lqCw+W5P0Z0oV6r8hVGWKripmiiP9X1fWGcy7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764311243; c=relaxed/simple;
	bh=uxXx2Dt9ovr7xEDXTx3MLSG145z2GZi2DJ1y87yMKcg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E4pscwVoe6gtsGl5C98lN3nwrzdXBcaa9F5+dhdinppwcnJBgmcRKHykE0pQUviIjsBYQLVmASe8UlqkyJJK1N5wnI8igy4AkvLnycwctrcusC9neaxDBEFHkJfIauSd47/dD6arpVTcwbI/0Dy6RTR5yd9BbeFImH2J9l0LglY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CqktlKtM; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CqktlKtM"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4eda6a8cc12so14436691cf.0
        for <linux-xfs@vger.kernel.org>; Thu, 27 Nov 2025 22:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764311240; x=1764916040; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rNBX+tdFCi976CT3NTPOtFudKzRzrB7upXknWDTBPfs=;
        b=CqktlKtMSvE5zV2ceALEbGv09s3lETxK9XNUOFgNInCKfzq2OsZjQe8yvn04Ne5TLT
         0318phA8KNpGb205+xtT7wB3JlPdf22NPutwA4lIwsdwLOt3UR6BdxC2GrZ8qP2tUfN5
         Y7evJCkbsp+8MnyNg1rSIc6AUeKpkc4GnT2XAu5sPOBSl0TVjhrHM+tFCCHTEKKXzypn
         h/Ql/Eq71VNre09PDoSW6vGc9F13C38NwBtdgL+Vfeu9/ijLMVk4gvY9ANe/V1C64Zmy
         YcrtayvbYVZE3wOBBo5JZ7vmFfUzUTwYeMc6AsZv9IVbAhSkZHJesp5GJPvwSiCm+na5
         aWrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764311240; x=1764916040;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rNBX+tdFCi976CT3NTPOtFudKzRzrB7upXknWDTBPfs=;
        b=fRjreoqpjors+Yqin5B0ddd1oBhE4Q3L2XwdePHhAYjPunfp+OPdhIqJyu+HpNECqv
         rhxbraFgz0FZGQ8FBQef/OwLWK5WbZWeQn8Spa4Qkmk/EsovMQAfLxyz/RPCgQlxIudh
         ZmC2frnnTg61yyLhdD0ixtJHsH8wEq02LJwDdmY8DNsthVeNF42ggzUsy9n4iYBsYBIa
         UV7VcwFTosjdiCK7QWJWJWQGtGDQGTDqTyLHEyRHDSwwJ6O2Sd6+C121K6T01fQk9Cvd
         +qew+9N8CSRJse6Og8JmRycUAnpzroyg/jH6cOpp+ewEAuTWvUh3uVt6AGoqBOrv31nH
         GZSQ==
X-Forwarded-Encrypted: i=1; AJvYcCVg8OaBFpW3CNvTQBl6DgUZLej8J2HshWMK8coSm0NtY6cjR5GjM4cdppnjgrlK15ZzSQkXAWjAdgc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKjSGbjNwyMVTgFW61GG/53rrsuGuhn9uFI7X6azXr6RVMapQw
	/C9zh7SpGuQmtEY2I0nutt+U9idgqg2IE1gyOZsGeY3B2KnfRV7MkJgf+Eev6aYUA2DOZD1Cxdp
	hQk1hWm8Yj95GzoivH5c3hVJO+YeSauA=
X-Gm-Gg: ASbGncthBBzj5mV5iX1SwzGabqNfPJ4dv0cpC3c0/iV/jOX7s2S3bNz8+2L6K1sH+av
	bAVFuO4K0lIdqs39BwLmkYbpccR30NGwyQPhVG36rymT3Uzw99n5ggdN7JbcoHeSH1mcVnB9QEB
	Zis2kTSvjKHFcVDEJcWAf2pTLY7HUJwN0dFxc3uR+y12Tt3ElcPYPTY77j+P92qE/sHkp3gIOab
	GEygT7UGjR3LMvEWc8uDdVnZnKv88WvM4hw5etAGCTGVpvGbG4amDSZiXS2qF93fp9Y0LY=
X-Google-Smtp-Source: AGHT+IHqoxxME/wZYacFTCZmpyvjYqen8b7+sN/d+VbUoZE5rC4JPn9P+8N4Y6c+biawDbsHSmqE9yp/CsWDMeNGoss=
X-Received: by 2002:a05:622a:3d4:b0:4ed:43ae:85f6 with SMTP id
 d75a77b69052e-4ee58911262mr343758661cf.47.1764311240290; Thu, 27 Nov 2025
 22:27:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251121081748.1443507-1-zhangshida@kylinos.cn>
 <20251121081748.1443507-2-zhangshida@kylinos.cn> <aSA_dTktkC85K39o@infradead.org>
 <CAHc6FU7NpnmbOGZB8Z7VwOBoZLm8jZkcAk_2yPANy9=DYS67-A@mail.gmail.com>
 <CANubcdXzxPuh9wweeW0yjprsQRZuBWmJwnEBcihqtvk6n7b=bQ@mail.gmail.com> <aSk5QFHzCwz97Xqw@infradead.org>
In-Reply-To: <aSk5QFHzCwz97Xqw@infradead.org>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Fri, 28 Nov 2025 14:26:44 +0800
X-Gm-Features: AWmQ_blfmVuM70WOWxBT6SLO-nBFz1VQq0RiOHlp-O6KawgJbGDwoH1nduOeubA
Message-ID: <CANubcdVTwitvE8ZP2BRtW28u8ZYBvdobxxXQgDSRWP_FbS1Wmg@mail.gmail.com>
Subject: Re: [PATCH 1/9] block: fix data loss and stale date exposure problems
 during append write
To: Christoph Hellwig <hch@infradead.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, nvdimm@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, 
	gfs2@lists.linux.dev, ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org, 
	zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Christoph Hellwig <hch@infradead.org> =E4=BA=8E2025=E5=B9=B411=E6=9C=8828=
=E6=97=A5=E5=91=A8=E4=BA=94 13:55=E5=86=99=E9=81=93=EF=BC=9A
>
> On Fri, Nov 28, 2025 at 11:22:49AM +0800, Stephen Zhang wrote:
> > Therefore, we could potentially change it to::
> >
> >         if (bio->bi_status && !READ_ONCE(parent->bi_status))
> >                 parent->bi_status =3D bio->bi_status;
> >
> > But as you mentioned, the check might not be critical here. So ultimate=
ly,
> > we can simplify it to:
> >
> >         if (bio->bi_status)
> >                 parent->bi_status =3D bio->bi_status;
>
> It might make sense to just use cmpxchg.  See btrfs_bio_end_io as an
> example (although it is operating on the btrfs_bio structure)
>

Thanks for the suggestion! I learned something new today.

Thanks,
Shida
