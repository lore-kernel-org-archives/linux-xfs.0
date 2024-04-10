Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3A3181337
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 20:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712781937; cv=none; b=i8Gvzs8Cv3aQmmqvQ5Ls7AThE3/4GCr3/y5jV3oih34yk+87t4PG014RsXiZRHkAcfpSwYxxe1y9tViIPEWgMMu65NI+C+lT3CGOROMuAKuloHAQ4Sh9G7uIcJvZmSb0yOtuM3uVFk3012N2W7IIFZIOZ3pxfZIlNOqAgf0eLmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712781937; c=relaxed/simple;
	bh=Sy/3n97bkylo2eylcSw3DIwMa8fASnqo3q+J98wrEpE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TJIYOMC4q5w/fUK7+DNFXj7lGIw8O/CgmlVsfmdH6ZcadezoxGoESufflKAipWs5uJRzblDtzMPa2+DMdromCrlfkW3dVvxibpquwbi3KqvaITCwCH3ygFQ0ijCxMa4w9CE6TNvbBHgvRmoEHtDUtqnTMWqrsXIQoIxv5tiOBt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=heQAV+oy; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="heQAV+oy"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-56e56ee8d5cso5756724a12.2
        for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 13:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712781934; x=1713386734; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0FpPTUKrctxgqUBZXGaV/dKz7xcwvMQQhwEMsCpGXfs=;
        b=heQAV+oyQseVhgH63oyWgmp0WZhI+e8PaKUSNqhS2gq5orPDuuvVGIy5rsZYMOMMW7
         CqluC5pAB76gyqN3zfWm+YKGvB2VMz0PV4uf02PHGcdoRDnP+b2aA0IjqVmBUEghLZ2D
         /CNIH1jqAnKC4j1aUtB9bN82JwWtTC/Fd9++2AuvL6i6UJlDnZh9Y64NElDkXFJmo5j0
         gfB5VXvQjCFUKjwp3tIIHAIIlKCZ3Xzfap7RS1ZrrksDRPdLuY9Yw0UjZjUn3dWl1Yos
         /4ud1qASFPdeTEvSklsck7SbvaYeKFzchNNraKXpNZ01nMfUd2uBj57q80EekeFfC19A
         ps7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712781934; x=1713386734;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0FpPTUKrctxgqUBZXGaV/dKz7xcwvMQQhwEMsCpGXfs=;
        b=iPsLDxd09qfqyEYhAU55XrYV6te5dVrzbMPXYcOfV+4bguUR5eVIBmVF3bI0OKCZHb
         K+N6tVSTW7wjKnf+Ku4AuM7KBAC1zqfks7K53l9vFNsuFeXjY4ftGcaEugPV3LpoX/vx
         pXvGUKqrct2qaGZ9li4EBq4egRx9MwOT/r+BCLdty/srMqoQr/iB8EYCeJlcTuNeOIW0
         kezEQaZKoXvwXiBG6RtsiMnIM6O+kpF5+1NKq8ULKHQXiASCF0ai6+fnsIcYog9J9/a0
         ZZ+vEq9hM8GWCPQTYOs7zsTabw018R5JEzRBtI1s6+yr6SlmbdUUwAESE9sDzFkGth4p
         56lQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZzx2jXsiM2qPxg7EkV1TyBV4V59Yffm5GnlxED7tm9ycsVoN39lpjIHAvwTB0MC8YJsneYkK6Oj/JDYk0IaR4IetgbmFmw1u6
X-Gm-Message-State: AOJu0YznI0JFbhSHgdS4yCmHOikWwXnZNKC0MEHgUi9aD0zLc0OBgFtt
	F5Dx83K7/BYgjix03onnLBsBI9cBQVHdwGUbkhy1DZAi8aDMamSlhH0UTX9Lvbyp/tztiT8cax4
	S3UD5HHaBEmnjl63h2Zl9lqws5huTbcXxfmF6
X-Google-Smtp-Source: AGHT+IGfm5SKHc8x1Z8MOzxbf2eCje55T11TlY72Op320UlYL+PXjp/rDhREz7tGSwdmUtZx2sXVhYyqBWZ86FXOxZ4=
X-Received: by 2002:a50:d603:0:b0:56b:b6a2:2048 with SMTP id
 x3-20020a50d603000000b0056bb6a22048mr2808188edi.24.1712781934025; Wed, 10 Apr
 2024 13:45:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240405-strncpy-xfs-split1-v1-1-3e3df465adb9@google.com> <202404090921.A203626A@keescook>
In-Reply-To: <202404090921.A203626A@keescook>
From: Justin Stitt <justinstitt@google.com>
Date: Wed, 10 Apr 2024 13:45:21 -0700
Message-ID: <CAFhGd8pr5XycTH1iCUgBodCOV8_WY_da=aH+WZGPXfuOY5_Zgg@mail.gmail.com>
Subject: Re: [PATCH] xfs: replace deprecated strncpy with strscpy_pad
To: Kees Cook <keescook@chromium.org>
Cc: Chandan Babu R <chandan.babu@oracle.com>, "Darrick J. Wong" <djwong@kernel.org>, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 9, 2024 at 9:22=E2=80=AFAM Kees Cook <keescook@chromium.org> wr=
ote:
> >
> > -     /* 1 larger than sb_fname, so this ensures a trailing NUL char */
> > -     memset(label, 0, sizeof(label));
> >       spin_lock(&mp->m_sb_lock);
> > -     strncpy(label, sbp->sb_fname, XFSLABEL_MAX);
> > +     strscpy_pad(label, sbp->sb_fname);
>
> Is sbp->sb_fname itself NUL-terminated? This looks like another case of
> needing the memtostr() helper?
>

I sent a patch [1].

Obviously it depends on your implementation patch landing first; what
tree should it go to?

> Kees Cook

[1]: https://lore.kernel.org/r/20240410-strncpy-xfs-split1-v2-1-7c651502bcb=
0@google.com
