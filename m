Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.230.64
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793118935;
	b=1d5yqMVNvYVP9iiuitsoGUnfL+hOb4hiSsRAiXITPcA8TewrDAs5rJhgmS4+bjWktVb9
	 cZ2NXv8sFAId/ra9O8koKYBqZfDPQb1ECO9+LJpgohJEz3EO48geSPgGY2YYH006yPO+i
	 xopYjbCPni+cx3D0X9retWKNu7Knjc+TEsdue0PNZH1q+mrLz6TXgi4rkg7XNTXJiuzpV
	 ktX6Fv/Z1+9xpmZzUROIGxZ+B5z4J7qwqYyEULIpqaqTBY7wW2C/j2ZRDocvpBuKCY+aS
	 OoOI53R4i4kak81gX63JqiEcFMcNO1OUpbCW5BaJ92VCalDRA3WXWhgQJ1jcj1LN5Tg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793118935;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type;
	bh=8zfsEmvvEIyKGYebqHsmSSP0PgqljQxJolIvgr8S9M8=;
	b=20dCCf/Rn4DiFCuEzZaxwmYLY9mgJczcET120YyHA0f1j8+mxY4LjLFIiRxKy4kQyb0k
	 vJUpmL0hqByuVdKbQqTFYi4moUuOAUdozm7oDmH5o6vglHq/tNlUNHFMztlq47eH9XCT0
	 M1oc7PENGkMVSbqtrOR3TumZ668n4+q3s8NHfuhXRVMZ8LJXNkAxAl9nqeZrndYmJRRnj
	 7O0+o+USg4Jd/tx+8q1+IdWHso4wRnymdew6X4yXhttQ5hNHcCUhl5XjYWMhtIA2y/SES
	 6fGpdrOSPT4T4oi6mW9WfIcrSE1q1pwf5a1pJlbanDLpocYYjSdRMZGVORXfWnMmk/Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=plt7RT+r;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.230.64
Received: from mail-lr2-f0.google.com (mail-lr2-f0.google.com [74.125.230.64])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41314606A31A
	for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 16:35:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41314606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=plt7RT+r
Received: by mail-lr2-f0.google.com with SMTP id 38308e7fff4ca-3ab1cf59ff4so27110481fa.0
        for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 09:35:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793118933; cv=none;
        d=google.com; s=arc-20260327;
        b=iPY2HNZMktib1BTBKglAY60Vy1TG/x7Gtva3hzU06WQAN52yYH4OJAxf8l1ELqVRNo
         x0FMDauuEUuXhvK3JQyR60EChfnNU4H95uAociT++qNQZoOfcijNfWdykMmjoCb7slv+
         4UxXIN93rdmjnaRaM/6qjNw4OtXr0JWWiCyGhrZWqwCBRBSHCDBUtkOLbcyJyBf1/0r2
         lF6EaW3XzmbElwrXoSo6i61YULPyGUP5tFPHkB9SLw6qUQZnv25qX3vhJQNJ8clMsauZ
         xxxJCROBk4IfYe/+fK8mWCUL/I6BF2LJqulCqc5YcFZNJcRvEEmxsKbL5KTaN9JjPsyw
         FUbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=8zfsEmvvEIyKGYebqHsmSSP0PgqljQxJolIvgr8S9M8=;
        fh=jDTXTCF4cGkutP1AqQBfZAnlbCKAI/UXEE1DEy9iv6c=;
        b=bQxqnpnnrJpQajdyzfkRTZvmkTgIy34jgPZlFr54gJf1s90ufwf6vPqWSTEK500yxN
         Npd/NTzCNjrHUDy2jdLvSyDH8CcnilO2iyPrnalRvddLEoQ4/wMMMYTmvgqtKloZtSSx
         8jLfXTws4ex6sqMjTV7vcJn531Q+YhQNiiNB6WZthYS59M4PUrntGe5cmRLoulBc1WSs
         oCpD/jCrHUPr8N9Ebz3uFlROuOe1mRJiF4xBVy6tEwQZLtYyHrGcWtn0evL7JhoYgKMR
         aLvIqIS3BZVFlmL8SBaneuUBmZcr02gLl5iiH/+SW9B2RKXmVDtWDLB8hUdSVunfacUx
         Rs4A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793118933; x=1793723733; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8zfsEmvvEIyKGYebqHsmSSP0PgqljQxJolIvgr8S9M8=;
        b=plt7RT+rReO1uv3DGoqtn5hgid4k6TW055WTECby5G3CxTpjrleAcNMeYuiNbbNwQk
         Uy0soNopyCpLowEY3e9sIS568TX3wvGjidJcuKxNus1h5KSTT1o6ECpfP77rggUgunVD
         xKDFP4KU05cYXbIetEKVvaCS0b619SdrgovzNm6FdBPCBt0jZWsd565ulgJEnvgaY3qO
         dbMp6TUMhwXyXeDc3UOnYJqf2Y6TQzTp9jlDCaK5EX/1PwfHOzdk6Mc7GGmr0Lvn3957
         78PyQCnu4aLn5rVOQSWAxr4hQa0GOXSxJo6teP0Nugk4j8OwLijDJgx3WjamAvg7p72N
         16Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793118933; x=1793723733;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=8zfsEmvvEIyKGYebqHsmSSP0PgqljQxJolIvgr8S9M8=;
        b=LCskPzRvUPXn/i+GJm/GmVqZMsv9yS8mTVoW8fwjbECmJGv3K7bCNxgKzIf8459UuA
         wCHHiAIVZY76ksLsnI1gsNy2qC1nNEk8OpexQIdqefNsYaWmPrqaPfGZ58JhbCroc+WH
         3HezDHCDmq0kPYQF2+9m0QmOiNGBXJiOVXWOMeda4H22Y3hfSMPaXY3m1ySsNFWBQAiD
         45FShLkzF9A5WxGgQMdfDdTGvgcwDCbS1wUmP7r5prqIR4dY/19aeU1LWj0SfSAGtd25
         GNrHC43GdmccrYctJVuVR1CE9M7qxJhKFdRYjpbGTMB6uxIk2SaiAYAUtpCh4TKYFcgv
         Z+BA==
