Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBD51BF2A;
	Wed, 22 May 2024 21:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716414931; cv=none; b=ngJP7KnET87RK7OsA+Tg7Y5dHx2QbOUfGHr3ya14TnbXnCeA+9YWjWk32iLXQ/z5ePMudtjgvd8GOxsUmqQi8Dx8xhM+zYwLbAcx1YWVk/O2Wxs3y2o957/dd4SIC9LZpZW0GR304BnJjFkZF2SLvwMQdIl6qxiuwDaaJNSFFqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716414931; c=relaxed/simple;
	bh=biS27k1v25ESh7nlKLwuhk7msK7Vxc95usSBLqpbkVc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GzYwNmIxTXq5Lbrg7n9wKSdgdlX90sZY+sXY8wFehxdNv7141LZJlyKehigex44X16q3SHCzeiCYJZSxitjDYGgNb+nIl3y5dIzkFpcP8hLHO142rZZwfEIf6etJPKE04dslapgQ6We7CzaLiD3xiqtoSqRO6Lm52pPPUX6eaFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a1KU88kl; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a1KU88kl"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-61bee45d035so58022497b3.1;
        Wed, 22 May 2024 14:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716414929; x=1717019729; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qvHEXtI8w2mJSWFFWNE5WHl/b53q+5tj9SqX8JL+kf4=;
        b=a1KU88kl931GNsUx/9+xrsjMdPIjTbRXGi1lcWsm83BFCh/Xtr/ij7XUMf0jchnpBi
         njgV3WGHMYmZkFcVl9kIXjVoXQqH6TnzfKYIxDeaIGXUx+3KMwhfl/76NxbWtdzatuLm
         YFprP47WSLMBKpasKdU6n/TkKAfD4Lsm2hZcOWfQ33HUA6XuecllOkCJm+BkknfPo8cK
         IF4wdY6eKhtiS4FqmK56C4VfJV2JDgNGn4ExJac0zyo0JcO/yrYPBoJuhNVdRk5cELtA
         2w1bfQLJFOUwBOGPKLknj+XYRq9EheXfT1B35Ehy8HjZ8rXLStufv9RpT1BUS3O4szdt
         +4lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716414929; x=1717019729;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qvHEXtI8w2mJSWFFWNE5WHl/b53q+5tj9SqX8JL+kf4=;
        b=lXaEKOnxCD8STpTDYAjktIAH4JBpixt2sF01JFGsd4imR4l7tyqIHopr5tACMCZR7K
         78aoLMwXGzLT3MRSBKYNWyEzM9hJ3QMfsVLVO2X+Gy5jkeh5D8iU8zltxaoaG9ZCpO36
         2k/x/B232p81dKdXJAuVu+czIO3tVQLUrvztdWAyjZmZMpbe2yHpnmuoJJ4xu9/MRAmA
         47KdaWE90oaqcvBR2ZTL05J/SW7DJDQFVJFBa5Iis8wUhsL7UvrcXNcFQNQ+mqc/yhi9
         p1Vx426c1zFQZ00FJRQ7PcxODFTNBJfvw3oOOAvY3lENbnFsx2tiEXf+iJFu742xBk1D
         x2xA==
X-Forwarded-Encrypted: i=1; AJvYcCXkX6vbM4Fz+1jKvE3+1xWtOP0gp4An2TZz9RiSWpoE4j0M3JN2ZBMWOllvpJRjqzC9hUyPNIi8HE+Gh0BInuS/QEUJLiV/FXVPxYA8e4KOBCpk3WP0Tqw8IsrqtADEEqBz
X-Gm-Message-State: AOJu0YzvlJt+J+t5nZKf82AlV2iT0Nx3ZTbdwNRmWSiC6+g0RX2rEZ0w
	LPfFi5+nPX+NSO9RlxdFD7Ni+YS2oXDW999CC44IT7tFhY7vWXzMMCY7CIJQ2iO7f8wPSNViNYl
	z5PVSnvTUTjy8GlvervZaqfhTmuS3qx5S
X-Google-Smtp-Source: AGHT+IEiscBx1uu8+wmYNfvzZIUfh6mAICeSHfdeOAIEqxaswj3+oWoFbGbHAqF/rUOMe4pVWdLmMPfbWXqU80+VKfQ=
X-Received: by 2002:a0d:ddc6:0:b0:61d:fcf7:3377 with SMTP id
 00721157ae682-627e48809fbmr34428347b3.44.1716414928946; Wed, 22 May 2024
 14:55:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240501184112.3799035-1-leah.rumancik@gmail.com>
 <2024050436-conceded-idealness-d2c5@gregkh> <CAOQ4uxhcFSPhnAfDxm-GQ8i-NmDonzLAq5npMh84EZxxr=qhjQ@mail.gmail.com>
 <CACzhbgSNe5amnMPEz8AYu3Z=qZRyKLFDvOtA_9wFGW9Bh-jg+g@mail.gmail.com> <2024052207-curve-revered-b879@gregkh>
