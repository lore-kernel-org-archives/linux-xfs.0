Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0870923CE
	for <linux-xfs@vger.kernel.org>; Tue, 14 Oct 2025 07:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760425817; cv=none; b=ZOx7XS/fgrAYeoh1Ri5NBiwkjIOvKKWaLaE08xJatcaaTzwmUtEFctEC1UD7IMSSupWGLsYj+a+rRLuxn+mUsn/gEXO30y4aP1iXvSKNadlc/V1HVUOA+OEHSaaTY92iY74ikW0sh1Af4L6mdFS8i51SwufG5xVNEsuSE5dL+wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760425817; c=relaxed/simple;
	bh=cq9uw8grWJhJrjC0Uudr9DxsgXmV436TasExQ1HyP6E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=prM/O6r31DRgtA9/RjiIXP+16pNRHQPOBuWcEd5/VDkmu3E79bqM5VSY6CoVpIbBtg/9CJXnznTde5TFgoJ+WoATRH+VvaDcdaASkLaGbgWSZNaUp2m4cIzBiO32sEbUjx0XKQdSjf3yds+A6SQyjMwn0F97sOELq+2OXWV0Wcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.217.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-556f7e21432so4562855137.2
        for <linux-xfs@vger.kernel.org>; Tue, 14 Oct 2025 00:10:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760425815; x=1761030615;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t19a6MXKzHciHV0Q6aOx1ZCqH/XgqkiiYrhyJp0q9cg=;
        b=bRYmWBofOAw603kJB3ATJAAke7VDfDZ1ptL8Nwtl3iZ0zRKmaLh/tSpXBEv2oghaUX
         57ynj72asZ1G2BoCkdwrZ+5voImiYCgA2vbEohN84D+dCMqYaQJJqZ43wkSey2n7nVLp
         iphBLQG9s1xF4BP2pNOGVA82rnrf5QDiKYe1BEVi9SnYCHkXc4FpibWTiiRk2llZ4O2B
         74JTeGRag1fNOKhAR3/ee2aZi0UZ+HcetfrXGCXn4zOjMtW2Zz4FBTsEwKdmkar/p2Ca
         6h4JO34T+0J3zerUaGTOE5AQ4dDMxNRietXSl4qB55/pmh7vj6shzQQdbacBgIn1H9hb
         sq9w==
X-Forwarded-Encrypted: i=1; AJvYcCVK/pBWlIvtyDmDqQtNdSqutOQjOTL9Z5+RJ1atvffCyNGXa+eZdBPMpVENmcfCDELfzRFfXqwO1Ek=@vger.kernel.org
X-Gm-Message-State: AOJu0YztmY1vDinuzo0deK4FGZnJB8oIJ1KwiRJgEtAjzSiziK/d01F7
	EiGylUSkwqmhzX3KEcrO+Qop/En/Ckkzk8aQEI7UYAgYETOBu4DqwNWBdcx5tqMF
X-Gm-Gg: ASbGncuKpnhtrbPZV/HIuz+KANkgO9BFxIg7fgz6+cfcP4ot7FndRc8nSBT2sq2Z39E
	blDIE7pNXg4VWGveC1PLoJKyvCSHWDbnThyeYES70LC39cnuRb/M6SR6o7H+rg9SVU8LNIFXQmK
	5CiWSnVh+QcY7DVK1Txu7NEGIehSHGncsUoB7o2nbC6N0dhyDqru76BdPgTCpyxP8myHTiTH0cr
	b/89xdYbDNAN7I6t5cozeCRUL1qrxGb0d0I/1YvLEF+/BQ6nmNeCSYQ9ImBwG36Ls8itYBrMFP7
	GI6CDU986PbRI1AWQ/dzD0RDYA28W3nv3jdkLenHgtB9qmSXdSY1SaLCM90lW2YzyMnxUlMEkUE
	KJVbZ/sNs49L3aKYtDMH+3KV2MH3VzAVQGYEkO5hLqX9OZwcB/ZcRTXOAMa5gPfQXC324NV4HjV
	luUIlkK4o5H65AbQ==
