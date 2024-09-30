Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56763185B54
	for <linux-xfs@vger.kernel.org>; Mon, 30 Sep 2024 23:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727740409; cv=none; b=RAdnJwgS+JBQ1Essztof+37ONOR1t/n/Bxcp3Ze42Y6pImNr0tf9GikG1szQSsc8eOjKuX26S4s85gKjZ+MxsaFupttGdOcYjwrffQWPkQue9nZn3aFUq0V3YyOzmdMQRXf7fVhmPv8TmVQ+ud3K6i76Gp1ndiEjzW0uaJqmYS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727740409; c=relaxed/simple;
	bh=jqmfhlo6Nq51O9MWU++JmBpPZJAwV8doQ3e17gImTUE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TAeKro3qSQ5bNCfaYE+0TmBguHlElxzVoGYfc0zurLstysnlkqZF8sQVAhw+6Dxv4yRBX8qUyZxuNNg+1kvhGRqIMzM+0cbdhALOCY3wf93yjgN2kj/fE9KWJSmvTeEi10nLc930uI9QO6dDMOgHsZSdDFmPh3AWyLF2gox9ujU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ajUDsE11; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ajUDsE11"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a8d2b24b7a8so1101171566b.1
        for <linux-xfs@vger.kernel.org>; Mon, 30 Sep 2024 16:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1727740405; x=1728345205; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=N6S4zxOawKjAaveDpwT3Z661D+kmHQpHbS1yW1IiFsM=;
        b=ajUDsE11WI1Vq55/BJx/W1mDMt3Yjffus4198B9oxyfK9xgJ2DMoKGrnbgyJyVhuwE
         yuHr22S46R/D+7yyf9LwFQoS/FJJGJjKoJob7naBHr/4fCXG4Qd4bbbrCgRn9morzWUU
         x0K24QYqXETNwJkYMIHp6CxPRQHI5LnnlFax0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727740405; x=1728345205;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N6S4zxOawKjAaveDpwT3Z661D+kmHQpHbS1yW1IiFsM=;
        b=cXeaDLd48+bQ5rK0U1ujvRDFSAeXtyRJy8OD3ch0Xgx3Xa901piCX3JkNgX5I8dQ8P
         /Iuv9+5Flg0KatOY/11arXodP23qXIqo+/FUSibOV46ei+SeqZJOoBj1/OvH03X4R2UZ
         ZtATqphFYIO19r0Pe/NcyTl3H/yhpqd+gUpezLcFh5yq1yBM13I72+Zw5kwDw6Rz/Oic
         yHnyF1R6Pqjv/qVVHfBPMeLvS2yR/2Qt8BlB6UuJqLbJPQtBWTKj4jdNDEDGbTK3EsUN
         NYz4gdCV63toAEunwDOr21zdOpM6K7vkK2LZlK/Jbpxprl9ZK6m94tlSGKHg8zdehTVD
         hTjw==
X-Forwarded-Encrypted: i=1; AJvYcCUrzS6kLlGfWD2t8KZQ4ZGKLXwZ7MTlH7NSJVuSyddGFLHjz+IqqO0Sb+dGb8XpFQzqggIIR1iQ9sg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4JRV7t57TmE9TsI4jN0rymwNJn1vnyfD/Zy7eSOf2+BSRTj2E
	4dx5qF93VKNZBmCofqdZPEIMoQx/AM3ZmLFThxGG7GWb5Jw7QiKOsZ+XV9RafZifQFgPrv7Vkcz
	AVIuS/Q==
