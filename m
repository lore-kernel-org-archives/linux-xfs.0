Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E35336826C
	for <linux-xfs@vger.kernel.org>; Fri,  9 Jan 2026 17:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767979308; cv=none; b=NAUkUZpHsfeosIJOYHzj8vGfHDcJ4lS2fLWRArm46y+eBbO4r18rSx3Ooaab6xZHoBSPht9JmEeo3map29ApVl7ZLo9K0t5U+3Yjq7qVfxmJouX+tUcQJOV5Q6aY1h7Hcqx9rgUi6ThtZXl3+BD+8MlgYfPOow34JudiUFiE4P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767979308; c=relaxed/simple;
	bh=Lj3igUV+Cb1m0jqbI8PEs3OxTHSYa54zbabeA2JUKYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LY5GFhqBMyj02oob2XvlYZb0Vk9km0ceXtiEcIb1rjRjBbLa3TGv3a1HzuaOrAMIvXYSS2pGbGvVkI4VF6kbxTw6henQxrgdgBOSCQJDw3Hn3YgNMlm1yyUH9jFDfOJqyrZWBkfyVlM9BnP8zffGkIbweSCxrP7mwVQFPXz4vkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=g2v8jKxJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="g2v8jKxJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0dyTwJ8g21yPXkwH/XuQkgKxY5PBaIvrXcU1QaUL1ac=; b=g2v8jKxJuMgf0193nEZDDwx+jy
	Dp8euv0zAjmcHZxCq2c3gJv39y1eY+xlln+9uE0Lw3cQd0UJMu74E0vuRklc6Q23sjqpT3KtfC4IN
	s4h9m9uKwnu97E27CQHm6yyuv7b4Wcf8v3UoWeOyGiKUt/wC26BpBbUg11AgXaw6KC5YglW0hMmRb
	Kz4PStwxFIv9AMMyWsb7ircnBp9/yqUHhXaizjiIJUvLUjug7Q9g58pGRfQyw10Nrnput08rsMBYL
	9PJYhysZSXqo4pVevfLGsXsTijLMPwTu9aTV7YJKnmPJaZJAH9eGNu4SJFWu/zNZL/dcK9W6uS6r4
	AY58fAgw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1veGBF-00000002nXX-1pcQ;
	Fri, 09 Jan 2026 17:21:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/6] xfs: add missing forward declaration in xfs_zones.h
Date: Fri,  9 Jan 2026 18:20:46 +0100
Message-ID: <20260109172139.2410399-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260109172139.2410399-1-hch@lst.de>
References: <20260109172139.2410399-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

From: Damien Le Moal <dlemoal@kernel.org>

Add the missing forward declaration for struct blk_zone in xfs_zones.h.
This avoids headaches with the order of header file inclusion to avoid
compilation errors.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_zones.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/libxfs/xfs_zones.h b/fs/xfs/libxfs/xfs_zones.h
index 5fefd132e002..df10a34da71d 100644
--- a/fs/xfs/libxfs/xfs_zones.h
+++ b/fs/xfs/libxfs/xfs_zones.h
@@ -3,6 +3,7 @@
 #define _LIBXFS_ZONES_H
 
 struct xfs_rtgroup;
+struct blk_zone;
 
 /*
  * In order to guarantee forward progress for GC we need to reserve at least
-- 
2.47.3

