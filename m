Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F12238D2D
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 18:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740596257; cv=none; b=hDL9OXv27omqw9VNxlg3xbcCxJImpT/YLXSAlvGeOuvncEilH987F8aK9eAOl5HQXrVMLN684JqBohRUld9YQEWd9l+7CdNEL9Xn33oC3Z2Rbd6rzDON7Jz/BX97xW87GZsiZDIbvtETxL6TTQ3o2mR6qztgtVL034bAf2hMG84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740596257; c=relaxed/simple;
	bh=D0AvWTo8yMH1iQjDo7+was6klsYOBuBCA//bCluYxmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pjQgqvy2LhSjnBooDaOSWGwB8kbDtmbT0/S00x+uUdIB0StTZqZ/Vwst5TlUdzZxh55dCqbKPvqmQrU6r6Pjpx0+djFvFoCZhXpbI03u1YnmGfFaiFS6M834TxkZLwy5sCXpSB/SqQKkYgEfOAarH3njQKox2V66a8gR/Ysm93E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=T461egWe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="T461egWe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QUTwTCOner/UAZVqFE+3JUmlqfID/Nq+OSHyYmmIGXI=; b=T461egWeO+cVbpDZ6jXz1Q+IuG
	g3z2T8jztH/IOdzjT3xH9V824bPJ6nIBMpqWqDe34kNbgCEuwHH3TG8BDcGXuIZ3Yp//v9SQAKaXZ
	q5BMXBw5da9F/GFvu9e1imhZEELf9BpSxMWLwQNkEwV6kg2DtS+g97G3fw5x63Ir91diUuC9B6bzO
	QgX5lnJ500utYHoM6X73jXXD0Zrjz4i7RTtrhxIjsmszYKfBKjvfQKkRWKlWKl/+Rkdi5s1vBlulL
	yE4z0s2eKA60lCXoa1ruVogfsHsEI9jOIImW87VZ83Bn16Pe8FdCyhTV583G4EictzRWc3a8PNMGZ
	SMDheUYA==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tnMb9-000000053wv-0m56;
	Wed, 26 Feb 2025 18:57:35 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 36/44] xfs: disable rt quotas for zoned file systems
Date: Wed, 26 Feb 2025 10:57:08 -0800
Message-ID: <20250226185723.518867-37-hch@lst.de>
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

They'll need a little more work.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_qm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index e1ba5af6250f..417439b58785 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1711,7 +1711,8 @@ xfs_qm_mount_quotas(
 	 * immediately.  We only support rtquota if rtgroups are enabled to
 	 * avoid problems with older kernels.
 	 */
-	if (mp->m_sb.sb_rextents && !xfs_has_rtgroups(mp)) {
+	if (mp->m_sb.sb_rextents &&
+	    (!xfs_has_rtgroups(mp) || xfs_has_zoned(mp))) {
 		xfs_notice(mp, "Cannot turn on quotas for realtime filesystem");
 		mp->m_qflags = 0;
 		goto write_changes;
-- 
2.45.2

