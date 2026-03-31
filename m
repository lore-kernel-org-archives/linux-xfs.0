Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA6A188CC9
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 03:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774927461; cv=pass; b=HV5gr+o8fdibvCT7mXu2mLoVoU9zYmqA+MFlrsJPluJDvKsFn2JhfXXzln7D9+5AWEAm+7mMFXjY2lmhUNMjEIAfn84qhcUV1CnUyBMpEiHrdUXV0tXrFn9sxweniommaIy52f5E4sR/Amoc+VZqmGRirnuwV6xhPsn8HPHb3Tw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774927461; c=relaxed/simple;
	bh=sl3CgoktJVD+hXa8DugfdvSnR5CnuT3CK4jGL+N0QnQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i35tiOgEUrBn1AqrrZ0374FC+uGnE2pdp9UlkRD6TIIYTHka7cKrDrL1h6MGIg2SMXRV1Y7ARv3TFHcVjjg7d0LHLxMSrNVBKp/TuoI8p/hrdLHkkZwDQhDwPCa9RQnRgY0LbErtzkTXkrwo70Dhdjw7bn2ocp90nYDuTOfvn80=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fVc0RvPr; arc=pass smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fVc0RvPr"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-66bd3d05e03so2322550a12.2
        for <linux-xfs@vger.kernel.org>; Mon, 30 Mar 2026 20:24:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774927458; cv=none;
        d=google.com; s=arc-20240605;
        b=d+uF11v3DJ6I7gAit5Ne/G5M0gbrtrMrbmFJyhcPBpJpbBjfDg6hbf3WAcMcKcKfNO
         NPmx7+PwEoTswag4UHqcjAiQwcpuZAtkDtAzK0gBe9PkfuZ/pn+gogtgvm8ruVE2WZot
         /7gVA6XlPhHQwAO0VeWbhIU73Y8/66B1ryi2ea6IcpFfWoId1yiBBuI90Zuaqd8cFazF
         U2y6yNETUorv5/icAYCeEMQse8BtkQjXZYQ/SHTz1EfZZBVjR1GZ3dzvzIjknw1BqnkC
         U9tRqR6bq/4NC9qbcwF1V7KhqGcUhIjzBzMTeUOJylp6dUrr5ALvavBRdGslwy1HwM9K
         57rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tF4n3JKXrQULJ30mEQH7OIay40SUMLZiItP8PWw2KdY=;
        fh=0vrTI6zGYpH/VWI6f/0ST4rpS1UelHrUux0qkXocyeQ=;
        b=NDG+/g7eLaxz4NqJjyuJQDCQobYvXlCoucQ9Al0SicrLAZqD3mDx33aRnbR46uP7cX
         jh8qXiLsh+AHBGOm6yclSHJGR98SJQDWx0I1XktxGKnnb+O8BduUNiyVe5/K7UZbNYHX
         IZVNRumnbI8FWBWoVbpdF7ezOlBqZgtpKSq3Dx+J2Z727qN64TfpZI0wLuoqVr0ERt5/
         LbWi9VYdf7XOEiY89cIUaPVYCOFmPrGcQivZSyUeyyp+SRt0vfolKgzyuSmGerTcphGp
         EWyxq8md6ln+qF/8bWyrkNNZNJPInTTVlkslErZuY/XWhZrclZplyAgvLVy5nvRravk/
         cyMw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774927458; x=1775532258; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tF4n3JKXrQULJ30mEQH7OIay40SUMLZiItP8PWw2KdY=;
        b=fVc0RvPrGo6BvgXdlXXhDMzvLzMg+tcnaIiIYfXR+48xfw8w7rFHDfwYOMrvzl1lly
         fG8ySbOoP8Tm/LjII8ONpVOb0dQkFyAEv9TIKG7+d7DBkJd8f7tBu8Mi+LGofQHyJ5DQ
         nAeZEx3tobL81VuMVnTit6QpQX3DB7J4nodxz517827Yi59y6IALzs5INAc3BYiokhxC
         NvR99nPA1PtlQDMR1+njK/sJ02c/GhqN15j80Az3S6M9xsdAh60Nz/8VNaaWteaGzhCe
         J6hYIZ+SoK+51KqUFEnUX9wk7WiwKQZxBK/JO1JxEQa3wF93zrQrLvB1N89W0ODJv1BR
         KRCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774927458; x=1775532258;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tF4n3JKXrQULJ30mEQH7OIay40SUMLZiItP8PWw2KdY=;
        b=PI1qgNRai0YQDtCIgyVi7LS8J8qCd0eOQdDniGGmdVlrMt7X2y8KBxeK94qMcmK5Bq
         bkD8k4sF4G0xGYCwgYBSvCL8M5GRgjz3JCa2XAjTKzFib7d1JDu54Xa8nF59O8WJ6K2B
         NkHFp6Xw8WPha0N1sXGAqXr9Pgh8ynplN2V51alevIoYIq1ojUbRj51aiaOz0xha9oDU
         p5y+BXnkHaEHLlXLhwggM9ULHFD5vyTqPrVqty/4su/uNk4mZ8vQSuUIpnshf57E5Lzz
         UwEBlgSqWUwYU2xszOWtuNOMVpgz9C3EOe8GA310biuY7SpyWtIbvOxYIy+NrYM1hHNF
         kIZA==
