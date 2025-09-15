Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40000314A92
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 13:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757942833; cv=none; b=VLAB2OvCAuECjwnztsiC7rvv+D4m+qZggiGEZRUljVdM83Hq5KVQpuHzmoBMtfPF+1rqK4tJf/hH94vx7OQB1S5wXk9V6oXWQXt3KHbpIeBDhPqdbo6mR7E0r4w/BtRGo+PI35TkUmLI+OE3WOaYYMS4VJ7oB3K7xjDvEiwqHAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757942833; c=relaxed/simple;
	bh=PzWDiC+zcKI1D+8Mb8827cMInzZLZFpbuDOGACo/JJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJRTpzWe8wR6EYyTwd97VmZCxXReyajm0saApHvN/Xwbh4z1yLVFpXzhOFDZlhLgb3/Pmvi4EoiD+GxNPb+b97xRlW270jtm8PX7UQIlaW9NK0L5AH9sa/Kw/n/vHFZ1txlM6kNUNUXKUQOY5eydqc5GCpdC1Z9+YHt53TrUXkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GBlWyIgZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GBlWyIgZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ISvHUCcHwvxQ/RbJFHc7UCwGxPVWgeXKfbgwaLfvZrc=; b=GBlWyIgZFXRJx/rn2403rSZGAC
	6zsNGpWiZ39jonrt0RtoxnqLMTVE2FW9cfkVg8poK9ynHn5cMjzruT88i2KgREbjX21+5pXGnp824
	ugsN1PaaFkylbqDa1iL7w7OUsJHKIkeJt5ah4yyCKOyJx5dt7LrLuaCGbIEvIeYEqBG4Ns/Sso6AY
	A8eYkT1Ac91R1Qg1Vg8xxwA0Tv0dB4aDLFuu+jH/n1fHIcejDRpZmY/zTgyo6NYasTLzYm1IjbbTl
	WkQRX4IRv8emAW3c3ZAeG80BB5QCbouNQQzu7ReRh41CIpclHeik+8ywmIslaHqPVzgrS2XtXPOdH
	1boIkbZQ==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uy9Ed-00000004JbI-3An0;
	Mon, 15 Sep 2025 13:27:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 09/15] xfs: remove the xfs_efd_log_format_t typedef
Date: Mon, 15 Sep 2025 06:26:59 -0700
Message-ID: <20250915132709.160247-10-hch@lst.de>
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
index dca750367756..bb06c48e0513 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -677,13 +677,13 @@ xfs_efi_log_format64_sizeof(
  * log.  The efd_extents array is a variable size array whose
  * size is given by efd_nextents;
  */
-typedef struct xfs_efd_log_format {
+struct xfs_efd_log_format {
 	uint16_t		efd_type;	/* efd log item type */
 	uint16_t		efd_size;	/* size of this item */
 	uint32_t		efd_nextents;	/* # of extents freed */
 	uint64_t		efd_efi_id;	/* id of corresponding efi */
 	struct xfs_extent	efd_extents[];	/* array of extents freed */
-} xfs_efd_log_format_t;
+};
 
 static inline size_t
 xfs_efd_log_format_sizeof(
diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index e56376853f2d..af1b0331f7af 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -69,7 +69,7 @@ struct xfs_efd_log_item {
 	struct xfs_log_item	efd_item;
 	struct xfs_efi_log_item *efd_efip;
 	uint			efd_next_extent;
-	xfs_efd_log_format_t	efd_format;
+	struct xfs_efd_log_format efd_format;
 };
 
 static inline size_t
-- 
2.47.2

