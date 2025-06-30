Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883FC239E7C;
	Mon, 30 Jun 2025 09:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751274378; cv=none; b=At/92TsykcsWxuFRiur9NENAzjOlQWptcuE0vFDL1jiMVl08sdHPVeTM5mulp0x68MCPmYlsLCES8uzC99iiLpXXASOP62dpyJAjwcRHzJUYE6d28OxCaSueq19MOubokXyYlsMtF3Fy6HvedlrJUJuxUwcQYD1xm34R427ZGFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751274378; c=relaxed/simple;
	bh=5gHgaJRDbCKSv2ytqimG2JxpO3g5IlQOq1sbnXKKmVk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=taJZjxbePNQv0VSf8J6hWt79KAMlXxtVrXSNSwpYW3CuxitosU9phu8PKDv0bD8mRLSFAuhVB9ldMZ0eyi1d3Tu/41rG1nwwIzNe/Fs2efFDvtWUC9uqsnczeDU+i20T7sqnGjjJQ/Xwe1TpnLj0Tzy9XECFQZTzA/MPtFVmSs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KQOS5NK3; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KQOS5NK3"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-60702d77c60so8437785a12.3;
        Mon, 30 Jun 2025 02:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751274375; x=1751879175; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zkB7mEEipMdqVFva/up+3uvXTv0EJjxJagKL7Ep/rFs=;
        b=KQOS5NK3nrD83B/P462a7As7v8fQT71yRrOg1VxkOIjv0EREGow5i27/kEol2nzEim
         t+jSJJaplYZHYqLQHElp6B7QeA7fj/TSZbf2LyoXyvxLUnMjIL1wYCO/m1XLk9cvJkOL
         XtnexGJ4mceMCsK08d2mnMcamUljIbyYX2tIp5o6HP3CVkqDz9Dl5NHYhzSC8VUrwjqZ
         HaiGG/iOye7YHVF1JEt4WYYy9Fp6KmGaGAuYABmX+AHuNQwkD3U03PoQGFZUt3vUcYhB
         WlLVB+vkx1dKddprUy7aNFfJ2aujlhozqQI63Y31CQy794LtXSpOuNBmORtpdii7+wnM
         Y0ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751274375; x=1751879175;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zkB7mEEipMdqVFva/up+3uvXTv0EJjxJagKL7Ep/rFs=;
        b=lOmrGB48lZib9wcByQyuhUqvf9eYuP86Eu8zyJYKkBXcs5mAaJNqvM9/jcI/BuhGG8
         03IfWDmxN6rRtg/Uuqy7omorviktsaHEy68RGPzq4vFLVF/jabSzyGBQCMoPoO3z+uM4
         OvVZ1SpzhBIKK6MRT2hRadteV0p5up1+pHXMsiQhvrQcnrWkhhJWoFibi78DWsUI5Z+J
         rwHMoIe1KfK3KQL30shzYrgSuOqKZkU6jjiBavQCVmCxLbnOkXTigtnYYcZ+vm8HpveC
         uhKmpoiFXAqx2WMNADmZJhv8QqEL6o7T/ZmG5RKASw1qSU5vyGSgG75Nabofl0cquNef
         YNEA==
X-Forwarded-Encrypted: i=1; AJvYcCWJB0SzUGYeHfZie/YUKlgllyCBxu+WM60jsPcGGFFNMtNvMDDZZ/9hwaZmIzVIUB4iUrEAMeJffWZvTeQ=@vger.kernel.org, AJvYcCXPTKTdGIWdzL0nUoEousV1qytXdMwLzvH0+Y6tUD2zWVxGodqOyLKRGLRuYPs8KQdrMQ37w3jZG9vS@vger.kernel.org
X-Gm-Message-State: AOJu0YyqQ+riVOWVkdu11Rs/UNmA4bjQ2DV2wtBaTBuhu8sF0FvqGR7O
	gOm5bbATZb+SUVhn99hGhE5JLSrzkZxfdpS3MqWfbH4n4akdq/OU5RU0dD7wxYJfn6AFEIRxFeU
	+0EwZ7+5hPAjjGS2MCz4P4Ts6MbTAiaA=
X-Gm-Gg: ASbGnctdkT7yzRgI2b/nlSW9E3Mb/BYsd72YA5jUQFSMGtwJZjR5zlPonkutAZ1F9Nx
	XTbLulQyVswvvKR0lAgsDrOqTm96DnyEkLX/xWMPMQDMg/HrObAC3IoUzZSgvgghPs2S/CbpLIf
	8AiItLzl7okROWEKj6S75EZ9WDbviACcTeNAo7rCDpvX0Xuk7BdjBFBZuzPwEz8DeVErR/2tc2b
	ZlAQmqfjVMQNCE=