X-Forwarded-Encrypted: i=1; AJvYcCVhAVvgoUPdw84nEEMAmjCluiNLZ1Tdvhq0XRTJWJJWqcYtMjTjEb+IZjovwRCir1UetkWogz4irf0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+60jgPFMVHFfxUXfSKpt1e9eg990Xkv+Unl4Zi7mo3JjCvPVJ
	ORdMpzLodJSMc9jQPyFxNQ/KLzCx/GZiS2iwvEyKAJ3mnMbkt/H1BAMyB3Z12fWrQDyg/I26sLq
	8eGyVBS8K4W+CCzSKzPUU0nUcXAEk4QU=
X-Gm-Gg: ATEYQzz0Xzigu3Hf+QrrZBOcNA3OlLedPNBXAVJ4RAnn/RcxxexoEuaiXvlxcs8zbev
	rtNHAsTkT3Sts0IEjLNiex1jnIitsj+55nSt0S5aDwsr84LwxiuHNkjlHRsOQTI46qB90EQS/vP
	Hklp9llSFWSF3jSv0pyQbNUE0OB3HhWs/q7ji3sWUkeFvU223nJw04OCA/udgf7jEErYYczulG7
	i+h4/zuYtScQUZwRK35fa7h98SeB3bXjWV/zfYV9Dgvdoh7H0IVQcZDfOOA2nwpfD3oO91hOGz4
	5eCCbhXQmridJqNaEdD9wnDYQ4+aNkjOPlrK4U4HEmYdq0jKsTQpVDVTdAmHwg0=
X-Received: by 2002:a05:6402:3247:10b0:66b:3d06:ccc0 with SMTP id
 4fb4d7f45d1cf-66b3d06d05emr6265493a12.0.1774927457682; Mon, 30 Mar 2026
 20:24:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260328071252.3936506-1-gality369@gmail.com> <acnUybgMAsBA9IEc@dread>
 <CAOmEq9Vx_sJf1PbD_SFdRyKb+u+kRR8_BPJ_+Ms4tdD895-cVg@mail.gmail.com> <acrg64yzAbgb8jte@dread>
