Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3279F224B08
	for <linux-xfs@vger.kernel.org>; Mon, 17 Feb 2025 16:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739809667; cv=none; b=Y24/BrXzytN9OuKPl360U1+8BMyIrpDdXaZPWqao5yMfxs0HQeXsGNSk9n+Ap4oLjaLXOzoZKk2xmF6aoGNwYjKW8kvYZ3BgbjBJ9u6Em+ZvckdXItBMHolshkV+TS0lOeQpZv4i22WdrHLiBWR/+P2mM2J5XOKl/MV+clsmieM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739809667; c=relaxed/simple;
	bh=6s7qdFHoXX0JCt7zS/mheacDmDGeW5NZtHSKHWH4Gyg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ABoFaI+s2KX2siTV2+4j/fnHZstrYRFQUU54GhkSxHe9wy+DIQyyZTPaJyMxgKeE/NmJB0T907KQiQ+NFPuM06RGxl1H7U7TDvS/EtBlIMEZ4b0bWLJME62fV88YGKzpnVWOPsP+tvsZVqYo6VnDjFGkioCvdxqT3H/IA08kGdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=monogon.tech; spf=pass smtp.mailfrom=monogon.tech; dkim=pass (2048-bit key) header.d=monogon-tech.20230601.gappssmtp.com header.i=@monogon-tech.20230601.gappssmtp.com header.b=vYx0PAmz; arc=none smtp.client-ip=209.85.217.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=monogon.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=monogon.tech
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=monogon-tech.20230601.gappssmtp.com header.i=@monogon-tech.20230601.gappssmtp.com header.b="vYx0PAmz"
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-4be5b33ff91so269349137.1
        for <linux-xfs@vger.kernel.org>; Mon, 17 Feb 2025 08:27:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=monogon-tech.20230601.gappssmtp.com; s=20230601; t=1739809664; x=1740414464; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6PvFl2wKnWHwXjigH9j9efLBuesnBYAv1Xo9xuUqiu4=;
        b=vYx0PAmz630aNYOeaJketaAZqaiqrwp2t+0uTLJMzaifqDQYJ/ARttby3j/S/dwfkh
         2VXg2Jgm+CUd0WhkbLQZvtr96vkXEaA3BgF9XZOshrItpEnMvLaVr2FXMCLnjQasGehB
         cWhVnZEIl9jdmAFe8gXpQ9ZhhOsxNTKn25oPZwqg4LxUVt9KEyinFsCYIlQT2QGwhekX
         dH8W94CHKiqnOpdjHGYb792Qvyy8rz2hyJ+Qytkx6C53pO/EWDCXMoRthzoOx+w7VjL2
         eCACMl7Z4SSXCx6NQPaoRc8rSKJYJMJO4rgZezw4o/5V9Lg1jiUXBSVfuTbmWk2MJrDr
         E8Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739809664; x=1740414464;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6PvFl2wKnWHwXjigH9j9efLBuesnBYAv1Xo9xuUqiu4=;
        b=cLjDmpzg/oLSsv055nRWWWLx4h7ycrI00PwO0Io1vsr+GdlppvGzZwCtU4QYn/i3fT
         y/ATQwHMqNte0T/OnsupcdIs00lu0GyoCAJYUnNbCaEki9o/41S3y+vD5gjeEkBX3MO3
         0Hsxg7/iJLnMiXDSen27SEXMjVeP3MRJH8hqYmRJsbIjqvA7/z5pYVwDKhjn1yn3/SDb
         fadyOQXeNtnswJl+ktQxMy/a/H+VLf2n/N8FDClm7LshFmzv5+n/KwF9p2ZneJNknpft
         uA756Qi8hj36JBfOodwgrLSIN4IUBY28C++ufoZe/DVJLOz+15IA6ngC+2hBDT2CqFpG
         BnBA==
X-Forwarded-Encrypted: i=1; AJvYcCWoo/umCW0+B4JMzmKlpMsAUb8EdMotZQdtvnU7JQ7d7b7Z+J01nHQ2S34LYn2gLIpOMPGgQQVArFs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyI/Id0BXtqYvG2bVZmEhBqZFSh/De2QWQVBuk/0S8jL4Yp2GmR
	hnDXsYIeWgDpHACp3Ol/bUfccX6ulOLmQfCQo1ZtGXFITec3G3fFrb1cKgYnGAt67LnUhyxkE8g
	sdYrROtb237I2y/EutZCIabU8acmrN7DC+IwOYA==