X-Gm-Message-State: AFq9FYLe36TQdp6lVoMiS5kOQxvL2N/dOow4InoqU38OdbxOmpcyJcAi
	2wiulIfP2lKhYhF1sC2wA/1U5gwowEC8AN1H6OXrXGa+XVasIG1mklTBiyYkgpXimxle0XTgCF0
	/jVjNTOTUYDqX6zHRao4nuFPOsVcMj68=
X-Gm-Gg: AYBFou0uJimrY/CmuU++5gDkIf0uwG95abmlyJAzk7mbB+n9I1822jJm+9ccG/UBW5f
	IOos2LE6iDO52MSZ3p1QwOavfn1CMUZG62SEJMj5FjQJWqlMboFel5wzBcvIBWOmkDycj4DTVWc
	w2IFmr/NmotYfMhVDujIOhYmH5QJtkEYrRp78mf8TWA0m0QXy58SJh9je7Slr/plm6A9+Sie+MM
	5TDE3um0XO3Iavj/SiW4rxsSkgHOguyc6PmhZ6I6yp9Ra330tNatFtPSWb0RZ/+L2j7AOlAeQX7
	2lgOVUoU3CTBltBLxRcDjSBGJZ3xMwXH0W+WCjgj2L8oCokHe5KEzCLOJP4r270KqrktNgAeXgR
	uS9p/55UA9BECnOGMt+ql8fHcFRE7VNGI2SE=
X-Received: by 2002:a05:651c:a324:b0:3ab:1639:9a79 with SMTP id
 38308e7fff4ca-3ac6fd0d6bcmr26637271fa.15.1793118933187; Tue, 27 Oct 2026
 09:35:33 -0700 (PDT)
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
Date: Wed, 28 Oct 2026 00:35:20 +0800
X-Gm-Features: AclHuK-V9AfE3y9zpjFZtwNjnX9zkj6jNEXo9wHFvEsgWVBRge4G6NUXSzqXSk0
Message-ID: <CAO-4RZ2jOonxsnfq5RtzaTVARqHw_4s0X1yMZiEvG-h=ZFEWfg@mail.gmail.com>
Subject: [BUG] xfs: undersized log triggers assertion in xfs_log_mount()
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Carlos,

Replaying the syzkaller recipe linked below triggers an assertion in
xfs_log_mount(). The log size check reports 516 blocks, below the required
minimum of 636 blocks.

Is this an expected assertion with my XFS debug configuration, or should this
malformed image be rejected without triggering a kernel BUG?

I am reporting an observable assertion with a deliberately malformed XFS
image. I am not claiming a new vulnerability or a specific root cause.

