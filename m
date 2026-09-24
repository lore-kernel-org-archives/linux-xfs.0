Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86EA411FB1;
	Thu, 24 Sep 2026 10:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244560; cv=none; b=FL5B+uZPwfKMrxRuwxQjrHDRcvKoWCRRVgaFAmziWUJLZVEnApdGYD01ZW9/iB2BOXjVk5ZwzBYLz+hvmZKVGIwTH+EqwGCK9B/lgWXBl7KUgu+d2d2xX1RNdy4t5BnOJ5wJQgfMesXeZ9/pFqJFBv/C7fq8wibrRuWW1cGH5Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244560; c=relaxed/simple;
	bh=oOfq5G1CWRxPgZSU59NO+7Vj0mfpkBJu6h9uXYR/J6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WwaISVgc2hg0w73NnEp3ddlxTgV5b6j+jzdfhmPfxZ2IpxvSV+N47LdMThZbVo6OiOxd2T180VlZ3XvRgKBIv8RZO3XITd8v/5tqMVfpqmdAYPsjO5lI8ZJe8QqZ2eRYq4PLjKBbLEPj38rb6XTldWpzfwmmnjI+NGwuDb0phNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=r0wtA8B0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="r0wtA8B0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ApBtfocJDCBBGAgUZDFbtksBO87iS+d/iTekmGItHAE=; b=r0wtA8B0oyEs7MNlNydlZklIh9
	zKFZRDeOud7pSO4Of3YYvk70+rtLOn+UK11kmDnqN828O5UIv6ycbvQYWbvDLGRV3LvKg07cpFI3E
	/TUf5iOQhniPwsCdS0kEAANtbT+lmCLK+T+MyPZqh0w+3lp0xwqgzzvon8BUbzyS/0uiWkrIV4Raa
	icbnLtOpuco1VVGfI57IRV6gstODAwUTAzIx3ElUYxwyFyr3VpCmfsJATxa43Qcit5QNWrIw1XfqP
	bybSq5G05a8WQ1qc9X/9bH6dJXCY8HyeX1fyTUQPxAAwQzTbW541F/10Fbqtc9W+fQBM2a/hBLerM
	yHdaC0Nw==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gO3-0000000AfmB-1NzE;
	Thu, 24 Sep 2026 10:09:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 01/13] add a "datacsum" group
Date: Thu, 24 Sep 2026 12:07:42 +0200
Message-ID: <20260924100855.2734089-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100855.2734089-1-hch@lst.de>
References: <20260924100855.2734089-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a group for test exercising data checksum functionality.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 doc/group-names.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/doc/group-names.txt b/doc/group-names.txt
index ef6b8f51cf87..101c72688c02 100644
--- a/doc/group-names.txt
+++ b/doc/group-names.txt
@@ -34,6 +34,7 @@ dangerous		dangerous test that can crash the system
 dangerous_fuzzers	fuzzers that can crash your computer
 dangerous_selftest	selftests that crash/hang
 data			data loss checkers
+datacsum		data checksumming
 dax			direct access mode for persistent memory files
 db			xfs_db functional tests
 dedupe			FIEDEDUPERANGE ioctl
-- 
2.53.0

