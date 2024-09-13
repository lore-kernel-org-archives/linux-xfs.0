Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B40FBA50
	for <linux-xfs@vger.kernel.org>; Fri, 13 Sep 2024 21:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726262666; cv=none; b=HjxjEGrhIPAbBP4WRrV02QyysKvBm4CuPMAqZiKnzf5axbgCqYlvhlHXWEHk1l/OHIZKTEFjH5yTZB+QydElFtUTNi3jGoeknZ8Ps7ugjwb4/DprIevtk15jVIAH3GlnmvfV+nrLhKtBshoIPxqFd3cyZKv4r2azFIe3PGI0M6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726262666; c=relaxed/simple;
	bh=ZYhLlCfJubXl2lpFJkootrsMtKBVHk6xopFryr344Jw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RWF32jXPRaD2jmp1xTCrz/+5OEyWEAjYHaPmTC9JzydiZrbzZPtnVBDccfHRbYuJMFdws+SulQkX4LcT0s24YxGZUxy/LlY31rMI8asMdIIQxs9d76WywmYwddShWLLGIZbJGBY+U/pmm9tNcvKdWxRomF8re2cjZXJ+VjBUKq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dOXPS2ct; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dOXPS2ct"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2f77be8ffecso32047291fa.1
        for <linux-xfs@vger.kernel.org>; Fri, 13 Sep 2024 14:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1726262662; x=1726867462; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xRuFfVQTrS2LaFQHsAbqiDg4XIXZJlnGtDFvh2VKrJg=;
        b=dOXPS2ctuH/ZJu0xW6+f9l/5uP8WwekX4KBkgSF9NNXokVP6l0rhP5JPeiR39fnwis
         0smUoOPmopxYjX9xHydq9PLm6KpGHuB7HngkdoX9C9Opr5jtwHAk34mA8LbH9VDjKaup
         Fk+WWYnlYtVFc5kvyB6e/Q0OApzCLqrfNjVfQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726262662; x=1726867462;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xRuFfVQTrS2LaFQHsAbqiDg4XIXZJlnGtDFvh2VKrJg=;
        b=Idi/xUcvmlYl4fs6qABCEQnrCMyN7GqhU4zXgJ42r8lIdcyd56Km/W7BoN6Goa8h18
         ehwH16V2Tvlkoohs1uJMicM8n37lpgTW/+pF4A+oN2jpPG+aBz3G7h+7vK058XMBbZsR
         24Z7DFD/c6v2FYv4nHEFmSzRfQlL87SF16yIc6crCYogefCAFJCg+PkRvVKOvIW5nuSo
         J+TEOoONDoTI1FyCDI+RniFjXJYe+B+rb+j3Ailqx7QyULvmo1srROkVcA5y3uZEvL5w
         kb9HzvXR0rTiiRwR1p25+kT44xuevWg+a2O+6OW9ZfZ48jKvTsc8QQmrmlIeglGn36j/
         hQPA==
X-Forwarded-Encrypted: i=1; AJvYcCXjcy2Cs75r9tHBwmLMMus/gnwSU3KYODOoglAIm/i3jzGn344A4VvRqWS39euR7OUszGU6V6VBwNo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxpZvJT3sD3UKeoNNOD4llQHhdxSVs50q1XMbq7vORY/45cEkmD
	N5sIlZOkh8kZc5neFRU0MexIyGLl+IeXiMyyKWFaT6CIA/AOgayMEMrQyc8qTlo8koCDdd2E8kR
	aqMI=
X-Google-Smtp-Source: AGHT+IFo7UzGHFaV1MZEj2Y2bSFF0zcnzu/4We7DVtV6bFByIblVmT6MeMALLuFHVfzCUyYYd2qYGw==
X-Received: by 2002:a05:651c:2208:b0:2f3:e7cb:ee37 with SMTP id 38308e7fff4ca-2f787da0339mr52995141fa.8.1726262661350;
        Fri, 13 Sep 2024 14:24:21 -0700 (PDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com. [209.85.208.178])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2f79d37f52bsm202281fa.85.2024.09.13.14.24.20
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Sep 2024 14:24:20 -0700 (PDT)
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2f75c6ed397so29529991fa.2
        for <linux-xfs@vger.kernel.org>; Fri, 13 Sep 2024 14:24:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU7VayjYqkFDIOKU+OhaJIKMAXXYXSX3Kr6bzJrh0KOlTeqW2CyePoI6LLhgDXpwkxYR6Y4SU7AcQA=@vger.kernel.org
X-Received: by 2002:a2e:7c0d:0:b0:2f5:11f6:1b24 with SMTP id
 38308e7fff4ca-2f787dd0941mr36494131fa.18.1726262659861; Fri, 13 Sep 2024
 14:24:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <A5A976CB-DB57-4513-A700-656580488AB6@flyingcircus.io>
 <ZuNjNNmrDPVsVK03@casper.infradead.org> <0fc8c3e7-e5d2-40db-8661-8c7199f84e43@kernel.dk>
 <CAHk-=wh5LRp6Tb2oLKv1LrJWuXKOvxcucMfRMmYcT-npbo0=_A@mail.gmail.com>
 <d4a1cca4-96b8-4692-81f0-81c512f55ccf@meta.com> <ZuRfjGhAtXizA7Hu@casper.infradead.org>
 <b40b2b1c-3ed5-4943-b8d0-316e04cb1dab@meta.com> <ZuSBPrN2CbWMlr3f@casper.infradead.org>
In-Reply-To: <ZuSBPrN2CbWMlr3f@casper.infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Sep 2024 14:24:02 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh=_n1jfSRw2tyS0w85JpHZvG9wNynOB_141C19=RuJvQ@mail.gmail.com>
Message-ID: <CAHk-=wh=_n1jfSRw2tyS0w85JpHZvG9wNynOB_141C19=RuJvQ@mail.gmail.com>
Subject: Re: Known and unfixed active data loss bug in MM + XFS with large
 folios since Dec 2021 (any kernel from 6.1 upwards)
To: Matthew Wilcox <willy@infradead.org>
Cc: Chris Mason <clm@meta.com>, Jens Axboe <axboe@kernel.dk>, Christian Theune <ct@flyingcircus.io>, 
	linux-mm@kvack.org, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Daniel Dao <dqminh@cloudflare.com>, Dave Chinner <david@fromorbit.com>, regressions@lists.linux.dev, 
	regressions@leemhuis.info
Content-Type: text/plain; charset="UTF-8"

On Fri, 13 Sept 2024 at 11:15, Matthew Wilcox <willy@infradead.org> wrote:
>
> Oh!  I think split is the key.  Let's say we have an order-6 (or
> larger) folio.  And we call split_huge_page() (whatever it's called
> in your kernel version).  That calls xas_split_alloc() followed
> by xas_split().  xas_split_alloc() puts entry in node->slots[0] and
> initialises node->slots[1..XA_CHUNK_SIZE] to a sibling entry.

Hmm. The splitting does seem to be not just indicated by the debug
logs, but it ends up being a fairly complicated case. *The* most
complicated case of adding a new folio by far, I'd say.

And I wonder if it's even necessary?

Because I think the *common* case is through filemap_add_folio(),
isn't it? And that code path really doesn't care what the size of the
folio is.

So instead of splitting, that code path would seem to be perfectly
happy with instead erroring out, and simply re-doing the new folio
allocation using the same size that the old conflicting folio had (at
which point it won't be conflicting any more).

No?

It's possible that I'm entirely missing something, but at least the
filemap_add_folio() case looks like it really would actually be
happier with a "oh, that size conflicts with an existing entry, let's
just allocate a smaller size then"

                Linus
