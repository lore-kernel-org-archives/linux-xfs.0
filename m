Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DCB1C175F
	for <linux-xfs@vger.kernel.org>; Thu, 12 Sep 2024 22:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726179973; cv=none; b=hB9/ASpRI3aXhTBz0jIn+R/cslZxvpf7GqLQMQhM0UIwAN9IeH2hIE3KFXfh2NanLqSQ1LTbYQBDKcez44V6F4mPvRM5nSNO7i6JKgEZiEXZza/3NYjX86eDTRpoi9TxwbgkRjSEf1bEdRzT2ew1T7+R9ERy3Yd/Pzve6jfhszg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726179973; c=relaxed/simple;
	bh=KbS83rDiWhetHVtFkjA/wbafpTGhtpNgKVkrYNxEn7I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=csIkxyapQB1DdwWfrMzLFSF9GbenSOXfjb/mK+FQOMD8bgfW+n4k3XPpG7torNAGlwWQc8zXVqIRlwntd8W8II0st1XhNUQd0rjylbLXn6H7255GJPh49FDBLn5JYuzrsA12KmBu0VqhyKn7L2qvCM17sNcDvrPKXL/wRQUFb0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HvJ6SrZ4; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HvJ6SrZ4"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a8a7903cb7dso14107366b.3
        for <linux-xfs@vger.kernel.org>; Thu, 12 Sep 2024 15:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1726179969; x=1726784769; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QeNLQ4zvks3207JaJjctekem2eb/h7As09d+6h+vRY8=;
        b=HvJ6SrZ4XOg7QdrDfupDUvarrACv/pwoh5022WXxvBgxX9RWRRTeAXUDEiwPxrlk5a
         EJDRaVQOkv+OMxCSG32BiaPWbG3GJHC7WsrIHxRayJTWk1bAl/yfH7017P4WCGQEbaqV
         AyO7GoVlMG6DERPSBFCG0NDHyc/fVXfc/2JOo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726179969; x=1726784769;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QeNLQ4zvks3207JaJjctekem2eb/h7As09d+6h+vRY8=;
        b=VGtgY2I3vHVWToTVm+C0wz/pX4Y5IYf4VfYqTF4SPZgs9hWItDVckNiCPtzdJ8KoCQ
         kWdnDgyV7/X47az6rN00ydUkusrP/4Ks2SEzY9uP7d+UFxEU3PlvpH6xiT/57iAn5sex
         VeOoKcIHoluGKjbiD3UPOrvx9VpLtfKtflsUE3TsRTnVY1J2O2QyAvq+wvUVgsImgNsp
         o5NzQ2ckFoNTqaH662Xp8lHkzzomeTBknVSAC6UpgNRJIv7HTmroUeZwRcJ3y0DSU7LO
         kgQ0NT1FCmQbHrjKzx4vO10KxX5HBMSW1RqU/BtPZ4kTgBWZ1wDDqtYtJJSyVPjzhHwN
         UGvA==
X-Forwarded-Encrypted: i=1; AJvYcCWEYM8AoJ4xUvJ4wvZhiuc1Jg39jp+RSbwVT9sYAYxt0nZI6mQFsi8vM/41KXNb500gR7vZTanH4Z4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyewprCJOwypiYJ+4G9XeYcHHZa3DZO4b7gLr0C+wGstke377GU
	kF1IpDJFZ06Ce/VqoS/uH/HEkEG/f9a9czUbidvEjdbLe/FzzXsWvnrzL205O9kcSicIbMesHCp
	JyizJ/g==
X-Google-Smtp-Source: AGHT+IG6sUauBggcOMen6Xy9AX/Pkoe8aLyCo5yWB0WBg+Ct+h8yIo13Q98jafL9HEk8zV8J6QBKtw==
X-Received: by 2002:a05:6402:3484:b0:5c2:58fe:9304 with SMTP id 4fb4d7f45d1cf-5c41dea6b5emr721685a12.1.1726179969250;
        Thu, 12 Sep 2024 15:26:09 -0700 (PDT)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c3ebd42620sm6872201a12.20.2024.09.12.15.26.07
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Sep 2024 15:26:07 -0700 (PDT)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5c26a52cf82so126487a12.2
        for <linux-xfs@vger.kernel.org>; Thu, 12 Sep 2024 15:26:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUvoRK57rLNPMRMZljy2MF5GE11298HcipvN2pZXxO61xwNGiL4xo5mK//LMm37p/hDwT5GP41btBw=@vger.kernel.org
X-Received: by 2002:a05:6402:43cd:b0:5c4:ae3:83bd with SMTP id
 4fb4d7f45d1cf-5c41e193d3dmr666054a12.21.1726179967306; Thu, 12 Sep 2024
 15:26:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <A5A976CB-DB57-4513-A700-656580488AB6@flyingcircus.io>
 <ZuNjNNmrDPVsVK03@casper.infradead.org> <0fc8c3e7-e5d2-40db-8661-8c7199f84e43@kernel.dk>
In-Reply-To: <0fc8c3e7-e5d2-40db-8661-8c7199f84e43@kernel.dk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 Sep 2024 15:25:50 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh5LRp6Tb2oLKv1LrJWuXKOvxcucMfRMmYcT-npbo0=_A@mail.gmail.com>
Message-ID: <CAHk-=wh5LRp6Tb2oLKv1LrJWuXKOvxcucMfRMmYcT-npbo0=_A@mail.gmail.com>
Subject: Re: Known and unfixed active data loss bug in MM + XFS with large
 folios since Dec 2021 (any kernel from 6.1 upwards)
To: Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox <willy@infradead.org>, Christian Theune <ct@flyingcircus.io>, linux-mm@kvack.org, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Daniel Dao <dqminh@cloudflare.com>, 
	Dave Chinner <david@fromorbit.com>, clm@meta.com, regressions@lists.linux.dev, 
	regressions@leemhuis.info
Content-Type: text/plain; charset="UTF-8"

On Thu, 12 Sept 2024 at 15:12, Jens Axboe <axboe@kernel.dk> wrote:
>
> When I saw Christian's report, I seemed to recall that we ran into this
> at Meta too. And we did, and hence have been reverting it since our 5.19
> release (and hence 6.4, 6.9, and 6.11 next). We should not be shipping
> things that are known broken.

I do think that if we have big sites just reverting it as known broken
and can't figure out why, we should do so upstream too.

Yes,  it's going to make it even harder to figure out what's wrong.
Not great. But if this causes filesystem corruption, that sure isn't
great either. And people end up going "I'll use ext4 which doesn't
have the problem", that's not exactly helpful either.

And yeah, the reason ext4 doesn't have the problem is simply because
ext4 doesn't enable large folios. So that doesn't pin anything down
either (ie it does *not* say "this is an xfs bug" - it obviously might
be, but it's probably more likely some large-folio issue).

Other filesystems do enable large folios (afs, bcachefs, erofs, nfs,
smb), but maybe just not be used under the kind of load to show it.

Honestly, the fact that it hasn't been reverted after apparently
people knowing about it for months is a bit shocking to me. Filesystem
people tend to take unknown corruption issues as a big deal. What
makes this so special? Is it because the XFS people don't consider it
an XFS issue, so...

                Linus
