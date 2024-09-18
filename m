Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4EB1BAEEF
	for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 14:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726670441; cv=none; b=BahqR4Am+neD1x08yv5wfJKbT8Dck0SjdyrEaaQOMKo9vCa3CUnViTaU1vAA1H/isrqspB6zlHQSnbPmpeoMuJhRJ0nOtYWoFWuNS7/C9YVFkFHrcJ6yKI604ttBxSGdMp+jVSVVvshRFMmgy6NTOqIw5aFNZylwkYdwApcnfag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726670441; c=relaxed/simple;
	bh=mT3ohME7te8T2As9CrdpUmPIESVaDC3Cl9Dhcw5IwvA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KCQBgePUcqaT539lyL6QZfvcn/YBeq9QenonLmQ7dgsypro/PEivrxTeeSBH+sbxceBrCCZk2sGl3Hm7o0jIpLNa7IKWrBqBNNEbK1lsLjhP/CD2nvr2ik2an4tOa8H6gJz+YbueulR+UISpSrFDJePL3K2uyGdmChyH3LeuTdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HUcnHx+Q; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HUcnHx+Q"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a8a7596b7dfso153780566b.0
        for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 07:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1726670437; x=1727275237; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2t1ItWJ3ig5qNarueJWrYx/kj01x5BbGfjJ8rjmQF4o=;
        b=HUcnHx+QUHCiwb1RvbDZkjP/J+G9NvAQjfzMhtuHUVsN6Jt0thzUyiMRRrYD28c73m
         QRM8deO3IDjl5nstdABwCz6d5ZyjN9rLytENWm3BiNQrKNeWex7cPbw0rhqPuYI0RAm3
         7f2bZCqAR6mGX4Wu102mBUFRf5o517eapNynk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726670437; x=1727275237;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2t1ItWJ3ig5qNarueJWrYx/kj01x5BbGfjJ8rjmQF4o=;
        b=bsyrrNLYTxX8vPT7KPC/8nLsRufuo1f1vAVh25u+oIgQD6j/jLtSuTJfvZyHapP/oz
         c1A0RIWsJjhXJYyT7vEYOTOmpgQMC6sjfwxkmw0LsUXkVI7OWIryss9BTm6kKbczTnmj
         iM5xLpP3OiuVP3N5RxVOlpDqfjZq85MSjg81Tu4W/I0BV6LrLcHcDCsotST8pj1qIxIC
         I5MgfO3iICqUl9fUy/MvVYxbD6/aRuPeKe6d3l29gEBXZxig6M7B9wpLhRDeT1JFBBcf
         xbBKwoHdBuV4EZmlghi4YV6JkUq+o7O6fZKradZNI2sjV/D+IXs6VZ9sNoPE26LaLro1
         tZqA==
X-Forwarded-Encrypted: i=1; AJvYcCXSdgTgIg3JmonIcvA0daL3RsquVHqJzhvH8qac19tkHIUHd7jSPlr/uzClLWeeXPeWoFE7cHLO/t8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMob35hwSyR9E9ppvXGZAnfIpZvHivCtu74l8Nh/2vo77DxUqi
	xm1o899/Iq/5j3XxyzZxmMhNRo+zBzHD10gHHbiTtp2PyhK9Ygll3Pb5YqDL/xHnjSL2Tp59glB
	ufsi5mw==
