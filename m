Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8211F23ABA1
	for <linux-xfs@vger.kernel.org>; Fri, 19 Dec 2025 09:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766135822; cv=none; b=mIsGr3r9N3QMafE2lJi8yu/1j4veNeoKtZElv+9OlmSTYS9GFxZ7F1DVXMpbOAjfBoDvfX+kagbnEc2OCw3arXQOwCjr9qdh3S3Vma4k/czKtbv9dxYNAAYU20YdXNgCib56XheqV53FJwKAKjClxAOQifYvw94njfSkOjtIV+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766135822; c=relaxed/simple;
	bh=El6G/9j44fP2ZtV48psePZD4Uh0fSAOEmOlTLn0v+TA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=erA8TsWTI2iFDDBoIAn+tdbc+7cjrzj5AUnB9ipmJ8ffA5+CgDbNa7zYs8KxwiRzH49/5n2aAXwcpYnjhOwre0RBW3hXKpPYOUS+iZel6L1OgMotNSCgCrD1iEHakJzK5fgUOePwN1gG6v5yli94Beu6qhiSzT/g8C+ll8daWFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U6bOnyMf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U6bOnyMf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82555C116B1;
	Fri, 19 Dec 2025 09:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766135822;
	bh=El6G/9j44fP2ZtV48psePZD4Uh0fSAOEmOlTLn0v+TA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U6bOnyMf3RatZoCIvW/ftQILSrNC/t15rh1pVnfcn2SRPTx7vld8OovlgdWeP3xmK
	 kL1UrDRt7RFhwvGvJJ2oslO/EHi0M6CgSB0yNNxW8tBFvyhhwLTxCrzhJh1Pgc8Ukq
	 2bf7Wf472wMsm6UPUKEZEIsbIstvUHDi02TR3g1O3porrcPFysregkKxKPmDQBv226
	 0yrsR6j0u6/S97cZeYEVr4xOngdfmZPH5D+1jzMfHmIApm4SX/WbgpwvVF6SWbAJcU
	 B68Av2A44XzhALAQz72gn8DE8jsIFvb2wMSyTh1IDrobBOS6w6hGQRgdf8hDjZat8q
	 RlxdzYroJ/yRw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-xfs@vger.kernel.org,
	Andrey Albershteyn <aalbersh@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 1/3] libxfs: define BLKREPORTZONEV2 if the kernel does not provide it
Date: Fri, 19 Dec 2025 18:12:30 +0900
Message-ID: <20251219091232.529097-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251219091232.529097-1-dlemoal@kernel.org>
References: <20251219091232.529097-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Define the BLKREPORTZONEV2 ioctl and the BLK_ZONE_REP_CACHED flag if
the kernel blkzoned.h header file does not provide these, to allow
faster zone reporting in mkfs and repair.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
[hch: split from a larger patch]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/topology.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/libxfs/topology.h b/libxfs/topology.h
index f0ca65f3576e..a6e69353f9a0 100644
--- a/libxfs/topology.h
+++ b/libxfs/topology.h
@@ -46,4 +46,12 @@ extern int
 check_overwrite(
 	const char	*device);
 
+/*
+ * Cached report ioctl (/usr/include/linux/blkzoned.h)
+ */
+#ifndef BLKREPORTZONEV2
+#define BLKREPORTZONEV2		_IOWR(0x12, 142, struct blk_zone_report)
+#define BLK_ZONE_REP_CACHED	(1U << 31)
+#endif
+
 #endif	/* __LIBXFS_TOPOLOGY_H__ */
-- 
2.52.0

