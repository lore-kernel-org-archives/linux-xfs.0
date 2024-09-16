Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE922F5B
	for <linux-xfs@vger.kernel.org>; Mon, 16 Sep 2024 04:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726460463; cv=none; b=qKhu4nAOjk3EVOFDk1iHeIO6h7E+GECrWyazhNkX3wtBB9pJgITQNSmg263A7kMcZVi4g1BED5isVHrdxGbvKdlREDZ5zxYfNCu6gCeF8gwX5pReHomvgzs7+jzVPd+JxK5TJasHhaOqbVRu45L6oUGiTKwtyFM5dt+jtU5Zrig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726460463; c=relaxed/simple;
	bh=OTJ/oKsnoisoc9GbqLHkeCIc2BFxmDrQOsJxcfR3nk4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RbRvNNDme8xYmZ0TP/5cf1CESWtVJT7hPGMnxz2z8nVwXVZRfRMw67IOKosnVxYxqfmwhnNcmrL2MSbVLjyiVfMVZww1EErZXMdIBgwIhTDPcjDjlAnIVA9QdS2MbOz59CNs43KzcwAMaoCWn6QtAOIn59e0kLKIUVFyLpd6CkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W1152b/P; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W1152b/P"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a8a6d1766a7so520111466b.3
        for <linux-xfs@vger.kernel.org>; Sun, 15 Sep 2024 21:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1726460460; x=1727065260; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jwnw+7buV/Co6cDy6nKRIoLyua67GCD7ZNv0sYBhUOM=;
        b=W1152b/P/CRuwXIhT/+AISMTiWayok3ekr74HS0WXX7JxRJwdbcICyi2vh/2Xs9QY9
         mJTuMHJZYp5OlN0BWU7fZ5xd01wSfiLkBazHZdQp31jYWTH8eI5utA71MklpU211UOx3
         hv54Rr8c0EzzW5VJ8Xxw+euNJOPe4jREw2iq8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726460460; x=1727065260;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jwnw+7buV/Co6cDy6nKRIoLyua67GCD7ZNv0sYBhUOM=;
        b=fwmKnCx8O8BNJP0cx8VJtsnByMlraRYLoogUYz7WaAftJ7dgBumo+2w9uBYZFYRykH
         oOuuv5h/qEuI3JiDJsNdGcM9FU/gN2aUHACRE1R79r52zWikSXt6nZpLYEMCREsHsB0S
         avudTZzBosxs0Ig75XWhoPVavFs1WaU3h9lO4WPmVBarsspJsd3T3PliYnmUPd7NJkLj
         U4UAEO1MrJnjHizva/0fJaeRtlkooDnQ/D7iQBtY2KVZuv6DtdBg60XAjpWMKXi1gDOi
         UVfFM0gBP9C3fqn5u1qBE4T0kSSisI+cb/NOvoIN6CzaEur1oJx1t9Ve3a/7ElroQi55
         fCBw==
X-Forwarded-Encrypted: i=1; AJvYcCXNu7KeSiYTFeOyoBczzavxvMI5Ki95hDCOq1rQ91kTXdfkCSXmqdpIwavh2sXTNG6Nu8Eo2AhKT4w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5DYpiUtQ3mwjCMs8L1KtSFWgdLyyWCBSKE3rMf8/4CX+HyFKL
	HOdBBudSwZdEQZOsf89BCUhMdhw5blViLwD05arAUo3MziZFFuvuRNWbcoFC+C/n46Orbb/f6Bd
	vxtxG6Q==
X-Google-Smtp-Source: AGHT+IEqLwmfHH6u9uGyPSybx5AxbAGDXiNedy7wESv96nwpSfA+bXzRboQocLbHgmdZ2G3ZjpJ8zA==
X-Received: by 2002:a17:907:940e:b0:a8d:2ab2:c9b1 with SMTP id a640c23a62f3a-a90296716efmr1444604066b.56.1726460459339;
        Sun, 15 Sep 2024 21:20:59 -0700 (PDT)
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com. [209.85.208.49])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a90610f4510sm258173366b.67.2024.09.15.21.20.58
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Sep 2024 21:20:58 -0700 (PDT)
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5c25f01879fso4600638a12.1
        for <linux-xfs@vger.kernel.org>; Sun, 15 Sep 2024 21:20:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV8GcOC/OwxC/i+KEIcJe4t+OUttRkrLb5Zv7rJIqU6gnmQUXL+6+XIOOAOeuugwtRgSRn0UVK6CAE=@vger.kernel.org
X-Received: by 2002:a05:6402:2107:b0:5c4:367e:c874 with SMTP id
 4fb4d7f45d1cf-5c4367ec9dfmr3443219a12.11.1726460457889; Sun, 15 Sep 2024
 21:20:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <A5A976CB-DB57-4513-A700-656580488AB6@flyingcircus.io>
 <ZuNjNNmrDPVsVK03@casper.infradead.org> <0fc8c3e7-e5d2-40db-8661-8c7199f84e43@kernel.dk>
 <CAHk-=wh5LRp6Tb2oLKv1LrJWuXKOvxcucMfRMmYcT-npbo0=_A@mail.gmail.com> <Zud1EhTnoWIRFPa/@dread.disaster.area>
In-Reply-To: <Zud1EhTnoWIRFPa/@dread.disaster.area>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 16 Sep 2024 06:20:40 +0200
X-Gmail-Original-Message-ID: <CAHk-=wgY-PVaVRBHem2qGnzpAQJheDOWKpqsteQxbRop6ey+fQ@mail.gmail.com>
Message-ID: <CAHk-=wgY-PVaVRBHem2qGnzpAQJheDOWKpqsteQxbRop6ey+fQ@mail.gmail.com>
Subject: Re: Known and unfixed active data loss bug in MM + XFS with large
 folios since Dec 2021 (any kernel from 6.1 upwards)
To: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <willy@infradead.org>, 
	Christian Theune <ct@flyingcircus.io>, linux-mm@kvack.org, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Daniel Dao <dqminh@cloudflare.com>, clm@meta.com, 
	regressions@lists.linux.dev, regressions@leemhuis.info
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Sept 2024 at 02:00, Dave Chinner <david@fromorbit.com> wrote:
>
> I don't think this is a data corruption/loss problem - it certainly
> hasn't ever appeared that way to me.  The "data loss" appeared to be
> in incomplete postgres dump files after the system was rebooted and
> this is exactly what would happen when you randomly crash the
> system.

Ok, that sounds better, indeed.

Of course, "hang due to internal xarray corruption" isn't _much_
better, but still..

> All the hangs seem to be caused by folio lookup getting stuck
> on a rogue xarray entry in truncate or readahead. If we find an
> invalid entry or a folio from a different mapping or with a
> unexpected index, we skip it and try again.

We *could* perhaps change the "retry the optimistic lookup forever" to
be a "retry and take lock after optimistic failure". At least in the
common paths.

That's what we do with some dcache locking, because the "retry on
race" caused some potential latency issues under ridiculous loads.

And if we retry with the lock, at that point we can actually notice
corruption, because at that point we can say "we have the lock, and we
see a bad folio with the wrong mapping pointer, and now it's not some
possible race condition due to RCU".

That, in turn, might then result in better bug reports. Which would at
least be forward progress rather than "we have this bug".

Let me think about it. Unless somebody else gets to it before I do
(hint hint to anybody who is comfy with that filemap_read() path etc).

                 Linus
