Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C9A49647;
	Mon, 15 Jul 2024 05:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721021926; cv=none; b=f4X3LHUmHn5mPZH/eMja2QSx1mVZdLI1K57nCet+PEEjLESuorpOCoG75Ndm3Vh4W7AlUILM5/FJPoE9skxCSla3RMfhOQwqTwib2RrPp/akuyJAsEK4iGbmwqCfI6lXMf0F2feFy6OCTPFmRMyUEvA/Xoc7NW5abaCKT9l7g9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721021926; c=relaxed/simple;
	bh=DaSY8pRAYgFX5VlGPKris31cJSpr3ct1pHdwAGX+zP0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GBGusGmDdFM/ui7MF7by3gXuDxVQtAhqT9zApOeNNpuDdQ5+I3aE73o65qTvSkwgm6HQHVxT2wX7z3ksRjsY03YIbiBbksf//EtsZLATBBKtvnYbJbam8mE/Y6LLsKa5prsAl1v2YAEIXA1lg22Gd2QX2Rc99QwqYb31/eFKt7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yBnlfEhQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yBnlfEhQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=a/Mh5+PyO58paEDIrJqrB3rMLYPEBwSr48lrx2MpNsc=; b=yBnlfEhQHcNDYRXDBl1YP4rtd8
	9TSJHcV+aSFCOUQyKR3UFKPd21sLf6B7I82oenjI4QhVmqxBVIuswT2kRS44Q67Rdl0HRkYUdCd8M
	FV3HUgKhE//s3+H/zv+uib5vqjCO4z0IxDY6YtD5+rW7PoIi5OCD9tG/W5fcFVgt18WWD/3+/PQbZ
	YFM+gPJX/+1gYn7XQ9pTcFwat6eyQkNGZe/JaKyuFjlycD2czFDJ2yNYlaRSE8te+sZfysVC+6Xuv
	JOu8ZYY/U1Bc3aUp49kvK9BB1lAIvV2x5+TKYgLxuP6reu7WkdTydfc/LsF94ijtHyzoZN9sJYJjc
	P0GX92ww==;
Received: from 2a02-8389-2341-5b80-e5f3-ff26-c02d-471d.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:e5f3:ff26:c02d:471d] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sTEQ5-00000005wJj-1awT;
	Mon, 15 Jul 2024 05:38:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH] xfs: add a few more tests to the repair group
Date: Mon, 15 Jul 2024 07:38:37 +0200
Message-ID: <20240715053837.577532-1-hch@lst.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a bunch of tests that test repair for the RT subvolume to the repair
group.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/337 | 2 +-
 tests/xfs/338 | 2 +-
 tests/xfs/339 | 2 +-
 tests/xfs/340 | 2 +-
 tests/xfs/341 | 2 +-
 tests/xfs/342 | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tests/xfs/337 b/tests/xfs/337
index ca232c1c5..2ba508044 100755
--- a/tests/xfs/337
+++ b/tests/xfs/337
@@ -7,7 +7,7 @@
 # Corrupt the realtime rmapbt and see how the kernel and xfs_repair deal.
 #
 . ./common/preamble
-_begin_fstest fuzzers rmap realtime prealloc
+_begin_fstest fuzzers rmap realtime prealloc repair
 
 # Import common functions.
 . ./common/filter
diff --git a/tests/xfs/338 b/tests/xfs/338
index 1bdec2bfa..9648c9df4 100755
--- a/tests/xfs/338
+++ b/tests/xfs/338
@@ -7,7 +7,7 @@
 # Set rrmapino to zero on an rtrmap fs and see if repair fixes it.
 #
 . ./common/preamble
-_begin_fstest auto quick rmap realtime
+_begin_fstest auto quick rmap realtime repair
 
 # Import common functions.
 . ./common/filter
diff --git a/tests/xfs/339 b/tests/xfs/339
index 90faac784..4dabe43ff 100755
--- a/tests/xfs/339
+++ b/tests/xfs/339
@@ -7,7 +7,7 @@
 # Link rrmapino into the rootdir on an rtrmap fs and see if repair fixes it.
 #
 . ./common/preamble
-_begin_fstest auto quick rmap realtime
+_begin_fstest auto quick rmap realtime repair
 
 # Import common functions.
 . ./common/filter
diff --git a/tests/xfs/340 b/tests/xfs/340
index 58c4176a6..248d3233c 100755
--- a/tests/xfs/340
+++ b/tests/xfs/340
@@ -7,7 +7,7 @@
 # Set rrmapino to another inode on an rtrmap fs and see if repair fixes it.
 #
 . ./common/preamble
-_begin_fstest auto quick rmap realtime
+_begin_fstest auto quick rmap realtime repair
 
 # Import common functions.
 . ./common/filter
diff --git a/tests/xfs/341 b/tests/xfs/341
index 424deb3eb..6e25549b2 100755
--- a/tests/xfs/341
+++ b/tests/xfs/341
@@ -7,7 +7,7 @@
 # Cross-link file block into rtrmapbt and see if repair fixes it.
 #
 . ./common/preamble
-_begin_fstest auto quick rmap realtime prealloc
+_begin_fstest auto quick rmap realtime prealloc repair
 
 # Import common functions.
 . ./common/filter
diff --git a/tests/xfs/342 b/tests/xfs/342
index 9360ddbe7..5c0e916db 100755
--- a/tests/xfs/342
+++ b/tests/xfs/342
@@ -7,7 +7,7 @@
 # Cross-link rtrmapbt block into a file and see if repair fixes it.
 #
 . ./common/preamble
-_begin_fstest auto quick rmap realtime prealloc
+_begin_fstest auto quick rmap realtime prealloc repair
 
 # Import common functions.
 . ./common/filter
-- 
2.43.0