X-Google-Smtp-Source: AGHT+IHbuFgWJcE3H7UzcIRzw9fYShGIfNPY3DBQ+d+dfyql1XBNC/ijWnXWdf91huHkL0LI8EvryA==
X-Received: by 2002:a17:907:3f8d:b0:a7a:8284:c8d6 with SMTP id a640c23a62f3a-a967bfd9483mr115635866b.24.1727740405586;
        Mon, 30 Sep 2024 16:53:25 -0700 (PDT)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com. [209.85.208.48])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a93c2775d0bsm618651866b.11.2024.09.30.16.53.22
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Sep 2024 16:53:23 -0700 (PDT)
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5c87ab540b3so7449468a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 30 Sep 2024 16:53:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXreAtFt2fYFLudKyx6Ykw/rfprIbeaw9Pp1TtiTIXvOxWof4RTEUya+0fI+kpzvNsLMpdtpMbDIfY=@vger.kernel.org
X-Received: by 2002:a17:907:7294:b0:a8d:5f69:c839 with SMTP id
 a640c23a62f3a-a967bf527c8mr104147566b.15.1727740402409; Mon, 30 Sep 2024
 16:53:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZuuBs762OrOk58zQ@dread.disaster.area> <CAHk-=wjsrwuU9uALfif4WhSg=kpwXqP2h1ZB+zmH_ORDsrLCnQ@mail.gmail.com>
 <CAHk-=wgQ_OeAaNMA7A=icuf66r7Atz1-NNs9Qk8O=2gEjd=qTw@mail.gmail.com>
 <E6728F3E-374A-4A86-A5F2-C67CCECD6F7D@flyingcircus.io> <CAHk-=wgtHDOxi+1uXo8gJcDKO7yjswQr5eMs0cgAB6=mp+yWxw@mail.gmail.com>
 <D49C9D27-7523-41C9-8B8D-82B2A7CBE97B@flyingcircus.io> <02121707-E630-4E7E-837B-8F53B4C28721@flyingcircus.io>
 <CAHk-=wj6YRm2fpYHjZxNfKCC_N+X=T=ay+69g7tJ2cnziYT8=g@mail.gmail.com>
 <295BE120-8BF4-41AE-A506-3D6B10965F2B@flyingcircus.io> <CAHk-=wgF3LV2wuOYvd+gqri7=ZHfHjKpwLbdYjUnZpo49Hh4tA@mail.gmail.com>
 <ZvsQmJM2q7zMf69e@casper.infradead.org>
In-Reply-To: <ZvsQmJM2q7zMf69e@casper.infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 30 Sep 2024 16:53:05 -0700
X-Gmail-Original-Message-ID: <CAHk-=wire4EQTQAwggte-MJPC1Wy-RB8egx8wjxi7dApGaiGFw@mail.gmail.com>
Message-ID: <CAHk-=wire4EQTQAwggte-MJPC1Wy-RB8egx8wjxi7dApGaiGFw@mail.gmail.com>
Subject: Re: Known and unfixed active data loss bug in MM + XFS with large
 folios since Dec 2021 (any kernel from 6.1 upwards)
To: Matthew Wilcox <willy@infradead.org>
Cc: Christian Theune <ct@flyingcircus.io>, Dave Chinner <david@fromorbit.com>, Chris Mason <clm@meta.com>, 
	Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Daniel Dao <dqminh@cloudflare.com>, 
	regressions@lists.linux.dev, regressions@leemhuis.info
Content-Type: text/plain; charset="UTF-8"

On Mon, 30 Sept 2024 at 13:57, Matthew Wilcox <willy@infradead.org> wrote:
>
> Could we break out if folio->mapping has changed?  Clearly if it has,
> we're no longer waiting for the folio we thought we were waiting for,
> but for a folio which now belongs to a different file.

Sounds like a sane check to me, but it's also not clear that this
would make any difference.

The most likely reason for starvation I can see is a slow thread
(possibly due to cgroup throttling like Christian alluded to) would
simply be continually unlucky, because every time it gets woken up,
some other thread has already dirtied the data and caused writeback
again.

I would think that kind of behavior (perhaps some DB transaction
header kind of folio) would be more likely than the mapping changing
(and then remaining under writeback for some other mapping).

But I really don't know.

I would much prefer to limit the folio_wait_bit() loop based on something else.

For example, the basic reason for that loop (unless there is some
other hidden one) is that the folio writeback bit is not atomic wrt
the wakeup. Maybe we could *make* it atomic, by simply taking the
folio waitqueue lock before clearing the bit?

(Only if it has the "waiters" bit set, of course!)

Handwavy.

Anyway, this writeback handling is nasty. folio_end_writeback() has a
big comment about the subtle folio reference issue too, and ignoring
that we also have this:

        if (__folio_end_writeback(folio))
                folio_wake_bit(folio, PG_writeback);

(which is the cause of the non-atomicity: __folio_end_writeback() will
clear the bit, and return the "did we have waiters", and then
folio_wake_bit() will get the waitqueue lock and wake people up).

And notice how __folio_end_writeback() clears the bit with

                ret = folio_xor_flags_has_waiters(folio, 1 << PG_writeback);

which does that "clear bit and look it it had waiters" atomically. But
that function then has a comment that says

 * This must only be used for flags which are changed with the folio
 * lock held.  For example, it is unsafe to use for PG_dirty as that
 * can be set without the folio lock held.  [...]

but the code that uses it here does *NOT* hold the folio lock.

I think the comment is wrong, and the code is fine (the important
point is that the folio lock _serialized_ the writers, and while
clearing doesn't hold the folio lock, you can't clear it without
setting it, and setting the writeback flag *does* hold the folio
lock).

So my point is not that this code is wrong, but that this code is all
kinds of subtle and complex. I think it would be good to change the
rules so that we serialize with waiters, but being complex and subtle
means it sounds all kinds of nasty.

            Linus
