Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E303D14F9FB;
	Sat, 11 Apr 2026 14:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.34.181.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775917477; cv=none; b=dw+u1yF+b6O07BthN9AtZo04aDnfLaeHo4F6BqJ0Vb6HRayk2GEUYz1HpP7Vo9c8PvfD+xXIyvja9jA7Z1vDCP/RDp8vAvEtab4DgzJOIinR9TKsZLzREcYRrZaoIrSzEeXdgefmWCNGm4ZgznsWtkmJtHa8QVrut3SCrw2J+8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775917477; c=relaxed/simple;
	bh=JHTdkV3I/zkcvcsBKZMBXGlO1bdCXiVhsj0VoyEbBxs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AYRaSLJcD2gB0diu0sCcb4+6osNihjVym61w306+ddEK9XBwrnNbZcsSFSm0ncrW3bIG+vfFeExryDwGhETy5mjpvckBR/mm34ASG71R5vfBnolliFMkfIsYv+9+TlJJ/FDe58xcya9v6aOnHDV97ssqFDrmvEiJbwkeJzxnnaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=jjIE/v7+; arc=none smtp.client-ip=52.34.181.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="jjIE/v7+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1775917475; x=1807453475;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ckfxy6F02oeQPQE3zILF7niSD2AMkcx7i7dm+y+4eNI=;
  b=jjIE/v7+3m0K5CuxhxISBdkQ1pifi0DUaWdPieSf4mFuU7QfazAwtXwO
   SDtfN4K5cmX0UX99BCxLVbFisgfs/+E65G6pW7dwyjCFZTln7/Rw9uW9A
   MohzuPgabv6+M3rpbDkEJkq3DPlGyikZlIoVS4qSxw8Hh0G+SgDPVjnC+
   0SZxI+pl+v0WKg1Py3IKpw5b3OSRIqhvXQclXgMZvO0Npz3dM90gWmjRO
   /Sd42rQKH47WxF8vKA79aOH/87Lm9Lf4CyPGHNKgV7987plZgEiuPCCeb
   yJvQmxZsg8fdOod2CWhQkdr0q9x3g81P5qvh2qsZpQQusxRX9F9gh8j7d
   g==;
X-CSE-ConnectionGUID: lAwEZtVXTgiaEpXSo/daxg==
X-CSE-MsgGUID: BrAAEBteS3mLecEVNpsoBw==
X-IronPort-AV: E=Sophos;i="6.23,173,1770595200"; 
   d="scan'208";a="17065959"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2026 14:24:33 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:11208]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.60.232:2525] with esmtp (Farcaster)
 id 25e20de6-2886-4a46-a4b7-79fb911e0fdd; Sat, 11 Apr 2026 14:24:32 +0000 (UTC)
X-Farcaster-Flow-ID: 25e20de6-2886-4a46-a4b7-79fb911e0fdd
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sat, 11 Apr 2026 14:24:32 +0000
Received: from c889f3b07a0a.amazon.com (10.106.82.32) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sat, 11 Apr 2026 14:24:30 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: Carlos Maiolino <cem@kernel.org>
CC: "Darrick J . Wong" <djwong@kernel.org>, Dave Chinner <dgc@kernel.org>,
	<linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Yuto Ohnuki
	<ytohnuki@amazon.com>
Subject: [PATCH v3 3/3] xfs: check directory data block header padding in scrub
Date: Sat, 11 Apr 2026 15:24:15 +0100
Message-ID: <20260411142411.72194-8-ytohnuki@amazon.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260411142411.72194-5-ytohnuki@amazon.com>
References: <20260411142411.72194-5-ytohnuki@amazon.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D041UWB002.ant.amazon.com (10.13.139.179) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add the missing scrub check for the pad field in directory data block
headers. Old kernels may have written non-zero padding without issue,
and the write path now self-heals stale padding on modification. Flag
non-zero padding as an optimization opportunity (preen) rather than
corruption.

Add xchk_fblock_set_preen helper for reporting file fork block issues
that could be optimized. The trace event xchk_fblock_preen already
exists.

Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
---
 fs/xfs/scrub/common.c | 11 +++++++++++
 fs/xfs/scrub/common.h |  2 ++
 fs/xfs/scrub/dir.c    |  7 ++++++-
 3 files changed, 19 insertions(+), 1 deletion(-)

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
index e09724cd3725..09715a4aa154 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -492,7 +492,12 @@ xchk_directory_data_bestfree(
 		goto out;
 	xchk_buffer_recheck(sc, bp);
 
-	/* XXX: Check xfs_dir3_data_hdr.pad is zero once we start setting it. */
+	if (xfs_has_crc(sc->mp)) {
+		struct xfs_dir3_data_hdr    *hdr3 = bp->b_addr;
+
+		if (hdr3->pad)
+			xchk_fblock_set_preen(sc, XFS_DATA_FORK, lblk);
+	}
 
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		goto out_buf;
-- 
2.50.1




Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



