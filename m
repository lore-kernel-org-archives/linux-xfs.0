Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792434386;
	b=Mm3TR11u9TnHp9oWUDKJcAe18Rs3ry3CUgWVwW8M5rkZKR+Cv4oEMzJZ44uFMB11wgS5
	 e7XkwNK3usR0s4xAj0ByqFPZBVZHak4f7g0WrFwbA81eDYAFH4bZCqhSrSCKTygJVIBF9
	 peujs2OPbmaozuOEAOWdz8Wj8zSD+l1ervz/Dkcnov3pOeQjoXtZuOyEOO/FT/eo1iCNL
	 TpufIG4Nn4U+s6XG3XC8y5gWGpU55okjfR+boSBkzV2LVdBryX/kh3CtXb0/wB7nx/ajF
	 k14dxuPv8a3zIJtXRPQgnzfpi72OGA5bYtFB/fG97mZWQM6Gyl6MGLU1AVhiIBKiNpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792434386;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=Gfzqq+Mihcd4W76FO9QW4+X9+QsynA9Rxb0dqBSC9Uc=;
	b=FWKQZMrP6/q6W3iwdwVtztpe3UUt0LWDJ2wywIfZqcpUCsDqs+CPpfr4DjdtueWgs3OY
	 kO5iEbpDrDKn/c9SAcmcW7OA2bLLqwlAiBG/Kc7NpXAcQ5EP3Z03EVEE6oBuMW1xvm6ij
	 JqE6HMPlBXksIYGMhHk8QAVm8gyn0qRyRZQX5k+tUN2fuSpimQKzX5oyzaaAjMQAUs1/c
	 Ia3bpGIwLQ2hGK0MWcCTbP7PocHecLoVKn0P5KxwDYiQDqH/HLEvCsImz5vXX/a1rhghp
	 pbjh/RG/VQYuXtr3Xvs7OyiJFCt7NCeSJcgZpb2zKPtBPuI8QbrVH+H6WmOz8ci9D4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=cz1dfPSx;
	arc=none smtp.remote-ip=209.85.214.171
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F6C606A320
	for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2026 18:26:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86F6C606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=cz1dfPSx
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2e8ad5b31c7so13547865ad.3
        for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2026 11:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792434385; x=1793039185; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Gfzqq+Mihcd4W76FO9QW4+X9+QsynA9Rxb0dqBSC9Uc=;
        b=cz1dfPSxYB7WMTSPVLuOlH7LkElDiwod+++J2VpnAwGplFzLmV719t5VDfXS3x6Sn3
         jsZGoXX5S8eNXFaQI98GqTusPyJRBIwgCHm32IGNDza0EdSARIW2TO/fw24e1jKlV9Nj
         YgEnij2sH0PZ3ZRdfLOS8kS4cxQPEUxC/sLuOEmJT9ei2NCueUu6+cXXDKg0UApFbaON
         1MvWS6CC2ONpi2lr0ve56YIAPnaUorRuP/fTrteUPcQuHH+A5XUqxA/VBqIbiDoXiUNM
         BQ1USa8zYh9aXR+2pk8nke2alt2j7Czvy1NdPkT8JKdrH1kNbxxxkaGrpBNPfpTBE6yJ
         lmBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792434385; x=1793039185;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Gfzqq+Mihcd4W76FO9QW4+X9+QsynA9Rxb0dqBSC9Uc=;
        b=NIkyb4dFQBZgR/O2JdjS9fnlDtLswxXMr+gV9+OFx7J65TRLich0sJwvKTV0uYR59h
         SbvcbnoknbY2Bk0FrCy5SQlsmjD4cFeFwcawkFp/0R785pfsstRqi5ujRIrnyQgfKG6g
         1kAxrrAuW1cCHxcVcz5KT9PHjBPHIAVifEu/BZheYrByRM9bNZUSAKq1GmVv6YWz70wM
         xRkf0hWkkD035ZOLT3kyQCQgWsY2/4y5pX1Kas+B2Ep7sP+L1qfivIKARy8VyJPkOmHY
         QmO1QOo/fjexu3or+6G3PVOLtDbAAhcwnpiNg8P6sFr8HQGtGXHitUl6mXwsqqeHcdp2
         ifFQ==
X-Gm-Message-State: AFq9FYIeUhQR0HP/b375qmSQz6Gwv0/wJLu2NeljQliOm8aiDW7MFOL7
	dUO+EPwxll9uzm2WP9BpU4h9+zh5wMhfXMLZ4T4aFMGeNUI6OE+RXrn0NKCzB1aM
