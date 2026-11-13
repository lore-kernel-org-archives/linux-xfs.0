Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=52.26.1.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585072;
	b=DypaR7+DUI0aujEunej1lGGUbIyD0vAcrvtoN+73hmTC/P+WPOopg5asT4tKnBgeN2jx
	 318VyUs3gZorL1O9CNl1ti6WOIJPZymOEETZJJznsljtgxONc03Ek4gawrgkU6bH0dmGC
	 3cNuxsSVeUCbJQFufUgG8fILIe5cqj8S9n7yvXpMylQshJlUrYB2UIZ4JCijH8gBMSBem
	 I+So1LnM3qc0TEH1fYzdsL38HK/PARpKZCyBw3/EvF4YG3vGtQxjutEYyOz+9jcCn8fqK
	 ZGuwLpK00cBi7FmmvD6Ez+8NkOUrkn+050QydRqGesSH9EzlV31ZgBsWJLC8qZdjrrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585072;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:Received:X-Farcaster-Flow-ID:Received:Received:
	 From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:X-Originating-IP:X-ClientProxiedBy:Content-Type:
	 Content-Transfer-Encoding;
	bh=ttqAfDxUfq10cMBrxuj6822Y6w4QHwk60wHnUr65sec=;
	b=ZWSSbdP1EbVTI9KVE47zCO8nRHV8U/NTla7QPlFUclmk0CwNdqu3fJiELMh26PJLu5BC
	 r+rtHD/ALks+SJwMgw27Wg04prtt3Jdttxnfp0aK5ah04Yn0qsIqCiLo4R2JW4DS0RAW1
	 Sk7yCQIGsSTQDs6v288E5YMDDBYR+02Vk3IsP8au8IkfA5OWOV34U9jHBud2fjnK+Gb6p
	 OxMec+M6BoeGt4lY5H9e7wNoZ5kPCDMHErqmdwfKt9Xbftwhr2wvnF8MH8TzXt7LkgPEI
	 Lkiekn5ZjPOzvfpetUP9PtnNHgUU9lpKQEBk68nhnGO/+aBV6jpN2KaqAG3KhGIReiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amazon.com;
	spf=pass smtp.mailfrom=amazon.it;
	dkim=pass header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=A2YWGP1F;
	arc=none smtp.remote-ip=52.26.1.71
Received: from pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.26.1.71])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB69606A330;
	Fri, 13 Nov 2026 15:51:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2EB69606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=A2YWGP1F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794585065; x=1826121065;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ttqAfDxUfq10cMBrxuj6822Y6w4QHwk60wHnUr65sec=;
  b=A2YWGP1Fpk2ennvvIVzm+5gKtGrHfZqwO3k6Fac3QUJHHaNGlbsKOe82
   ZZT5fkrCxezz3MVrW43yrWb+Thpo+s410hHAHtwrwQiXvwIMWaQdrhI9B
   ud6B5Er5bzUSFGIOKZscALODbNt+OsQLk8ngsDzgwIg//uYfWcp5lxkQS
   t4/foga8HVDruCDogUljFI93EI6AzEX3ugqCqmXbZCPv5LDIfCGi1xMD0
   Jp6EUnskndoCjsiyMUi45J+zod9wAL4o653QwfVWt5HvBj+pBjyG3qBsR
   6bnGlnGZoHjLk1m2hj3Z7BXb74iDvQ1p3vdKDPYSlgNgEILjNZc5ogMwo
   A==;
X-CSE-ConnectionGUID: mEzGvvEbQ/eZvW+yJkWFSA==
X-CSE-MsgGUID: 726PIJdYTv201+SXclxh0w==
X-IronPort-AV: E=Sophos;i="6.27,211,1787011200"; 
   d="scan'208";a="33924868"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 15:50:57 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:27372]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.10.61:2525] with esmtp (Farcaster)
 id 06ade6d6-3062-4e83-9e5f-28bb5c92f1e7; Fri, 13 Nov 2026 15:50:57 +0000 (UTC)
X-Farcaster-Flow-ID: 06ade6d6-3062-4e83-9e5f-28bb5c92f1e7
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 13 Nov 2026 15:50:55 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Fri, 13 Nov 2026
 15:50:49 +0000
