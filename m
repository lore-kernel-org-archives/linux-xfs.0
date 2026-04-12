Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75F2363C66
	for <linux-xfs@vger.kernel.org>; Sun, 12 Apr 2026 19:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776023585; cv=none; b=LeoDEX1JodfAd7GOFm7a53Ni/Xg0+6Mx+WrAfU7YbaYe9/9HA/WcQ/P1RQK/cPjZ1lzVpofI6nQ0RvAZPn5N5j7DLCgTvRWGCPYtEuZ3qCuWNz10dIb8Gkwlxf4+e19yShx40fvyEmTGvZ2pSRiJwpVttN44mpmIB4Xprn8snbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776023585; c=relaxed/simple;
	bh=gmOF0waEiPjAeADNa5PSDARyWSDvzMIqgLwlZIt8U0Q=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WcrW3xdboi8nbdne+mypESCauPNK2xlOuIiwuZ4CMhNVvc5a2Gsu79auH8vpj01xSqQesCEjzgfgkCGq3qfVrslG81vtPZuvibVlba22d+awizJ74Zu+ieQGIvGGoxIYHwb3PmocAkA6n2zybgPo5081kCzMUSzTMjtM049OMPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Av53Numb; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Av53Numb"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-824c9da9928so2607143b3a.3
        for <linux-xfs@vger.kernel.org>; Sun, 12 Apr 2026 12:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776023584; x=1776628384; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:date:from:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MgCkg4u2Qrfr9fRJnSUD7WSR9QFXT508OS0yWkaKGsE=;
        b=Av53NumbE7+9PkBg4+CZAis10CWZ3O3DJpJu2nQdd4nRdJuPVWnR4OAv03dQh7X5uJ
         0f7fGTx0QjM2jNjal1L3DgbEVwHiJ24e92DbWQ/A+A9CIY3qgEaXNUssxPzo44+KVccI
         gxiGgZmIEcF0L9qI420yPwGAFndJ7RCA113Eadc1M4vBXFfXIgWAaLacIfA3C+Pb1b0p
         Ud9009eZh9iMqW1w/gheZx7jyqswjoG38EGFJigFUnsPc+MKjUHG8ICkoSO0DqrYSZFx
         8jLyILv5G9HJymgzLXhZ1t6fuCTK2KB/qsB4bf98PhaCV/U8+K0rxejI0ptxoqpbxhMZ
         eahQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776023584; x=1776628384;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MgCkg4u2Qrfr9fRJnSUD7WSR9QFXT508OS0yWkaKGsE=;
        b=TWnazS94n4agc4dTz31hnrUIrZXXBFqLAuuPhTCuISwlCRxXrLG4Z5Swi+8/XGtHtC
         US/Nahpkj7K5tLV5q2onT1jxLwir7Io8iJc1hRxXErANErqmy3I4qGWPtx8A65o7bsPG
         yq8sOX8BsWfNb0kvALOBlPMp2z1kNRz/hhCJLqrCLu1DoKpvRGZe0RYazZbPqoki+qUH
         BFfEeBSWiEWXoWRdFd3TY1O+o7UEfFBPUea4/oBnhiVghw8MMEjB4mu5CsD68nTfIctk
         Sjz4Nueo5zMf5A7a+1Gex9fnLommq2hJ+HG1tVInNP80m0/pox7Aixf84jYKMQ180ZOT
         ZBHg==
X-Gm-Message-State: AOJu0Yyn84RTv+h4QsGL3EqsBRg9WOj0gqwDKL0uBYz/hyOV1Q8lwmsd
	ZRGzyvr8KExuG87uSgyQPkgsLyuZt9BIWKMlWhlP9E9IT7hRjPPjuCR+
