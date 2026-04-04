Received: from pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com [34.218.115.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA5740DFAF;
	Sat,  4 Apr 2026 14:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.218.115.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775313058; cv=none; b=a4ifE2kgPZpSzb3rKMbSk/8pGI85jhCrYXqWk3qGu7gqASku5NmHt2rX/X+SfDZq2vSPQnNRcnZktG6Tkawy8dgqxUZTTYk1rkKijjmmPzEpH1PdSLglp1C2gA2r3Qn8u13MFhvKuzfv0WO4hCK872KvXGs1b1w0C2CI30k0Oz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775313058; c=relaxed/simple;
	bh=+xV2gtJ+wXEebNPdGxfbe6+OHkz2MmO2AAS/Do8twz0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TTQDqnHoReJtbSFK4AfrZwb9blY4qW18DJRRZLN9+1QpRARi8QzwMV8eBDI5kAEP8QZsHzY3jQLdTA5Kl0Gy7drpsce2KNbe1Ibz3A2AldTPhM7GBaujw3AdL6NsRl1dsR7Axr/ZNM1xD1KFzk8L0Aur/TPEV3O7yWOLe96ejBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=ZM6bum9N; arc=none smtp.client-ip=34.218.115.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="ZM6bum9N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1775313056; x=1806849056;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Yd6sQTlZ/axVirW+33+th8JF7Q56aRJ020B2qbnCbkw=;
  b=ZM6bum9NYCXpCN4iB3ZdSQ02Nyp7GrZ2wtrzG/LeOTXuBPue/yN/adAq
   Ait/KEWWv6TDdhid7wgjA2zqJX1ZRpstYx4nyf0hqtDLluyTDbTvP7rTz
   re9OQbF//NL0Qb39+GLeS2o0IwYBvxw8XKLmQ7P+JjG7jImaST//SueJ7
   7AZyXFyOckIVxj4TgXMW4zwaWzQjaNe6g23xN3u4TWTjcFPiPuxxOKOm6
   N9R7s52e9Rx3UZMRkLslIOMVxgXPrgi2upWD5BjUKziAYRd42zb2qrHbZ
   N3CjLzZDe7NpX9J6OGS11zcyffd859nhbY2t6U7FWKg5P+89zW0Jssbmg
   Q==;
X-CSE-ConnectionGUID: qrOs64ZNT0e8WZCuLa5uGQ==
X-CSE-MsgGUID: zgrBmgn2Sf+V6fMp6LnatQ==
X-IronPort-AV: E=Sophos;i="6.23,159,1770595200"; 
   d="scan'208";a="16352627"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2026 14:30:53 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.51:25133]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.2.226:2525] with esmtp (Farcaster)
 id 1c93d730-0eb9-470a-909a-12693c4553a6; Sat, 4 Apr 2026 14:30:53 +0000 (UTC)
X-Farcaster-Flow-ID: 1c93d730-0eb9-470a-909a-12693c4553a6
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sat, 4 Apr 2026 14:30:53 +0000
Received: from c889f3b07a0a.amazon.com (10.106.82.14) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sat, 4 Apr 2026 14:30:51 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: Carlos Maiolino <cem@kernel.org>
CC: "Darrick J . Wong" <djwong@kernel.org>, <linux-xfs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Yuto Ohnuki <ytohnuki@amazon.com>
Subject: [PATCH] xfs: check da node block pad field during scrub
Date: Sat, 4 Apr 2026 15:30:44 +0100
Message-ID: <20260404143043.65268-2-ytohnuki@amazon.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D043UWA004.ant.amazon.com (10.13.139.41) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The da node block header (xfs_da3_node_hdr) contains a __pad32 field
that should always be zero. Add a check for this during directory and
attribute btree scrubbing so that non-zero padding is flagged as
corruption.

Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
---
 fs/xfs/scrub/dabtree.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index 1a71d36898b1..73d5a3bd936a 100644
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
+				xchk_da_set_corrupt(ds, level);
+		}
 		break;
 	default:
 		xchk_da_set_corrupt(ds, level);
-- 
2.50.1




Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



