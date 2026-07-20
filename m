Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8116C3D6662
	for <linux-xfs@vger.kernel.org>; Mon, 20 Jul 2026 09:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784540789; cv=none; b=Fby408LPC7R2hCdPGW4bynrxUpqL0LkatRCdjJ725Qe89UKOstO4GbKVMxOj6xNfYuQpN3Cy068OIDdmZe2GkF60AM5O/fSlwm2AUfB5LreTh0wADGOOvBonv19P9lzHd5FPQyruDtfKgz8UTqloqueoMqlskTEt5NhgGyW0/NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784540789; c=relaxed/simple;
	bh=UnTegrTc3a9yrq0HQ9A8quNbb9q0ldWYLeqcdMdBnRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oL4EBvpJstFPLY1oZWJQy/0dsh5x6WQElkWAiBkCvGP9omyluOZWLhbujQWmM0dikjoviJ7/vRnVeLWfMGl93ECh1HIj0ocwIC1WjsgmV2nISakQvPNtFYPp7/7iRGxzVOlBD+owxTjOSUDX0QH6NvHSv8+pJ3HLvmJ553acsCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zuHsweIM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zuHsweIM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Zqhy3uJgcl//wpr81iVDQifLStDL/tc6SBx06/ieB6E=; b=zuHsweIMlyefLHC3VyVymHWTEe
	OjJBV/k3YenfKJWbSWqDnI+e2xpolVSuPSztk1C6GDx3a5i0x26E8kjYPAc5865Iub/7kxuSG5kQ3
	hcYimhk4H35kn14VXvBvRxth0rpyVwlHQkCRESS1TNjQng7fzubHaAGMSJ+ynRGtb32biuOb9mfUa
	WEKI9MIxkqLLoMUN1/nA7cd+Ai+whPgTYZnw7mgqVfPPTq3lIF4bROIbFqHLl8Ogpf+c5TQBrm1r5
	r8HAwW90V1gyXc0jFF2tYyiMVva3UvcbeB4C8P5iQhTIVPdAX5yS5nZGlLV3gF0I7E4IdExVX74fL
	ydBc/eNA==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wlkZv-00000006MiC-3MzP;
	Mon, 20 Jul 2026 09:46:28 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6/8] xfs: add lock annotations to xlog_state_shutdown_callbacks
Date: Mon, 20 Jul 2026 11:45:43 +0200
Message-ID: <20260720094609.2191633-7-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260720094609.2191633-1-hch@lst.de>
References: <20260720094609.2191633-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Sparse used to get away without these despite dropping and reacquiring
l_icloglock

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 0294ac277f35..2a34611d81f6 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -422,6 +422,8 @@ xfs_log_reserve(
 static void
 xlog_state_shutdown_callbacks(
 	struct xlog		*log)
+		__releases(&log->l_icloglock)
+		__acquires(&log->l_icloglock)
 {
 	struct xlog_in_core	*iclog;
 	LIST_HEAD(cb_list);
-- 
2.53.0

