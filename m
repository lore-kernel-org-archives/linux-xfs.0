Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="URYQmOV/"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39CFED44;
	Wed,  6 Dec 2023 23:27:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=WP7kO0AnWsmxJgL9BTgKd8gFOHO+tz/SXOo3qvhpGqk=; b=URYQmOV/3fWZouPH4qcfUowKx3
	EuEA3IwhDPwsVpneYJ2Z1ne+WPoHrUqAYw6Jw9KZprSh4IZlmFoNeOUlHV6vFwcsxKI8dv2uJGlSb
	TFYv3eWWBkjrN9Jq7xcCyxayY1mRKVTehIVfiVpUm2Cgc4wKXtjk2SoKbGqben+TmKO85C2YytsMD
	ak6t3wjc8qspDZZvuFnWYC8ihhYb9Z1mcO1ZdeWhw9eXyjPfzfqKMqOSrAh3mzSPq+pw3QP6NCuG4
	0lYTh+X54P9f6YMPcPrmP1JIYxdDDxN8ot8h1RHf/B6i/akO+u/bnNW2QLTwIMbOo5GIYRoxmxO6n
	6m1RDTiA==;
Received: from [2001:4bb8:191:e7ca:4bf6:cea4:9bbf:8b02] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rB8n2-00C4yI-0I;
	Thu, 07 Dec 2023 07:27:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Zhang Yi <yi.zhang@huaweicloud.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org,
	gfs2@lists.linux.dev
Subject: [PATCH 02/14] iomap: treat inline data in iomap_writepage_map as an I/O error
Date: Thu,  7 Dec 2023 08:26:58 +0100
Message-Id: <20231207072710.176093-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231207072710.176093-1-hch@lst.de>
References: <20231207072710.176093-1-hch@lst.de>
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
index fc5c64712318aa..2426cab70b7102 100644
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

