Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.230.72
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793120469;
	b=FOeSYgHwInbQXnPP9DFpsxfthCX1WtfGIYOJ6NCZ1XmI4WpwlGlu1786Sw2O3Tq29olf
	 bcjoZL3ZWByu2VxIMMcFN9E8BXGR1hiC8nx0rlUg7imsovYs1r0o/an8SpXoEkACh/Bpn
	 InV/20y+Itn90mQSDQwXK69mAZrxdrjqb7DOkdIUJwun6Lp0k1u37Tq7xDQlEEkMittH9
	 W4ECEGE9tCrsHy4jWiUofwntTXx7v/F12ETllt50EZ0d1c59WMg/o3PG7ZpXbnbmxAtW2
	 QKP1njtFA1tmBh+uu6B0TRN+K73YkjinZh1PrKi78bTRrqaKp/wOfavBuTRGrJSDiGQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793120469;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type;
	bh=zi4w/c44kjEfa6V924nGXSvk6C4q+Jl3FpQUCJP2Aq4=;
	b=uiCO8IC62AZD2tHFiI/wySPJrJuvVUlxMNwW8ghelFenEaEjwoOXyN6U0hWR1DuM7pti
	 rNxiGF5N1cSnV5IV2qfebGzPs032FE5rS0pe9A+q2zEp4ntGrZSjDK0rHpYhddaDvAZn2
	 wfhbgFQYAgjFVHBKqU+tcbPeKlOmB0pl2KL+Hma3meSCiGr/vubfEmB7h8XGTxeFLUmRA
	 JNnLOybkTFvYw65+2st6eX69E5TNNW9nJGr3UaZ69cjqC4JME+suIktRtBy04mW93aEFn
	 B3V0sbp7/yQEXdc5K5K/DKRNbop/S6Qh3MD/jiK2e422+OqIwhk0mNJPthxFPRiIOcg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fdDgoeco;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.230.72
