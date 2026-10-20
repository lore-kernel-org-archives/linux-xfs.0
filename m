Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792478029;
	b=W+7wNn3kkSFB646AvFAUkUaKHiCoL2DC6raVsHJM1/8SHhMj5fFK7RSMxIx7KolsDxDW
	 O0xdUoaaJh2x7D/ClpfqXooEZHQLkIWvcNmVWMUMf8g4XrCTOiILrns9ELUXrVA2fCZDp
	 8OcZzIAy1fFN9zPvjMoY4JLFnhM1ceqZ/Z54PV0Y3ecKrCdOdl4M8WjDEveVURUU99i6N
	 FAPQamcJ4vlDyPXDVXKItmrdkD4tUMdiug4/vCJyJWSTyOIFR5e8jKj2nCxyoVTk1T8on
	 u0K+b8o2aP0gpcndEKUj5B1SFKj9ApQ70GGdO3LOvZRxiLTHR90SCO6YRM9VxKEXLCg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792478029;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=exeTp1cAoNgGNBzHpnK0Fe4gV+c26CWlkIC+95vHT8w=;
	b=WxhVNS298JiOmTZzvTHSxDg5eFGInTQGcq5meyGJc0KNdQEv2QeJ1mO29ov+N9DyS6Qj
	 xMNfwQIms6Xdt9MA56MEGWIwjcC+rqMnDE/LRlWEQcLQYPBOkjYKI3+KGTDeH3soK2dRr
	 34Gw8N1m9LF2iIzV2lYbI8DmWdZwHU+81NrWVpYgFnLF0KTrXfhN+24Hv4aGfzIAADcKz
	 kvVM4DKinL0OzDSd+5kZxS3noV3AkDavSK2R/h66fQqFI/YDq99vK8RPS0ynFrv1pgy2T
	 z9QZgLseHZbXTw7J5tWdiqeoFpLBKyW/SjFrU1M/gvO1D/s2fkKfXyiuXf5F4vdyIZg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=owltronix.com;
	spf=none smtp.mailfrom=owltronix.com;
	dkim=pass header.d=owltronix-com.20251104.gappssmtp.com header.i=@owltronix-com.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=aXnphUCd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56729606A321
	for <linux-xfs@vger.kernel.org>; Tue, 20 Oct 2026 06:33:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 56729606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=owltronix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=owltronix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=owltronix-com.20251104.gappssmtp.com header.i=@owltronix-com.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=aXnphUCd
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a1e34ecb02so14195535e9.2
        for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2026 23:33:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792478023; cv=none;
        d=google.com; s=arc-20260327;
        b=spfsBonF1q0qeBhRINI1pA/wHX9LX+8NLkexG1cNK8DOofqzJwrDj4pIRq5GzLTUnq
         stWwbtT0/CkE4CF1QVUXH0r9o+viqNP0XMGeqhKsll26mHZRWKUyvj9/wPfeJH1II6U8
         q5nedTEXghElNn1wIaXeZjRlKjKbRXer1R8yEF/r4TmKNmY7qyttev2caa0x5d6i0R0p
         N8wB60qLi8vJfry1hr7hhLZ3TOFlKPd0GCafcvVMacgYfjWEHdeKmlkPMevqB2Bzaz5w
         VWTvJSUzZLAIekbNRytc3fzVeTReBrIAS3KkP53XMePL2QHw63h34901pK5JA8gX0bcP
         f/ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=exeTp1cAoNgGNBzHpnK0Fe4gV+c26CWlkIC+95vHT8w=;
        fh=bNu6oWQzmiIGwCewTn9zDqNoPZSjInZ4eTOH5bOhiLQ=;
        b=o3JVWZyMk0KWnEVV0h5sOsYbXRXEFMn1nxr53yKG3F34pR4fxvd14mWExZ5FHcSIhk
         Z0Jo7OaAPc/Ygr3C8+RohXjxKkDwWMVypCjqBowhNwN35WNvv0VWs7+6ZwcVaemaAzH1
         MoRYeTEG19G09gPRdni16WbJr2Rwxx8Qu03o110X91TWgnSRiJuka+Q2SpyzwYRjETU1
         OaZfj6fMl7rWBslRkPnDayA/iNj19WQbct79XstVLc/QuwlCz/T9rULKlSvxGgIQhz13
         r+tSzxT/5mkyXU1ZcGgbWfj8SAZJoEeo+0bgPpEJvjPUvc4w6Hcu6ncOFpWRObb4ml3k
         kBVg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=owltronix-com.20251104.gappssmtp.com; s=20251104; t=1792478023; x=1793082823; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=exeTp1cAoNgGNBzHpnK0Fe4gV+c26CWlkIC+95vHT8w=;
        b=aXnphUCd1OxmReadwWegZwBmMEXcQoL5UXzvHpS6C5j3EWlIRvjPWPNunlqO+IWQel
         TLjejB3aKqyeGJcs2XDFWRVHO0NShXeY4QCocXkRzsjqySq9g68Hcn5EFspP6iqw2DxJ
         pun+vmmO6V3eUuwc18zX56uanSkO/w++vt6zjQJScnjIj1LPa6sYimGT5H0t5kOz3str
         ByLPtoXIji412AHh53PuTjgh6Lf+BweNFvTBBdK/wZgci189jV6FJigATHzDga3AJlxM
         hW8D7sRhOEhR7g+d2s+j7Xh7APye/CBgRphiwifOaZypID1F/l077nZMfaosuEAy4f1u
         m+UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792478023; x=1793082823;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=exeTp1cAoNgGNBzHpnK0Fe4gV+c26CWlkIC+95vHT8w=;
        b=UWKz9i3j9jYHE9nMNgU0Zb6tMl5XihfUcJMCqWoUrY+BfbN0m42NAdpT1JDSe6bEZC
         PozVes9tDscSwHbBMk8TBJailTFijTJ0estLRMcVyGY9Jb0bNUgqnP43rKHKpGhBcpyW
         q3qj+ZDMjccGyc29TOmHT1qtptFowkMjeGQOnk7Ffkd323Lbl69BqTtjdMR3YOjfKBM+
         /oxgEBjIyRYI2tkElk51qQVCMb/Od+5gTCGefJ6ke7gXy/0dPDe1ilykn6hIJjVFt9al
         BO7tNvtUlscpZDB4AvBvtTUNTZsO5eBEpGidBHmjhAE6D8rQ5zjHA/F+dBEpQLjrqAYF
         RDAw==
