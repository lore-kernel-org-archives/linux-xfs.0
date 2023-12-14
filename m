Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zg93vykZ"
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8836BD
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 06:55:41 -0800 (PST)
Received: by mail-qv1-xf2e.google.com with SMTP id 6a1803df08f44-67ee17ab697so22464356d6.0
        for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 06:55:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702565741; x=1703170541; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bgs8beqFiekckw3WR8YiKzI+yNleMXeH4aOT2b+WN64=;
        b=zg93vykZglFFbm2Z1nl173j4Lx+z4LgOTPy7DPNDDN/n3N7iLfexrr5ymdAmy29gIG
         IdoPqtJuFNlFwZvOrofmuoYuh+yt/2V0U+IV8hc+9dFewlfFLd/XA/azu99ZdzJmGThU
         +eCwbHDH8s2gfB+8rkXnKL1KPumXwy1nWtRFbeVhYU4GaHgXPZeA0/cUkxW24LQddiv8
         snBpkuouOR1lZJNMQ96/QyPrwlrCeljqkDGEZhcJTfkQiiKHdeCDv/JG9yQopnnmnk7K
         OfYVqmhuRcRwyX8LCBfKQhjbraNeaOIsMX7eX1C1cCnlAUmto1bqHgqcUKVkPQRFqGP3
         tgeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702565741; x=1703170541;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bgs8beqFiekckw3WR8YiKzI+yNleMXeH4aOT2b+WN64=;
        b=VNlsSOQ787wqA3Vj+QVOWcTPRZ+q8PBxbzyaXMBvIM7wpvi1cxY+R0+/BIpdtGa9j5
         9Hm1N8ZnK4TrbYDx0ePAYyTPWMmoSSYBff5Lzn+YnsdqGXRo5MH/m4t3HKRttpmPUdGU
         6cD2mOpkUp4MhXw8y31TPr/zKqCxu2AD2sxH5guA4aJllr0zOaG8yeEj3+osKynumlac
         jypdJ8JM0t6yVxY+nHfpP3kN6oYFkaYBNSjK38l/5K3tnbkq8Iyxv1Fn8IZAhK+U9gKl
         AB2hm7Coqqa3yZoHPHsoZC6J71zryqfw/wCDNR1vj7ggngUBCDkckv0qCrzgIQwo/6t6
         8NAw==
X-Gm-Message-State: AOJu0YydYdkgQRnPdOItjQRnRvsForSx+KFjaOh+mSnFNFItU+Oo51jv
	UDQwr1cMw2WKT1G8/ZNnGBA7odUTWDgn22ERf9Zz7Q==
X-Google-Smtp-Source: AGHT+IEsLmHEUusvZQFiGgThJYCfYEu5uL9Ur9BmC1h3zHzuSXlUlQi5+C6Xa76eUg2ZzWa4mUxgAR4OBzeNO/8uOFA=
X-Received: by 2002:a05:6214:16cc:b0:67e:ef8f:7978 with SMTP id
 d12-20020a05621416cc00b0067eef8f7978mr4056082qvz.30.1702565740942; Thu, 14
 Dec 2023 06:55:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <000000000000f66a3005fa578223@google.com> <20231213104950.1587730-1-glider@google.com>
 <ZXofF2lXuIUvKi/c@rh> <ZXopGGh/YqNIdtMJ@dread.disaster.area>
In-Reply-To: <ZXopGGh/YqNIdtMJ@dread.disaster.area>
From: Alexander Potapenko <glider@google.com>
Date: Thu, 14 Dec 2023 15:55:00 +0100
Message-ID: <CAG_fn=UukAf5sPrwqQtmL7-_dyUs3neBpa75JAaeACUzXsHwOA@mail.gmail.com>
Subject: Re: [syzbot] [crypto?] KMSAN: uninit-value in __crc32c_le_base (3)
To: Dave Chinner <david@fromorbit.com>
Cc: Dave Chinner <dchinner@redhat.com>, 
	syzbot+a6d6b8fffa294705dbd8@syzkaller.appspotmail.com, hch@lst.de, 
	davem@davemloft.net, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 13, 2023 at 10:58=E2=80=AFPM 'Dave Chinner' via syzkaller-bugs
<syzkaller-bugs@googlegroups.com> wrote:
>
> On Thu, Dec 14, 2023 at 08:16:07AM +1100, Dave Chinner wrote:
> > [cc linux-xfs@vger.kernel.org because that's where all questions
> > about XFS stuff should be directed, not to random individual
> > developers. ]
> >
> > On Wed, Dec 13, 2023 at 11:49:50AM +0100, Alexander Potapenko wrote:
> > > Hi Christoph, Dave,
> > >
> > > The repro provided by Xingwei indeed works.
>
> Can you please test the patch below?

It fixed the problem for me, feel free to add:

Tested-by: Alexander Potapenko <glider@google.com>

As for the time needed to detect the bug, note that kmemcheck was
never used together with syzkaller, so it couldn't have the chance to
find it.

KMSAN found this bug in April
(https://syzkaller.appspot.com/bug?extid=3Da6d6b8fffa294705dbd8), only
half a year after we started mounting XFS images on syzbot.
Right now it is among the top crashers, so fixing it might uncover
more interesting bugs in xfs.
