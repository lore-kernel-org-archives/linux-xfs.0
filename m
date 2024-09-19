Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40077125DE
	for <linux-xfs@vger.kernel.org>; Thu, 19 Sep 2024 03:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726715602; cv=none; b=iLfhGmPDuSUpPODNI70tmyGk85PFrDHUFkduZoTj0prRf4IXX9XBlnoOp0ejflyZYNPE3cnJs7xUxPzlcwKT5bZBm4SbR8t7M3dOqohaNvLtrQIkBLvGsbu8+X4eowkWFPYOjc9lGZGynaEygGqE6XDLxaRbl1+Gt7u1fUyK8Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726715602; c=relaxed/simple;
	bh=9V2+zbwm8Yz+r58UL9q8WQFB/wy+TQMYxqZgi3T/d3g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hpmfXPyDHzpol9bWT5P211ebtD7exwdMIctpQUTo+HqAuihu5sVZKcVWjROoS2nYzuM+jvAvZPrygsAeI5qSwsf1NeOmOR6jP/LV0swdMITapQGqHCMVACsG+GoZwDVu/Ap4ByLQImmPuH8N3w5NErX7+lJ3Z3JECftxMOlHqjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z5NY6D81; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z5NY6D81"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a8a7cdfdd80so38717666b.0
        for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 20:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1726715599; x=1727320399; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wcLLwAFuhFyJrwjWn6iH7R74N7ls/NAjmWUt4uQ7SSo=;
        b=Z5NY6D81bIpdfHw2NosgMR7SH9Oux8BtJnPJSBlFP+Yo3V+QFX3ek4DhYeu32acq+f
         k0uQ6UAChVZzEZ7qez/x1T/TpQCYb1Ov426eY/oMHYZCightbyO/UjredNmM42O+fN00
         apsc7cX5b1IBE4F2eQSgg56SQjfgL5Nxr6mJ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726715599; x=1727320399;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wcLLwAFuhFyJrwjWn6iH7R74N7ls/NAjmWUt4uQ7SSo=;
        b=YxN7gqLfhpZp9Ox8mAO1wMKhrA6zek8tglbvKy7pmjvA9ZZ/TlClJy6pc7j+L1i0yX
         18mW0Xy/LQ67D5J1p/8gNOYJX4mr5G46nbyttcrVRKyRX6sAjf6rLpy/1sghV2kWIDK7
         YqIEUw4u+i+tkvKPlTDT1SUaMiRscmil9OCRSXi4xOybUPashCF9cy3Esu0aneykPDw5
         sTrtCmdFbfQUokBxpECxztHHC3sNjZIqLs7tIYF9IFlsv4y9LDH1CKUw/K+3eeg7YQFj
         i28qnRtOU4QUpj3IYeYdW2cKSlZllkNvubFi9HupAlZ37dgHvE3/zgDp/wpqe1xYd7Cj
         WsXA==
X-Forwarded-Encrypted: i=1; AJvYcCXD9GKpt/Jw9kHhmhi+tQ4AwNioKgbDKO2W6aO9Ibr1bXikOhTdPkSjcdosB0iGRdhLxqwtpYyj1H8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZNpGhDPTOnwVhyidn/yh8+5do6Sdtg9ftfU+1824eMKBNYQPq
	gLI4ojkf4TG5y3yTH+ksMvXJzjDafxIALujh5wSeAratDQ0r09xbTx6gBLAQuAoe6vh1lPnt0fr
	BH0LF4A==
X-Google-Smtp-Source: AGHT+IEfJXHXbekuPHormRvg3R3cSyYHMjdIIL2uXmThVWi6ygkxnptnB9e5ytNRjVc/kyXNEeaB8A==
X-Received: by 2002:a17:906:fd83:b0:a8d:4e24:5314 with SMTP id a640c23a62f3a-a9047ca4111mr1798246266b.24.1726715599249;
        Wed, 18 Sep 2024 20:13:19 -0700 (PDT)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9061331912sm659429066b.224.2024.09.18.20.13.16
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Sep 2024 20:13:16 -0700 (PDT)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5c2561e8041so437553a12.2
        for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 20:13:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXcAzPoS3S4nBrsOaCuK9T+pJzx2i1KGcVS/eFQnwcg259LWEMdssbPrQVVBPWxnR3Q9xNK8jD2F3Y=@vger.kernel.org
X-Received: by 2002:a17:907:6e8b:b0:a89:f1b9:d391 with SMTP id
 a640c23a62f3a-a9047c9c504mr1768413466b.14.1726715595791; Wed, 18 Sep 2024
 20:13:15 -0700 (PDT)
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
In-Reply-To: <CAHk-=wjsrwuU9uALfif4WhSg=kpwXqP2h1ZB+zmH_ORDsrLCnQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 19 Sep 2024 05:12:59 +0200
X-Gmail-Original-Message-ID: <CAHk-=wgQ_OeAaNMA7A=icuf66r7Atz1-NNs9Qk8O=2gEjd=qTw@mail.gmail.com>
Message-ID: <CAHk-=wgQ_OeAaNMA7A=icuf66r7Atz1-NNs9Qk8O=2gEjd=qTw@mail.gmail.com>
Subject: Re: Known and unfixed active data loss bug in MM + XFS with large
 folios since Dec 2021 (any kernel from 6.1 upwards)
To: Dave Chinner <david@fromorbit.com>
Cc: Matthew Wilcox <willy@infradead.org>, Chris Mason <clm@meta.com>, Jens Axboe <axboe@kernel.dk>, 
	Christian Theune <ct@flyingcircus.io>, linux-mm@kvack.org, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Daniel Dao <dqminh@cloudflare.com>, 
	regressions@lists.linux.dev, regressions@leemhuis.info
Content-Type: text/plain; charset="UTF-8"

On Thu, 19 Sept 2024 at 05:03, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I think we should just do the simple one-liner of adding a
> "xas_reset()" to after doing xas_split_alloc() (or do it inside the
> xas_split_alloc()).

.. and obviously that should be actually *verified* to fix the issue
not just with the test-case that Chris and Jens have been using, but
on Christian's real PostgreSQL load.

Christian?

Note that the xas_reset() needs to be done after the check for errors
- or like Willy suggested, xas_split_alloc() needs to be re-organized.

So the simplest fix is probably to just add a

                        if (xas_error(&xas))
                                goto error;
                }
+               xas_reset(&xas);
                xas_lock_irq(&xas);
                xas_for_each_conflict(&xas, entry) {
                        old = entry;

in __filemap_add_folio() in mm/filemap.c

(The above is obviously a whitespace-damaged pseudo-patch for the
pre-6758c1128ceb state. I don't actually carry a stable tree around on
my laptop, but I hope it's clear enough what I'm rambling about)

               Linus
