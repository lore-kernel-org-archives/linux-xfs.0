Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.195
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794502912;
	b=kM660JriFEro3OofuexoOf9ierUihuRaOitCv9QIQAzmlHScIAp1AkatIcYUhv/877Ad
	 qqx24Zr6f3Ry0TFr/98SlwXlDpcGRH2g8QOAbNSgcg0IpaY+HspEJMt+iph6doUt3LgTc
	 EGGksHdQxAdczaEvZPKxOOtDXisBBh1VjzF4YhmM5fR0xaRg/UdqnZZmSwmOP8wOj9uOZ
	 sbZmyoZrEWi56D5AV/7D4NFiY3SjgmgOeB//kZiA0bFkvz90KB+xbRrGKlRaTvD4psZ/a
	 v9kG1tP9l2A0UDZeMd5U0B/WAo+5dqfJ7v6fUZcgyMywkXQmwt7apO03dnpqWPgpktg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794502912;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type;
	bh=LE1pJkJzQmD4KHZy3KibAk6pagP6QWSp8ER9p+DD6nk=;
	b=FG2X9ge2fsne/i74+Qtd71h7kjsr9GE3qWIAJGYfH3omqpCciNX/WSJMyBF9B6ZUD/5S
	 vz/8yj4qZCTI9eirIiWUqCkliFTl4tsJX6JZdd0DMOSGGmW2RY/fln1Aq+Ns7exWNjNcM
	 kDe2gfNQ2EJaMdMkVKF8LTE+Z13OPxXgTGCfBy5fdH11oaywUVjwTXjOk/GaQheFI8N9D
	 6EXe7iQxckbTqIE1tc59gvRdRk8uV9ENqOLTCiCUnONYwtsz0oXVql4IcZmm3LDNZiycl
	 PTPnNAdCpq/BfbWQDsfPnBVpmizJYFEu90PG98jC6rwGa5SBFBjHJLAgq6se5PH75XA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rklWZWfh;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.195
Received: from mail-lj1-f195.google.com (mail-lj1-f195.google.com [209.85.208.195])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E4D606A31C
	for <linux-xfs@vger.kernel.org>; Thu, 12 Nov 2026 17:01:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99E4D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rklWZWfh
