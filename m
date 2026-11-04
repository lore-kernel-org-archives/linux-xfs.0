Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793815969;
	b=5MqSycJbzqydX9U32HBmvSnC5m4ceKAItl3zScmP2S6dCmStZkZXF6fKxD53Vep+bSDC
	 yvsmkSRN9ia5Ayg0WWp8wnctjlIYP3ewxY/McUawDIRwMTXC49gdIGdicHNW2WpxPFce6
	 KMT5VeCwsTPFW1jyK4A3wjE80CDZ8HkG1djWt/cFn6eA46h9M9H51HfaaA3D0ZTS+/zyd
	 PPjZOXH2pHBvLCpgOWxXpGY7P+tr95kf6GGMcHo+FsVcx6JMmx5052ju/4YNzMs7IUy6C
	 /fMkJbzdigBgH0pcWAVtSrVn+SEn0rSdDefSyp/gzc2U8IAQkKupzN58i1TsnVsrrdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793815969;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Ono7N58ByNZI48Y3QSu0KoYOTb8Je5peq1KxbsyI0X0=;
	b=bpa6hKSUa+WG4stG+HxKYgDq8e/XGVa5ytf+ZBHB863Wam71qUDl3IPHzGA7FELZv85H
	 vFCOJd5WIuHxb3v2ejFukXVnNJa42nLRZXIEgXej6D1Pvxzt/GXhE9agoMgdAzI0VjPFW
	 3asaQ3gcPvhWZi9jQTueFZcJIToTcATvsO7Y2bKIoVuIfOoQDB2EZFxREAPB5zC4XiMmo
	 IV5QwPmeDFBrqouwyoq2Fo6IMAAQNanCLskr2VpZPKECRMevSblIB5mr6XpXr+9RxNxnD
	 LRB1xXELhCISfLfiMv8tc1OImisN6N3qF6T2tbKVUcBk/3J8LfVcXI5MORcMzFT/0FQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GWfzPYBi;
	arc=none smtp.remote-ip=209.85.216.45
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3A7606A334
	for <linux-xfs@vger.kernel.org>; Wed,  4 Nov 2026 18:12:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3E3A7606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GWfzPYBi
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3ae6b4c669fso1375726a91.0
        for <linux-xfs@vger.kernel.org>; Wed, 04 Nov 2026 10:12:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793815968; x=1794420768; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ono7N58ByNZI48Y3QSu0KoYOTb8Je5peq1KxbsyI0X0=;
        b=GWfzPYBitaO/bkePGx2zn88PE16vLAgyfXWYypFtjslphu40OFxhWQg8jdS2zSrBDR
         SIUtdKz7r7E4XX2CXYmppqIcjYGdp6Nt62+zgjA5CdlL1ggAYFAfGqyYK+kx4gknnkKT
         oeXObrhqmgmErfqY2VTKUkIKqEj9FHTe5YoWgDqPQORjCpY0+7FSUVZxCVs7wqPRmeeB
         cVho0JP33Ab7EmOWx7HvbPa5MINE/31tUQQW5wzr7XRhNQfjJPqx3t/7H8dtvlfwVppu
         FODvo68ttZ1YyzWgEen68N/Tdx++yjb1K+xO5MhBOxwimVvneH3KXW1ZAAbltC7aax8F
         h9og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793815968; x=1794420768;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ono7N58ByNZI48Y3QSu0KoYOTb8Je5peq1KxbsyI0X0=;
        b=U9Pol+nAOISTl01BXAx9B+ZKVU3p5nCTyAhRduFti/sG7+FbwLIQaQfysLs8SquhGW
         qis3AaKJq2U9+58vVYN0dgyWl8nNngHwwTmiacf6o9SRdOy26q7CDpKhukEtTmOQwqpW
         SeoykYYnMnXcnfZMeZJvfDE1M39jlM/lgauigONxNqDSubPIiYG1MTnuymoY8GgYHhre
         eSZc4kf2sk78AGch4fvVT19AEGmpIFsNmJDdWX4iir1WSES6vjBZ1tQzBXasDBelvWE0
         F7Y2l+LPoDjzivm6JhJbqTQb9WOeT4JN+Ur4lxliA63ztVEniNwS0h1Y2hwvWEHThUIh
         /Iag==
