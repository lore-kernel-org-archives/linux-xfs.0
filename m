Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306B321C9EA
	for <linux-xfs@vger.kernel.org>; Tue,  4 Feb 2025 13:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738675710; cv=none; b=hvM7ozNpwJW/8wdLqQM0ZLXl8NbAQLkRsHMdD09fgIVI2OVTZ9fGs8YqHunMcuXQTG01ouyL03VuZ4zCiykm2FUvfVpUdRtJ97uR8RKDrE2YmnHyp4RBYOPkxoYLJaVEBxlw7ope2i2jqP1vTm9Gd4aGyheGAgVq0hHqq2fofnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738675710; c=relaxed/simple;
	bh=tZ3utb3UFnI8pBkZAItdp6eb0Zz3IuUL9qfvvkp76c4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bF9HWsv1ABBulWqjWyiL86asOkhniqaBg4+vUFr2gEcKN5Ib0vHcbncbgKNk2DxcpHs29AiQsmsx/9BWwXDf47qtnSngK32q0Ix1DMnrkMOE5JLmpBruRRFk/g5wYN2cwwDqj4YtWQ2O0NRx/mgpQZfr4222WbhxknTO0kBP98A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V/ATvOL/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V/ATvOL/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738675708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y/vNSfYY3pGNcOO4GEvFjuvOArvsvasFJcAT1zrEj1g=;
	b=V/ATvOL/BVl+ziFcK8ATiiybOd4C0MdDBW7thkv8BmYAl44JPaSemWuBp6c1QdTOMeLQMP
	hjv/Rp5VNBy+JEJXYxrMF+b0ooYr7xOHhlyE3mBqO4pfLMmzdPjgL46jns14/Pjnk+NLAo
	I0rhDn63UF7ucoTlcYwCY13tO9m3pzc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-457-sBwddKyLOq2yNuQtcnVebg-1; Tue,
 04 Feb 2025 08:28:23 -0500
X-MC-Unique: sBwddKyLOq2yNuQtcnVebg-1
X-Mimecast-MFC-AGG-ID: sBwddKyLOq2yNuQtcnVebg
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 56BF41801F27;
	Tue,  4 Feb 2025 13:28:22 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.48])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 69BD119560AD;
	Tue,  4 Feb 2025 13:28:21 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v4 03/10] iomap: refactor iomap_iter() length check and tracepoint
Date: Tue,  4 Feb 2025 08:30:37 -0500
Message-ID: <20250204133044.80551-4-bfoster@redhat.com>
In-Reply-To: <20250204133044.80551-1-bfoster@redhat.com>
References: <20250204133044.80551-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

iomap_iter() checks iomap.length to skip individual code blocks not
appropriate for the initial case where there is no mapping in the
iter. To prepare for upcoming changes, refactor the code to jump
straight to the ->iomap_begin() handler in the initial case and move
the tracepoint to the top of the function so it always executes.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/iomap/iter.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index 731ea7267f27..a2ae99fe6431 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -73,7 +73,12 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 {
 	int ret;
 
-	if (iter->iomap.length && ops->iomap_end) {
+	trace_iomap_iter(iter, ops, _RET_IP_);
+
+	if (!iter->iomap.length)
+		goto begin;
+
+	if (ops->iomap_end) {
 		ret = ops->iomap_end(iter->inode, iter->pos, iomap_length(iter),
 				iter->processed > 0 ? iter->processed : 0,
 				iter->flags, &iter->iomap);
@@ -82,14 +87,12 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 	}
 
 	/* advance and clear state from the previous iteration */
-	trace_iomap_iter(iter, ops, _RET_IP_);
-	if (iter->iomap.length) {
-		ret = iomap_iter_advance(iter, iter->processed);
-		iomap_iter_reset_iomap(iter);
-		if (ret <= 0)
-			return ret;
-	}
+	ret = iomap_iter_advance(iter, iter->processed);
+	iomap_iter_reset_iomap(iter);
+	if (ret <= 0)
+		return ret;
 
+begin:
 	ret = ops->iomap_begin(iter->inode, iter->pos, iter->len, iter->flags,
 			       &iter->iomap, &iter->srcmap);
 	if (ret < 0)
-- 
2.48.1