In-Reply-To: <2024052207-curve-revered-b879@gregkh>
From: Leah Rumancik <leah.rumancik@gmail.com>
Date: Wed, 22 May 2024 14:55:18 -0700
Message-ID: <CACzhbgQzrmKHX-VAzt8VKsxRT8YZN1nVdnd5Tq4bc4THtp5Lxg@mail.gmail.com>
Subject: Re: [PATCH 6.1 01/24] xfs: write page faults in iomap are not
 buffered writes
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Amir Goldstein <amir73il@gmail.com>, stable@vger.kernel.org, linux-xfs@vger.kernel.org, 
	chandan.babu@oracle.com, fred@cloudflare.com, 
	Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, "Darrick J . Wong" <djwong@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 22, 2024 at 7:11=E2=80=AFAM Greg KH <gregkh@linuxfoundation.org=
> wrote:
>
> On Mon, May 06, 2024 at 10:52:16AM -0700, Leah Rumancik wrote:
> > Ah my bad, I'll make sure to explicitly mention its been ACK'd by
> > linux-xfs in the future.
> >
> > Will send out a MAINTAINERS file patch as well.
>
> Did that happen?

Yep, https://lore.kernel.org/all/Zj9xj1wIzlTK8VCm@sashalap/

>
> Anyway, this patch series breaks the build:
>
> s/xfs/xfs_iomap.c: In function =E2=80=98xfs_iomap_inode_sequence=E2=80=99=
:
> fs/xfs/xfs_iomap.c:58:27: error: =E2=80=98IOMAP_F_XATTR=E2=80=99 undeclar=
ed (first use in this function); did you mean =E2=80=98IOP_XATTR=E2=80=99?
>    58 |         if (iomap_flags & IOMAP_F_XATTR)
>       |                           ^~~~~~~~~~~~~
>       |                           IOP_XATTR
> fs/xfs/xfs_iomap.c:58:27: note: each undeclared identifier is reported on=
ly once for each function it appears in
> fs/xfs/xfs_iomap.c: In function =E2=80=98xfs_iomap_valid=E2=80=99:
> fs/xfs/xfs_iomap.c:74:21: error: =E2=80=98const struct iomap=E2=80=99 has=
 no member named =E2=80=98validity_cookie=E2=80=99
>    74 |         return iomap->validity_cookie =3D=3D
>       |                     ^~
> fs/xfs/xfs_iomap.c: At top level:
> fs/xfs/xfs_iomap.c:79:10: error: =E2=80=98const struct iomap_page_ops=E2=
=80=99 has no member named =E2=80=98iomap_valid=E2=80=99
>    79 |         .iomap_valid            =3D xfs_iomap_valid,
>       |          ^~~~~~~~~~~
> fs/xfs/xfs_iomap.c:79:35: error: positional initialization of field in =
=E2=80=98struct=E2=80=99 declared with =E2=80=98designated_init=E2=80=99 at=
tribute [-Werror=3Ddesignated-init]
>    79 |         .iomap_valid            =3D xfs_iomap_valid,
>       |                                   ^~~~~~~~~~~~~~~
> fs/xfs/xfs_iomap.c:79:35: note: (near initialization for =E2=80=98xfs_iom=
ap_page_ops=E2=80=99)
> fs/xfs/xfs_iomap.c:79:35: error: invalid initializer
> fs/xfs/xfs_iomap.c:79:35: note: (near initialization for =E2=80=98xfs_iom=
ap_page_ops.<anonymous>=E2=80=99)
> fs/xfs/xfs_iomap.c: In function =E2=80=98xfs_bmbt_to_iomap=E2=80=99:
> fs/xfs/xfs_iomap.c:127:14: error: =E2=80=98struct iomap=E2=80=99 has no m=
ember named =E2=80=98validity_cookie=E2=80=99
>   127 |         iomap->validity_cookie =3D sequence_cookie;
>       |              ^~
> fs/xfs/xfs_iomap.c: In function =E2=80=98xfs_xattr_iomap_begin=E2=80=99:
> fs/xfs/xfs_iomap.c:1375:44: error: =E2=80=98IOMAP_F_XATTR=E2=80=99 undecl=
ared (first use in this function); did you mean =E2=80=98IOP_XATTR=E2=80=99=
?
>  1375 |         seq =3D xfs_iomap_inode_sequence(ip, IOMAP_F_XATTR);
>       |                                            ^~~~~~~~~~~~~
>       |                                            IOP_XATTR
> fs/xfs/xfs_iomap.c:1382:1: error: control reaches end of non-void functio=
n [-Werror=3Dreturn-type]
>  1382 | }
>       | ^
> cc1: all warnings being treated as errors
>
>
> Any chance you can rebase and resend it?
>

Will do.

Thanks,
Leah

> thanks,
>
> greg k-h