Received: by mail-lj1-f195.google.com with SMTP id 38308e7fff4ca-3ada7d53082so612441fa.0
        for <linux-xfs@vger.kernel.org>; Thu, 12 Nov 2026 09:01:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794502910; cv=none;
        d=google.com; s=arc-20260327;
        b=GzcoHhgHmhkYM47MEcpXZZWx1iaUnP5ageXZYT8e4Mv/3W51j/Q9+V7KGyzPSbNmcR
         VWSIDuxx4g1oiu6DEMvI1EfOiwXFSG1wb4wOJlF6FxheGj05lbnF3pneQYhwAtISusAC
         /HzVku0DCaIlcgFI4BPwYjAqLuIr0SI9L8ixJ+Y+1LtFq6UXN1Y0r8IxyaEeTVVMOGQK
         y7gm+B5G7jjBFqbbTVVFjIKanmkV6Jvr9UHeY2gVBPV8jIDJHALHzkUin3dwGysrSqNW
         yk1era+46Z2SbuMu5a2puoLdrqkLb2hCWze/BchsZZspA6v47DvGc/lnL9js/DBsb4Tk
         O61Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=LE1pJkJzQmD4KHZy3KibAk6pagP6QWSp8ER9p+DD6nk=;
        fh=/cvED26QcK8RKf7XdBxNspC3OAyC8YKJSa+vB7gNuro=;
        b=Jbt8heO1Aqg4i3CmAni/XLa2y3BA+cZCd0E2BvZBPTkrrPX+Mv4ichUc+xlt4e1saK
         Fi07nlWRnDykWDZuMk4yXcalSMB55uKU+2h8ow+G3bcuzObn9xX13fdX9mhOOfSkTi4z
         h96mekgpUq1Yt756kU85tMKDnes/P9jVAxAMqNW9YHW++4EH441XCpVaF6m6KH+lQgLl
         dur2aLMI+HqkrC8ICJQNj3vkk+Beu2M2Ah9kmz4HUYZ50Nfz/f4z1HB/YCoruy1iiK2i
         xHaVAb21d2Yo82ICB1oIfZeZ1n76WpZJ4UKZd/0tky8esxyiYOS4l5sm6mX+tXmUBMWv
         RyWw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794502910; x=1795107710; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LE1pJkJzQmD4KHZy3KibAk6pagP6QWSp8ER9p+DD6nk=;
        b=rklWZWfhrj53wAWPR76QmBFXjRMLzzHCqWJHEJSHWW99JHS6GvghPeQlUSoKCL2A7D
         Jsbb8ETKSOAmmbgYrs0YY8bpo/A2qTDgn/8ruyBhyAVT85kpAyt/M396lR3BJF62g5i2
         KSKrO+vOXl4dGMsbUd5L23VbxY2eYTJzbp6IxQqrAr+ckfFHpyzYez0a9nNbxkbKkjSC
         s8vh/xYn3AG5VLJObz/zutqVI8+oe0PEdReZxXGNiwznYP/o85Nmq1UCCsO2AN43eXNj
         X0xB6YIeB+qcfWSZGA9T+EoGHgMGarhxiydvLT1K1RfUc1bZf5wzecYf2yqmLFcIUvL2
         2WNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794502910; x=1795107710;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=LE1pJkJzQmD4KHZy3KibAk6pagP6QWSp8ER9p+DD6nk=;
        b=efe1ajqVzyvzSLnfkXG5ILt2Ku6TocNFriYePJ7RQkgvCdxvAWxqjBHFer1osrSk5i
         6rqG+A9uWQsJ/ZGESBRuttO8pZKPuW/Vo0SdOr6XtXv8agHTsSIjswdyLF11BacHPe1G
         vCeEFMqGUlr1hhvgkNbJpKJLVvP8pmnCFCNZDndUvVV2SykOIV29qjTeprqkdBfo1FbZ
         haRbI4n8Ixo5EVtDPH6cM6IlMTqEGCkpQCic0YlZ7uc2t3RHPJMgR0ZMAJcG5Qr9WGrO
         lw5g4NkVAsg9wgmz735uLrO797INL3jGpyt/TCXeLgBRAFep4x0eO/MeukJllP8zYNI2
         OWyQ==
X-Gm-Message-State: APuU4Z/oLvpow4hqfKMOe1/L5ayhdaJqkJohKrTenJys0YRmfHBx9eO4
	8gyfSh7V/uL1F7/nBUKM+m/uSpAffkZTykdaM+dWcrq07LU9hVt4zYTn43S4IfU9k2DfYVMFsi1
	9y/1goIGFQF1iycWTdT4kHu3D7DAK7VE=
X-Gm-Gg: AYBFou0329Pjw2aGrri177Zha+9R5kfv2GFJdtI34/cg1VH5yOMSvCsuyXhMv3f7ZTK
	4rvHFl5qBjCnZU8c25ICPizG4F9bsJEy8OfpEFsu9TToXhC6wqEnnpPANkJqQ0Ca4ERRHyRIyf6
	JMVaYBk9aOF5GhbRbYmXEiQrKkSuJo/uXK4YEPQd5jCV+h6m8u0avQmtcHz7fQAnqLsCWAdCS/X
	qtJ5LZCn6xuN3HHhlygE2nCTvOIFGWMYxbuEQPPS46Cb+q3dth2E34tLPfTpwKwASGY74HS7/Q3
	S1Fnk2G++2BaBdjGAvCzuQ8hm3f8r0LLq3lTzI+liVfr+RV2wru/x2FGh3qrUq9qwjFLiiZII/0
	SnQYullwoIuJHjelj89tw6rmG4y/hUrI0osU9UMOo7mafCtsb7/rs6Oam1993nij1/iUr3Mblmo
	JMnhNnl11GtiR67A==
