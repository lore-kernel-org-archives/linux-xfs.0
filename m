Received: from pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.12.53.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228CA30BBB6;
	Fri,  3 Apr 2026 19:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.12.53.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775244977; cv=none; b=JN/5j6m1S7nfJ0sXBXaENYSLSkG7KxCMWkictAEpVGTS6+V975jSNwBkfHjfEKHrNIbrxTMuqzkkBpoqOAi2w/upyUPw58lSwnGBi3TiChwz7LNzSRfJQ1xJebQjCqSOoxtxOk5g5YjZ2nLcNUP5ZFwSDYfH71UePSjH3RuWsn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775244977; c=relaxed/simple;
	bh=dxJO5YVE/OPjRgddTX1KjW/X8U+yr0JUjdzgbXw0AAw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UtBZST8hRqCKF8HUddCmRLjvLmuQ0ek8vYc4zN13ht7+KWdv8Zp3DpfeJ6yahrLwhPSZVSDQj+kpbktLlA1eIEphIewHuNV+wdGJNbBPjeyzd4GRQ+FKXcWBhXo4mi1Ft/tOEEfbPEytNmfGqLxKpBfrW1KcgQFd0NULtyB9yN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it; spf=pass smtp.mailfrom=amazon.it; dkim=pass (2048-bit key) header.d=amazon.it header.i=@amazon.it header.b=AnPqCQSH; arc=none smtp.client-ip=52.12.53.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.it header.i=@amazon.it header.b="AnPqCQSH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1775244976; x=1806780976;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mpl71prcbBB4KcjOnt3ORGNSWkJRRbWjFiSgjofalCc=;
  b=AnPqCQSHlH2chK0SEUZvWSuuy2vlnEIDqAWOMWVZZhG1HU8EkcpkO5BU
   ae9paoUlmCaoLb/PfJy/yrhVIz1mBSE+BWSqlLEcF8yHgO3bgz4vb1Ho4
   JctgoYHAc3NKPo4onlADNiL6jQxqGGgWDJU+Fp9Qc3t9nnL/JRicZvF1x
   Bi98LooDaZOEOF47CO6gT2Y0B4HDXpFE/wlLutE0Bjw2PYNsOD7fjR8YT
   EzJ3ki54lT6/xbsr39SOXO2W6gRFyYuQ2mhnnWovwqYOrB00SFCnLTqkX
   ysgRbK2UmvRSawFGRw5babJgCgHdCRT/hJl5dEwoaRcmrfn5FuRPyKAAL
   A==;
X-CSE-ConnectionGUID: XQ8s/7tLQL+BEbvPctpUKQ==
X-CSE-MsgGUID: o/kmG15oS4i/4Q+VRSCWsg==
X-IronPort-AV: E=Sophos;i="6.23,158,1770595200"; 
   d="scan'208";a="16387910"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 19:36:15 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:28742]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.60.23:2525] with esmtp (Farcaster)
 id c594b784-a88c-4527-a05b-cf0f1180c89c; Fri, 3 Apr 2026 19:36:15 +0000 (UTC)
X-Farcaster-Flow-ID: c594b784-a88c-4527-a05b-cf0f1180c89c
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 3 Apr 2026 19:36:13 +0000
Received: from dev-dsk-dipiets-2b-fa1865ee.us-west-2.amazon.com
 (172.22.139.101) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Fri, 3 Apr 2026
 19:36:13 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <linux-kernel@vger.kernel.org>
CC: <dipiets@amazon.it>, <alisaidi@amazon.com>, <blakgeof@amazon.com>,
	<abuehaze@amazon.de>, <dipietro.salvatore@gmail.com>, <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>, "Darrick J. Wong"
	<djwong@kernel.org>, <linux-xfs@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>
Subject: [PATCH 0/1] iomap: avoid compaction for costly folio order allocation
Date: Fri, 3 Apr 2026 19:35:33 +0000
Message-ID: <20260403193535.9970-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D039UWA004.ant.amazon.com (10.13.139.68) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

We are reporting a throughput regression on PostgreSQL pgbench
(simple-update) on arm64 caused by commit 5d8edfb900d5 ("iomap:
Copy larger chunks from userspace") introduced in v6.6-rc1.

The regression manifests as a 0.75x throughput drop on a pgbench
simple-update workload with 1024 clients on a 96-vCPU arm64
system. When memory is even slightly fragmented, each failed
high-order allocation enters into __alloc_pages_slowpath() which
runs 2 memory compactions and drain_all_pages(), forcing all
vCPUs to release their pages. This is done multiple times, one
for each order (up to 6), until the allocation succeeds.

The patch makes costly-order folio allocations in the iomap
buffered write path purely opportunistic -- no direct reclaim,
no compaction, no drain_all_pages().

Combined with the separate PREEMPT_LAZY regression [1], the
total impact is a 2.87x throughput and latency loss.

1. Test environment
___________________

  Hardware:  1x AWS EC2 m8g.24xlarge
             (12x 1TB IO2 32000 iops RAID0 XFS)
  OS:        AL2023 (ami-03a8d3251f401ffca)
  Kernel:    next-20260331
  Database:  PostgreSQL 17
  Workload:  pgbench simple-update
             1024 clients, 96 threads, 1200s duration
             scale factor 8470, fillfactor=90, prepared protocol

2. Results
__________

  Config                 Run1       Run2       Run3       Avg         x
  _____________________  _________  _________  _________  __________  ____
  baseline                47242.39   53369.18   51644.29    50751.96  1.00
  iomap patch             69305.92   66994.08   64603.33    66967.78  1.32
  preempt-none [1]        92906.62  103976.03   98814.94    98565.86  1.94
  iomap+preempt-none[1]  145904.53  146470.95  144728.91   145701.46  2.87

3. Reproduction
_______________

On the AWS EC2 m8g.24xlarge, install and run the PostgreSQL
database using the repro-collection repository like:

  # Reproducer code:
  git clone https://github.com/aws/repro-collection.git ~/repro-collection

  # Setup and start PostgreSQL server in terminal 1:
  ~/repro-collection/run.sh postgresql SUT --ldg=127.0.0.1

  # Run pgbench load generator in terminal 2:
  PGBENCH_SCALE=8470 \
  PGBENCH_INIT_EXTRA_ARGS="--fillfactor=90" \
  PGBENCH_CLIENTS=1024 \
  PGBENCH_THREADS=96 \
  PGBENCH_DURATION=1200 \
  PGBENCH_BUILTIN=simple-update \
  PGBENCH_PROTOCOL=prepared \
  ~/repro-collection/run.sh postgresql LDG --sut=127.0.0.1

[1] https://lore.kernel.org/all/20260403191942.21410-1-dipiets@amazon.it/T/#t

Salvatore Dipietro (1):
  iomap: avoid compaction for costly folio order allocation

 fs/iomap/buffered-io.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)


base-commit: 9147566d801602c9e7fc7f85e989735735bf38ba
-- 
2.50.1 (Apple Git-155)




AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico



