Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235011531C1;
	Sat,  4 Apr 2026 12:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.13.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775307047; cv=none; b=RFWqGUiYypXEbubCnApAkRi0SLDJ6XnPol3Xdx8fD3Vu3sJQoufVUuqtLgrNsljtUdZuxliibwueWGd7muQAkywutfKXU/OY8XsmhekSFk6wgYOJok+a1X8OaQW6RP/lBB8Ab6ktR2+UC+oalXQZmC2KJe+3RCzickDQB37NGPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775307047; c=relaxed/simple;
	bh=P/te+KD0J9rMECPDPyLNPpRXKsPe6aC6yoq8W2ao4Nw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=T1gXV+5av6rlM+6byHDDDL9la34dzLjjRAZc4446DU19slQjsGQDp+dSuDq/Ur8QMObfNVgepQXQ3ymPXA2hNgycdbSj0lACGCW7MTX3Ax7zbPndCpQgitN3WIm3GeXSsf97w+cpY0GtbDZJW/XWZAKJ3jBZjxs5l90co/RBfKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=IZjvcx48; arc=none smtp.client-ip=52.13.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="IZjvcx48"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1775307046; x=1806843046;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=lP6thk9cUzp3QjFSX27yDwNTPPqLJ1Hkoy80UthEhu0=;
  b=IZjvcx48RRDCzdVJojNgOrb3m+1JZqRYDHDG7LZO9vXr7kdp+Zj6JXBu
   6S8lttYB/+uyBXVPaAVo/dj4vrdCqJlOjxNBvVJ0+BFfpUtZbHNQ8yt/h
   L0C2lkTAWxeR20nxyzQ8EX6g7zCB0XjwU28PF9z7JKouOQmKZuLpb32kn
   n8OEwWEmEeMzxnGgd71qDeIOvCw7FAtqkQoJdqibNqdtI0ZbOLBSBmel7
   vVm7n640L17OTa4vZoxksphA/897l+TqrQgHWrDYbxy9IOvxZbCLaQvYU
   jaBYZUbqZUKiEKfXkggC/yspU+GaGAIXI+Q6nkAuf1Nvo1J9M384yBtM+
   Q==;
X-CSE-ConnectionGUID: T4p1uZdSTDCVcPtj+y2Lbw==
X-CSE-MsgGUID: 3RJYK02ETnygm2uHoj3yRA==
X-IronPort-AV: E=Sophos;i="6.23,159,1770595200"; 
   d="scan'208";a="16537733"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2026 12:50:42 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:18530]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.43.164:2525] with esmtp (Farcaster)
 id 9fe09342-f0a9-40b0-9cd1-58bcfa997eac; Sat, 4 Apr 2026 12:50:42 +0000 (UTC)
X-Farcaster-Flow-ID: 9fe09342-f0a9-40b0-9cd1-58bcfa997eac
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sat, 4 Apr 2026 12:50:42 +0000
Received: from c889f3b07a0a.amazon.com (10.106.82.39) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sat, 4 Apr 2026 12:50:41 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: Carlos Maiolino <cem@kernel.org>
CC: "Darrick J . Wong" <djwong@kernel.org>, <linux-xfs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Yuto Ohnuki <ytohnuki@amazon.com>
Subject: [PATCH] xfs: check directory data block header padding in scrub
Date: Sat, 4 Apr 2026 13:50:33 +0100
Message-ID: <20260404125032.37693-2-ytohnuki@amazon.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D045UWC001.ant.amazon.com (10.13.139.223) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The pad field in xfs_dir3_data_hdr exists for 64-bit alignment and
should always be zero. The scrub code already checks the pad field for
leaf and free block headers but was missing the same check for data
block headers. Add the missing check.

Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
---
 fs/xfs/scrub/dir.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index e09724cd3725..2db4def3358c 100644
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
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
+	}
 
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		goto out_buf;
-- 
2.50.1




Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