X-Gm-Gg: AYBFou0V+F7bsgwE7WFnviVordWZS4Q3Oq5/CaRT4cO8fZX1bmnIucxOp+eU/ahQEAu
	u+UqBLpcblLNfodv8jYf7xA5x2ty1q2wiTMJqQv8RU2MkTaZ6y3eeOOoGFuUNDG6/SyFpa43kXu
	cH3Xkx9FTBHzyZ3kSXvGWLa/XfJSrXSx26vQko2nulBEG7Fi/NkTj4NezbVY+fyqr0+Nuvly2Gf
	93z9b8NlUKdGJd6ACHJ+NLU3gl5rPpIM7IEZuP8M0rg9n5rAllc5wvqg6A/WmMhmQVJoxoHmqYT
	cGWK6xUfRmvm15WftyiVmamzGQgSnTBKcXNf5Uwme4H4KDZAZaPYwc+uGe6YEKYX876mPEd7S9F
	tk9mZgVZPKSJUx6r5zKKa6UXVFW/FYpZenkOgd8bGPWfgD92xKZYXSeo/qAHtvxoR32S4NvQj6Y
	ZrZ8g7JEHHJNS6STZRBHUMTI84IRpP4+MVT6r6fRl8tcGnghNSfZXfGsZJtL8dQ74ai9KA/7OnC
	UnMh4MiHQwWWJ1wbpkg/1VTGK785HHJwuZ7IlqkxQik2k3p
X-Received: by 2002:a17:902:e948:b0:2e9:851a:7188 with SMTP id d9443c01a7336-2e9a6a0c879mr76483025ad.23.1792434384575;
        Mon, 19 Oct 2026 11:26:24 -0700 (PDT)
Received: from archlinux.tail3acd4.ts.net ([69.110.143.170])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea1517e7cfsm4156375ad.58.2026.10.19.11.26.23
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 11:26:23 -0700 (PDT)
From: Vitali Lovich <vlovich@gmail.com>
To: linux-xfs@vger.kernel.org
Subject: [RFC PATCH v1 0/6] fs/iomap/xfs: generation-based DIO range draining
Date: Mon, 19 Oct 2026 11:26:14 -0700
Message-ID: <20261019182620.1527591-1-vlovich@gmail.com>
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

The core problem this patch series tries to address is how to keep
read IOPS up and read latency down in the face of concurrent (but
non-overlapping) hole punching or writes past the EOF with gaps.

Previous ideas have explored the idea of using range tracking for
operations. The downside is that it has a small but measurable overhead
for IOPs throughput, increased CPU usage, and more memory usage. Range
tracking also enables more concurrency of certain write operations of
unrelated ranges.

The core idea of this patch series is instead to ignore trying to
support hole punches of unrelated regions. Instead, hole punching (and
writes past the end with gaps) remain exclusive of each other and
update a read-optimized data structure to contain the range they're
operating on. Reads then check against this range on submission to know
if they need to defer themselves against a pending hole punch. This
flips the problem and side-steps the need for interval tracking,
resulting in no overhead for pure-read scenarios.

