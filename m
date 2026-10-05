Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DA7481A94
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 12:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791205009; cv=none; b=W60tLCrHolTSNLtcwRU2+i1UboVb5Tt70523zvKhgLDPcU0gKD2CjBRDaKe8C1NQ3H01SbWW09n3gecIvaLZoVLaO88q62De0ehYaTjpzVBloZ8NpxzEQv/OUzRvp2yuy8vKrqkmM1k4C3o37iWWLc/73imajMYo/WRqN3M+L7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791205009; c=relaxed/simple;
	bh=OIq3tO0g2MBPFQA/PK/8YqIzETeEOJZLJUc2L4JSIyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SJV227Ios/XxpgTnX7y5qYyCPuEhGWmRv/dDa4NDEoi8TqFUAMi28bhnSsrnvnWCc19/m1UkI1gMKwGkqpwhQrPxsiLVLtmUdizr1kfaMLnK+TaNE34BhIcksCiLSHfGdC5epAeSSl/3hoI9HJwOgfeqIrYyQ5LFMDXw6OC/0uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sBlepqcb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sBlepqcb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5VPwDKxNjEu49QIZDa9QwujF1VhFVs3xN3uyRNQJ+Vg=; b=sBlepqcbP7zt91XKgXKApqzVqk
	lg95n/DdAvVdG97sdUoI984mVoU/i5+H4wH/vErXEshHqX5E9JLeWSZoXl1wvlYFWaPsYjAweBPyK
	96dW6Rl3KgCzHnrhtImpFx0d9c5exBCBy6i/Kb88UJXJoGeYYn+bSAsHwwQ4um7KxiaUcQ0a3e5gC
	q38Ulc8Rh+jM06dTfrBWgWTPdnOYl0OUXusKR8w2UjogKcSi3uXhOARdkswdwnfCY5vNvXxPxxKAd
	k8SkXdcWcYyO1oRU2Zn93/6sbnQefkZe2uRvPcFLsfn/7N4Dd7+qq2PuQoc918S7Ebs8+PSLaumgP
	N0e+NAog==;
Received: from 2a02-8389-2301-9f00-88fd-fcdd-06aa-821c.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:88fd:fcdd:6aa:821c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xDiFK-0000000GR3v-1Ox5;
	Mon, 05 Oct 2026 12:56:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong " <djwong@kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 02/13] libxfs: provide memalloc_nofs_{save,restore} stubs
Date: Mon,  5 Oct 2026 14:56:12 +0200
Message-ID: <20261005125637.1340355-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261005125637.1340355-1-hch@lst.de>
References: <20261005125637.1340355-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/libxfs.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/libxfs.h b/include/libxfs.h
index 7f0c22ef4991..549176cf0b2c 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -54,6 +54,9 @@ struct iomap;
 #define unlikely(x) (x)
 #define likely(x) (x)
 
+#define memalloc_nofs_save()		(0)
+#define memalloc_nofs_restore(flags)	do { } while (0)
+
 /*
  * This mirrors the kernel include for xfs_buf.h - it's implicitly included in
  * every files via a similar include in the kernel xfs_linux.h.
-- 
2.53.0