X-Received: by 2002:a2e:a543:0:b0:3ad:fd26:fd2a with SMTP id
 38308e7fff4ca-3ae1bfb8004mr8647671fa.7.1794502909765; Thu, 12 Nov 2026
 09:01:49 -0800 (PST)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: =?UTF-8?B?6ZOu?= <fengaojigui88@gmail.com>
Date: Fri, 13 Nov 2026 01:01:37 +0800
X-Gm-Features: AclHuK-drOWyFhSlQjdMJ_5Q4lK9tj9u39cXrmTuwnolZTO9jGZH0B97pKhU-6M
Message-ID: <CAO-4RZ0x1FLMRWHV5pE+oxf1ttPLQLzaJfLqKcacXyNSdXVOmA@mail.gmail.com>
Subject: [BUG] xfs: WARNING in inc_nlink (fs/inode.c:465) via mkdir on crafted
 XFS image (v7.4-rc2)
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Carlos,

We found a reproducible XFS warning on v7.4-rc2 with syzkaller. Creating a
directory on a crafted XFS image trips the VFS link-count sanity check:

  WARNING: fs/inode.c:465 at inc_nlink+0x168/0x180, CPU#2: syz.0.17/25512
  RIP: 0010:inc_nlink+0x168/0x180 fs/inode.c:465
  Call Trace:
   xfs_bumplink+0x94/0x1e0 fs/xfs/libxfs/xfs_inode_util.c:687
   xfs_dir_create_child+0x340/0x3a0 fs/xfs/libxfs/xfs_dir2.c:872
   xfs_create+0x8bb/0xb80 fs/xfs/xfs_inode.c:728
   xfs_generic_create+0x650/0x800 fs/xfs/xfs_iops.c:216
   xfs_vn_mkdir+0x36/0x50 fs/xfs/xfs_iops.c:308

The warning indicates that inc_nlink() was called with
inode->i_nlink == 0 while I_LINKABLE was not set, via the XFS mkdir path
(xfs_vn_mkdir -> xfs_create -> xfs_dir_create_child -> xfs_bumplink).
The underlying cause of this inode state has not yet been determined.
Our guest runs with panic_on_warn=1, which escalates this warning to a
kernel panic.

Kernel/config: 7.4.0-rc2-kernsight-kasan #1, built from v7.4-rc2 with
CONFIG_KASAN=y, CONFIG_PROVE_LOCKING=y, CONFIG_XFS_FS=y, booted with
oops=panic and panic_on_warn=1.

The reproducer contains a set of 83 state-reconstruction programs and
triggering operations. The programs are replayed repeatedly with 8
parallel workers. The warning is reached through the XFS mkdir path:

  syz-execprog -procs=8 -threaded -repeat=0 -executor ./syz-executor
repro.kernsight.prog

Verified on a fresh VM: the warning fires 230.6 s after guest boot and
panic_on_warn escalates it to a kernel panic (full console in the
repository).

A full write-up, the reproducer and the verified console log are available
at https://github.com/Zheng-zheng-codes/xfs-inc-nlink-warning.

Repository contents:
  - README.md                      full bug report: phenomenon, stack trace,
                                   mechanism, reproduction steps, timings
  - reproducer/repro.kernsight.prog
                                   pipeline-verified reproducer (83-program
                                   ordered set + triggering mkdir)
  - reproducer/repro.prog          original syzkaller-extracted program
                                 (pipeline evidence; not a standalone
reproducer)
  - reproducer/repro.priming.prog  state-priming program set (pipeline recipe)
  - kernel.config                  kernel configuration used
  - environment.txt                kernel image info (sha256), QEMU command
                                   line, syzkaller commit, reproducer command
  - logs/log-*.txt, logs/report-*.txt
                                   original syzkaller execution logs and crash
                                   reports from the fuzzing pipeline
  - logs/machineInfo-*.txt, logs/title-stat.json
                                   guest environment info and title statistics
  - logs/external-verification/    external standalone verification artifacts
                                   (serial console of the verified run)


Happy to provide the kernel image, the crafted XFS image, additional crash
instances or raw artifacts if useful.

Best regards,
Zheng Zheng
