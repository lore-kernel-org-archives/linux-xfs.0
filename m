Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D16B4779B3
	for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2026 15:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784128075; cv=pass; b=oGaJOZ5uysY+UUoUrTar+TCqFf1R7XPGbEM8ymkC88Hxn1a+5aOClr8Bw9xqn9Azc5fm57nTL+MuTezA/DhHNEf6C1KTQ5iB85mc8irWQY9LIecOnGNYHeU1o2DBK7sPXR0XMnPdINf60Rr24Rs8iOiJwKYykLaWYhVFM39dxaQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784128075; c=relaxed/simple;
	bh=Dn9V0XFYZ9qRdhcIqs/LE4TMkuCZ9dpdgdqLukvnD4c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f7x+8DzRQJFhcbltQPv/sLlvxuh42WweeeOnoG8kgTF0bup2nVNuOh0IMm4X7VMEnSABkc2XboJnKkoUBw7Eeof+Cm1PWD4n9ACYNNuCRrfwZvZeGK5K29YS4XjohMZB5zlc8vX98XFrNibWDy7Bg6rNqj6d/zaHwiTCatP83PQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=reillybrogan.com; spf=pass smtp.mailfrom=reillybrogan.com; dkim=pass (1024-bit key) header.d=reillybrogan.com header.i=@reillybrogan.com header.b=D3PC4GtV; arc=pass smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=reillybrogan.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=reillybrogan.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=reillybrogan.com header.i=@reillybrogan.com header.b="D3PC4GtV"
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-489f3611e0cso3689911b6e.1
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2026 08:07:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784128073; cv=none;
        d=google.com; s=arc-20260327;
        b=mGvlzx9NguzfL5VPMTl7XjS9QFDkO3WP6LVP+yFj1auzCupIs+yYeTCaTNMVb9MMwz
         wIBeTjIINZyrJ3Jll9HYdRcI2Z51+/XHVqjleiyC0V0kAYD0tQKrdfongUTFR0SE09WH
         3jos/jkVAf+M7olFqPUPixbcUccIFLR3rCNQpxG4zDO0OQ69Ww5C51P7+3bCmI5xn9gG
         4pHjGzZQ/KFBxxT4fTJ1xxSySIO5f9yn5RyJJyX5rv6BpSn8g/TM+i3syiyQh2CDUkuv
         f3OXMWnofRGco4RJAAQDPj17hqngJcesEz0+B3DrOtXVjKLGbSSX4JQ8UeENbYcMS9Bt
         63hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kRY19XIQ6ifI6Kv0H6iaupd+RiC5Hhne23xpxCVxjXU=;
        fh=qSc5JJp6wQOvJgVLnZPmXLqPWV0QqQinStwCDAA/NxY=;
        b=VVDfATRDTXLSQQMlU7Hv3MyIUgpVaDm9UjftaI3BrQ/P7n11T9HPL241DMkdwNL96I
         382869b5ru1RDPQpuZ4XLv4GVRTwSMnYVxhmxVDwJc9ODYT5ZQ4FpFCSNWs5W5+q4GDQ
         hMAmGjJoocDZk+VY/UURF63ANkOYkcO9xJdqtdLO0siQH7VJVmNXnEuvOk46p5VXHxFU
         ZH3ZJYFQC+NN43uOLH6HRrn/UqQGEHtZ9kU83jpeu46/DlCxg5PZiXHWwO12O6aJXttY
         QxwsemYfZthoZC5jvR58m1GZ/6jrypUKbf5mYqcBAOg7l1XWLkCEre/DcyXgqSRwCxaJ
         IOIQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=reillybrogan.com; s=google; t=1784128073; x=1784732873; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kRY19XIQ6ifI6Kv0H6iaupd+RiC5Hhne23xpxCVxjXU=;
        b=D3PC4GtVt1XfHtmtSyLcdfZSOHN240hYfL9KRrp5UI32ZxPlFAukNAS0YUd670VsyB
         BgtG+HTFwrStVZrdfetsD2nK/UrYP1JwTyk3DY/mBIVbVpK3eM+INODQqDBMUWNEqdlm
         39j+UZ1f2CNk30QhvprkWNUxcGyU3fjS8dnMU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784128073; x=1784732873;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kRY19XIQ6ifI6Kv0H6iaupd+RiC5Hhne23xpxCVxjXU=;
        b=eEQQDWFAncUedoThTqUc+wAKFs9CJ8tzelzOEBLMyqTziwBx/vFDhyRS69uonl0lL2
         /Dr5Z4YORBLYkFJZ8QzvCTwKQ44nq7G4Fxu9/95q52Jyawg10PxHPZqr9pY1WzJZ64yF
         v9XrQUVJgaFNAGzx+LeTe4e7q+b3Pa3VDBCvur7XpRf0d2zp2nwqvkkoFT/hNUjXkevP
         psmEgDZpPYDxeU2jddl8C76A3XHdwTd54ImrPhdbtoqH5+NUyDb0Ff/v5kFi1YlGMzZ2
         xC73LrJali81bWggz2DRwoAIomYVdeHLs4i3rpMnXHkE8Z+iDT72MHTirYE4zUxinHkf
         YwPA==
