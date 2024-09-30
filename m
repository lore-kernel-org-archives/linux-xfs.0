Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7844078C60
	for <linux-xfs@vger.kernel.org>; Mon, 30 Sep 2024 18:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727722014; cv=none; b=raCAvIA4hYXcT0O1k9dZ3WMCdUcQAzlrOVhcSqFItE+JwYN91vwY5N8oOVSz4USzkQNRA4OQSXyWhuehGw4dKrNCd9muhtwUgTkYx+DhXqbCd1jpMKjA/KRkJinjMHO2S/X2nPyR5Ni+lnXyyTr1ei99vb4v+uG5fX7MOJeQyC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727722014; c=relaxed/simple;
	bh=LJBd2XzWsHz164n1fTuK+B4D3XarcsLPTUGiEDLMWG0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dm7cdO63aIyganrsV12nlEJoznBhl/U7AIUfL52XVucn+vgG/sUtQ++qh/edOMPM/Bj9vUNMrCsobk76dLLu5WLSJYuZQarI/Oxue7CktQrQxiiKctVsbCdRwyP4mZdPeWm0u+pRTdWY+RA+HDYJtNq7avQE9/2yYMzcB6nPDV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JX2IytFj; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JX2IytFj"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5369f1c7cb8so5768004e87.1
        for <linux-xfs@vger.kernel.org>; Mon, 30 Sep 2024 11:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1727722010; x=1728326810; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8ZxtY/yExLakikPIWimGxq8rXeYi1ZRab5obj2wCNkU=;
        b=JX2IytFjK6uDYofVY6bhRn9dqxxuRzcYIY6Olru8nFDstHQtjmlQuol+wRluNQXrbH
         9+ItpMDby8QJ0U+8mGPljuKdS0NgptVs2zo07K8heAJTlCO2wOqufdcAhSga95t9w5hH
         QVG5GExg+ptMhgoPdGXhbkWg2VKVcxnQ/FdhA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727722010; x=1728326810;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8ZxtY/yExLakikPIWimGxq8rXeYi1ZRab5obj2wCNkU=;
        b=b0A4dthqiXQLuPnVU9jwqFyicOk++PHrU1rpsr/zioRS/uBQSV+CNPYRSw8EDvO729
         K0c+OTsTSAucLV/PAcXkBouCGnV67C293jDWkuFDLVLCJZNdd3NZZ46zlHxweb0Lvuj1
         lHXll2SVs8lg8sl8hHdPcgpXQRpFP6Z9ss71/lCxpm+DhesetAsXkWHqM+wcGmnoeqF3
         AEUHp9rYH8L1F4m8GLe9mEOvAYBr7N9dEAXdtW7SSDXnU5/gXddnRV4VNYjP7Og6I1TJ
         zTieNkRdv0M7JANNifbQsoIsMiicaU6ErKhJygsV1r+nLepbX5kL55q/OG/puGFGLK8j
         OaKw==
X-Forwarded-Encrypted: i=1; AJvYcCUaL8VkVzToTOpF7VrZjyRVn/3Xa5nNOqgGA+cUaTXwqchqqsEBNOejBWWkOiIgUHNwdBDdbi/wteM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzK0qhGC+KnpLRCX9mdNVAZZyEMxUP7oahdDI3UAJg7WaH+YQgx
	jkpyaA0v6CNXgvkyg2i9Ty3yfdl0NEKnoXLndgfP8qV0IFWSCgih5Sjo0DiAtQ37OuFn+qcuWbg
	kXCVMiQ==
X-Google-Smtp-Source: AGHT+IGl2YxssS46VtP3ZXAJB6kkF2O7M2RsJTURkGFsdtrSVuPTzmRehoL9B0+ZXrRDrIiz0xMJLQ==
X-Received: by 2002:a05:6512:6cd:b0:530:aa09:b6bf with SMTP id 2adb3069b0e04-5389fc3747emr7293392e87.24.1727722010197;
        Mon, 30 Sep 2024 11:46:50 -0700 (PDT)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com. [209.85.208.169])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5389fd53865sm1328452e87.37.2024.09.30.11.46.48
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Sep 2024 11:46:49 -0700 (PDT)
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2fac3f1287bso19253551fa.1
        for <linux-xfs@vger.kernel.org>; Mon, 30 Sep 2024 11:46:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWd7gxydl5oFb/GPv62XKWHjs1hzjKR80RdCl9S75mT+ZkZumIoq5hCJe3uMdUrXj50hz+G+fwWFpM=@vger.kernel.org
