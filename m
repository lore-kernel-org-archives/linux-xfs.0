Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5693988E3
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871383; cv=none; b=Nir7FUb8HbgYH69ICsrqCpmvBdwFKUBn7fqiPOj/WXkynClH1axZyKmCYPsNppal76pXpt/2PiaBSbV3S8MWGTOI88dJWpmKxsredJT2cTFj2YLK+AVi0aiNlq6MC+byf7brjRQyJiCZdZzvKdw8+CnuhyEqG5Uyzy7vb+V7P7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871383; c=relaxed/simple;
	bh=b+s/Tgq2K4rlOwIgDVYnaZ6Cr1phxgpMo5ABDl6K+nY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7z3uW/6vyziRwSlp0OifXyFPXsXIJ1xBGRnayYrfWHjzcujCdYgpkorNJoT43+5fKn1hBfHwfNHHC/MxFImsu85p8UgJJUz5gPUV8+2wsjGX7hA3bNCXz1G7Jgpx9oy/+ZEfBgilaMjdehcAGNyJ8OOBTc4nNKyOlGj3V5zmNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JMFZpnrW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JMFZpnrW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 070571F000FF;
	Tue, 13 Oct 2026 06:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871382;
	bh=XGBj+t7oyBUARQha2uxq7yPCbL/BoPNadP/HFQTBqKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JMFZpnrWxVObNwpBEOYBzonk7oVBmAwsI+P5hGSB58Uzs4JkZAaxhWVMP+uJwf/W6
	 SzyiXT80URLfwZmPjQhuzgqHgBsKECBOBoQWaRF6Wqaux3R8F47iz8avDIxEm20vqQ
	 VMCz5TUD/YDUxUlIkM8yxuCF5KSPdPMAcNGjIRK6TEuwJBk6hCKhSGHzTAfOQZ56cK
	 iWXIpeRQgMJocCNPTzFCWm48ksJ3NdibtjdmvW39r4iJtEaCYFHJBSkz3kS4RXE/aS
	 Kk8Fsx7ZNjnSHSLF4OfeNHnZahc+Gw+cE6+gIbchPMwy+mTjWnDe9mgwqSKJs/Rfr4
	 5rniuBa3DnjvQ==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 43/48] xfs: validate buffer item region count during recovery
Date: Tue, 13 Oct 2026 17:01:33 +1100
Message-ID: <20261013060204.3138690-44-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013060204.3138690-1-dgc@kernel.org>
References: <20261013060204.3138690-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Validate the number of regions in a buffer log item as it is decoded from the
journal. A cancelled buffer logs only its format header, so the valid range
spans the whole range a log item can hold.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_buf_item_recover.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 57929f115055..52253b426166 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -1173,8 +1173,25 @@ xlog_recover_buf_commit_pass2(
 	return 0;
 }
 
+/*
+ * A buffer item is a format header region followed by a region for each dirty
+ * range of the buffer. However, a cancelled buffer only logs a format header,
+ * hence the valid region count range spans the entire range a log item can
+ * legally have.
+ */
+static int
+xlog_recover_buf_nregions(
+	struct xlog			*log,
+	uint16_t			nregions)
+{
+	if (nregions < 1 || nregions > XLOG_MAX_REGIONS_IN_ITEM)
+		return -EFSCORRUPTED;
+	return nregions;
+}
+
 const struct xlog_recover_item_ops xlog_buf_item_ops = {
 	.item_type		= XFS_LI_BUF,
+	.validate_nregions	= xlog_recover_buf_nregions,
 	.reorder		= xlog_recover_buf_reorder,
 	.ra_pass2		= xlog_recover_buf_ra_pass2,
 	.commit_pass1		= xlog_recover_buf_commit_pass1,
-- 
2.55.0

