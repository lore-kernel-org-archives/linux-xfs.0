Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5010131329A
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 13:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757942834; cv=none; b=dNuB1TP4UaDa7B+w8BXIiA4cxnIZ/aGb1NZMe9E3izgBDBvK4LYuH6NsPo6dkg+4lhl7/f9RBMmf3yLQBbsjWCrf7MuR1tpz1V2EvdvQ5a7SLGSNPLvHfzny/qCF/MgSl/DlSDVT77dUFWEt/NrcSs+xkK2kiohn9nU41NOpmZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757942834; c=relaxed/simple;
	bh=W8dvycFTMv8ijEB0n3lKfIx1zLAPLksSgnrl2d3xnBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S7RNu0naX2hAZ8XQ8giCyyty/jiFCiYufDDVZuzXq4e++fcoXIqHndtCsg1w9ZXYza48lrWcfFs3TikSDuFLLPf06H02gMnvmUpeVu7u2epf1YCVX3hJdV9qYXUEUpkrk1nDOx8RmrYaTMLudEbeXL7NtMj1dVbjfnBQRh36Mdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xPD+5ewE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xPD+5ewE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Ysk54RVvSyHBpMYJ+Wqw5JKYKwXplbGT5gNNOxyGeuk=; b=xPD+5ewEwDUOguDCEWkU7gvUpG
	j8VEkQ1q2jVoh8Vi4YABqXiFRduRxfIJG87DK+WgGsJwcinkFiK1BeO+Lk4EKrtsyC2jNxjoqTbEx
	QzQpbKtk/t/1Jw0POqn00drQ/jtheTq0OUGZzXG1AUc+Vh87XzHiNwm/I+by9dLCYwFEhgoZlRwcn
	w0EHHUtr61Z9IdBSHDrbucX9jb2VM4uRVM/yp+M86E5YDptarWFqi0N0O/3DhgTbe7H3eQTaK77sA
	57534dg2lv2jKzMWmutBhGkB4X0/QR5YEka2NUGzIAzLobh9J+86NbzbS4Jj1/Q+PsViQZtwlaAk0
	7BQ3Ogdw==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uy9Ee-00000004Jbq-2qaE;
	Mon, 15 Sep 2025 13:27:12 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 14/15] xfs: remove the unused xfs_qoff_logformat_t typedef
Date: Mon, 15 Sep 2025 06:27:04 -0700
Message-ID: <20250915132709.160247-15-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250915132709.160247-1-hch@lst.de>
References: <20250915132709.160247-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_format.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 4ea9749f98e2..c1076e4f55be 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -965,12 +965,12 @@ struct xfs_dq_logformat {
  * to the first and ensures that the first logitem is taken out of the AIL
  * only when the last one is securely committed.
  */
-typedef struct xfs_qoff_logformat {
+struct xfs_qoff_logformat {
 	unsigned short		qf_type;	/* quotaoff log item type */
 	unsigned short		qf_size;	/* size of this item */
 	unsigned int		qf_flags;	/* USR and/or GRP */
 	char			qf_pad[12];	/* padding for future */
-} xfs_qoff_logformat_t;
+};
 
 /*
  * Disk quotas status in m_qflags, and also sb_qflags. 16 bits.
-- 
2.47.2

