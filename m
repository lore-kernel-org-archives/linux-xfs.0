Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CBE313534
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 13:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757942833; cv=none; b=OGBqWvC24GLVulXC1XQCdMqUv0pQLwkTfVpwc0dTYAD0QEtxKMTjFYONLcsUAaWHIS/kt7uCO8otMQQ/gS5z7fK6WbdVX1PZaaQkIQmFI3cgsBqKjBKVl7BSxqhCWzCWvFCPc/sMk3hz9xFk891JTdB0jcoEdWY0ysIC492aVJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757942833; c=relaxed/simple;
	bh=9VXEij6V6e5QVbNDFw52Fyg14luPN0OYJGv6d+1YwPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qJ82w0KUZvMb5gF4wLixgM/0A0CT/ft1fcByD6YbwINUxd4nKsExKKKsvI4pZ/d7TGjJ/1JwVz1r9rlr7msz/uLNdjrKlL17ojmtAIdg76qAwlpNU4pe3hnPyHikFQ2V0DSWIGgWRrolsCia2XF80eNKYlQkDxQtcJf53TTvZf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kviMB9cL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kviMB9cL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=WS2IMCFCKIx59qCEp23pbcBiGzCwcuj5SdxIbIaxNLU=; b=kviMB9cLMIEtD8ljhOz+eCxSbE
	gktpFHQjYUYk7Z4YmZfpO7Mb7NiRv9/0bGuTFkhXDP4UtCLWsQYHz5fE32eptBNgSikuf3w+/2by2
	fEjSjnnDRjTWpK9p0ZS0JC7+N/9U0F26GQ+jJXr6MkM/EI6NL5oqegyETRhxDjhTvJCMnlIu+UsaX
	EZuhOTzeaw9qJXmtsPL6+VQhb35/nF/7GjJ+txUui8h2CLYv8MtxCJu4GYXkQpjp5XyI2jPKxOWH3
	1K5NeEeQpFtWgvKJE2zQUUvYsJMUND6TKGT7rksnIbnKuk82Oh24VBWR+xYEJLIz/pCogDslgPqPu
	FN90IrWA==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uy9Ed-00000004JbA-2OPG;
	Mon, 15 Sep 2025 13:27:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 08/15] xfs: remove the xfs_efi_log_format_64_t typedef
Date: Mon, 15 Sep 2025 06:26:58 -0700
Message-ID: <20250915132709.160247-9-hch@lst.de>
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
 fs/xfs/xfs_extfree_item.c      | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index c9e3b3f178cb..dca750367756 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -656,13 +656,13 @@ xfs_efi_log_format32_sizeof(
 			nr * sizeof(struct xfs_extent_32);
 }
 
-typedef struct xfs_efi_log_format_64 {
+struct xfs_efi_log_format_64 {
 	uint16_t		efi_type;	/* efi log item type */
 	uint16_t		efi_size;	/* size of this item */
 	uint32_t		efi_nextents;	/* # extents to free */
 	uint64_t		efi_id;		/* efi identifier */
 	struct xfs_extent_64	efi_extents[];	/* array of extents to free */
-} xfs_efi_log_format_64_t;
+};
 
 static inline size_t
 xfs_efi_log_format64_sizeof(
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 0190cc55d75b..418ddab590e0 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -216,7 +216,7 @@ xfs_efi_copy_format(
 		}
 		return 0;
 	} else if (buf->iov_len == len64) {
-		xfs_efi_log_format_64_t *src_efi_fmt_64 = buf->iov_base;
+		struct xfs_efi_log_format_64 *src_efi_fmt_64 = buf->iov_base;
 
 		dst_efi_fmt->efi_type     = src_efi_fmt_64->efi_type;
 		dst_efi_fmt->efi_size     = src_efi_fmt_64->efi_size;
-- 
2.47.2

