Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B411B1FDE19;
	Tue,  1 Jul 2025 08:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751359708; cv=none; b=VZr8deLAw59ngB6Pz0Rmgh1UhzB8Y17Edg+Hh2sGoPLNfuE2wmECs9f0OtcyadFo5XGqAWHzYRiQYXEkfT1QVFztSWrm0HhCijJywarTu475ErTLJzb/H//muWkEKhq7MIWUU4zMzrj7vHottdRMwpUje7dEy9+UxuwrdHhqeJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751359708; c=relaxed/simple;
	bh=bUYUIt7n5OcwxqVw8g8uXUJAIxLA66GdHxIXW4wbQ7Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SAREsp3hDwPrpQIuRD7XB+Czz8wZh0hJLyaN5PDsQ6qkiNAI9M5gry9gwLh0WUpUrmNh822+i3xfe9l3wUW7u9ZZ57YZzB6l8cZdvs6RY6D5bTJSi04i2AlVNLP0w6UA9eSkX7e3Aj7revotW7Mpa6D+JbSe4qEPVzL11cbOyZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SuI7X+gT; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SuI7X+gT"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-32b78b5aa39so29008431fa.1;
        Tue, 01 Jul 2025 01:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751359705; x=1751964505; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qlz9G1EGtx3NEnNnxuRUfIX8nol1KFsq1PaL5R1mF/A=;
        b=SuI7X+gTU21fAFFKYgRps4WlHwwoubeJE6PdlH8MYzJGOK0Dvtlt33g4BVuUbnEoAE
         +MX3mJ9cOQZL7npjXSCWVXpOYkm7ESyZTXO2htJ7pWt8a78YNTLiaCG1x90ghOWAcA1i
         hr+lSsQFEpoJEYGWTEs07Tj/U+iWnhb7AMGjGTTNlBpR0WdE01EQa5L/rztrkMyspukW
         wO72oCo2l44/yGKvBL+tm9VG/r149jNIS77C5Vj5uZKtFjzb2FSbMfuSbaPx8d8MGKdV
         Iw+SXw0X0VrqHbKNnEyP5DPDdZqEFkKC6MVksMWtJ7DyUUwwIY98KGF/BCu4QhDaPrbB
         a16A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751359705; x=1751964505;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qlz9G1EGtx3NEnNnxuRUfIX8nol1KFsq1PaL5R1mF/A=;
        b=KksOeFoFl3u/0ynHi1cIh6Jv3tp0ZCPKBFNislUieSk0vgkr/gZ43GsWsDiMn91zMG
         zH8aot251qTMx9KotTSEdqaOu7V8rScR84rd4cSyN6RndFUhNOJSMSWzN1bA3oRnXXjy
         Wyd79f5XctG580kDsJkMLJR0JymbGfeSkfHSVXi0olKyLTcxFfOYBzMin+kUCB6nfqAJ
         ZNAv5/DZUyqSQ+OV5L1wXZjm2cGo7yDZVfl3AJChEjZa7WeF+scFpZeX/UUsGhXK4kB4
         hl+yGfe+fKPcpGLNW49T7jIkgraZwaX5VeCobZUJfPi49tFqw82NBai+8tE6PFhsXzFh
         d2cQ==
X-Forwarded-Encrypted: i=1; AJvYcCU8/pIWasV+7ni2ha1YbqAJxScB1sG/oENd2/QT0klzW3RZyKT7gdgqHbgTX9b7AwrvWD6SsbgFNhaxROY=@vger.kernel.org, AJvYcCX7GUg5vzBX9hK7Bdg+0owxrtYUMb0hKDaiPnduwXagwlhEH2q9b8m6pe50aZAWGEPvZqCA4ItFD0Wq@vger.kernel.org
X-Gm-Message-State: AOJu0YwK501xg9hw4pf1iUQmneNE5GgGk04BgiXmqWMfqwSN8AMnZlER
	uFQ3rPcvolwuy5Ho8psiR/G7OwevWet+tnkSVWkurDk5X554AThfuS5h66mNhd2O2teZ4tBar2Y
	IdPInE1isiQ5b/DpICBNA4c1VqrO+jgeZu7Hlz/DogQ==
