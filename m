Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A012F84D3E;
	Wed, 20 Nov 2024 15:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732117006; cv=none; b=s3Lf5/6psa7kcZkocW2x2mqScicXzqjREtGPMphEk9inLsYJVOhWvTVBxAOBFj0DbxLK7sP58eyaWYPZ/08LjZLufHB7NzAujpYIVxIfbKr/g9M3s86hLmtoGYfK2+gILwP4tMbiL+0Sl0y+yEwvUEJujOniu6hdT/yiGQ+uRz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732117006; c=relaxed/simple;
	bh=rRQ4OBZRgRUT2QDchNqnm2+yTXcDEmctPLBAk9SKaYc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RBsF2N5X3EoTYaCy5IIxIAV7Vk/4RkxXUR7laAszgXwNzzrBNZFARfTgyjnpEo4TWHJ98o+KsUmN+bPHuQrm2Y9g8iLwaSP40xHv3zBwZONBPyDb2LdUFjm4AFDzWrH5CL1Ay+fP6cD0KHV2OqldX+2+CplocGokqtHMW+5d9Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RiX0pJeV; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RiX0pJeV"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2ff3232ee75so25814021fa.0;
        Wed, 20 Nov 2024 07:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732117003; x=1732721803; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J4480msYWYSV1aWn6FUea6HU3tyZnI63NOgH1lUg7gA=;
        b=RiX0pJeVzQ7fdQ8P/OjjNe3lUqpRlEwSN2X+9+T86/yH8PoHav9OBJOI7gymjfL4Tk
         8u3JJ9w3uU1Y7GiiVbSok38oW2LB6KiVSmdsA88F2tBv+eHzu09DMCdLm/nsC7B3D5SM
         xdWB5bRFNowvFMZcge33J41ddTxGILfwLfDh2j9KPsxjeKnYfca7f6j8m65G5u0TaIvv
         8PM/8qZ1GnlGyQQxKXr1gWmomSO5mr1zH2A4od0XGIIJ5fHTZn7sngKINzXhs8UktB88
         e9MRTyPrOp2i5Z6nm5rZwLpqJrHvSH5y34UHR91q1RvrNtmrmnPrvGB4IMzt2tg6v31M
         dJow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732117003; x=1732721803;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J4480msYWYSV1aWn6FUea6HU3tyZnI63NOgH1lUg7gA=;
        b=uv/aHPSvsYpE0UaYQCseffrsMjAu1v7sSxF5Yc6Ubpal3W83D3dEKAFKbSpJTePj11
         UVkiBCfgsofWl2Iixzsp8iFs/l/iijf2WeXIlVXOgdkHBTKPdeBgHdMOGDukYSf3Ttn+
         9c6niV6F7WdeLHuEiGOm8Kf8/zULESZvolHd/w0XDtM4cxSl3daDoCEfvV64KeR2sRww
         uwqnt0IMVUlZ2STWl9QlX7VMdTS50VVcuOLxdBYWMAW5jX/CA++14CVDMq33DAI+i614
         CZt271AXHOulYYwsBYyfI1mPpHV1JknP3HEBkXXIMYjixuguQM6qJLQ5OgiMUv4+pAMQ
         cYnw==
X-Forwarded-Encrypted: i=1; AJvYcCVsvD9qfmq4JtGxeY4AKPzXuKlMwtSljoyzf1R9QLoe34bkJkcPV9HdoaQsc/u8fA4rB5KOgxFtI4obPyo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyng32+K4oOo4LJJc4wDML2RHZB1cksDayKLHPdO6TYTb80zBtD
	vt+9BR4UIy3JdtYC78McOAlxXoOnjPiEZwghnPiAe7VJcQmG4TmdllmK/ZasTq8fO9AFUf/Vx6v
	aPoyzhfihD5w69y9RzW8oQAhiHp4=
X-Gm-Gg: ASbGncu/UoK2a+HVTC61PG2Gcg2LbL3aE4dX5vQopt6ojJJpeqismN9Ws2jHtrqUQcx
	Wv4ViMA8bTUKZVgypl9kdQIAcv1g2YhQ=
X-Google-Smtp-Source: AGHT+IE0bt43BHS9nIQ63LeFwzqnyam1nsHgEkDbLK9lae8oPkZ3wEfyCNHxDLWM8UkdXvP2YPMfBynx1DXZIZnRzcg=
X-Received: by 2002:a2e:a5c7:0:b0:2ff:8d7e:56f with SMTP id
 38308e7fff4ca-2ff8dcbee1fmr25369481fa.32.1732117002554; Wed, 20 Nov 2024
 07:36:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241120150725.3378-1-ubizjak@gmail.com> <ad32f0aa-79df-41b2-90d0-9d98de695a18@riscstar.com>
In-Reply-To: <ad32f0aa-79df-41b2-90d0-9d98de695a18@riscstar.com>
From: Uros Bizjak <ubizjak@gmail.com>
Date: Wed, 20 Nov 2024 16:36:31 +0100
Message-ID: <CAFULd4afgt7LtqzZ_oFDz4wtMe+TZKGX3E_XpSo2HD5rQEvOjg@mail.gmail.com>
Subject: Re: [PATCH] xfs: Use xchg() in xlog_cil_insert_pcp_aggregate()
To: Alex Elder <elder@riscstar.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chandan Babu R <chandan.babu@oracle.com>, "Darrick J. Wong" <djwong@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, Dave Chinner <dchinner@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 20, 2024 at 4:34=E2=80=AFPM Alex Elder <elder@riscstar.com> wro=
te:
>
> On 11/20/24 9:06 AM, Uros Bizjak wrote:
> > try_cmpxchg() loop with constant "new" value can be substituted
> > with just xchg() to atomically get and clear the location.
>
> You're right.  With a constant new value (0), there is no need
> to loop to ensure we get a "stable" update.
>
> Is the READ_ONCE() is still needed?

No, xchg() guarantees atomic access on its own.

Uros.