X-Gm-Message-State: AOJu0YwP2+Va+UnpqJ5MmQUqPs/t+s6fC6d+VVCrMoBZLdJ0HW16qZ5j
	NUuUpNoM6ShbeAmeEyM6+LmpW5JQSGcGnkv4/Isg0T5dxWQJv6NsvYd+rS16z4i+jL8v8+drbiv
	HCfpFLxeCov3+4Yf8kWbkddbQ0hpZDVhsGLpIKHysd95tv3+4vLSab+fWoQ==
X-Gm-Gg: AfdE7clbs4dGjqucC/s9XdeqNLi0fitJMYpDyCZ4bTvy0qRoqgiYC5sv0GenxYwuGJA
	c3rTMRjAob37wcs2qR+lEsM2PC0n695hoRS3xesVzE7PXvIjxak7HMtV5krerrPI3T5PK/JqndT
	YCcH69llds5rmcFRYRC3A4ThbGePE7dbEcs1I+CvwR9HYy+WddCle2wgpw/GYoU+6oWK/2vSzEj
	OC95/1LDWhDtoLArLhRsJaXPCC8/2bsuwDJuDf7pRViihnngbGqNEmXaZodibPd+3iwP6UUv5SP
	A5Aas8Y=
X-Received: by 2002:a05:6808:5242:b0:4a4:2538:7620 with SMTP id
 5614622812f47-4a4959d6a96mr2038241b6e.0.1784128072809; Wed, 15 Jul 2026
 08:07:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CABqFQkar-sMMyZGw4KfAV51x7F65ddF7d8cszQ8iWiprvnKMFQ@mail.gmail.com>
 <bf7bab13-51eb-8be8-a875-fd9d02391f51@applied-asynchrony.com>
In-Reply-To: <bf7bab13-51eb-8be8-a875-fd9d02391f51@applied-asynchrony.com>
From: Reilly Brogan <reilly@reillybrogan.com>
Date: Wed, 15 Jul 2026 10:07:41 -0500
X-Gm-Features: AUfX_mzYtfMCXLC0nbRRVh9fu5VxtI45d7vvlecIHWUDHxx8J1CLVHONFZ92U20
Message-ID: <CABqFQkbcGmDJsuuLTN+u-uV0r2jO6tQRfWO1NcsT69v4MykL_w@mail.gmail.com>
Subject: Re: xfsprogs: 7.1.0 Build Failure
To: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>
Cc: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I think the root issue here is that something (install-sh?) is
checking for the existence of the output directory in the buildroot
itself. In AerynOS the buildroot is an isolated chroot with the
minimal set of required dependencies/toolchain packages installed.
Since there's no reason for xfsprogs to be installed in the case of
AerynOS the directory `/usr/lib/xfsprogs` does not exist. Instead it
should be checking for the directory in the installroot where it
should exist because it was created prior to the install step that
failed.

I'm not sure where to fix that specifically but
https://raw.githubusercontent.com/AerynOS/recipes/refs/heads/main/x/xfsprog=
s/pkg/0001-Maybe-fix.patch
is a viable workaround for the moment.

On Tue, Jul 14, 2026 at 1:25=E2=80=AFPM Holger Hoffst=C3=A4tte
<holger@applied-asynchrony.com> wrote:
>
> On 2026-07-14 19:10, Reilly Brogan wrote:
> > We're seeing a build failure on AerynOS with 7.1.0 that we didn't get
> > with 7.0.1:
> >
> > ```
> > Installing healer-install
> > ../install-sh -o root -g root -m 755 -d /usr/lib/xfsprogs
> > /usr/bin/dash ../libtool --quiet --mode=3Dinstall ../install-sh -o root
> > -g root -m 755 xfs_healer xfs_healer_start /usr/lib/xfsprogs
> > Usage: /mason/build/x86_64/xfsprogs-7.1.0.tar.xz/libtool [OPTION]...
> > [MODE-ARG]...
> > Try 'libtool --help' for more information.
> > libtool:   error: '/usr/lib/xfsprogs' is not a directory
> > make[1]: *** [Makefile:72: install-healer] Error 1
> > ```
> >
> > We use slibtool as our libtool implementation and dash as /usr/bin/sh
> > so perhaps this is an incompatibility with either of those (likely
> > slibtool).
>
> Nope - I see the same on Gentoo with bash and GNU libtool:
>
> Installing scrub-install
> gmake[1]: Nothing to be done for 'install'.
> ../install-sh -o portage -g portage -m 755 -d /usr/libexec/xfsprogs
> /bin/sh ../libtool --quiet --mode=3Dinstall ../install-sh -o portage -g p=
ortage -m 755 xfs_healer xfs_healer_start /usr/libexec/xfsprogs
> Usage: /tmp/portage/sys-fs/xfsprogs-7.1.0/work/xfsprogs-7.1.0/libtool [OP=
TION]... [MODE-ARG]...
> Try 'libtool --help' for more information.
> libtool:   error: '/usr/libexec/xfsprogs' is not a directory
> gmake[1]: *** [Makefile:72: install-healer] Error 1
> make: *** [Makefile:134: healer-install] Error 2
>
> -h
