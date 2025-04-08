Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0647216605;
	Tue,  8 Apr 2025 06:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744095153; cv=none; b=eurRuYX4pzl6wnd+NV6vr8uKMdxOTxarg+GF90q83owIoMYX9T9lgdUfy5XGDRC7PAifn+fNnw8jqX2BlW4vZCYlOdfk5nKpLEoJDan8VsL9k1EnWNvAwRbFHFWaPoBS/EcC5kxe0I/2+YU/cIMgKnZ4zuhhfzBNCbqfMnADlGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744095153; c=relaxed/simple;
	bh=qWaw4Ph1MOMUGD43PfrSRuCHT88olaoQRDsLhvJwew4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lYjZXxwJwhoqya2+uctoMyVLFPtS3DUfomj5jxNruWwDeRU3viprZ2LaVF2ADjXaj8Whl1kmmCbHrk6vkzIi/63M6N53XlLXwuju9ZHThY8s+clbb23XSnGTEwIexb/vZae0j5XzGKEmRrPW/WDnJkiUM4x4dIbSCCdzwJRmS7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vtvAAlq6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vtvAAlq6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=WWA6k+XdUT4CX1cvecQllTxRdR69UJww7w97TjJiJsE=; b=vtvAAlq6VoaC1/H688xhP2vm1r
	tEvrrjbhuHdCMLJokh2Z685Vy72rVxkuw7WZsf29REp/kk6yZHw9IrvZMkRHYw+nTlVMylCyp/a6J
	A6xxqLe4xPOAlKdNQzTf1wtL/j/EaN8Um+LKChwx2fIVA0vqMuaxdN0Yjqv+mOKCYxyRUW2EVzYQu
	2Q94UfO4hVlofJBWs5+QfwI5Rhahti3cEQ4viEGiopOUw2optMTf0GAWfMM4qfdUeUa2Saj59QNtu
	5WS9nzj3x5X6IU7kq7kQZt4eD/2JMu3ztY6kXxM3gTnQQExmnrLi7y0W03Pwxme6GDP1BmduRRc+U
	CwT9EMAw==;
Received: from 2a02-8389-2341-5b80-f320-f588-da2a-f4ef.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:f320:f588:da2a:f4ef] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.1 #2 (Red Hat Linux))
	id 1u22ox-00000002xdt-0TCH;
	Tue, 08 Apr 2025 06:52:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH, resend] xfs: remove the post-EOF prealloc tests from the auto and quick groups
Date: Tue,  8 Apr 2025 08:51:55 +0200
Message-ID: <20250408065228.3212479-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

These fail for various non-default configs like DAX, alwayscow and
small block sizes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---

Resend.  Last time Darrick said he's working on an autodetection, but that
didn't get finished.

 tests/xfs/629 | 2 +-
 tests/xfs/630 | 2 +-
 tests/xfs/631 | 2 +-
 tests/xfs/632 | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tests/xfs/629 b/tests/xfs/629
index a2f345571ca3..bb59e421e43a 100755
--- a/tests/xfs/629
+++ b/tests/xfs/629
@@ -8,7 +8,7 @@
 #
 
 . ./common/preamble
-_begin_fstest auto quick prealloc rw
+_begin_fstest prealloc rw
 
 . ./common/filter
 
diff --git a/tests/xfs/630 b/tests/xfs/630
index 79dcb44bc066..0a3fce10c68f 100755
--- a/tests/xfs/630
+++ b/tests/xfs/630
@@ -8,7 +8,7 @@
 #
 
 . ./common/preamble
-_begin_fstest auto quick prealloc rw
+_begin_fstest prealloc rw
 
 . ./common/filter
 
diff --git a/tests/xfs/631 b/tests/xfs/631
index 319995f816fe..ece491722557 100755
--- a/tests/xfs/631
+++ b/tests/xfs/631
@@ -13,7 +13,7 @@
 # from the extent size hint.
 
 . ./common/preamble
-_begin_fstest auto quick prealloc rw unreliable_in_parallel
+_begin_fstest prealloc rw unreliable_in_parallel
 
 . ./common/filter
 
diff --git a/tests/xfs/632 b/tests/xfs/632
index 61041d45a706..3b1c61fdc129 100755
--- a/tests/xfs/632
+++ b/tests/xfs/632
@@ -9,7 +9,7 @@
 #
 
 . ./common/preamble
-_begin_fstest auto prealloc rw
+_begin_fstest prealloc rw
 
 . ./common/filter
 
-- 
2.47.2

