Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8DB3A4F2C
	for <linux-xfs@vger.kernel.org>; Wed, 20 May 2026 13:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779283488; cv=pass; b=CYKLTwEfvQQGLgzQSb3MBfqTsd3hQq1jp44mjCYw1d8LGFhbU07XU8AoBk0ytYn7qGpAT0G9qpmskRylfIKdxHGaNOlM/3dSn7eC/ao8UA89uBTuCW2DK8QdSlWWJ5s55o2SLxMT0iVZN7JjuqgsIshKeFLgwhI2VUCCpY/Rl5Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779283488; c=relaxed/simple;
	bh=Rit3XOj+nAqSskgBa3AwkCsmGpVaId+gpzvsbFjHRsc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GfE0ST/SNKUpVbyRYLqWW+AEq9w970Ar8OY3hcWNZGTE9dRQOJoO66Q8ROiTjnd5WZ8ovhtazncTqbIdV9NvDJf45+1bMDO7UJAYs2wgPwUz7MhvLu6eDtjZOVrWfpAav3s2QnCS0yuPjUQ8/RjoTRpLp+HMQSUs75IzHfVuL88=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DwKoCw/P; arc=pass smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DwKoCw/P"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-676a89de629so8330176a12.1
        for <linux-xfs@vger.kernel.org>; Wed, 20 May 2026 06:24:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779283485; cv=none;
        d=google.com; s=arc-20240605;
        b=kjmFb8Q7RRQvMiLDWvNE1EIIb1Z0Q39Hy85hU+sYVBALJ85yP85kqaKRd989hWjzCE
         L1aNAx0KBfWe5k9huPosleAf3u2Gu8rLLG+NjAbhkh0Dh0C6asRyNswJuCaS1nL/9avo
         10Z724qz8YRnnerE+WJgazyp8gj5PaMMbo37nP7JydYi1X1qq5qmtW8JqHCUWc8/Wcw5
         HOAgjqMAglkesu/GDJzphS2/NlnIY61Cl4EAgpmUCPhiCpcsWzGMDcbQtWVNbD8UL4xD
         jsBrbAqNwRgJNxqiG+Bd2zVOECTLeM3ZWhOwqsOHDWSAPnktYOMsgBNW6LvfZmCmBQt1
         fviQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Rit3XOj+nAqSskgBa3AwkCsmGpVaId+gpzvsbFjHRsc=;
        fh=nhfX+Z8+BtJ5knfexpMLb/XAMWEXYYPEB930IRFXEpc=;
        b=ZhNx8nmJo5Rl9QTsPoQJfXK+7eVA+8rKApsbw3pddlqWWTUX3oqBOvmFoj2nN1x8lJ
         K6s5JITWmcMRqwrNIe2jcQnQv6O0rlBOkMVOx8YAHNEZzk8LcCYnAC8iZPDkc8K8CBJp
         fHP6SRuXBCxbXjcjogJbyuN4WFY6d3vUB2qJcuDxy6tTwgRMCzg60dKpHH6KApATvRi5
         LpQt5eI4Z4tVkeFMeOs6X0gFFpkqyfRYp1Eu5FXtdBV3RD3iLaupGQKzAXl7VHf6+9Iu
         czwD0A3HgApk8Fonn5nGUaWEj43tbq5eLhLSDsufaEBUCU1GfrkdjSvC6SxGdlVA1WNX
         DU8g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779283485; x=1779888285; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rit3XOj+nAqSskgBa3AwkCsmGpVaId+gpzvsbFjHRsc=;
        b=DwKoCw/PT7mQ10vNBMUrsTEgJ/KD0xilvxMKeI+aiO7GBDvQq7XKJJ6kyNOOhWPRFC
         qAQRff8dLVNruj1MIMY+n75FGD1FnYxldtzIkNgu+HLnxNvGPuCim/abv25tCKOX0c4M
         B90eJODV43Mun+Az+kck902Vl9CJYMttimw0RXk+sRWyhFsmweKWF99SC7Mwan6wOHFe
         ECm4lVjQVlTWgUeeELJ94rOZn5g2GnGibbV9qeU8cfV+5qB+iTfrqeWOwpY9JiXUFeT2
         qwR5fHpfjh1a5z5kJLq0R3QIzdIesXZWyZHMBltpqUvmJGhNMGt1egwYWRwxhVmDRO+w
         Lh+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779283485; x=1779888285;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Rit3XOj+nAqSskgBa3AwkCsmGpVaId+gpzvsbFjHRsc=;
        b=LR84GU9TgN3AISoBONz4ZGnrp3owuNsYLu03IhE1z67QglbjGgAejxwqWRso7YdeUm
         MlDx5lxfaluH2tKGeZIa9Cpncwe3uTlTphqsru0kkIcDIqCD6Bwvw/dEeOd+DUNUF47z
         hb2m81bz2+mRO6CN82BACepqY5/McAuTjpM/OqZo+N2XqOImjk3lXsaMg+HnqkrtqxTj
         gRF9EIgyT3+9N/jymxoxFQ9BKKzhkvaQEK7W9uz/jXTLqWF8gMKs6DWseo1FrChKC489
         dvlVy22XGUnMA+Id8owaT1jsyk1JBSnZaUiPGfiYL4Bt/swze5/yoKev+COvUai8nRsE
         sEcA==
