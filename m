Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFA62E7160;
	Tue, 17 Jun 2025 13:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750166619; cv=none; b=QwEIq2fiRVQUixobG+G5Ng7DjUA0rYMa/rOSGnqSW0J02XlMFtweaGS9J0yFMYI1Yr4J7Cce5HQqIBTalYesrRDm61s+/1CFvmnYBn34fdqg+gXJ5Sy1YM9CGfrjpCwLIpIRR+If/KlH4t1Mh4xctTdWHDYPuQwXlVDl+dWqtZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750166619; c=relaxed/simple;
	bh=aq+jLmLEZueUREtaCloPI8dNoT19sceodfbAKjhjFCY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UIdSW7XlExN9Sl1X9V4CWRMq2ivcf8mtwdiDNwMhi4fbbvHtdeKCLdXiB736iPupOjDyHcN4OuUBteuLKWUU96gzKO2yY5Dxq/MrP0Q+tt05b+WmLifYEwyltAgwyw/h559jOWZbSyC/ZAbu9dgELE++ZpZNznMNyQqPQPamv7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S/LLvZmM; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S/LLvZmM"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-60780d74c8cso10331975a12.2;
        Tue, 17 Jun 2025 06:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750166616; x=1750771416; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Da7GngsMQn+NCqkD4TvMnzofO+IHiaf6PmzIm2w+GkQ=;
        b=S/LLvZmMYIc390LjFnsM/8hEit306FUYPx9j40KQLIqDjpAhto8LQqmfWmHBKycYnM
         /koZfjoaJDiL+PyImkhJPS9rZJbZJxXAp1YTqDMJVdE6mp3jh7SbJDb1pjXoiCN3Ljz3
         KXnwyMAQ4ag30VgrWcPii7NqtEh9XZgomFrqHZVnbI3BI1cEVDAfm4G5vLCpSdivg9FR
         KKyidejDobs6jJqaaass3zkkAOBj9CXVP9Hi7Fs43dixN3lVw8yfsHWpj3jNFQ69FDrn
         CUxmmJfIHrGS6E6eSI3UdBu2a7JqOBfSzLZVPgnmO4Z4MY9twGoXmL/ajf7IPWOT6vHz
         9Otg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750166616; x=1750771416;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Da7GngsMQn+NCqkD4TvMnzofO+IHiaf6PmzIm2w+GkQ=;
        b=TOO7rY5D/FC0/dqqZiEtLeIhiSzDEHW1TEWKJzDGNEskQIBCeuJ0stjgZsGmweoDs/
         /csOv+4LqSoKQ4NBU8q436/ml6zenZ3dt2ON9qx82VcjNe+jyIsUG5yPOmhml7SXSN7l
         Ab/aXObs8Q2Xz4h0bDl6OurAE2osPHijKliiZK0LU0zCeio6EBe49M25dEoxLXmpOOWP
         WkCKaBGSc9s8u1k0hrgfPQwCFY46u1GDlEThwyXrXb0ZrQi0Vlqs98MtfzFxK+DmYlwz
         Ce7gvp9uGmhGs0S87ATF/5m9VFMBATRyopSacBh1/MiIIM80OUb07QAcLOd3/2p5T2BY
         Dmfw==
X-Forwarded-Encrypted: i=1; AJvYcCUXXuazmmx581XZ76XssK+4R2b8h/HdBVbjHMegLO1jSem5ZAUEoyOLYqSjfH1rAaqeUuhlRx6qbPMR@vger.kernel.org, AJvYcCVTd/URaHSgAesFxAXbX50JDw9Qo0aU+2mGOA0RGjKDqKsidYxlQYlapIJ1dMNNwVENBdoB+v2WAxfUlw0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxcUUcKxprCWQA5q94TH9VoE3FWywg3EVmzkCIba1x0Whd3+wJ6
	ilCz9QRAvS/P51NgmQukZ7kYeQQEW/ruiV/JC3POkIr1Jf/KL5pDKgb6WiFELXCgLn0Ut4ra5Ld
	HK591qqGl3xZtGyluBH+JZ1DSOh7pV6mzjN+Wnf4=
X-Gm-Gg: ASbGnctMhqH9QeG32FimNHQV4M2d21A8F81DhTXpfYsH6gb0FmZfw7cw0oPa7LkKjqP
	I3Cdhi76W6YKr+6iGbXd7CD6HCZkGUhL1d+m0fUEX9pEriY9xVuwHh+CpLY4VQgKTg3OIhySSAG
	TxW7NFGjGF5cL5Cgmoce286ZjtTp4AfVkP86GSisehmwEZ6i7Y5MOkBuvw3XkMUhxovrwX4qhdB
	uSc4lD9uTDsQcFc
X-Google-Smtp-Source: AGHT+IF35zRDouRKgsl23iu8Ip8Af2QD0L6RBLQ4Z6LxvD9CFO2X76jNFfDTlSdWniAE8FphyNnG7TzaPsay7oaHoT4=
X-Received: by 2002:a05:6402:510c:b0:602:3e3:dada with SMTP id
 4fb4d7f45d1cf-608d0977a42mr11931446a12.25.1750166615605; Tue, 17 Jun 2025
 06:23:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250616110313.372314-1-pranav.tyagi03@gmail.com> <2025061610-basics-attendee-cd02@gregkh>
In-Reply-To: <2025061610-basics-attendee-cd02@gregkh>
From: Pranav Tyagi <pranav.tyagi03@gmail.com>
Date: Tue, 17 Jun 2025 18:53:23 +0530
X-Gm-Features: AX0GCFvpbJIGp1gRUpPgvLsO-IJEhIBlsBKcgaCSHrIHCpbktmH_xOFexTbviFw
Message-ID: <CAH4c4jLn78OYPqqEESh6vRhxfD8s=J8a-cX0WzVE1bEPKVAHEg@mail.gmail.com>
Subject: Re: [PATCH] fs/xfs: use scnprintf() in show functions
To: Greg KH <gregkh@linuxfoundation.org>
Cc: cem@kernel.org, skhan@linuxfoundation.org, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 16, 2025 at 7:50=E2=80=AFPM Greg KH <gregkh@linuxfoundation.org=
> wrote:
>
> On Mon, Jun 16, 2025 at 04:33:13PM +0530, Pranav Tyagi wrote:
> > Replace all snprintf() instances with scnprintf(). snprintf() returns
> > the number of bytes that would have been written had there been enough
> > space. For sysfs attributes, snprintf() should not be used for the
> > show() method. Instead use scnprintf() which returns the number of byte=
s
> > actually written.
>
> No, please use sysfs_emit() if you really want to change this.
>
> >
> > Signed-off-by: Pranav Tyagi <pranav.tyagi03@gmail.com>
> > ---
> >  fs/xfs/xfs_sysfs.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> > index 7a5c5ef2db92..f7206e3edea2 100644
> > --- a/fs/xfs/xfs_sysfs.c
> > +++ b/fs/xfs/xfs_sysfs.c
> > @@ -257,7 +257,7 @@ larp_show(
> >       struct kobject  *kobject,
> >       char            *buf)
> >  {
> > -     return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.larp);
>
> There is nothing wrong with the original code here, you could use
> sprintf() and it too is ok.  So this type of change is not needed.  But
> again, if you really want to, use sysfs_emit() instead.
>
> Same for all the other show() callback changes you just made.
>
> thanks,
>
> greg k-h

Hi,

Thanks for the feedback. I understand the original code is
perfectly fine. All these show callback changes were intended as
cleanups. I'll drop these patches. And will use sysfs_emit() if
I ever have to.

Regards
Pranav Tyagi
