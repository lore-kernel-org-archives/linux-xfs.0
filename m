Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33CB32FF175
	for <linux-xfs@vger.kernel.org>; Wed, 24 Sep 2025 12:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758715475; cv=none; b=SiZpn5aCEY1ND9UetWX4gyuuYRQJV5JdBL4Jou4IIo/dkabnXwK8iKJSCvwHUqe31GCCRDU69BnmYQjQVVR/TzJpn3DONuwammOxO0VsUuCXkSFcwSyLBDXn7Prg3XNBsiaSt2Kj5WJwUsM3hPa70cY1L/wb6LN+iryuIGfIxBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758715475; c=relaxed/simple;
	bh=9ibOWPuNdaOplH+FBy5QoeKpS1t7hE49sJQ9OEcLq4o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Lvvoc2zJMP8OsscMGGnsiqY8klXTdAkqVpcpejyaRtoC1On9/tWtUIvY97VHTnitYf3/RYWeCNloe3iQZc9U2zNSYj6/aBHX80Z35venI0940o3tGg/GzwMkT3eQHDSEWiCwftKA3/2iPVkdCvSeh+ukiqASe82E03BRQxMeqp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=gI88R5Kb; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="gI88R5Kb"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4d2686300f6so21519741cf.2
        for <linux-xfs@vger.kernel.org>; Wed, 24 Sep 2025 05:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1758715472; x=1759320272; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9ibOWPuNdaOplH+FBy5QoeKpS1t7hE49sJQ9OEcLq4o=;
        b=gI88R5KbwQep8XLJLqQ1ZJmLlTtTsZwRDdSdybaTdAofHOz79bHjwLnG0svWikFepS
         rYiXi19QelDa73KcZqFTVdRTD40ZuKEBg45FS/Qt5+9jOgn/VsW5uwccvH7B2N7UqdG/
         X0iTiTf5N6GX8E0hp2xH/yh2KLir+BG8g0yfY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758715472; x=1759320272;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9ibOWPuNdaOplH+FBy5QoeKpS1t7hE49sJQ9OEcLq4o=;
        b=RBUTeFbCpR4zHFtCuzwpdqmsdvlmaDjhMhGT5tFG70U1Bss8JLWTq6Ss0d1+0aaHTl
         C/BTADesVSu/52JL1eYa9kxHzWTEpsNf4Zr4sSrRXkPWbbTuuK19vDjEEN+AlDCGYBAk
         pLY8XgKwTNR5v73ZdtYEi25ucpY7WqXM7SS3rbKbj/XPQruerO0jBHbpEq0Ib0X0NLqy
         rY4PquJ7tspsHZzy3ArXDnW7R1ZlUnicFWRNdY+CGQrdXLq3aNLgWEY4gtyInAkHdgmS
         j0+innlM2sHE93G7mgYChA92bEhtOWZrfB5xfJsGASogOFC8y2uYLYPpdK4S1IpmqR8i
         OdXA==
X-Forwarded-Encrypted: i=1; AJvYcCWR8nY4MeEUYHbKpTJh0/6mMVIFORbxdaYJkCMxAbviH/6xJ0Z+bOxIUug0H+bOOSN+P9d0nf1hh1s=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhOBwZ1ug3r5mMxAoQXC5N82ggeXk+yBHUdW6ZusFafjzDKUAv
	gl+ICen+4/apVcR/1zyAZxs+C45amJfSFcHf3Vfqbp/i207VQC2f8404Ls46LdoTtmcFG08LLB3
	Agb89d0F6BTufEGR15gMFn7S79WVfZUh/rqdPlFq5og==
X-Gm-Gg: ASbGnctCu26oqOceW9LOxgmBWHVHrA5nnhsYpRjVGSXU2MwfP0rELGb1lyAeHpy65Qn
	X30NT8Fm1zEJ2lO2TTEzv0e5k1rAWrhP9KFrwj5v8iW4Ok+iLVQ2GnOvlyRLsOr135oB5jjTTyL
	3c5D+StqBf+Q11bNl3IuVJFLL6ljNHyyYgY3sH3twxyA7S172Uv58h60mjDhar+3UYgNeijF0Ni
	qEyjd5r3LlAVZ5q20nk03rprwp5vixGAiNtUURPh+gZ9GzEqA==
X-Google-Smtp-Source: AGHT+IFzX+IW76Y9GPEZbQ1y6EX1pULnJsvnodAmkX3ktuNW0oM3kKJxbWcPTYg+rr2jPsvmhkcmNpkPJ/6Wb9P1WbQ=
X-Received: by 2002:a05:622a:1442:b0:4d3:55f7:ddcd with SMTP id
 d75a77b69052e-4d36fdef829mr76582171cf.59.1758715472064; Wed, 24 Sep 2025
 05:04:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <175798149979.381990.14913079500562122255.stgit@frogsfrogsfrogs>
 <175798150070.381990.9068347413538134501.stgit@frogsfrogsfrogs>
 <CAJfpegtW++UjUioZA3XqU3pXBs29ewoUOVys732jsusMo2GBDA@mail.gmail.com>
 <20250923145413.GH8117@frogsfrogsfrogs> <CAJfpegsytZbeQdO3aL+AScJa1Yr8b+_cWxZFqCuJBrV3yaoqNw@mail.gmail.com>
 <20250923205936.GI1587915@frogsfrogsfrogs> <20250923223447.GJ1587915@frogsfrogsfrogs>
In-Reply-To: <20250923223447.GJ1587915@frogsfrogsfrogs>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 24 Sep 2025 14:04:20 +0200
X-Gm-Features: AS18NWDcnShhwKGclrcwGUaZj51GkpVzLGQIL0hjgTsrUfuhKR0cDZo_FZLUM_g
Message-ID: <CAJfpegthiP32O=O5O8eAEjYbY2sAJ1SFA0nS8NGjM85YvWBNuA@mail.gmail.com>
Subject: Re: [PATCH 2/8] fuse: flush pending fuse events before aborting the connection
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: bernd@bsbernd.com, linux-xfs@vger.kernel.org, John@groves.net, 
	linux-fsdevel@vger.kernel.org, neal@gompa.dev, joannelkoong@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 24 Sept 2025 at 00:34, Darrick J. Wong <djwong@kernel.org> wrote:

> Conclusion: The loop is necessary to avoid softlockup warnings while the
> fuse requests are processed by the server, but it is not necessary to
> touch the watchdog in the loop body.

I'm still confused.

What is the kernel message you get?

"watchdog: BUG: soft lockup - CPU#X stuck for NNs!"

or

"INFO: task PROC blocked for more than NN seconds."

Thanks,
Miklos
