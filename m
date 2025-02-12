Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F301220E709
	for <linux-xfs@vger.kernel.org>; Wed, 12 Feb 2025 13:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739368497; cv=none; b=WpiLx37JndbC25yPvZhkyqfk0XjFt+rSIMGD7mfOeFF7A/EJbRsTmle4QFuJ80buUlFMuFMvRhaGkHEJc/mHBs3uJdX8S8ImjI316eCdWxxbcKd1AmvmHHJTdI0621Ntj3ES2aQr8Jn2Px0KWzV4C54GJ+HA3VGKpeH3fll+Ptw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739368497; c=relaxed/simple;
	bh=nNNuE+S6bO2qWfsK6S+oyDlS4rM39WpUmnrNS8KEPqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J5yB6N+yrULurkOLxMj2R4RkA//CVGDi1s8CR2/LHxbW4TonUrEE058dDSb10eegX+UfsU1o+EuweNvA5Vo5KjMxlx017KveibQXWG6bbjFI5A8luXQ9cCuIIkOFSrusLZplO9Gu40mgu4F18dRbhNPj15lLkNLFRHlEFtVSPkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KhesX55i; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KhesX55i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739368495;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qzKkSKGrehSnUFVI9qrvgUD4yE6vLHAkTxhA4RsNEgA=;
	b=KhesX55iZcux8FWNdPL3flv5FbHd46+CnAHBdu4ME5WvC9ZYur9Cd9L71+bVro6M6qwrty
	gt4tschpRlhcJnAigsCtf4WIK8PH5MupcDBEEmzeKGPt8aKU0wtS4vWFh9u/IT3pCTzTGM
	qJralsup+EDo3KND9bXWyrw+ziaGDLU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-17-pOJnRc0eMlG6yf4bfLjwtw-1; Wed,
 12 Feb 2025 08:54:53 -0500
X-MC-Unique: pOJnRc0eMlG6yf4bfLjwtw-1
X-Mimecast-MFC-AGG-ID: pOJnRc0eMlG6yf4bfLjwtw_1739368492
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BE2D31956094;
	Wed, 12 Feb 2025 13:54:52 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.88])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 986613001D10;
	Wed, 12 Feb 2025 13:54:51 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 05/10] dax: advance the iomap_iter on zero range
Date: Wed, 12 Feb 2025 08:57:07 -0500
Message-ID: <20250212135712.506987-6-bfoster@redhat.com>
In-Reply-To: <20250212135712.506987-1-bfoster@redhat.com>
References: <20250212135712.506987-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Update the DAX zero range iomap iter handler to advance the iter
directly. Advance by the full length in the hole/unwritten case, or
otherwise advance incrementally in the zeroing loop. In either case,
return 0 or an error code for success or failure.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/dax.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 296f5aa18640..0f611209ee37 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1358,13 +1358,12 @@ static s64 dax_zero_iter(struct iomap_iter *iter, bool *did_zero)
 {
 	const struct iomap *iomap = &iter->iomap;
 	const struct iomap *srcmap = iomap_iter_srcmap(iter);
-	loff_t pos = iter->pos;
 	u64 length = iomap_length(iter);
-	s64 written = 0;
+	s64 ret;
 
 	/* already zeroed?  we're done. */
 	if (srcmap->type == IOMAP_HOLE || srcmap->type == IOMAP_UNWRITTEN)
-		return length;
+		return iomap_iter_advance(iter, &length);
 
 	/*
 	 * invalidate the pages whose sharing state is to be changed
@@ -1372,33 +1371,35 @@ static s64 dax_zero_iter(struct iomap_iter *iter, bool *did_zero)
 	 */
 	if (iomap->flags & IOMAP_F_SHARED)
 		invalidate_inode_pages2_range(iter->inode->i_mapping,
-					      pos >> PAGE_SHIFT,
-					      (pos + length - 1) >> PAGE_SHIFT);
+					      iter->pos >> PAGE_SHIFT,
+					      (iter->pos + length - 1) >> PAGE_SHIFT);
 
 	do {
+		loff_t pos = iter->pos;
 		unsigned offset = offset_in_page(pos);
-		unsigned size = min_t(u64, PAGE_SIZE - offset, length);
 		pgoff_t pgoff = dax_iomap_pgoff(iomap, pos);
-		long rc;
 		int id;
 
+		length = min_t(u64, PAGE_SIZE - offset, length);
+
 		id = dax_read_lock();
-		if (IS_ALIGNED(pos, PAGE_SIZE) && size == PAGE_SIZE)
-			rc = dax_zero_page_range(iomap->dax_dev, pgoff, 1);
+		if (IS_ALIGNED(pos, PAGE_SIZE) && length == PAGE_SIZE)
+			ret = dax_zero_page_range(iomap->dax_dev, pgoff, 1);
 		else
-			rc = dax_memzero(iter, pos, size);
+			ret = dax_memzero(iter, pos, length);
 		dax_read_unlock(id);
 
-		if (rc < 0)
-			return rc;
-		pos += size;
-		length -= size;
-		written += size;
+		if (ret < 0)
+			return ret;
+
+		ret = iomap_iter_advance(iter, &length);
+		if (ret)
+			return ret;
 	} while (length > 0);
 
 	if (did_zero)
 		*did_zero = true;
-	return written;
+	return ret;
 }
 
 int dax_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
-- 
2.48.1

