Received: from pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.162.73.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8EF83D7D69;
	Wed,  8 Apr 2026 17:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.162.73.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775669284; cv=none; b=XbnJ3Cl9sysZ7t+rJfwekMiTKVPtGRVKJRiqaxjd2s9HqisXMWrALL4CP8LRQbAJR0vS5oKulB/+yGxM10RiAe5roRdPUBIS9uD6n/WV8OKvSjdM9pntoAYjpqlQ5CRHxxrTWPBUFxz8kXlobG7KShuSo1EKx8NupIJsRFvGaj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775669284; c=relaxed/simple;
	bh=eXsyAHVTWUrq4S3lQvU2PzVAhitEeFitM0kABdJEI/U=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=d9p9LU9IOGzE1cusXBrETGk6v5oy+wZYPY3gTLEDCL8cJCsvf7u9NVj0Di2QTLpEwZazlBd+vM214WjtMrL0WmqV0vVafnpqRbEHFzE1jZgiSliiL3RYE7Unx4zZEBD54hca4RCZtfRNwKXsh+QH5LVz2PmY50WCZO9Cnz60Sr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=UIszVF6F; arc=none smtp.client-ip=35.162.73.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="UIszVF6F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1775669282; x=1807205282;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wMbqv2G3WF5JQm3aWqQDxjEOSRBVaI07dNzVvGcwTJk=;
  b=UIszVF6F3pcQsHnJKjmUDECA3DEaZSimJEDSUm24E1BP/EcfFbKoC7FR
   VruEmNCQEosE5RuX1kFOnTIBDU3l3QDa92PrTnqwVL1XnutbJg8j+LDsD
   18C1iFJflLrO/sDw4gf6Vz8ZMUSBSSLw1yX7Gw8pLtzPNIFNaLomglq5/
   xuoaiurcIvJjK22rJU2MH8eMeNd0m8OINe4Lp/xeP0e243NWn3pIQfVD1
   GmAqIr/Xf0LmQvNOrqnVEZk1F9Kl3su+wbWxaFSxH8Cw2dhOlGQYKE8f6
   ZS7FM1AENSxR/fY+q6md3fQWWHqaexO9F+02+yKutqHhg+S1o+y4YZr3s
   Q==;
X-CSE-ConnectionGUID: +lU8cfP1SBKGTnJ1M4onhQ==
X-CSE-MsgGUID: gRYHE5HDSpeExzqxCI8HIg==
X-IronPort-AV: E=Sophos;i="6.23,167,1770595200"; 
   d="scan'208";a="16656516"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2026 17:28:02 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:9803]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.60.232:2525] with esmtp (Farcaster)
 id 267df027-0f1a-435d-8902-396ef5fe31e1; Wed, 8 Apr 2026 17:28:02 +0000 (UTC)
X-Farcaster-Flow-ID: 267df027-0f1a-435d-8902-396ef5fe31e1
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 8 Apr 2026 17:28:00 +0000
Received: from c889f3b07a0a.amazon.com (10.106.83.24) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 8 Apr 2026 17:27:58 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: Carlos Maiolino <cem@kernel.org>
CC: "Darrick J . Wong" <djwong@kernel.org>, <linux-xfs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Yuto Ohnuki <ytohnuki@amazon.com>
Subject: [PATCH v2] xfs: check directory data block header padding in scrub
Date: Wed, 8 Apr 2026 18:27:50 +0100
Message-ID: <20260408172749.99216-2-ytohnuki@amazon.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D042UWB003.ant.amazon.com (10.13.139.135) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The pad field in xfs_dir3_data_hdr exists for 64-bit alignment and
should always be zero.

First, fix xfs_dir3_data_init to zero the full xfs_dir3_data_hdr instead
of just xfs_dir3_blk_hdr so that the pad field is covered by the memset.

