Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=34.218.115.239
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793100447;
	b=UeM/YSDrrtZRcSrWTXfcNaeu7mVgpvor9ePKppruJJ8/w1hO8nCunfoYT/JbYkZsc1r1
	 P5tMUfGG3cdypVnga9J0k3uJ4kq566TcC4owkhL0oq9iQxzNd1GIeYovSxZMbcS3hXsbT
	 Or+vQQcZcZStknkJ40/e6x6bDMTnvZwb6iYTyvbks7BZtlBumzdX6etQBKJkxVI/QuQRV
	 Sd20ifQ2Je2QXGdsdo80Eo00quk+z49eh/DOzq1AOL3Z8ZBM1vyaYt6/7buBjdokX/oAn
	 T2vQaQLnkvR2VMGGagsaICbtbMRWHC7DGod2F5t1OY58VtGSmXQIkIiUJ5de6g9pR2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793100447;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:Received:X-Farcaster-Flow-ID:Received:Received:
	 From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 X-Originating-IP:X-ClientProxiedBy:Content-Type:
	 Content-Transfer-Encoding;
	bh=Zhv98/DMFgaVHqthgMh+5047LoW5P9chJ9n6zONF7MI=;
	b=UyNBbPbSQzfRYFNAGiPlDW3KWtTKUDsWMaT/EVjc3IPM1lc0/aHOlcyvWvWPnpfpwG7e
	 JF8sQ8dLysur/c2u0uHhUrAmJeK9ZaZt8WvyFzWh1aJuxxe20eFo8i1nILGqrzJF3j8hb
	 Rk14ngc9rUb+xZmEeXAaQTp5MoaRxlOBp3+AatpuhOsl7c1tvv1Bi/SrvrtZNq9FV0SH9
	 pARgzJy+zmFuWybtFJ0qw7bNHPsbrP4GhIp06dNVz6QsI5ooLSmvzi42c0WI1ycZHDO5V
	 Q5XRg7jWmgAjYpIIBV2IldV2CSvaVL0bJuJ0151csUW6oUvMyIoUqg9QdXpGorIivlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amazon.it;
	spf=pass smtp.mailfrom=amazon.it;
	dkim=pass header.d=amazon.it header.i=@amazon.it header.a=rsa-sha256 header.s=amazoncorp2 header.b=IltX4WvW;
	arc=none smtp.remote-ip=34.218.115.239
Received: from pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com [34.218.115.239])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125BE606A326;
	Tue, 27 Oct 2026 11:27:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 125BE606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.it header.i=@amazon.it header.a=rsa-sha256 header.s=amazoncorp2 header.b=IltX4WvW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1793100447; x=1824636447;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Zhv98/DMFgaVHqthgMh+5047LoW5P9chJ9n6zONF7MI=;
  b=IltX4WvW3H3ycZ7wCFSQqyDNe4Y+xWvxTgcIY+6vUBdGODne72kql64E
   WihUJbBgtJp3M2B9lqNPFMsfGlOCqnpDYTC5kZOsq+f/y190fx+64YDJT
   xovtX/K021EAEMTiQwragoHYdK8n/rA1/syQu7jayt3Px6oVD4VEBVioQ
   goIoLKz6greU3ZX+25qk4b8BVq+hGq805jv2LNIIdYQWFY5MsDUeYI0uC
   YfXYLO8olTtMzUzU1C39AHcLLWQtbJ05BHmEkwNKuJlNkzCQ33IWqFpN7
   Md/07FdddF3dSYrY4oBEA6jqVRjsx1ADkOcVtNaYn+Wga6g81t7lghlKf
   A==;
X-CSE-ConnectionGUID: cBtv+tbPSuaYbQZrAgM8pQ==
X-CSE-MsgGUID: fKISb3HxQf+nFB973LWUPA==
X-IronPort-AV: E=Sophos;i="6.27,181,1787011200"; 
   d="scan'208";a="32129592"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2026 11:27:24 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:27038]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.29.97:2525] with esmtp (Farcaster)
 id 11a1da28-eaf2-40b1-b48f-53da0e26ce8e; Tue, 27 Oct 2026 11:27:24 +0000 (UTC)
