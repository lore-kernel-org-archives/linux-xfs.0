Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9986D2FE577
	for <linux-xfs@vger.kernel.org>; Fri, 19 Dec 2025 09:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766137360; cv=none; b=jPQpg0HyB3I8FSb/Dfgq8p8SFmw7gjLkcgNZnH92s585uJkD1qpgI5RqOPfSPWY5C4dEQWq5oRpOwdQC1w9rH/1firtMyAafTnwAcvPZU6TnyvYf0uS8xqBPnP9LwQJRF8/U27dbcolK3CNzmR6ao6++nJ0YdERf9T7acMDxjDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766137360; c=relaxed/simple;
	bh=El6G/9j44fP2ZtV48psePZD4Uh0fSAOEmOlTLn0v+TA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I2E5umLMv2LPLNs8yfiWcR7DcyrMxaBAnpqBhGw3hyzFt1QBj7+AMWluyuyY9Re7SsOf4V9f1YlzugB6OmycvyKEsxdlVTjjrQippFwpkcIroegB+ka7H+agRCwCgP0Yy4v7pN3vteccJ1lMhO4+zOXmQCZC7ZD2yL3J5c+nvek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jrng8gwL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jrng8gwL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B048C116B1;
	Fri, 19 Dec 2025 09:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766137360;
	bh=El6G/9j44fP2ZtV48psePZD4Uh0fSAOEmOlTLn0v+TA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jrng8gwLir8wBpeuPuP+IeAJciBgY61ic7lKN4sAkVOpUU5FPxKUQVB1TI3K3Wrl+
	 BIlsPVHbnt0sPYTybfDOlwkTze1uqhAR9T0Pw6od7Xr7wexFpj1+yYlFs6FBKmxygg
	 aKyqFCpHWEPOamgcFQm3hcMBBd4l4gGRlF1cpYEDLL5rvv93YXUTA60IufXKwoj9Vh
	 VKrjHQ1S+m71xVP5rt7/Jme/HKlEViGgy1CEJFTzqASCZoelZbAf+7ESEA2JUQl/+K
	 7pPL9gKY9mM7j0BkI4Fzdvsl1QcE0NdiK/UxLyDddskpmY+KEj/+10Qz67XldlU4M/
	 F4l5OGyCd3FdQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-xfs@vger.kernel.org,
	Andrey Albershteyn <aalbersh@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH v2 1/3] libxfs: define BLKREPORTZONEV2 if the kernel does not provide it
Date: Fri, 19 Dec 2025 18:38:08 +0900
Message-ID: <20251219093810.540437-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251219093810.540437-1-dlemoal@kernel.org>
References: <20251219093810.540437-1-dlemoal@kernel.org>
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

