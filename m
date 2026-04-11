Received: from pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.1.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1397A1DC985;
	Sat, 11 Apr 2026 14:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.1.125
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775917471; cv=none; b=FQwdneDXlfy21VPk9QVXXBAAAhMSjc5aiOXRH1ZY48wuA7ihOVQvwq85LKSxkLbE5xIfofJEw1pjqTBoSvEKFRbrWzVjLVmIyQlMsjCNX4gHRbATj8rg+5D3kGzCVLCNgFEWaRUsJC6vemmy5gs4aQBUyLz6jIVa+KvCyJTOgh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775917471; c=relaxed/simple;
	bh=YO33DTb3TFUJP7s0OGTVpjhZDK5q2AcYV6YlHRVebEc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cAb8ZxRMezhsHQtx+FIJZU2mv7oXrkPrfn+LSuIUO/1TgpdacNqBaYbsX2oal/37ChxVT3QnzeyNa0CMrPtVc+yhYuhM63zdIcpXCq7rNNa0kPLnRvbaWuqHtVDSooL6pNGk1InewIEGXD/oNKhu+RMLCZD/7OlZLFmFvFLMzeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=QZcnZPTf; arc=none smtp.client-ip=44.246.1.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="QZcnZPTf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1775917470; x=1807453470;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4sThVgGuDgNwYYYjDOGxnVqvTIfz6/gKqjsCraS8JU8=;
  b=QZcnZPTfdFJgqfsbMfsQ1MZ0iSLKrCAicl6vfLCD1HydIU417dLsPNJX
   UcHmZXXj7LSHk/sdJjXdw6XWSQN81acQ8cNy1AhYEq6mS1Zub+bbcwwJk
   OOTRSDRZ3Q6ytkuGtQ65dUB/P4INLFS77whEpJMHsoBA1PcYfuDEHVzO3
   WE6NrjWfprXuf+dmXE2/hacMSQEedqASPgslwV/JYRFNTSrbemRRQwowv
   wxjxs3FZfsXGHoPlGAxsECc4642NQnWP2Qdgy/OAH3/A9mt24UP1uLW/e
   h9N+FZ7KLR8QYuiFRSlHF0LzJMcF3OKuQOUhC1nbpF73KcbMlzKQRJXEP
   A==;
X-CSE-ConnectionGUID: m2XkPdVnT+eewg9qFseQCQ==
X-CSE-MsgGUID: XZqFyBdqQoicSGPYpft5xg==
X-IronPort-AV: E=Sophos;i="6.23,173,1770595200"; 
   d="scan'208";a="17075725"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2026 14:24:27 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.51:23512]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.3.82:2525] with esmtp (Farcaster)
 id 635207fb-31e3-46bc-8466-58d5e8d2b5c3; Sat, 11 Apr 2026 14:24:27 +0000 (UTC)
X-Farcaster-Flow-ID: 635207fb-31e3-46bc-8466-58d5e8d2b5c3
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sat, 11 Apr 2026 14:24:27 +0000
Received: from c889f3b07a0a.amazon.com (10.106.82.32) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sat, 11 Apr 2026 14:24:25 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: Carlos Maiolino <cem@kernel.org>
CC: "Darrick J . Wong" <djwong@kernel.org>, Dave Chinner <dgc@kernel.org>,
	<linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Yuto Ohnuki
	<ytohnuki@amazon.com>
Subject: [PATCH v3 1/3] xfs: zero entire directory data block header region at init
Date: Sat, 11 Apr 2026 15:24:13 +0100
Message-ID: <20260411142411.72194-6-ytohnuki@amazon.com>
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

xfs_dir3_data_init currently zeroes only the xfs_dir3_blk_hdr portion of
the directory data block header, then manually initializes the bestfree
entries in a loop. This leaves the pad field in xfs_dir3_data_hdr
uninitialized and requires explicit zeroing of each bestfree slot.

Zero the entire header region (geo->data_entry_offset bytes)
unconditionally before setting individual fields. This covers all
current and future header fields, all padding (implicit and explicit),
and the bestfree array, so the manual zeroing loop for bestfree can be
removed.

Suggested-by: Dave Chinner <dgc@kernel.org>
Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
---
 fs/xfs/libxfs/xfs_dir2_data.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 80ba94f51e5c..35ff119aa84b 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -728,7 +728,6 @@ xfs_dir3_data_init(
 	struct xfs_dir2_data_unused	*dup;
 	struct xfs_dir2_data_free 	*bf;
 	int				error;
-	int				i;
 
 	/*
 	 * Get the buffer set up for the block.
@@ -741,13 +740,16 @@ xfs_dir3_data_init(
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DIR_DATA_BUF);
 
 	/*
-	 * Initialize the header.
+	 * Initialize the whole directory header region to zero
+	 * so that all padding, bestfree entries, and any
+	 * future header fields are clean.
 	 */
 	hdr = bp->b_addr;
+	memset(hdr, 0, geo->data_entry_offset);
+
 	if (xfs_has_crc(mp)) {
 		struct xfs_dir3_blk_hdr *hdr3 = bp->b_addr;
 
-		memset(hdr3, 0, sizeof(*hdr3));
 		hdr3->magic = cpu_to_be32(XFS_DIR3_DATA_MAGIC);
 		hdr3->blkno = cpu_to_be64(xfs_buf_daddr(bp));
 		hdr3->owner = cpu_to_be64(args->owner);
@@ -759,10 +761,6 @@ xfs_dir3_data_init(
 	bf = xfs_dir2_data_bestfree_p(mp, hdr);
 	bf[0].offset = cpu_to_be16(geo->data_entry_offset);
 	bf[0].length = cpu_to_be16(geo->blksize - geo->data_entry_offset);
-	for (i = 1; i < XFS_DIR2_DATA_FD_COUNT; i++) {
-		bf[i].length = 0;
-		bf[i].offset = 0;
-	}
 
 	/*
 	 * Set up an unused entry for the block's body.
-- 
2.50.1




Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



