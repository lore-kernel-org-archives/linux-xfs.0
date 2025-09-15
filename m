Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD6530F812
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 13:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757942655; cv=none; b=Kj1Ldd4Mka/fVyBkgU/u4lHhQadWuELOUtm6kq8HxbE2vxszGmmItGe5hG7T/iOdDSkc++BFtqUcG8tAR0Nb2s7SU5o7AZsIfjzm/0EbYYDMbh6pB2s4RGRUK15wobGjgV77NGIs6yKVibxuPFOFdd6Pxk/ZSWfYOuwQ2JI5eWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757942655; c=relaxed/simple;
	bh=nKR7PM1F59yCrywQecKhr14RWcwqgRlihVVEgAIBzHY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BJI4+vh0VhzI39MMs2NSoppNIRLw6aM1hPr/HFkP5rRa0DndiS+Zn3Gk6+P/F92L9ylntXXNt0ZrNZZwXYYFbawqkmTLcv5Z5oivJhdkLOAjHhcxlwavqhnPyme0seAq+csuI824dViVxMW6oVku3cxiJHp3Xp7dSivTlLgfjWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DcdjXvSb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DcdjXvSb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=JIDBgjsYeHKpLM7YGmCTYFmgrZQ4PTzUMgfF/Q6Pyls=; b=DcdjXvSbgVmT2MJ+SuYjHEHhrk
	kVvKuBqZo4DXgQthri539HAPyhWSjmC8TblY2TsA++kgp9z5cyXJkmGWhieA6xMcezs3DLUQ6htAU
	mhWvD1gjmuFxTOQZDorlisAz/LziGYQnWYnZC3jXMEKP+/DwnwSCYBnuBs3ZwFurLPGXzrOHH6rgs
	bY76pdwVgXuNNXEyB1jQX9ryIuv4DRw2c5ccnlYEntHdjUzzoQyJIs09mj8CwsmvgI6kKccj6TR5G
	v16nYWCDAKHVmnMf15ZoFIamQg3gT6tWbJy3siD4rH8nI0hvqG/3LVTU8V2WmN0m6DTn8jFRZm8FU
	L87i7uBQ==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uy9Bl-00000004Ipq-3znk;
	Mon, 15 Sep 2025 13:24:13 +0000
From: Christoph Hellwig <hch@lst.de>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: move the XLOG_REG_ constants out of xfs_log_format.h
Date: Mon, 15 Sep 2025 06:24:13 -0700
Message-ID: <20250915132413.159877-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

These are purely in-memory values and not used at all in xfsprogs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_format.h | 37 ----------------------------------
 fs/xfs/xfs_log.h               | 37 ++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 942c490f23e4..890646b5c87a 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -86,43 +86,6 @@ struct xfs_unmount_log_format {
 	uint32_t	pad2;	/* may as well make it 64 bits */
 };
 
