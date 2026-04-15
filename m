Received: from pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com [34.218.115.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278B43921F8;
	Wed, 15 Apr 2026 07:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.218.115.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776237164; cv=none; b=XgC/J2pRBiGjV0FY54LzQRGWWqfVZOzu4ULqAnHj+A7SMFNFoiC5ZNiazWw9wXTphiMCUYK1gIQpbFxhWi4bX+PYjl+btzVTYC0oLzfi448pBO+a7s9VR4SxPxBUrvwzBig7reEZViAm9phaRseBDjlHdw9OP7a/uiFJsRP23P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776237164; c=relaxed/simple;
	bh=AiP5O8kzvzPUdzVPgscxMyaevvVeyFKIShfeMs+slQQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kXoJzhpGbMnfa+LczIsjfXlOnNLznoFCDocAFTS8GqlOsYjzv23amFvlbE6mVajwrWCG9ZAvhiJvArfF4bxOJgnklUn/6OrrxMObD/fpJ/oswz/mSG56QgGqeh5MuKMwjKfqWgG2FnryQTmlbfncRebiQS6kmMe/Jkd04t9aD8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=CCYs2ll5; arc=none smtp.client-ip=34.218.115.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="CCYs2ll5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1776237163; x=1807773163;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=SYSoivwX3a6sIKInsL6gsZBdmsyzkxOOQVo/BKpg5D8=;
  b=CCYs2ll59RpSoTdpW2Gjz/k/S1TcQ4tcGQ+WjSdxnR0F3Oc2FjZ24LVs
   nrGDSmbrdaNzqloyH2589B11lBwA9C3m1LMTeKkKslEHqRnWpN3hfbKKL
   ONHdwCJ0GfdTmkgc29eaBxfveFGpIrCoMP4K+hxK3yjIWdsg0wp3uPSuF
   EbNzm7B5nFtwGAW4Y6OKV1/zWkRlPRLk6yRQNpV1PXPom/onAxXspGLOV
   pLKv9OoK3jazCShyyOQewclyz4IZKEJphEHU5SN7k598rrszKe1SnDdBm
   j6PDs0pC1+Vs0GSAwXpxYoY8z7p70AtJrTmvlJuY9Pl5o9RwDWdS8AdOR
   g==;
X-CSE-ConnectionGUID: QgpUZyeNS9aBdoeg8htUzQ==
X-CSE-MsgGUID: DVFz9tvaQeCrrXHLVgT/0g==
X-IronPort-AV: E=Sophos;i="6.23,179,1770595200"; 
   d="scan'208";a="17141567"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2026 07:12:39 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:14928]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.25.2:2525] with esmtp (Farcaster)
 id 27fb743d-9600-4e50-beb2-a6785a809762; Wed, 15 Apr 2026 07:12:39 +0000 (UTC)
X-Farcaster-Flow-ID: 27fb743d-9600-4e50-beb2-a6785a809762
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 15 Apr 2026 07:12:39 +0000
Received: from c889f3b07a0a.amazon.com (10.106.82.9) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 15 Apr 2026 07:12:37 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: Carlos Maiolino <cem@kernel.org>
CC: "Darrick J . Wong" <djwong@kernel.org>, <linux-xfs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Yuto Ohnuki <ytohnuki@amazon.com>
Subject: [PATCH] xfs: check hash ordering in xfs_da3_node_verify
Date: Wed, 15 Apr 2026 08:12:24 +0100
Message-ID: <20260415071223.48609-2-ytohnuki@amazon.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D037UWB002.ant.amazon.com (10.13.138.121) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The DA node verifier checks header fields such as level and count, but
it does not verify that the btree hash values are in non-decreasing
order.

DA node blocks are traversed by searching the btree array for the first
hash value that exceeds the lookup hash, which requires the hash values
to be ordered correctly.

Add a hash order check to xfs_da3_node_verify, similar to the existing
validation in xfs_dir3_leaf_check_int, so that misordered node
blocks are detected as metadata corruption.

Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
---
 fs/xfs/libxfs/xfs_da_btree.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index ad801b7bd2dd..ef49df22899e 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -225,6 +225,7 @@ xfs_da3_node_verify(
 	struct xfs_da_intnode	*hdr = bp->b_addr;
 	struct xfs_da3_icnode_hdr ichdr;
 	xfs_failaddr_t		fa;
+	int			i;
 
 	xfs_da3_node_hdr_from_disk(mp, &ichdr, hdr);
 
@@ -247,7 +248,12 @@ xfs_da3_node_verify(
 	    ichdr.count > mp->m_attr_geo->node_ents)
 		return __this_address;
 
-	/* XXX: hash order check? */
+	/* Check hash value order. */
+	for (i = 0; i + 1 < ichdr.count; i++) {
+		if (be32_to_cpu(ichdr.btree[i].hashval) >
+				be32_to_cpu(ichdr.btree[i + 1].hashval))
+			return __this_address;
+	}
 
 	return NULL;
 }
-- 
2.50.1




Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



