Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33ACD48CFC;
	Tue, 21 Apr 2026 05:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.68.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776750207; cv=none; b=jloiRoLZCojuZU3DGAdJthtDSVabM0qDy8HFlexTxOK3RH1CyGNLGsBLEHnjhzbU5kx2CWAYwIurofD9bnve3pa6lsN5fHgb5WVQmoQFkBFj4o7muhL2VTMy3EncAnWSQbTsdMVoZVh318cbtMjbRMM4v50wyA3R0Vkqd2ZiyyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776750207; c=relaxed/simple;
	bh=9jBu5Aar4na8O+pzqs+6zACjtzT3a2rRs5054X8M7iU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SJY4OPFbRG9AjOJGuP2JBWlKMvnsZ0F1U9XWgkhagPhiNicHZtuegrttL1/SWO+iXbVYzDQ6JEIfZK1ZIF3wZ2sowlEJAxkFMgOrFJQBZbWBM2TApNN+K/O0B/dgXBwUSJLmOW0JfYB5O8GeN1ETDvLzwYC4I86k/cAAC0APS+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=ANShlhj4; arc=none smtp.client-ip=44.246.68.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="ANShlhj4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1776750206; x=1808286206;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5iBfHp8uOU4h35XO5O+SHBuIAWzBwWV+ps2topgpwNQ=;
  b=ANShlhj4ASRP8j6b704F3DIkakAHOV/z6UfO+YlVCWyY+AXcDbJ2ziBr
   7IHgS7cPTgNXUROdKkVhfkAlVhl1VUWgMyqMXOMbCtjaYOjyGzq6vJ+CQ
   rwlKmegS3zQhAtz8rqqB+76XpHoZTjHGGpFwfGEslGrLPoTHmZ6+B26Wz
   Yn/aRs3db835qoLgylv8S7hPCN47I5v18Egcky0FbmtdPMMpoZjdibmIv
   +dotIOhVGz7vspHabJUjfjM9Rxvxa6CZUEZRcB1qtIHcTy8b0hXS1Iamv
   TWqqNWqj5bs1fvgnIipK6pwt+2HXyDdLpqY+kWIAovDwLDZrecdgbVMGG
   g==;
X-CSE-ConnectionGUID: eap77qYRTSeNnbOpqaCaDw==
X-CSE-MsgGUID: RtodH22WSEyuZCrd3FWIiA==
X-IronPort-AV: E=Sophos;i="6.23,191,1770595200"; 
   d="scan'208";a="17829179"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2026 05:43:23 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:30127]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.44.27:2525] with esmtp (Farcaster)
 id e154c7e1-ac83-4c16-9386-7a17ead5f9f8; Tue, 21 Apr 2026 05:43:22 +0000 (UTC)
X-Farcaster-Flow-ID: e154c7e1-ac83-4c16-9386-7a17ead5f9f8
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 21 Apr 2026 05:43:21 +0000
Received: from c889f3b07a0a.amazon.com (10.106.82.33) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 21 Apr 2026 05:43:20 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: Carlos Maiolino <cem@kernel.org>
CC: "Darrick J . Wong" <djwong@kernel.org>, Dave Chinner <dgc@kernel.org>,
	<linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Yuto Ohnuki
	<ytohnuki@amazon.com>
Subject: [PATCH] xfs: sanitize da node pad field on write
Date: Tue, 21 Apr 2026 06:43:12 +0100
Message-ID: <20260421054311.25301-2-ytohnuki@amazon.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D041UWA001.ant.amazon.com (10.13.139.124) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The DA node block header (xfs_da3_node_hdr) contains a __pad32 field
that should always be zero. Prior to commit a45086e27dfa21 ("xfs:
validate metadata LSNs against log on v5 superblocks"),
xfs_da3_node_create() did not zero the full header, so __pad32 could
contain stale data on older filesystems.

Clear this field in the write verifier to ensure it is corrected
whenever the block is next written to disk.

Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
---
 fs/xfs/libxfs/xfs_da_btree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index ad801b7bd2dd..f6054a47d24c 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -318,6 +318,8 @@ xfs_da3_node_write_verify(
 	if (bip)
 		hdr3->info.lsn = cpu_to_be64(bip->bli_item.li_lsn);
 
+	hdr3->__pad32 = 0;
+
 	xfs_buf_update_cksum(bp, XFS_DA3_NODE_CRC_OFF);
 }
 
-- 
2.50.1




Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



