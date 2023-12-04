Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gQCI7pIe"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F4ACC4
	for <linux-xfs@vger.kernel.org>; Mon,  4 Dec 2023 12:07:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=C7lirrRVpvvH0Ipb0RL6LLJt1pM6D3nn+FdEmYWhGKI=; b=gQCI7pIe1eh9FampFUAtMq5fEZ
	RhiPLs4VFGUJP7jkAkpmYvLl+X9PbmNSQWHqlIfl4nPkxK2D2blCa5zxfurt2ePdP682TxHC99OPF
	APQMCjCUhQ6Cl4Ps3Ntq6vImtevhMURkUxZccxtjnkXN0SqA3YAL9M8JnAeNwoj8WWIwK/t2dlAhi
	chuu8re8OZTHOIYIt4uI2Dkd1W7I8OTINuenMLPwyIir9nvgZylxNbF/9Y+mOKg5+PzzcB7qnmV7q
	E7+7OYe5pqAkvid0TXH3eTbO6jxYHRwP3lrQ+Lif/+lTdMjpKXEvMIK6gKUdw4cuJ02AJy7oJ4y6s
	3FFFqbyA==;
Received: from [2001:4bb8:191:e7ca:e426:5a32:22a9:9ec0] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rAFDz-005W9x-08;
	Mon, 04 Dec 2023 20:07:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: use static_assert to check struct sizes and offsets
Date: Mon,  4 Dec 2023 21:07:18 +0100
Message-Id: <20231204200719.15139-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231204200719.15139-1-hch@lst.de>
References: <20231204200719.15139-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Use the compiler-provided static_assert built-in from C11 instead of
the kernel-specific BUILD_BUG_ON_MSG for the structure size and offset
checks in xfs_ondisk.  This not only gives slightly nicer error messages
in case things go south, but can also be trivially used as-is in
userspace.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_ondisk.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 21a7e350b4c58e..d9c988c5ad692e 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -7,16 +7,16 @@
 #define __XFS_ONDISK_H
 
 #define XFS_CHECK_STRUCT_SIZE(structname, size) \
-	BUILD_BUG_ON_MSG(sizeof(structname) != (size), "XFS: sizeof(" \
-		#structname ") is wrong, expected " #size)
+	static_assert(sizeof(structname) == (size), \
+		"XFS: sizeof(" #structname ") is wrong, expected " #size)
 
 #define XFS_CHECK_OFFSET(structname, member, off) \
-	BUILD_BUG_ON_MSG(offsetof(structname, member) != (off), \
+	static_assert(offsetof(structname, member) == (off), \
 		"XFS: offsetof(" #structname ", " #member ") is wrong, " \
 		"expected " #off)
 
 #define XFS_CHECK_VALUE(value, expected) \
-	BUILD_BUG_ON_MSG((value) != (expected), \
+	static_assert((value) == (expected), \
 		"XFS: value of " #value " is wrong, expected " #expected)
 
 static inline void __init
-- 
2.39.2

