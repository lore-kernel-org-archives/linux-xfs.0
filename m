Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B262BD04;
	Wed, 12 Mar 2025 06:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741761980; cv=none; b=Mg4+LtJ7N+NL1Q1MAve6lB8Wn1AuP60+aB4t4/KsRwfu7FpSr5D0Zt0g7g1OK45SQ8gfeoujOvt4kpXedaPZr6+ROX0B23b8+1XrG6rXwdB7k+KUmpGDLEzzsfTXHkflJ1XKVMKXTOq+y67PbbndDwthECkIyE34j/TjmJ0LcoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741761980; c=relaxed/simple;
	bh=q1Kcq+rUyPgX4uOQTsir7qgmyP3zf+2z6Xsjt60s2xY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UmCpQo04Idzvq8pqlUf+oP/m+wGEWnYM46tHzQdHNJEnrbfKKyGc6M4n5mdev+waj1b0jscTqO5aXcXsMAaxIqDNTqksU81apur9Fg+smWpJrkFM8gjO3WExVR5mgJdQkQmMTIbaEbkp+PDe2r8jg2AYA8mthxCX7UXUOabeMkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gPq0Es55; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gPq0Es55"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=2059WEcHa65hXCx3Ivv7mvrmkON9tnHf2OL0ocGIyyc=; b=gPq0Es55nii7xg41m7AZFTQZ2a
	JxmchLzz2Gv63PJByJgQH9KshWhSqhdxCiR19JLm36slqmBzUaTYq6VoF22I5k4E27RyAf7jIl8yl
	oD9yjK5ZH61DLPsXpasIz3FnNTSnw/45UafVE2Tiw7w9FpxClI+/x+x41g7d2RvB5YvEn73w3BKlb
	EzV/0rIs7aCn6PqF4aB90QJ8RZjIcxcBs0AcH3NBdINItlvjM1PXotJo0+IG5j7mKYUV0g8p9qlDD
	5z8gy3iIU+drwcgp5NDj0hV+rWTSxemIRk/3B4UN4bBdgZ5a5G33omLiccaLzvHFpmlPifzPrg26h
	pstt2+Qw==;
Received: from 2a02-8389-2341-5b80-f359-bc8f-8f56-db64.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:f359:bc8f:8f56:db64] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tsFr8-00000007ctY-1xZ8;
	Wed, 12 Mar 2025 06:46:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 13/17] xfs: xfs_copy doesn't like RT sections
Date: Wed, 12 Mar 2025 07:45:05 +0100
Message-ID: <20250312064541.664334-14-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250312064541.664334-1-hch@lst.de>
References: <20250312064541.664334-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

internal or external..

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 common/xfs | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/common/xfs b/common/xfs
index 3f9119d5ef65..7756c82cf0e5 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1561,6 +1561,9 @@ _require_xfs_copy()
 	[ "$USE_EXTERNAL" = yes ] && \
 		_notrun "Cannot xfs_copy with external devices"
 
+	xfs_info "$TEST_DIR" | grep -q 'realtime.*internal' &&
+		_notrun "Cannot xfs_copy with internal rt device"
+
 	# xfs_copy on v5 filesystems do not require the "-d" option if xfs_db
 	# can change the UUID on v5 filesystems
 	touch /tmp/$$.img
-- 
2.45.2

