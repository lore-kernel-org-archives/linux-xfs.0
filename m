Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49AC21CCB4E;
	Tue, 19 Nov 2024 14:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732028113; cv=none; b=ISOESXttDAP1YXcdbXoJwvt0fWMyuTpzYH500ZnAGGzNo9lN6m5HaKeNYu9pL5Kh7iLxdSd96SDqQYf3+WjRDpvLb7YNSkvlL9LHVPs4X3pmDZqSxkfUzR1jZ3w8GnVSoq27tu/JZrpWydRymAuev4O0RNmdiXldBKDYKz1ZZCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732028113; c=relaxed/simple;
	bh=Ha9mamDiAebG8G1Z5HxfKpUeIZq2AndQo0glDDXbNwg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pVuMW/+GLsR7UgwxAHfXOnuCUv4C0QhsbcX2E2z2jT58DfzZ/fA9Jm7iHlrbGPLC6Of2xyMpMXqbKPKgZxrWINqMqxISXMxUfcsWju5IGpZ88mrAQqSP+l55x0c0Opo05GB7O4Nvs5Mitiu0p87vEAgsakRsAol+zs9MXKVuaR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4cY430Tf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4cY430Tf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=5MQLMfE4ZyfZPhUI3ONUFEi2YQtwtFvPgkgKYZ+XEwE=; b=4cY430Tflcht5sIXlCT8Wuhv8p
	Z/5TmkHmiy2OomNNROk79JKKE/aXby22UaS7Jr4bUq8ilq4fnJoKqaFNieaK4VBDb7NAbIJZBAP0T
	Tz823ph+SrUTw9RUTqz/pmenv/9GDSrB8JDiS1/YrNteruaaj2UVsASXDTeyhuWeeY7Oum2Y9NqMs
	U4G891ysq4QpYgSb4H93+8WqUv+7Bb0Fkv03ZYlKdmSVbW7+LXeyREjIX1owKI6JY+39frTOAYCmy
	fdh0rHhHbAeMrlaIwPyjCT4HYbuga3nEpDtJbGniZbP5LjdsDBbNwfFEhkTz3v3G3k9mIyKpepTRI
	rsUIdncA==;
Received: from 2a02-8389-2341-5b80-1731-a089-d2b1-3edf.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:1731:a089:d2b1:3edf] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tDPdG-0000000CkPc-1xhb;
	Tue, 19 Nov 2024 14:55:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH] xfs/229: call on the test directory
Date: Tue, 19 Nov 2024 15:55:07 +0100
Message-ID: <20241119145507.1240249-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs/229 operates on a directory that is forced to the data volume, but
it calls _require_fs_space on $TEST_DIR which might point to the RT
device when -d rtinherit is set.

Call _require_fs_space on $TDIR after it is create to check for the
space actually used by the test.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/229 | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tests/xfs/229 b/tests/xfs/229
index 9dae0f6496e9..3ac1f9401a1a 100755
--- a/tests/xfs/229
+++ b/tests/xfs/229
@@ -24,7 +24,6 @@ _cleanup()
 # Import common functions.
 
 _require_test
-_require_fs_space $TEST_DIR 3200000
 
 TDIR="${TEST_DIR}/t_holes"
 NFILES="10"
@@ -39,6 +38,9 @@ mkdir ${TDIR}
 # that will affect other tests.
 _xfs_force_bdev data $TDIR
 
+# check for free space on the data volume even if rthinherit is set
+_require_fs_space $TDIR 3200000
+
 # Set the test directory extsize
 $XFS_IO_PROG -c "extsize ${EXTSIZE}" ${TDIR}
 
-- 
2.45.2

