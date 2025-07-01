Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452C027816A;
	Tue,  1 Jul 2025 15:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751384543; cv=none; b=FuvBicup5na0Pc4SwJ+ar0Oe9qLuFS7bMIsH0jaJ8lbjtubxaiZtNgeX+yivd29t7nxXk58lpDOLTLs1HTCupffp2Yu769FMokE3y68/LUbZ2RZ9p1W12ZlZzuyuzjr8iAeNhYE68j2K71/j9eLklmK5J8ClDIYfMBdrO4FZQ1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751384543; c=relaxed/simple;
	bh=sF+03HSIwOXlAgwN7PqRptlDGeBLCm7jygWo/KrfNno=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PCpWsxXPqdE9M34DEbhHieIQmPm92tq87CqnkdBpVFwN/RouIUQg4AhbssZzqFE4yIvzCa0awayWN/Pf+FNSA9tSzesCUOQ0CI5WRhVuCNVeCdWnLGgsZ4bBA+lHXm6dBt5T3TNYoP7DCb8vn3uSmRdDKkpfD0wMfrqu9EjaFIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gt+65Hk+; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gt+65Hk+"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-553b16a0e38so6388766e87.1;
        Tue, 01 Jul 2025 08:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751384539; x=1751989339; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pBlCZ1mA0p0uhuNGCxCL9ZQiCr3I3i6VKn9TZEgMOuw=;
        b=gt+65Hk+4XGjOGmWsZalRWDiANBiQ4vQK8RZM72U9II3SF+Qz76J3w5paTIhk2uRTh
         hWHNcY0eoZQK5JxPVsqXYtkEbEeMlNQe4TDqdTs0HPz5CzQRICA5g0MS+z98ls0LFAw2
         gtP9g3s8+qBouwfvjHHAGSXR+lvX+9VihGJ68PTSeM51Ety6hxfEQ/pGOCRQ1n0TXQ26
         K8twuNrtZxekGbmtaJJrBW3owNh8cius00vmO8miRUYpqWaQVD6+xkXevOW9/gtDXCuv
         H+Intuvx72lsF38Gydq4LjtqwIPI5+4RIHvMfIkRRA4XfC8n8zlwoKydADXNsL4BtMjW
         7t8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751384539; x=1751989339;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pBlCZ1mA0p0uhuNGCxCL9ZQiCr3I3i6VKn9TZEgMOuw=;
        b=XQIPTqS3GU7ymJJf6EpZWYxJcwUozVTWvPLYGgEqWmlrX4sN8IpfJsv6LU+Ei0DBwS
         IN429wCtT8nz1rnf/o+Fbk/dSAboBRwUzGZdD85Lheg3hodb8EdM935d4MPgFnEpY/aS
         mFFXnitO8s4GRv88RYspfBlCusr/3v4GjVkbWgM97XZ1rBYXJmPXddWSIa50v5EGsZr4
         F0ZOUE1ixPYq7G592+hDABdkrXwItIBfey6Zr0WnfvQWESZVZadmstICyYpREAHerDG6
         Xq7CTorkYp0L1jtLqezU/Xen25ti0B5DT+U5mATQNhe8zHs0Y6Aecd9f0Qj+r7lsylo6
         V4FQ==
X-Forwarded-Encrypted: i=1; AJvYcCUyu1OYFNAXxG1dCerJSrfSDcjG7wVRw9uDES1bwJGvh2t9O41U9Jt44IG85UR91ghjpv9XcFz30Xx5@vger.kernel.org, AJvYcCX0hWLY/Cer+BsiqJCduT6MnOQU32gUyWsSP1MzFBCPNJoC+ZYqisCQ6lAOaHplXjNJ+DNiJkFrALHaGXo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0cKuagrsbt9vmTkKf1ePmqRpajtp/fjWsib+eRopzrhopFHc4
	4ZbdDX1mn9l6es58jHqBs2rFXe/AZL4PizDtLFQTCwyrQvv230tP1myLVAo/oQaETom41JIOYfU
	ypORaaokbQ9m6cmmoZzC1ViKS4I4dMr4=
X-Gm-Gg: ASbGnctUMElkCjeAmKaNDkCb4MgZNGsoHLmPcgQPsnVekpQGwYfoAc246f+gb9u/OFg
	s+3PkaxHiiRFQpcQEhEgfXEgFTE219B8SbiSPjDFBQYWQ9gR4pQyi3jzmFkUL99EkN+3voyM+dz
	jLGH1qOkcALPBIvNmPRvEjojxzQBOOZ28uOc2eX60XpXIgl0e99AoSBBH9MKvbrnQGY1uVPXVAt
	oxDpSsKtuy4e7E=
