Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23E51EC00C;
	Fri, 21 Mar 2025 07:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742541731; cv=none; b=svgieLKyCbLVVCXPTOyhoJKkhgdZpYHSyPGMqfH/FDX9nOwpnO0B5eXBjNzNfS5zE3LVFQEu525okYY9iWJG6jLxOMpJj5xValPwiH6n2sO7d8t8kWFUvaSpGVMAJg+Z4eMOEg3xtIKvjGDZch8bAf3tUijn3ky5aU8kdXODasg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742541731; c=relaxed/simple;
	bh=eZRbMJS4BAnVP0zhVO2SbgQOnWJnNSHLUzd3/joIePU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XW2kLz0oeGHVr7K4PdGtyYUXgIxAMI91jBT9MQHiF2/IK8YuW7IhdZ0NaIHBwwllxpo9SeEbN0yV8sA4bgz5KbnpIfNRqUrgl8eAlJ/3fhuDGzA/zytp72THgkVyvj5niHJAtxTY3ddoTX091rWEZQX1eBFsbnwi9ue55jUB27U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=F84P+x9N; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="F84P+x9N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=DJE5XIeAyjJDQDJDYxVzZ9Ko35CYlbB+qGmXRE1M4YE=; b=F84P+x9NrAt+SCfKvGIK3Djt0O
	E10J59fLna7w/F5KFn6+I1zXP2piNx5USgDW1Xu1/1vVKrE7O1044Y5FQL4tea2Li9bbx8iRltCiT
	1VYPUT0NEuLT94jnAwNDmb/CwZNMzggDnDPc5t79PiVGqFV741H7Q5oxx3a9IG+ZHz9OqZWiILLm0
	qYrYmNCgwd6Fe0lexzJQAWru70e2kBmnMxS1IPzXWUda3+vIonry9/P31db6sTOre9FV1wtLVTJad
	x5GpwuvGTNdDK7seXnuWfStYg5wcJbgBvk9G/+ny2iWo25jJnOGaKkhNZ2ptG2TZ/kJdObhQ0r1ri
	itN7FK/g==;
Received: from 2a02-8389-2341-5b80-85eb-1a17-b49a-7467.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:85eb:1a17:b49a:7467] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tvWhk-0000000E5H9-3h5Y;
	Fri, 21 Mar 2025 07:22:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 09/13] xfs: xfs_copy doesn't like RT sections
Date: Fri, 21 Mar 2025 08:21:38 +0100
Message-ID: <20250321072145.1675257-10-hch@lst.de>
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

internal or external..

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 common/xfs | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/common/xfs b/common/xfs
index ccf263aeb969..d9999829d3b5 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1556,6 +1556,9 @@ _require_xfs_copy()
 	[ "$USE_EXTERNAL" = yes ] && \
 		_notrun "Cannot xfs_copy with external devices"
 
+	$XFS_INFO_PROG "$TEST_DIR" | grep -q 'realtime.*internal' &&
+		_notrun "Cannot xfs_copy with internal rt device"
+
 	# xfs_copy on v5 filesystems do not require the "-d" option if xfs_db
 	# can change the UUID on v5 filesystems
 	touch /tmp/$$.img
-- 
2.45.2

