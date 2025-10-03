Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C23E1494DB
	for <linux-xfs@vger.kernel.org>; Fri,  3 Oct 2025 10:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759486398; cv=none; b=fulDP5qOI0BE8sQbBpQlwgXdm0wGNkj1Tp/5kE/k84Pf3X3kmkmV00jyX1LARq5R4AnEcS93DSRQMPRcsi2q1g54m2e9KdCG9Rkozl2gQw6ZD1d3QloWm0Jt3/MpSuEoAVQu0KqHL9L3rfagdPZJc7xFfSdTjl5YcSrpudXmBfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759486398; c=relaxed/simple;
	bh=trtN8Tzwo65jTvLl6fNrap9kh3jqTF4qK2BEVskBi/o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sypo/AEDNnK3y9o+3drNKqi2QxHYPZzWmQ6xGj10q770t6wIRQHqDZVDFqY6pM+g1Zc+Us1vWlrvv+Hp9Q7EPq/IqLI3pJktWeAoD9A9Nq6tAW59t27ISUWCPKyJTWwNrcbvP64m3YSW+MI9iJkLqE18ba/AO/Ag7NzED80J/yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3hUZm+OU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3hUZm+OU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=ZZS7CGa0e85dHDbXOzF167Lz5dE4IThzdb8EkkGJuMM=; b=3hUZm+OUhUSaDwyQCtpj4Fa/SG
	LSOqtrgZvcaK+QXWRoVshj/YK4TUZdE7mknmKOTrALWr9Wmfop6KXTzDJh2dCpyFNPZyJ2LlgHjW9
	23QezURfibX+oTvUA5T6RZsxisLtZxdRi4KRgSl4v0Ti97KWLPwjs2SGc/grx7rInd6UpgJg1/Del
	ojUGXqqmmfAXTeXhYI5Er8HTrehhLibrfwbxHlDWEW07rocAigw+E0gJXseLtDXbkSW0DTf7QhWsg
	2Sq81CKH4Yk90oVPW0IorNPQnsIu8yolrKlExgxIV1G+77OZHR9QS8JFU/EboGxbA5R1NRIBNsc2r
	5WYOObbg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v4cmo-0000000C1BF-3xih;
	Fri, 03 Oct 2025 10:13:15 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: darrick.wong@oracle.com,
	raven@themaw.net,
	linux-xfs@vger.kernel.org,
	syzbot+359a67b608de1ef72f65@syzkaller.appspotmail.com,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH v2] xfs: don't use __GFP_NOFAIL in xfs_init_fs_context
Date: Fri,  3 Oct 2025 12:12:48 +0200
Message-ID: <20251003101307.2524661-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

With enough debug options enabled, struct xfs_mount is larger
than 4k and thus NOFAIL allocations won't work for it.

xfs_init_fs_context is early in the mount process, and if we really
are out of memory there we'd better give up ASAP anyway.

Fixes: 7b77b46a6137 ("xfs: use kmem functions for struct xfs_mount")
Reported-by: syzbot+359a67b608de1ef72f65@syzkaller.appspotmail.com
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---

Changes since v1:
 - update commit log for the proper root cause, add Fixes and
   Reported-by tags.

 fs/xfs/xfs_super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e85a156dc17d..8aa562a8b60b 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2221,7 +2221,7 @@ xfs_init_fs_context(
 	struct xfs_mount	*mp;
 	int			i;
 
-	mp = kzalloc(sizeof(struct xfs_mount), GFP_KERNEL | __GFP_NOFAIL);
+	mp = kzalloc(sizeof(struct xfs_mount), GFP_KERNEL);
 	if (!mp)
 		return -ENOMEM;
 
-- 
2.47.3

