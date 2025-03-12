Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DDD1E7C25;
	Wed, 12 Mar 2025 06:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741761970; cv=none; b=QValK25AVTJpt9tkZ2FqFi1BrN3fLl6t1uk+AhuxFZ/hlecyOsXNLTpeoasfWD9c3nUY0UyQfgfy7jmTOJ5kx8hu8VyseAMINZa0MJKuuJkVsROIkY6Set8nIA/5xP+sfBZWWJsFqOCau9lPX8nepi+jpSXA/7B0tsOTjETAQqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741761970; c=relaxed/simple;
	bh=hQJiIJYQ/lRknS6QBZlbWwm+hPWNd3gzckYFSOkaryc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DMwSWNix3lwWx/l0JyEGAzDfkfl2dAItJAXQRC2t5uRC4Z8uRg03IL9pgMELRBWebW/BbG2keaDCNIf9rlj3kUc7kaZSOXnEEww5rrijAdyt1okrIMthjuNka4nWMX8l3oxwLjWtBwB5HmtS6I8h84xtTvf+KCGhW/pwfrJtgUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EPML3Wic; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EPML3Wic"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4dwuBGVi+62Qz36Zo2gYuYWNmA71hzYu9DyGavELtRw=; b=EPML3WicB4EMYE9RDAcXWhKpFf
	wePOTaruKzMl47qQNcVdG9XeqnvyDL9a+hsPwO+P/tt/9bjsnNKMXO4tde2ahhBKyi0rRHfhWstMU
	pFFjMcpAck7sF8KGkB6gEjQYHxOOYxnzt6GN+i8hI/TJPfXlk9MBowC/0qib9oqd3ld5t7VJKiC/v
	nUiHTo4gM7wCCf0+2wj2OUHQGfEiDCC9OAhgdgOdTAyNa+UsWKj9fwi7YZ/CqH6NwwXcGRDnNXTSQ
	o9QmYjhe1r3X10d+nBuP6Jz4z/eTho6O+SuYlmLECExESZY8uQH3qjPTAqVoA2xEsxWz3rnCNyVcC
	0Zn/Ef/g==;
Received: from 2a02-8389-2341-5b80-f359-bc8f-8f56-db64.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:f359:bc8f:8f56:db64] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tsFqy-00000007cpd-19ra;
	Wed, 12 Mar 2025 06:46:08 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 09/17] common: notrun in mkfs_dev for too small zoned file systems
Date: Wed, 12 Mar 2025 07:45:01 +0100
Message-ID: <20250312064541.664334-10-hch@lst.de>
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

Similar to the regular scratch_mkfs, skip the test if the file system
would be so small that there's not enough zones.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 common/rc | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/common/rc b/common/rc
index 5e56d90e5931..e664f3b81a6b 100644
--- a/common/rc
+++ b/common/rc
@@ -910,6 +910,10 @@ _mkfs_dev()
 {
     local tmp=`mktemp -u`
     if ! _try_mkfs_dev "$@" 2>$tmp.mkfserr 1>$tmp.mkfsstd; then
+	grep -q "must be greater than the minimum" $tmp.mkfserr && \
+		_notrun "Zone count too small"
+	grep -q "too small for zoned allocator" $tmp.mkfserr && \
+		_notrun "Zone count too small"
 	# output stored mkfs output
 	cat $tmp.mkfserr >&2
 	cat $tmp.mkfsstd
-- 
2.45.2

