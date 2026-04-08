Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94FB3D8115;
	Wed,  8 Apr 2026 17:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.42.203.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775670052; cv=none; b=fx/Mv815E7ZC4CzkwVvaUa6ieMeNp20XS5uD0WMqt+1soACArey4iAlKTiknbLitQtESxCktWswO7pBjJMpcGWOWHUeCRH3i65iArtSAImuh5iqnG4N0l6ye1VwLLJZMnFXYkAAe7gJhIVmMACZacYHEB2+0g/o+AQ1Iz4bK+Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775670052; c=relaxed/simple;
	bh=0zX96AWyAq896lOewvbo4JJvYxPyM/Zdcb4t5ti3M/g=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=O99uIy8/3RO/kyItktO/7p3qmF+uogUzbNFDkrLtp+tIR8len9p4o39FGpAoMeBIUoA/zKhUw1GDcduKyBlprrzB8iBdnXwdbD0KmiHduFXFeSgiHLCj95fg622P00ahASsgxMgz6JU/18TM+US9/TJAEoyzWy02nWvivdpL5sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=SsCus4UI; arc=none smtp.client-ip=52.42.203.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="SsCus4UI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1775670048; x=1807206048;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=L/Tx5KGUtqf5jBYqaqiGzeW/fFk8dUq8ZCfZcIkuV7E=;
  b=SsCus4UIAjxanQJ/Wy4gE++lZh8lqKF+vy/WIWvpStsvHJv9UfHKDuqA
   tYH4KMtvJCpn8Xm+sXdlVuyja/gyklXfi6S+OQBf71tUgurMfctC9tfRk
   o80LDvpCGkeg1/9x0kS3DPLLFvqdWoixK7TLDQ0AQYMW0kS0gfc8v2dPO
   mGYAk4n9NxqS19a/SLZRensRg6RWc2vixMEd9ECyHF/fdPBN7s3xYryTu
   XJ4Ux/9zMCNvLx3nYPoAvrmM/D24A4hfCFNSbdvfeXYEFJirUquB5thuI
   cRoZDzAzYrLOsEtbVJsSfS2R43OPgzenFodwh82F8EY0SZzFVA09ttvUt
   w==;
X-CSE-ConnectionGUID: uiAZU3ycRt6speDqXb8p6A==
X-CSE-MsgGUID: TuWW9OOaQ7mH2H7l73YXQg==
X-IronPort-AV: E=Sophos;i="6.23,167,1770595200"; 
   d="scan'208";a="16864528"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2026 17:40:45 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:13494]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.6.131:2525] with esmtp (Farcaster)
 id 40c1da0c-a5f7-4d44-9783-902d7197fbbf; Wed, 8 Apr 2026 17:40:45 +0000 (UTC)
X-Farcaster-Flow-ID: 40c1da0c-a5f7-4d44-9783-902d7197fbbf
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 8 Apr 2026 17:40:44 +0000
Received: from c889f3b07a0a.amazon.com (10.106.83.24) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 8 Apr 2026 17:40:43 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: Carlos Maiolino <cem@kernel.org>
CC: "Darrick J . Wong" <djwong@kernel.org>, <linux-xfs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Yuto Ohnuki <ytohnuki@amazon.com>
Subject: [PATCH v2] xfs: check da node block pad field during scrub
Date: Wed, 8 Apr 2026 18:40:34 +0100
Message-ID: <20260408174033.4165-2-ytohnuki@amazon.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D037UWC002.ant.amazon.com (10.13.139.250) To
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
Changes in v2:
- Use xchk_da_set_preen instead of xchk_da_set_corrupt since
  old kernels may have written non-zero padding without issues.
- Link to v1: https://lore.kernel.org/all/20260404143043.65268-2-ytohnuki@amazon.com/
---
 fs/xfs/scrub/dabtree.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index 1a71d36898b1..b55922d3e988 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -454,7 +454,12 @@ xchk_da_btree_block(
 			}
 		}
 
-		/* XXX: Check hdr3.pad32 once we know how to fix it. */
+		if (xfs_has_crc(ip->i_mount)) {
+			struct xfs_da3_node_hdr *nodehdr3 = blk->bp->b_addr;
+
+			if (be32_to_cpu(nodehdr3->__pad32) != 0)
+				xchk_da_set_preen(ds, level);
+		}
 		break;
 	default:
 		xchk_da_set_corrupt(ds, level);
-- 
2.50.1




Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