Received: from mail-lr2-f8.google.com (mail-lr2-f8.google.com [74.125.230.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17124606A31B
	for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 17:01:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17124606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fdDgoeco
Received: by mail-lr2-f8.google.com with SMTP id 38308e7fff4ca-3ab28382b92so331001fa.0
        for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 10:01:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793120467; cv=none;
        d=google.com; s=arc-20260327;
        b=j9FeIGcn/lZbv5WycTzsxHMawBO1MO8fh4tKJLRTYnO4L1lGGQE9knhm+GNlbbK1QA
         QcKs3XGeaq2hMmgQlf6/PSg6gTg/P0Dxc9fQpOc/mS91Wc27ni2gSYfmGiQ/z5d3CX9x
         L/noU6W8OUKupT2maq30RfgM0IejhIUGFdSNiaBDfE5bJSqu6UxlhpH3ES4qhDBE58dN
         Oisa9dqN2DvlMjBdvj12gC5ks1G5k+e7w5Ldy58V523vg8ll5y/htWxJ3wUxsxVdTBTH
         pABNPUFyx/DTy0cKRdWz4GiKEfTq9+BYUHsajqxmoTfxcidqHd5TZAudlh+cajKLCiZd
         +wRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=zi4w/c44kjEfa6V924nGXSvk6C4q+Jl3FpQUCJP2Aq4=;
        fh=jDTXTCF4cGkutP1AqQBfZAnlbCKAI/UXEE1DEy9iv6c=;
        b=SsHDr42dP2uVwC/7dDHR5iC8mFhzhdWIbZqAWtYaCsIrVlQuZk/C/xxX7KSa0xAhea
         5RjWKNnBgmQqkZ40Xk88Aym/XzWDY3Y8A70t+d0rsAK8L4oq4fF8QIInSVo4BQLokFZO
         GZCzsmTKFawQtC7B777wCFDlAN0sdunGoHEgQlFuVPN/+JJdkS2GCg1CE0RkfEUT1qMf
         4BkwjosVVc3O92uyB1sCVQBmiLMIJe3U7AeaKtk8/sDjhfOWEQ58MkJ+vvQQjl2TnpQg
         QrmpDv0kg84L+nDM67Da7wgw7+eABTfsl/qwOGwVCP4vqO/mh0ZkU0n+tXyqBBhy+Jbk
         gXZg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793120467; x=1793725267; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zi4w/c44kjEfa6V924nGXSvk6C4q+Jl3FpQUCJP2Aq4=;
        b=fdDgoecoIiBfOFqtlN9rln0tfD73jh+IA4IxvE4+jpDzfnH1ylQtpJ8vmi8izMdkIk
         bKovoGRkCuaQWurDmgujP4LkM0f7zhXIuFbJT/XSnZS32cNNLaPpqJ1NpRGSScXGlPGa
         d9JOI8ga3/oh8WFTdJKtkHtC8JcI/Y8Z4o39AuVZRO2y1nP2px0iahQTwFugMBXD7x9U
         r2764mM2HlMUkIgyY1wGL5EITjJn50UAjmZj9k3JPLtbXEmr2n8RZi7umDk5Z7jpkhmM
         f0wJJ9fPFcvhmV5NLNRIv8CHDLZLcQ+s2jrzo6C1ORb3mYts1bBg+jhgMEZs4GkybNfx
         viLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793120467; x=1793725267;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=zi4w/c44kjEfa6V924nGXSvk6C4q+Jl3FpQUCJP2Aq4=;
        b=EHoTyw6U26pY0KexXZXuaEiazRGqPNvaRzrxbch62sUQfMBfyKAxTnnFYhVT6KUlwt
         vu5RvJgxdkHLWM9CapVcn41gq7zdcXVdrnhR64c9wNsyUHHh9/y37oEehPXZxhsGkT6C
         yc8QcC4vPy3OBrpwsPno1VZsJP5bgmyilV3bnrWuJOg/LuDPqczTLPHG80nM++kS+42S
         cZ1AWf/0TKUy5+91F2VqhoA8KUYTWQkhd/tMi+yATrYRAK7w7slxx0jn4M6+kuBi/sU+
         Vj0cxwDB8pKDCS8+3GjjCnldMqirL3mu9bazz+Ke/m3HfSEwS22LUg9aMxspjB9EYDOY
         noBg==
X-Gm-Message-State: AFq9FYIapFgtkwx917dLm/GNr5BRHwYFV7BW6GaAu0iulUej5WQTvAlz
	mvBoBdmRWMPOMSpPJTj222/meJ9OpwLPUaAdXKDtfjpNu/EvxaM16MIda6W4kGX6/W792LGGZPm
	EJswZKuWzEcN+uTV/vIXoSq2HgzXGU8Y=
X-Gm-Gg: AYBFou1eDi0cztOOIa6dYpp+M6c8eFiUE1TQx4g6oqF4IXxPNZ4QfT1+aHT55ExXjNx
	fvOLz3cexvjCoBqSP9P3iQbOJRjfSU9HnPO2D5sdkrpOV9kDDgowgzQRRm/kae/yOgNbZXY/pa4
	XdKUTBEqgf5DHYseoQ9ud1janaGSYDNOMToZY0ipfx70YlPFgs2wgTETgyUySe/C0o4GQkD7mB0
	wK4ypTrcXUuME9hzoNI36FYn8CQZ3YUe/TyvPkFiL7WBz1napv8c9q6PiWMFAlXRvE9j2qQqhnp
	mnxvLJbuh8VRjqCKUrcr8TXiG0163DQF2rJ67/R/foPymRQaw2gxiqGSnfu+4ur7dt/qPh5KXl8
	RzeqjdUAfaMntk7bXre3keNMxRID65ptgrjU=
X-Received: by 2002:a2e:bc14:0:b0:3a9:82c2:ec1e with SMTP id
 38308e7fff4ca-3ac6fd0b4ccmr27235761fa.15.1793120466960; Tue, 27 Oct 2026
 10:01:06 -0700 (PDT)
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
Date: Wed, 28 Oct 2026 01:00:54 +0800
X-Gm-Features: AclHuK_T5zbz1aBN4vXlACbADxhIhPFWfhZBWoWr8eVkT95CYHG06F69Ck5S7L8
Message-ID: <CAO-4RZ25PZ5BM+83Vk8t5NUY3ksLGz5nzONrncipu2_MZhFSsg@mail.gmail.com>
Subject: [BUG] xfs: undersized log triggers assertion in xfs_log_mount()
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Carlos,

Executing the stored syzkaller testcases on Linux 7.3.0 ultimately triggers
an assertion in xfs_log_mount():

  XFS (loop0): AAIEEE! Log failed size checks. Abort!
  XFS: Assertion failed: 0, file: fs/xfs/xfs_log.c, line: 597
  kernel BUG at fs/xfs/xfs_message.c:102!
  ...
  xfs_log_mount+0x4e3/0x590
  xfs_mountfs+0x10b9/0x2270
  xfs_fs_fill_super+0x15cc/0x20b0
  ...
  Kernel panic - not syncing: Fatal exception

The log size check reports 516 blocks, below the required minimum of
636 blocks.

Is this an expected assertion with my XFS debug configuration, or should
this malformed image be rejected without triggering a kernel BUG?

I am reporting an observable assertion from a syzkaller reproduction. I am
not claiming a new vulnerability or a specific root cause.

Environment
-----------
- Kernel: 7.3.0-kernsight-kasan #1 SMP PREEMPT_DYNAMIC (2026-10-20),
  x86_64, KASAN/KCOV. Source: mainline Linux v7.3, commit
  091b06388b117fefdcb63336ac09956a4914b961, release tarball sha256
  87363c24f10e06321eb362765521094e94471f6bff8bce2d6b3e40f39f004953.
- XFS config: CONFIG_XFS_DEBUG=y, CONFIG_XFS_DEBUG_EXPENSIVE=y,
  CONFIG_XFS_ASSERT_FATAL=y. The full configuration is available as
  kernel/kernel-7.3.config in the repository.
- Kernel source changes: none for XFS or the VFS. The KernSight changes are
  in the syzkaller tree, not in the kernel.
- Taint: Not tainted (the report above is from a clean boot).
- Guest: QEMU 6.2.0, 4 vCPU, 6 GiB, KVM, x86_64; a fresh VM per run.
- Syzkaller: revision 853b104bb454141a5b0fc0e4218ec78e9f34ffb1+
  (2026-09-18). The "+" denotes local KernSight integration (seed ordering/
  state feedback: pkg/kernsight, prog/kernsight_*, syz-manager/kernsight_*,
  pkg/execbackend, vm/qemu snapshot support). It does not change the XFS
  syscall descriptions or the executor's fault-injection semantics.
- Full kernel command line:
  7.3/cmdline-7.3-20261024.txt in the repository.
- An additional fresh-VM validation on 2026-10-28 confirmed that
  repro.kernsight.prog alone triggers the assertion using the command
  below. The kernel BUG occurred at approximately 162.26 seconds after
  boot.

Reproduction
------------
The trigger is the state-construction recipe alone
(`repro.kernsight.prog`, ~2.6 MB); the smaller `repro.prog` (~24 KB) is not
needed. There is no standalone XFS image file; the image data is embedded in
the recipe. Run it on a fresh VM:

  scp syz-execprog syz-executor repro/repro.kernsight.prog root@guest:/tmp/
  ssh root@guest
  cd /tmp && chmod +x syz-execprog syz-executor
  ./syz-execprog -procs=1 -repeat=1 -disable=swap -executor
./syz-executor ./repro.kernsight.prog

Earlier observation on 7.3.0 (2026-10-24)
----------------------------------------
```
[ 155.506948][T11067] XFS (loop0): AAIEEE! Log failed size checks. Abort!
[ 155.506958][T11067] XFS: Assertion failed: 0, file:
fs/xfs/xfs_log.c, line: 597
[ 155.507283][T11067] ------------[ cut here ]------------
[ 155.507292][T11067] kernel BUG at fs/xfs/xfs_message.c:102!
[ 155.507311][T11067] Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
[ 155.513319][T11067] CPU: 2 UID: 0 PID: 11067 Comm: syz.0.50 Not
tainted 7.3.0-kernsight-kasan #1 PREEMPT(full)
[ 155.515662][T11067] RIP: 0010:assfail+0xa2/0xb0
[ 155.527881][T11067] Call Trace:
[ 155.528122][T11067]  xfs_log_mount+0x4e3/0x590
[ 155.528503][T11067]  xfs_mountfs+0x10b9/0x2270
[ 155.530595][T11067]  xfs_fs_fill_super+0x15cc/0x20b0
[ 155.531014][T11067]  get_tree_bdev_flags+0x38e/0x620
[ 155.553843][T11067] Kernel panic - not syncing: Fatal exception
```

Questions
---------
- Is triggering a fatal assertion for an undersized V5 log intentional
  with CONFIG_XFS_DEBUG=y and CONFIG_XFS_ASSERT_FATAL=y, or should this
  case return -EINVAL without triggering a BUG?
- If a diagnostic dump would help, what state should be printed before the
  assertion so the malformed image/log geometry can be identified?

Materials
---------
The full testcases, 7.3.0 serial/console logs, crash report, .config and
reproduction script are in the public repository:

  https://github.com/Zheng-zheng-codes/e713403e-xfs-assfail-repro

Contents include:
  repro/repro.kernsight.prog             state-construction recipe (~2.6 MB)
  repro/repro.prog                       small testcase (~24 KB; NOT needed)
  7.3/validation-run-20261028/          2026-10-28 recipe-only validation
                                         (serial log, boot information,
                                         kernel command line)
  7.3/serial-7.3-20261024.log            full boot-to-crash serial log
  7.3/crash-excerpt-7.3-20261024.txt     extracted crash report
  7.3/console-7.3-20261024.log
  7.3/cmdline-7.3-20261024.txt
  7.3/boot-info-7.3-20261024.txt
  7.3/RESULT.txt                          earlier 2026-10-24 harness result
                                         (its 466 s is the old harness duration,
                                         not the 162.26 s crash time above)
  kernel/kernel-7.3.config, kernel/SOURCES.md
  reproduce.sh, verify.sh, MANIFEST.sha256

Best regards,
Zheng Zheng
