Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74F51E5B7F;
	Wed, 12 Mar 2025 06:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741761952; cv=none; b=oVqKS0nDufyp7yxpePyzcEnYyyHMbh6al9yG17P1jCl2GFfbDO2Vxd93s0rYhieYsOkfM0OzaokKthiY/2YvHKvv6Q0DSMMJFKlKTMqnP3LQ2u/GeMgD5gtE7cnigynWzqtddghUoLXjjiqCi4AyPXXU2DmwBUNDay+/pKufS54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741761952; c=relaxed/simple;
	bh=SDubL15RTZtwkKk0PGndGA908VZ28cUOKxKlfxUMYdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o+ZIqqcdx6xxs6zSTh1MiPWojITQem6QWjZaoAkQx8AEFoMadVNzyVFVpNOkyGObMS9vuMjyJsSYvGOc2fDO8BU1FRMinlrO8g1mdQDrlK7UnvBlk8BI006uMToUH+oCb+E9o+C6l7O/RM9HM4qYOt7rqxcR3E/6iZdVBfT2oSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jboxdCqJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jboxdCqJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=sKlz5L0Ao/eBnyjpBgYMZuxfsY67WLOtZfWFdWYW+1I=; b=jboxdCqJpu0ouxIrRFdlm1jSK5
	6nQ6pTkPfnp1XywzrN5KHYj/LHB7FoqiSSQ9SeZ+Fra6DEhVQAdExjswEwMVX+O9yyDIcnyyVICZ7
	j3d8eSA0GsMJk66w3yqj8dFyRYUqPyQybYglLhBM+NLz/05DkkUjHocTOVtvI+kpOO8aFCZdP4G2I
	MzjE6YyhZMD336htZoRM9y4sOcpl+3fUadwowRqmlVX5W6RTajUTSuc4UF5g2GMiD0CKppmagQKx6
	A0Q+Z+EHIZQSbBybqoRBA5v3lV19J3n+7F1mnzapXkD92VgFgYD50ztE7BClmcFHsT4YO3/ekn17H
	q1Zo/Hdg==;
Received: from 2a02-8389-2341-5b80-f359-bc8f-8f56-db64.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:f359:bc8f:8f56:db64] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tsFqg-00000007cjA-1P25;
	Wed, 12 Mar 2025 06:45:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 02/17] xfs/419: use _scratch_mkfs_xfs
Date: Wed, 12 Mar 2025 07:44:54 +0100
Message-ID: <20250312064541.664334-3-hch@lst.de>
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

So that the test is _notrun instead of failed for conflicting options.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/419 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/xfs/419 b/tests/xfs/419
index b9cd21faf443..5e122a0b8763 100755
--- a/tests/xfs/419
+++ b/tests/xfs/419
@@ -39,7 +39,7 @@ $MKFS_XFS_PROG -d rtinherit=0 "${mkfs_args[@]}" &>> $seqres.full || \
 	echo "mkfs should succeed with uninheritable rtext-unaligned extent hint"
 
 # Move on to checking the kernel's behavior
-_scratch_mkfs -r extsize=7b | _filter_mkfs >> $seqres.full 2> $tmp.mkfs
+_scratch_mkfs_xfs -r extsize=7b | _filter_mkfs >> $seqres.full 2> $tmp.mkfs
 cat $tmp.mkfs >> $seqres.full
 . $tmp.mkfs
 _scratch_mount
-- 
2.45.2

