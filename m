Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9919C27E07E
	for <linux-xfs@vger.kernel.org>; Fri,  3 Jul 2026 03:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783047958; cv=pass; b=V9Jg1mezP39XqaD5dMQILiZZ74V8NH/jsIC4f08bII3xzfFzo044IJITjzWq7K5oyyBdlW4VfMccaxyjqnsjr2TPS21huu0KU6k5zSziIBMfgiL7UoN6ovwDaspPSz/W1SLBIcIs3Ih8f45tZGfjfBYAFpnA+ndqQkCT3nwH/vI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783047958; c=relaxed/simple;
	bh=L+H3GdulcKLSn6s39Xisy3yxUPpEpZqQt/6NPjm2hT4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RiUNjLkF+p8IjQtl5XWl7XVecbdv0d83Ke5PovXb7RybrHlitzJvrT7DFgzdxanXbSqY3rnmEGsP27HvjkPbJSEM7YLcKowpuKGYbXFDRJwIcVtpPaCRA9unfh/GcR9BR/thPAehoKEMPd/0/5/M2RFwXOlV3iAGgjO4QnuyLF8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EeDkho1p; arc=pass smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EeDkho1p"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-493bc8fda98so544545e9.0
        for <linux-xfs@vger.kernel.org>; Thu, 02 Jul 2026 20:05:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783047956; cv=none;
        d=google.com; s=arc-20260327;
        b=GOXnClbk5xmACI6CJHDydr6ynkw+v0jNHqwUTGXSCwKS2ykQ7d121rXKpMCG7TXuU/
         xUS1ks9b9q/xsAnVjz2rLEwxpDoEx1ToRWpj7FROxeXYSEgVhGbUn63kQpO/soxJyQky
         clqgJ0gdyyFQxha9P3Zn33VVdfnwFHUQJ2vDwkCgOWagr/ZsPRnXWBFW9huasFhpYBRa
         r1v6otdzVWvmLptH1BC+MY1qmzrNn9UYsSoLHJnqVlL9gBPVg4oaT2nPPKJKr5dci7ra
         I+/ycoW5sVixhU4SKqui9msXeYwuh5Ih24sSAaW50WFarHkFsgEFT2PDXqTKLLJ04mEb
         fx6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=L+H3GdulcKLSn6s39Xisy3yxUPpEpZqQt/6NPjm2hT4=;
        fh=Ce27NoyrpQCWpS3uYR4RPHZlev2vzxV1HmQD2Uxw9oo=;
        b=D2FFUCgicdCEdWVl2xtkqDn8+ktqwNlnJfUz3GmmQk/8IQXo7AsFP23HJFpsn2REmq
         o3xqVmTIUUKZ5t9WS7LBtFtvctcDYRVJQtV8hg1fXYZ+CeCZKouBFOwCyrj3JCJ25IpG
         6HLlefDxgYehUoezual9ERRCDu4eSCTv2amIu8gEtzU2WMeDUgOEvusA0uvVY9pbbFOz
         tncCtN7Bwrf5PgNvlBNcKv8eDrsch/oJksnL5cK+C1rKTNzUIbh294nfxQVc2xWtYAej
         QZvFOySu9wjVSjaLarIt8hlh8ZH6Pv1X0Q9ZdcQShudZCReH44bf5NHduRjrbZaDbavs
         YBGg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783047956; x=1783652756; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L+H3GdulcKLSn6s39Xisy3yxUPpEpZqQt/6NPjm2hT4=;
        b=EeDkho1p38ZO22WDSFypik9GdRJBnA+hMGgltuEEi7yE5dOIEj9CVMtTfHZXnCeeh5
         5S3nGoLhb/sTUnk5InAuevla/JvQUID/1utipgwbUYEX0iHlWRZtgVke6p//pqLHct1N
         BeLworJR14NmtSnzoMrQjZDD7QNBrCWnJVT9EsYFsyOVGXxL6760xBoOp/3PtYJgEYay
         4LkzdbbfFhtCIq5Zulul3GTsnoTlZijODF8NTQy0/q9919N14dHXs3fRvTY/yFx7LSIM
         jVYnCfrOrRnwp/WCXDXecj4nyLPui8a+HFQ2IDvL/fLLQiFRfbbB58e6wrwns24iukZH
         gg6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783047956; x=1783652756;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=L+H3GdulcKLSn6s39Xisy3yxUPpEpZqQt/6NPjm2hT4=;
        b=ZfvO7rhO2AkSiGVs3K5p/xn6rrKIQ4oFV4Tq/1iWod16yOs29UDFWhCZJ8lnvr8r8+
         uIbFmoizJJuJT7uwpmbtvjjOjg+xDF7j+719ukRKdgEqfzWOPy6KEMDTI/P9VjssdYnh
         xM1Er8PULFSTDIvb7uwtJPd+68KKEGHiRqBiUsLTxhmTLXJakn2e2g8jDZ65B1c012l6
         DdjVwt5MjTacOLmVgCM9FI7qOA7FvIPko2tZl/wzurtxmpCrZ1+9xoqdwP0q5FoKFsdE
         T/P0LRsZuqfxd5et4hcHtMqeK2skFsfR/Opxba8KUrIJWCyA/DrXVjz/jA+KmX5qYO+h
         5ghw==