X-Gm-Gg: ASbGnct9hxE2HiSYMFAQI4cWH5qkueioaNd6agmJlg5hhZFJNpEoXnSUa6NOxJAXDsP
	kQ3pJ5BIr0abLuewVYk6vVqLErkvRCqdrnF42KWWUm7TdCGv9ywkuil/EwddOL5pmW8B7hUizjz
	DPOqJZjvJGO901xLlEarU5PEFtMin3YGPML1RJAKfj5/+DnKc3tWjyEnDuxNODxroQcSJgjHdlb
	d3viO7xmrLe/SM=
X-Google-Smtp-Source: AGHT+IErmMRan+sKmTTHK37Vk8l1nc2SvVeFF1R3OUSqouyPhRnqa2qhw9hJkcrN1a1c7VkhUpmiklz7WxPFHCxWJL4=
X-Received: by 2002:a2e:a239:0:b0:32a:de39:eb4c with SMTP id
 38308e7fff4ca-32cdc4991cdmr30441751fa.18.1751359704426; Tue, 01 Jul 2025
 01:48:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <BgUaxdxshFCssVdvh_jiOf_C2IyUDDKB9gNz_bt5pLaC8fFmFa0E_Cvq6s9eXOGe8M0fvBUFYG3bqVQAsCyz3w==@protonmail.internalid>
 <20250617124546.24102-1-pranav.tyagi03@gmail.com> <qlogdnggv2y4nbzzt62oq4yguitq4ytkqavdwele3xrqi6gwfo@aj45rl7f3eik>
 <CAH4c4jLjiBEqVxgRG0GH37RELDp=Py3EoY6bcJhzA+ydfV=Q1A@mail.gmail.com> <ldak3a3zmqlkv67mjproobt4g7pe6ii7pkqzzohd5o5kyv64xw@r63jjlqzafzp>
In-Reply-To: <ldak3a3zmqlkv67mjproobt4g7pe6ii7pkqzzohd5o5kyv64xw@r63jjlqzafzp>
From: Pranav Tyagi <pranav.tyagi03@gmail.com>
Date: Tue, 1 Jul 2025 14:18:12 +0530
X-Gm-Features: Ac12FXwKv4GTEJXH-cF4nonvlMBRj4FNPI9VATuH549AH0Rji8nOLlaLVC8Pjmg
Message-ID: <CAH4c4jJcyA+=x5y3BrW7dQkWOM3bVTepH0W16cm+_CLqHr4hfw@mail.gmail.com>
Subject: Re: [PATCH] fs/xfs: replace strncpy with strscpy
To: Brahmajit Das <listout@listout.xyz>
Cc: Carlos Maiolino <cem@kernel.org>, skhan@linuxfoundation.org, 
	linux-kernel-mentees@lists.linux.dev, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 30, 2025 at 7:48=E2=80=AFPM Brahmajit Das <listout@listout.xyz>=
 wrote:
>
> On 30.06.2025 14:36, Pranav Tyagi wrote:
> ... snip ...
> > > >       spin_unlock(&mp->m_sb_lock);
> > > >
> > > >       if (copy_to_user(user_label, label, sizeof(label)))
> > > > --
> > > > 2.49.0
> > > >
> >
> > Hi,
> >
> > Thank you for the feedback. I understand that my patch is incorrect and
> > it causes a buffer overrun. The destination buffer is indeed, already, =
null
> > terminated. Would you like me to send a corrected patch which uses
> > strscpy() (as strncpy() is deprecated)?
> >
> If the destination buffer is already NUL terminated, you can use either
> strtomem or strtomem_pad [0].
>
> [0]: https://docs.kernel.org/core-api/kernel-api.html#c.strncpy
> (Description)

Thank you for the suggestion. On going through [0], I see that,
both, strtomem and strscpy require the src to be null
terminated. As far as I know, sb_fname buffer has a size of
XFSLABEL_MAX (12 bytes). This means no terminating NULL
for the src. So shouldn't memcpy() be the right function to use here?

> > Regret the inconvenience.
> >
> > Regards
> > Pranav Tyagi
> >
>
> --
> Regards,
> listout