In-Reply-To: <acrg64yzAbgb8jte@dread>
From: ZhengYuan Huang <gality369@gmail.com>
Date: Tue, 31 Mar 2026 11:24:04 +0800
X-Gm-Features: AQROBzDF2NJE2J_yNggKynH2HbzQhj7JPY2pJVqScgaiZANNyzyphquZBLO59Hw
Message-ID: <CAOmEq9U_3ypykxNHenrdSu+_o6YCsWg5JQT59SixSum46QQeBg@mail.gmail.com>
Subject: Re: [PATCH] xfs: avoid inodegc worker flush deadlock
To: Dave Chinner <dgc@kernel.org>
Cc: cem@kernel.org, dchinner@redhat.com, djwong@kernel.org, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 31, 2026 at 4:45=E2=80=AFAM Dave Chinner <dgc@kernel.org> wrote=
:
> On Mon, Mar 30, 2026 at 10:40:13AM +0800, ZhengYuan Huang wrote:
> > This issue was found by our fuzzing tool, and we are still working on
> > a reliable reproducer.
>
> Is this some new custom fuzzer tool, or just another private syzbot
> instance?

This fuzzing tool is built on top of syzkaller and designed to test filesys=
tem
stability and robustness by mutating filesystem metadata. To further
investigate, we have preserved the disk image that originally triggered
the issue. However, when attempting to reproduce, the filesystem
behaviour has changed in a way we haven't yet explained =E2=80=94 we are
still looking into that.

> More importantly: this is not a failure that anyone is likely to see
> in production systems, right?

Our current understanding is that this is likely caused by on-disk
corruption introduced by fuzzing, rather than a normal runtime condition.
So it is probably not representative of production scenarios, although
we are not yet fully certain about all contributing factors.

> > In particular, we observe
> > repeated per-AG reservation failures during mount, followed by:
> >
> > ENOSPC reserving per-AG metadata pool, log recovery may fail.
>
> This error doesn't occur in isolation - what other errors were
> reported?
>
> Please post the entire log output from the start of the mount to the
> actual reported failure. That way we know the same things as you do,
> and can make more informed comments about the error rather than
> having to rely on what you think is relevant.

