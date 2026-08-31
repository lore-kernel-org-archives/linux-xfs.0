Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F1842DA36
	for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 15:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788191593; cv=none; b=maOakTPoRqDOxZx3xMFJf0E1yhNAAbdsk3rxv501vqFZ/KFdzQSkq0+rzB1JHqHLBaXbOIzU0XB/bZNAmIsBoXtQR6nh6xx4w0kHQNf3PyNfGOr4c81fG99o1zdOk+YZfe7dYKgXSsTAMJCa7nohzMDn9kM4QQMzWs5aBbMrXLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788191593; c=relaxed/simple;
	bh=gAbvP4+Os6TgV4Ik0HS4ZZfkRe+Ugx4nJWg61i0aPTk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JNjFkLUKj5Vl+3qpwzBcrCL2E8St8ocj3moOx1cHORyjGfzCd6bscaWXibRP6PjZ1Cjr9UmQnoTmcxgDQw5XjBwQqJ509WRsRg8gANlXd+l2DzsZndpw0R93xuDvFWs0HsouVKmNfLlQbpHoGxdFRwTq7HoxKiP32R+0T7eb8L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IOkV0X+3; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IOkV0X+3"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6a6143cca69so5477729a12.3
        for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 08:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1788191589; x=1788796389; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=APi8RFdHET1R86VCMK/uG53ii7MkEL7yOeVhbVqENNs=;
        b=IOkV0X+3DWeSylG3nwX3ntQLvRbq07e9Kl+w+xahqBXuJG17ou8J3AzkzhZ2a912FV
         rEvny1eBudb6k8MOsV5RUW+miuTizAAe3FDBNjjOV1JfiUzphXTra8LUYgKu6LC60yH5
         SeTJSQNdaPZVR/lf7d6TZ3d0Df0EO0/rfqCl0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788191589; x=1788796389;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=APi8RFdHET1R86VCMK/uG53ii7MkEL7yOeVhbVqENNs=;
        b=Motrc9y6G6rSlkvVQ3L67dRQ9AuRK1cg9U5JYUevij0X5SBxdqGfKkl2v5sKkuojOQ
         2+cHpZHTeHxnWQ6sTuYjUwY7zplohQbBFONwxAul+qijZWEjRTkij6x46NEHDEj/2aOu
         45FlDCmqBjxLOqA8u9EzfNqhPXjM/Bce8wIhLXXH7TWGiiJbs0XCfes1IArluDkstW5E
         OavRRGiopIkfZv3QZol541B9aqpB03ONgpw66N+NwOv7Gr4izMEmz1PI2VJK6JpT8TnQ
         lVpu6p/uD3votk5aLp+WS+lP2vXHaavW8GJ2+ya5p4FZwbOiRUQbjm8edKqN9I3X49e5
         jU5g==
X-Gm-Message-State: AFuF++mrUIuLdQg+5itVUsaOYgSfu7c6+GUOQ0Z21qR2yiOxHqglxa55
	KfFAf3AkfvRA3pqZfcQFBTd6//3gHpLTawJNJ926uquzo7diy+tZAZ0hEwukPOM0Z25ZnmkNGgb
	QxDpoAJ6gVg==
X-Gm-Gg: AYBFou1W52LPerasjO3OgT8hL2htrD7fLsUA8wSHliB1PtLxcOr1DFeKwYR8UjEyY3g
	Tt07offx9LBjBMScn89sX6nknohONTahxlg1OR4QNY5dgAeveztX6C3a/5zCRxYL5asHSSMwBNg
	EvyQyI2B1IQ52E/c60Jh7FM0vTeTiNLcNdWPLENRbIeNcWhZFE15qyK/zxMiuqol8EqTQLKf9ju
	IfePrNqin7jbGx1coaLPENhIaXpceq80PoaYVPBzDsL6eBz/hvL7ybVnRogYHNJviMaIDwkIe/j
	+tqAICo0bQRpCGLdhRM8T2i5F8ecCLdMo+iNYeWabpU8DYmaqU+m5rSCwvqrk7cVLqeNx049i05
	6NHFbwR1lfPeNutBlqj8zZ4hIAPn/TXa86c7S7iJ5r3LkgXiVxPajimMIc/ksPiiq4yR1EjP9Hw
	Yixlc6/XSz1alQeJUi0iBodbMNf0xP3GizXgGhSVIwoMhYcuUpzxjpnEaszWhuQyQ88djuiJKMP
	QdiY7twNAhdo0gSZs4jmf2zIinpzuv2SM2Lhg==
X-Received: by 2002:a05:6402:434a:b0:6a6:32f6:f with SMTP id 4fb4d7f45d1cf-6a632f601a5mr9095863a12.21.1788191588110;
        Mon, 31 Aug 2026 08:53:08 -0700 (PDT)
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com. [209.85.218.41])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a611b675d1sm3967494a12.9.2026.08.31.08.53.07
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2026 08:53:07 -0700 (PDT)
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c15e2dab83eso95599166b.1
        for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 08:53:07 -0700 (PDT)
X-Received: by 2002:a17:907:1c09:b0:c21:6f8c:2335 with SMTP id
 a640c23a62f3a-c2557465a51mr1726543466b.16.1788191587177; Mon, 31 Aug 2026
 08:53:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <apUSmA9aI8wpLyXf@andromeda.toxiclabs.cc>
In-Reply-To: <apUSmA9aI8wpLyXf@andromeda.toxiclabs.cc>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 31 Aug 2026 08:52:50 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh+Rxk7kuzGMX5UzkwROsCsCuk-ZvGGnRCiU0T3fecsMQ@mail.gmail.com>
X-Gm-Features: AcwNN1UmIpDKF1-V93kSJWvjIylEwF38zIAvZMeoC1EQJnn7dTeGrp8rc6kaSko
Message-ID: <CAHk-=wh+Rxk7kuzGMX5UzkwROsCsCuk-ZvGGnRCiU0T3fecsMQ@mail.gmail.com>
Subject: Re: [GIT PULL] XFS: Fixes for v7.3-rc2
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 30 Aug 2026 at 22:53, Carlos Maiolino <cem@kernel.org> wrote:
>
> This contains a set of fixes for rc-2. I just want to highlight from
> this series that it contains a couple patches for capabilities subsystem
> and another for the quota subsystem. All three patches have been acked
> by the respective maintainers and they agreed for these patches to go
> through xfs tree as they are dependencies for a xfs bugfix.

I would really like *some* information about what the actual fixes are.

As it is, I made some sh*t up myself. The end result could be better.
Much better.

            Linus
