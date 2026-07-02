Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96145433E99
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 16:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783008868; cv=pass; b=q/5yFTxZCigsUnUF4hNLsIhaQ28O0LgQl6eVfAZZxcPbEA8jVaSNHMZiU/+ScNBKJExv8I4dN7ZsDliADuNVxzRaXTC+Z0UnDC/gIk9WxPTol3n2hLkIiWKX/4x/XSRvB7lA4I5MA8ojAFS3IyP4HUfXsmag5M6s3gEug/vTSvg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783008868; c=relaxed/simple;
	bh=K4XvDZLqwMfq3cmMPQEaqvs3wD9qaln26TJcaFU/vyU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sIQqdgva3rvnQu0KXx79taB4kmIK6ahQGzA3Vrx/yyVy1VSp7Pn04Oz056ODNO1tW9CcN5/9MlcY7UHXrTaOyA4va7+bY8ZDaBZnBC1BLdJ/pzUOVFAE3mpZjG5bhy4GCdeCx7v6GDHxgwZJiuPNqelQxd42cjNGEkwPUCvLVDE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=baahGdMT; arc=pass smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="baahGdMT"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c029505b389so117912966b.1
        for <linux-xfs@vger.kernel.org>; Thu, 02 Jul 2026 09:14:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783008866; cv=none;
        d=google.com; s=arc-20260327;
        b=VHpAEaf0El/8pCqphr2IrVM+193QpMCEFoeGreh9uhmf5XffJyKO3JXsbqF4uKIKGx
         HvgtkdvX0YWYvpr6+SyWfQHIx4jugUV/MY5lmASAPAo2Ffwwy38QBfgA3ihnxI1Qolpa
         h4Nh07Iobsili/S4cQCq/7cIsoa6AuDjlYQu33yhjuaGa3wvWXhJfwt6rsPF1Yym3K3M
         FlbkiiZ5iZa/fovhjoTgDKKpKH8Nw3lGFSvAtXhnOTc9qLReqFKFKaEXbdnpE35EpN9g
         zNc2wZPlMiHCEMN6v37RyDRm62dixZfIEl2/pb0KNtPGfvBBwp7cyD0l8St5q1BrEGe9
         A0/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=D6UG2VU5THPXNW0USN8gjUg4E9lQRbe+JjGsVq4Rxqg=;
        fh=ozGSy/dJMlKYAcoEGwPAj/urggh3DrTRsqmldHKiS/U=;
        b=DSWGetD4p9ecAZv93zSs+sdB67BcsKqlvTbGw/LB2ZY6ep7Wob/h6teDx8elSNrwFw
         FW2Hu2xu4r+oS4VKEcuDHJiYDalfyVZZ5tD+GJWmXsEjmMDyQlYuVQasA5cMTrOhkoJw
         Vb8VvbHCrWY65nZi+VudgwfTmxOcWRB2zLjSSrcwx81sCBPdH3AWkB3ZvFegBl3ya9FB
         LtDlyDvWJaRLNGYBaUgH4WiNyasSAzGj44vkFsMplm7iL9dm8n9l9dfqtDUvSbFnZc56
         RVZyQ30lPkZ2bxImL1WL5zLC0ttQFrESCIhsmQAwtzureJ/g/PwTAt5SuQHPXU2HfV8G
         NafQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783008866; x=1783613666; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D6UG2VU5THPXNW0USN8gjUg4E9lQRbe+JjGsVq4Rxqg=;
        b=baahGdMT5kThNp0lQZV9T46ShvPF8//jKSPBr0blxRI+eCmrXbLTnjt9cLc0RtyV1A
         iFfZkxbUL88ejBEenzHNdprp2/RGX5AvJGFMt+yMpoRZR+sGRxt3W1sCM2nkvcLktu+r
         CZIWZHeqBiwpyjOwL5GZuyUNE2PWbAz0bPymPd65kSW/QuGapIdzMV82uLNjt8oiaXm6
         Oip/gS/ZwJaLbXVYbAC8sNxER6WuUFY9BZXE8UMh58944ObQjzBlRTiaPq6SBxJYXBS1
         ++aazV9Fhux5jP6370sD00hUFkMUIfNGy+P7OskuRdVCkJmJZhJEQwGmE9vLoy8YEFeV
         kILQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783008866; x=1783613666;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D6UG2VU5THPXNW0USN8gjUg4E9lQRbe+JjGsVq4Rxqg=;
        b=PFRytpDVPXXHJHVqxwJKkjmauLqTJHOfpPneCbuYTHHq0VqtHJA+CqzycFxMeax90M
         8QMhgFAd1vIZ/1QhfctZp2ZjJSkSApLzt4To6cko3wOMyffRKkx8jrGwnK3rlfT+02a1
         705jTEpygMf91BaLtVMa+Sk9F2QI9DM1kXPegFBI0nsUoAGn37CTgJ5Ct9j4Bs1ngg6j
         80M9zadiykRHp88HFpb8U9VTH8PnTWt6fTaRQtJEUbkSKESKQVEsavTbbU22BAq8FMKk
         SIeLmTuEwm+jlgKr2XI2tXACUTvAV0f5QtKFTPIdqlJ04jI7z0bY+uN3VdNz/U8+KUlP
         rUPQ==