X-Google-Smtp-Source: AGHT+IFwTxcyTIa8fzprZ+ugwGCzJpImOkoMGnG2ENcUx+MwC8Um4xsbA+LiwKFmDE08uC5QoYs1DEPe5zA4p/Q2t8I=
X-Received: by 2002:a05:6402:254a:b0:60c:3b63:d026 with SMTP id
 4fb4d7f45d1cf-60c88e59f4amr11089474a12.26.1751274374529; Mon, 30 Jun 2025
 02:06:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <BgUaxdxshFCssVdvh_jiOf_C2IyUDDKB9gNz_bt5pLaC8fFmFa0E_Cvq6s9eXOGe8M0fvBUFYG3bqVQAsCyz3w==@protonmail.internalid>
 <20250617124546.24102-1-pranav.tyagi03@gmail.com> <qlogdnggv2y4nbzzt62oq4yguitq4ytkqavdwele3xrqi6gwfo@aj45rl7f3eik>
In-Reply-To: <qlogdnggv2y4nbzzt62oq4yguitq4ytkqavdwele3xrqi6gwfo@aj45rl7f3eik>
From: Pranav Tyagi <pranav.tyagi03@gmail.com>
Date: Mon, 30 Jun 2025 14:36:01 +0530
X-Gm-Features: Ac12FXyJJULHsrmqDZ-6EY8YAD-MmRxLrWdoQ4FALL0Aw5V02Zuh37C80PEcs1c
Message-ID: <CAH4c4jLjiBEqVxgRG0GH37RELDp=Py3EoY6bcJhzA+ydfV=Q1A@mail.gmail.com>
Subject: Re: [PATCH] fs/xfs: replace strncpy with strscpy
To: Carlos Maiolino <cem@kernel.org>
Cc: skhan@linuxfoundation.org, linux-kernel-mentees@lists.linux.dev, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 30, 2025 at 2:09=E2=80=AFPM Carlos Maiolino <cem@kernel.org> wr=
ote:
>
> On Tue, Jun 17, 2025 at 06:15:46PM +0530, Pranav Tyagi wrote:
> > Replace the deprecated strncpy() with strscpy() as the destination
> > buffer should be NUL-terminated and does not require any trailing
> > NUL-padding. Also, since NUL-termination is guaranteed,
>
> NUL-termination is only guaranteed if you copy into the buffer one less
> byte than the label requires, i.e XFSLABEL_MAX.
>
> > use sizeof(label) in place of XFSLABEL_MAX as the size
> > parameter.
>
> This is wrong, see below why.
>
> >
> > Signed-off-by: Pranav Tyagi <pranav.tyagi03@gmail.com>
> > ---
> >  fs/xfs/xfs_ioctl.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index d250f7f74e3b..9f4d68c5b5ab 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -992,7 +992,7 @@ xfs_ioc_getlabel(
> >       /* 1 larger than sb_fname, so this ensures a trailing NUL char */
> >       memset(label, 0, sizeof(label));
> >       spin_lock(&mp->m_sb_lock);
> > -     strncpy(label, sbp->sb_fname, XFSLABEL_MAX);
> > +     strscpy(label, sbp->sb_fname, sizeof(label));
>
> This is broken and you created a buffer overrun here.
>
> XFSLABEL_MAX is set to 12 bytes. The current label size is 13 bytes:
>
> char                    label[XFSLABEL_MAX + 1];
>
> This ensures the label will always have a null termination character as
> long as you copy XFSLABEL_MAX bytes into the label.
>
> - strncpy(label, sbp->sb_fname, XFSLABEL_MAX);
>
> Copies 12 bytes from sb_fname into label. This ensures we always have a
> trailing \0 at the last byte.
>
> Your version:
>
> strscpy(label, sbp->sb_fname, sizeof(label));
>
> Copies 13 bytes from sb_fname into the label buffer.
>
> This not only could have copied a non-null byte to the last byte in the
> label buffer, but also But sbp->sb_fname size is XFSLABEL_MAX, so you
> are reading beyond the source buffer size, causing a buffer overrun as yo=
u
> can see on the kernel test robot report.
>
> Carlos
>
> >       spin_unlock(&mp->m_sb_lock);
> >
> >       if (copy_to_user(user_label, label, sizeof(label)))
> > --
> > 2.49.0
> >

Hi,

Thank you for the feedback. I understand that my patch is incorrect and
it causes a buffer overrun. The destination buffer is indeed, already, null
terminated. Would you like me to send a corrected patch which uses
strscpy() (as strncpy() is deprecated)?

Regret the inconvenience.

Regards
Pranav Tyagi
