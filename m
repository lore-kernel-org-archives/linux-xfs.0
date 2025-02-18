Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7A9286286
	for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 20:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739911838; cv=none; b=gXd5XhnTyuQ6olOL5jOg5A2V89ddTT4VYPg9FOK47A56wVMwV7CBjJdSA57GNsl57JjZODUpyL48RUrSPW39E/g5ImB0Ez58qwvmgGzDlosxODuzpQYpNV59UOJoKAMx2+Ica2ThXXwY3D6pncK6iHyUHTjdCWNSK+3zY+PX6gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739911838; c=relaxed/simple;
	bh=PpiQTlTOOZyXjOnfhxl0EHn+GiaHyGsMFZnUED6Xgcs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NUVlAs12rKV/BFEw0W2f+PjsH0cloNESErDvJfmjNwL3TKZzDTR4uXz1svgewbUg7kCgj5fcHoUjSPjV+r9PqM7X6tUAXNE8Xc+DdjYM3ho41MNumh7fkoNX6s0MhypVmZo73DyNYiDJAvTvCY+J/yhOPzNNG6vXZzGG8v2Ti1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=monogon.tech; spf=pass smtp.mailfrom=monogon.tech; dkim=pass (2048-bit key) header.d=monogon-tech.20230601.gappssmtp.com header.i=@monogon-tech.20230601.gappssmtp.com header.b=yH9onioN; arc=none smtp.client-ip=209.85.217.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=monogon.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=monogon.tech
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=monogon-tech.20230601.gappssmtp.com header.i=@monogon-tech.20230601.gappssmtp.com header.b="yH9onioN"
Received: by mail-vs1-f52.google.com with SMTP id ada2fe7eead31-4bd73f93215so2203722137.1
        for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 12:50:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=monogon-tech.20230601.gappssmtp.com; s=20230601; t=1739911835; x=1740516635; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ofYDHxj1ziYDYXkrBzg3wkNuykm4qVuLZJ1pxIE9UxY=;
        b=yH9onioN4Q605j3xdKkKZ8rI2hK40EXvS1ETsKnZV2/2OeMucjR3gKbC34YI8YKv6m
         vT43Knx7cmv5H9KiJ3uKCIpr51LGUqo6gfL/lM0XD521HdwpGicoc8tEcb2I2N1DeOj9
         M+n/T35iwLKkgIY7NfOS8JrevNDmNoDQqkNuF/wmejFaQZZIFNw4cEPyJLCxU2M4OHBT
         m/oYaQw0k2JDByJWnJR7pHXj8EtqzXSIFEhjmgSc6GdQLsGxJqwC/X0BVRV0P9vZq6t7
         EI9R3Khm2yK39Nw7vVjHZF21U/IQLnyGEm7WAd7yM2he/xkZWp/FIThISXyYGzCNsHIt
         uL6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739911835; x=1740516635;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ofYDHxj1ziYDYXkrBzg3wkNuykm4qVuLZJ1pxIE9UxY=;
        b=FNHpMwxGfq67VPJZoNMKHX4NK2D5lh9KBtym8ioGqVeoPM42gZG0wscqK2JgEDT4Bc
         j7wRCY4QSEcttEZgsrJ7zhi5lT3JUvOsq5tn08kyhmtqugBf/wRSgxq+ZQ+Jyj2MScTA
         xSnD/DDPUY3NKT77P6hA3BLfg4FDon/jmeA9CTOYHmiw4N41j0t7i8pqTsqMnIsRIq+/
         TQkJjRoKoBUpDJC4lrxiu2qELP3oWwipZmexMn/9FXuRDXGQFhU6UfFJevUrnxNBgp1E
         FmED9Kc/frI0Gxj1Mt0fnUyVeOQUFmV2w8bJ8Dg/wUyH8L1Kkl1J9zsbs4c7b+fsrtzJ
         AY6g==
X-Forwarded-Encrypted: i=1; AJvYcCXvuvR70XhoOwHY73PKGT2WOgg5t5D9P3Y9AwSQDNNK2rXX5VUwPEoonefud/c/lKlNxhY0bUcHBl4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4WYpjUKG7ULoNAULLH/GWQ7Ae8y5w1+Ht/ZHF9tKiwhXed8Hn
	eKL8+GVakVrj0rvZsFUzkwx3S9g0txOmOzQw1PzudUASD49lhHbFULrbY0dzOKfhqRBm1LbDIJH
	z7U3fhBxe3hOgc5vITyhWJfZkfgVMvo2KS2UYn5eeTJriiF/N
