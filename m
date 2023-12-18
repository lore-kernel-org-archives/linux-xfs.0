Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973DB63A3
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 04:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="z20Tw39+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=rngLYiBVnIww2phDsWieYGqouhphNgfqZeCFglD3uxQ=; b=z20Tw39+AjRSzsd/BQ63ynHZzm
	wdZFJ7JrC4jESAW1TcOzkVcVogc0sBfSZXMzqqhic4NgljI9CHuQ45qjuoBt9Xl7r0M1BJjRmIkgD
	f492i7MRZDjk1q6l3Sso8tzb9ZB7GkpSZu9vfnK/RdKI34NGnSRomuMXP1RkOJRNeJjsNfiYVmyUx
	30CYLEKjrywwQLfzOkpT3GwG2hetpDhqUTUNgYWzUZOFHKQ8m8gLTs7B8/Zq9TknhIQehDJVNc0CH
	8eARIjCufJ7hIJocpcs+ugfXax/IQFcwVcS2T+4+9wAknXWuMHg0rkzA/2TlchR3pjvZW3Qf1HWa3
	RXjskmhQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rF5hI-00956Z-2O;
	Mon, 18 Dec 2023 04:57:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 02/22] xfs: turn the xfs_trans_mod_dquot_byino stub into an inline function
Date: Mon, 18 Dec 2023 05:57:18 +0100
Message-Id: <20231218045738.711465-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231218045738.711465-1-hch@lst.de>
References: <20231218045738.711465-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Without this upcoming change can cause an unused variable warning,
when adding a local variable for the fields field passed to it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_quota.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index dcc785fdd34532..e0d56489f3b287 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -127,7 +127,10 @@ xfs_qm_vop_dqalloc(struct xfs_inode *ip, kuid_t kuid, kgid_t kgid,
 }
 #define xfs_trans_dup_dqinfo(tp, tp2)
 #define xfs_trans_free_dqinfo(tp)
-#define xfs_trans_mod_dquot_byino(tp, ip, fields, delta) do { } while (0)
+static inline void xfs_trans_mod_dquot_byino(struct xfs_trans *tp,
+		struct xfs_inode *ip, uint field, int64_t delta)
+{
+}
 #define xfs_trans_apply_dquot_deltas(tp)
 #define xfs_trans_unreserve_and_mod_dquots(tp)
 static inline int xfs_trans_reserve_quota_nblks(struct xfs_trans *tp,
-- 
2.39.2

