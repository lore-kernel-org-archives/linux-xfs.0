Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D959830748D
	for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 09:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758274632; cv=none; b=mkAKJg6znmCg/J51UDF8o+5sJG+garxVhDm1qxLgHLPEqv+CNFESuM8Mz2UUhcrbdjg1WMZecTLXJxsFLpmUFkMajnY3ffV7WJkrrdqCgmxkQGXc48JRspzcgaooYfPTxOIO0XjqV9OUM7dSDTZ8uUFx+Se/YxVzNON0oGrHaUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758274632; c=relaxed/simple;
	bh=ux0ULfd3xCncc0cwLZBeo72pmM0oL3gedYheRT0V9BI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nZ4pXgoN4LzG6s56HJt7bm32w7p68z/Po4KaR3EtYs3bFqtM6kjmXvkU3KYBsqLREDyG7YKU5v39IwHMOXOq26C1MM+LOWHOzwLDX9VOStMoiKMyBcqtFDRvqp9iliI+kf9O6lGRRA8Zw77w+8pOAxo8JBAvaZQgI5Q+eTEsvw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kTok00sK; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kTok00sK"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-628f29d68ecso3624340a12.3
        for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 02:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758274629; x=1758879429; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nc22zviXbCVE/wfqJE1lji2RZPwM55lMyHr7YuKEqp8=;
        b=kTok00sK0f2gRnxy8RYTfv9Ku957i/oopkXKrZIKIsUK/BTNUXpHY3P9umzxlo+l58
         gmXL7I6+DymDcqn2v4n0zUYYLaC6W+LRgwot0DbA/sDDPxDfF7poA2qbEubTEqqN83Kn
         h+Xqek9K2dr507fBzj7N6fDVnkf/6DfUQlNw8K0PqA6UrM64iI19Euwud9OaiSaaccA6
         41SRbLGEJPwGD67x3lljYYSCkw612YJrkDs3fcB+vW75iyTxOI9I+F1NHsx0lZauww8q
         Tt1r8WMxe1BdRSlL56Wt5TdJPP1v3GDYffXPEUuU/9Lwo0gizWG3J5CCMfFrMsAfriEX
         eq0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758274629; x=1758879429;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nc22zviXbCVE/wfqJE1lji2RZPwM55lMyHr7YuKEqp8=;
        b=cEPCBywK5V396CeoCAGAQ0jhdpc59uvABk1HbfhhypZ0nT+w6jahaeN9tizmzP5GqJ
         0XVwQZYpTS5/FsQf/EE6xV93qfKqvOXpvgEPB3/laxA+vtrFNzxOD5xGxNXKb7rhxsGa
         VWztIJW0FCZ+kKs2snpLIaLX28F0ib16ktEWibIuQ8c1MLcLdzVFNHgYgN84bUf1DZLv
         AQJG3k1hhVjBadEW6q8R8vh8GUoRzrezbSYeeWOf1amuBixTUz6KqmEhYzgMR7QldruN
         CpkaGAcueQrb0nOm1EeEk/ROylh0Phc7qsvOAWNiUTHsMDsmpeRHu0HqVXRgiqIHAnh5
         hbmQ==
X-Forwarded-Encrypted: i=1; AJvYcCUC0ZHy+vePati34BtYLuyaGpbvhkyAmTldOViztRF+6+s95JUKnp3jX9DMBH6JAPFzcuVQ0AOKdQE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7NQg2JWzrFDkOk9labIbXSaJdgvSP061aTRy0NGfHfCVGZQJL
	PIfbXo6uXC2LamjJmL/pDzp/Ag+331CsxfcASJRIAQGlGTjnnS8krc863HUwrsH23FDX0ruSyLI
	GSVdksvNrEqWe0DqZs5ezWX5tdwCQnnE=
X-Gm-Gg: ASbGncsEoJt3a7V9LkC7NjuqG1rY6kn6wkUYXf110NghPdOuByhsGLOE/2EQRjuLND5
	d/JZDj18WuEP3VmG54/QLhLtJn9mY1KnTygwqSBfWB7P8AVl4L68r8x/4vl4fuDmqBqCKwoXd2j
	4pCKlPCebh1jbH7I5k05tcfDkrrbiowP/IzQZSJUtKf6LhFLEIxfgWThmVruID1yy7OdZIfECgN
	CyMGBoJ+hCXsz0x685/l8h5nBOAZTvl54yn
X-Google-Smtp-Source: AGHT+IFukV2hHzyYfAw61zA4QToWTJ0gmln+XCIGEGxvWOZGM7oulWjg37nN3xnrdo4Hx0eZ245YAV9OWI8OWD0umUI=
X-Received: by 2002:a05:6402:2344:b0:62f:3135:cafc with SMTP id
 4fb4d7f45d1cf-62fbfeac925mr2202455a12.0.1758274628822; Fri, 19 Sep 2025
 02:37:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <175798150680.382479.9087542564560468560.stgit@frogsfrogsfrogs>
 <175798150773.382479.13993075040890328659.stgit@frogsfrogsfrogs>
 <CAOQ4uxigBL4pCDXjRYX0ftCMyQibRPuRJP7+KhC7Jr=yEM=DUw@mail.gmail.com>
 <20250918180226.GZ8117@frogsfrogsfrogs> <CAJfpegsN32gJohjiqdqKqLqwnu7BOchfqrjJEKVo33M1gMgmgg@mail.gmail.com>
In-Reply-To: <CAJfpegsN32gJohjiqdqKqLqwnu7BOchfqrjJEKVo33M1gMgmgg@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 19 Sep 2025 11:36:57 +0200
X-Gm-Features: AS18NWCnD9OqR8OqnJ_FjK5YRfMqJ_5QvxTbXiPNxb6ZHovm0AhEqankCNyCon8
Message-ID: <CAOQ4uxjLJUng7ug0e5V0qcSy1Qq0Fg963u-yAHcTeUJ6G+RPDw@mail.gmail.com>
Subject: Re: [PATCH 3/5] fuse: move the passthrough-specific code back to passthrough.c
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Darrick J. Wong" <djwong@kernel.org>, bernd@bsbernd.com, linux-xfs@vger.kernel.org, 
	John@groves.net, linux-fsdevel@vger.kernel.org, neal@gompa.dev, 
	joannelkoong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 19, 2025 at 9:34=E2=80=AFAM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Thu, 18 Sept 2025 at 20:02, Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Wed, Sep 17, 2025 at 04:47:19AM +0200, Amir Goldstein wrote:
>
> > > I think at this point in time FUSE_PASSTHROUGH and
> > > FUSE_IOMAP should be mutually exclusive and
> > > fuse_backing_ops could be set at fc level.
> > > If we want to move them for per fuse_backing later
> > > we can always do that when the use cases and tests arrive.
> >
> > With Miklos' ok I'll constrain fuse not to allow passthrough and iomap
> > files on the same filesystem, but as it is now there's no technical
> > reason to make it so that they can't coexist.
>
> Is there a good reason to add the restriction?   If restricting it

I guess "good reason" is subjective.
I do not like to have never tested code, but it's your fs, so up to you.

> doesn't simplify anything or even makes it more complex, then I'd opt
> for leaving it more general, even if it doesn't seem to make sense.

I don't think either restricting or not is more complex.
It's just a matter of whether fuse_backing_ops are per fuse_backing
or per fuse_conn.

It may come handy to limit the number of backing ids per fuse_conn
so that can be negotiated on FUSE_INIT, but that is independent
on the question of mutually excluding the two features.

Thanks,
Amir.
