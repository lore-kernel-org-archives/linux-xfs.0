Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A201537D2
	for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2024 06:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723444372; cv=none; b=Z8wUy443wB48wvvJS4ZdXOKo1W+XG2HFvRg3CYVvkfH+DHry3RKuCQIHyOO1PPfIU5y+wehFrIbz+Lc6dsQp2ZFSYLGUuQAzs3nuMYBag4bb+glH4HH3l7YlEGB1z1ZZhalnAp8RljMfSH9HOjBsBOcXhKinLTsZ3mR2Mh25F8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723444372; c=relaxed/simple;
	bh=z9/gSWP5gc+UZS2oathWIUHbFPf39I7xrYe/be5QB+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tWgj9/Wk2ljHleBqsy6yCf6JjxLuwd8Crf+13cvK15m2iqOFPdWcwbIhIV/XCWdoaAZ/bAvMaGrRbKF7S7bmzKsO2o2enFqrQ05gTI8S0MneOXatIFwb07tHEZjLncoDamKJoS/n+rMJC3hztS3Kadna2SgPwcqWJGR0y99VqFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PVOtiZIU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PVOtiZIU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=VtBha4XqRWa+BqQihXo/qeCG758gnIQFhKOOXdOKGXg=; b=PVOtiZIUaHNGDewTwBzg8lUP72
	44kA6ruQsWP6uACuol+T/aLa0DywCkilg7u9ABDlkgsvL9Gu72uaPsuSMhuaQBjZWACMdp9l13DSj
	qK0gOgwXbdNfBlxmFUrUAGKBhPJnXpBNU7j+pzf20YklINByvOFc9sMYsodQ59iEXPwul+jQLDbxM
	XDWOsq9nLZFIfwPDclpS9WBpCE+xZTgXzwlht4QPMBOZprPQTU+SVT6jQ8i7NRY1K431Hj0JprgBz
	AFvAR8643y+jULNYoH7GAy0uRHTIyog336bRHnE+ZrJMTNCCO8t1jJMcBy4+vxWSQwxgbH3+GqGu+
	/10Et28Q==;
Received: from 2a02-8389-2341-5b80-ee60-2eea-6f8f-8d7f.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:ee60:2eea:6f8f:8d7f] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sdObq-0000000H1ea-1edR;
	Mon, 12 Aug 2024 06:32:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/4] libxfs: add a kfree_rcu_mightsleep stub
Date: Mon, 12 Aug 2024 08:32:29 +0200
Message-ID: <20240812063243.3806779-3-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240812063243.3806779-1-hch@lst.de>
References: <20240812063243.3806779-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a kfree_rcu_mightsleep stub so that code that needs to RCU free
AGs in kernelspace can simply use this helper in xfsprogs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/kmem.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/kmem.h b/include/kmem.h
index 8dfb2fb0b..b61385ec4 100644
--- a/include/kmem.h
+++ b/include/kmem.h
@@ -65,6 +65,16 @@ static inline void kfree(const void *ptr)
 	free((void *)ptr);
 }
 
+/*
+ * Stub for the kernel kfree_rcu_mightsleep.  Does not actually wait
+ * for a RCU grace period, so can only be used in code that does not
+ * require RCU protection in userspace.
+ */
+static inline void kfree_rcu_mightsleep(const void *ptr)
+{
+	kfree(ptr);
+}
+
 __attribute__((format(printf,2,3)))
 char *kasprintf(gfp_t gfp, const char *fmt, ...);
 
-- 
2.43.0

