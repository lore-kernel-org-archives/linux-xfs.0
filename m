Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E51E43AA1
	for <linux-xfs@vger.kernel.org>; Mon, 10 Feb 2025 18:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739212467; cv=none; b=nPTDtlD9Vd9VHs3LmknEW6cp4ChrhgSFfW3gqWUNPyUKYeurnP85OYgp54u2EP/D63J3HE75xf4EBiHFXrUwhlQiMmEnmiCYdQPNGbFVJH/Yn6Ptho3pDYgna7n+l6lkcx+tJv0jSZXb35l1jjEwaNzyfGUsXMtPs9XIRxSvadA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739212467; c=relaxed/simple;
	bh=gpH9vmxvl5HIS6ETSK90Nyk5snQxXSDUPWARQbvAdj0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PjbXtgSQ+lVkchYz4KoTTlYn1FmORCOYFwd1x0UCzYW0qvlz6+2eyMLHoWVMazOCzWoNjpmPxnTuD3Hz+ikA5GU9TRlad5C8IHetdrW5SLBlMBj9og6kAsOIAwHiM6qmQhpXtUFV6tk13NMlyk9QMTDAQtSsPjf/s/B52PiS4xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=scylladb.com; spf=pass smtp.mailfrom=scylladb.com; dkim=pass (2048-bit key) header.d=scylladb.com header.i=@scylladb.com header.b=D1yCHSWs; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=scylladb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scylladb.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=scylladb.com header.i=@scylladb.com header.b="D1yCHSWs"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-21f4af4f9ddso53104635ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 10 Feb 2025 10:34:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb.com; s=google; t=1739212465; x=1739817265; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TtE8Mn8yxuEsrWyQt/824T3+/FuJ+XtVk6ePIzrR3yI=;
        b=D1yCHSWsFmch5WkUxC05c41Tl57oZNpzsP7Pxq0o1CezDCQZdkkVQauLKBbP4V998D
         2BDpxgMG3w8F0f0YAJmu/9QuhTcHMJ8FhcHU8BP1OXiIDKxuBpYSD6YRJK3viq9e0JD3
         5kQfT5e2Zviw1dqxfFJKs5r05sseHTVzNAzfM1Ly2Y5VcyjUar0gGGxOuS+AEzlsKe+L
         5om9P+vENtOyQ2Gvt8NH0L/jRk1II8JeKe8bnCXvDjVhtNz/MBxqWK4RjGpri22fCHEl
         TbG7G2bOs/8GORnSaW5YugfgGPYsleCC6Z+YRpFRMtzHA8Q0wsmVYXY9zEfMV94G/Xxa
         J9dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739212465; x=1739817265;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TtE8Mn8yxuEsrWyQt/824T3+/FuJ+XtVk6ePIzrR3yI=;
        b=HjiwVQm6kcwhfcFNFYB1h2KQvL7kbVHtnZEQSAZ7xkD0ZoyqmmL7ELXeI7snop3GMs
         CIUcq1V0VRl6XIUNSCYVd55KdZuF/AGot7Whyb0u8efexhz1y65CYyGL88X7D1IN3y97
         +biPRZ4mf6l8aXOpDeObPOk1aBiiTqmb9mbpMT7uE8zGz1rGJ+fJFYyKyulmleGM/5Cb
         hQgt7Z9YxeCOwYBG+J9Z0DJH0fRt0tMXhx+KTUUDdUNGyEbRT1WEiUL3BHXSTJNqsEpv
         q3U4VzY3Jt0NJoKSD0OCvePE+YCMjyosHqiF6whVM9gH0G5wgewxsup/BS4SsfnxPUIq
         st7Q==
X-Gm-Message-State: AOJu0YxEQRlmOOLFPAja7faciWvokBclsVtfOVUS4PKgw8cyeRXcyui7
	jQCuzdRnxu8hsYljcg/ktXwk5OUlXv09AEK2LUGYKdyqkkhHQGXDkJ+QJR3Us/KSGUYV7o97EY1
	UuOM732mZK3iwx1zCecFB5ndRldnb+xD+bpRxoNVdnm04NuY3ZSU4ZSwnqla9iVnmdh05BWfxDw
	wb+xbN/yJK4oazQ8kR8tYDNsd3umt5dxlXQu3h3+H8bsO6z6xjUxdCXXX6wH9vN633mL6Ahoxhr
	BpB/drMEE6hR19Gtmccia5QtMRE0ti/b5+QLq99qWxhA6mH5u4XEnT2Gf8CCauVqs01AD4xB6gT
	wcMyBi/7rZGjaGK1a1UqktsRpCOaxRC5okICYfd0AlpuVkpJt6PC15+euNDx29+Oi1IwLCBD40+
	ulYJxxRCfzlj76Q7op/smhIp1
