Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05AD724169C
	for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 14:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408339; cv=none; b=jhpYT56V59i4tj4D6KRQpDYeu7QyN4enApoVzmg+6znE5Nuedszu529r1Aq2iqx9ZF9Dyn0Gu5J2eeVFIE9nAusBkwmbz7bcGmYb0FOX73yea6ALBSpWk1HJfuI6MQdIqgoxO4pnIZRwYu9x4ZwLAmFARurhKgxSK2FE9sJfCuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408339; c=relaxed/simple;
	bh=tUuQI9xUtnMSDCFH0CQwt2QCoF6hxYb0lc+w1F83nVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EZPpohr8HcP6TpCqk8MIKZTbFP4V6EwefY4xOrCSswJTeLen1sa7tvXaVZRmcetyzR0uWYzQYb9j5VPhnlxPBkH9g4TovnMgArMQKkUBZxc+XaJKgKQv+eWwUP4v7rI7aMcZ8662lvIwAMVvyj0QDef2SWluKW7OnII5BH8RSZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hV7fqP91; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hV7fqP91"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740408337;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NuGKgxjrSI5+5zGaTK4k67qC5l8ZfQJftmVnarXSnDM=;
	b=hV7fqP91y2VZ64kgRWiVcM9LNQ7uM9/utGFVVcCRbonYlDNbKivsDiN4oHbSgGGOXkX8Gz
	/QsKDkXjPJEiqzKJcnisWmsb/QyWEyFeuOUPM9kKAk9VQLim/cwL5qtCu/rNNcskNvap1i
	H9YDMoADAi8pOiHfjgT9dI4YYSDauxM=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-690-lb3Q1hoWOPaCkfoBdiC-RQ-1; Mon,
 24 Feb 2025 09:45:33 -0500
X-MC-Unique: lb3Q1hoWOPaCkfoBdiC-RQ-1
X-Mimecast-MFC-AGG-ID: lb3Q1hoWOPaCkfoBdiC-RQ_1740408330
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 190951801A37;
	Mon, 24 Feb 2025 14:45:30 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.79])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2E3EB19560AA;
	Mon, 24 Feb 2025 14:45:29 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v3 08/12] dax: advance the iomap_iter on dedupe range
Date: Mon, 24 Feb 2025 09:47:53 -0500
Message-ID: <20250224144757.237706-9-bfoster@redhat.com>
In-Reply-To: <20250224144757.237706-1-bfoster@redhat.com>
References: <20250224144757.237706-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Advance the iter on successful dedupe. Dedupe range uses two iters
and iterates so long as both have outstanding work, so
correspondingly this needs to advance both on each iteration. Since
dax_range_compare_iter() now returns status instead of a byte count,
update the variable name in the caller as well.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
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

