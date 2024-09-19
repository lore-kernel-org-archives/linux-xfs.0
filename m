Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E0418F2E3
	for <linux-xfs@vger.kernel.org>; Thu, 19 Sep 2024 06:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726729071; cv=none; b=lhhkK0oW2ixW0rnT1KtbMhedfdcbTiJR6m40HQPW729hydLbWuPYlAoBq1CICXL6WQZKNiLZX4OpcpNuzqx/FK9ylS49K7ZYpZBD4tVhe0Og2lWNRMkn9QlbyhS/dEMN7ByimSGOM1TVAQ8rddFZdeGZeN70x5+uqVRmsLfo+pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726729071; c=relaxed/simple;
	bh=T42I0lRZBaFB9187EeGtKoTYqZo584h9kb6/EqVjmtE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EEoVQLhjjHw044XtVc/i3fdShz11t7JATaxBmnYJ6tS8Cd2ZxWWWPSjYI55AYFeneGcYK/10L6zcwdRbUpkQmaL1CG+hU8ewbtsAX60k2axEweMRgPB7QAqimIbvQ8dTLedM3TLrp6av+o8uL62/rj3QFbdUMcgsPgabuMUqOEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SpEr+eq3; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SpEr+eq3"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5c25554ec1eso624715a12.1
        for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 23:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1726729067; x=1727333867; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5TUPhH68J4aIRtGndcy4NXpmyIlQij++uMUQdRa57QE=;
        b=SpEr+eq3/HQ76fT8RajuijqMzOA6bqekax+/as/obHB1a77UjrN5y1LJrrFqfcCIK7
         AcxmtSLzvY3ZQSDCZOfg0DR819lly9TCQbo2PuO8eentFY4zmIAZ2PVpe0y2mTlSv0gM
         nFQVT0QYN3rgJtORcJUYDcrQHBUc2xJOcYc2M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726729067; x=1727333867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5TUPhH68J4aIRtGndcy4NXpmyIlQij++uMUQdRa57QE=;
        b=OpqSNgZlkVFpxYLhR6iLrn/0hDNwFNyoQMgUAA9N6/BgSgh5RIuarnN/GRof0R/X4C
         Eg/bUWcSlOoyI9+AuBHMNAEhdQYBcOiGaH+aLehONbwz9J7g0vI2Q4myd6Y2tnM+bVOQ
         iwEcouybo1SScnCiY5LsPI+6DjdWMhXygK8haCrzDTZEZ9w1nMD2s2aKUwjAwTJBwkQz
         tAX/fHDeCowqh5bfDyDeu4VevX+3vvFv6l6Za84Ko/4XrierBQ44q9QwMAJBDAcU7yA0
         P86/0UcQQcR47R7sz5Z/OVhyl+ApTfoWq22LTh9EVIoA4F8JjVRMMb56li7f2Ss7p6ds
         31qg==
X-Forwarded-Encrypted: i=1; AJvYcCXVP4yveHlB/UfP3HFbDHNmP0pMJ3n8QPUTyk/mrM8UeCwar5ccbWwAr2Co8rXja3q/k6c5zSGLA1M=@vger.kernel.org
X-Gm-Message-State: AOJu0YyP/V9eibnuhmROnCQyUT+ISYDjUK9Jp3Va3GXzZMlXAngCDnW2
	5CEC29chH0VcFol4HPUDZkaVeJGrvo/ZMbQyzarSFBV7kvQpg7eq7GJijtB8MgkCRmd8QmhsMF0
	U48nyiQ==