Environment
-----------
- Kernel used for the actual reproduction: 7.3.0-kernsight-kasan #1 SMP
  PREEMPT_DYNAMIC, x86_64, KASAN/KCOV. Source: mainline Linux v7.3, commit
  091b06388b117fefdcb63336ac09956a4914b961 (release tarball sha256
  87363c24f10e06321eb362765521094e94471f6bff8bce2d6b3e40f39f004953).
- Original report: 7.1.3-kernsight-kasan #13, commit
  113be0295f4f632d61f4e9c93322f70e2365f54d (the tree is not a git checkout).
- Also reproduced on 7.2.11-kernsight-kasan, commit
  8316c24ec1b77dba19ba072ca4fe251b36dc65d3.
- XFS config (7.3.0): CONFIG_XFS_DEBUG=y, CONFIG_XFS_DEBUG_EXPENSIVE=y,
  CONFIG_XFS_ASSERT_FATAL=y. The 7.2.11 config has CONFIG_XFS_DEBUG=y and
  CONFIG_XFS_ASSERT_FATAL=y. The three .config files are in the repository.
- Kernel source changes: none for XFS or the VFS in any of the three trees.
  The KernSight changes are in the syzkaller tree, not in the kernel.
- Out-of-tree modules: the original 7.1.3 log was captured in a guest with
  the out-of-tree module ltp_tpci loaded (taint O/E). The 7.3.0 log used for
  this report does not contain ltp_tpci and is clean on that point; a 7.1.3
  re-validation without ltp_tpci has not been done.
- Guest: QEMU 6.2.0, 4 vCPU, 6 GiB, KVM, x86_64; a fresh VM per run.
- Syzkaller: revision 853b104bb454141a5b0fc0e4218ec78e9f34ffb1+
  (2026-09-18); "+" denotes local KernSight integration (seed ordering/state
  feedback in pkg/kernsight, prog/kernsight_*, syz-manager/kernsight_*,
  pkg/execbackend, vm/qemu snapshot support). It does not change the XFS
  syscall descriptions or the executor's fault-injection semantics.
- Kernel command line: root=/dev/sda console=ttyS0 fstab=no rw
  earlyprintk=serial net.ifnames=0 oops=panic panic_on_warn=1
  panic=86400 hung_task_panic=1 softlockup_panic=1 nmi_watchdog=panic
  sysctl.kernel.hung_task_all_cpu_backtrace=1
  sysctl.kernel.panic_on_rcu_stall=1
  sysctl.kernel.max_rcu_stall_to_panic=1 rcupdate.rcu_expedited=1
  rcupdate.rcu_cpu_stall_cputime=1 no_hash_pointers page_owner=on
  sysctl.vm.nr_hugepages=4 sysctl.vm.nr_overcommit_hugepages=4
  secretmem.enable=1 msr.allow_writes=off coredump_filter=0xffff
  vsyscall=native kvm-intel.nested=1 spec_store_bypass_disable=prctl
  nopcid vivid.n_devs=64
vivid.multiplanar=1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2
  netrom.nr_ndevs=32 rose.rose_ndevs=32 smp.csd_lock_timeout=100000
  watchdog_thresh=55 workqueue.watchdog_thresh=140
  sysctl.net.core.netdev_unregister_timeout_secs=140 dummy_hcd.num=16
  max_loop=32 nbd.nbds_max=32 comedi.comedi_num_legacy_minors=4
  kunit.autorun=0 vcan.echo=1
- Reproduction counts (methods kept separate): full 37-program recipe on
  7.3.0: 1/1; standalone mount-32.prog on 7.3.0: 1/1; 7.2.11 state-primed:
  1/1; 7.1.3: original report. A repeated cold-boot run (e.g. 5/5) and a
  non-debug / CONFIG_XFS_ASSERT_FATAL=n kernel were not tested.

Reproduction
------------
The independent trigger is `xfs-mounts/mount-32.prog`, a single
`syz_mount_image$xfs` program extracted from the full recipe. Run it alone in
a fresh 7.3.0 VM with the same execprog arguments:

  scp syz-execprog syz-executor mount-32.prog root@guest:/tmp/
  ssh root@guest
  cd /tmp && chmod +x syz-execprog syz-executor
  ./syz-execprog -procs=1 -repeat=1 -disable=swap -executor
./syz-executor ./mount-32.prog

