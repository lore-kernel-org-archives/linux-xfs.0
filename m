Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9BE41DDE5
	for <linux-xfs@vger.kernel.org>; Tue, 24 Feb 2026 06:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771913867; cv=pass; b=murYM78eORVSwLdBCFp9ymXLZVqQ+8ABKKTiTy/PgNUzPObKCS4RWl0OkzmdqAGtfdRDgMZHUa6ZuwCmX6nx7hHSd436Yn+djqVA+1X8+1pkM/rM0sDmbVZFPg/cer+vRKpyTgLePPkn7z8lfu1U+BH4Yedg0Kjt9/ABSGJPLZc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771913867; c=relaxed/simple;
	bh=2z0EOhz8K0AmNpyEL7wPeiJNKbnFreiq+QhI1xzR2OA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LZUz7JDIcoRY5KgFi63znw5ltY4tQNfZeQhDapPSDzKCWFLd7peZ7u87DaESeY2VFSkOVSAA1j786Ke/N9r7yxD2WnJ7hR/jN2w0SM0rMLk0A2R+dUBWKG8gbntCmAySYUduoKZB4hM0zBsyE7XOdpeSgiCj6g4yEU6glhv3gRg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XV1ICedM; arc=pass smtp.client-ip=74.125.82.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XV1ICedM"
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-2b4520f6b32so6269442eec.0
        for <linux-xfs@vger.kernel.org>; Mon, 23 Feb 2026 22:17:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771913865; cv=none;
        d=google.com; s=arc-20240605;
        b=JtAX8e01m03zDOkc0EqKljCwM7yeEVe7iR0igoJTSqGgvx4p9tn7GOyDavEp0OLB15
         rtVpJh9D6KrMxXt6IU8FOl0nVAIc6hyYBjzeXUlGj1jJJePMo6mdxMa/KFctXvxYfBJZ
         1HmHkKN4lxjfk9f48dnb64dIayRtHvwqtgPxY7yD7FzaK9jW+RXjkVHU7wxmV8PH9v7N
         JBPGFXD4tLnzM/lPkhb14nj6X6SWGezFvJvD/1ca0oEmRzryofcxM4DXe9V/jq0o59EY
         QeK0H32heBAQoexMIz3wYff6nDy4aCeygNO7JQdhmxUtb0bZJuDFb51QgCjI86SRcuMJ
         H5Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uU4DHnIX8mlfZgVmJu6OlaRk4cJhwTjr5L5mCLu2N7w=;
        fh=pSdrseqNupkxNxqKlXhEMb/2RRkeMT4fn8FFpitvwgI=;
        b=eXzaaFZSneMdzwT/YjWcf1MvS741Kp6DMdVojM7kdQ2+qRcff+O/y4oIc0EefUKPG4
         P+pdQRAHGBGrDgN0S21zjG3FO5tI1pVPBE5ZZa6b73wk1Hrb0OkWZK0iKWjljwOrW7ZJ
         18nmVJAw1N7DR/7+q2jpfaEEksdFgMeeNcuEzslpUvaVDOMs4C5Zkl29bTo5vs0mGg8r
         zeCfYn2FUapPySzfqGE2eTx62b6Q1wXqG6BtWXoGOUwIpERtHEBElYpqghi1O8+avpli
         wrmmb3gwvK5zYFqSVdzx1PLXqKU+4VwpzT5tWmexq1V+lwerfdv10EHxzH8ve3MKXmyI
         UPFw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771913865; x=1772518665; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uU4DHnIX8mlfZgVmJu6OlaRk4cJhwTjr5L5mCLu2N7w=;
        b=XV1ICedM7Z9RgyMAq4GLdw/Z8nR2GE53DWLkszmQT8HVECeHMjSDBMfDW4i8Icyuyc
         WouAfc8bKQppPSnDOJ5/FMGQ0bBsQY25kmv6LdY9ANDYF7aMcTZydU//p5l8olCkJw9z
         uw4cQ2DghRnAakI5GCO7ykDwCPo59wkusT661aRIqkIQbIfj/xWWyF+9sGc56NLtppQi
         TtiHaESZBe9ETJ7q2Habs9AFJILmvLTPMjTtmQuah+ewyXdQK6bT7dzZnjUtR8HjPRc+
         nSGVXUqoeGsa/J2Tb83Hs8dd5+L++m9HjjAI+sTAmqsTO2+TJzvNq0mLN+aWY/mEAqaQ
         KOgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771913865; x=1772518665;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uU4DHnIX8mlfZgVmJu6OlaRk4cJhwTjr5L5mCLu2N7w=;
        b=qSNbOGbq3wdvW/gDr3iRiEGHqwDrsAojCs/cbhnqi+RyYqfqGx2Kv6um7H2MWTStWL
         cjBW46PoL/HTMQ4URMULzi444LGkw629VM/NSsOGiY1l9K6HgnqjTgXOFKjYPpQHkP25
         p8Gju9qxhxhfMR3Rg4LDV2kZpi21IGYB6Ub/zZxt32M3m6uNauMEd2a2jm1VVWZiPe+6
         x9GbZfvlbPKjTwHIdgnLrER/McfxCLhXfF9xSw127zYevxEeymrO4XafX0Jn74xncG8u
         CO6nK7JuMjK9ZIcxTCnFG3N4FQpnBhy7o9xJlgEq9FAEQseAu+unF6OYvun83u/P/NL1
         PiVQ==
