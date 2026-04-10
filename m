Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FA7224B1E;
	Fri, 10 Apr 2026 17:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.68.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775840789; cv=none; b=cRUdtHoPMBauoKDxbr11W+1TGvita4Kg7FXr9tENzw9eIdHI6M5todXfnnYuLnLVkwKx7b23czSIEfpJJZZ8Uv6j8IYd4ro09DeKZP4MyitnIn+d001eVzFOG/r1Og3pYBD/MbnKvR+LdR0BmdW7+91J1Y3GGgMuLheRn8i4bPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775840789; c=relaxed/simple;
	bh=/1sChIBuoB0VviEcJfb7kDAkT6okEUlaGtITyP6nvN0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=McuVf0T2Zi6qJrSlkYZC/jm63Wcw9+zMDm3fEzEBagST7sIWeEzgzNlQfKClJmuUhbZU8KEczM1MXKRUy4yIWssTPbzDF1DlWbasTkvagGrJY3eIk0Q0NSr6Aenuwm9bXRUK+rbikK9DuKMMuABx0lvqQ+vvsOKZ2TzsuIgO0DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=hFL3kPAK; arc=none smtp.client-ip=44.246.68.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="hFL3kPAK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1775840788; x=1807376788;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=iE5x5E+6YfshAYXbIfKYGNwJY0Yno1amc/LWGz59L64=;
  b=hFL3kPAK1Upjc1AZTG6q7sT9HRsy57nlQOHPZ7X/Xt3ojzSAkg7hgXhI
   GVoIiEuPDOaubJzbSPh+rw8h3x6iOL/26FxC77aYGSQi9N3sEIi+Eth/q
   iuFiGgHdusY34dnwSq9I992/kvV9AUUOmum4R8nwLOmUsyPMF7RJscyZ3
   oIyKkntAZ9yQhqE8tkkPD2Xofr4E1WW4zvtzOZXBxyaXmsd4aidiq/2Ll
   h4/i6AzU3jFehdeLnOOaNLl0XRoX598do7nAtqCZ+tMxowu0sG7HtOeXj
   uaAuFq7vpiu6/nomPScTC9RXVVeIdYqidMraCsET+hLI2kLJ46hIUKscy
   g==;
X-CSE-ConnectionGUID: /FBqyDurSoK0PZIAP4Ijaw==
X-CSE-MsgGUID: nPe6iu1KTySdDk2bDKM0jA==
X-IronPort-AV: E=Sophos;i="6.23,171,1770595200"; 
   d="scan'208";a="17040286"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 17:06:25 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:5155]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.6.131:2525] with esmtp (Farcaster)
 id 925b7213-749b-4c16-9af7-227e919a6bd6; Fri, 10 Apr 2026 17:06:25 +0000 (UTC)
X-Farcaster-Flow-ID: 925b7213-749b-4c16-9af7-227e919a6bd6
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 17:06:24 +0000
Received: from c889f3b07a0a.amazon.com (10.106.83.15) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 17:06:22 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: Carlos Maiolino <cem@kernel.org>
CC: "Darrick J . Wong" <djwong@kernel.org>, Dave Chinner <dgc@kernel.org>,
	<linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Yuto Ohnuki
	<ytohnuki@amazon.com>
Subject: [PATCH v3] xfs: check da node block pad field during scrub
Date: Fri, 10 Apr 2026 18:06:15 +0100
Message-ID: <20260410170614.8075-2-ytohnuki@amazon.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D036UWB001.ant.amazon.com (10.13.139.133) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The da node block header (xfs_da3_node_hdr) contains a __pad32 field
that should always be zero. Add a check for this during directory and
attribute btree scrubbing.

Since old kernels may have written non-zero padding without issues, flag
this as an optimization opportunity (preen) rather than corruption.

Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
---
Changes in v3:
- Drop unnecessary be32_to_cpu() on comparison to zero.
- Link to v2: https://lore.kernel.org/all/20260408174033.4165-2-ytohnuki@amazon.com/
Changes in v2:
- Use xchk_da_set_preen instead of xchk_da_set_corrupt since
  old kernels may have written non-zero padding without issues.
- Link to v1: https://lore.kernel.org/all/20260404143043.65268-2-ytohnuki@amazon.com/
---
 fs/xfs/scrub/dabtree.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index 1a71d36898b1..c2d6ad59d03e 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -454,7 +454,12 @@ xchk_da_btree_block(
 			}
 		}
 
-		/* XXX: Check hdr3.pad32 once we know how to fix it. */
+		if (xfs_has_crc(ip->i_mount)) {
+			struct xfs_da3_node_hdr *nodehdr3 = blk->bp->b_addr;
+
+			if (nodehdr3->__pad32)
+				xchk_da_set_preen(ds, level);
+		}
 		break;
 	default:
 		xchk_da_set_corrupt(ds, level);
-- 
2.50.1




Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



