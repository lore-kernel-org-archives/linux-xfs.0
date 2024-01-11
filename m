Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E377F3D569;
	Thu, 11 Jan 2024 14:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="blMSWCQk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ZeMD8HB6t4Vd1uhsa9VGEdXcdw/mvJBqEnJQy1BLsyg=; b=blMSWCQkTk8ZCJqoKHLv957Gpy
	hzec4br5QU0w0o1hd1WHCRwdSkbpjq5LyHR67TfmiH4aW1C5fkF+OPx0fYEQzwa1i19qhMnFJYxnx
	C86JPTSCksIOYOJO4fVr4zU4CNYSpBvA9ntMecKeWq+XlIyr72uk6D66oALNXFET7+XlCSPVU5sRH
	crjA0vrC1G8hpIWdjw0VJfb6FYNhl3V6oZBNU1KW91TdtF/4IIJgEYdu8TAZ5S7O364MiyOMNTD7n
	HWuDalXgUpT7CKFnNPoy/KHrgcyBW8DrC4cbN2qjv84eNxVB0tbT1jyBBC/q+lI/1faIORWpx2kIK
	SwpZCplQ==;
Received: from [2001:4bb8:191:2f6b:63ff:a340:8ed1:7cd5] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rNvyj-000HGK-0h;
	Thu, 11 Jan 2024 14:24:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@redhat.com
Cc: djwong@kernel.org,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] xfs: check that the mountpoint is actually mounted in _supports_xfs_scrub
Date: Thu, 11 Jan 2024 15:24:05 +0100
Message-Id: <20240111142407.2163578-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240111142407.2163578-1-hch@lst.de>
References: <20240111142407.2163578-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a sanity check that the passed in mount point is actually mounted
to guard against actually calling _supports_xfs_scrub before
$SCRATCH_MNT is mounted.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 common/xfs | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/common/xfs b/common/xfs
index f53b33fc5..9db998837 100644
--- a/common/xfs
+++ b/common/xfs
@@ -649,6 +649,8 @@ _supports_xfs_scrub()
 	test "$FSTYP" = "xfs" || return 1
 	test -x "$XFS_SCRUB_PROG" || return 1
 
+	mountpoint $mountpoint >/dev/null || echo "$mountpoint is not mounted"
+
 	# Probe for kernel support...
 	$XFS_IO_PROG -c 'help scrub' 2>&1 | grep -q 'types are:.*probe' || return 1
 	$XFS_IO_PROG -c "scrub probe" "$mountpoint" 2>&1 | grep -q "Inappropriate ioctl" && return 1
-- 
2.39.2