X-Gm-Gg: ASbGncsoQSt6bRZCKBuvc4gfsEHeg0xe+paLehesVl1AJ4espieJfYiUdY4e3u6oenp
	Ih5ipYnYRj2rCR/URw2gEcQycTruZjCD1OtxhL8bcbNX3nnVTvm5jFvsnhmJoz0HQxXpD9vSBod
	sQ6PEofQfrFKUCn0IE3n7Jfbz4
X-Google-Smtp-Source: AGHT+IHlb4IHEqQNpxwkO8FcQivnJ2dQg/jVmJf/Nwp7U8mK4w4rGOC/fOQ+qGybr1+upwQ78iRxHho/GtLj5P3hjZw=
X-Received: by 2002:a05:6102:cca:b0:4bb:d062:452 with SMTP id
 ada2fe7eead31-4bd3fc6c813mr9738263137.3.1739911834844; Tue, 18 Feb 2025
 12:50:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJMi0nTHX0inFxme=xnJf23c8=w0bAf7LfiT=YNpmU-zVnUR+Q@mail.gmail.com>
 <CAJMi0nTbyi6VGTmmZ43wYWwJWur0XPtuswZ_5UaXB+S6Z=Mo6A@mail.gmail.com> <20250217172957.GB21808@frogsfrogsfrogs>
In-Reply-To: <20250217172957.GB21808@frogsfrogsfrogs>
From: Lorenz Brun <lorenz@monogon.tech>
Date: Tue, 18 Feb 2025 21:50:24 +0100
X-Gm-Features: AWEUYZm5giUiD9ukjAqvt09Gva85GVPggxV3eM_6kCSxlpA4Pg9vV2yYFq5snTU
Message-ID: <CAJMi0nRtfzLASwT0MTJY1vxdyS+KCHezA-Hc9ugCrPJ-6uZL9w@mail.gmail.com>
Subject: Re: [REGRESSION] xfs kernel panic
To: "Darrick J. Wong" <djwong@kernel.org>, gregkh@linuxfoundation.org
Cc: stable@vger.kernel.org, regressions@lists.linux.dev, 
	linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Thanks everyone, with that patch (now included in 6.12.15) the bug is fixed.

I'm also curious how that commit ended up in stable without the
already-pushed bug fix? It even has the right "Fixes" tag. Not blaming
anyone, nothing bad happened, this all got caught in tests as it
should but how does the process work?

Regards,
Lorenz

