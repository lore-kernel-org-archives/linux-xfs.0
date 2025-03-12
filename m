Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C231E25EF;
	Wed, 12 Mar 2025 06:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741761967; cv=none; b=ayc/Q2KyU7ZvBmnzGlnaSDd8T+qbHs0rJ6d7JDiJwbIzTs2nFj6gdmFkDU5m6oam5CLjzijb0Ky4iEt3HGktxLIpfEJxzMe9tSjNHpfrqUovOp4NWIUPoprd5AwrXbH6fia94AZ3xZsdBpxqrOYfIWeeiZTP1BUOzLhQp9NjqZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741761967; c=relaxed/simple;
	bh=yS+dACl+TXQCanDbmHn75Zllfk/ogkWWTNCpT89yCVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P6A9Utj/BQAMQiE+3YkPFubNaxvFAKLq53KxrukfylCkijvg5nxeIr19gOwFYunP+i3VnUHx4zCLC77JZeKnWsv2vNKEJWdXJ6xflFyzOL5YxnL1aXbIaIjU3an1vuvZfGmuOyBVXE60/hRvV2qMPE6NGQW/PAy9bMbmO20FvEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SYWLGIGl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SYWLGIGl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=2qn3C9izqQGXM6HKPk3YkB346LcpSuvoklXQS6mR5D0=; b=SYWLGIGlSvvyaaN2kHNKaRaIwy
	GclpyGDEEy2AyE5LaAtT2rhXnuEwoGZiifhO79VZRwjJHb9sZRPTzeRX2a76sD8D8uG/HBdGVmvfD
	DszPi7wKYn8/j9BjMIIWzR9PGwq8j4b7jB1u9g3tqq8+tx/G6YzcS/NohbW5YZI0uuzInzY1P+KKi
	lkTY8SFZTXW6yvp3/WUGxX2++D3FpTELoxghRJk8faQpwNKGKKCpBA6i2VpuwVLEPZAwx8IgtHrfm
	jpc4+3WyiKZdx4CZQgYUkBqDEi+6tid7NQ4hHGILyRkM6zX2j3zQftcq/SMzugD8F3Y3gJgBpydD6
	yc8S0Z+Q==;
Received: from 2a02-8389-2341-5b80-f359-bc8f-8f56-db64.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:f359:bc8f:8f56:db64] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tsFqv-00000007col-3xvc;
	Wed, 12 Mar 2025 06:46:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 08/17] xfs: check for zoned-specific errors in _try_scratch_mkfs_xfs
Date: Wed, 12 Mar 2025 07:45:00 +0100
Message-ID: <20250312064541.664334-9-hch@lst.de>
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

Check for a few errors issued for unsupported zoned configurations in
_try_scratch_mkfs_xfs so that the test is not run instead of failed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 common/xfs | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/common/xfs b/common/xfs
index 93260fdb4599..807454d3e03b 100644
--- a/common/xfs
+++ b/common/xfs
@@ -160,6 +160,11 @@ _try_scratch_mkfs_xfs()
 
 	grep -q crc=0 $tmp.mkfsstd && _force_xfsv4_mount_options
 
+	grep -q "zoned file systems do not support" $tmp.mkfserr && \
+		_notrun "Not supported on zoned file systems"
+	grep -q "must be greater than the minimum" $tmp.mkfserr && \
+		_notrun "Zone count too small"
+
 	if [ $mkfs_status -eq 0 -a "$LARGE_SCRATCH_DEV" = yes ]; then
 		# manually parse the mkfs output to get the fs size in bytes
 		local fs_size
-- 
2.45.2

