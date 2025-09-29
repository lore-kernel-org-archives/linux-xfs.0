Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5302BE636
	for <linux-xfs@vger.kernel.org>; Mon, 29 Sep 2025 06:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759128125; cv=none; b=DIgcE0wPFBbBH/486rJNbaw6tCac9T/L/jadMSRz0luuwWNQNH/B6JaibRlKG83EFLyWwddh/MQnZNb51Ck1KO8jHFjxQaZ0JOY/2GXJw1rgSrxyGwIWyyMkTHRz1ckVqdPiO4XNpHX+rnuq+/2116Wf4APzzN3pEmwrQ6vTpx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759128125; c=relaxed/simple;
	bh=AhWAtIM4keYZ2G+tEYfvF3hHWsOoDFlvMOEEndA7xlo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DynFJUs83DW+WSJmhQHW4HlZdNtvkUJ3C5kiDanyFrGvP/+KsH2xEN92hmeLV8ycCQNyeh5SQlkcHMWAUpjrfF7kbNem6HbGXkurbi7x082SFJSq/R6jWxShKIVt8tGd2MiYlEpkrCe96fzPOyGAZ4igSG2gMqFDSTCIPxXqPsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qkZbo6eX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qkZbo6eX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=fpmoGIdd+NVSC5QPJuwOfGRPO90V0GYhLv3xI7kDohA=; b=qkZbo6eXtyCkdBtzpeS4iwEBVu
	Mr+eTexKMXJiibpdnGJo66b18yWoO2qDQkfMrW7pZQhB9M5aWcyd2lQJq7mEVn2K/azuHB6wHMhVE
	KbdlUKnNHEJsUoM5g9uqY4lzbMMXkarCSzQ9B8OC86gzrbc29kZ5Zw5ryByEuKo6C8/0tzUX03BjO
	v9pgXmz1nyT+SeA0i57nppphvvZPw/CEB84i811lEAQNkyBz8QU+EnLmtcDY3lQm7Niu4Y8kGYP8y
	l89IM6dakdEKikmlPqxbpuJphj8Al0vNreg/LJVP82ZeVT459T/7tps8qvVMpyNUwzxE/7SZR6Zxx
	NqVIEzTw==;
Received: from 85-127-106-42.dsl.dynamic.surfer.at ([85.127.106.42] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v37aE-00000001VcX-2jqw;
	Mon, 29 Sep 2025 06:42:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: don't use __GFP_NOFAIL in xfs_init_fs_context
Date: Mon, 29 Sep 2025 08:41:54 +0200
Message-ID: <20250929064154.2239442-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_init_fs_context is early in the mount process, and if we really
are out of memory there we'd better give up ASAP.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index bb0a82635a77..a8fe8b042331 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2275,7 +2275,7 @@ xfs_init_fs_context(
 	struct xfs_mount	*mp;
 	int			i;
 
-	mp = kzalloc(sizeof(struct xfs_mount), GFP_KERNEL | __GFP_NOFAIL);
+	mp = kzalloc(sizeof(struct xfs_mount), GFP_KERNEL);
 	if (!mp)
 		return -ENOMEM;
 
-- 
2.47.3