From: Salvatore Dipietro <dipiets@amazon.com>
To: <jack@suse.cz>
CC: <abuehaze@amazon.com>, <agruenba@redhat.com>, <akpm@linux-foundation.org>,
	<alisaidi@amazon.com>, <almaz.alexandrovich@paragon-software.com>,
	<apopple@nvidia.com>, <blakgeof@amazon.com>, <brauner@kernel.org>,
	<byungchul@sk.com>, <cem@kernel.org>, <david@kernel.org>,
	<dipietro.salvatore@gmail.com>, <dipiets@amazon.it>, <djwong@kernel.org>,
	<dlemoal@kernel.org>, <exfat@lists.linux.dev>, <fuse-devel@lists.linux.dev>,
	<gfs2@lists.linux.dev>, <gourry@gourry.net>, <hyc.lee@gmail.com>,
	<joshua.hahnjy@gmail.com>, <jth@kernel.org>, <liam@infradead.org>,
	<linkinjeon@kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-xfs@vger.kernel.org>, <ljs@kernel.org>, <matthew.brost@intel.com>,
	<mhocko@suse.com>, <miklos@szeredi.hu>, <naohiro.aota@wdc.com>,
	<ntfs3@lists.linux.dev>, <ntfs@lists.linux.dev>, <pfalcato@suse.de>,
	<rakie.kim@sk.com>, <ritesh.list@gmail.com>, <rppt@kernel.org>,
	<rvvandan@amazon.com>, <ryan.roberts@arm.com>, <sj1557.seo@samsung.com>,
	<surenb@google.com>, <vbabka@kernel.org>, <viro@zeniv.linux.org.uk>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>,
	<yuezhang.mo@sony.com>, <ziy@nvidia.com>, <kirill@shutemov.name>,
	<dgc@kernel.org>
Subject: Re: [PATCH 0/2] mm, iomap: account dirty at page granularity for per-block dirty folios
Date: Fri, 13 Nov 2026 15:50:15 +0000
Message-ID: <20261113155015.516481-1-dipiets@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <mcskrz2zbav5r3xtlwqytyotgjcmmi3wapeibkqornuhb3qp5y@qk22j77kvkqx>
References: <mcskrz2zbav5r3xtlwqytyotgjcmmi3wapeibkqornuhb3qp5y@qk22j77kvkqx>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWA001.ant.amazon.com (10.13.139.88) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi all,

Thanks Jan, Pedro, Dave, David and Kiryl for the feedback.

Following Dave's question about how PostgreSQL gets large folios on
files it writes 8 KiB at a time, we looked deeper and found a
reproducer that needs only fio and a single disk.

What happens:

  1. A buffered sequential read (VACUUM, a backup, a scan) builds large
     folios through readahead.  They stay large in the page cache until
     they are evicted.
  2. The first small write into one of these clean folios charges the
     whole folio as dirty: a 4 KiB write into a 256 KiB folio charges
     256 KiB, while writeback only writes the dirty 4 KiB.
  3. With random writes, most writes land in a different clean folio,
     so the dirty count reaches the limits with little real data.
     balance_dirty_pages() then throttles the writers, and they end up
     paced by how many folios writeback can clean per second rather
     than by the bytes to write.

Reproducer: XFS on one EBS gp3 volume (3000 IOPS), m8g.8xlarge
(32 CPUs, 128 GiB), default read_ahead_kb=128. fio's 1 MiB reads grow
the readahead window up to the device's max_sectors_kb (256 KiB), so
the read builds 256 KiB folios.

  ; create.fio: 16 x 3 GiB files, direct I/O so nothing is cached
  [global]
  directory=/mnt/xfs/fio
  filename_format=f.$jobnum
  size=3072m
  numjobs=16
  group_reporting=1
  [create]
  rw=write
  bs=1m
  direct=1
  ioengine=libaio
  iodepth=16

  ; load.fio: buffered sequential read; builds the large folios
  [global]
  directory=/mnt/xfs/fio
  filename_format=f.$jobnum
  size=3072m
  numjobs=16
  group_reporting=1
  [load]
  rw=read
  bs=1m
  direct=0
  ioengine=psync

  ; randwrite.fio: random 4 KiB buffered writes, 32 x 312 = ~10k IOPS
  ; invalidate=0 keeps the cached folios when fio opens the files
  [randwrite]
  directory=/mnt/xfs/fio
  filename=f.0:f.1:f.2:f.3:f.4:f.5:f.6:f.7:f.8:f.9:f.10:f.11:f.12:f.13:f.14:f.15
  rw=randwrite
  bs=4k
  direct=0
  ioengine=psync
  invalidate=0
  numjobs=32
  rate_iops=312
  time_based=1
  runtime=120
  group_reporting=1

