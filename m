Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C4C3F9E5
	for <linux-xfs@vger.kernel.org>; Mon, 12 Feb 2024 18:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707761267; cv=none; b=M+2Gr7+K2iPhjFaIBuzW1tjTd5aDxXnyywi2JiMObt077aZE9450F9kTVYQY7hnfz/Ys3m5ln53+OW9zxVTMpsRRYnvsDGpDkKQIOCeqZTyk8DRFUKPxql8fQyAMMShjP+aI4n8CRG6KoSfZIcWePNHC7QEU1ObGlN7P9yr40Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707761267; c=relaxed/simple;
	bh=+3QSVJ/97zy1U5qXkBGssU8yL0uHf1QfXbRTzL0nWYI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Gz7MUyIdSULwppoNM9v326iw1HJ8lCWrEVXbOKZJrKuRxSZodO7fwKVnTuVHM0MKsxb3cNniYR/8XtqTcFOucRA3WvmnNmTnV4sOb4bWlLs5+XZqzf6E6KP/32BJrYp+yKDE+8m7gCmJtngj+8poXPVoCOXH9xMRrjlfwxgSSzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=soe.ucsc.edu; spf=pass smtp.mailfrom=soe.ucsc.edu; dkim=pass (2048-bit key) header.d=soe.ucsc.edu header.i=@soe.ucsc.edu header.b=Z01o5Hlv; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=soe.ucsc.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soe.ucsc.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soe.ucsc.edu header.i=@soe.ucsc.edu header.b="Z01o5Hlv"
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-3bb9b28acb4so2835653b6e.2
        for <linux-xfs@vger.kernel.org>; Mon, 12 Feb 2024 10:07:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soe.ucsc.edu; s=soe-google-2018; t=1707761265; x=1708366065; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yjwOiKSv6QfziDHVZ7UQHuTKFxlyjFK4f7YcHc2pIsI=;
        b=Z01o5HlvIUVBwPLmw+1IhSEEksd8Ujfz3UEslyaAi1+FOAnLWjlGUOMjmWfENw0TvI
         4au+jF+FGTFaicAbL5lUmqJY494k3iYM6fVnIsHgdsjXOlRULbsroqP+1QsD7xeb8dR5
         uawmPqL15hgkj5UvJET5oEAXlYTDwjNgVGnsCmTerBFoUpO8cPp6+lbSxhoHQ6d3ygjd
         1zcHLics8I6DqhPF5gNJ4GyPIVdfPgeN1hharT0ODn2vbjdHza5PzLobqFeC/EQkx2Lt
         X44m4Wsgx/fbDzqYdzdeCv7LUypwiRrClVb8smq65VZ5hpB5FhPT55b3xq6wYUEBgWWz
         G86w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707761265; x=1708366065;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yjwOiKSv6QfziDHVZ7UQHuTKFxlyjFK4f7YcHc2pIsI=;
        b=tif9i7pi/XPz2S7Ds6+dJ7PY3fHaeYqbHwvxWUQlYDsIzNTx3m39N2nsz+5QJ3Pp7S
         NM/IruU8OYjBFQRL/eCgOAUXFbARpMX0zRzMyGAEJqg38yF1Nk9/cbx455uj7IvSb3+D
         GA3t6sl6NMh/gXG0Sfkm58pUfO0CiPTLy4pIEZ2fJhPGnR+qklrgjWyJ5g/PHwG4lQ6K
         Ec8mGtw1sLK3zjYyGqs0cXIwYGXNQLXTX33kl91M5HLaKKsSWE8pZftJwkpdI9Y0bril
         QfAcnUzJtA0n+UAOBBzVk/YZHFsHqHenHH7/8/JPJlN38XmY9HDjm2Rdfc+4C3gDkJYN
         FNaA==
X-Gm-Message-State: AOJu0YzqpM2ScmWakiwvr6vjc25qzJA0jZTWf7Ncp+goa2oijZfAzXty
	4PLVcRHlftycl3LPxlWxGQae8rOX77+hWIK/RTcUSI8QrE3ZtmLeHBMYMp5asFBwn4Oqx3lZbzw
	TzT+U9opuyi0f2Ckw/ePAzIXcCoiwfI/+nvtAlFjNRFIlnSzohAI=
X-Google-Smtp-Source: AGHT+IE2HduG/QRjQ/E4vdNCpufIkN+NDNa4QqtefDzKVXmue6WcWv28seio04XvwQadxIJZZG+SpebAqVco24VI6d4=
X-Received: by 2002:a05:6808:1813:b0:3bd:a8a3:7237 with SMTP id
 bh19-20020a056808181300b003bda8a37237mr8536813oib.10.1707761264798; Mon, 12
 Feb 2024 10:07:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAMz=2cecSLKwOHuVC31wARcjFO50jtGy8bUzYZHeUT09CVNhxw@mail.gmail.com>
 <6ecca473-f23e-4bb6-a3c3-ebef6d08cc7e@sandeen.net>
In-Reply-To: <6ecca473-f23e-4bb6-a3c3-ebef6d08cc7e@sandeen.net>
From: Jorge Garcia <jgarcia@soe.ucsc.edu>
Date: Mon, 12 Feb 2024 10:07:33 -0800
Message-ID: <CAMz=2ccSrb9bG3ahRJTpwu2_8-mQDtwRz-YmKjkH+4qoGoURxQ@mail.gmail.com>
Subject: Re: XFS corruption after power surge/outage
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 11, 2024 at 12:39=E2=80=AFPM Eric Sandeen <sandeen@sandeen.net>=
 wrote:

> I was going to suggest creating an xfs_metadump image for analysis.
> Was that created with xfsprogs v6.5.0 as well?

> so the metadump did not complete?

I actually tried running xfs_metadump with both v5.0 and v6.5.0. They
both gave many error messages, but they created files. Not sure what I
can do with those files

> Does the filesystem mount? Can you mount it -o ro or -o ro,norecovery
> to see how much you can read off of it?

The file system doesn't mount. the message when I try to mount it is:

mount: /data: wrong fs type, bad option, bad superblock on /dev/sda1,
missing codepage or helper program, or other error.

and

Feb 12 10:06:02 hgdownload1 kernel: XFS (sda1): Superblock has unknown
incompatible features (0x10) enabled.
Feb 12 10:06:02 hgdownload1 kernel: XFS (sda1): Filesystem cannot be
safely mounted by this kernel.
Feb 12 10:06:02 hgdownload1 kernel: XFS (sda1): SB validate failed
with error -22.

I wonder if that is because I tried a xfs_repair with a newer version...

>
> If mount fails, what is in the kernel log when it fails?

> Power losses really should not cause corruption, it's a metadata journali=
ng
> filesytem which should maintain consistency even with a power loss.
>
> What kind of storage do you have, though? Corruption after a power loss o=
ften
> stems from a filesystem on a RAID with a write cache that does not honor
> data integrity commands and/or does not have its own battery backup.

We have a RAID 6 card with a BBU:

Product Name    : AVAGO MegaRAID SAS 9361-8i
Serial No       : SK00485396
FW Package Build: 24.21.0-0017

I agree that power issues should not cause corruption, but here we
are. Somewhere on one of the discussion threads I saw somebody mention
ufsexplorer, and when I downloaded the trial version, it seemed to see
most of the files on the device. I guess if I can't find a way to
recover the current filesystem, I will try to use that to recover the
data.