X-Forwarded-Encrypted: i=1; AFNElJ/hZYLXmqfwDa9MkozTGDU3hPV/KPq99tUw2kWWYb8psuza9YRG2Mt0BbTNYJShuYjnTspU1AD6R9w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5ayPFVI1sCcEFoK6zuvJvAy7wWDU1S1XiM0Y+SAsCd7DiZb8V
	tspvvLM9x09oM+XEJ8NNvWYCb/EXIRIkGEbQnwS6Udt+clxMM17y/cOrIitx3Hkc5W1aIk6UHPv
	ekufdJLs+iym6p7LdS0RH+W140IiU4Xs=
X-Gm-Gg: AfdE7cksEbkx3oqYIJU7DVwtGBBMaaZH5I7AOV0a2f7eUZUkmaL/xtYWEaYkz7zx25m
	FvEhrb5QeCHcEDajr5b+OORV5RCZ7EwFOHwXig/+paZMfNw61j6ibzQX8nm65akN2dzI3Picb+L
	MSVTtTA2HSlDXn7E/WAOJcw5hExzzaO2WYZnsenftmAApfGXa56C2dqtd0P1E+Dz8yb4L/E6P1M
	wrxg65qJSCOOFT0Ax0kblYpMuNeA3DSI0+VgHHQWkzu3RX4yX84z0tr/r6DYvN1s8HaPhInkVfT
	kY0OYJ1loHlZUbefUMaPNpDH3xMwBMzsOi9fBeP7bG1Y/TEr9Kik
X-Received: by 2002:a05:600d:840c:10b0:493:b9cd:1272 with SMTP id
 5b1f17b1804b1-493c3cf2f50mr85170315e9.23.1783047955834; Thu, 02 Jul 2026
 20:05:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260701033253.46420-1-changfengnan@bytedance.com>
 <20260701033253.46420-4-changfengnan@bytedance.com> <akT4tJzFSfrBxqdq@infradead.org>
 <CAJnrk1Y3yPeXBeBNo+DjTt8eRN-mc2F9apBCUn+j=GV7GMzi4g@mail.gmail.com> <akZ3GErzJSTtOn-H@infradead.org>
In-Reply-To: <akZ3GErzJSTtOn-H@infradead.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 2 Jul 2026 20:05:42 -0700
X-Gm-Features: AVVi8CfZKbXMpL8snbpx3vl7cTayO8vf5li7UT5PBriPQUNElwm8EQYO8_inLP4
Message-ID: <CAJnrk1ZijiWYU8YOmRf24xxwX0kH6vCe3ta89LfoX7v7j_JYLQ@mail.gmail.com>
Subject: Re: [PATCH v6 3/3] iomap: add simple dio path for small direct I/O
To: Christoph Hellwig <hch@infradead.org>
Cc: Fengnan Chang <changfengnan@bytedance.com>, brauner@kernel.org, djwong@kernel.org, 
	ojaswin@linux.ibm.com, dgc@kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, lidiangang@bytedance.com, 
	pankaj.raghav@linux.dev, Brian Foster <bfoster@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 2, 2026 at 7:35=E2=80=AFAM Christoph Hellwig <hch@infradead.org=
> wrote:
>
> On Wed, Jul 01, 2026 at 12:35:24PM -0700, Joanne Koong wrote:
> > I think it ends up being pretty simple to get it integrated since
> > ->iomap_next already contains the logic to only begin the mapping at
> > the start and only finish the mapping when the iter has been fully
> > consumed, eg
>
> I wonder if this adds overhead that the simple path removed.

Ah I see now, the whole point of Fengnan's series is to k eep the
logic minimal...

Fengnan, I think you had mentioned earlier [1] that enabling
iomap_next brought the simple-read gain down from 10% to 7%? Thanks
for running those numbers. Would you be able to share the changes you
made to iomap_dio_rw to support iomap_next for those benchmarks you
ran?

Thanks,
Joanne

[1] https://lore.kernel.org/linux-fsdevel/e85e73bd-5fbe-4d11-89ba-7b42c237d=
d34@bytedance.com/
