Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3643714B950
	for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 21:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744838480; cv=none; b=tlw+MKCIL0jvOwXkRORI20y0bB0u689swjrEUNULWVlE38cpz3m9InYLZ9TAFdwzhUU371r6ujyzMvKmrZgTWL3pBx5yrB8sxTTzjVuoaEeA/h6w6idI/ix1XsFUHAGN3lRptYC68QTQkcroYGDXVuWbF5rynmw9G0iVn4A+pPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744838480; c=relaxed/simple;
	bh=wnqXWFVUTz7LPLKgjDUBUm5XXujso1/HoGCuWGV7f10=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Bmqcx4xUP5CCpNaCcuQ9r/SKLDCDyKEOAVxZdbsSS1C8J2Cryu7VQKuORVoM8kKJCjgb6umNDmnZgRtBFfivLT1Vyuyzyzff89DOw5C+E8CNDI+AVlJ14B4YcyRzkMMKyRWVU/tkS/MGoSZ70YnT7FzYp1Jrj8vjNX0ianbgVzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AYX+KngI; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AYX+KngI"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-abbb12bea54so14266466b.0
        for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 14:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744838474; x=1745443274; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KDXx1oZ+/eOX9TmJk7VjuHM/Bh9Oll7bQAZaVjh4crk=;
        b=AYX+KngITs6vGArDxnr8b+C53udGGRjIs+8EjaguoEHLSxOGdrKx8fm9QzkWvKtB9/
         7bEZayzybfdzHtLtecnPJ8T5NzOG1GoOgEVVQHsbdMPuS3rdH0IWS6wIs67+efjf5vee
         hlAdfbgWZ3GeD/6l83IFvoZcxNERt/cqZub+NDFDuq4ilOC/VomMDtNwKtSPHmvYsJ8l
         qiCYTYzPWM1yukVsnu+hQVBjmh5ALoA4piy8GdGUYybdym6pa7FBzvQzp1tA2jCsLfQ4
         ZKBJo8ow72aopfTTyANyN7nrAFl2g1RJRJn/ULyYjkJy57c3VV5c3mV21Yh8mHBd5Hj4
         A3nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744838474; x=1745443274;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KDXx1oZ+/eOX9TmJk7VjuHM/Bh9Oll7bQAZaVjh4crk=;
        b=rwGrWuJU5n0/YITYmUO1IwNZL2xHpZZUOuB/Techzs/OXWiBbsTzukMA7B5mJX+YdG
         29+NTTrWMwYfnINqYllSzBHlTLDkI/lCnzvlKiUGI42f6mHGBhKOkCyx/s+V3vV2RhVV
         nc2aObK7nWclrmhyGmQT8Gto8gRYpM667E35b4qbILu28SenzhAOod8Jehm4QA2kRzQv
         017sqkzS5JABPfXyA1zMcaAvTc94w2Zpy/HWMJxHIZR4i9KD3O9IRNThKQA/Ai7unDim
         RlajY0i+g79AjBoUi5hXYIzRda97SmbUXfZ98KAsPVbffxU1MZnRGYDI5y7ZfBDnuKJS
         QNXA==
X-Gm-Message-State: AOJu0Yy17snYaUEwm9hbWaeAYclYMyvuOZtGgDjrGqWZLULGiPy2icWE
	Rrv8X4w55mZ/X/VlOU8QXm1o5IqTX0OCATuVaNuh6R9MggF7oiJsRifLB7xZCphpKpRe1SSoCuR
	9vChj70uWYJRXKlcVWwjKwxbv64E=
X-Gm-Gg: ASbGncui7a31fKDfuBOAJUpFSkalIED+RoNdZd/e7o0VaxLKyhm1X6iF6FsYwUYzSAd
	bjjRRehEMVDJ7jlrVpejQVfUvbnorEDzsUrMMvFg0Wol7LdghTZClZZyLIvaEvUqc+Oemeu7BGL
	h4bQcb9/050yY+To9YlDEyvFjwWZKzR95Wq+HZMOGMMf7WxBRcd44=
X-Google-Smtp-Source: AGHT+IGkzbtuISfEV47/XEgZ+egQIQciPTSCqGYLZy/VSnIr95BtkRPWPCd7RJi00sr8M7WHkMOlEA5+8k9LCb8uf8A=
X-Received: by 2002:a17:907:1c18:b0:ac7:9828:ea41 with SMTP id
 a640c23a62f3a-acb42ac64cdmr373675266b.41.1744838474364; Wed, 16 Apr 2025
 14:21:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250416161422.964167-1-luca.dimaio1@gmail.com> <20250416162812.GL25675@frogsfrogsfrogs>
In-Reply-To: <20250416162812.GL25675@frogsfrogsfrogs>
From: Luca Di Maio <luca.dimaio1@gmail.com>
Date: Wed, 16 Apr 2025 23:20:58 +0200
X-Gm-Features: ATxdqUGCKyuqkYb6WpbMAMabYoP50p0-RlieK58WZZPdl5_oLB-yXbTccLdisJc
Message-ID: <CANSUjYYJhof2h-yYJU2tZKAk6f5UwaeNOTHNyVbryTKKB5=P4A@mail.gmail.com>
Subject: Re: [PATCH v2] xfs_profile: fix permission octet when suid/guid is set
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sorry for the typo! Sent the fixed patch

L.

On Wed, Apr 16, 2025 at 6:28=E2=80=AFPM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> On Wed, Apr 16, 2025 at 06:14:13PM +0200, Luca Di Maio wrote:
> > When encountering suid or sgid files, we already set the `u` or `g` pro=
perty
> > in the prototype file.
> > Given that proto.c only supports three numbers for permissions, we need=
 to
> > remove the redundant information from the permission, else it was incor=
rectly
> > parsed.
> >
> > [v1] -> [v2]
> > Improve masking as suggested
> >
> > Co-authored-by: Luca Di Maio <luca.dimaio1@gmail.com>
> > Co-authored-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
>
> The subject line should say "xfs_protofile", not "xfs_profile".
>
> With that fixed,
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
>
> --D
>
> > ---
> >  mkfs/xfs_protofile.in | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/mkfs/xfs_protofile.in b/mkfs/xfs_protofile.in
> > index e83c39f..9418e7f 100644
> > --- a/mkfs/xfs_protofile.in
> > +++ b/mkfs/xfs_protofile.in
> > @@ -43,7 +43,9 @@ def stat_to_str(statbuf):
> >       else:
> >               sgid =3D '-'
> >
> > -     perms =3D stat.S_IMODE(statbuf.st_mode)
> > +     # We already register suid in the proto string, no need
> > +     # to also represent it into the octet
> > +     perms =3D stat.S_IMODE(statbuf.st_mode) & 0o777
> >
> >       return '%s%s%s%03o %d %d' % (type, suid, sgid, perms, statbuf.st_=
uid, \
> >                       statbuf.st_gid)
> > --
> > 2.49.0
> >