X-Gm-Gg: ASbGncvhMuiEOewrP1wyncciALab3jismYwMCV0UbXKa+7kKFdfttcUioQ4UnuutbxY
	nyN0LHaD7xmttN6aLgkVbbu/7Z4hkqij7ejBP0F3t7t9eNEIPriETFEYIcF7uwFUBmuS2tgHbDO
	cSxLt8Gmn/f1MFx/TLZgFjf9p9
X-Google-Smtp-Source: AGHT+IEU+xU6Lu3tYZjkn9ZoOcQOLC4IpIXmKmOlG8P6p77QposbysTbDwU5scNRtoiwFYf2AGQQ8athYurjvX1HotA=
X-Received: by 2002:a05:6102:150f:b0:4bb:dba6:99b7 with SMTP id
 ada2fe7eead31-4bd3fd83d64mr5797165137.13.1739809663935; Mon, 17 Feb 2025
 08:27:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJMi0nTHX0inFxme=xnJf23c8=w0bAf7LfiT=YNpmU-zVnUR+Q@mail.gmail.com>
In-Reply-To: <CAJMi0nTHX0inFxme=xnJf23c8=w0bAf7LfiT=YNpmU-zVnUR+Q@mail.gmail.com>
From: Lorenz Brun <lorenz@monogon.tech>
Date: Mon, 17 Feb 2025 17:27:33 +0100
X-Gm-Features: AWEUYZlONNt3-2mGQmD2nJ1CQWjkgdmHcjq6soS03JM_P4AP6zfQzaEeoIF9ZpE
Message-ID: <CAJMi0nTbyi6VGTmmZ43wYWwJWur0XPtuswZ_5UaXB+S6Z=Mo6A@mail.gmail.com>
Subject: Re: [REGRESSION] xfs kernel panic
To: "Darrick J. Wong" <djwong@kernel.org>, stable@vger.kernel.org
Cc: regressions@lists.linux.dev, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Am Mo., 17. Feb. 2025 um 16:00 Uhr schrieb Lorenz Brun <lorenz@monogon.tech>:
>
> Hi everyone,
>
> Linux 6.12.14 (released today) contains a regression for XFS, causing
> a kernel panic after just a few seconds of working with a
> freshly-created (xfsprogs 6.9) XFS filesystem. I have not yet bisected
> this because I wanted to get this report out ASAP but I'm going to do
> that now. There are multiple associated stack traces, but all of them
> have xfs_buf_offset as the faulting function.
>
> Example backtrace:
> [   31.745932] BUG: kernel NULL pointer dereference, address: 0000000000000098
> [   31.746590] #PF: supervisor read access in kernel mode
> [   31.747072] #PF: error_code(0x0000) - not-present page
> [   31.747537] PGD 5bee067 P4D 5bee067 PUD 5bef067 PMD 0
> [   31.748016] Oops: Oops: 0000 [#1] PREEMPT SMP NOPTI
> [   31.748459] CPU: 0 UID: 0 PID: 116 Comm: xfsaild/vda4 Not tainted
> 6.12.14-metropolis #1 9b2470be3d7713b818a3236e4a2804dd9cbef735
> [   31.749490] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
> BIOS 0.0.0 02/06/2015
> [   31.750340] RIP: 0010:xfs_buf_offset+0x9/0x50
> [   31.750823] Code: 08 5b e9 8a 2c c4 00 66 2e 0f 1f 84 00 00 00 00
> 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 0f 1f 00 0f 1f
> 44 00 00 <48> 8b 87 98 00 00 00 48 85 c0 75 2e 48 8b 87 00 01 00 00 48
> 89 f2
> [   31.752775] RSP: 0018:ffffbf50c07abdb8 EFLAGS: 00010246
> [   31.753343] RAX: 0000000000000002 RBX: ffff9c0985817d58 RCX: 0000000000000016
> [   31.754103] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> [   31.754734] RBP: 0000000000000000 R08: ffff9c09fb704000 R09: 00000000e0be9fc4
> [   31.755396] R10: 0000000000000000 R11: ffff9c0985827df8 R12: ffff9c09fb57ff58
> [   31.756078] R13: ffff9c0985817eb0 R14: ffff9c09fb704000 R15: ffff9c0985817f00
> [   31.756764] FS:  0000000000000000(0000) GS:ffff9c09fc000000(0000)
> knlGS:0000000000000000
> [   31.757529] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   31.758041] CR2: 0000000000000098 CR3: 0000000005b70000 CR4: 0000000000350ef0
> [   31.758696] Call Trace:
> [   31.758940]  <TASK>
> [   31.759172]  ? __die+0x56/0x97
> [   31.759473]  ? page_fault_oops+0x15c/0x2d0
> [   31.759853]  ? exc_page_fault+0x4c5/0x790
> [   31.760237]  ? asm_exc_page_fault+0x26/0x30
> [   31.760637]  ? xfs_buf_offset+0x9/0x50
> [   31.761002]  ? srso_return_thunk+0x5/0x5f
> [   31.761409]  xfs_qm_dqflush+0xd0/0x350
> [   31.761799]  xfs_qm_dquot_logitem_push+0xe9/0x140
> [   31.762253]  xfsaild+0x347/0xa10
> [   31.762567]  ? srso_return_thunk+0x5/0x5f
> [   31.762952]  ? srso_return_thunk+0x5/0x5f
> [   31.763325]  ? __pfx_xfsaild+0x10/0x10
> [   31.763665]  kthread+0xd2/0x100
> [   31.763985]  ? __pfx_kthread+0x10/0x10
> [   31.764342]  ret_from_fork+0x34/0x50
> [   31.764675]  ? __pfx_kthread+0x10/0x10
> [   31.765029]  ret_from_fork_asm+0x1a/0x30
> [   31.765408]  </TASK>
> [   31.765618] Modules linked in: kvm_amd
> [   31.765978] CR2: 0000000000000098
> [   31.766297] ---[ end trace 0000000000000000 ]---
> [   32.371004] RIP: 0010:xfs_buf_offset+0x9/0x50
> [   32.371453] Code: 08 5b e9 8a 2c c4 00 66 2e 0f 1f 84 00 00 00 00
> 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 0f 1f 00 0f 1f
> 44 00 00 <48> 8b 87 98 00 00 00 48 85 c0 75 2e 48 8b 87 00 01 00 00 48
> 89 f2
> [   32.373133] RSP: 0018:ffffbf50c07abdb8 EFLAGS: 00010246
> [   32.373611] RAX: 0000000000000002 RBX: ffff9c0985817d58 RCX: 0000000000000016
> [   32.374275] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> [   32.374921] RBP: 0000000000000000 R08: ffff9c09fb704000 R09: 00000000e0be9fc4
> [   32.375720] R10: 0000000000000000 R11: ffff9c0985827df8 R12: ffff9c09fb57ff58
> [   32.376376] R13: ffff9c0985817eb0 R14: ffff9c09fb704000 R15: ffff9c0985817f00
> [   32.377027] FS:  0000000000000000(0000) GS:ffff9c09fc000000(0000)
> knlGS:0000000000000000
> [   32.377761] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   32.378292] CR2: 0000000000000098 CR3: 0000000005b70000 CR4: 0000000000350ef0
> [   32.378940] Kernel panic - not syncing: Fatal exception
> [   32.379492] Kernel Offset: 0x2a600000 from 0xffffffff81000000
> (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
>
> #regzbot introduced: v6.12.13..v6.12.14
>
> Regards,
> Lorenz

Hi everyone,

I root-caused this to 5808d420 ("xfs: attach dquot buffer to dquot log
item buffer"), but needs reverting of the 3 follow-up commits
(d331fc15, ee6984a2 and 84307caf) as well as they depend on the broken
one. With that 6.12.14 passes our test suite again. Reproduction
should be rather easy by just creating a fresh filesystem, mounting
with "prjquota" and performing I/O.

Regards,
Lorenz
