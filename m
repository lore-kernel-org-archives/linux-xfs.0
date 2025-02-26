Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B6C239090
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 18:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740596255; cv=none; b=dxJofyRQDfTQGTGTKu1zsNsUn9hWK7jRmo/VAN3Wt9hdX7Fx3qSeC80r7bTnHATYD1vcSljrJqOSsN+MGNTWHEU6aytHC44fZvGWBjONHjJNuiADRbPmVH+8SaqLKuW/6+qoHwhMNHgkCZd+drSQfX95O0svuBKUdAPX9Ye5qvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740596255; c=relaxed/simple;
	bh=o4qmu71mfsG0w66cyvwU+ui0elQnmaPwk3CEYVzA/w4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ls22OE+Z4Gg1XsPkC1ft/4IIDLyUjN71v3sNvABk2k5SZ2NmIKxHT9TlmYICiYnPOOW+nT/GbjYPKeBFKmuZGo+aVQVYAD2bUWjLRT/X9e7l39GMLzSjGKBZMqbLxk1CShrfI1BcP4UADI47UunTq/Ytx211Qpkj0JwYL/WxSSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=z42mrHQA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="z42mrHQA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=bC3TDk74gJ3fKZm+X3vAcQvxIZluCPHKLeeO5DbfNqk=; b=z42mrHQAVp8Dxa4eDrkJWdJhZG
	ElQTXi8zCJbQRfhH53u8Q92uMUcFHshE9bXK1pJ91VG96b5JgcV+7joPNqLGSOmuWhLN7WkHDn1S9
	PXTpaGETPoZx8QdiWAolyUpEKP+gvdx7fTxaUfgrufIHuq82S5d/immgeu/wa9lZfJUFs2TcEaZKW
	wyjboHMpVtrycCajHZkAfyU7fjGMKdyeKdRjQ+PaACKfw7jVRNqI4JMjwIKnhQF4HtjG/EUGVpsZb
	NtguGd36Z1my7KSoL0xQEuA/hAbTGAUbJtLiIm2SaLkQ7zdTh/XnM6fPY0h7hnaVCnArgEqNw6/Qr
	EhnweRbQ==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tnMb7-000000053wJ-2unA;
	Wed, 26 Feb 2025 18:57:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 31/44] xfs: allow COW forks on zoned file systems in xchk_bmap
Date: Wed, 26 Feb 2025 10:57:03 -0800
Message-ID: <20250226185723.518867-32-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250226185723.518867-1-hch@lst.de>
References: <20250226185723.518867-1-hch@lst.de>
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

