Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A20189F3B;
	Thu,  1 May 2025 13:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746106745; cv=none; b=EG2YbDh4OHa18McOITp4iy2OzdTaI11SyFA3l3HTVDkEFG9h5J494NVEgbWcjbtAAGKekiX6ztyP0mMeTAJCMfg/IJk1MhxmZa8/A4aPek2f8xFfn7kyZ9BxRZEFwoLedqnDlDYz8q4GmMXf1ksRoCVjCMbxhEl6F9BtqpBBMZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746106745; c=relaxed/simple;
	bh=ULEUKjcpoO2XQukLnt7jpZLlU9DvpZDTSUiULPRBaok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P8X7DJg4vxykyZcVF2VvH1CTqkxCpXONYnP2R7FS10cNoux1mvyrbQrHEcv/63x70IkDfKSa8Q1RknT6hw7n1fmTEZWiYYZVp0asha8Wo8Ky5Z/vM9+stxqaC7ka5TrIGBf8fQuAGEi5jSSssBUSPgo2fdVf463mQvB9i08Abms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3GVBsuiU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3GVBsuiU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QWQ20OCeBGF2OBgmbnCR9NjUfd5ccGZ9JpfKcjLkMV8=; b=3GVBsuiU6HifPvHR40RUSRaq+D
	mMNxKcycMoOQ/i1rLQLeDpE5im7+lF9Tg/S1jVRy6XkBAsJxzNPNMmoe7kdt0C9g9BA05ddr1oRWZ
	0HGGIoKKC/IuFkLt4rfhnApF5PG8KJYj2KH41EBr7hoHRJMw0Wq1nszdWe8nn7tJ4lC/j9TerXRkq
	d6UzsM3qwlpwBzEe419eXf8pmfzRUVUwSlD7zf4c5ulmb3uNCSUqMS9gW/1BRLwxF8tU1mkzcDIyQ
	PKoB5JHFfzJdIrkMdcKa0XosH7r/xFwSW7oYmuAvq+RNV9IVxjvlIN6771XTAtmcXRedJYrIHzmcm
	PB38PE0A==;
Received: from [104.254.106.146] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uAU7z-0000000Fqev-2JNr;
	Thu, 01 May 2025 13:39:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/4] common: notrun in mkfs_dev for too small zoned file systems
Date: Thu,  1 May 2025 08:38:56 -0500
Message-ID: <20250501133900.2880958-3-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250501133900.2880958-1-hch@lst.de>
References: <20250501133900.2880958-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Similar to the regular scratch_mkfs, skip the test if the file system
would be so small that there's not enough zones.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 common/rc | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/common/rc b/common/rc
index 9bed6dad9303..f9ffe2d279bc 100644
--- a/common/rc
+++ b/common/rc
@@ -906,6 +906,10 @@ _mkfs_dev()
 {
     local tmp=`mktemp -u`
     if ! _try_mkfs_dev "$@" 2>$tmp.mkfserr 1>$tmp.mkfsstd; then
+	grep -q "must be greater than the minimum zone count" $tmp.mkfserr && \
+		_notrun "Zone count too small"
+	grep -q "too small for zoned allocator" $tmp.mkfserr && \
+		_notrun "Zone count too small"
 	# output stored mkfs output
 	cat $tmp.mkfserr >&2
 	cat $tmp.mkfsstd
-- 
2.47.2