We are happy to share the complete log below (with some unrelated
noise removed for clarity). One additional note: the -dirty tag in the
kernel version string is solely because we added a helper to dump
stack traces; no XFS code was modified.
=3D=3D=3D=3D=3D=3D LOG =3D=3D=3D=3D=3D=3D
[   46.833438] XFS (ublkb1): Mounting V5 Filesystem
ed0a5015-75fd-40a3-bcb7-39dc2d7bf4e3
[   46.905414] XFS (ublkb1): Reserve blocks depleted! Consider
increasing reserve pool size.
[   46.907124] XFS (ublkb1): Per-AG reservation for AG 0 failed.
Filesystem may run out of space.
[   46.910303] XFS (ublkb1): Per-AG reservation for AG 0 failed.
Filesystem may run out of space.
[   46.919427] XFS (ublkb1): Per-AG reservation for AG 1 failed.
Filesystem may run out of space.
[   46.921898] XFS (ublkb1): Per-AG reservation for AG 1 failed.
Filesystem may run out of space.
[   46.931705] XFS (ublkb1): Per-AG reservation for AG 2 failed.
Filesystem may run out of space.
[   46.933707] XFS (ublkb1): Per-AG reservation for AG 2 failed.
Filesystem may run out of space.
[   46.943612] XFS (ublkb1): Per-AG reservation for AG 3 failed.
Filesystem may run out of space.
[   46.945408] XFS (ublkb1): Per-AG reservation for AG 3 failed.
Filesystem may run out of space.
[   46.947176] XFS (ublkb1): ENOSPC reserving per-AG metadata pool,
log recovery may fail.
[   46.948802] XFS (ublkb1): Ending clean mount
[   46.960493] XFS (ublkb1): Per-AG reservation for AG 0 failed.
Filesystem may run out of space.
[   46.962052] XFS (ublkb1): Per-AG reservation for AG 0 failed.
Filesystem may run out of space.
[   46.973196] XFS (ublkb1): Per-AG reservation for AG 1 failed.
Filesystem may run out of space.
[   46.974662] XFS (ublkb1): Per-AG reservation for AG 1 failed.
Filesystem may run out of space.
[   46.982909] XFS (ublkb1): Per-AG reservation for AG 2 failed.
Filesystem may run out of space.
[   46.984336] XFS (ublkb1): Per-AG reservation for AG 2 failed.
Filesystem may run out of space.
[   46.992623] XFS (ublkb1): Per-AG reservation for AG 3 failed.
Filesystem may run out of space.
[   46.994431] XFS (ublkb1): Per-AG reservation for AG 3 failed.
Filesystem may run out of space.
[   46.996066] xfs filesystem being mounted at /mnt/xfs supports
timestamps until 2038-01-19 (0x7fffffff)
[  237.225031] XFS (ublkb1): Metadata corruption detected at
xfs_dinode_verify.part.0+0x4a9/0x1410, inode 0x41c0 dinode
[  237.226784] XFS (ublkb1): Unmount and run xfs_repair
[  237.227626] XFS (ublkb1): First 128 bytes of corrupted metadata buffer:
[  237.228643] 00000000: 49 4e e4 f5 03 02 00 00 00 00 00 00 00 00 00
00  IN..............
[  237.229832] 00000010: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00
00  ................
[  237.230945] 00000020: ff ff ff f8 00 00 00 00 00 00 00 81 00 00 00
00  ................
[  237.232196] 00000030: 69 c0 b4 39 32 2f e6 80 00 00 00 00 00 00 00
00  i..92/..........
[  237.233454] 00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00  ................
[  237.234689] 00000050: 00 00 11 01 00 00 00 00 00 00 00 00 c2 4d 5a
de  .............MZ.
[  237.235911] 00000060: ff ff ff ff fb ec ad 7a 00 00 00 00 00 00 00
15  .......z........
[  237.237178] 00000070: 00 00 00 01 00 00 32 80 00 00 00 00 00 00 00
00  ......2.........
[  288.800496] XFS (ublkb1): Metadata corruption detected at
xfs_dinode_verify.part.0+0x4a9/0x1410, inode 0x41c0 dinode
[  288.802321] XFS (ublkb1): Unmount and run xfs_repair
[  288.803524] XFS (ublkb1): First 128 bytes of corrupted metadata buffer:
[  288.804591] 00000000: 49 4e e4 f5 03 02 00 00 00 00 00 00 00 00 00
00  IN..............
[  288.805850] 00000010: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00
00  ................
[  288.807063] 00000020: ff ff ff f8 00 00 00 00 00 00 00 81 00 00 00
00  ................
[  288.808178] 00000030: 69 c0 b4 39 32 2f e6 80 00 00 00 00 00 00 00
00  i..92/..........
[  288.809262] 00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00  ................
[  288.810324] 00000050: 00 00 11 01 00 00 00 00 00 00 00 00 c2 4d 5a
de  .............MZ.
[  288.811528] 00000060: ff ff ff ff fb ec ad 7a 00 00 00 00 00 00 00
15  .......z........
[  288.812772] 00000070: 00 00 00 01 00 00 32 80 00 00 00 00 00 00 00
00  ......2.........
[  292.851051] Direct I/O collision with buffered writes! File: /mn=EF=BF=
=BDd
[  292.851051] j Comm: syz.0.505
[  295.532209] XFS (ublkb1): Metadata corruption detected at
xfs_dinode_verify.part.0+0x4a9/0x1410, inode 0x41c0 dinode
[  295.534296] XFS (ublkb1): Unmount and run xfs_repair
[  295.535341] XFS (ublkb1): First 128 bytes of corrupted metadata buffer:
[  295.536632] 00000000: 49 4e e4 f5 03 02 00 00 00 00 00 00 00 00 00
00  IN..............
[  295.538380] 00000010: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00
00  ................
[  295.540379] 00000020: ff ff ff f8 00 00 00 00 00 00 00 81 00 00 00
00  ................
[  295.542385] 00000030: 69 c0 b4 39 32 2f e6 80 00 00 00 00 00 00 00
00  i..92/..........
[  295.544337] 00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00  ................
[  295.546382] 00000050: 00 00 11 01 00 00 00 00 00 00 00 00 c2 4d 5a
de  .............MZ.
[  295.548332] 00000060: ff ff ff ff fb ec ad 7a 00 00 00 00 00 00 00
15  .......z........
[  295.550370] 00000070: 00 00 00 01 00 00 32 80 00 00 00 00 00 00 00
00  ......2.........
[  354.190195] XFS (ublkb1): Metadata corruption detected at
xfs_dinode_verify.part.0+0x4a9/0x1410, inode 0x41c0 dinode
[  354.195110] XFS (ublkb1): Unmount and run xfs_repair
[  354.198969] XFS (ublkb1): First 128 bytes of corrupted metadata buffer:
[  354.199974] 00000000: 49 4e e4 f5 03 02 00 00 00 00 00 00 00 00 00
00  IN..............
[  354.201200] 00000010: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00
00  ................
[  354.204952] 00000020: ff ff ff f8 00 00 00 00 00 00 00 81 00 00 00
00  ................
[  354.206459] 00000030: 69 c0 b4 39 32 2f e6 80 00 00 00 00 00 00 00
00  i..92/..........
[  354.207774] 00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00  ................
[  354.209031] 00000050: 00 00 11 01 00 00 00 00 00 00 00 00 c2 4d 5a
de  .............MZ.
[  354.210274] 00000060: ff ff ff ff fb ec ad 7a 00 00 00 00 00 00 00
15  .......z........
[  354.211474] 00000070: 00 00 00 01 00 00 32 80 00 00 00 00 00 00 00
00  ......2.........
[  367.277630] XFS (ublkb1): Metadata corruption detected at
xfs_dinode_verify.part.0+0x4a9/0x1410, inode 0x41c0 dinode
[  367.280014] XFS (ublkb1): Unmount and run xfs_repair
[  367.281661] XFS (ublkb1): First 128 bytes of corrupted metadata buffer:
[  367.283455] 00000000: 49 4e e4 f5 03 02 00 00 00 00 00 00 00 00 00
00  IN..............
[  367.284686] 00000010: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00
00  ................
[  367.287382] 00000020: ff ff ff f8 00 00 00 00 00 00 00 81 00 00 00
00  ................
[  367.288729] 00000030: 69 c0 b4 39 32 2f e6 80 00 00 00 00 00 00 00
00  i..92/..........
[  367.289970] 00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00  ................
[  367.291261] 00000050: 00 00 11 01 00 00 00 00 00 00 00 00 c2 4d 5a
de  .............MZ.
[  367.292480] 00000060: ff ff ff ff fb ec ad 7a 00 00 00 00 00 00 00
15  .......z........
[  367.293746] 00000070: 00 00 00 01 00 00 32 80 00 00 00 00 00 00 00
00  ......2.........
[  409.688514]
[  409.688846] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[  409.689672] WARNING: possible recursive locking detected
[  409.690585] 6.18.0-dirty #1 Tainted: G           OE
[  409.691428] --------------------------------------------
[  409.692219] kworker/0:1/10 is trying to acquire lock:
[  409.693031] ffff88801621fd48
((wq_completion)xfs-inodegc/ublkb1){+.+.}-{0:0}, at:
touch_wq_lockdep_map+0x99/0x1c0
[  409.695062]
[  409.695062] but task is already holding lock:
[  409.696291] ffff88801621fd48
((wq_completion)xfs-inodegc/ublkb1){+.+.}-{0:0}, at:
process_one_work+0x1188/0x1980
[  409.697803]
[  409.697803] other info that might help us debug this:
[  409.698772]  Possible unsafe locking scenario:
[  409.698772]
[  409.699844]        CPU0
[  409.700360]        ----
[  409.700898]   lock((wq_completion)xfs-inodegc/ublkb1);
[  409.701919]   lock((wq_completion)xfs-inodegc/ublkb1);
[  409.702984]
[  409.702984]  *** DEADLOCK ***
[  409.702984]
[  409.704195]  May be due to missing lock nesting notation
[  409.704195]
[  409.705838] 2 locks held by kworker/0:1/10:
[  409.706725]  #0: ffff88801621fd48
((wq_completion)xfs-inodegc/ublkb1){+.+.}-{0:0}, at:
process_one_work+0x1188/0x1980
[  409.708916]  #1: ffff888009dafce8
((work_completion)(&(&gc->work)->work)){+.+.}-{0:0}, at:
process_one_work+0x865/0x1980
[  409.711101]
[  409.711101] stack backtrace:
[  409.712068] CPU: 0 UID: 0 PID: 10 Comm: kworker/0:1 Tainted: G
     OE       6.18.0-dirty #1 PREEMPT(voluntary)
