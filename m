Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB0218A920
	for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 13:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726667523; cv=none; b=RJZBZzgrs2WQYdzwouRwU3YO74oCWiX1+OeXJorXH0RFDwpF14Wrg7oVjTj/atlRxw8QoOr2/fCeqJdwBSqGD2Zf3q9t9X1yoCM7J1hunVvgPxB/SneYxBW9uerAJ7CN+wrXypvPTSHtp1Kk1ErUl6p4SahSHVDoMy97wIkKrcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726667523; c=relaxed/simple;
	bh=jJVr2CDyy7rQp2h2UjSJiI9buPJ4d++KINwnkdK6qcA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KkVsP6AoBMfLtKV2MAUILi5ykEBetpPnaHKljH+Q0vDXhwabOfGi79sh8pBg5XPw9+SKf70sFg0uk6KqyD5wHES4yftlMV3v+SGQPD7j1fxAqmlAmx6tUiooDeVO9k03Zixzv6yYXtd34E+j8uOjJ9EBcWJaTpQm9nrzWevicHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y5QQ0Ze2; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y5QQ0Ze2"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2f759688444so59238361fa.1
        for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 06:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1726667519; x=1727272319; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+OjIl9uDxGAJUC7PJ0lAX4rCR6IE5m7Lsi7Ws5gE7Fw=;
        b=Y5QQ0Ze2C2/Lyp3vpbQlEVIwUiAcRTMyC8tJNNyncaeNz+Fp9s60R858g9u6hMDnwA
         AG39e/vi9vbeT1LhsUCquDaK8DqKRQ392I6QMniUMEHf3SR/6m0FPa3ma7R5Tm0R5uN3
         0mscOYZU5Q5pn4BoUEg60al7/N2nqkeIZ1PL8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726667519; x=1727272319;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+OjIl9uDxGAJUC7PJ0lAX4rCR6IE5m7Lsi7Ws5gE7Fw=;
        b=oAItnL5H0PaJ9tLb8Gs0UXZFs0Dx2Jnm08C+Pfle+PMe5MbkveKU15lzG3sOU7wlrO
         UTcepwQcetwBlA3QmKGjyECkMc+X11mF2P4Wh2hPN/Vicd4vNnRNPgwsYgu8CSlrH8J3
         JXo8/H4Q8hc9t66+gKLQoO8ZFR9o2R86aPBePgHQz6cqK569cF6eA1l5uH3lYJTJWB0U
         FVmAxKsjoyO2jeetD49jR+kbrKvzjOw1/PN8edpFu8hBXED4Gzwc4M9CJBRfqNDQ7vNz
         bggY5/DMb0WZZP06zHU+MumGc+UEnAI47BZn2jIJ1gAOZFAc1zB3aX819oUAI7MUP8Yq
         T7Xg==
X-Forwarded-Encrypted: i=1; AJvYcCXP8z3a1txdtxiy4nxPxiQFoRErqp/dTJGhT8TIrFhuqI+WwKaVMqpfifoqWPi5SeM2MgyH1CglF6c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzrzsd3V/Pb6pENLiJIW8IZYU/usP+8b4DVS7vXnYv3Wcy54BC0
	7uj2i8wFN95LER/XPS09+5sVhDtXEA5T449VYzx1DIjh/41LkOzb65u2uahCPpZtX5sQ1NUwNf+
	Nr31cVw==
X-Google-Smtp-Source: AGHT+IH95ejrDwcT9+n8qjui4Y4KzcJZFRnaQK/SO1YokHA3rjCu7XeMcHl/Fhc8NhZPwVWw4faAzA==
X-Received: by 2002:a2e:4c12:0:b0:2f7:6277:f2d8 with SMTP id 38308e7fff4ca-2f787ee1e85mr93915221fa.25.1726667519255;
        Wed, 18 Sep 2024 06:51:59 -0700 (PDT)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com. [209.85.167.49])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2f79d2e1deesm13528321fa.10.2024.09.18.06.51.57
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Sep 2024 06:51:57 -0700 (PDT)
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-536584f6c84so8662441e87.0
        for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 06:51:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX5uB61JqDULflBzqY/KjJ3g854uSWwcDlHgxpPrP086msmjc9XH4W0RXq0Mb3K1mrhlw2/xyfhFoc=@vger.kernel.org
X-Received: by 2002:a05:6512:4019:b0:52e:fc7b:39cb with SMTP id
 2adb3069b0e04-53678fce759mr13328998e87.26.1726667516650; Wed, 18 Sep 2024
 06:51:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0fc8c3e7-e5d2-40db-8661-8c7199f84e43@kernel.dk>
 <CAHk-=wh5LRp6Tb2oLKv1LrJWuXKOvxcucMfRMmYcT-npbo0=_A@mail.gmail.com>
 <Zud1EhTnoWIRFPa/@dread.disaster.area> <CAHk-=wgY-PVaVRBHem2qGnzpAQJheDOWKpqsteQxbRop6ey+fQ@mail.gmail.com>
 <74cceb67-2e71-455f-a4d4-6c5185ef775b@meta.com> <ZulMlPFKiiRe3iFd@casper.infradead.org>
 <52d45d22-e108-400e-a63f-f50ef1a0ae1a@meta.com> <ZumDPU7RDg5wV0Re@casper.infradead.org>
 <5bee194c-9cd3-47e7-919b-9f352441f855@kernel.dk> <459beb1c-defd-4836-952c-589203b7005c@meta.com>
 <ZurXAco1BKqf8I2E@casper.infradead.org>
In-Reply-To: <ZurXAco1BKqf8I2E@casper.infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 18 Sep 2024 15:51:39 +0200
X-Gmail-Original-Message-ID: <CAHk-=wjix8S7_049hd=+9NjiYr90TnT0LLt-HiYvwf6XMPQq6Q@mail.gmail.com>
Message-ID: <CAHk-=wjix8S7_049hd=+9NjiYr90TnT0LLt-HiYvwf6XMPQq6Q@mail.gmail.com>
Subject: Re: Known and unfixed active data loss bug in MM + XFS with large
 folios since Dec 2021 (any kernel from 6.1 upwards)
To: Matthew Wilcox <willy@infradead.org>
Cc: Chris Mason <clm@meta.com>, Jens Axboe <axboe@kernel.dk>, Dave Chinner <david@fromorbit.com>, 
	Christian Theune <ct@flyingcircus.io>, linux-mm@kvack.org, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Daniel Dao <dqminh@cloudflare.com>, 
	regressions@lists.linux.dev, regressions@leemhuis.info
Content-Type: text/plain; charset="UTF-8"

On Wed, 18 Sept 2024 at 15:35, Matthew Wilcox <willy@infradead.org> wrote:
>
> Oh god, that's it.
>
> there should have been an xas_reset() after calling xas_split_alloc().

I think it is worse than that.

Even *without* an xas_split_alloc(), I think the old code was wrong,
because it drops the xas lock without doing the xas_reset.

> i wonder if xas_split_alloc() should call xas_reset() to prevent this
> from ever being a problem again?

See above: I think the code in filemap_add_folio() was buggy entirely
unrelated to the xas_split_alloc(), although it is probably *much*
easier to trigger issues with it (ie the alloc will just make any
races much bigger)

But even when it doesn't do the alloc, it takes and drops the lock,
and it's unclear how much xas state it just randomly re-uses over the
lock drop.

(Maybe none of the other operations end up mattering, but it does look
very wrong).

So I think it might be better to do the xas_reset() when you do the
xas_lock_irq(), no? Isn't _that_ the a more logical point where "any
old state is unreliable, now we need to reset the walk"?

                   Linus
