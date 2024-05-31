Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796897483
	for <linux-xfs@vger.kernel.org>; Fri, 31 May 2024 01:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717117960; cv=none; b=G257394Ub8Mpr7YcPHLomvNx1RdUonTNnSHsH5PVhw8yuRnpvEzT5FZUFsJpm5TzNmWvcR9rsc7Nqj9LNmek0cuaVbKc01LXm1Jl65LEFTEGhFpjhlsmYSe+f/FPCkiozgpfPD/CmrHcNq3p9nbyw2zA1/+Dq6tvh3AEAdEoXzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717117960; c=relaxed/simple;
	bh=5gMid+lXOVXUNyyHrlelpW2Aparu1oapiPrImVtXqNI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HwrO0w2S+bwo60m2lqrvKpHDh0KRb/ZIB3RckBUn7a5S0TOh4Gz5k0FacXdEj1mZymAhd/lNBAvTw1Dhw4pxU+idM9P7eZIaAWlQbBQCC4ZbKqjC4ZH85fkstokbMFsWHeokKz+uEQCl2tbtJTiIuyqylOsEe+O4B6gMYZ9cmw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pKdHHpCu; arc=none smtp.client-ip=209.85.219.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pKdHHpCu"
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-df4e1366da6so1351396276.1
        for <linux-xfs@vger.kernel.org>; Thu, 30 May 2024 18:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717117958; x=1717722758; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jMNqn+VzgJDh1HW7KbXMrJ/PRgsITmUpxO+rT9xOuHw=;
        b=pKdHHpCunac+olP37ylCQyagAw2GgkFNOhIBqJLO33cyqSPBSPkjjqlCj8f+o9aPXt
         1PsbqlrGOHpXk+MwiESe7UQQ9aApXy26uQNpZojx/HU34BMe94ligtyydgKVgr8E0Yp1
         Sk+PjuY2MC0wS5aZiEuXQ2rs8ELcHfrzfV5veRrKWDZmTGwmvq0umG8+zm9zc4B2gdct
         O8FQLMbGkp8cQg3D8T/n9EGotTFRA/4vDHE/s8S1If4sOV0mg/Ec5znDN9F5tDqW0HhL
         we/2I1faIuZkv3Ypxytu5+6w1KL8plReH0rG8hJQPxchkwXcHzlN4nLK7pabT2dqVAAt
         4LCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717117958; x=1717722758;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jMNqn+VzgJDh1HW7KbXMrJ/PRgsITmUpxO+rT9xOuHw=;
        b=weOFeCBFS3LbexuS3nMX5TfuSmBAWYB0h4qy6w8ebZeJmgRzJC/d/S4+CTn0AlMuDU
         Xr08+QQKxlcHoFTaCfGbLueCQecAB2vXh1ozuxrU6xCuTigBjytsmzkOoqTWCpGweTVM
         VFFtcqXTDIrkwdHhz2vpW8wE60/T7+AQS59TYp+jpgIh3+9fK0GsmgMCq4C5AwJKOGbR
         ZEedAmIV90h2UrMCnbR3MunMmfYnLu+TvixmQDAK7LXqOY4ZtYx9SqQonjpDcdLzt8XO
         1WIZ8yBHPjT9XrsAn8bV4NrK+ueRqOhez0fXWFuEjc3AzehJN12tOI7N+QSMBnQS/517
         lsbg==
X-Forwarded-Encrypted: i=1; AJvYcCWIu1SqgXuaj0P9RImGPquOHm/+MPUjw3BZQsVtj2ek6fDPN8y9GOKZf2Jp91gF8IPe04YyytGhh8uBT9HOcg9KeB/Q+HCfSlq8
X-Gm-Message-State: AOJu0YxWVJiaNNdN1hb3Z7XQkQd3SGUF//NVVtA+neve6gVLT/zttwsi
	XSvSFXKi4q93qtaiHBk2ne0OjPCjwhX9fI6Tj74zwl/a2x4OmJmvHHlnWzMthecqfDvr40Oi3QL
	4TQ9kE33ystEWJelNEdlNHVc0dxSJq8sDQwcP8M3aNK19m40tJgRy
X-Google-Smtp-Source: AGHT+IEyzQN68Z9927YWtfSuyw5MimPU5RW3qAkfRnjlQu/xRcgG10tMJeHicBAyvk7CkB8qMf3QDT+AYR+zs+fAeBE=
X-Received: by 2002:a25:ad65:0:b0:dfa:7233:4942 with SMTP id
 3f1490d57ef6-dfa73bc2869mr586621276.6.1717117958213; Thu, 30 May 2024
 18:12:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Zlj0CNam_zIuJuB6@bombadil.infradead.org> <fkotssj75qj5g5kosjgsewitoiyyqztj2hlxfmgwmwn6pxjhpl@ps57kalkeeqp>
 <ZlkICDI7djlmpYpr@bombadil.infradead.org>
In-Reply-To: <ZlkICDI7djlmpYpr@bombadil.infradead.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 30 May 2024 18:12:24 -0700
Message-ID: <CAJuCfpEz+-VeE0-6Z1ks7BTLGmC7JOsM9bHKN5jMqgn9rutmAg@mail.gmail.com>
Subject: Re: allocation tagging splats xfs generic/531
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, linux-xfs@vger.kernel.org, 
	linux-mm@kvack.org, david@fromorbit.com, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com, 
	kdevops@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 30, 2024 at 4:13=E2=80=AFPM Luis Chamberlain <mcgrof@kernel.org=
> wrote:
>
> On Thu, May 30, 2024 at 07:03:47PM -0400, Kent Overstreet wrote:
> > this only pops with kasan enabled, so kasan is doing something weird

Thanks for taking a look. I'm back from vacation and will try to dig
up the root cause.

>
> Ok thanks, but it means I gotta disable either mem profiling or kasan. An=
d
> since this is to see what other kernel configs to enable or disable
> to help debug fstests better on kdevops too, kasan seems to win, and
> I suspect I can't be the only other user who might end up concluding the
> same.

To avoid the warning you could disable
CONFIG_MEM_ALLOC_PROFILING_DEBUG until this issue is fixed. This
should allow you to use mem profiling together with kasan.
Thanks,
Suren.

>
> This is easily redproducible by just *boot* on kdevops if you enable
> KASAN and memprofiling today. generic/531 was just another example. So
> hopefully kasan folks have enough info for folks interested to help
> chase it down.
>
>   Luis