X-Google-Smtp-Source: AGHT+IHNw0xGRLuWrhM7eDrAWF4KsUdgthEPgIDunGNnj3IhU08lg8Lj50IyGzticIu5RGgaDdvAwg==
X-Received: by 2002:a17:907:9721:b0:a80:c0ed:2145 with SMTP id a640c23a62f3a-a902a3d105cmr2544015666b.2.1726670437090;
        Wed, 18 Sep 2024 07:40:37 -0700 (PDT)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com. [209.85.208.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a90610f151esm599767266b.48.2024.09.18.07.40.14
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Sep 2024 07:40:22 -0700 (PDT)
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5c24ebaa427so1392703a12.1
        for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 07:40:14 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX0ZorDjjAVINTr3JhfQee9sQZgivhYdkjYkEe8IeomFCNG3R7b9vZv4cPTwUcmBDYv1Sq8Y7Fm4kI=@vger.kernel.org
X-Received: by 2002:a05:6402:2189:b0:5c4:178a:7162 with SMTP id
 4fb4d7f45d1cf-5c4178a7270mr24593373a12.19.1726670413894; Wed, 18 Sep 2024
 07:40:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Zud1EhTnoWIRFPa/@dread.disaster.area> <CAHk-=wgY-PVaVRBHem2qGnzpAQJheDOWKpqsteQxbRop6ey+fQ@mail.gmail.com>
 <74cceb67-2e71-455f-a4d4-6c5185ef775b@meta.com> <ZulMlPFKiiRe3iFd@casper.infradead.org>
 <52d45d22-e108-400e-a63f-f50ef1a0ae1a@meta.com> <ZumDPU7RDg5wV0Re@casper.infradead.org>
 <5bee194c-9cd3-47e7-919b-9f352441f855@kernel.dk> <459beb1c-defd-4836-952c-589203b7005c@meta.com>
 <ZurXAco1BKqf8I2E@casper.infradead.org> <CAHk-=wjix8S7_049hd=+9NjiYr90TnT0LLt-HiYvwf6XMPQq6Q@mail.gmail.com>
 <Zurfz7CNeyxGrfRr@casper.infradead.org>
In-Reply-To: <Zurfz7CNeyxGrfRr@casper.infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 18 Sep 2024 16:39:56 +0200
X-Gmail-Original-Message-ID: <CAHk-=whNqXvQywo305oixS-xkofRicUD-D+Nh-mLZ6cc-N3P5w@mail.gmail.com>
Message-ID: <CAHk-=whNqXvQywo305oixS-xkofRicUD-D+Nh-mLZ6cc-N3P5w@mail.gmail.com>
Subject: Re: Known and unfixed active data loss bug in MM + XFS with large
 folios since Dec 2021 (any kernel from 6.1 upwards)
To: Matthew Wilcox <willy@infradead.org>
Cc: Chris Mason <clm@meta.com>, Jens Axboe <axboe@kernel.dk>, Dave Chinner <david@fromorbit.com>, 
	Christian Theune <ct@flyingcircus.io>, linux-mm@kvack.org, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Daniel Dao <dqminh@cloudflare.com>, 
	regressions@lists.linux.dev, regressions@leemhuis.info
Content-Type: text/plain; charset="UTF-8"

On Wed, 18 Sept 2024 at 16:12, Matthew Wilcox <willy@infradead.org> wrote:
>
>
> That's actually OK.  The first time around the loop, we haven't walked the
> tree, so we start from the top as you'd expect.  The only other reason to
> go around the loop again is that memory allocation failed for a node, and
> in that case we call xas_nomem() and that (effectively) calls xas_reset().

Well, that's quite subtle and undocumented. But yes, I see the
(open-coded) xas_reset() in xas_nomem().

So yes, in practice it seems to be only the xas_split_alloc() path in
there that can have this problem, but maybe this should at the very
least be very documented.

The fact that this bug was fixed basically entirely by mistake does
say "this is much too subtle".

Of course, the fact that an xas_reset() not only resets the walk, but
also clears any pending errors (because it's all the same "xa_node"
thing), doesn't make things more obvious. Because right now you
*could* treat errors as "cumulative", but if a xas_split_alloc() does
an xas_reset() on success, that means that it's actually a big
conceptual change and you can't do the "cumulative" thing any more.

End result: it would probably make sense to change "cas_split_alloc()"
to explicitly *not* have that "check xas_error() afterwards as if it
could be cumulative", and instead make it very clearly have no history
and change the semantics to

 (a) return the error - instead of having people have to check for
errors separately afterwards

 (b) do the xas_reset() in the success path

so that it explicitly does *not* work for accumulating previous errors
(which presumably was never really the intent of the interface, but
people certainly _could_ use it that way).

             Linus
