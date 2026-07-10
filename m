Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5FF2D7DCF;
	Fri, 10 Jul 2026 05:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783661282; cv=none; b=VOXJGqhMqr5FP6cmZctlSd71tQBR9b89qXFYXqfOAUpIkMM2r6y9Tvhcc9tHYwnzjkH9wOwUI1K8+bqvASbYWm1RJx5dsHw9cnFT8UkaWVUhTi+yTy3h4AH+XljBLqSI5BdqVXCk4IUkm1jYyjrsCV4jiukCVnH+NuXjpX0Evw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783661282; c=relaxed/simple;
	bh=dYNH/rOYBKknqqIXfpAtuzBFS5E+Ed33XOnlWxDvqAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rt0pbfTTZoS9uw5d+jZ6m7z7wxVRhbq/Y/HD72dedGgb2hirxzoLL/XCL/vYv5JwAoC8RyDsNZgOAfPuXNLrEiZuPmECxMSAGnK2i6pR2FsLXWXsmgSbbgikKAaLtfGApMVoYBjc5Vo0tnqJc5cQZYkAm+Q8NkJ8Lw7HOJk1+ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WR2cR4+a; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WR2cR4+a"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=jIMniudH4akj2iDVOW/VRPFSc+abHLK6NtJGi0Me0qE=; b=WR2cR4+ammtWq04JuO5RkkdIEY
	OonpNMnARwPPy/2dToTkOu5nyWpjZ2cbJGCgz8Ruw8xt7WeqKpYDsNGzoOCcGPLQbA7+J/Qo9W/rT
	WZV/qVtykYTfxdY+kfIuhwAKNGzW4ZDTOKBUUhEjL8McIHD/62Z0dc/tvT4Or7mwGiwYGFwBYp4iV
	0gb05XT0ypDIMObNMmK7paU/1PBiiGhrrubwkDAoH5m+ZuuiYNnuogfxzSZVNv2ID1ChOUlyihvRe
	CzogcTW+tz9nWnWExhWZbos5kofCasD/sA5kDUJBW4xQRiw210hPU5u19p7dgZGU7dYFQ1g9ZlaCr
	5u5SO/LA==;
Received: from [2001:4bb8:2cc:d72d:4dff:292f:a943:a4b9] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wi3mJ-00000004CJL-2FZ6;
	Fri, 10 Jul 2026 05:27:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] xfs/65[56]: don't unset SCRATCH_RTDEV here
Date: Fri, 10 Jul 2026 07:27:34 +0200
Message-ID: <20260710052747.1841555-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260710052747.1841555-1-hch@lst.de>
References: <20260710052747.1841555-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

From: "Darrick J. Wong" <djwong@kernel.org>

Both of these tests claim that they have to unset SCRATCH_RTDEV to avoid
formatting failures due to the rt bitmap consuming all the space in the
"small" data device.  However, the format doesn't constrain the size of
the data device, so the justification doesn't apply.  Remove the whole
thing.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/655 | 4 ----
 tests/xfs/656 | 4 ----
 2 files changed, 8 deletions(-)

diff --git a/tests/xfs/655 b/tests/xfs/655
index a4162d70b321..9d09cc000531 100755
--- a/tests/xfs/655
+++ b/tests/xfs/655
@@ -24,10 +24,6 @@ _require_scratch_nocheck
 _require_scratch_xfs_crc # can't detect minor corruption w/o crc
 _require_xfs_io_command healthmon
 
-# Disable the scratch rt device to avoid test failures relating to the rt
-# bitmap consuming all the free space in our small data device.
-unset SCRATCH_RTDEV
-
 echo "Format and mount"
 _scratch_mkfs -d agcount=1 | _filter_mkfs 2> $tmp.mkfs >> $seqres.full
 . $tmp.mkfs
diff --git a/tests/xfs/656 b/tests/xfs/656
index c01276eb384b..5114a6c24003 100755
--- a/tests/xfs/656
+++ b/tests/xfs/656
@@ -40,10 +40,6 @@ filter_healer_errors() {
 		uniq
 }
 
-# Disable the scratch rt device to avoid test failures relating to the rt
-# bitmap consuming all the free space in our small data device.
-unset SCRATCH_RTDEV
-
 echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1
 _dmerror_init no_log
-- 
2.53.0

