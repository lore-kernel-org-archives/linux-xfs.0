Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD75A176242
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 04:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742391; cv=none; b=Q7PpLVU0FZB6BUO5Q2TOSfl7YZK8YXm3JdTS6oD7R2JzBI3PwuAh8rugAQHekK0O2tenPlvSOgp3giHRMWX1uhT+EsogjMMoghzPIX/otkVEdqRaFsRWE5kvQVnYOcBbbTrEWlW9BMn3XJTQcz+L9e3mblAMnW/TIGx/UisJnUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742391; c=relaxed/simple;
	bh=Qg7zG8yNXXa6NdpCkHhED5CRslTXrnIjOH2Pdlts8OA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eH1Yj2dl7u0P7m0a0DTho7i8hJMbJtklNPBpfbXUNB+DJp2u19TBelmXP2Vz67F7vqHirqqh3nJ7Sugt57za9z7VLITgmWNb8jN5s5eAuVD259/H4eUYS8hSEFf6C5WZcTcqySnW//ellJP3aWuP4z64jT3NjKPi3PIVixCYJ6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ky5qSJ7M; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ky5qSJ7M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=nqNe/Cb7E2v+gTbR51QijIhbj6axllhA5z3lHA7aty8=; b=Ky5qSJ7MzMbY2MEGf+rwNvAE50
	zntBX2Cs0HkRSdgF/z59nb+DmkXbQd43Zym/roD2+d1ruQrN48hL4QvzEk3Tfy+p33Q41tOvsucOW
	FRb2SM8llCcOcKfA4aMgBwcxmwTiRf444glgs6v60BgejYUtnRUWk5DC0d0IxIJDJh74CkGHyIHjO
	sx4H1wgJjny53YHab8LiomLZ/oRT2cKevMSm4YjllkWJejTrMUsAkSDBqvjX6eY5s4y8YNusGZTfK
	SxqVf4IVFdc5CmHO/3JuuxNEP1AVMI3yskc9EgSiZTbYYG7f0lxBfv3LMzpR2H9z8Bu44YB1q5ZqH
	oPUVTU4Q==;
Received: from 2a02-8389-2341-5b80-421b-ad95-8448-da51.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:421b:ad95:8448:da51] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tXC21-00000003ymG-0HzK;
	Mon, 13 Jan 2025 04:26:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: fix the comment above xfs_discard_endio
Date: Mon, 13 Jan 2025 05:26:26 +0100
Message-ID: <20250113042626.2051997-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

pagb_lock has been replaced with eb_lock.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_discard.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index c4bd145f5ec1..3f2403a7b49c 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -90,7 +90,7 @@ xfs_discard_endio_work(
 
 /*
  * Queue up the actual completion to a thread to avoid IRQ-safe locking for
- * pagb_lock.
+ * eb_lock.
  */
 static void
 xfs_discard_endio(
-- 
2.45.2