X-Google-Smtp-Source: AGHT+IEG6/NoInMehsBOGv9dqzPSH2WrUuL5qY2al5KmJYEySHilYV4lP3dEMajRwsiiz1+vDWV0Qw==
X-Received: by 2002:a05:6102:5087:b0:522:db47:90ac with SMTP id ada2fe7eead31-5d5e21d35c3mr8504730137.6.1760425814694;
        Tue, 14 Oct 2025 00:10:14 -0700 (PDT)
Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com. [209.85.217.41])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-5d5fc762b0fsm4045268137.8.2025.10.14.00.10.14
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 00:10:14 -0700 (PDT)
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-580144a31b0so2515900137.0
        for <linux-xfs@vger.kernel.org>; Tue, 14 Oct 2025 00:10:14 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV7t2j+1qvaD3z9ir6nSKeCr6MdMg+tthALGOfEYhLMrjBkmnp038ZnNrKaKfiow59x6HoHAyFY9O0=@vger.kernel.org
X-Received: by 2002:a05:6102:3f04:b0:5d5:f6ae:38e8 with SMTP id
 ada2fe7eead31-5d61e0b5ffbmr2234131137.41.1760425814222; Tue, 14 Oct 2025
 00:10:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <69104b397a62ea3149c932bd3a9ed6fc7e4e91a0.1760345180.git.geert@linux-m68k.org>
 <20251013163211.GL6188@frogsfrogsfrogs>
In-Reply-To: <20251013163211.GL6188@frogsfrogsfrogs>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 14 Oct 2025 09:10:03 +0200
X-Gmail-Original-Message-ID: <CAMuHMdURm_mpK3Pnr=XtUqe2RsqJY_hVR-R797hRSSc0U_0DKg@mail.gmail.com>
X-Gm-Features: AS18NWAt5y941DryWLpHjW4UEKltrVPplKlP6XoI8IybklIeQYe_Y8B6bt0jZBI
Message-ID: <CAMuHMdURm_mpK3Pnr=XtUqe2RsqJY_hVR-R797hRSSc0U_0DKg@mail.gmail.com>
Subject: Re: [PATCH] xfs: XFS_ONLINE_SCRUB_STATS should depend on DEBUG_FS
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Darrick,

On Mon, 13 Oct 2025 at 18:32, Darrick J. Wong <djwong@kernel.org> wrote:
> On Mon, Oct 13, 2025 at 10:48:46AM +0200, Geert Uytterhoeven wrote:
> > Currently, XFS_ONLINE_SCRUB_STATS selects DEBUG_FS.  However, DEBUG_FS
> > is meant for debugging, and people may want to disable it on production
> > systems.  Since commit 0ff51a1fd786f47b ("xfs: enable online fsck by
> > default in Kconfig")), XFS_ONLINE_SCRUB_STATS is enabled by default,
> > forcing DEBUG_FS enabled too.
> >
> > Fix this by replacing the selection of DEBUG_FS by a dependency on
> > DEBUG_FS, which is what most other options controlling the gathering and
> > exposing of statistics do.
> >
> > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > ---
> >  fs/xfs/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
> > index 8930d5254e1da61d..402cf7aad5ca93ab 100644
> > --- a/fs/xfs/Kconfig
> > +++ b/fs/xfs/Kconfig
> > @@ -156,7 +156,7 @@ config XFS_ONLINE_SCRUB_STATS
> >       bool "XFS online metadata check usage data collection"
> >       default y
> >       depends on XFS_ONLINE_SCRUB
> > -     select DEBUG_FS
> > +     depends on DEBUG_FS
>
> Looks ok to me, though I wonder why there are so many "select DEBUG_FS"
> in the kernel?

I think select is OK for pure debug functionality, which is not enabled
unless really wanted; depends on is better for optional features like
statistics, especially if they default to y.

Alternatively, the "default y" could be dropped from
XFS_ONLINE_SCRUB_STATS?

> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
