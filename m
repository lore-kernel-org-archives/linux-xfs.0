Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC9E1E9B1C;
	Fri, 21 Mar 2025 07:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742541712; cv=none; b=qJU52mhCyXTlluPt8143689yruF/lvXM9/DJ5d7H/1z82fCMsv5y1WpGweI59sAYfYCQ5KzHHDuENNGUzbzmUpJsigwka6fvZ32tGL8dENTG2JFmlnKerfFwn3dzySo/CZLL5vDSEzB90+3NQrEwh4y8vHaa8GyLCjplfNxNeqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742541712; c=relaxed/simple;
	bh=yGaIlq4gvov3ZHwbjzKqHlgpFDLtkRwnWdfFRiQwWZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jF4TZl/qPZxEJqpk+4Ipxz0k+ybWocChuZUhjquo/FfqNxHZnYKXdEs++VvZ4pS1PBXGg6T+dI8KPYldEda57zst5n/VQcfNxgtcU36XEQQBLUAZV/KYROpvxVo5/vbYIyyawtczXpcS2pgUX8e3yAMltRsWkSXgovr+OMKAGts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AiPAoZeT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AiPAoZeT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=LLSs537/c+e20ke0v7q9Q2ZY994B88jrs+fyZlTXeKw=; b=AiPAoZeT6Be5x46evyw0U7NENH
	jcdrcw47ewSBo7Mr9bcybLRhJLsooR3ko0umH7FJN8IqVRZFznOhMR6weo6ogddrkdbsN3CkcsfJP
	K856ssQUio6RnFrVp4vVcKjbBJmN0vSllBulJhVkmorCmE1rA45FxxBi3OKfonLofRrqn+/K+CUjz
	BBtKsHmInxsgYJsuQEAI4UCCyqJS+Gb9yQjkUcFNd9SaOTQelpScw+ks3ZsMKpskkmzcSQr+3BAL9
	EhH5CG9JB+cqPbdSpSW7gwELxTmlT0jrCW6XXSepT509rOsnjL63ItSn9c6CD8PX8jsYgPSdtquRf
	JILJi8pw==;
Received: from 2a02-8389-2341-5b80-85eb-1a17-b49a-7467.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:85eb:1a17:b49a:7467] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tvWhS-0000000E5BE-0Tnf;
	Fri, 21 Mar 2025 07:21:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 01/13] xfs/177: force a small file system size
Date: Fri, 21 Mar 2025 08:21:30 +0100
Message-ID: <20250321072145.1675257-2-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250321072145.1675257-1-hch@lst.de>
References: <20250321072145.1675257-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This test make assumptions about the number of metadata inodes.  When
using small realtime group size (e.g. the customary 256MB for SMR
hard drives) this assumption gets violated even with modest file system
size.  Force a small file system size to side-step this issue.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/177 | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tests/xfs/177 b/tests/xfs/177
index 82b3ca264140..8d23f66d51b7 100755
--- a/tests/xfs/177
+++ b/tests/xfs/177
@@ -77,7 +77,9 @@ delay_centisecs="$(cat "$xfs_centisecs_file")"
 sleep_seconds=$(( ( (99 + (delay_centisecs / 6) ) / 100) + 1))
 echo "Will sleep $sleep_seconds seconds to expire inodes" >> $seqres.full
 
-_scratch_mkfs >> $seqres.full
+# Force a relatively small file system size to keep the number of rtgroups
+# and thus metadata inodes low
+_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full
 _scratch_mount >> $seqres.full
 
 junkdir=$SCRATCH_MNT/$seq.junk
-- 
2.45.2

