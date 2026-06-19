Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1662F2BD030;
	Fri, 19 Jun 2026 05:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781845791; cv=none; b=ic7FGGad5lLWXQGle+LC0KtrWku9XswKBOwEOJYxbUnjcGv7dCkqmEOCJFdeeBXlf61CWyTytZTXfw8MwgIhj+AZ0jmfWyOU/CAY8O/N1Vp50zWnyO22tvH31YqW0QIIG4D2/viC0c4SB9kbKdyX6nwyY4PO4nc8vz5rhiZP/cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781845791; c=relaxed/simple;
	bh=XBrtyquqMbAyHwcnhhrI9Zqt0xI8ELrbifDkTSPA0jI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qa5zOIC0TRcNmcpi6QwVMnkv+5RcWr8WiTRzucYEweFmLWA1xOqFNI26xCfiMsSxil8YbW4AVdAJ/V96/IEBuycVpNKL75h5+KkS5nojiqUiviyaxdHAk6+n0H2/iotKeuLGLuknzREuSDXAJ4tztVht+DhrrL5XZ5tjJTU3FwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=si53DRt4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="si53DRt4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=NVXOgHUS+LduAtENeg+2GVeOuWCVyGbfS0c0OCg9MMk=; b=si53DRt4IozxllBd8PoRjfJ9eM
	sk21mgljShTHQE9cpoPK2ITntOOhRfd/6n25idUM65gF33CB3/Ps/TOQtzKxzoqYnsUBqRSY11i8F
	rgan/mDvPUoDgrXsdXvos+GEVU93jj5TLfgNESh+pTQtl8qH8RDjaT0VxdSOM+360pusjMHbxpry/
	ULZ9yDf0rfzKUX3QoF8KOsuE015t+533cE7/XVIITdHTUpK3usgR2ClX7rZZJRunidZ7BWxgA7XBu
	FsglKj12goXOz7dtuIm+yUJAqolgn7liC8odJEYVtAp/HfyJRURaCu3/WGpbpczCI2kHvTWm7Ez0E
	c0yDrqrw==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1waRUC-00000001zqT-3oXC;
	Fri, 19 Jun 2026 05:09:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Lukas Herbolt <lukas@herbolt.com>,
	Eric Sandeen <sandeen@sandeen.net>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH 2/2] xfs/216: disable all concurrency scaling
Date: Fri, 19 Jun 2026 07:09:29 +0200
Message-ID: <20260619050937.444488-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260619050937.444488-1-hch@lst.de>
References: <20260619050937.444488-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This test currently disables log concurrency scaling, but even the
data device concurrency scaling can create mismatching output on
systems with a large CPU count.

Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 tests/xfs/216 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/xfs/216 b/tests/xfs/216
index 1749647c11f7..ce8bb528410b 100755
--- a/tests/xfs/216
+++ b/tests/xfs/216
@@ -23,7 +23,7 @@ _cleanup()
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
 if _scratch_mkfs_xfs_supports_concurrency -l >> $seqres.full 2>&1; then
-	loop_mkfs_opts="-l concurrency=0"
+	loop_mkfs_opts="-d concurrency=0 -l concurrency=0 -r concurrency=0"
 else
 	loop_mkfs_opts=""
 fi
-- 
2.53.0

