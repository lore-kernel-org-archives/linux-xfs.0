Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A744EB676
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jan 2025 09:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736157384; cv=none; b=qG4EiC8d9vXqw/yoerBY3/0Aya7B3LKHj6La39cbA0SR/QJzsQG6edjaHttGsaHTEhWLfekQlz0i9B06GiWh50EPLzyOg4ATRN5nXb+17g5hFpIwov4Xavf1zLSxJ9eJWUhXXP9C4MkXdMLH2BncU+2inTdpUSFUNA7ek7YsR1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736157384; c=relaxed/simple;
	bh=OsEB0Kz8JoZ8+uz2WL48xgaYQ8evu5ptBK60qKkEcxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uz3lK9WDcbF82ObJ5EluRR/W64By9iyTg4a3mUAjRoebTnUYkliNb1TYPFFWg7zFp5Uc25p4cUG6Wl6FjIvFiyZXHPlT6azCnAGgWkmU95Pjz1dWBBxC18S6w78+82/FMsIrjaZiZfW32Npl0hy5eAV+AJMFe/oqQYfTzeY7110=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3Bli0s3N; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3Bli0s3N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ws5mXIkIL3izsupIVy1AsPa0/+0ZJ8noCFD071mamsE=; b=3Bli0s3N1zeuD6yMcijpfl2dCa
	4DMC1W+kcvIpLP0XtyF5glZUP2BFF6D7wxjBwnM4dFINQQ7y0KOVUccgSDzyDuFiV+BxKCt1emBnM
	h/02HqGrsB4PHbBDyGx+5nbrxg8Aqk8tAPVK80oozxGGv6dEkiSB2FIwX1ZyB/HU+xmzht3hnPxaW
	Ys+JP7FA0TjbjCfTxPR8ECwD2LmrZtP8PAAnbsdEebP9NiwKyrHcKJkPzfqAAmc3MnNvm4hu62p72
	e5ueyVm/woXfAcEVbdzhG6GqDLohwhbUQ/h7YDP4Cc/JAlvqoINTyw7ULDDSUbiK0Wc8wK92WffQJ
	RtAfaHrg==;
Received: from 2a02-8389-2341-5b80-db6b-99e8-3feb-3b4e.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:db6b:99e8:3feb:3b4e] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tUjqP-00000000lDM-4Aun;
	Mon, 06 Jan 2025 09:56:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 03/15] xfs: remove the incorrect comment about the b_pag field
Date: Mon,  6 Jan 2025 10:54:40 +0100
Message-ID: <20250106095613.847700-4-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250106095613.847700-1-hch@lst.de>
References: <20250106095613.847700-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The rbtree root is long gone.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 3d56bc7a35cc..da80399c7457 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -187,7 +187,7 @@ struct xfs_buf {
 	int			b_io_error;	/* internal IO error state */
 	wait_queue_head_t	b_waiters;	/* unpin waiters */
 	struct list_head	b_list;
-	struct xfs_perag	*b_pag;		/* contains rbtree root */
+	struct xfs_perag	*b_pag;
 	struct xfs_mount	*b_mount;
 	struct xfs_buftarg	*b_target;	/* buffer target (device) */
 	void			*b_addr;	/* virtual address of buffer */
-- 
2.45.2

