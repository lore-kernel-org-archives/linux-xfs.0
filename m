Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0DD266B40
	for <linux-xfs@vger.kernel.org>; Thu,  7 Aug 2025 14:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754577822; cv=none; b=GcrYrV1qcAKp8dxIjWwEyxYi2DFpM6d1TkUo1/L04T2b4AYkQ93gPBDSq8yd+zz42Hp7mtPCOrk3yXtrv43sLQKpX4J1Hb0xfbU0FxGdByJbzDhHTmfnQMtIgUboDoJZf0quu1bh1Z4cim3eLRcUmAIj6jynhso7bGENsDQ85cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754577822; c=relaxed/simple;
	bh=LhU77/GljgwlfeWkOiaySnUnIiVZ/nugigKvlA19ods=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NGIoJc5XCxCxFQzU99jN5jsEGUoS6M7V11vTpBKHvYj1+/rIW4krzv6zGjcOz1cZiFz6zagVXFBOnLMLxdwxuUGfOP8W8UvpvfWyfs1gYuWatPbf7/wJhkFGqXDyjnN7qgUEl2uCsd8/C+mjgz4sV7Wci55mB70uQyELQsPgNbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BoARhp1L; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BoARhp1L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754577820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SGsnHH/7ANS+cU/5LhZY4MqydsQWx1VmAjvofEAotZs=;
	b=BoARhp1LheUaFunUrunyLKSyRUVeXSuENAkAL9JNDKG1jYaHeq38io5Pdfku+7AHfJcVrA
	+/rn2zqCJ+PquY5oV1ta05GmQFxubDAEAZOQO1r7Kc/J7MdlvGJxw20tzKc+Fd6NFOeMNs
	Q0cP+1YoG4+5Nf/0tdlI91sCBR4T9OA=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-326-haI_EDJfMNeBWdrXrIQdtQ-1; Thu,
 07 Aug 2025 10:43:35 -0400
X-MC-Unique: haI_EDJfMNeBWdrXrIQdtQ-1
X-Mimecast-MFC-AGG-ID: haI_EDJfMNeBWdrXrIQdtQ_1754577814
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DB0851956050;
	Thu,  7 Aug 2025 14:43:33 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.68])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AB582180035C;
	Thu,  7 Aug 2025 14:43:32 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	hch@infradead.org,
	djwong@kernel.org,
	willy@infradead.org
Subject: [PATCH v4 7/7] xfs: error tag to force zeroing on debug kernels
Date: Thu,  7 Aug 2025 10:47:10 -0400
Message-ID: <20250807144711.564137-8-bfoster@redhat.com>
In-Reply-To: <20250807144711.564137-1-bfoster@redhat.com>
References: <20250807144711.564137-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

iomap_zero_range() has to cover various corner cases that are
difficult to test on production kernels because it is used in fairly
limited use cases. For example, it is currently only used by XFS and
mostly only in partial block zeroing cases.

While it's possible to test most of these functional cases, we can
provide more robust test coverage by co-opting fallocate zero range
to invoke zeroing of the entire range instead of the more efficient
block punch/allocate sequence. Add an errortag to occasionally
invoke forced zeroing.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_errortag.h |  4 +++-
 fs/xfs/xfs_error.c           |  3 +++
 fs/xfs/xfs_file.c            | 26 ++++++++++++++++++++------
 3 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index a53c5d40e084..33ca3fc2ca88 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -65,7 +65,8 @@
 #define XFS_ERRTAG_WRITE_DELAY_MS			43
 #define XFS_ERRTAG_EXCHMAPS_FINISH_ONE			44
 #define XFS_ERRTAG_METAFILE_RESV_CRITICAL		45
-#define XFS_ERRTAG_MAX					46
+#define XFS_ERRTAG_FORCE_ZERO_RANGE			46
+#define XFS_ERRTAG_MAX					47
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -115,5 +116,6 @@
 #define XFS_RANDOM_WRITE_DELAY_MS			3000
 #define XFS_RANDOM_EXCHMAPS_FINISH_ONE			1
 #define XFS_RANDOM_METAFILE_RESV_CRITICAL		4
+#define XFS_RANDOM_FORCE_ZERO_RANGE			4
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index dbd87e137694..00c0c391c329 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -64,6 +64,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_WRITE_DELAY_MS,
 	XFS_RANDOM_EXCHMAPS_FINISH_ONE,
 	XFS_RANDOM_METAFILE_RESV_CRITICAL,
+	XFS_RANDOM_FORCE_ZERO_RANGE,
 };
 
 struct xfs_errortag_attr {
@@ -183,6 +184,7 @@ XFS_ERRORTAG_ATTR_RW(wb_delay_ms,	XFS_ERRTAG_WB_DELAY_MS);
 XFS_ERRORTAG_ATTR_RW(write_delay_ms,	XFS_ERRTAG_WRITE_DELAY_MS);
 XFS_ERRORTAG_ATTR_RW(exchmaps_finish_one, XFS_ERRTAG_EXCHMAPS_FINISH_ONE);
 XFS_ERRORTAG_ATTR_RW(metafile_resv_crit, XFS_ERRTAG_METAFILE_RESV_CRITICAL);
+XFS_ERRORTAG_ATTR_RW(force_zero_range, XFS_ERRTAG_FORCE_ZERO_RANGE);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -230,6 +232,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(write_delay_ms),
 	XFS_ERRORTAG_ATTR_LIST(exchmaps_finish_one),
 	XFS_ERRORTAG_ATTR_LIST(metafile_resv_crit),
+	XFS_ERRORTAG_ATTR_LIST(force_zero_range),
 	NULL,
 };
 ATTRIBUTE_GROUPS(xfs_errortag);
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 55a304cb3aef..7d1dda56ebdf 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -27,6 +27,8 @@
 #include "xfs_file.h"
 #include "xfs_aops.h"
 #include "xfs_zone_alloc.h"
+#include "xfs_error.h"
+#include "xfs_errortag.h"
 
 #include <linux/dax.h>
 #include <linux/falloc.h>
@@ -1271,13 +1273,25 @@ xfs_falloc_zero_range(
 	if (error)
 		return error;
 
-	error = xfs_free_file_space(XFS_I(inode), offset, len, ac);
-	if (error)
-		return error;
+	/*
+	 * Zero range implements a full zeroing mechanism but is only used in
+	 * limited situations. It is more efficient to allocate unwritten
+	 * extents than to perform zeroing here, so use an errortag to randomly
+	 * force zeroing on DEBUG kernels for added test coverage.
+	 */
+	if (XFS_TEST_ERROR(false, XFS_I(inode)->i_mount,
+			   XFS_ERRTAG_FORCE_ZERO_RANGE)) {
+		error = xfs_zero_range(XFS_I(inode), offset, len, ac, NULL);
+	} else {
+		error = xfs_free_file_space(XFS_I(inode), offset, len, ac);
+		if (error)
+			return error;
 
-	len = round_up(offset + len, blksize) - round_down(offset, blksize);
-	offset = round_down(offset, blksize);
-	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
+		len = round_up(offset + len, blksize) -
+			round_down(offset, blksize);
+		offset = round_down(offset, blksize);
+		error = xfs_alloc_file_space(XFS_I(inode), offset, len);
+	}
 	if (error)
 		return error;
 	return xfs_falloc_setsize(file, new_size);
-- 
2.50.1

