Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0961AC89B
	for <linux-xfs@vger.kernel.org>; Tue, 24 Sep 2024 19:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727205876; cv=none; b=Pw9Wys9GRvGHirNz33TOAArb3HNGf5exTszzYJLcXqYlvc4HF2oSmXllDNOVFrFMSC2QyuKipLTWNfq/D+yooMVfbbXxsCobePw2PnfAaAQrYcY/wpZW6kzK2iXxeprm5NlgoTrRkS8hB28pql7TDUeIoGckECtBvq/34fPvTmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727205876; c=relaxed/simple;
	bh=SIeQoyCxYAQebwPctse0ec/xuA/Q6FV0i8cdsXtARic=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SS3EyHOXATL8BERR1COklUmkAwiQAtwLAxA4OKFwDIqmpEY+JKSfLFVeysXUiGds3SQfb14m454DkMKQYFwA6yWdk2xHEYDdJt54nsQURrhVc06H8X30DURABACauYbcaK6n7nnbwNlc72R90xxUtecfkSm66/gqDPnXT9NWq1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eSyd9mhF; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eSyd9mhF"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a8d24f98215so788387366b.1
        for <linux-xfs@vger.kernel.org>; Tue, 24 Sep 2024 12:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1727205873; x=1727810673; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3AEQwCgf5wgX6ZTyJ9aWNB159Y5/5DzJz6MiCsxsiWg=;
        b=eSyd9mhFdtmsq3dEfWRKP5ZMJdd0egIpa3MuPtXvCvm0GeTBw3AGpd8v0eqBZ9Ouwm
         VjzPrXseWGXNRss6ChzLXcZuP2YUNy77dC1keB0SQ+D040jNoPG2pmfbcUPPayaqOPdH
         VttoI3U4Ub8/RXc8k6dd4+sxzBHRxJSFWz3ec=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727205873; x=1727810673;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3AEQwCgf5wgX6ZTyJ9aWNB159Y5/5DzJz6MiCsxsiWg=;
        b=IrTmpJ4CP4sg5pz9av/HEZaBOxZrt9xDXzi3eIahfqoGLNo3PQvIYRw6+ahMHUuF08
         eax8a3LouOeA6Tl5ExGhgLix1DxwY+ay48gpn4jUVe6a3NSQUu4QhJGxksJ6qfHrm2/+
         VUJsm24tBNQ+/ZiyDHtuO0iYws2bgW2w4xboQ0Wv6g6Wj9SB7lBTvcu0gQAu6c+qNxQk
         jxyA6Nf+QVEOarewhePfkw36puIET8khZo8cQBRM8gJErh+rhIC5fMwgXn4hCgKQX14L
         Q5YNe/u/NEapq3xAulOk8gVALIKzuQqRWqATCqkx9Cr12jAM8KIlArjbgnFTLpO/x3Ha
         RF2w==
X-Forwarded-Encrypted: i=1; AJvYcCVbjp9XsrzMTPQgpqjXaD5MxeTFRoKJQsIxbIpHcBo/ZjwV2QqJp1FDy1TZmxJqOZ5jNTKUZ19tqPQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFt5b932s3auLEnVgRRsgvzSJ9OOnA7xce4hf1r2LCt6r/GXmD
	FSIzvlPG3AeDVlvd74SDvgjSR4kS4+cgLoIFyDIEIA+n2uQIg3IaSDh5u/BZ0xgonYLC8o5TfHI
	1yZZRuA==
X-Google-Smtp-Source: AGHT+IHBIcsQbsHRtxjb8XeJrF6KuMHR7SG1WZd0ElR2OzzppbZB7CMB5VZ/e2HJBYqQVohsoKDU4g==
X-Received: by 2002:a17:907:c0a:b0:a7a:aa35:408c with SMTP id a640c23a62f3a-a93a0342190mr32007266b.8.1727205872637;
        Tue, 24 Sep 2024 12:24:32 -0700 (PDT)
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com. [209.85.208.47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a93930cae43sm120755166b.135.2024.09.24.12.24.31
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Sep 2024 12:24:31 -0700 (PDT)
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5c43003a667so8273411a12.3
        for <linux-xfs@vger.kernel.org>; Tue, 24 Sep 2024 12:24:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUbmecuTWMtGGASCT6cqgxG42QRVtUSwzM1skDVxZJyigqWSBf0JUyfKddFxpPnPYfqR+Q4DqCC8hE=@vger.kernel.org
X-Received: by 2002:a17:907:9726:b0:a86:799d:f8d1 with SMTP id
 a640c23a62f3a-a93a06333edmr32505866b.47.1727205871314; Tue, 24 Sep 2024
 12:24:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZulMlPFKiiRe3iFd@casper.infradead.org> <52d45d22-e108-400e-a63f-f50ef1a0ae1a@meta.com>
 <ZumDPU7RDg5wV0Re@casper.infradead.org> <5bee194c-9cd3-47e7-919b-9f352441f855@kernel.dk>
 <459beb1c-defd-4836-952c-589203b7005c@meta.com> <ZurXAco1BKqf8I2E@casper.infradead.org>
 <ZuuBs762OrOk58zQ@dread.disaster.area> <CAHk-=wjsrwuU9uALfif4WhSg=kpwXqP2h1ZB+zmH_ORDsrLCnQ@mail.gmail.com>
 <CAHk-=wgQ_OeAaNMA7A=icuf66r7Atz1-NNs9Qk8O=2gEjd=qTw@mail.gmail.com>
 <8697e349-d22f-43a0-8469-beb857eb44a1@kernel.dk> <ZuuqPEtIliUJejvw@casper.infradead.org>
 <0a3b09db-23e8-4a06-85f8-a0d7bbc3228b@meta.com> <15f15df9-ec90-486a-a784-effb8b2cb292@meta.com>
In-Reply-To: <15f15df9-ec90-486a-a784-effb8b2cb292@meta.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 Sep 2024 12:24:14 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiAQ23ongRsJTdYhpQRn2YP-2-Z4_NkWiSJRyv6wf_dxg@mail.gmail.com>
Message-ID: <CAHk-=wiAQ23ongRsJTdYhpQRn2YP-2-Z4_NkWiSJRyv6wf_dxg@mail.gmail.com>
Subject: Re: Known and unfixed active data loss bug in MM + XFS with large
 folios since Dec 2021 (any kernel from 6.1 upwards)
To: Chris Mason <clm@meta.com>
Cc: Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	Dave Chinner <david@fromorbit.com>, Christian Theune <ct@flyingcircus.io>, linux-mm@kvack.org, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Daniel Dao <dqminh@cloudflare.com>, 
	regressions@lists.linux.dev, regressions@leemhuis.info
Content-Type: text/plain; charset="UTF-8"

On Tue, 24 Sept 2024 at 12:18, Chris Mason <clm@meta.com> wrote:
>
> A few days of load later and some extra printks, it turns out that
> taking the writer lock in __filemap_add_folio() makes us dramatically
> more likely to just return EEXIST than go into the xas_split_alloc() dance.

.. and that sounds like a good thing, except for the test coverage, I guess.

Which you seem to have fixed:

> With the changes in 6.10, we only get into that xas_destroy() case above
> when the conflicting entry is a shadow entry, so I changed my repro to
> use memory pressure instead of fadvise.
>
> I also added a schedule_timeout(1) after the split alloc, and with all
> of that I'm able to consistently make the xas_destroy() case trigger
> without causing any system instability.  Kairui Song's patches do seem
> to have fixed things nicely.

<confused thumbs up / fingers crossed emoji>

              Linus
