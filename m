Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527E71EEA46
	for <linux-xfs@vger.kernel.org>; Thu, 30 Jan 2025 17:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738256865; cv=none; b=DOwrRwSgEQnExDz1M7CBR0Efuxj9gyzAJB3eEEZuGSLVBzsf+7t9/MIck5DH+wzHa74Ms+MfIpbBLbBZvKO3DKjRAka6fNVygK/MvBwLdGr6t70C3IXd1dSMRekMSpTRcaC61mEGox59Un+t8q/RiSkLlw6VagX8GJtEYsDzmUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738256865; c=relaxed/simple;
	bh=/CcAGSXtCyzmWnS93ZOrskKZkHRoJXfInTSOetrZE0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uuoSw7KNQCHRg5FlEOvmbpMdWFTPa3REsBjkVqRC1xammyAYv3LlYzY4C+9z80QlJwPm1kZm4iO8Oes2XO5MFWmKZjy9Ny5ugSHBFLJEAHChjB160IaKhh6DO6REK9N2HWvsqYnQb3wBt7dq4aPAsL0WoiGFUd99gJQEPT7KT1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WYaehM4z; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WYaehM4z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738256862;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l8+3EkgGdj8WgrbHVmLXjg2LfbG3NgNfTsmBRTx6Ry8=;
	b=WYaehM4zGR+o9V6hselDuEpAiNqghSXKHvS5OuZ5zuy+sLaA9Ec6pxXKo1uQCikNQ/CwUM
	V38PZrCeccglq/KUgs0iEz7eMoGg/t0YMWooWJ4DwAljvXayESDjqVfjoJO1B8AhKGCOh/
	3TS3V5M3WY/w+C52M45x4FEPH5xCHTw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-659-IIMtKxIfMFGYfuLq-MbjHA-1; Thu,
 30 Jan 2025 12:07:38 -0500
X-MC-Unique: IIMtKxIfMFGYfuLq-MbjHA-1
X-Mimecast-MFC-AGG-ID: IIMtKxIfMFGYfuLq-MbjHA
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5D7921800370;
	Thu, 30 Jan 2025 17:07:37 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.80.113])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 674C730001BE;
	Thu, 30 Jan 2025 17:07:36 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v3 1/7] iomap: split out iomap check and reset logic from iter advance
Date: Thu, 30 Jan 2025 12:09:42 -0500
Message-ID: <20250130170949.916098-2-bfoster@redhat.com>
In-Reply-To: <20250130170949.916098-1-bfoster@redhat.com>
References: <20250130170949.916098-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

In preparation for more granular iomap_iter advancing, break out
some of the logic associated with higher level iteration from
iomap_advance_iter(). Specifically, factor the iomap reset code into
a separate helper and lift the iomap.length check into the calling
code, similar to how ->iomap_end() calls are handled.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/iter.c | 49 ++++++++++++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 23 deletions(-)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index 3790918646af..731ea7267f27 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -7,6 +7,13 @@
 #include <linux/iomap.h>
 #include "trace.h"
 
+static inline void iomap_iter_reset_iomap(struct iomap_iter *iter)
+{
+	iter->processed = 0;
+	memset(&iter->iomap, 0, sizeof(iter->iomap));
+	memset(&iter->srcmap, 0, sizeof(iter->srcmap));
+}
+
 /*
  * Advance to the next range we need to map.
  *
@@ -14,32 +21,24 @@
  * processed - it was aborted because the extent the iomap spanned may have been
  * changed during the operation. In this case, the iteration behaviour is to
  * remap the unprocessed range of the iter, and that means we may need to remap
- * even when we've made no progress (i.e. iter->processed = 0). Hence the
- * "finished iterating" case needs to distinguish between
- * (processed = 0) meaning we are done and (processed = 0 && stale) meaning we
- * need to remap the entire remaining range.
+ * even when we've made no progress (i.e. count = 0). Hence the "finished
+ * iterating" case needs to distinguish between (count = 0) meaning we are done
+ * and (count = 0 && stale) meaning we need to remap the entire remaining range.
  */
-static inline int iomap_iter_advance(struct iomap_iter *iter)
+static inline int iomap_iter_advance(struct iomap_iter *iter, s64 count)
 {
 	bool stale = iter->iomap.flags & IOMAP_F_STALE;
 	int ret = 1;
 
-	/* handle the previous iteration (if any) */
-	if (iter->iomap.length) {
-		if (iter->processed < 0)
-			return iter->processed;
-		if (WARN_ON_ONCE(iter->processed > iomap_length(iter)))
-			return -EIO;
-		iter->pos += iter->processed;
-		iter->len -= iter->processed;
-		if (!iter->len || (!iter->processed && !stale))
-			ret = 0;
-	}
+	if (count < 0)
+		return count;
+	if (WARN_ON_ONCE(count > iomap_length(iter)))
+		return -EIO;
+	iter->pos += count;
+	iter->len -= count;
+	if (!iter->len || (!count && !stale))
+		ret = 0;
 
-	/* clear the per iteration state */
-	iter->processed = 0;
-	memset(&iter->iomap, 0, sizeof(iter->iomap));
-	memset(&iter->srcmap, 0, sizeof(iter->srcmap));
 	return ret;
 }
 
@@ -82,10 +81,14 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 			return ret;
 	}
 
+	/* advance and clear state from the previous iteration */
 	trace_iomap_iter(iter, ops, _RET_IP_);
-	ret = iomap_iter_advance(iter);
-	if (ret <= 0)
-		return ret;
+	if (iter->iomap.length) {
+		ret = iomap_iter_advance(iter, iter->processed);
+		iomap_iter_reset_iomap(iter);
+		if (ret <= 0)
+			return ret;
+	}
 
 	ret = ops->iomap_begin(iter->inode, iter->pos, iter->len, iter->flags,
 			       &iter->iomap, &iter->srcmap);
-- 
2.47.1

