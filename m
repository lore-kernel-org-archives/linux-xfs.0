Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3101482E9
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 18:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718302687; cv=none; b=Ly8+ZmfCb0+nShULR/PeIXYxtJiTpjQKvJw3l8v6LANxAZ+vvkmXDgR75MEUTAqmz5TZbdc6yn06KrTdo3urgohROJ7Fu7o8XEK4EOXzbgpsdKoIl9qAsqfLDQSv43pFmsPUqQTWMHNiS0XMj3/W8waCDQ6Y5YPCvfxWSPnFduM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718302687; c=relaxed/simple;
	bh=bOUOYj1yJWVfslyu9pCNZsN+CqdeAchG298E4ENLkPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NtzNnqzhWZcRmVvwLKPHXrAgZvuU65q54AW8iMqHznCK+PG84tRTvbdoBb9o8GMHlaEaU8AjqfOIgvHCkfqBfE1hhRJhndl/B4TSFHeZeXKjyfZJMgbwYX4XFYv8gGWE39uEhzs5E4KSmu/Y64x7Raimkmr1Z0cKlHEZCX6f7jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hfqe0bCR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hfqe0bCR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718302684;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jk9BFaIBdnRuur/DRp9Mi6o2SQFE0p2XyV62LiyPpE4=;
	b=hfqe0bCRhpK/y9nkN+eI8EalESJAOp4cfMi7oMQiod96bnroSQSrDc05T3GHoahLgln/KV
	l+5k+aQLqudZOElP/xLaWXuw82JJwbe+WsNA6t0wiQ1DwJGXdIEKvN6Gs8mQiJQ+cExbAy
	BNlIOu280CFbQovY/gGOBX4f3DG9Jb4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-228-8903I-Z0OEq1qFyeVYyEOA-1; Thu,
 13 Jun 2024 14:18:03 -0400
X-MC-Unique: 8903I-Z0OEq1qFyeVYyEOA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ADA4C19560AF
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 18:18:02 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.34.24])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8B4D71956056;
	Thu, 13 Jun 2024 18:18:01 +0000 (UTC)
From: Bill O'Donnell <bodonnel@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cmaiolino@redhat.com,
	Bill O'Donnell <bodonnel@redhat.com>
Subject: [PATCH 1/4] mkfs.xfs: avoid potential overflowing expression in xfs_mkfs.c
Date: Thu, 13 Jun 2024 13:07:05 -0500
Message-ID: <20240613181745.1052423-2-bodonnel@redhat.com>
In-Reply-To: <20240613181745.1052423-1-bodonnel@redhat.com>
References: <20240613181745.1052423-1-bodonnel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Cast max_tx_bytes to uint64_t to avoid overflowing expression in
calc_concurrency_logblocks().

Coverity-id: 1596603

Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
---
 mkfs/xfs_mkfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index f4a9bf20..2f801dd4 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3678,7 +3678,7 @@ calc_concurrency_logblocks(
 	 * without blocking for space.  Increase the figure by 50% so that
 	 * background threads can also run.
 	 */
-	log_bytes = max_tx_bytes * 3 * cli->log_concurrency / 2;
+	log_bytes = (uint64_t)max_tx_bytes * 3 * cli->log_concurrency / 2;
 	new_logblocks = min(XFS_MAX_LOG_BYTES >> cfg->blocklog,
 				log_bytes >> cfg->blocklog);
 
-- 
2.45.2