Its serial log shows the same failure (516 < 636 blocks,
`fs/xfs/xfs_log.c:597`, kernel BUG, panic); it is archived as
`xfs-mounts/results/mount-32/serial.log`. The full 37-program recipe
(`repro/repro.kernsight.prog`) also triggers it. The other 9 extracted mount
blocks did not show the crash in their captured serial logs. The programs,
commands and per-run logs are in `xfs-mounts/` (`xfs-mounts/RESULTS.md`).
Note that syz-execprog's `executed programs: 0` / `EXIT:0` lines are not
proof of execution; the serial logs are the evidence. No preceding recipe
replay was needed in this standalone run. Further minimisation of
`mount-32.prog` has not been attempted. `repro/repro.prog` is only the
tty/KDSKBSENT testcase and is not the XFS trigger.

Observed on 7.3.0
-----------------
During the full-recipe run, at 155.287 s:

  [ 155.287055][T11019] XFS (loop0): Log size 516 blocks too small,
minimum size is 636 blocks
  [ 155.287075][T11019] XFS: Assertion failed: 0, file:
fs/xfs/xfs_log.c, line: 597
  [ 155.287882][T11019] kernel BUG at fs/xfs/xfs_message.c:102!
  [ 155.295065][T11019] RIP: 0010:assfail+0xa2/0xb0
  [ 155.304491][T11019]  xfs_log_mount+0x4e3/0x590
  [ 155.320739][T11019] RIP: 0010:assfail+0xa2/0xb0
  [ 155.320891][T11019] Kernel panic - not syncing: Fatal exception

In the standalone mount-32 run, at 259.143/259.154 s:

  [ 259.143249][T10455] XFS (loop0): Mounting V5 Filesystem
a2f82aab-77f8-4286-afd4-a8f747a74bab
  [ 259.154708][T10455] XFS (loop0): Log size 516 blocks too small,
minimum size is 636 blocks
  [ 259.154745][T10455] XFS: Assertion failed: 0, file:
fs/xfs/xfs_log.c, line: 597
  [ 259.155220][T10455] kernel BUG at fs/xfs/xfs_message.c:102!
  [ 259.193047][T10455] Kernel panic - not syncing: Fatal exception

The original 7.1.3 report shows the same log-size diagnostic and
assertion at fs/xfs/xfs_log.c:593:

  XFS (loop1): Log size 516 blocks too small, minimum size is 636 blocks
  XFS: Assertion failed: 0, file: fs/xfs/xfs_log.c, line: 593
  kernel BUG at fs/xfs/xfs_message.c:102!
  RIP: 0010:assfail fs/xfs/xfs_message.c:102 [inline]
  xfs_log_mount+0x4e3/0x590 fs/xfs/xfs_log.c:593

On 7.2.11 the state-primed replay reproduces the same crash
(2026-10-20T09:15:38Z, C=false); the report excerpt is in the repository.

Questions
---------
- Is this assertion expected when mounting an image whose log is smaller
  than the minimum, or should xfs_log_mount() reject the image without
  triggering a kernel BUG?
- Is the XFS (loop0) "Log size ... too small" path intended to be fatal
  under CONFIG_XFS_DEBUG + CONFIG_XFS_ASSERT_FATAL, or is it a case that
  should be handled gracefully regardless of the debug configuration?

Materials
---------
The full programs, embedded image, .config files and boot-to-crash serial
logs are available at:

  https://github.com/Zheng-zheng-codes/xfs-undersized-log-assert-repro

Contents:
  repro/repro.prog                tty/KDSKBSENT testcase (NOT the XFS trigger)
  repro/repro.kernsight.prog      full 37-program recipe; contains the
XFS image/mounts
  7.1.3/report0, 7.1.3/log0       original 7.1.3 report and full log
  7.1.3/machineInfo0, 7.1.3/description, 7.1.3/pre_state0
  7.2.11/RESULT.md, 7.2.11/repro.*   7.2.11 state-primed reproduction
  7.3/serial-7.3.log              full 7.3.0 boot-to-crash serial log
  7.3/console-7.3.log, 7.3/cmdline-7.3.txt,
  7.3/boot-info-7.3.txt, 7.3/RESULT-7.3.txt
  xfs-mounts/                     10 extracted mount blocks + standalone results
  kernel/kernel-7.1.3.config, kernel/kernel-7.2.11.config,
  kernel/kernel-7.3.config, kernel/SOURCES.md

Best regards,
Zheng Zheng
