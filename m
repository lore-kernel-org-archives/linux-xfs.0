Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2E0225777
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 06:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738824401; cv=none; b=s2FDbet6oD7U3avFieBOFZDygauMvAfFWRa/pUSenGrTeousREYIk2d0aWxDovc+k59J8RoPKAL53RhHVgVucWxYf5O8IwJsFr863zpSd6UUb94thZ281WUa+7xJIacRmmhbwl75pThQ192xMeiZB0ul39DRFnzmB7gpmPfG1iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738824401; c=relaxed/simple;
	bh=o4qmu71mfsG0w66cyvwU+ui0elQnmaPwk3CEYVzA/w4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iO8NV07fu4hRZFznJEkM0UwDWhNIseu7XWwYzurQj/6xgVb9uHkNDKmJPWHBvRnYD9fbQwY1JYiaUFDz9yzds5vXlKnvWxFvfU/a9C72n7PbEvDOsMMvwPmD3p/oPs+/83Qjp107O/TvYKfUQB5I92PdVmx0sfdtCApb3PTk7Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JoBzzgr/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JoBzzgr/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=bC3TDk74gJ3fKZm+X3vAcQvxIZluCPHKLeeO5DbfNqk=; b=JoBzzgr/moEtLVV3HN0+dTLhVe
	i0SDsNpo+tnJ7Tchjxrsymqs4YyE/+sewOnpw1rkxlDt1/qB2+z3tlHMlgGlX6S/X+4beOt/zO9Gv
	AvgqP6c/s6jmM8YeiLtinv9ugAEXNyUHVuCYONC8Kw0IWyfJfUQFrCH9GDDnzfPyA0xLVw404dNFX
	7Ue2S/cphRX0x5Jt4+UNrpkgFok2ACQsqSjlLpRWvM6111YpMp3Hv6N07xECkE0uFnb6lo3HkcFxm
	nyM4mKaXHMhXuuw1k9P25H7baOrkq4/Qx2ZKh2M9BC3htq62nOFVsmO1NHGIHn1BwSfnYPzDfmAlM
	OKpf680w==;
Received: from 2a02-8389-2341-5b80-9d5d-e9d2-4927-2bd6.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d5d:e9d2:4927:2bd6] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfvep-00000005QiB-3ThX;
	Thu, 06 Feb 2025 06:46:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 30/43] xfs: allow COW forks on zoned file systems in xchk_bmap
Date: Thu,  6 Feb 2025 07:44:46 +0100
Message-ID: <20250206064511.2323878-31-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250206064511.2323878-1-hch@lst.de>
References: <20250206064511.2323878-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Zoned file systems can have COW forks even without reflinks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/bmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 66da7d4d56ba..4f1e2574660d 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -1038,8 +1038,8 @@ xchk_bmap(
 
 	switch (whichfork) {
 	case XFS_COW_FORK:
-		/* No CoW forks on non-reflink filesystems. */
-		if (!xfs_has_reflink(mp)) {
+		/* No CoW forks filesystem doesn't support out of place writes */
+		if (!xfs_has_reflink(mp) && !xfs_has_zoned(mp)) {
 			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
 			return 0;
 		}
-- 
2.45.2