X-Gm-Message-State: AOJu0Yx+PueCTZmyIoB4Jnn8v6AakzPP0Pe/znP4YlFwXJzqT9j8PGMC
	jnEw5t1bzEQVjpITvGhXLgjYq6FS+K5DcyMLMK5Zij6wTzEDr6nlmacF0NoWr3pgaWPIL2NSN8m
	mtuqH7QxlyXdXaVQin/ljHqA+8cqRxUcIkLZcToQ=
X-Gm-Gg: ATEYQzx8JXknCCpjCrKHpZsC5a7yTEZrhC5pTQ45FPaZYjdR/CJTUa1lRg/uDQvW+Ny
	HLtlDP1luwvONulft5znd4VpZIdODR40Z2J6amPW+3O//Cc0AYeVgT5rKGC3BsfJZkMB1FbX1BZ
	nGygO4UGoBsS34Xa9jRPy2x958bC7NFLDHdoEYzQk9FS7D6g6VFxjFIBx9uRMNJVTanCpu02s6h
	cdwQln8r5PFcO8mWQd2A5GwwfsKf4qSNDKIeHcGvPcOlA+gf6b7O6oJuF0LQkO4QeyF3YN/kSaQ
	YOJhzWFSIXfG9SSU
X-Received: by 2002:a05:7301:678e:b0:2b7:a27f:3a6a with SMTP id
 5a478bee46e88-2bd7b9d9844mr4366057eec.4.1771913864698; Mon, 23 Feb 2026
 22:17:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAEmTpZGcBvxsMP6Qg4zcUd-D4M9-jmzS=+9ZsY2RemRDTDQcQg@mail.gmail.com>
 <20260223162320.GB2390353@frogsfrogsfrogs> <CAEmTpZFcHCgt_T63zE4pQk4mmyULZ7TfTNqPXDXDfJBma8dj+g@mail.gmail.com>
 <20260223230840.GD2390353@frogsfrogsfrogs>
In-Reply-To: <20260223230840.GD2390353@frogsfrogsfrogs>
From: =?UTF-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= <socketpair@gmail.com>
Date: Tue, 24 Feb 2026 11:17:33 +0500
X-Gm-Features: AaiRm53nsEobfStMKFp3GrS-Qo8KUxykQiyF_8uJvf0uLq8qCz-IKpLNHjV8idc
Message-ID: <CAEmTpZFxZP2K3QDOFnoKXMKZP7pKzLu_aHZpM-wkvC68Lt7UZA@mail.gmail.com>
Subject: Re: [RFE] xfs_growfs: option to clamp growth to an AG boundary
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