Am Mo., 17. Feb. 2025 um 18:29 Uhr schrieb Darrick J. Wong <djwong@kernel.org>:
>
> On Mon, Feb 17, 2025 at 05:27:33PM +0100, Lorenz Brun wrote:
> > Am Mo., 17. Feb. 2025 um 16:00 Uhr schrieb Lorenz Brun <lorenz@monogon.tech>:
> > >
> > > Hi everyone,
> > >
> > > Linux 6.12.14 (released today) contains a regression for XFS, causing
> > > a kernel panic after just a few seconds of working with a
> > > freshly-created (xfsprogs 6.9) XFS filesystem. I have not yet bisected
> > > this because I wanted to get this report out ASAP but I'm going to do
> > > that now. There are multiple associated stack traces, but all of them
> > > have xfs_buf_offset as the faulting function.
> > >
> > > Example backtrace:
> > > [   31.745932] BUG: kernel NULL pointer dereference, address: 0000000000000098
> > > [   31.746590] #PF: supervisor read access in kernel mode
> > > [   31.747072] #PF: error_code(0x0000) - not-present page
> > > [   31.747537] PGD 5bee067 P4D 5bee067 PUD 5bef067 PMD 0
> > > [   31.748016] Oops: Oops: 0000 [#1] PREEMPT SMP NOPTI
> > > [   31.748459] CPU: 0 UID: 0 PID: 116 Comm: xfsaild/vda4 Not tainted
> > > 6.12.14-metropolis #1 9b2470be3d7713b818a3236e4a2804dd9cbef735
> > > [   31.749490] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
> > > BIOS 0.0.0 02/06/2015
> > > [   31.750340] RIP: 0010:xfs_buf_offset+0x9/0x50
> > > [   31.750823] Code: 08 5b e9 8a 2c c4 00 66 2e 0f 1f 84 00 00 00 00
> > > 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 0f 1f 00 0f 1f
> > > 44 00 00 <48> 8b 87 98 00 00 00 48 85 c0 75 2e 48 8b 87 00 01 00 00 48
> > > 89 f2
> > > [   31.752775] RSP: 0018:ffffbf50c07abdb8 EFLAGS: 00010246
> > > [   31.753343] RAX: 0000000000000002 RBX: ffff9c0985817d58 RCX: 0000000000000016
> > > [   31.754103] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> > > [   31.754734] RBP: 0000000000000000 R08: ffff9c09fb704000 R09: 00000000e0be9fc4
> > > [   31.755396] R10: 0000000000000000 R11: ffff9c0985827df8 R12: ffff9c09fb57ff58
> > > [   31.756078] R13: ffff9c0985817eb0 R14: ffff9c09fb704000 R15: ffff9c0985817f00
> > > [   31.756764] FS:  0000000000000000(0000) GS:ffff9c09fc000000(0000)
> > > knlGS:0000000000000000
> > > [   31.757529] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [   31.758041] CR2: 0000000000000098 CR3: 0000000005b70000 CR4: 0000000000350ef0
> > > [   31.758696] Call Trace:
> > > [   31.758940]  <TASK>
> > > [   31.759172]  ? __die+0x56/0x97
> > > [   31.759473]  ? page_fault_oops+0x15c/0x2d0
> > > [   31.759853]  ? exc_page_fault+0x4c5/0x790
> > > [   31.760237]  ? asm_exc_page_fault+0x26/0x30
> > > [   31.760637]  ? xfs_buf_offset+0x9/0x50
> > > [   31.761002]  ? srso_return_thunk+0x5/0x5f
> > > [   31.761409]  xfs_qm_dqflush+0xd0/0x350
> > > [   31.761799]  xfs_qm_dquot_logitem_push+0xe9/0x140
> > > [   31.762253]  xfsaild+0x347/0xa10
> > > [   31.762567]  ? srso_return_thunk+0x5/0x5f
> > > [   31.762952]  ? srso_return_thunk+0x5/0x5f
> > > [   31.763325]  ? __pfx_xfsaild+0x10/0x10
> > > [   31.763665]  kthread+0xd2/0x100
> > > [   31.763985]  ? __pfx_kthread+0x10/0x10
> > > [   31.764342]  ret_from_fork+0x34/0x50
> > > [   31.764675]  ? __pfx_kthread+0x10/0x10
> > > [   31.765029]  ret_from_fork_asm+0x1a/0x30
> > > [   31.765408]  </TASK>
> > > [   31.765618] Modules linked in: kvm_amd
> > > [   31.765978] CR2: 0000000000000098
> > > [   31.766297] ---[ end trace 0000000000000000 ]---
> > > [   32.371004] RIP: 0010:xfs_buf_offset+0x9/0x50
> > > [   32.371453] Code: 08 5b e9 8a 2c c4 00 66 2e 0f 1f 84 00 00 00 00
> > > 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 0f 1f 00 0f 1f
> > > 44 00 00 <48> 8b 87 98 00 00 00 48 85 c0 75 2e 48 8b 87 00 01 00 00 48
> > > 89 f2
> > > [   32.373133] RSP: 0018:ffffbf50c07abdb8 EFLAGS: 00010246
> > > [   32.373611] RAX: 0000000000000002 RBX: ffff9c0985817d58 RCX: 0000000000000016
> > > [   32.374275] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> > > [   32.374921] RBP: 0000000000000000 R08: ffff9c09fb704000 R09: 00000000e0be9fc4
> > > [   32.375720] R10: 0000000000000000 R11: ffff9c0985827df8 R12: ffff9c09fb57ff58
> > > [   32.376376] R13: ffff9c0985817eb0 R14: ffff9c09fb704000 R15: ffff9c0985817f00
> > > [   32.377027] FS:  0000000000000000(0000) GS:ffff9c09fc000000(0000)
> > > knlGS:0000000000000000
> > > [   32.377761] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [   32.378292] CR2: 0000000000000098 CR3: 0000000005b70000 CR4: 0000000000350ef0
> > > [   32.378940] Kernel panic - not syncing: Fatal exception
> > > [   32.379492] Kernel Offset: 0x2a600000 from 0xffffffff81000000
> > > (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> > >
> > > #regzbot introduced: v6.12.13..v6.12.14
> > >
> > > Regards,
> > > Lorenz
> >
> > Hi everyone,
> >
> > I root-caused this to 5808d420 ("xfs: attach dquot buffer to dquot log
> > item buffer"), but needs reverting of the 3 follow-up commits
> > (d331fc15, ee6984a2 and 84307caf) as well as they depend on the broken
> > one. With that 6.12.14 passes our test suite again. Reproduction
> > should be rather easy by just creating a fresh filesystem, mounting
> > with "prjquota" and performing I/O.
>
> Known bug, will patch soon.
>
> --D
>
> > Regards,
> > Lorenz
> >
