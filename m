Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E6A211710
	for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2025 17:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739987310; cv=none; b=hHSinNgdX9C1A3OJgcp/tBkvoSRR0tDe/88CNscu5hSP7NgC1qODZoE0ZsV+e5eyJPNdBBsFb9UX2ABM7gxD0VVwxoOeA7spa4h2eLqwIQYMsTXLLsSuDWudVWCCr+O0KPZSu8Ol3Y4Dwk7+kJmYFxV8mu5TwtQ5hwrCjY/yz5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739987310; c=relaxed/simple;
	bh=z1wU4VDX2qCqWOZ3745I9ikm1ya8n/vDS2yykKLsqEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=glL83KX2JQxu5mr2O0CKOSGgItBVflpolDN2ryb/9JhuJurgVDAaYm63dBmgwHAjBgkNNJtu3oc/DxdimOhOnO1KLDBUaU5FnHK3PIEAd+Sua+MUfITRizJwNexX74K+3W5O2la/4qX+IFtEtUL1fcdXk2VAcsHLo3P/Br2Xc2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UyvI87o3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UyvI87o3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739987308;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rL7LCQFuNuAIzwOfoCJYdDQeaFnb9s6wkmgFuWzSkk4=;
	b=UyvI87o3vdJtx9RQxldQMIBmk3/92RWvhoJTUEDDp5h2giB7eazMTseBW0l389Ibxd+r1W
	yYLoF/ws6z/g34lEQ7CEd+0e8ZPQtnYE1gNqEzY3WN+jdxjZsA/45LotGS57+UY6WhqnGs
	h2FqyVeKMt/ksEw61Ok7TCBTcX+lYBY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-122-wPTJySdLOqGkZ4HYTahoXQ-1; Wed,
 19 Feb 2025 12:48:24 -0500
X-MC-Unique: wPTJySdLOqGkZ4HYTahoXQ-1
X-Mimecast-MFC-AGG-ID: wPTJySdLOqGkZ4HYTahoXQ_1739987303
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 917FF180087D;
	Wed, 19 Feb 2025 17:48:23 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.79])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9D4761800D96;
	Wed, 19 Feb 2025 17:48:22 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v2 08/12] dax: advance the iomap_iter on dedupe range
Date: Wed, 19 Feb 2025 12:50:46 -0500
Message-ID: <20250219175050.83986-9-bfoster@redhat.com>
In-Reply-To: <20250219175050.83986-1-bfoster@redhat.com>
References: <20250219175050.83986-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Advance the iter on successful dedupe. Dedupe range uses two iters
and iterates so long as both have outstanding work, so
correspondingly this needs to advance both on each iteration. Since
dax_range_compare_iter() now returns status instead of a byte count,
update the variable name in the caller as well.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/dax.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index c0fbab8c66f7..c8c0d81122ab 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -2001,12 +2001,13 @@ vm_fault_t dax_finish_sync_fault(struct vm_fault *vmf, unsigned int order,
 }
 EXPORT_SYMBOL_GPL(dax_finish_sync_fault);
 
-static loff_t dax_range_compare_iter(struct iomap_iter *it_src,
+static int dax_range_compare_iter(struct iomap_iter *it_src,
 		struct iomap_iter *it_dest, u64 len, bool *same)
 {
 	const struct iomap *smap = &it_src->iomap;
 	const struct iomap *dmap = &it_dest->iomap;
 	loff_t pos1 = it_src->pos, pos2 = it_dest->pos;
+	u64 dest_len;
 	void *saddr, *daddr;
 	int id, ret;
 
@@ -2014,7 +2015,7 @@ static loff_t dax_range_compare_iter(struct iomap_iter *it_src,
 
 	if (smap->type == IOMAP_HOLE && dmap->type == IOMAP_HOLE) {
 		*same = true;
-		return len;
+		goto advance;
 	}
 
 	if (smap->type == IOMAP_HOLE || dmap->type == IOMAP_HOLE) {
@@ -2037,7 +2038,13 @@ static loff_t dax_range_compare_iter(struct iomap_iter *it_src,
 	if (!*same)
 		len = 0;
 	dax_read_unlock(id);
-	return len;
+
+advance:
+	dest_len = len;
+	ret = iomap_iter_advance(it_src, &len);
+	if (!ret)
+		ret = iomap_iter_advance(it_dest, &dest_len);
+	return ret;
 
 out_unlock:
 	dax_read_unlock(id);
@@ -2060,15 +2067,15 @@ int dax_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 		.len		= len,
 		.flags		= IOMAP_DAX,
 	};
-	int ret, compared = 0;
+	int ret, status;
 
 	while ((ret = iomap_iter(&src_iter, ops)) > 0 &&
 	       (ret = iomap_iter(&dst_iter, ops)) > 0) {
-		compared = dax_range_compare_iter(&src_iter, &dst_iter,
+		status = dax_range_compare_iter(&src_iter, &dst_iter,
 				min(src_iter.len, dst_iter.len), same);
-		if (compared < 0)
+		if (status < 0)
 			return ret;
-		src_iter.processed = dst_iter.processed = compared;
+		src_iter.processed = dst_iter.processed = status;
 	}
 	return ret;
 }
-- 
2.48.1

