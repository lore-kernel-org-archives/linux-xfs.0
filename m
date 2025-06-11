Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DA520C489
	for <linux-xfs@vger.kernel.org>; Wed, 11 Jun 2025 18:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749665993; cv=none; b=k9mnu+aJsP3yPysExxyU4K+8P282Z0yhmnTr3OIna5rzxIOTKU3AzAExIeoxNIt5CMiqJpQKvFvMu8tv6iGEQGY0zqqfd4XCQ7knXAtCJOrd/v1XmCfE++qzIWn41QfzmMqJNyhwjvuplLgF2UQ9gNHGoeDrY7lDm4u216DS7Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749665993; c=relaxed/simple;
	bh=HvaBZFCIXi09nWA2u/3A/vHKUqnYuR/s1QWerPvhDq8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oxM2QHoOv3shUH26UHe6fQedfYVPSDkClLYfv8fkmwtpR+1PmE75rFweg33HZ1lSGhI/LulklHVABI3YndLA8Gx4PRRW33OeX1XxNPN9a5npD9NDE9//jFTuhpIw0VtdjOgdcJQ/4H1/so/uudpBfgYW2xN0Jel1w/l+U3icg64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e/Fl/vNS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e/Fl/vNS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749665991;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2ct3SwPJ+iKfRv0dPU/09Z1MYJwxjfdSCi8QxsQZSvM=;
	b=e/Fl/vNS/p7FQwLqslhlHQw8+wLSkmqwWWTSMAw1dB0l6PmUM8zi5V/N+POO2i3soFs//3
	eMofWl0iiseR3q+bqCCqi029o2T9oNrM0BioZpuUKb1yhQZayV0aJ+0Pkp1uTyV1fAdA8W
	RCCAzcfSNZoUKYjT/TH8u/rVGeRWzDw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-269-dbnLRUTPNkaHsmwo-D_tDQ-1; Wed,
 11 Jun 2025 14:19:49 -0400
X-MC-Unique: dbnLRUTPNkaHsmwo-D_tDQ-1
X-Mimecast-MFC-AGG-ID: dbnLRUTPNkaHsmwo-D_tDQ_1749665989
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 070EE19560A3
	for <linux-xfs@vger.kernel.org>; Wed, 11 Jun 2025 18:19:49 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.80.100])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 87F4830002C3
	for <linux-xfs@vger.kernel.org>; Wed, 11 Jun 2025 18:19:48 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] xfs: convert extent alloc debug fallback to errortag
Date: Wed, 11 Jun 2025 14:23:22 -0400
Message-ID: <20250611182323.183512-3-bfoster@redhat.com>
In-Reply-To: <20250611182323.183512-1-bfoster@redhat.com>
References: <20250611182323.183512-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Extent allocation includes multiple algorithms depending on on-disk
state to maintain performance and efficiency. The likely first
candidate is to simply use the rightmost block in the cntbt if
that's where initial lookup landed.

Since this is a common path for larger allocations on freshly
created filesystems, we include some DEBUG mode logic to randomly
fall out of the this algorithm and exercise fallback behavior. Now
that errortags can be enabled by default, convert this logic to an
errortag and drop the unnecessary DEBUG ifdef.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c    | 5 +----
 fs/xfs/libxfs/xfs_errortag.h | 4 +++-
 fs/xfs/xfs_error.c           | 3 +++
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 7839efe050bf..129c9f690afc 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1615,11 +1615,8 @@ xfs_alloc_ag_vextent_lastblock(
 	int			error;
 	int			i;
 
-#ifdef DEBUG
-	/* Randomly don't execute the first algorithm. */
-	if (get_random_u32_below(2))
+	if (XFS_TEST_ERROR(false, args->mp, XFS_ERRTAG_AG_ALLOC_SKIP))
 		return 0;
-#endif
 
 	/*
 	 * Start from the entry that lookup found, sequence through all larger
diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index a53c5d40e084..c57d26619817 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -65,7 +65,8 @@
 #define XFS_ERRTAG_WRITE_DELAY_MS			43
 #define XFS_ERRTAG_EXCHMAPS_FINISH_ONE			44
 #define XFS_ERRTAG_METAFILE_RESV_CRITICAL		45
-#define XFS_ERRTAG_MAX					46
+#define XFS_ERRTAG_AG_ALLOC_SKIP			46
+#define XFS_ERRTAG_MAX					47
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -115,5 +116,6 @@
 #define XFS_RANDOM_WRITE_DELAY_MS			3000
 #define XFS_RANDOM_EXCHMAPS_FINISH_ONE			1
 #define XFS_RANDOM_METAFILE_RESV_CRITICAL		4
+#define XFS_RANDOM_AG_ALLOC_SKIP			2
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 62ac6debcb5e..f1222e4e8c5f 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -64,6 +64,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_WRITE_DELAY_MS,
 	XFS_RANDOM_EXCHMAPS_FINISH_ONE,
 	XFS_RANDOM_METAFILE_RESV_CRITICAL,
+	XFS_RANDOM_AG_ALLOC_SKIP,
 };
 
 struct xfs_errortag_attr {
@@ -187,6 +188,7 @@ XFS_ERRORTAG_ATTR_RW(wb_delay_ms,	XFS_ERRTAG_WB_DELAY_MS);
 XFS_ERRORTAG_ATTR_RW(write_delay_ms,	XFS_ERRTAG_WRITE_DELAY_MS);
 XFS_ERRORTAG_ATTR_RW(exchmaps_finish_one, XFS_ERRTAG_EXCHMAPS_FINISH_ONE);
 XFS_ERRORTAG_ATTR_RW(metafile_resv_crit, XFS_ERRTAG_METAFILE_RESV_CRITICAL);
+__XFS_ERRORTAG_ATTR_RW(ag_alloc_skip,	XFS_ERRTAG_AG_ALLOC_SKIP,	true);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -234,6 +236,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(write_delay_ms),
 	XFS_ERRORTAG_ATTR_LIST(exchmaps_finish_one),
 	XFS_ERRORTAG_ATTR_LIST(metafile_resv_crit),
+	XFS_ERRORTAG_ATTR_LIST(ag_alloc_skip),
 	NULL,
 };
 ATTRIBUTE_GROUPS(xfs_errortag);
-- 
2.49.0