[  409.712095] Tainted: [O]=3DOOT_MODULE, [E]=3DUNSIGNED_MODULE
[  409.712103] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX,
arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  409.712117] Workqueue: xfs-inodegc/ublkb1 xfs_inodegc_worker
[  409.712154] Call Trace:
[  409.712187]  <TASK>
[  409.712197]  dump_stack_lvl+0xbe/0x130
[  409.712231]  dump_stack+0x15/0x20
[  409.712252]  print_deadlock_bug+0x23f/0x320
[  409.712284]  __lock_acquire+0x1317/0x21e0
[  409.712326]  lock_acquire+0x169/0x2f0
[  409.712348]  ? touch_wq_lockdep_map+0x99/0x1c0
[  409.712373]  ? srso_alias_return_thunk+0x5/0xfbef5
[  409.712394]  ? lockdep_init_map_type+0x5c/0x280
[  409.712422]  ? touch_wq_lockdep_map+0x99/0x1c0
[  409.712444]  touch_wq_lockdep_map+0xab/0x1c0
[  409.712465]  ? touch_wq_lockdep_map+0x99/0x1c0
[  409.712490]  __flush_workqueue+0x117/0x1010
[  409.712519]  ? srso_alias_return_thunk+0x5/0xfbef5
[  409.712554]  ? xa_find+0x1d0/0x370
[  409.712585]  ? __pfx___flush_workqueue+0x10/0x10
[  409.712623]  ? xfs_inodegc_flush+0x26/0x390
[  409.712646]  ? xfs_blockgc_flush_all+0x106/0x250
[  409.712671]  xfs_inodegc_flush+0x9a/0x390
[  409.712699]  xfs_blockgc_flush_all+0x106/0x250
[  409.712725]  xfs_trans_alloc+0x5e4/0xc10
[  409.712740]  ? xfs_iunlock+0xb1/0x2e0
[  409.712768]  xfs_inactive_ifree+0x329/0x3c0
[  409.712790]  ? __pfx_xfs_inactive_ifree+0x10/0x10
[  409.712812]  ? srso_alias_return_thunk+0x5/0xfbef5
[  409.712853]  ? srso_alias_return_thunk+0x5/0xfbef5
[  409.712879]  ? xfs_qm_need_dqattach+0xed/0x290
[  409.712901]  xfs_inactive+0x590/0xb60
[  409.712921]  ? srso_alias_return_thunk+0x5/0xfbef5
[  409.712944]  ? __pfx_xfs_inactive+0x10/0x10
[  409.712964]  ? xfs_inodegc_worker+0x308/0x650
[  409.712989]  ? srso_alias_return_thunk+0x5/0xfbef5
[  409.713011]  ? srso_alias_return_thunk+0x5/0xfbef5
[  409.713031]  ? do_raw_spin_unlock+0x14b/0x200
[  409.713065]  xfs_inodegc_worker+0x241/0x650
[  409.713093]  process_one_work+0x8e0/0x1980
[  409.713132]  ? __pfx_process_one_work+0x10/0x10
[  409.713157]  ? move_linked_works+0x1a8/0x2c0
[  409.713182]  ? srso_alias_return_thunk+0x5/0xfbef5
[  409.713203]  ? assign_work+0x19d/0x240
[  409.713226]  ? srso_alias_return_thunk+0x5/0xfbef5
[  409.713247]  ? lock_is_held_type+0xa3/0x130
[  409.713272]  worker_thread+0x683/0xf80
[  409.713298]  ? srso_alias_return_thunk+0x5/0xfbef5
[  409.713324]  ? srso_alias_return_thunk+0x5/0xfbef5
[  409.713345]  ? __kasan_check_read+0x11/0x20
[  409.713387]  ? __pfx_worker_thread+0x10/0x10
[  409.713413]  kthread+0x3f0/0x850
[  409.713440]  ? srso_alias_return_thunk+0x5/0xfbef5
[  409.713463]  ? __pfx_kthread+0x10/0x10
[  409.713486]  ? srso_alias_return_thunk+0x5/0xfbef5
[  409.713507]  ? trace_hardirqs_on+0x53/0x60
[  409.713534]  ? srso_alias_return_thunk+0x5/0xfbef5
[  409.713574]  ? _raw_spin_unlock_irq+0x27/0x70
[  409.713604]  ? srso_alias_return_thunk+0x5/0xfbef5
[  409.713625]  ? calculate_sigpending+0x7c/0xb0
[  409.713658]  ? __pfx_kthread+0x10/0x10
[  409.713685]  ret_from_fork+0x50f/0x610
[  409.713721]  ? __pfx_kthread+0x10/0x10
[  409.713747]  ret_from_fork_asm+0x1a/0x30
[  409.713784]  </TASK>

