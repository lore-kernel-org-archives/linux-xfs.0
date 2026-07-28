Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C277044E667
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 18:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785263413; cv=none; b=mUx9iS5FBBDBI+WzK6glAWpz+BAl0i+S6bYeU+uBmSOUVw0ptlVFFVtYI3K8hULLB+4pnnjmmyanB3ORCKyaqo/OFZLJJdbjahmbYFK7TwZzLYbACsnkw6vzjIMnML93XkW+tInwOj5RUs4xmE7FTPdJR3nXXVZ1R/z1Xed/HIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785263413; c=relaxed/simple;
	bh=ONF7e3RAVhQ4JABQ9DM5kA8UM3Uu+eyUnRrg+8dbuSs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ta7H/sQfcrWLnuEDVNNMKKoASb+Bea+7Cy6zIhWWOl1FLB3idSQLyB+h+TgU5eENIE+IoKAnLBSANX+HiCPreyjuADC6hYExEcsp8kDcLTQD3tdRfqSbgRYqi3Pu/EqxiVYR814P1Ck8E9p8KXHArXxaUKXHmUkVyPX9VmAoC4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b+t/wpyJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b+t/wpyJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785263410;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qHYwPQJmw7YRfUoLhcIEsFXfANiKg9NR8lP6i3/GzJc=;
	b=b+t/wpyJGdaJkbZI5f3eqaMSFW1h01AlYHTWAL599stlZGqQGhqwKN1/w+UGU4Iam9JOG8
	PX09xKSnTvSieEUqGXgttpK2sDN9OskMHPN2WW3db8SQAQVKXksfVivGF7TEcqBk6q7OV/
	zASojbBYZcooJXRR7Qf7VQdDrV5yto4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-390-ImwyG1DIOBGAsS-Jp80wAg-1; Tue,
 28 Jul 2026 14:30:08 -0400
X-MC-Unique: ImwyG1DIOBGAsS-Jp80wAg-1
X-Mimecast-MFC-AGG-ID: ImwyG1DIOBGAsS-Jp80wAg_1785263407
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8383D180044D;
	Tue, 28 Jul 2026 18:30:07 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.46])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9F560300019F;
	Tue, 28 Jul 2026 18:30:06 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Cc: hch@lst.de,
	joannelkoong@gmail.com,
	djwong@kernel.org
Subject: [PATCH] iomap: release the folio batch on iomap callback failures
Date: Tue, 28 Jul 2026 14:30:05 -0400
Message-ID: <20260728183005.92395-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

A sashiko review of an unrelated patch points out that the folio
batch mechanism used for iomap zero range fails to release the batch
in a couple error scenarios. If either calls to ->iomap_end() or
->iomap_begin() fail, the direct return paths bypass the batch
cleanup.

The ->iomap_end() case is not a practical issue at the moment
because there is no user of the mechanism that returns an error from
this path. The ->iomap_begin() case is theoretically possible
because XFS can invoke the fill helper and error out at various
points thereafter. This subtly complicates things because XFS does
not transfer iomap_flags to the iomap data structure in the error
path.

To deal with both of these issues, first make sure to invoke the
cleanup helper in the error path for either fs callback. Second,
update the helper to clear the flag unconditionally and release the
batch so long as it is populated. This more clearly delineates the
purpose of the flag to control the I/O path and not necessarily the
status of the fbatch, so add a comment around this as well.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Assisted-by: LLM
Fixes: 395ed1ef0012 ("iomap: optional zero range dirty folio processing")
Signed-off-by: Brian Foster <bfoster@redhat.com>
---

As noted here[1], I'm aware this conflicts with the outstanding iomap
iter rework. I'm happy to rebase onto that if that is ultimately
preferred. I've got at least one vote to get this in sooner, so this
version is based on 7.2-rc5.

Brian

[1] https://lore.kernel.org/linux-fsdevel/amizdHj6ICgP2xFv@bfoster/

 fs/iomap/iter.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index e4a29829591a..63617ec48250 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -6,12 +6,18 @@
 #include <linux/iomap.h>
 #include "trace.h"
 
+/*
+ * Release the iter folio batch. Note that the iomap flag is meant to control
+ * the I/O path for the mapping and may not be set in error situations.
+ */
 static inline void iomap_iter_clean_fbatch(struct iomap_iter *iter)
 {
-	if (iter->iomap.flags & IOMAP_F_FOLIO_BATCH) {
+	if (!iter->fbatch)
+		return;
+	iter->iomap.flags &= ~IOMAP_F_FOLIO_BATCH;
+	if (folio_batch_count(iter->fbatch)) {
 		folio_batch_release(iter->fbatch);
 		folio_batch_reinit(iter->fbatch);
-		iter->iomap.flags &= ~IOMAP_F_FOLIO_BATCH;
 	}
 }
 
@@ -79,7 +85,7 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 						  olen),
 				advanced, iter->flags, &iter->iomap);
 		if (ret < 0 && !advanced)
-			return ret;
+			goto error;
 	}
 
 	/* detect old return semantics where this would advance */
@@ -110,7 +116,11 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 	ret = ops->iomap_begin(iter->inode, iter->pos, iter->len, iter->flags,
 			       &iter->iomap, &iter->srcmap);
 	if (ret < 0)
-		return ret;
+		goto error;
 	iomap_iter_done(iter);
 	return 1;
+
+error:
+	iomap_iter_clean_fbatch(iter);
+	return ret;
 }
-- 
2.55.0