As the data at the end shows, this patch series solves a good chunk of
the read IOPs and latency performance under concurrent hole punches
while showing no impact on pure read workloads. There remain two
additional sources of contention that show up; the exclusive metadata
lock (extent mapping + modified timestamps when not using lazytime) and
the ili_lock which is unnecessarily checked for reads. I have prototyped
optimizing the extent metadata mapping and it shows read IOPs and read
latency approach the uncontended case even with a large number of
concurrent hole punches. It also significantly improves the "reduced"
hole punching performance the numbers below show (I explain below why
it's a phantom reduction and not a bug in the patch set). Fixing the
ili_lock contention on top of this should largely eliminate the
remaining contention bottleneck between readers and hole punching.

I'll also note that even in the uncontended read cases, this performs
slightly better in pure reads and, combined with the metadata mapping
contention improvement, results in a ~2-6% speedup for read-only
workloads; this patchset by itself is more modest for pure read workload
wins.

The specific mechanism this patch series implements is:
* Introduces a new draining lock that hole punching and writes past
  end need to acquire. This ensures that concurrent hole punching, as
  currently, can only happen one at a time. This restriction is not
  lifted by this patchset.
* Once the lock is acquired, the drainer updates a seqcount_latch_t
  protected exclusion range and reading counter with the number of
  currently outstanding DIOs acts as the natural barrier. We use a
  single bit generation counter to dilineate DIO cohorts that may have
  not observed the installed latch and those that definitely did. The
  former on completion will notice the writer is waiting for draining
  and they count off and know when to wake the writer that the OPs it's
  waiting to drain have completed.
* The read path checks the seqcount_latch_t state cheaply and safely so
  that it knows upon start which drain generation it's part of and
  which range to potentially check on. Conflicting rights take the slow
  path and will wait for the already started draining - the head of line
  blocking that occurs here is no different than the current status quo,
  except only overlapping reads are impacted.

The i_dio_counter acts as the barrier mechanism for the latch snapshot
protocol. This upgrades the relaxed increment of the counter on
registration into fully ordered. While I confirmed this has no
observable impact on pure read workloads, I don't have access to a
weakly ordered machine with huge concurrency to confirm it doesn't have
an impact on less concurrency. The SeqCst consistency in this patch set
could be optimized to use Acquire/Release instead, but I decided to be a
bit more conservative here.

Patches 1-3 add VFS accounting, iomap ownership, documentation, a focused
LKMM litmus test, and KUnit coverage. Patches 4-6 integrate admission and
the two consumers in XFS. The ext4 change only adapts the iomap helper
signature.

KUnit, two CPUs: 5 passed, 0 failed, 0 skipped
LKMM, herd7 7.58: Forbidden outcome Never
XFS debug + lockdep fstests: 16 passed, 0 failed, 0 skipped

Performance measurements gathered as requested in:
https://lore.kernel.org/linux-xfs/atF7xJlbck-xA1G3@dread/T/#m203f6ae3899e7061afc847a45f72abd9d257dfef

Workload is number of concurrent readers + writers. Hole punches column
is the workers attempting to hit 1000/s and the effective number
actually reached. All IOPs are hitting the same inode. Read IOPs are in
millions and P99.9 is in milliseconds.

kernel    | readers/workers | punches/s | read IOPS | read P99.9 (ms)
----------+-----------------+-----------+-----------+----------------
baseline  |       1/0       |      0.00 |   592,088 |           0.214
latch     |       1/0       |      0.00 |   584,266 |           0.189
baseline  |       1/1       |    989.44 |   400,052 |           0.758
latch     |       1/1       |    790.79 |   522,255 |           0.436
baseline  |       1/8       |    879.33 |    32,103 |           5.603
latch     |       1/8       |    768.11 |   261,712 |           1.221
baseline  |       1/32      |    998.67 |    15,721 |          16.318
latch     |       1/32      |    704.56 |   256,991 |           1.237
baseline  |       1/64      |    999.81 |    25,364 |          12.517
latch     |       1/64      |    711.11 |   256,288 |           1.221
----------+-----------------+-----------+-----------+----------------
baseline  |       8/0       |      0.00 | 2,159,746 |           0.416
latch     |       8/0       |      0.00 | 2,142,864 |           0.387
baseline  |       8/1       |    300.72 |   715,545 |           2.867
latch     |       8/1       |    131.08 | 1,302,691 |           4.047
baseline  |       8/8       |    744.09 |   185,504 |           6.193
latch     |       8/8       |    204.85 |   594,782 |           4.014
baseline  |       8/32      |    999.41 |    66,411 |          15.663
latch     |       8/32      |    205.75 |   594,228 |           4.014
baseline  |       8/64      |    940.88 |    22,154 |          43.778
latch     |       8/64      |    203.97 |   593,788 |           4.014
----------+-----------------+-----------+-----------+----------------
baseline  |      32/0       |      0.00 | 2,467,761 |           1.221
latch     |      32/0       |      0.00 | 2,497,401 |           0.913
baseline  |      32/1       |    129.01 |   653,812 |           6.914
latch     |      32/1       |     65.50 | 1,112,291 |           6.783
baseline  |      32/8       |    507.07 |   347,173 |          10.289
latch     |      32/8       |     89.23 |   750,753 |           9.765
baseline  |      32/32      |    617.12 |   112,667 |          25.559
latch     |      32/32      |     88.54 |   751,453 |           9.765
baseline  |      32/64      |    821.00 |    70,012 |          42.205
latch     |      32/64      |     88.81 |   750,884 |           9.765
----------+-----------------+-----------+-----------+----------------
baseline  |      64/0       |      0.00 | 2,511,819 |           1.761
latch     |      64/0       |      0.00 | 2,520,544 |           1.761
latch+fix |      64/0       |      0.00 | 2,682,546 |           2.245
baseline  |      64/1       |     65.46 |   677,507 |          13.042
latch     |      64/1       |     39.78 | 1,036,213 |          10.682
latch+fix |      64/1       |    690.05 | 2,619,882 |           2.277
baseline  |      64/8       |    326.80 |   383,964 |          18.481
latch     |      64/8       |     48.12 |   801,694 |          18.481
latch+fix |      64/8       |    539.84 | 2,506,797 |           3.785
baseline  |      64/32      |    472.71 |   142,776 |          39.059
latch     |      64/32      |     48.04 |   800,569 |          18.481
latch+fix |      64/32      |    526.69 | 2,505,012 |           3.785
baseline  |      64/64      |    659.57 |    86,426 |          63.701
latch     |      64/64      |     47.92 |   800,364 |          18.481
latch+fix |      64/64      |    541.89 | 2,508,080 |           3.752
----------+-----------------+-----------+-----------+----------------
baseline  |     128/0       |      0.00 | 2,703,411 |           3.195
latch     |     128/0       |      0.00 | 2,738,430 |           3.129
latch+fix |     128/0       |      0.00 | 2,780,706 |           3.097
baseline  |     128/1       |     35.24 |   698,842 |          25.035
latch     |     128/1       |     21.83 | 1,003,072 |          18.743
latch+fix |     128/1       |    349.77 | 2,612,422 |          47.972
baseline  |     128/8       |    233.86 |   525,114 |          25.559
latch     |     128/8       |     26.26 |   857,379 |          33.817
latch+fix |     128/8       |    324.93 | 2,549,251 |          52.167
baseline  |     128/32      |    468.56 |   279,933 |          42.729
latch     |     128/32      |     26.04 |   855,151 |          34.341
latch+fix |     128/32      |    396.54 | 2,557,483 |           5.341
baseline  |     128/64      |    500.56 |   140,166 |          80.216
latch     |     128/64      |     26.13 |   853,051 |          34.341
latch+fix |     128/64      |    363.48 | 2,561,624 |          35.914

As I call out above, punch throughput seems to crash / not scale as well
as it does today. This isn't some bug in the patch set. Instead, what
happens is that the increased read IOPs that don't block on the I/O lock
causes more contention on the metadata lock and in this case the writer
loses. If you kept read IOPs artificially lower at the throughput we
could manage before, then hole punch IOPs would rise. So this patch set
on its own could result in regression of hole punch IOPs performance in
the face of a lot of concurrent readers on the same inode. This is only
intended as a temporary state of affairs though. Once this approach is
approved, I'll present how the metadata extent mapping contention could
be lifted. When that is done, hole punching performance under concurrent
read IOPs largely restores, read IOPs are almost identical with and
without hole punching, and read P99.9 latency is similarly reduced
further to the uncontended read case. Perf profiles and tracing point to
the ili_lock contention as the final area to cut this gap further.

Tradeoffs this patch series introduces:
* xfs inode struct grows by 1 cache line because there's no padding
  available to absorb the pointer we add. The callbacks used in the FS
  layer ensure only filesystems opting into this new codepath pay for
  that pointer.
* Hole punch throughput can suffer under heavier concurrent read
  contention that is now possible. This is fixable.

Vitali Lovich (6):
  fs: implement range-based generation-coordinated DIO draining
  iomap: support generation accounting and caller-registered DIO
  fs: add KUnit coverage for generation-based DIO draining
  xfs: add range-drain state and latch-based DIO admission
  xfs: use range-based DIO draining for aligned hole punches
  xfs: use range-based DIO draining for post-EOF zeroing

 Documentation/filesystems/locking.rst         |  89 ++--
 Documentation/filesystems/vfs.rst             |  41 ++
 fs/Kconfig                                    |  13 +
 fs/Makefile                                   |   1 +
 fs/ext4/file.c                                |   2 +-
 fs/inode.c                                    | 120 +++++-
 fs/iomap/direct-io.c                          |  36 +-
 fs/tests/dio_drain_kunit.c                    | 393 ++++++++++++++++++
 fs/xfs/xfs_bmap_util.c                        |   9 +-
 fs/xfs/xfs_file.c                             | 343 +++++++++++++--
 fs/xfs/xfs_icache.c                           |   2 +
 fs/xfs/xfs_inode.c                            |  10 +
 fs/xfs/xfs_inode.h                            |   1 +
 fs/xfs/xfs_iops.c                             |   9 +
 fs/xfs/xfs_reflink.h                          |   2 +-
 include/linux/fs.h                            |  97 ++++-
 include/linux/iomap.h                         |  56 ++-
 .../litmus-tests/DIO-register-first.litmus    |  36 ++
 18 files changed, 1172 insertions(+), 88 deletions(-)
 create mode 100644 fs/tests/dio_drain_kunit.c
 create mode 100644 tools/memory-model/litmus-tests/DIO-register-first.litmus


base-commit: 0fcb05b72344f40806cbe810de8872f1698bf053
-- 
2.56.0

