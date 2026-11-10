Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=216.71.154.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794306956;
	b=g5tTkZJRDKCR7+r8Q1nc6ctaQtM8q8EltRvRcnogS3CTz17UQhcbtlMeCMZ0Zl29JTCF
	 0e97okuEyBEnKlNzUnoNaIf7ExO0UNVgzNZFWYYXvnocLXMGtSAJzNumcYQpBajIGEGaj
	 u7ulPxXcT5gfccOpgaWqeyWz55Em55cZNyyYP25BwP5Rqqo0tLVd23Od7eSF0cId4SY+A
	 RpVrO5Qo5WMK9sQYGUOCDs83D8Ne+08vE8wAfk+kQJeFHdKkuSgwFRBWYeBdiJGu7wRKi
	 pn1eIvadWPf1F9DlD2g8Ss+ZPdL2hFm+b1acs++fFPhVPXMf4zSRfstNV6/yVnXkLAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794306956;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 IronPort-SDR:Received:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 WDCIronportException:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Onpt/kc6syzXjX13IXxBzAglaNbMY4EH6w0Is3yyCQ8=;
	b=ULs42ePxrSB4Mj+T+GET3lB9bD9goAIAd1I4k60TKOyEmQsnw5kQkkT01iqu0mNdPZH1
	 tmj9kyG4Xwc9xyOexJNLkF/JRsBX2e4RZHysAx4FeCwu11IhwnIxstajj4HcT70UAe1kR
	 YQ5HYHJPeL+dA41qTj8LtHrTj43+aeRBo8pvRpYYZHVf3Lwc24Q2DdRM/1R6W69zSVIPK
	 30A50h+F5ADIb9vzhuWj2nLrR94nBO3d/DF57sYnjrCa4vOWPMWh53v7vFWliNHeYl5VN
	 ga5JR5OeYf9WvGWnpgRZ4ktDMC4aQ7VHoQu3bH3nE7gFJQOra9E3kQdFpdOOroIoXtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=moJEQxPK;
	arc=none smtp.remote-ip=216.71.154.45
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BC3606A31C;
	Tue, 10 Nov 2026 10:35:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 37BC3606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=moJEQxPK
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794306956; x=1825842956;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CdF9G5iRxtadVVsQ/XSoafHoMH+3wgdwnd/2yxaC3/w=;
  b=moJEQxPKzdjiZ61uhtDKuOyP3BenP7vRjMKppE80/n/HP4xzpyPf5O7i
   Pyg5cb2zZBP7mz6IVFFWW0w54HjwoCouofQ+rz6m4YmF398cLS0rY87o1
   WIaptf9fDRrpU78LBSwG7nkGuCYowpEnFVgeweD5lY3N+uiAglsjbhXzf
   cTzuwk7Gie8DzDZKj40uoC/N8K5FC9moZjksQHXdEGX7ps3TAkJzH4T66
   sP0pse+pH0u9xpjJhK6AVcqT9rs/+TOjkR8xtCY+0BdaGnP1ajuShHOIh
   iAiFENgSlkT45bjLNTRA5hOHR31RqoOsit0Se86AkaU/3+kC40fOiQE7h
   w==;
X-CSE-ConnectionGUID: NB/LsZUjSwCtTowSBeeRZg==
X-CSE-MsgGUID: 9cpyHknoSI61XlatcZ+QBg==
X-IronPort-AV: E=Sophos;i="6.27,205,1786982400"; 
   d="scan'208";a="158891389"
