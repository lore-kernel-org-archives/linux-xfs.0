Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769C61A00EC
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jan 2025 09:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736157057; cv=none; b=pQ8mlRS+YpL3CcQ8fKXgLGWt7f9lNEfLNwH7DxRiolt35hqDhcf2cugVOKDuJwKyTksBeSmhjb7Y0oc5Q8SwzSRCEVCYy69S12F8T6SIY7PXJmlUMWhbzPRyok/SwR0TlVR79wQ0L2DclLaxBGi/ryBGl6C+Xv12C9u14SHn9BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736157057; c=relaxed/simple;
	bh=lucWGSp0mD10wEufTjggfGWFrxYarU8oRW+07rCzfjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WuwK+hWxXOAnnHo+4DfYXuK7wGom6wVoswNAa14NlEW33nWE5AOAzrchlE/Ki1IfMhDpfreBG/csn1S62O4F21U0NUSdL8mQjEyT3sV8wsbPZ6khOr1qAMUVPYleT8eYGdFv5FNPhdps8jQVZ33hC8IjIO2vrsHMQK/BxpztFco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2o2yTXv1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2o2yTXv1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=YFKnyzQfVcY0PNPH6AJ2RAyj7JLUqWXHgpOofdpYQkY=; b=2o2yTXv1QxBfOgqK2rjfGCH5Mx
	p/4Mq/EfhyEqlg1VDxG9M60GhAgxpnyeeyTKTkXR4SzE3KGp6uYn2UFfd55K9STVjkZt4AEKyqlmb
	zkpdDMIi8/zP8F+OFKJTUlyEjsM24aQMBayj4+ZjLHWkB/USW0tpvzgzqAcdc4Ajl5jvwW2LnSidG
	AIaVLp6g0fzaA1ZW/v0YuhgfwvvFCC/Fle9Ubd3lYE7pcML54rECfpFKW/PSOF1da1b72KpBygoT8
	n+lO79o0xQhWvVlk0Nhf4NTkals8LWEa/y9rFyRfptQkP9re+XFaNqIsbnTdh66yXqrVrOa6p8DYc
	qyW+xZHw==;
Received: from 2a02-8389-2341-5b80-db6b-99e8-3feb-3b4e.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:db6b:99e8:3feb:3b4e] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tUjl8-00000000kCn-1xiD;
	Mon, 06 Jan 2025 09:50:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] xfs: remove XFS_ILOG_NONCORE
Date: Mon,  6 Jan 2025 10:50:30 +0100
Message-ID: <20250106095044.847334-3-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250106095044.847334-1-hch@lst.de>
References: <20250106095044.847334-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

XFS_ILOG_NONCORE is not used in the kernel code or xfsprogs, remove it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_format.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 15dec19b6c32..41e974d17ce2 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -351,12 +351,6 @@ struct xfs_inode_log_format_32 {
  */
 #define XFS_ILOG_IVERSION	0x8000
 
-#define	XFS_ILOG_NONCORE	(XFS_ILOG_DDATA | XFS_ILOG_DEXT | \
-				 XFS_ILOG_DBROOT | XFS_ILOG_DEV | \
-				 XFS_ILOG_ADATA | XFS_ILOG_AEXT | \
-				 XFS_ILOG_ABROOT | XFS_ILOG_DOWNER | \
-				 XFS_ILOG_AOWNER)
-
 #define	XFS_ILOG_DFORK		(XFS_ILOG_DDATA | XFS_ILOG_DEXT | \
 				 XFS_ILOG_DBROOT)
 
-- 
2.45.2