X-Google-Smtp-Source: AGHT+IFKyvLywVbvPp4+IAYsLJGN1A/FzeH/GkeWu1Ic03hmzkh8su5WzJzIbXEv994J37Qscka0Vjyh57qSWmJkoZs=
X-Received: by 2002:a05:6512:3b2c:b0:553:3892:5ec3 with SMTP id
 2adb3069b0e04-5550b8d861bmr5647623e87.46.1751384538989; Tue, 01 Jul 2025
 08:42:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <BgUaxdxshFCssVdvh_jiOf_C2IyUDDKB9gNz_bt5pLaC8fFmFa0E_Cvq6s9eXOGe8M0fvBUFYG3bqVQAsCyz3w==@protonmail.internalid>
 <20250617124546.24102-1-pranav.tyagi03@gmail.com> <qlogdnggv2y4nbzzt62oq4yguitq4ytkqavdwele3xrqi6gwfo@aj45rl7f3eik>
 <CAH4c4jLjiBEqVxgRG0GH37RELDp=Py3EoY6bcJhzA+ydfV=Q1A@mail.gmail.com>
 <ldak3a3zmqlkv67mjproobt4g7pe6ii7pkqzzohd5o5kyv64xw@r63jjlqzafzp>
 <CAH4c4jJcyA+=x5y3BrW7dQkWOM3bVTepH0W16cm+_CLqHr4hfw@mail.gmail.com> <20250701145736.GE10009@frogsfrogsfrogs>
In-Reply-To: <20250701145736.GE10009@frogsfrogsfrogs>
From: Pranav Tyagi <pranav.tyagi03@gmail.com>
Date: Tue, 1 Jul 2025 21:12:07 +0530
X-Gm-Features: Ac12FXz-FW-denQLRxG_NjlT4YvYBBzn0GPsDDvTMYDJxmt6df0KudTNSR6YHqY
Message-ID: <CAH4c4j+N0OrdmeeEUALKE+fQpVZjWNHegFMPTq2DmotSmBtsdw@mail.gmail.com>
Subject: Re: [PATCH] fs/xfs: replace strncpy with strscpy
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Brahmajit Das <listout@listout.xyz>, Carlos Maiolino <cem@kernel.org>, skhan@linuxfoundation.org, 
	linux-kernel-mentees@lists.linux.dev, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 1, 2025 at 8:27=E2=80=AFPM Darrick J. Wong <djwong@kernel.org> =
wrote:
>
> On Tue, Jul 01, 2025 at 02:18:12PM +0530, Pranav Tyagi wrote:
> > On Mon, Jun 30, 2025 at 7:48=E2=80=AFPM Brahmajit Das <listout@listout.=
xyz> wrote:
> > >
> > > On 30.06.2025 14:36, Pranav Tyagi wrote:
> > > ... snip ...
> > > > > >       spin_unlock(&mp->m_sb_lock);
> > > > > >
> > > > > >       if (copy_to_user(user_label, label, sizeof(label)))
> > > > > > --
> > > > > > 2.49.0
> > > > > >
> > > >
> > > > Hi,
> > > >
> > > > Thank you for the feedback. I understand that my patch is incorrect=
 and
> > > > it causes a buffer overrun. The destination buffer is indeed, alrea=
dy, null
> > > > terminated. Would you like me to send a corrected patch which uses
> > > > strscpy() (as strncpy() is deprecated)?
> > > >
> > > If the destination buffer is already NUL terminated, you can use eith=
er
> > > strtomem or strtomem_pad [0].
> > >
> > > [0]: https://docs.kernel.org/core-api/kernel-api.html#c.strncpy
> > > (Description)
> >
> > Thank you for the suggestion. On going through [0], I see that,
> > both, strtomem and strscpy require the src to be null
> > terminated. As far as I know, sb_fname buffer has a size of
> > XFSLABEL_MAX (12 bytes). This means no terminating NULL
> > for the src. So shouldn't memcpy() be the right function to use here?
>
> memtostr_pad?
>
> --D
>

Thanks for the suggestion. memtostr_pad fits perfectly for this use case.
It takes care of null termination as well as avoids the need for separate
zeroing. I'll update the patch accordingly and resend it.

Regards
Pranav Tyagi

> > > > Regret the inconvenience.
> > > >
> > > > Regards
> > > > Pranav Tyagi
> > > >
> > >
> > > --
> > > Regards,
> > > listout
> >
