Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1702A35E95A;
	Thu, 23 Jul 2026 05:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784782981; cv=none; b=O2xxpNw/gLKWqXKc3gdjQqbTnbL80mSeDFivYh6rNyCYGOip07AclCu/EaLef8H8SE60InakqJPry/WQmlAADOWd8hPMZ5hlNkjYqtyEPAtcQ17IOh8/tqter0IVkzx9190ES/p3bZX5mTDrW3ZBPreQkwjyUv5TZ7SrvKdHlCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784782981; c=relaxed/simple;
	bh=UQ5RSswaSvyxLB7OSf/Ggqz+25hgNErhHCz2IVHB1J4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QLYxcfUAZSf/IWu+6OCo1Pl4I4sJvLytoz0bDjAzhGKNrXDiRezTtVIhgjVCPgfPdKctcpO4mc3m5jfx5DVEwuMLlULpqCQJmCmL/svyWlNcDfCoMTvPv3CKJgJnYxSOVJoIeYb+qjqN/IPpYBkWKABTMnJL/a6ENjrtva/FY+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TSMfhQws; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TSMfhQws"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5sI2oX2b/cuxDhEPa3JzhOeZCWG+ASMu6y88Mew0aIk=; b=TSMfhQwsyzvAxAw6OgdNoHf4C/
	cHutA1wLKJcjDobhjdQ23S9b/CGayiiIwKFmnfmlkRsLaOESlslpkPitSaTFTE+jVnUTGOf+V1CTV
	i1XuY5Oj6mwnVZGtj4WEAHxLC+5KO+MQBxmUpL1Dyr0heJ/iJ9CJ2930+yFrC4EdrvnfJ+Nnc/go/
	QdXLtVPj7Jk6H6wmp/xOl2YUXIfcn5uUmIlFNyOwGqdYI6g0B/GWTZzmNaVl8AdRCpE3JBvWUaHxo
	fD1/y0nSHIKz47F11Cceu+rcuXaMP2ikWB1BjDDWbM5q1elUHQBQu1y8P9wDCHZrw8AmjlAhSRcXy
	+/aymh0g==;
Received: from 217-76-162-32.static.highway.a1.net ([217.76.162.32] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmlaD-0000000DRYX-1PF7;
	Thu, 23 Jul 2026 05:02:58 +0000
From: Christoph Hellwig <hch@lst.de>
To: changfengnan@bytedance.com,
	Joanne Koong <joannelkoong@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Carlos Maiolino <cem@kernel.org>,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 3/3] iomap: use GFP_NOWAIT when application for iomap_dio_simple allocations
Date: Thu, 23 Jul 2026 07:01:41 +0200
Message-ID: <20260723050201.3381045-4-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260723050201.3381045-1-hch@lst.de>
References: <20260723050201.3381045-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

For non-blocking iocbs we should avoid blocking allocation where
possible, so switch to a GFP_NOWAIT allocation here.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/direct-io.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 36c976cf0848..5c28124b9f02 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -986,6 +986,7 @@ static void iomap_dio_simple_end_io(struct bio *bio)
 ssize_t __iomap_dio_read_simple(struct kiocb *iocb, struct iov_iter *iter,
 		struct iomap_iter *iomi)
 {
+	gfp_t gfp = (iomi->flags & IOMAP_NOWAIT) ? GFP_NOWAIT : GFP_KERNEL;
 	struct iomap_dio_simple *sr;
 	unsigned int alignment;
 	struct bio *bio;
@@ -1015,7 +1016,11 @@ ssize_t __iomap_dio_read_simple(struct kiocb *iocb, struct iov_iter *iter,
 
 	bio = bio_alloc_bioset(iomi->iomap.bdev,
 			       bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS),
-			       REQ_OP_READ, GFP_KERNEL, &iomap_dio_simple_pool);
+			       REQ_OP_READ, gfp, &iomap_dio_simple_pool);
+	if (!bio) {
+		ret = -EAGAIN;
+		goto out_dio_end;
+	}
 	sr = container_of(bio, struct iomap_dio_simple, bio);
 	sr->iocb = iocb;
 	sr->dio_flags = 0;
-- 
2.53.0

