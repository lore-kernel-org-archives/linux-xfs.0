Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1vO4OfW/"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8C35A6
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 22:34:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=36Bx+rypWEqGBqK4hOqqgavE5SBI8neHwKyba9c2y5s=; b=1vO4OfW/42wf4t5mIuEjQoKJtf
	bNBDEF2UkbswRrZpFc4lB5ylzvwnIU8P7+Fks3A24BGMAlS7NIardiPltA0KNm/WJsogflsBPSVer
	wror7wJMAmHI5gSkYfgNwCTHe9bAseK92BJIAw5bHL5vsj3XcKxvioy/UtDfv/dOyOdf0dcgWYaqw
	9IDioNmZWodW1O7gW2l2bnDGFxeWcjtXFb1qNFNmadL0xKWYXwOZlwn0BGDYEunLuhbtfpEDmDSKs
	ZEJrOLoLxeOolhj+ujv4FkbRVCzUXCqTQN8Q98yRrgrgEDkUaq9+unIsHQaMBslGu9BSZmUP97iCg
	g8wCp1bQ==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rDfJ1-00GzJG-03;
	Thu, 14 Dec 2023 06:34:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 02/19] xfs: turn the xfs_trans_mod_dquot_byino stub into an inline function
Date: Thu, 14 Dec 2023 07:34:21 +0100
Message-Id: <20231214063438.290538-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231214063438.290538-1-hch@lst.de>
References: <20231214063438.290538-1-hch@lst.de>
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

