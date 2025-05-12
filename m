Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A58D5674E
	for <linux-xfs@vger.kernel.org>; Mon, 12 May 2025 13:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747055863; cv=none; b=Q2X37sKSN4/7bsU0wjPAEq9kPDKULewvgOBb5wqedgwF6DX2X9P7WTey3nFLj0h8IWWSCEEI7JZmx+8j8o8owCx7/4tUFdVeeruSQZr2rrHDmJlD1SF4ih8d7TaEuwqKYnFfXM6nBrzqqJvVmLCYf0OOKoBRMavirxfNdvcAxZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747055863; c=relaxed/simple;
	bh=N9eGFsKAiRcEbkkVkxYTj8dgFUUSPk+EvKIjHzOOcU0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jtiNY1Owffstcdw0AcjLdvMwkB6z1nWntn2B9rU5udPtBcHbFCgu404wVcsoKChPI+3xSGm7xP2vmcLVekWNGYD/BZssXn1TE+EiRdxu9Ss7yPPfU4ib1UA8SNPG1XVxXO4p/C7D6JoirxybJZL/h2hwUCuEQqu2S2bAgkNjqlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2Ox6ZR+U; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2Ox6ZR+U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=Fd8wl8fqNo1yQHXn8RMiBgsACS6ijhd5KvXb4sYo0ac=; b=2Ox6ZR+UDuVjYAFOZvvzDnaU8Y
	Eoe2XrmWELb3+8sajPrYgunGBc/k982qAMm12U3cybVOy/6YOaUJWde6I1yf7WMmNVg0pm1L+kNS3
	mc7NquZZNA9gE68r9GjoGTLdljC+NwShI3f3F6H/pq7SDAoY2AMwDbq8X4BpgWTV7lAmpfRSDfjV2
	bW4AlO5al5aFYrvYWupHiMbjqK0ypQjHsseGB0t9tvnrEi3qP+AVMrrtngc/xVUa9lQz0U8MA1Rcf
	elAAj8iPwxwOvbceQYnh3G+67E9xmhnFgrt4UPYSjZ+JezCmssb62/5qKX3zYQ5+8OSDFW1Qp9idC
	6U6cybrg==;
Received: from 2a02-8389-2341-5b80-6dec-1ead-dc3c-1d26.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:6dec:1ead:dc3c:1d26] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uET2K-00000009VeJ-1Nso;
	Mon, 12 May 2025 13:17:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: aalbersh@kernel.org
Cc: djwong@kernel.org,
	hans.holmberg@wdc.com,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs_mdrestore: don't allow restoring onto zoned block devices
Date: Mon, 12 May 2025 15:17:37 +0200
Message-ID: <20250512131737.629337-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The way mdrestore works is not very amendable to zone devices.  The code
that checks the device size tries to write to the highest offset, which
doesn't match the write pointer of a clean zone device.  And while that
is relatively easily fixable, the metadata for each RTG records the
highest written offset, and the mount code compares that to the hardware
write pointer, which will mismatch.  This could be fixed by using write
zeroes to pad the RTG until the expected write pointer, but this turns
the quick metadata operation that mdrestore is supposed to be into
something that could take hours on HDD.

So instead error out when someone tries to mdrestore onto a zoned device
to clearly document that this won't work.  Doing a mdrestore into a file
still works perfectly fine, and we might look into a new mdrestore option
to restore into a set of files suitable for the zoned loop device driver
to make mdrestore fully usable for debugging.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mdrestore/xfs_mdrestore.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 95b01a99a154..f10c4befb2fc 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -8,6 +8,7 @@
 #include "xfs_metadump.h"
 #include <libfrog/platform.h>
 #include "libfrog/div64.h"
+#include <linux/blkzoned.h>
 
 union mdrestore_headers {
 	__be32				magic;
@@ -148,6 +149,13 @@ open_device(
 	dev->fd = open(path, open_flags, 0644);
 	if (dev->fd < 0)
 		fatal("couldn't open \"%s\"\n", path);
+
+	if (!dev->is_file) {
+		uint32_t zone_size;
+
+		if (ioctl(dev->fd, BLKGETZONESZ, &zone_size) == 0 && zone_size)
+			fatal("can't restore to zoned device \"%s\"\n", path);
+	}
 }
 
 static void
-- 
2.47.2

