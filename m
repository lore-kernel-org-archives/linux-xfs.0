Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wBpVm4XP"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A07AEB;
	Sun, 26 Nov 2023 04:47:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=VOJ+OhWMdxatCYdzTdcHH3XOKvdIXVzUwQzfovaJkaY=; b=wBpVm4XPcC2JRGSYRb7HrWSc1B
	IkQaEPRGoW1gxtPz85HmukgCC7wiUV7KKbaE5t3qnPPWsJAKBemx8hAFYzZmSccG8RRNi01gEEidi
	mbzs9Pd/OSBW4KAY77ldP28pwGlHYw2sKuDAZF5nQZHkg0og8of47aG9t42/qacmlEUg/25ZYyq1+
	1M7GW8j5IitSYXN8kPkv7qcfuOMlY7iXsdq/kBAPvti9cXPusulUPIZZv3GCXIFALW0MhBQotaT/K
	38w41Yjhsf1UfvrqQ5rVW+NOEmX8LbJ2InEdemGHadn1O+GQYwW+PQDY3kZ05t6VzkFcO5+FMlYNY
	YGyssV0g==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1r7EXr-00BCDU-2Z;
	Sun, 26 Nov 2023 12:47:32 +0000
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Zhang Yi <yi.zhang@huaweicloud.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 02/13] iomap: treat inline data in iomap_writepage_map as an I/O error
Date: Sun, 26 Nov 2023 13:47:09 +0100
Message-Id: <20231126124720.1249310-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231126124720.1249310-1-hch@lst.de>
References: <20231126124720.1249310-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

iomap_writepage_map aready warns about inline data, but then just ignores
it.  Treat it as an error and return -EIO.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/buffered-io.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 98d52feb220f0a..b1bcc43baf0caf 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1818,8 +1818,10 @@ iomap_writepage_map(struct iomap_writepage_ctx *wpc,
 		if (error)
 			break;
 		trace_iomap_writepage_map(inode, &wpc->iomap);
-		if (WARN_ON_ONCE(wpc->iomap.type == IOMAP_INLINE))
-			continue;
+		if (WARN_ON_ONCE(wpc->iomap.type == IOMAP_INLINE)) {
+			error = -EIO;
+			break;
+		}
 		if (wpc->iomap.type == IOMAP_HOLE)
 			continue;
 		iomap_add_to_ioend(inode, pos, folio, ifs, wpc, wbc,
-- 
2.39.2