X-Gm-Gg: ASbGncuEiUbMoZT6dsq5ltVzftDUgTL0yhQjv1K/9Gb/zW6j6xNcQKxZOPrxqJVRZBg
	sjAjkflOrahD/tF+HGgd3NGMyQZCUi7AlR0LGQLSyHQQJUc+p/zRLa0Ea4ajHmJz+rSarYFheKA
	EY4DMNyuxTyGjMwg==
X-Google-Smtp-Source: AGHT+IGMZzGJbQn2M+JIUBkEh5RD6eTxlW+LYFah5rG4D3ms6esly6cH0lvgQtkr+zBFEsKYJcLey9gtT4kURkMhaM4=
X-Received: by 2002:a17:902:ea01:b0:216:5448:22a4 with SMTP id
 d9443c01a7336-21f4e6a037dmr213747695ad.10.1739212464930; Mon, 10 Feb 2025
 10:34:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKhLTr1UL3ePTpYjXOx2AJfNk8Ku2EdcEfu+CH1sf3Asr=B-Dw@mail.gmail.com>
 <CAKhLTr08CK1pPbnahvwJWu-k1wnwVV4ztVMGrmXRY5Yuz03YeA@mail.gmail.com>
In-Reply-To: <CAKhLTr08CK1pPbnahvwJWu-k1wnwVV4ztVMGrmXRY5Yuz03YeA@mail.gmail.com>
From: "Raphael S. Carvalho" <raphaelsc@scylladb.com>
Date: Mon, 10 Feb 2025 15:34:07 -0300
X-Gm-Features: AWEUYZlSn_nHGLCmKITeKjm9ehxtqZAOMEeXOg252a-rnBJWIdsjsDJhyFDqBto
Message-ID: <CAKhLTr1-UpCWuMk2KsJ9=BLSADiRmDAtBU7LoCq6Zq4JFN2LgA@mail.gmail.com>
Subject: Re: Possible regression with buffered writes + NOWAIT behavior, under
 memory pressure
To: linux-xfs@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org
Cc: djwong@kernel.org, Dave Chinner <david@fromorbit.com>, hch@lst.de, 
	Avi Kivity <avi@scylladb.com>
Content-Type: text/plain; charset="UTF-8"
X-CLOUD-SEC-AV-Sent: true
X-CLOUD-SEC-AV-Info: scylladb,google_mail,monitor
X-Gm-Spam: 0
X-Gm-Phishy: 0
X-CLOUD-SEC-AV-Sent: true
X-CLOUD-SEC-AV-Info: scylla,google_mail,monitor
X-Gm-Spam: 0
X-Gm-Phishy: 0

> > A possible way to fix it is this one-liner, but I am not well versed
> > in this area, so someone may end up suggesting a better fix:
> > diff --git a/mm/filemap.c b/mm/filemap.c
> > index 804d7365680c..9e698a619545 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -1964,7 +1964,7 @@ struct folio *__filemap_get_folio(struct
> > address_space *mapping, pgoff_t index,
> >                 do {
> >                         gfp_t alloc_gfp = gfp;
> >
> > -                       err = -ENOMEM;
> > +                       err = (fgp_flags & FGP_NOWAIT) ? -ENOMEM : -EAGAIN;
>
> Sorry, I actually meant this:
> +                       err = (fgp_flags & FGP_NOWAIT) ? -EAGAIN : -ENOMEM;

Digging a bit more, I realized a better patch (assuming regression
indeed exists) is this one, since it accounts for ENOMEM coming from
filemap_add_folio, which might allocate in xas_split_alloc() under
same fgp flags:

diff --git a/mm/filemap.c b/mm/filemap.c
index 804d7365680c..dcf1f57e0a9a 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1984,6 +1984,8 @@ struct folio *__filemap_get_folio(struct
address_space *mapping, pgoff_t index,
                        folio = NULL;
                } while (order-- > min_order);

+               if ((fgp_flags & FGP_NOWAIT) && err == -ENOMEM)
+                       return ERR_PTR(-EAGAIN);
                if (err == -EEXIST)
                        goto repeat;
                if (err)
