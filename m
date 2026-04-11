Received: from pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.1.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5441314F9FB;
	Sat, 11 Apr 2026 14:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.1.125
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775917472; cv=none; b=kMtRFM7bXN7jbN7X/62xtbyUACUGZl35miXoLZtWN5/sGiZ8JDNMhq2e5QxH+Fr2YvnGuXfZNuClziiLsSIpfZ2pdkfVL7/x76wUXcwHlaztJOr7JsMvFOPtQE1/WjfGx+C25OE8at6fPTVL3wRkJ1/55vl+hy7ZDk+03YI1YoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775917472; c=relaxed/simple;
	bh=WHxN6DA7if4ozJXB6pxQnPWkPkq+ryrCJk5OidJDJmw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Uu1GsNllP8m7uOIh+u2aAyrUSmewkIwZjR7qTRqdqrU6NSUpEEAvpNToDS8lt2FpgEskeIjUUMjUUO8xzfGmOwOI08HhTSiX37OtWqxEJMIsMywoQ0f6kN5hT0Sc+a+FnZFc9Ez4nLJdRet9TNNrla+VhoY7m97Xv11Avv3B3jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=rZKD5CMS; arc=none smtp.client-ip=44.246.1.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="rZKD5CMS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1775917471; x=1807453471;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OM24NWY2VAPWGUtD9Oo33qraqjuZLWmqRB2hUTmG5OE=;
  b=rZKD5CMSy4eRhtfvvf+FyjwYujBuKD4gqVkMC9FQ/Sj2y3jQY5Vhge0v
   FF0Lloqreax0wQKCBJ0hQb496y++erF35ctYwDFOhoLe3G4ScNxElX1dI
   p/oXbM5jdDM1Fbzq8GZnx+Hv30zdV777NIBlIOhsY+900jaiNh/86JcCH
   iSObg6NQ8GSZq6nsdOAMlYeY5zA99DSUaghIWc51KY8BhtEW6pAc9tAWk
   JfXD2uVjyqp9oaZL1+cSm6az/4zdMa4RoVq03k43ArPBv+5SYteK3048U
   hBsobNdJLHv653mN2xbPpPJuMoEinjlhdMpY95GkhIXFvJHHAhWb6QQCB
   w==;
X-CSE-ConnectionGUID: 6nCUCmzGQY+zYM5j/c1hZw==
X-CSE-MsgGUID: A5XDahZkQzOytlQBIIRoTg==
X-IronPort-AV: E=Sophos;i="6.23,173,1770595200"; 
   d="scan'208";a="17075729"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2026 14:24:30 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:1504]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.60.232:2525] with esmtp (Farcaster)
 id 2ef1022b-2988-49b9-b668-b8f8b7401954; Sat, 11 Apr 2026 14:24:30 +0000 (UTC)
X-Farcaster-Flow-ID: 2ef1022b-2988-49b9-b668-b8f8b7401954
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sat, 11 Apr 2026 14:24:29 +0000
Received: from c889f3b07a0a.amazon.com (10.106.82.32) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sat, 11 Apr 2026 14:24:28 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: Carlos Maiolino <cem@kernel.org>
CC: "Darrick J . Wong" <djwong@kernel.org>, Dave Chinner <dgc@kernel.org>,
	<linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Yuto Ohnuki
	<ytohnuki@amazon.com>
Subject: [PATCH v3 2/3] xfs: zero directory data block padding on write verification
Date: Sat, 11 Apr 2026 15:24:14 +0100
Message-ID: <20260411142411.72194-7-ytohnuki@amazon.com>
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

Old kernels did not zero the pad field in xfs_dir3_data_hdr when
initializing directory data blocks, so existing filesystems may have
non-zero padding on disk.

Zero the pad field in xfs_dir3_data_write_verify alongside the existing
LSN and checksum updates. The pad field is pure alignment padding with
no runtime meaning, so zeroing it during write verification is safe and
has no additional I/O cost. This lets filesystems gradually self-heal
stale non-zero padding as directories are modified, without requiring an
explicit repair pass.

Suggested-by: Dave Chinner <dgc@kernel.org>
Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
---
 fs/xfs/libxfs/xfs_dir2_data.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 35ff119aa84b..aecbab61014c 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -382,6 +382,7 @@ xfs_dir3_data_write_verify(
 	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
+	struct xfs_dir3_data_hdr *datahdr3 = bp->b_addr;
 	xfs_failaddr_t		fa;
 
 	fa = xfs_dir3_data_verify(bp);
@@ -396,6 +397,11 @@ xfs_dir3_data_write_verify(
 	if (bip)
 		hdr3->lsn = cpu_to_be64(bip->bli_item.li_lsn);
 
+	/*
+	 * Zero padding that may be stale from old kernels.
+	 */
+	datahdr3->pad = 0;
+
 	xfs_buf_update_cksum(bp, XFS_DIR3_DATA_CRC_OFF);
 }
 
-- 
2.50.1




Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