X-Gm-Message-State: AOJu0YwbOJVxocdSuRCh+CSoTaKaC3cJULuMx8+0etepKuP9iHOT2caJ
	39A2E+D8ZeTMKVdt5vm2TBFKfE5tFwCciIwZdn70HNA0W55vDlDSGYt7lP0u8G1zRQ0U+BJDV0G
	dK+USbcuOKv9ofGjv3CaZrR1gkOVFV+E=
X-Gm-Gg: Acq92OFVwK3FRlBoBBEJF9hFvsfQ0fYn5yI29v3AMADCpBbv4irWqpFgqY6nwjNacQr
	ARdqs2RP8VTUxv9j7Q/7YRp9V7VWheYx8KW8yK6uOdyQ7/JaKR1Ey9HiTdqsiLqnQb/gY3zRwGk
	Q0ZSLwRgetGwd/4Ue43PufNQg+9r/GC7p52g8kVkMjSQxcztDZJB6ZvMuSh3hTUaBOoINamr3Fx
	ktrDIB4xVde3iHAcZd+uj3dVaCKknn7wLVcgPh1NAUcy4WSGSBcy7ypf5J3LSxgie7c77HppO/V
	s9W+FC8hDaK/MnagHNn7la/H/2pyjWa/oQ1uJTKwiDN0DOm5oB8w
X-Received: by 2002:a05:6402:4313:b0:687:285d:44a3 with SMTP id
 4fb4d7f45d1cf-687285d465fmr1620985a12.15.1779283484506; Wed, 20 May 2026
 06:24:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260520123722.405752-1-aalbersh@kernel.org> <20260520123722.405752-4-aalbersh@kernel.org>
 <n67pde3prjxt2c2u2pvjytfw7uzwbeij2yljlrwh7fixcgnzhp@piqsltgpcc4v>
In-Reply-To: <n67pde3prjxt2c2u2pvjytfw7uzwbeij2yljlrwh7fixcgnzhp@piqsltgpcc4v>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 20 May 2026 15:24:33 +0200
X-Gm-Features: AVHnY4Jb9lW17aXG5JPAYjGDiGqwrTNH7OJH9zvcsbDKfZCeeZ6RTdTNxiDlapc
Message-ID: <CAOQ4uxiNN3U4datJb8kxxGVp7VNRFZB6_zEnO76kh9oEjE_-bg@mail.gmail.com>
Subject: Re: [PATCH v10 03/22] ovl: use core fsverity ensure info interface
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, djwong@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 20, 2026 at 2:54=E2=80=AFPM Andrey Albershteyn <aalbersh@kernel=
.org> wrote:
>
> On 2026-05-20 14:37:01, Andrey Albershteyn wrote:
> > fsverity now exposes fsverity_ensure_verity_info() which could be used
> > instead of opening file to ensure that fsverity info is loaded and
> > attached to inode.
> >
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > Acked-by: Amir Goldstein <amir73il@gmail.com>
>
> Amir, Eric, this is the last patch missing a review. Could one of
> you have a look at it. Not sure who should review this.

Feel free to upgrade my ack to:

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.