Then, add the missing scrub check for the pad field in directory data
block headers. Since old kernels may have written non-zero padding
without issue, flag this as an optimization opportunity (preen) rather
than corruption. Add xchk_fblock_set_preen helper for this purpose.

Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
---
Changes in v2:
- Fix xfs_dir3_data_init to zero the full xfs_dir3_data_hdr instead of
  just xfs_dir3_blk_hdr so that the pad field is covered by the memset.
- Use xchk_fblock_set_preen instead of xchk_fblock_set_corrupt since
  old kernels may have written non-zero padding without issues.
- Add xchk_fblock_set_preen helper function.
- Link to v1: https://lore.kernel.org/all/20260404125032.37693-2-ytohnuki@amazon.com/#t
---
 fs/xfs/libxfs/xfs_dir2_data.c | 10 +++++-----
 fs/xfs/scrub/common.c         | 11 +++++++++++
 fs/xfs/scrub/common.h         |  2 ++
 fs/xfs/scrub/dir.c            |  7 ++++++-
 4 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 80ba94f51e5c..037f9449835d 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -745,13 +745,13 @@ xfs_dir3_data_init(
 	 */
 	hdr = bp->b_addr;
 	if (xfs_has_crc(mp)) {
-		struct xfs_dir3_blk_hdr *hdr3 = bp->b_addr;
+		struct xfs_dir3_data_hdr *hdr3 = bp->b_addr;
 
 		memset(hdr3, 0, sizeof(*hdr3));
-		hdr3->magic = cpu_to_be32(XFS_DIR3_DATA_MAGIC);
-		hdr3->blkno = cpu_to_be64(xfs_buf_daddr(bp));
-		hdr3->owner = cpu_to_be64(args->owner);
-		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_meta_uuid);
+		hdr3->hdr.magic = cpu_to_be32(XFS_DIR3_DATA_MAGIC);
+		hdr3->hdr.blkno = cpu_to_be64(xfs_buf_daddr(bp));
+		hdr3->hdr.owner = cpu_to_be64(args->owner);
+		uuid_copy(&hdr3->hdr.uuid, &mp->m_sb.sb_meta_uuid);
 
 	} else
 		hdr->magic = cpu_to_be32(XFS_DIR2_DATA_MAGIC);
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 20e63069088b..3d40cb0b2496 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -251,6 +251,17 @@ xchk_ino_set_preen(
 	trace_xchk_ino_preen(sc, ino, __return_address);
 }
 
+/* Record a block indexed by a file fork that could be optimized. */
+void
+xchk_fblock_set_preen(
+	struct xfs_scrub        *sc,
+	int                     whichfork,
+	xfs_fileoff_t           offset)
+{
+	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_PREEN;
+	trace_xchk_fblock_preen(sc, whichfork, offset, __return_address);
+}
+
 /* Record something being wrong with the filesystem primary superblock. */
 void
 xchk_set_corrupt(
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index f2ecc68538f0..b494d747c008 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -25,6 +25,8 @@ bool xchk_fblock_xref_process_error(struct xfs_scrub *sc,
 void xchk_block_set_preen(struct xfs_scrub *sc,
 		struct xfs_buf *bp);
 void xchk_ino_set_preen(struct xfs_scrub *sc, xfs_ino_t ino);
+void xchk_fblock_set_preen(struct xfs_scrub *sc,
+		int whichfork, xfs_fileoff_t offset);
 
 void xchk_set_corrupt(struct xfs_scrub *sc);
 void xchk_block_set_corrupt(struct xfs_scrub *sc,
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index e09724cd3725..0a1ec94961ed 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -492,7 +492,12 @@ xchk_directory_data_bestfree(
 		goto out;
 	xchk_buffer_recheck(sc, bp);
 
-	/* XXX: Check xfs_dir3_data_hdr.pad is zero once we start setting it. */
+	if (xfs_has_crc(sc->mp)) {
+		struct xfs_dir3_data_hdr    *hdr3 = bp->b_addr;
+
+		if (hdr3->pad != cpu_to_be32(0))
+			xchk_fblock_set_preen(sc, XFS_DATA_FORK, lblk);
+	}
 
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		goto out_buf;
-- 
2.50.1




Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



