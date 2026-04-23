Received: from pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.26.1.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CDBA3BD631;
	Thu, 23 Apr 2026 08:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.26.1.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776932353; cv=none; b=WTvYGwsxQhYTuyjqNTjXSabCXfemTtckp7qgaURFoRyDnYFx3hz4JxbzLr554JQmg+XD9plcyyXOpQl7HlqSKB7KeFvqBOnXweVEqZV6FzpbMmJTN+d9tL07s1zjLCZlLzgFhMv2BMaQfphd9SaAPZZdgdZJAq1yZ1MHSNBtnN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776932353; c=relaxed/simple;
	bh=LN3XKSzEfkd6Sni7halAKuY1mD8eY9hM3npYoWbszTA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WjaWXD040QPtWxuqAa0nDfzRjHBn9fjr3NkjA4jGdC5Nz4aj9qn2qYxm3OsKcUAynSKjAA2oP2k/JALyBDAp1CmhUti4cKfTUzI2ubka43a5JnxfjRkqXdc1PU/eT5Yy252EJWRQ/bweJP2avEERR9H+tnoWAntCsf7qxnFVtEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=nByFV1nI; arc=none smtp.client-ip=52.26.1.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="nByFV1nI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1776932352; x=1808468352;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fQtOHpdpeB4D4wfng89GBKwK9ArXTo4aUw+P4DFOTqw=;
  b=nByFV1nII7hJ3TR2Ylph5wjc+csLm5EQMM3YXDb5RK/021rJSQK4+wC7
   czSTXsrKNr0K7Z5jhssx/051hXZs9WoTiFAiPpSfzpQu69HMxTzwYWD0U
   HBkTQogGpS874Af7xis3Bo0UxJ+9zF2UTpScF8LhAJma6qPVewGdFNTyY
   qAgaFgTE7bM3f3zPCqn7e39aUEFDMGHXwmGY+6F5HtA7JDe+VwKtAcKQw
   LBJOOh9t8YEwRCg2O8jrUVoVWPgN2L46tNiQMcN4c5sojxXM9fA/qHi2n
   RUt6lppPDPrE/srJimVyV40bS/eEj+2kurHWMp2VasoE4cOafxXKfRjk/
   w==;
X-CSE-ConnectionGUID: 0URuc1wrSRaLAqjU4/KFxA==
X-CSE-MsgGUID: 4kOFdjUWQXKTESYYqvPwkg==
X-IronPort-AV: E=Sophos;i="6.23,194,1770595200"; 
   d="scan'208";a="18034751"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2026 08:19:09 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:14446]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.3.51:2525] with esmtp (Farcaster)
 id bae9136d-37fc-4249-ac57-9553dffa3f1d; Thu, 23 Apr 2026 08:19:08 +0000 (UTC)
X-Farcaster-Flow-ID: bae9136d-37fc-4249-ac57-9553dffa3f1d
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 23 Apr 2026 08:19:06 +0000
Received: from c889f3b07a0a.amazon.com (10.106.83.12) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 23 Apr 2026 08:19:05 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: Carlos Maiolino <cem@kernel.org>
CC: "Darrick J . Wong" <djwong@kernel.org>, Dave Chinner <dgc@kernel.org>,
	<linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Yuto Ohnuki
	<ytohnuki@amazon.com>
Subject: [PATCH v2] xfs: sanitize da node pad field on write
Date: Thu, 23 Apr 2026 09:18:44 +0100
Message-ID: <20260423081843.32405-2-ytohnuki@amazon.com>
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

The DA node block header (xfs_da3_node_hdr) contains a __pad32 field
that should always be zero. Prior to commit a45086e27dfa21 ("xfs:
validate metadata LSNs against log on v5 superblocks"),
xfs_da3_node_create() did not zero the full header, so __pad32 could
contain stale data on older filesystems.

Clear this field in the write verifier to ensure it is corrected
whenever the block is next written to disk.

Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
---
Changes in v2:
- Added comments explaining why __pad32 is cleared unconditionally.
- Link to v1: https://lore.kernel.org/all/20260421054311.25301-2-ytohnuki@amazon.com/
---
 fs/xfs/libxfs/xfs_da_btree.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index ad801b7bd2dd..4edbf4bb5c7f 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -318,6 +318,12 @@ xfs_da3_node_write_verify(
 	if (bip)
 		hdr3->info.lsn = cpu_to_be64(bip->bli_item.li_lsn);
 
+	/*
+	 * Old kernels may not have zeroed the padding field in the header,
+	 * so clear it unconditionally to sanitize stale data on disk.
+	 */
+	hdr3->__pad32 = 0;
+
 	xfs_buf_update_cksum(bp, XFS_DA3_NODE_CRC_OFF);
 }
 
-- 
2.50.1




Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