To reproduce it, run (as root):

  fio create.fio
  sync; echo 3 > /proc/sys/vm/drop_caches
  fio load.fio          # skip this step for the control run
  fio randwrite.fio

fio asks for ~10k write IOPS, more than the volume's 3000, so dirty
data builds up in both runs.  In the control run (no load step) each
4 KiB write creates a 4 KiB folio: after 120 s only 3.3G is dirty,
below the 12.2G background threshold, and nothing is throttled.  After
the load step the same writes land in 256 KiB folios, and each write
into a clean folio is charged 256 KiB: the dirty count passes the
background threshold after 6 s and writers are throttled from 13 s.

Results on v7.4-rc2, one run per kernel, each on a fresh instance.
Writer sleep is the total balance_dirty_pages() pause time over the
32 writers during the 120 s write phase:

                         write   p99 / max   writer   max    folio
                          IOPS     lat ms    sleep s  dirty  size
  baseline, control      9,984  0.01 / 0.30      0    3.3G    -
  baseline               4,061    60 / 160     179   23.5G   256K
  v1 (this series)       9,984  0.01 / 0.67      0    3.6G   256K
  max order cap 64K      7,071    50 / 280      73   22.3G    64K
  max order cap 16K      9,984  0.02 / 0.05      0   11.9G    16K
  split on write         9,984  0.02 / 0.17      0    3.6G   256K
  evict on write         9,984  0.03 / 0.19      0    3.3G   256K
  POSIX_FADV_RANDOM      9,984  0.02 / 0.05      0    3.3G     4K

The control run gave 9,984 IOPS and max latency up to 0.30 ms on every
kernel.

  - max order cap: the global cap in mapping_max_folio_order() that Jan
    suggested trying.  At 64 KiB a 4 KiB write still charges 16x and is
    throttled.  At 16 KiB this run is not throttled, but dirty reached
    11.9G, just below the 12.2G background threshold.  The cap that
    avoids throttling depends on the write size, and it removes large
    folios for every file, including ones that never see small writes.
  - split on write: when a buffered write (iomap opts in, not for
    zeroing or unshare) finds a clean, uptodate, unmapped folio at least
    4x the write size, folio_split() it down to the write's order before
    dirtying it.  The rest of the folio stays cached in large folios.
    On the concerns Jan raised about splitting [1]: split on write only
    splits clean, uptodate, unmapped folios, so it needs no new
    filesystem state beyond an opt-in flag in iomap, and if
    folio_split() fails the write simply proceeds as today; evict on
    write avoids splitting altogether.
  - evict on write: same trigger, but mapping_evict_folio() the folio
    instead of splitting it (~40 lines).  This discards the folio's
    other cached data; nothing reads it back in this test, so the read
    cost does not show here.
  - POSIX_FADV_RANDOM (Dave's question): fio's fadvise_hint=random on
    the load job.  It avoids the problem without a kernel change, but
    only where the application opts in: the hint is per open file, so
    every process that reads a file must issue it, and a reader that
    doesn't (a backup or copy tool, for example) still builds large
    folios.  Every application that reads files sequentially and then
    rewrites them in place would have to adopt it, and keeps the
    regression until it does.  It also turns readahead off for those
    files, so their sequential reads lose readahead.

Split and evict on write keep whole-folio accounting and act at write
time, so they also cover large folios already in the page cache,
whoever built them, without each application having to opt in.  Both
only touch clean, uptodate, unmapped folios at least 4x the write
size, and only on iomap buffered writes.  Split keeps the rest of the
folio cached at the cost of the split; evict is simpler but drops it.
I'd appreciate your opinion on these options, or any other direction
you think is more appropriate.

Thanks,
Salvatore

[1] https://lore.kernel.org/all/oocwnxqgd4klrem6hkya3sddqoxkosml4ysz23if4j7wj2qdwi@5skgc4ftu7io/



AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico



