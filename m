Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2DF286D5E;
	Mon,  2 Feb 2026 08:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770022631; cv=none; b=LpRc8ifpuqLcesKyZNCVreB1VL2uuyNFDDbv07Z2KhXSFr2fOq2J5Kg41o8ihBDCSy/3AErmehfNIC17oA3mLv83ufxQEUdTUymNWRff4s05gCDe0W4GqDdk5VUkY1DVLQAy7k1lToADTsP5hYhfi1Ao0Lhrio77CPRVJZt7fZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770022631; c=relaxed/simple;
	bh=rUhR4wNo9bSTUjnujKxHl+N8uUmRfwXAX+JyWewA8DY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N0xQ/RW7mZHLchSF/iEsR7vf0QkCgHSWVVePng32osmAsb3jP18K+CrpzSbgDUGGmj1A2quuhymwioI4jN4Y0oCg09m6Us2jGqT4kRwQdvXDX/EBUWWRGlEvKbcSfFYmjBstfrK+s4uHrPQNQQLfEVecghPJw1NVyxqTmxDin3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ev84cN3e; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ev84cN3e"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=AieW4//0KzTZfe/crb4FtH8priqeGbHu+a/O036nJfo=; b=Ev84cN3eMIcHF9Ek9S62Dy6a3V
	euh/mjXCpLjQuBsf9Z6i1EB8mUNeoOwTcmQfZbYuVlDLdPjWJxhfRxYYn71YJ7MfEBUXAKP3SolZR
	knLHSWFubzS1V1e/R/7UaWhUZPBd4alVS4Y4cvHvnIUdtptBl9w9aZane4hm+1natHKpRRS20ZjGR
	mfg09rxEDPlewVscUXjIJkMI5XtzsOm27SvNNw3ng1R1qv/F5mAXOxVftL5/QTdXy0RHkAYoLNa+4
	VpGY3hXzQaBYAqPPkuRlvMEIPfOaVzphwIDXOhbRF60rGE27r8H/2PH/BSqTcOTTQ2wfOPNcmZIPr
	opRFJbUA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vmpk3-00000004fh3-0Law;
	Mon, 02 Feb 2026 08:57:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@kernel.org
Cc: djwong@kernel.org,
	luca.dimaio1@gmail.com,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH] xfs/841: create a block device that must exist
Date: Mon,  2 Feb 2026 09:57:01 +0100
Message-ID: <20260202085701.343099-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This test currently creates a block device node for /dev/ram0,
which isn't guaranteed to exist, and can thus cause the test to
fail with:

mkfs.xfs: cannot open $TEST_DIR/proto/blockdev: No such device or address

Instead, create a node for the backing device for $TEST_DIR, which must
exist.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/841 | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tests/xfs/841 b/tests/xfs/841
index ee2368d4a746..ddb1b3bea104 100755
--- a/tests/xfs/841
+++ b/tests/xfs/841
@@ -85,9 +85,12 @@ _create_proto_dir()
 	$here/src/af_unix "$PROTO_DIR/socket" 2> /dev/null || true
 
 	# Block device (requires root)
-	mknod "$PROTO_DIR/blockdev" b 1 0 2> /dev/null || true
+	# Uses the device for $TEST_DIR to ensure it always exists.
+	mknod "$PROTO_DIR/blockdev" b $(stat -c '%Hd %Ld' $TEST_DIR) \
+		2> /dev/null || true
 
 	# Character device (requires root)
+	# Uses /dev/null, which should always exist
 	mknod "$PROTO_DIR/chardev" c 1 3 2> /dev/null || true
 }
 
-- 
2.47.3