X-Gm-Message-State: AFq9FYIb2xGcRkGVVGVnbQWxcwa7E3RjvBKuynbydOP/XKV8xchdU+RH
	IdZFbSu547KQ/M6Yz48cZUc6kP8abkKy8p0/z8sNS2WOkjEyXW8SC5bd9QI4hNCuXdtdw4Xpjyq
	gGD18zd0HtkfhqDFwcAvycY8fPsWSk9jkbj39nxvPnQ==
X-Gm-Gg: AYBFou1e/cwD+r2d85a+WZ1SYefQ/LUh2lzNcRjtvIOHjMxJpSleQTAtydY48Yb6sJt
	AuCpRtptsrFKy+T/JAJ8lrUHIFatIsfXCKAjvnewtybOqWSgr9nzcfxe4yL/B6Kx2LEzLeV1U0i
	DJ4FnpaoXdiBkVm841V76mVbuo7Z57AH69JOiLkRTu11UssRSvLFYHkziEF13CfNV6x5Pb5a+RE
	I0UGOD0GZaTe93UEI/4iRoJVcwnUHXWmHNgHEA4KjRbS418bCbPMWgJyjB1fe8wftCERMeywhPZ
	UZDg+NCw1eEzU+Wss7G9xtP6pBCn1ERWd0JJOzMEPh13QVE5HrYicGEp
X-Received: by 2002:a05:600c:b99:b0:4a1:d36f:1ba0 with SMTP id
 5b1f17b1804b1-4a1d76227b4mr199950255e9.35.1792478022502; Mon, 19 Oct 2026
 23:33:42 -0700 (PDT)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261016160037.GA107919@frogsfrogsfrogs>
In-Reply-To: <20261016160037.GA107919@frogsfrogsfrogs>
From: Hans Holmberg <hans@owltronix.com>
Date: Tue, 20 Oct 2026 08:33:30 +0200
X-Gm-Features: AclHuK_ADi3z0cS39x96qE3d4XzZpXIuupVRKpApcCWwiB08hyMIjCfxAVkNnMI
Message-ID: <CANr-nt1btFt4FqSgrsjMW5tRihyKcUKG-irW9su5AM943+1vzA@mail.gmail.com>
Subject: Re: Farewell!
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, fuse-devel <fuse-devel@lists.linux.dev>, 
	fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for everything, Darrick!

It's been a pleasure. Hope to have you back one day!

Cheers,
Hans

On Fri, Oct 16, 2026 at 6:07=E2=80=AFPM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> Hi everyone,
>
> After 14 years at Oracle and 23 years working on Linux, I've decided to
> take an extended break.  Today, October 16th, 2026, is my last day.
>
> I don't have any immediate plans to drop the djwong@kernel.org
> forwarding, though ultimately that's up to the sysadmins to decide.
>
> I have very much enjoyed working with you all, and I'm proud of what
> we've accomplished together.  Good luck!
>
> --Darrick
>