X-Google-Smtp-Source: AGHT+IEhlzkFXrHMmgRqANnI3OiuDd525dqeo851xhgc2yviRCCmjNvj3jvnWnCXOoOoPPZFyz0/aw==
X-Received: by 2002:a17:907:c882:b0:a89:c8db:3810 with SMTP id a640c23a62f3a-a9029492510mr2563948666b.30.1726729067485;
        Wed, 18 Sep 2024 23:57:47 -0700 (PDT)
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com. [209.85.218.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a90612df4d3sm685811566b.144.2024.09.18.23.57.46
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Sep 2024 23:57:46 -0700 (PDT)
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a8ce5db8668so68342566b.1
        for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 23:57:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVMFLQxeEUD1BJ71CkdHfPebqIUPFbJCIQP8u+3ytRTir1Qz0URQgAPsujUJ9NctnsXvhZ47HqIR7I=@vger.kernel.org
X-Received: by 2002:a17:906:f5a7:b0:a86:a56a:3596 with SMTP id
 a640c23a62f3a-a9029678cbemr2701906566b.60.1726729065735; Wed, 18 Sep 2024
 23:57:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHk-=wh5LRp6Tb2oLKv1LrJWuXKOvxcucMfRMmYcT-npbo0=_A@mail.gmail.com>
 <Zud1EhTnoWIRFPa/@dread.disaster.area> <CAHk-=wgY-PVaVRBHem2qGnzpAQJheDOWKpqsteQxbRop6ey+fQ@mail.gmail.com>
 <74cceb67-2e71-455f-a4d4-6c5185ef775b@meta.com> <ZulMlPFKiiRe3iFd@casper.infradead.org>
 <52d45d22-e108-400e-a63f-f50ef1a0ae1a@meta.com> <ZumDPU7RDg5wV0Re@casper.infradead.org>
 <5bee194c-9cd3-47e7-919b-9f352441f855@kernel.dk> <459beb1c-defd-4836-952c-589203b7005c@meta.com>
 <ZurXAco1BKqf8I2E@casper.infradead.org> <ZuuBs762OrOk58zQ@dread.disaster.area>
 <CAHk-=wjsrwuU9uALfif4WhSg=kpwXqP2h1ZB+zmH_ORDsrLCnQ@mail.gmail.com>
 <CAHk-=wgQ_OeAaNMA7A=icuf66r7Atz1-NNs9Qk8O=2gEjd=qTw@mail.gmail.com> <E6728F3E-374A-4A86-A5F2-C67CCECD6F7D@flyingcircus.io>
In-Reply-To: <E6728F3E-374A-4A86-A5F2-C67CCECD6F7D@flyingcircus.io>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 19 Sep 2024 08:57:29 +0200
X-Gmail-Original-Message-ID: <CAHk-=wgtHDOxi+1uXo8gJcDKO7yjswQr5eMs0cgAB6=mp+yWxw@mail.gmail.com>
Message-ID: <CAHk-=wgtHDOxi+1uXo8gJcDKO7yjswQr5eMs0cgAB6=mp+yWxw@mail.gmail.com>
Subject: Re: Known and unfixed active data loss bug in MM + XFS with large
 folios since Dec 2021 (any kernel from 6.1 upwards)
To: Christian Theune <ct@flyingcircus.io>
Cc: Dave Chinner <david@fromorbit.com>, Matthew Wilcox <willy@infradead.org>, Chris Mason <clm@meta.com>, 
	Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Daniel Dao <dqminh@cloudflare.com>, 
	regressions@lists.linux.dev, regressions@leemhuis.info
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 19 Sept 2024 at 08:35, Christian Theune <ct@flyingcircus.io> wrote:
>
> Happy to! I see there=E2=80=99s still some back and forth on the specific
> patches. Let me know which kernel version and which patches I should
> start trying out. I=E2=80=99m loosing track while following the discussio=
n.

Yeah, right now Jens is still going to run some more testing, but I
think the plan is to just backport

  a4864671ca0b ("lib/xarray: introduce a new helper xas_get_order")
  6758c1128ceb ("mm/filemap: optimize filemap folio adding")

and I think we're at the point where you might as well start testing
that if you have the cycles for it. Jens is mostly trying to confirm
the root cause, but even without that, I think you running your load
with those two changes back-ported is worth it.

(Or even just try running it on plain 6.10 or 6.11, both of which
already has those commits)

> In preparation: I=E2=80=99m wondering whether the known reproducer gives
> insight how I might force my load to trigger it more easily? Would
> running the reproducer above and combining that with a running
> PostgreSQL benchmark make sense?
>
> Otherwise we=E2=80=99d likely only be getting insight after weeks of not
> seeing crashes =E2=80=A6

So considering how well the reproducer works for Jens and Chris, my
main worry is whether your load might have some _additional_ issue.

Unlikely, but still .. The two commits fix the repproducer, so I think
the important thing to make sure is that it really fixes the original
issue too.

And yeah, I'd be surprised if it doesn't, but at the same time I would
_not_ suggest you try to make your load look more like the case we
already know gets fixed.

So yes, it will be "weeks of not seeing crashes" until we'd be
_really_ confident it's all the same thing, but I'd rather still have
you test that, than test something else than what caused issues
originally, if you see what I mean.

         Linus
