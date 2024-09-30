Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B24E1A0BCB
	for <linux-xfs@vger.kernel.org>; Mon, 30 Sep 2024 20:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727727180; cv=none; b=fSHadPtyDC6Bzbhf0ko/+UzCdfq1jVhsbQJyMT5VP/ME99xF/5LVa+TYN4peIt1nlDJQrBgUVsP6R4v0JUJH8iw8q5RzFIZBjQ6e9vDkVBz4ola21widLLPrZkVpNQRgaHeBxCyfGo4dCdQ3frLYMzZn5+4qdEJYPN67JYXMgBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727727180; c=relaxed/simple;
	bh=HQF9J8H/AuRUNDVm0LUM1/KuCoSlcEZcddS5OBrqJUI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FuMU9rtsq1qzzYfQfvqO+U3+R25ZJ3iQ0I7ji8TsS0vTpnHS79LaAZhHO/LBIxGKaJDUXIVJNdS6SgJeo7otlKAB+Ks/arxDWYQE6XAP9b0Nu/eodof/kQ2FIFiUzrchbOxNWJy6adrpfPskVax1rsIlSf0d078uSt3s9EaC5sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fkBPN/jo; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fkBPN/jo"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5c5cf26b95aso5515222a12.3
        for <linux-xfs@vger.kernel.org>; Mon, 30 Sep 2024 13:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1727727176; x=1728331976; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M8SU9mjR4XCAezY3L+HkJFDMRx33ZVP0EqsIm6USarM=;
        b=fkBPN/joJbt4vpOQIL741YiJgU7wNqHpX3l9jsLkS2w6UA47/ajYHhcBjZXEAw+d+T
         AcmYByno0yvurvxfjVPcROfz/6Gs8mfJdTT6qu0Tn1ckQHuShomQtDlaJJUqUl2nXwd4
         +lnjlndUL/63UJs1Xw8AJW8n4w82AEqIRMygk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727727176; x=1728331976;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M8SU9mjR4XCAezY3L+HkJFDMRx33ZVP0EqsIm6USarM=;
        b=DFJKjDlj57KIBhbxkVpp8jH1mTheCgRKtcY6Qoz9KlEIHC3uV/C64AFWW71cGz5dtV
         m3cRhhARf3bwmfzrwxagtgVA3xGCUK+njRSE19yEdh1Pmmza11btCXAb8DUS1GsZrDsf
         qWLApEv/ermUxnYI60y8+12Rc5h3X0nko9i4GxWg44HxhpcQN3DBuc9CV1tETUR1hzfw
         EyfZ1iyR51m9Ro7iU7WHQA6BHzGQquVlGPevE/I8u8h17rb0KosUzt4k+e3kL8GF/XCo
         fjse9VLxY0xIZxDHXNtEY4pbNw4zCN3xdDXCVbb9DD42BJqgSc/PVL0ywACa6EMO+qrk
         CovA==
X-Forwarded-Encrypted: i=1; AJvYcCV9muhc5BU92x/4lkZrmvOq9DZsT5h8Eu9Hl3MpIU93gzdkJy0I1HEsOO2+I06bGHf3QjWGbZbNr58=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvnFXpkcTeVPypAhv3XH5HeJqGldnhbvkhsOgvuvKGMytwpjhs
	E8oO9HS96adjI6NLe0BzGgyfdKAcgJVjlr/ywTeUuCMhtwR7QgQBcJCOeTPEwPRxnRSs8ZLemdE
	0drZ//A==
X-Google-Smtp-Source: AGHT+IGx5b+FyZucpHShMDpAHSYuUWV4IJAUhQqJEG3l1/SFYNwZ9QkNzs3LFWeBBnqSNEnf2RMLvQ==
X-Received: by 2002:a17:907:7b8f:b0:a8d:75ab:17ca with SMTP id a640c23a62f3a-a93c49679f6mr1372863066b.31.1727727176233;
        Mon, 30 Sep 2024 13:12:56 -0700 (PDT)
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com. [209.85.218.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a93c2996631sm575093966b.200.2024.09.30.13.12.55
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Sep 2024 13:12:55 -0700 (PDT)
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a83562f9be9so551839666b.0
        for <linux-xfs@vger.kernel.org>; Mon, 30 Sep 2024 13:12:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVb9YWYWQzOycMedBUy60lQkMWlPU8UXpi49rWIEP7KQPoSVo2LOW3MZ9S5Wfkre15MNg3V8QojyH0=@vger.kernel.org
X-Received: by 2002:a17:907:869f:b0:a72:50f7:3c6f with SMTP id
 a640c23a62f3a-a93c49219f2mr1408201666b.14.1727727175132; Mon, 30 Sep 2024
 13:12:55 -0700 (PDT)
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
 <CAHk-=wj6YRm2fpYHjZxNfKCC_N+X=T=ay+69g7tJ2cnziYT8=g@mail.gmail.com> <295BE120-8BF4-41AE-A506-3D6B10965F2B@flyingcircus.io>
In-Reply-To: <295BE120-8BF4-41AE-A506-3D6B10965F2B@flyingcircus.io>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 30 Sep 2024 13:12:37 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgF3LV2wuOYvd+gqri7=ZHfHjKpwLbdYjUnZpo49Hh4tA@mail.gmail.com>
Message-ID: <CAHk-=wgF3LV2wuOYvd+gqri7=ZHfHjKpwLbdYjUnZpo49Hh4tA@mail.gmail.com>
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

On Mon, 30 Sept 2024 at 12:25, Christian Theune <ct@flyingcircus.io> wrote:
>
> I=E2=80=99m being told that I=E2=80=99m somewhat of a truffle pig for dir=
ty code =E2=80=A6 how long ago does =E2=80=9Cold old=E2=80=9D refer to, btw=
?

It's basically been that way forever. The code has changed many times,
but we've basically always had that "wait on bit will wait not until
the next wakeup, but until it actually sees the bit being clear".

And by "always" I mean "going back at least to before the git tree". I
didn't search further. It's not new.

The only reason I pointed at that (relatively recent) commit from 2021
is that when we rewrote the page bit waiting logic (for some unrelated
horrendous scalability issues with tens of thousands of pages on wait
queues), the rewritten code _tried_ to not do it, and instead go "we
were woken up by a bit clear op, so now we've waited enough".

And that then caused problems as explained in that commit c2407cf7d22d
("mm: make wait_on_page_writeback() wait for multiple pending
writebacks") because the wakeups aren't atomic wrt the actual bit
setting/clearing/testing.

IOW - that 2021 commit didn't _introduce_ the issue, it just went back
to the horrendous behavior that we've always had, and temporarily
tried to avoid.

Note that "horrendous behavior" is really "you probably can't hit it
under any normal load". So it's not like it's a problem in practice.

Except your load clearly triggers *something*. And maybe this is part of it=
.

                 Linus
