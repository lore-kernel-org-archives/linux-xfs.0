Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A8D4B1CF6
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 15:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790349677; cv=none; b=udnVV3R2GumeggQCV29QNak8msgtnX++/3VeyRptqffjeIqHMq/2CuSZD2ZPW1Jbk66BcTttwNXv7O1vKzWIb1DxabmeciEmXTjGFBxgd0Lw6u3Hphik3+F6lDl3cjg4cAanF5uou9a5+diXZJ04XfxZPMKLFKqSK8N0lemnsAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790349677; c=relaxed/simple;
	bh=OIq3tO0g2MBPFQA/PK/8YqIzETeEOJZLJUc2L4JSIyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fbXap8CzP0vKntJ5XNPxz/KbwkYPoD+SIasQARMXd9UktOF7R0lH8kUFdBp6eoTOAMOBMrqPZi2Lb6cFzte4YIzeU70hR7fP5G2/h9ZIrvaM6nh5V11ShAfYLiGLrZie/XqV+Uc/aZ0AMhZUo0cjKAIbU1GMCy135wTTjBfdxQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AhHBtSYn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AhHBtSYn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5VPwDKxNjEu49QIZDa9QwujF1VhFVs3xN3uyRNQJ+Vg=; b=AhHBtSYnVY8HXLhVbcid+d67UT
	prctN/5xlEJav0iXHn/QRujjryjL+sgLd6iADvfh+V/VgjwGbmIISjbeQH+8e8QwuMiI0KHdMOHyd
	JFzRTz8IK1Iz9HQfq7qxqMTaBoQkWTaHGiiXxkOulRxkSpStFeLq+gn+f+k+VLHRWvQgQ2QwDT8SJ
	6qWqd4oPR/y74TU77Zm9OPIRy4ufqo+UblmKcXUgiT6alkvzY+FQRjjQ1LvzyxOkrAGSiGZ1ZyBFJ
	HKiyUkJrwZesRl/zt/VGI6Y3qSYHzN47Efx3IxzRTLd87nrdnOYWHt/sZHc/qP7HBFbQP2ZS9zYOe
	un42V8Sw==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xA7je-0000000DlbZ-3QJP;
	Fri, 25 Sep 2026 15:21:15 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 02/13] libxfs: provide memalloc_nofs_{save,restore} stubs
Date: Fri, 25 Sep 2026 17:20:21 +0200
Message-ID: <20260925152107.3386097-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260925152107.3386097-1-hch@lst.de>
References: <20260925152107.3386097-1-hch@lst.de>
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