-/* Region types for iovec's i_type */
-#define XLOG_REG_TYPE_BFORMAT		1
-#define XLOG_REG_TYPE_BCHUNK		2
-#define XLOG_REG_TYPE_EFI_FORMAT	3
-#define XLOG_REG_TYPE_EFD_FORMAT	4
-#define XLOG_REG_TYPE_IFORMAT		5
-#define XLOG_REG_TYPE_ICORE		6
-#define XLOG_REG_TYPE_IEXT		7
-#define XLOG_REG_TYPE_IBROOT		8
-#define XLOG_REG_TYPE_ILOCAL		9
-#define XLOG_REG_TYPE_IATTR_EXT		10
-#define XLOG_REG_TYPE_IATTR_BROOT	11
-#define XLOG_REG_TYPE_IATTR_LOCAL	12
-#define XLOG_REG_TYPE_QFORMAT		13
-#define XLOG_REG_TYPE_DQUOT		14
-#define XLOG_REG_TYPE_QUOTAOFF		15
-#define XLOG_REG_TYPE_LRHEADER		16
-#define XLOG_REG_TYPE_UNMOUNT		17
-#define XLOG_REG_TYPE_COMMIT		18
-#define XLOG_REG_TYPE_TRANSHDR		19
-#define XLOG_REG_TYPE_ICREATE		20
-#define XLOG_REG_TYPE_RUI_FORMAT	21
-#define XLOG_REG_TYPE_RUD_FORMAT	22
-#define XLOG_REG_TYPE_CUI_FORMAT	23
-#define XLOG_REG_TYPE_CUD_FORMAT	24
-#define XLOG_REG_TYPE_BUI_FORMAT	25
-#define XLOG_REG_TYPE_BUD_FORMAT	26
-#define XLOG_REG_TYPE_ATTRI_FORMAT	27
-#define XLOG_REG_TYPE_ATTRD_FORMAT	28
-#define XLOG_REG_TYPE_ATTR_NAME		29
-#define XLOG_REG_TYPE_ATTR_VALUE	30
-#define XLOG_REG_TYPE_XMI_FORMAT	31
-#define XLOG_REG_TYPE_XMD_FORMAT	32
-#define XLOG_REG_TYPE_ATTR_NEWNAME	33
-#define XLOG_REG_TYPE_ATTR_NEWVALUE	34
-#define XLOG_REG_TYPE_MAX		34
-
 /*
  * Flags to log operation header
  *
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index af6daf4f6792..dcc1f44ed68f 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -20,6 +20,43 @@ struct xfs_log_vec {
 	int			lv_alloc_size;	/* size of allocated lv */
 };
 
+/* Region types for iovec's i_type */
+#define XLOG_REG_TYPE_BFORMAT		1
+#define XLOG_REG_TYPE_BCHUNK		2
+#define XLOG_REG_TYPE_EFI_FORMAT	3
+#define XLOG_REG_TYPE_EFD_FORMAT	4
+#define XLOG_REG_TYPE_IFORMAT		5
+#define XLOG_REG_TYPE_ICORE		6
+#define XLOG_REG_TYPE_IEXT		7
+#define XLOG_REG_TYPE_IBROOT		8
+#define XLOG_REG_TYPE_ILOCAL		9
+#define XLOG_REG_TYPE_IATTR_EXT		10
+#define XLOG_REG_TYPE_IATTR_BROOT	11
+#define XLOG_REG_TYPE_IATTR_LOCAL	12
+#define XLOG_REG_TYPE_QFORMAT		13
+#define XLOG_REG_TYPE_DQUOT		14
+#define XLOG_REG_TYPE_QUOTAOFF		15
+#define XLOG_REG_TYPE_LRHEADER		16
+#define XLOG_REG_TYPE_UNMOUNT		17
+#define XLOG_REG_TYPE_COMMIT		18
+#define XLOG_REG_TYPE_TRANSHDR		19
+#define XLOG_REG_TYPE_ICREATE		20
+#define XLOG_REG_TYPE_RUI_FORMAT	21
+#define XLOG_REG_TYPE_RUD_FORMAT	22
+#define XLOG_REG_TYPE_CUI_FORMAT	23
+#define XLOG_REG_TYPE_CUD_FORMAT	24
+#define XLOG_REG_TYPE_BUI_FORMAT	25
+#define XLOG_REG_TYPE_BUD_FORMAT	26
+#define XLOG_REG_TYPE_ATTRI_FORMAT	27
+#define XLOG_REG_TYPE_ATTRD_FORMAT	28
+#define XLOG_REG_TYPE_ATTR_NAME		29
+#define XLOG_REG_TYPE_ATTR_VALUE	30
+#define XLOG_REG_TYPE_XMI_FORMAT	31
+#define XLOG_REG_TYPE_XMD_FORMAT	32
+#define XLOG_REG_TYPE_ATTR_NEWNAME	33
+#define XLOG_REG_TYPE_ATTR_NEWVALUE	34
+#define XLOG_REG_TYPE_MAX		34
+
 #define XFS_LOG_VEC_ORDERED	(-1)
 
 /*
-- 
2.47.2