X-Forwarded-Encrypted: i=1; AKwUvBxiYECY8abCbbg10bV394GPvGGrejosdDBQOk9uCugYI8m43idQevdUPGRgRLTuUeunFOiahNBB4iY=@vger.kernel.org
X-Gm-Message-State: APuU4Z9D2U/I0ZhfeNkYdSsqRKR1S1QWBHVO5+evnaMu93DlgOv5G9YM
	skn7/druSJ+c48E8HahazKamRBuQ1EXkGfZ4cIDS/2pqWeDKM3ElsFIZ+vF9sIhXW2mt+w==
X-Gm-Gg: AYBFou0t3RrPwuGltE1tP7fCBGyS3G9/+34lV0HVS1p+kgcwOiM9BeKMMpPMdBRxNAr
	BYJk1M1myHq4WhuedmmzWEwxWD34YUtI7BU54IAjwYLRJk3Ic/zx8Ropzr53ZCWqTXIJMuZmm4x
	f5Db2B50Nxx7RobBGKDVw5sFpg0vdLNDRf/a+d6Z7ImDyCrUhZKOJp6492PJKtoewyne6cqhTIw
	OYC0iV7SAdXBAMAPUBQHZ/9dqKN773wsOQGZHm5qjyOqzKfRCSmn6ApQwQXpuXxi7FC6uBCQn1e
	TpeNoyMu6eiIn5+UDs3+X0qbjhmBRnntNo57K/kKaQ3G871+TgffpXzXc/5/YaFnwjQAU9PJ9vC
	gUzw/eMXSng+1HVAugSj1mdQWGntPXoYaYnSLNGlaU+dCnsalFn/pHrSH4zJ1hUUrz2/yqqnna4
	heMfXJlP24DC2NPsQhscdMu5+M2j7TGSAPMJmnJSO87LPUEKtRXFZfObfR4q/uCYBzWMNrrfjkf
	OEtUPzev/noPNcFCxxhNw8nWrnhqSnOyaexRwwggjZGDH2u3BW4XWOw1xcy7L8GpMCkCTrBjqo4
	Kl4txvMdQhdMZk7tSeFXfXRz24PrCmqcbbEuHFO0d1i8BHBjHLt4l6pNb2BzXbeuTFTzUPsIU6R
	EAwRxpQ==
X-Received: by 2002:a17:90b:554c:b0:3b0:a1c6:95ae with SMTP id 98e67ed59e1d1-3b0afc77a41mr149377a91.31.1793815968204;
        Wed, 04 Nov 2026 10:12:48 -0800 (PST)
Received: from archlinux.tail3acd4.ts.net ([69.110.143.170])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0b31a3efasm78326a91.9.2026.11.04.10.12.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 10:12:47 -0800 (PST)
From: Vitali Lovich <vlovich@gmail.com>
To: linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Cc: brauner@kernel.org,
	viro@zeniv.linux.org.uk,
	jack@suse.cz,
	cem@kernel.org,
	djwong@kernel.org
Subject: [RFC PATCH 0/6] fs: range-based admission for generation-drained DIO
Date: Wed,  4 Nov 2026 10:12:40 -0800
Message-ID: <cover.1793815542.git.vlovich@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This patch series attempts to resolve a major source of contention between
concurrent readers and writers on the same inode, specifically when
those writers are punching holes in the file or gapped appends provided
that readers aren't overlapping these operations. There's some interface
changes I needed just for this initial exclusive IOLOCK removal because
DIO completion needs to cooperate and that lives in generic layers.

I believe the patch set to be complete and well-tested. The details
performance numbers are available in my earlier XFS post:
https://lore.kernel.org/linux-xfs/20261019182620.1527591-1-vlovich@gmail.com/T/#t
This patch series is identical, just widening the group.

Performance measurements on XFS available in the previous posting indicate
substantial read throughput + P99 latency improvements under concurrent
read/write contention with no negative impact to pure read scenarios.
Fixing all sources of contention even manages to improve pure read
workloads by ~2-5%.

Technical overview
------------------

To opt-in, the filesystem serializes compatible punch/gapped operations
with a per-inode drain mutex (only for filesystems that opt-in). It
publishes an exclusion range through a seqcount latch and flips the DIO
generation counter, capturing the outstanding request count. Completion of
old-generation requests retires that finite cohort to wake the drainer;
this is similar semantics to today with the exception that reads can
continue during this exclusive drain mutex hold provided they don't
overlap the range (the writer doesn't wait for them to drain either
since it's guaranteed they don't overlap). Overlapping reads queue up
behind the drain mutex.