X-Gm-Gg: AeBDietiFUAG2tW8REtVuOTHX2oTihTE9F+c3R945Cu4g9r8OKJToMlmLnJunxDdaGm
	vtruy7+vmc7wLd9fFE684coFoL4YIOjWdQDSgJcWJ38+/TjJN3AQJYEu4B/vZ4eARWVGWVIKtfP
	hXAzieM5RKEkFcwApRe5KIMlUNBTDVrFauagk5EcQiQKVDVfnLE99PeMVFxCeDYif5jlAeACiGP
	q5rNv6u1pt5a3nbrzpzz7mcMPwdCNyQaYcwNlVjBcV3Pb01ttpETiFB+OiuSJjx74/DwZIq5w/e
	XOMpGVX+xfspgvUQFayVU54ASZw2XlwJfrjed4TZGkZTNZUFZB2J6itmvdxFM3VDamTXZ2uUSZA
	QQCEHCOiYHnZSuM3v71p9GMKeVHzmKqsEnezHjuaAxz2kKnxFkubKZwmPNEjlFre9rP25veUvxT
	LX697vk4DuOD7xlqgwhmRj
X-Received: by 2002:a05:6a00:2ea2:b0:829:b55e:1b27 with SMTP id d2e1a72fcca58-82f0c28b657mr11843235b3a.53.1776023583918;
        Sun, 12 Apr 2026 12:53:03 -0700 (PDT)
Received: from zlang-laptop ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c50cd34sm9449182b3a.54.2026.04.12.12.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2026 12:53:03 -0700 (PDT)
From: Zorro Lang <zorro.lang@gmail.com>
X-Google-Original-From: Zorro Lang <zlang@kernel.org>
Date: Mon, 13 Apr 2026 03:52:59 +0800
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/2] mkfs: fix assertion failure on empty data file
Message-ID: <advyLsWynjlIF40m@zlang-laptop>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>, 
	linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
References: <20260404163640.1013997-1-zlang@kernel.org>
 <20260404163640.1013997-2-zlang@kernel.org>
 <20260406152628.GC1048989@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260406152628.GC1048989@frogsfrogsfrogs>

On Mon, Apr 06, 2026 at 08:26:28AM -0700, Darrick J. Wong wrote:
> On Sun, Apr 05, 2026 at 12:36:39AM +0800, Zorro Lang wrote:
> > mkfs.xfs triggers an assertion failure, when it trys to make a xfs
> > on an empty file:
> >   # echo > emptyfile
> >   # mkfs.xfs emptyfile
> >   mkfs.xfs: xfs_mkfs.c:3852: validate_datadev: Assertion `cfg->dblocks' failed.
> >   Aborted                    (core dumped) mkfs.xfs emptyfile
> > 
> > This shouldn't be an assertion, but a warning.
> > 
> > Signed-off-by: Zorro Lang <zlang@kernel.org>
> > ---
> >  mkfs/xfs_mkfs.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 527a662f..9a93330f 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -3848,8 +3848,13 @@ validate_datadev(
> >  		if (!xi->data.isfile) {
> >  			fprintf(stderr, _("can't get size of data subvolume\n"));
> >  			usage();
> > +		} else {
> > +			if (!cli->dsize) {
> > +				fprintf(stderr,
> > +_("Warning: Empty file needs a data subvolume size by -d size=<value> option\n"));
> 
> I'm not sure why "Warning" is appropriate here -- this error is fatal to
> the program, and most fatal mkfs error messages don't have a prefix.

Oh, you're right, the mkfs.xfs command failing here is a total failure, not
just a warning.

How about:
_(Bad empty file, needs a data subvolume size by -d size=<value> option)

or any other you feel good.

Thanks,
Zorro

> 
> Other than that, the logic is sound that we need a softer landing for
> this scenario.
> 
> --D
> 
> > +				usage();
> > +			}
> >  		}
> > -		ASSERT(cfg->dblocks);
> >  	} else if (cfg->dblocks) {
> >  		/* check the size fits into the underlying device */
> >  		if (cfg->dblocks > DTOBT(xi->data.size, cfg->blocklog)) {
> > -- 
> > 2.52.0
> > 
> > 
> 