X-Received: by 2002:a05:6512:ad2:b0:537:a824:7e5 with SMTP id
 2adb3069b0e04-5389fc361dfmr6504852e87.18.1727722007490; Mon, 30 Sep 2024
 11:46:47 -0700 (PDT)
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
 <CAHk-=wgQ_OeAaNMA7A=icuf66r7Atz1-NNs9Qk8O=2gEjd=qTw@mail.gmail.com>
 <E6728F3E-374A-4A86-A5F2-C67CCECD6F7D@flyingcircus.io> <CAHk-=wgtHDOxi+1uXo8gJcDKO7yjswQr5eMs0cgAB6=mp+yWxw@mail.gmail.com>
 <D49C9D27-7523-41C9-8B8D-82B2A7CBE97B@flyingcircus.io> <02121707-E630-4E7E-837B-8F53B4C28721@flyingcircus.io>
In-Reply-To: <02121707-E630-4E7E-837B-8F53B4C28721@flyingcircus.io>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 30 Sep 2024 11:46:30 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj6YRm2fpYHjZxNfKCC_N+X=T=ay+69g7tJ2cnziYT8=g@mail.gmail.com>
Message-ID: <CAHk-=wj6YRm2fpYHjZxNfKCC_N+X=T=ay+69g7tJ2cnziYT8=g@mail.gmail.com>
Subject: Re: Known and unfixed active data loss bug in MM + XFS with large
 folios since Dec 2021 (any kernel from 6.1 upwards)
To: Christian Theune <ct@flyingcircus.io>
Cc: Dave Chinner <david@fromorbit.com>, Matthew Wilcox <willy@infradead.org>, Chris Mason <clm@meta.com>, 
	Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Daniel Dao <dqminh@cloudflare.com>, 
	regressions@lists.linux.dev, regressions@leemhuis.info
Content-Type: text/plain; charset="UTF-8"

On Mon, 30 Sept 2024 at 10:35, Christian Theune <ct@flyingcircus.io> wrote:
>
> Sep 27 00:51:20 <redactedhostname>13 kernel:  folio_wait_bit_common+0x13f/0x340
> Sep 27 00:51:20 <redactedhostname>13 kernel:  folio_wait_writeback+0x2b/0x80

Gaah. Every single case you point to is that folio_wait_writeback() case.

And this might be an old old annoyance.

folio_wait_writeback() is insane. It does

        while (folio_test_writeback(folio)) {
                trace_folio_wait_writeback(folio, folio_mapping(folio));
                folio_wait_bit(folio, PG_writeback);
        }

and the reason that is insane is that PG_writeback isn't some kind of
exclusive state. So folio_wait_bit() will return once somebody has
ended writeback, but *new* writeback can easily have been started
afterwards. So then we go back to wait...

And even after it eventually returns (possibly after having waited for
hundreds of other processes writing back that folio - imagine lots of
other threads doing writes to it and 'fdatasync()' or whatever) the
caller *still* can't actually assume that the writeback bit is clear,
because somebody else might have started writeback again.

Anyway, it's insane, but it's insane for a *reason*. We've tried to
fix this before, long before it was a folio op. See commit
c2407cf7d22d ("mm: make wait_on_page_writeback() wait for multiple
pending writebacks").

IOW, this code is known-broken and might have extreme unfairness
issues (although I had blissfully forgotten about it), because while
the actual writeback *bit* itself is set and cleared atomically, the
wakeup for the bit is asynchronous and can be delayed almost
arbitrarily, so you can get basically spurious wakeups that were from
a previous bit clear.

So the "wait many times" is crazy, but it's sadly a necessary crazy as
things are right now.

Now, many callers hold the page lock while doing this, and in that
case new writeback cases shouldn't happen, and so repeating the loop
should be extremely limited.

But "many" is not "all". For example, __filemap_fdatawait_range() very
much doesn't hold the lock on the pages it waits for, so afaik this
can cause that unfairness and starvation issue.

That said, while every one of your traces are for that
folio_wait_writeback(), the last one is for the truncate case, and
that one *does* hold the page lock and so shouldn't see this potential
unfairness issue.

So the code here is questionable, and might cause some issues, but the
starvation of folio_wait_writeback() can't explain _all_ the cases you
see.

                  Linus