> > Based on the current code, my understanding is that when
> > xfs_fs_reserve_ag_blocks fails, XFS can continue mounting in the
> > degraded m_finobt_nores mode. In this state, xfs_inactive_ifree may
> > later take the explicit reservation path, which seems like a plausible
> > way for ifree to encounter ENOSPC.
>
> The nores path sets XFS_TRANS_RESERVE, allowing it to dip into the
> global reserve blocks pool to avoid ENOSPC in most situations.
> However, if it gets ENOSPC, that means the reserve block pool is
> empty, and whatever corruption the fuzzer introduced has produced
> a filesystem that has zero space available to run transactions that
> log recovery needs to run.
>
> IOWs, if the fs is at ENOSPC, and the reserve pool is also empty,
> then we can't run unlinked inode recovery or replay intents because
> the transaction reservations will ENOSPC.  If that's the case, then
> we should be detecting the ENOSPC situation and aborting log
> recovery rather than trying to recover and hitting random ENOSPC
> failures part way through.
>
> i.e. I'm trying to understand the cause of the ENOSPC issue, because
> that will determine how we need to detect whatever on-disk
> corruption the fuzzer created to trigger this issue.

Thanks for the detailed explanation =E2=80=94 that makes sense.
For additional context, here is some on-disk free space information
from the image:

$ xfs_db -r -c "sb 0" -c "print fdblocks" /dev/vda
fdblocks =3D 3517

$ for ag in 0 1 2 3; do
echo "=3D=3D=3D AG $ag =3D=3D=3D"
xfs_db -r -c "agf $ag" -c "print freeblks" /dev/vda
done
=3D=3D=3D AG 0 =3D=3D=3D
freeblks =3D 622
=3D=3D=3D AG 1 =3D=3D=3D
freeblks =3D 630
=3D=3D=3D AG 2 =3D=3D=3D
freeblks =3D 1129
=3D=3D=3D AG 3 =3D=3D=3D
freeblks =3D 1076

Please let us know if there is anything else we can provide.

Thanks,
ZhengYuan Huang