X-Forwarded-Encrypted: i=1; AHgh+RqWQTlfP6DL+MC5noBBEPR6q/BKLQmWI01P5bkijlsguFk9s4RRCzgeajAF+5WW2ZM77k5Ix1bwLjU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2aYPyd3y9sb4YZb4x9c4Pyl9bJhAJT2HI4HjxdBHRLeBydvEJ
	8xV+CDrLuanN72I4PuZh+L8+Ht+EozTb6JCy4J/9p8ZX2FkDkQPxC6Yvl5qB19goVVo5LfgtpHs
	zD3DiePCBYGV6JkNMy9bVP0mY+8ByJ2EthRqBfx4=
X-Gm-Gg: AfdE7ckIitpP3GoMlxtCaoQtVq4wXBXqGe/Or9UG2KKCBqoCekomu41czQZv9IX49C8
	4loVd551WNkr0EkVqj62/Os4s8V/02U0mn6XVcH+ljTSFIdGGZs2Dy2c8B4vpxgU0HTX1Zf8iSU
	V+RUtRBzSJlpUfqfg3gyPs0/Pec+R61BlAqOa0tvWA3L+Q1SS1jpRYkSJlo0oCJlNZybykx8Awr
	Qd0DqhQSM64DQzq9qcpf4IkcjMA4wq4XakhDrDFui1NIB6ND908BGbkQBHNoY6DKEvWjzGA5eJP
	S9INlJIof3CG+yR3v/NPjVh/ZXnEmCnzYFQ5tSQ=
X-Received: by 2002:a17:907:3d4d:b0:c12:70af:a5f9 with SMTP id
 a640c23a62f3a-c12c9f7a154mr28562966b.31.1783008865692; Thu, 02 Jul 2026
 09:14:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260701153833.3155514-2-bestswngs@gmail.com> <20260701153833.3155514-5-bestswngs@gmail.com>
 <20260701220838.GI6526@frogsfrogsfrogs> <akZD87nbm6q0KXrP@infradead.org> <20260702153242.GB9392@frogsfrogsfrogs>
In-Reply-To: <20260702153242.GB9392@frogsfrogsfrogs>
From: Weiming Shi <bestswngs@gmail.com>
Date: Fri, 3 Jul 2026 00:13:47 +0800
X-Gm-Features: AVVi8CdjAdHFATgajK9jNVvjr5-t9wwk2zH3N6WkAlb11zwNRxpCUDZGqkM1uxk
Message-ID: <CANgPUi1SM9vnZf6RuqayFsxatgvKPNQurHR9U-TwqoOW4e2uaQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] xfs: fail recovery on a committed log item with no regions
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, 
	Carlos Maiolino <cem@kernel.org>, Brian Foster <bfoster@redhat.com>, Xiang Mei <xmei5@asu.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Darrick J. Wong <djwong@kernel.org> =E4=BA=8E2026=E5=B9=B47=E6=9C=882=E6=97=
=A5=E5=91=A8=E5=9B=9B 23:32=E5=86=99=E9=81=93=EF=BC=9A
>
> On Thu, Jul 02, 2026 at 03:56:51AM -0700, Christoph Hellwig wrote:
> > On Wed, Jul 01, 2026 at 03:08:38PM -0700, Darrick J. Wong wrote:
> > > I agree that a totally empty log item is a sign of corruption, or at
> > > least something going seriously wrong.  Can the runtime log code ever=
 be
> > > tricked into emitting a bare transaction header?
> >
> > I don't think so.  This looks like an automated search for bugs in the
> > parser.  And while I'm happy about tightening up all parsing, I still
> > think this should be stated in the commit log much more clearly.
>
> Yes, it could at least state whether this is a code change because the
> author hit a crash in practice vs. running some tool that pointed out a
> gap and emitted a reproducer.
>
> --D

Hi,

It came from an AI-assisted code audit of the log recovery parser. I'll
state that in the v3 changelog.

Best,
Weiming Shi