Received: from h199-255-45-14.hgst.com (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Nov 2026 18:35:55 +0800
X-CSE-ConnectionGUID: Bxo5IlWLSYuHuoWemGuq/w==
X-CSE-MsgGUID: uY3gEw7cQpyCoMC1bMwHVw==
IronPort-SDR: 6af2f38b_hSHUAdvYeTM2+G6TG5NY3RB5MPH6Wt0KmjPtbYbKGInsIrH
 rZ7YailVGKbMUqIomjLEaA+pOEoTL1Sa5MsocJA==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Nov 2026 02:35:55 -0800
X-CSE-ConnectionGUID: 2lxAYeObQVGkYuzreCFsUg==
X-CSE-MsgGUID: V1NOW0/nRrixVP1dibvVpg==
WDCIronportException: Internal
Received: from unknown (HELO gcv.wireless.wdc) ([10.224.5.251])
  by uls-op-esai1-o.wdc.com with ESMTP; 10 Nov 2026 02:35:52 -0800
From: Hans Holmberg <hans.holmberg@wdc.com>
To: brauner@kernel.org,
	hch@lst.de,
	djwong@kernel.org,
	dgc@kernel.org,
	cem@kernel.org,
	jack@suse.cz,
	axboe@kernel.dk,
	kbusch@kernel.org
Cc: dlemoal@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: [RFC 0/4] Zoned XFS stream based data placement PoC
Date: Tue, 10 Nov 2026 11:35:36 +0100
Message-ID: <20261110103540.46876-1-hans.holmberg@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103110640.1000095-1-anuj20.g@samsung.com>
References: <20261103110640.1000095-1-anuj20.g@samsung.com>
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

This is my first stab at stream-based data placement for zoned devices,
co-locating data with the same stream id.

It applies on top of v7 Anuj's/Kanchan's xfs write stream series.

The support is limited to ZNS/SMR devices, but could be extended with
support for FDP drives as well. We had an earlier prototype for this,
where we allocated as many open zones as there are hardware streams
minus the GC zones, which should work just fine.

I've done some benchmarks with Anuj's patched RocksDB branch
write-streams-v7 from [1] with streams added vs. the base write
lifetime hint support on ZNS.

For RocksDB, zoned XFS hints-based placement, which favors separating
data for long-lived files, gives the best overall result when the SST
file size matches the zone capacity, separating files into different
zones (144 GB moved by GC vs. 206-623 GB for the other modes at that
file size). This is likely because SST file lifetime in lower levels
doesn't correlate strongly enough with level for finer-grained
separation to pay off.

If a workload produces files that are a fraction of the zone capacity,
stream-based placement is better: with 16M-512M SST files, streams cut
GC by 26-32% vs. 4-12% for hints. It should also help workloads that
can use more streams than the write lifetime hints provide, so I think
it's worth including in the zoned allocator.

It would be great to have more sample workloads to benchmark streams
based file data placement, so if there is anything out there, let
me know.

Benchmarks:

Overwrite throughput and data moved by GC with hints and streams, each
disabled (nolifetime / nostreamalloc) and enabled (XFS zoned, ~1 GiB
zones on a 200G FS, fill + 1x random overwrite, single run per
configuration) 70-90% fs usage.

      |      overwrite MB/s       |  GC GB (from xfs stats)
      |    hints    |   streams   |    hints    |   streams
 SST  |   off    on |   off    on |   off    on |   off    on
 -----+-------------+-------------+-------------+-------------
 16M  |  27.3  28.4 |  27.1  32.0 |  1922  1777 |  1934  1314
 32M  |  29.0  29.5 |  28.8  34.1 |  1769  1685 |  1790  1211
 64M  |  31.0  31.8 |  30.9  36.4 |  1593  1534 |  1613  1113
 256M |  44.9  46.3 |  46.0  52.5 |  1026   935 |   972   714
 512M |  58.8  60.9 |  59.7  63.7 |   488   428 |   474   352
 1G   |  74.9  81.1 |  76.7  62.1 |   233   144 |   206   623

[1] https://github.com/anuj7781/rocksdb.git

Hans Holmberg (4):
  xfs: report write streams for zoned realtime inodes
  xfs: place zoned data by write stream in open zones
  xfs: report zoned write streams on realtime inheriting directories
  xfs: add a nostreamalloc mount option

 Documentation/admin-guide/xfs.rst |  10 +++
 fs/xfs/xfs_inode.c                |  33 ++++---
 fs/xfs/xfs_inode.h                |   2 +
 fs/xfs/xfs_ioctl.c                |   6 +-
 fs/xfs/xfs_iomap.c                |   8 +-
 fs/xfs/xfs_mount.h                |   2 +
 fs/xfs/xfs_super.c                |  15 ++++
 fs/xfs/xfs_zone_alloc.c           | 140 +++++++++++++++++++++---------
 fs/xfs/xfs_zone_alloc.h           |   7 ++
 fs/xfs/xfs_zone_info.c            |   3 +-
 fs/xfs/xfs_zone_priv.h            |  14 +++
 11 files changed, 185 insertions(+), 55 deletions(-)

-- 
2.43.0

