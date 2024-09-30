Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A94E193078
	for <linux-xfs@vger.kernel.org>; Mon, 30 Sep 2024 16:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727714558; cv=none; b=g+NMCXTn2f3JVShVMpFKanIm0hZ52VSdWuWY5ymVW5gb3lJHJgiw+q9nCTMhgCJ0Cf8y8HaSu2xdpi9EnaK4Ng/MEP3Dy3G8VTVr3IlFJ5md8AqxbfEPT8debZ5VWhmlmKGsfOvJa9nvMYh1gA3ChlJW12wYvPr3dMNKXrEIm5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727714558; c=relaxed/simple;
	bh=Hyq/YE0NzZRi39khtV+3zvGIK6fFPEVvfsNoDNKwKow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OIRcNeRL1SSfVfDe14co47svZ7Vil5E4V1jw5/h6ZwCfLHL33/r5b5NMlhLCtz0WGssZRp9aM/c2NH4MEsm4Pk0wyalMhDjDorSaAQkLWcptf/8we6kdlCMk1YPhZ124ivd+VoNEQ4l9ToFUL5v6S2ZwkXFm0a1Ox4SPCaoDebo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=x2qObWBb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="x2qObWBb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=qDh2ssTVh7WPcnLxh1UUgBjhIzyN5CLUw8IZbvq/w08=; b=x2qObWBb4Ijlo5MuS2XFLeOnAt
	yWDu0jwmrungjfBO+ZgL5eUL3VTg4Eakj2zSQ8ZHNnTowy4PPvbExJX1F/lre/3COZMXJv3/NfLlo
	0F+DhWEYveMlmEW4SzbpqJas5sDrZ6WeL2ndRfjLEx+BznyqkTceBpTDuK/t4gVGsp1WEFd/0mMLz
	WqNLQfZPORBl2hSp+81EDdhb/ZYuFVo5sTYHRrK0kM4bpXRV99t0bPIJW67RWr4fHY9v4cUvXEQWH
	ug2dhXfs+MVGu9t1+OY23C5ynNhTMALdj3OtpVG3PcGTmCZlIhoRwKWjEd0Cp2tKWBHlEOyipwuRG
	vJEznzZQ==;
Received: from 2a02-8389-2341-5b80-2b91-e1b6-c99c-08ea.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:2b91:e1b6:c99c:8ea] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1svJTo-00000000GcK-1pNz;
	Mon, 30 Sep 2024 16:42:36 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 5/7] xfs: don't use __GFP_RETRY_MAYFAIL in xfs_initialize_perag
Date: Mon, 30 Sep 2024 18:41:46 +0200
Message-ID: <20240930164211.2357358-6-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240930164211.2357358-1-hch@lst.de>
References: <20240930164211.2357358-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

__GFP_RETRY_MAYFAIL increases the likelyhood of allocations to fail,
which isn't really helpful during log recovery.  Remove the flag and
stick to the default GFP_KERNEL policies.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 8fac0ce45b1559..29feaed7c8f880 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -289,7 +289,7 @@ xfs_initialize_perag(
 		return 0;
 
 	for (index = old_agcount; index < new_agcount; index++) {
-		pag = kzalloc(sizeof(*pag), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
+		pag = kzalloc(sizeof(*pag), GFP_KERNEL);
 		if (!pag) {
 			error = -ENOMEM;
 			goto out_unwind_new_pags;
-- 
2.45.2