=D0=B2=D1=82, 24 =D1=84=D0=B5=D0=B2=D1=80. 2026=E2=80=AF=D0=B3. =D0=B2 04:0=
8, Darrick J. Wong <djwong@kernel.org>:
>
> On Tue, Feb 24, 2026 at 12:29:49AM +0500, =D0=9C=D0=B0=D1=80=D0=BA =D0=9A=
=D0=BE=D1=80=D0=B5=D0=BD=D0=B1=D0=B5=D1=80=D0=B3 wrote:
> > ```
> > cp: failed to clone
> > '/run/ideco-overlay-dir/ideco-trash-o4ut52ue/upperdir/var/lib/clickhous=
e/store/e2b/e2bdef56-6be8-40bf-8fab-d8fb2e9fdd94/90-20250905_11925_11925_0/=
primary.cidx'
> > from '/run/ideco-overlay-dir/storage/ideco-ngfw-19-7-19/upperdir/var/li=
b/clickhouse/store/e2b/e2bdef56-6be8-40bf-8fab-d8fb2e9fdd94/90-20250905_119=
25_11925_0/primary.cidx':
> > No space left on device
>
> Ah, that.  coreutils seems to think that FICLONE returning ENOSPC is a
> fatal error.  I wonder if we need to amend the ficlone manpage to state
> that ENOSPC can happen if there's not enough space in an AG to clone and
> that the caller might try a regular copy; or just change xfs to return a
> different errno?

Possibly. But in my use case, though, I need fast copying without
additional disk-space consumption, so reflinks are important. I=E2=80=99d
rather tolerate reduced free space than lose reflink capability.


>
> --D
>
> > ```
> >
> > In all such cases `xfs_bmap -v  ......` always refer to the last AG.
> >
> > # xfs_spaceman -c 'freesp -g' /run/ideco-overlay-dir
> >         AG    extents     blocks
> >          0        461    6658463
> >          1         98    6406298
> >         .......
> >         15        125    6638281
> >         16          1          1   <=3D=3D=3D=3D=3D=3D (!)
> >
> > =D0=BF=D0=BD, 23 =D1=84=D0=B5=D0=B2=D1=80. 2026=E2=80=AF=D0=B3. =D0=B2 =
21:23, Darrick J. Wong <djwong@kernel.org>:
> > >
> > > On Mon, Feb 23, 2026 at 02:48:48PM +0500, =D0=9C=D0=B0=D1=80=D0=BA =
=D0=9A=D0=BE=D1=80=D0=B5=D0=BD=D0=B1=D0=B5=D1=80=D0=B3 wrote:
> > > > Hi,
> > > >
> > > > I ran into an issue after growing an XFS filesystem where the final
> > > > allocation group (last AG) ended up very small. Most workloads were
> > > > fine, but large reflink-heavy copies started failing. In my case,
> > > > copying a ClickHouse data directory with:
> > > >
> > > > `cp -a --reflink=3Dalways ...`
> > > >
> > > > fails on a filesystem with a tiny last AG. Using --reflink=3Dauto
> > >
> > > How does it fail?
> > >
> > > --D
> > >
> > > > doesn=E2=80=99t help either, because `cp` doesn=E2=80=99t fall back=
 to a non-reflink
> > > > copy if the reflink attempt fails.
> > > >
> > > > To work around this, I had to write scripts that compute a =E2=80=
=9Csafe=E2=80=9D
> > > > target size before running xfs_growfs. The alignment I needed is a =
bit
> > > > awkward:
> > > >
> > > > 1. Round the LV size up to the next multiple of the filesystem AG
> > > > size, so the grown filesystem ends exactly on an AG boundary (no
> > > > partial/tiny last AG).
> > > >
> > > > 2. Then round the LV size down to the LVM extents size (4 MiB in my
> > > > case). Rounding up to the LVM granularity can reintroduce a tiny la=
st
> > > > AG.
> > > > If the automatically chosen AG size were aligned to that granularit=
y,
> > > > step (2) wouldn=E2=80=99t be necessary.
> > > >
> > > > This feels like something xfsprogs could support directly. My propo=
sals:
> > > >
> > > > 1. xfs_growfs: add an option to print an =E2=80=9Coptimal grow targ=
et size=E2=80=9D:
> > > > the current(new) block device size rounded **down** to a multiple o=
f
> > > > the AG size.
> > > > A --json output mode would make this easy to consume from scripts.
> > > >
> > > > 2. AG size calculation/alignment: when choosing an automatic AG siz=
e,
> > > > always round it down to an alignment such as 4 MiB, or (preferably)
> > > > consider the underlying device/LVM extent size when it can be
> > > > detected, instead of using a constant.
> > > >
> > > > 3. Docs (mkfs + AG sizing): when specifying AG size manually,
> > > > recommend: choosing filesystem sizing so the final size is an integ=
er
> > > > multiple of AG size (i.e., no partial last AG), and aligning the AG
> > > > size to the underlying allocation granularity (e.g., LVM
> > > > extent/segment size) when applicable.
> > > >
> > > > 4. Docs (xfs_growfs): add a note that it=E2=80=99s highly preferabl=
e to grow
> > > > the filesystem in multiples of the existing AG size, to avoid a tin=
y
> > > > last AG.
> > > >
> > > > 5. Optional grow mode: add a xfs_growfs mode/switch that grows =E2=
=80=9Cas
> > > > much as possible=E2=80=9D, but clamps the resulting filesystem size=
 **down**
> > > > to an AG boundary, and reports how much space is left unused (e.g.,=
 =E2=80=9CX
> > > > bytes left unallocated to avoid a partial final AG=E2=80=9D).
> > > >
> > > > This might sound like a corner case, but it=E2=80=99s easy to hit i=
n practice
> > > > when the block device is resized to just arbitrary chosen size then
> > > > xfs_growfs expands to consume the whole device.
> > > >
> > > > Thanks,
> > > > Mark
> > > >
> >
> >
> >
> > --
> > Segmentation fault
> >



--=20
Segmentation fault