X-Farcaster-Flow-ID: 11a1da28-eaf2-40b1-b48f-53da0e26ce8e
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Tue, 27 Oct 2026 11:27:24 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Tue, 27 Oct 2026
 11:27:17 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <akpm@linux-foundation.org>, <linux-mm@kvack.org>
CC: <ryan.roberts@arm.com>, <abuehaze@amazon.com>, <alisaidi@amazon.com>,
	<blakgeof@amazon.com>, <dipietro.salvatore@gmail.com>, <rvvandan@amazon.com>,
	<viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <jack@suse.cz>,
	<linkinjeon@kernel.org>, <sj1557.seo@samsung.com>, <yuezhang.mo@sony.com>,
	<miklos@szeredi.hu>, <agruenba@redhat.com>, <djwong@kernel.org>,
	<hyc.lee@gmail.com>, <almaz.alexandrovich@paragon-software.com>,
	<cem@kernel.org>, <dlemoal@kernel.org>, <naohiro.aota@wdc.com>,
	<jth@kernel.org>, <willy@infradead.org>, <david@kernel.org>,
	<ljs@kernel.org>, <liam@infradead.org>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <ziy@nvidia.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <ritesh.list@gmail.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<exfat@lists.linux.dev>, <fuse-devel@lists.linux.dev>,
	<gfs2@lists.linux.dev>, <linux-xfs@vger.kernel.org>, <ntfs@lists.linux.dev>,
	<ntfs3@lists.linux.dev>
Subject: [PATCH 0/2] mm, iomap: account dirty at page granularity for per-block dirty folios
Date: Tue, 27 Oct 2026 11:27:00 +0000
Message-ID: <20261027112702.3747009-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWA003.ant.amazon.com (10.13.139.47) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Since iomap gained per-block dirty tracking, a large folio can be
partially dirty: struct iomap_folio_state records exactly which
blocks are dirty, and writeback only writes those ranges.  The mm
dirty accounting, however, still charges the whole folio even if a
single block is dirty (up to 512x over-accounting for a 2 MB folio
over 4 KB blocks).

balance_dirty_pages() then throttles writers against a number that
is unrelated to how much data actually needs writing back.  On
workloads that repeatedly dirty small ranges of large folios --
e.g. PostgreSQL, which writes mostly 8/16 KB pages -- dirty_thresh
is crossed and writers are throttled long before the real dirty data
justifies it.  On the benchmark below, run on v7.3-rc7, the
unpatched kernel charges ~159 TB of dirtied pages while writing
~6 TB to the array, a factor of 27; with this series the dirtied
pages charged match the data actually written.

This series makes iomap charge and discharge the mm dirty counters
per dirty page for folios that carry per-block dirty state, so a
partially dirty large folio is accounted for the dirty part only:

  - Patch 1 adds the mm infrastructure: an AS_DIRTY_PER_BLOCK
    mapping flag, an @accounted argument to __folio_mark_dirty()
    and __filemap_dirty_folio() to skip the generic per-folio
    charge, and an address_space_operations::accounted_dirty_pages()
    callback used by the discharge and migration paths instead of
    folio_nr_pages().  No filesystem opts in, so it is a no-op on
    its own.

  - Patch 2 makes iomap charge per dirty page from the per-block
    dirty bitmap and wires iomap_accounted_dirty_pages() into every
    iomap-based filesystem.

This was benchmarked with PostgreSQL using the pgbench simple-update
workload on v7.3-rc7.  Average throughput rises 46.8% (139.8k ->
205.2k tps) and run-to-run variability drops from a 23.60% to a
3.98% coefficient of variation: the worst iteration improves from
97.9k to 191.5k tps, while the best gains 8%, 199.4k -> 215.9k.

