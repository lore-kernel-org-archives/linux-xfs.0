Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9491E313524
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 13:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757942833; cv=none; b=NB/vvlnow5Cmw7hNCqj2ZPD7yzqqu2f5POLw2X1Fj1xfIC/W7IYqLMGFx4QEPTLm3dmo0KJmTJskkiPFx4/5XWs/4VobJHRTMaOEPvdEMlBKuy6boJxTC4twI858KeQNXboN3Wlii5RKl4Pp3QYnuBQbaV/TCObVz2CZolbGyJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757942833; c=relaxed/simple;
	bh=n99NH+U6ogv8MCql9PENjVE6F1ptqv7pIVqBSFJZLHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fa1Ii2Wa/NSwjK3Vp6hus5UyqmfAbh/r6K5ZTYxJ1PYblEXbV8asyLpKCr3tDWLlvtU86UZ+zMB7/KM1ty8O/JWAWOE3jwdS+w8f5HPPGB5dDhAYOpKpoYd09YSPTgAAZcXIDI3/6iZazVcIp8otMGdicVLxuehgwCIuNOtJQFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eX60HnwR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eX60HnwR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=so4lGdmhxfEmE7UDQttXwTu9ZPefxFEGxnGnk9gelg4=; b=eX60HnwRmqrpIqRHfj0Ae1EvsU
	ndzPo33hhH0SfUiLMQZRyYFIA1grLU94PXFHfSyfGBh7GLJOnCOk3E8b7cRBTH3Y5RCj1QBpG4VC4
	/ndbIgtLIBEcD6dE6bJ8lVJMS7mVRYLLUTSYtQzMdq1U+OlHeAp9yPAXwNBJLJu51Ke561+phEUnO
	VFLf1aEQCMcZ4E/2VXABOyuyMTIcJ69V7XYmMieGclCsfDlzk3tjpCzv2KCt2DfAbuYTcOhjbHow3
	pqZcdTIv3IoqfA0AgL8jPYvFOAhyXM+bDwXNvXYKESOqJpWIYAbICElcal5DwQQdcY02U+G8V2sEr
	RWOg8jFQ==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uy9Ed-00000004Jac-0mrX;
	Mon, 15 Sep 2025 13:27:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 06/15] xfs: remove the xfs_efi_log_format_t typedef
Date: Mon, 15 Sep 2025 06:26:56 -0700
Message-ID: <20250915132709.160247-7-hch@lst.de>
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

There are almost no users of the typedef left, kill it and switch the
remaining users to use the underlying struct.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_format.h | 4 ++--
 fs/xfs/xfs_extfree_item.h      | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index c6cb41955088..c5013951c06a 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -624,13 +624,13 @@ struct xfs_extent_64 {
  * log.  The efi_extents field is a variable size array whose
  * size is given by efi_nextents.
  */
-typedef struct xfs_efi_log_format {
+struct xfs_efi_log_format {
 	uint16_t		efi_type;	/* efi log item type */
 	uint16_t		efi_size;	/* size of this item */
 	uint32_t		efi_nextents;	/* # extents to free */
 	uint64_t		efi_id;		/* efi identifier */
 	struct xfs_extent	efi_extents[];	/* array of extents to free */
-} xfs_efi_log_format_t;
+};
 
 static inline size_t
 xfs_efi_log_format_sizeof(
diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index c8402040410b..e56376853f2d 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -49,7 +49,7 @@ struct xfs_efi_log_item {
 	struct xfs_log_item	efi_item;
 	atomic_t		efi_refcount;
 	atomic_t		efi_next_extent;
-	xfs_efi_log_format_t	efi_format;
+	struct xfs_efi_log_format efi_format;
 };
 
 static inline size_t
-- 
2.47.2

