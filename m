Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9B222B8A9
	for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 08:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739866428; cv=none; b=tJ885RkpxLqQutVdz9Sp//hnYO/gJ9x1LO9sKSIT5TAhDBMTSTyQhz4Ih8OZL/hLdEWLflMvdNg9kvJ0Xlt+GnRGOV4sRARBNzIx5Mn9ie64f7xUIV89KRnX9S+Gpwaqi6VSf8IAjmADXTPaNu44KrFNysrImHmlFBvgwHhzN1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739866428; c=relaxed/simple;
	bh=9FR5O3Zf40DoRs02j42WH/1fuALbmK7Ki9JIEs7mwD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQepqeYQONDF0Nm65YF/g78hB+nACDLykXrjntUsiV8lGYiGlv3n1ZI0bPFS4uH+sE5H0JAvsOgsi/kkfZSSHbDrLCiN2BADoIbNQCOJFjS7EnTTGr65nZcgE3vf02WZrHYUbT4Fx0b+sr5KCq+4ZQ5d1XKBnqVKCP+i4OwyZ4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xIHk5N41; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xIHk5N41"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Z4g3kKDYAfcy3DLUAUmQHLlacdPtbIqAo/d4L5lGXVw=; b=xIHk5N41yNMIDc7qB3P1Ys/TGj
	s95MqNDPdFlOBXUzDMz+5K+cjQ7C/gnlK2egSse1dYWZuk2paPjQ1Dqxmz3pNXP1Xj+QSqoBAOmJB
	WP3SpaDuTCT2J4q+izcHvltxYQTbhSUwcmYQiiX2/rEDZhd1qLEBUjUEQ7VSpK0k33/XBOHmj7t/2
	pUbjM5tVx5ico8ys5/VsGrskalUAt5p81wWVdm1kKpdY/I57totJyVSRfSE4Y2Xl5tFx7HZgf9D+V
	wSimJa5PJBEUnwo/hGkfSh849SzU4jztOQAUmfpl6gzWsIHhhhsCaTSOchJv4EY2IxnHmt4rBTUqs
	4FrpkTUw==;
Received: from 2a02-8389-2341-5b80-8ced-6946-2068-0fcd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8ced:6946:2068:fcd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tkIjh-00000007CnP-2fZ7;
	Tue, 18 Feb 2025 08:13:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 36/45] xfs: disable reflink for zoned file systems
Date: Tue, 18 Feb 2025 09:10:39 +0100
Message-ID: <20250218081153.3889537-37-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250218081153.3889537-1-hch@lst.de>
References: <20250218081153.3889537-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

While the zoned on-disk format supports reflinks, the GC code currently
always unshares reflinks when moving blocks to new zones, thus making the
feature unusuable.  Disable reflinks until the GC code is refcount aware.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_super.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index b6426f5c8b51..4ea7150692dd 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1829,6 +1829,13 @@ xfs_fs_fill_super(
 			goto out_filestream_unmount;
 		}
 
+		if (xfs_has_zoned(mp)) {
+			xfs_alert(mp,
+	"reflink not compatible with zoned RT device!");
+			error = -EINVAL;
+			goto out_filestream_unmount;
+		}
+
 		if (xfs_globals.always_cow) {
 			xfs_info(mp, "using DEBUG-only always_cow mode.");
 			mp->m_always_cow = true;
-- 
2.45.2

