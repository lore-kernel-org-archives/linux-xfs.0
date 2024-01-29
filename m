Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88AD04F1E7
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 07:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706513555; cv=none; b=CGkcainmpCtBo0GUd+KeUuY4QUsHsRbyZBO/mbV3gzIrkCE7UJoaIml07QgiCpnL56qYUVcJGlh2bv7L/PZjeVvHOrxn0hmbn37XQsNrGeADiNY6BPvv/6VFSY6VUI07pcYUVU6bBx2O5OzH9Tw7uk6jjh96M13ls3lmKxcRm/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706513555; c=relaxed/simple;
	bh=yiZBdu/3iasW7v53M9TSlMfe8LlX2dkLtL72mbeCo+I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fLP2dKgafdXw0hbMFz9Z8270q0hl87ivs+7lGbNCXDG/lfdh6uC7PnqCfan2B0leWAZH/HUoXcXtFBx48IyU4uUAQwdV6/lNqrExjOAY020WPhdTB53wIPL6Y4f40NIaipCb3LWRQED+S68UsPwjyqv0koA7t61Vz/liZtPnBlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=orjT453A; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="orjT453A"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=IKNb8isyJ2DsDsIkYm/JQ9LoE+EX3ynBHkEr3+TaDlY=; b=orjT453Ax6SyGC1mWlpa5r6wxM
	c59yAPzfzEf07WJ5G/zU1URenZWtkcxODXuzmnroT2TfzMzAl4KUAtQQHgqIUYjhjqalmXd+F5qGz
	6OC5i88xRnJLSMR2o/fEPNbn6A7fg+lnom3howK7QOrKvrgoXkF7dSSxlfUexDNr6bl9GcGGCUJt6
	fWHWUdHdQDtDjgVlsK9yy1cZ7TLAd5Cr1DceIqQHEDNddJXw/ni+vcnfkag4ZRNyI2VX0pKUfso/j
	XSngksGLqhUA5lsCoPIiI0GALpZ/zHaX9eYJTN7nJGtU7oRuz8jt4LLG9FefVnUsaTq/dmf6816mY
	3+OyYKIg==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUM89-0000000BccB-3IgW;
	Mon, 29 Jan 2024 07:32:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 06/27] io: don't redefine SEEK_DATA and SEEK_HOLE
Date: Mon, 29 Jan 2024 08:31:54 +0100
Message-Id: <20240129073215.108519-7-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240129073215.108519-1-hch@lst.de>
References: <20240129073215.108519-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

HAVE_SEEK_DATA is never defined, so the code in xfs_io just
unconditionally redefines SEEK_DATA and SEEK_HOLE.  Switch to the
system version instead, which has been around since Linux 3.1 and
glibc of similar vintage.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 io/seek.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/io/seek.c b/io/seek.c
index 6734ecb56..61d352660 100644
--- a/io/seek.c
+++ b/io/seek.c
@@ -35,11 +35,6 @@ seek_help(void)
 "\n"));
 }
 
-#ifndef HAVE_SEEK_DATA
-#define	SEEK_DATA	3	/* seek to the next data */
-#define	SEEK_HOLE	4	/* seek to the next hole */
-#endif
-
 /* values for flag variable */
 #define	SEEK_DFLAG	(1 << 0)
 #define	SEEK_HFLAG	(1 << 1)
-- 
2.39.2

