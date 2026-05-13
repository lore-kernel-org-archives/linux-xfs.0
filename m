Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A322638B7CD
	for <linux-xfs@vger.kernel.org>; Wed, 13 May 2026 06:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778654385; cv=none; b=bMEM8fBbRZturQFyK/8vKQWYzfLJg5mQmYLWaUbuOnFHj5zBka/gLvTCMT2Q8u+FGJtJxtTLFqGZLZnUd+vFqrGIXXpqfIYur06lWgi8nUKh9LW4X4zTmOWieUwBvCNFoONR3kYIA8dTrAyAoUInqZ7u0jQl2TXc4b8UT6jSomQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778654385; c=relaxed/simple;
	bh=UFj3qSB+Bk8n6lfNSg6Ep70wWJwewrmpHBfQYTtETac=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A4Ks4zodmnEmvIa4f5USbaONCIEY47I92870Wu61BV7c5HRVYW7JRjEXdsbOBWdehwzO8PDia9kNVXvVor8NVlv0I8+mfjXJNgH/8wnzgM6ctjRFgCF+dV9pqlx1IsiWT2DIBkGz1aikTVB9OxWx64a4el4h+O33/9ShzTNhQyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=R6hj0d7d; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="R6hj0d7d"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1778654383; x=1810190383;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UFj3qSB+Bk8n6lfNSg6Ep70wWJwewrmpHBfQYTtETac=;
  b=R6hj0d7duyjgRgCGlbO6X80SQmF3UVZWfC7dKQ0u4jDh5YQWG8vIJr4Y
   6lvBrE2Ao9heJCp/YZNkXfe2kFp++4ht1IPEjfwTipSPK/DMRIva46+lw
   x8JE8O5VEYApGw3RurNZ2QzVCPPhOxKNpZragbFjC39qf/+XSbPSvooVs
   fR4bFX2fG2Qdi++pkodfEK3aFh/Z0xQjljRdv3fpM7hqRvGCAz1IF1L9g
   u+Qc554ZcY7EjNLl6PNnB1RshZNM+gRgOMArW2GazFKmsyD+aD2JhJanb
   Pa9ojvC1PXWS8uxVHncTXDAxj5B16WuQhLzCoBGqUi7ELB3Kcgz3KBj/3
   g==;
X-CSE-ConnectionGUID: /uQoY88SRXivWShN3OcsEQ==
X-CSE-MsgGUID: g4ggXZtdQeO7l0IZp6f4Lg==
X-IronPort-AV: E=Sophos;i="6.23,232,1770566400"; 
   d="scan'208";a="146458538"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 13 May 2026 14:38:35 +0800
X-CSE-ConnectionGUID: QnbXNQ8iQO2C9HAGT2EUgw==
X-CSE-MsgGUID: OAOFL3VZSaGwkgvF22mlRA==
IronPort-SDR: 6a041c46_DYjWmGGt3m2jok1lOuPGfX5Jf3axiQwGwugEziOdEWlG028
 +2qI9sJ71GYcagJ5q96wyU/AKww9+0RQeEel9KQ==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 May 2026 23:37:57 -0700
X-CSE-ConnectionGUID: RB8aHSpCSIuq817qBOIv6w==
X-CSE-MsgGUID: yhNns8FJQaSKcfdaLPbbSw==
WDCIronportException: Internal
Received: from wdap-r8nvkhmetp.ad.shared (HELO gcv.wdc.com) ([10.224.16.22])
  by uls-op-esai1-o.wdc.com with ESMTP; 12 May 2026 23:37:56 -0700
From: Hans Holmberg <hans.holmberg@wdc.com>
To: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	linux-xfs@vger.kernel.org,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: [PATCH] xfs: return -ENOENT for unallocated inodes in xfs_imap_lookup
Date: Wed, 13 May 2026 08:37:45 +0200
Message-ID: <20260513063745.8067-1-hans.holmberg@wdc.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Under heavy garbage collection pressure from RocksDB workloads,
filesystem shutdowns can occur in xfs_zone_gc_iter_irec when
xfs_iget() returns -EINVAL.

xfs_zone_gc_iter_irec expects -ENOENT when garbage collection races
with file deletion, so that blocks belonging to deleted files can be
skipped gracefully. Returning -EINVAL instead causes the GC code to
treat this as a fatal error and forces a shutdown.

Fix this by returning -ENOENT from xfs_imap_lookup for untrusted inodes
when the inode has been deleted, allowing zone GC to safely ignore stale
mappings.

Fixes: 080d01c41d44 ("xfs: implement zoned garbage collection")
Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
---

We could also fix this up in xfs_zone_gc_iter_irec, and handle -EINVAL
as a non-fatal error, but returning -ENOENT from xfs_imap_lookup seems
like the more right thing to do.

The check "that the returned record contains the required inode" in
xfs_imap_lookup also returns -EINVAL and might be worth switching
over to -ENOENT but I'm leaving that as is I did not hit that case
in my testing.

 fs/xfs/libxfs/xfs_ialloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index dcef06ec0a02..702e1e853e45 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2442,7 +2442,7 @@ xfs_imap_lookup(
 	/* for untrusted inodes check it is allocated first */
 	if ((flags & XFS_IGET_UNTRUSTED) &&
 	    (rec.ir_free & XFS_INOBT_MASK(agino - rec.ir_startino)))
-		return -EINVAL;
+		return -ENOENT;
 
 	*chunk_agbno = XFS_AGINO_TO_AGBNO(mp, rec.ir_startino);
 	*offset_agbno = agbno - *chunk_agbno;
-- 
2.34.1