Filesystems not using the new interface don't pay a cost.

Not all cases are eligible for this fast-path and those degrade to the old
exclusive IOLOCK + drain machinery, including DAX, realtime and unaligned
punches; the goal is to remain conservative for now while correctly solving
scaling bottlenecks for the common cases. I've tried to make sure there's
good additional test coverage for the new code paths.

I expect the same concept would also benefit ext4 and Btrfs which
similarly hold exclusive IOLOCKs; I have only double-checked that they
broadly follow the similar pattern but I'm not 100% sure if the
interface introduced here strictly applies the same to solve the same
scaling problem. I could imagine small adjustments being necessary. Like
XFS they have additional sources of contention present beyond what this
specific patch series solves and like XFS I expect filesystem-specific
optimizations will need to be written; it's possible there could be a
shared mechanism to encode some of this but I think all contention sources
for at least two or three filesystems need to be solved before generic
interfaces are codified.

In particular, I would appreciate feedback on:

* Whether the generic inode DIO accounting and iomap interfaces, with
  filesystem-private lifetime management through ->dio_drain_complete is
  correct.
* The generation/count encoding and ordering guarantees.
* The XFS lock/revalidation contract and whether my analysis is correct that
  ext4/Btrfs would benefit from the same interface or if different hooks
  are needed.

The base is 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4. The patch ordering is
generic accounting, iomap ownership, KUnit coverage, XFS admission, aligned
hole punching, then post-EOF zeroing.

Thanks,
Vitali

Vitali Lovich (6):
  fs: implement range-based generation-coordinated DIO draining
  iomap: support generation accounting and caller-registered DIO
  fs: add KUnit coverage for generation-based DIO draining
  xfs: add range-drain state and latch-based DIO admission
  xfs: use range-based DIO draining for aligned hole punches
  xfs: use range-based DIO draining for post-EOF zeroing

 Documentation/filesystems/locking.rst         |  89 +-
 Documentation/filesystems/vfs.rst             |  41 +
 fs/Kconfig                                    |  13 +
 fs/Makefile                                   |   1 +
 fs/ext4/file.c                                |   2 +-
 fs/inode.c                                    | 120 ++-
 fs/iomap/direct-io.c                          |  56 +-
 fs/tests/dio_drain_kunit.c                    | 893 ++++++++++++++++++
 fs/xfs/Kconfig                                |   9 +
 fs/xfs/Makefile                               |   2 +
 fs/xfs/tests/xfs_dio_test.c                   | 190 ++++
 fs/xfs/xfs_bmap_util.c                        |   9 +-
 fs/xfs/xfs_dio_test.h                         |  32 +
 fs/xfs/xfs_file.c                             | 357 ++++++-
 fs/xfs/xfs_icache.c                           |   2 +
 fs/xfs/xfs_inode.c                            |  10 +
 fs/xfs/xfs_inode.h                            |   1 +
 fs/xfs/xfs_iops.c                             |   9 +
 fs/xfs/xfs_reflink.c                          |   2 +
 fs/xfs/xfs_reflink.h                          |   2 +-
 fs/xfs/xfs_super.c                            |   2 +
 include/linux/fs.h                            |  97 +-
 include/linux/iomap.h                         |  60 +-
 .../litmus-tests/DIO-register-first.litmus    |  36 +
 tools/testing/selftests/filesystems/Makefile  |   6 +
 .../selftests/filesystems/xfs_dio_admission.c | 380 ++++++++
 .../selftests/filesystems/xfs_dio_drain.c     | 392 ++++++++
 .../selftests/filesystems/xfs_dio_remap.c     | 391 ++++++++
 28 files changed, 3116 insertions(+), 88 deletions(-)
 create mode 100644 fs/tests/dio_drain_kunit.c
 create mode 100644 fs/xfs/tests/xfs_dio_test.c
 create mode 100644 fs/xfs/xfs_dio_test.h
 create mode 100644 tools/memory-model/litmus-tests/DIO-register-first.litmus
 create mode 100644 tools/testing/selftests/filesystems/xfs_dio_admission.c
 create mode 100644 tools/testing/selftests/filesystems/xfs_dio_drain.c
 create mode 100644 tools/testing/selftests/filesystems/xfs_dio_remap.c


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.56.0