Ten iterations per kernel, same database and workload (tps):

  Kernel                     Avg     Min     Max      CV   iters   iters
                                                             1-5    6-10
  ______________________  ______  ______  ______  ______  ______  ______
  v7.3-rc7                139.8k   97.9k  199.4k  23.60%  164.4k  115.2k
  v7.3-rc7 + this series  205.2k  191.5k  215.9k   3.98%  200.1k  210.2k

On unpatched v7.3-rc7 the worst iteration lands ~51% below the best,
and throughput decays as the run progresses: iterations 6-10 average
30% below iterations 1-5.  With this series the decay is gone -- the
second half is similar to the first -- and the coefficient of
variation stays at 3.98%.

The over-accounting has existed since commit 4ce02c679722 ("iomap: Add
per-block dirty state tracking to improve performance"), merged in
v6.6, where the ifs bitmap started recording partial dirty state while
the mm counters kept charging whole folios.

The throughput collapse bisects to the v6.17 readahead series, first
bad commit c4602f9fa77f ("mm/readahead: store folio order in struct
file_ra_state"), which lets readahead stay at the largest folio order
once it has ramped up, so a single dirty block charges far more than
is written.  Patch 2 therefore carries:

  Fixes: 4ce02c679722 ("iomap: Add per-block dirty state tracking to improve performance")
  Cc: stable@vger.kernel.org # v6.17+

Test environment:

  Hardware:  2x AWS EC2 m8g.24xlarge
             (SUT with 12x 1TB io2, 32000 IOPS each, RAID0, XFS)
  OS:        AL2023
  Kernels:   v7.3-rc7, v7.3-rc7 + this series
  Database:  PostgreSQL 17 (with huge_pages=on)
  Workload:  pgbench simple-update
             1024 clients, 96 threads, 600s duration
             scale factor 8470, fillfactor=90, prepared protocol
  Runs:      10 iterations per configuration

How to replicate results:

This script starts two AWS EC2 m8g.24xlarge instances (SUT + driver),
then installs, loads and benchmarks PostgreSQL using the
repro-collection repository.  To run it:

  # Reproducer code (dirty-folio-regression branch):
  git clone -b dirty-folio-regression \
    https://github.com/aws/repro-collection.git ~/repro-collection

  # Concatenate patches 1 and 2 of this series, in order, into one file:
  cat 0001-*.patch 0002-*.patch > dirty-per-block.patch

  # Setup and start PostgreSQL benchmark:
  KERNEL_REPO="https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git" \
  KERNEL_BRANCH="v7.3-rc7" \
  ITERS=10 \
  PLACEMENT_GROUP="pg-test" \
  KEY="$HOME/.ssh/id_rsa" \
  KEYPAIR="<aws keypair>" \
  ./repros/repro-postgresql-dirty-folios/folio-reproduce.sh <benchmark name> \
  --patch="<path to dirty-per-block.patch>"

Salvatore Dipietro (2):
  mm: add infrastructure for per-dirty-page accounting
  mm, iomap: account dirty at page granularity for per-block dirty
    folios

 fs/buffer.c             |   4 +-
 fs/exfat/inode.c        |   1 +
 fs/fuse/file.c          |   1 +
 fs/gfs2/aops.c          |   1 +
 fs/iomap/buffered-io.c  | 167 ++++++++++++++++++++++++++++++++++++++--
 fs/ntfs/aops.c          |   2 +
 fs/ntfs3/inode.c        |   2 +
 fs/xfs/xfs_aops.c       |   1 +
 fs/zonefs/file.c        |   1 +
 include/linux/fs.h      |   7 ++
 include/linux/iomap.h   |   1 +
 include/linux/pagemap.h |  20 ++++-
 mm/internal.h           |   3 +
 mm/migrate.c            |  17 +++-
 mm/page-writeback.c     |  91 +++++++++++++++++-----
 15 files changed, 286 insertions(+), 33 deletions(-)


base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
2.50.1




AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico



