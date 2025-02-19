Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED9E2147E6
	for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2025 17:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739987304; cv=none; b=aEVrM+6P7m5BBWKW8iatPfEKo2oQT0vkyXGevkfBioeol4WZk6+uvyK5Smjnf+X/bVE1zgkmZezKMGceXbhkoX9ozze6ezzYMLA+lQhelGiv8pkcVrN+DjjNyhJbjeTxnEGpU+SqU8TMNBo7xqYRq1mie7KowBl3Evoezh19bqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739987304; c=relaxed/simple;
	bh=haxkW4O5T1tJxjmvheOMWACsxEEkPzqqsEfH61e185E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bR0guqA5v8swxWcrD0/8ETbVZCOYoOB56kWRPyTy9mV2jvJPr8wSZENHbJNVYe1FmAzknEfNknGah7PlGLmS7gmYCIUqL31+M6dK0wKkNQl6tErpaoGFQbhOK6h7qNBbpqS7y/CBulr3Mbrx/gr2W4vpES9bP04yBTzjnbKLkE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LdK+yI6W; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LdK+yI6W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739987301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sT8vCYOXeFABE1redu+hNWAyqAvlUkaC5+RF9MwY+c4=;
	b=LdK+yI6WqDdeqMsAIDpvPBVDm4AGxv/1GDncT5oDcANKMQQpzP+aJNtsyoo+2MxFBwlliq
	vhPNAUUUS2x8Xg2miJzTrO3wus42L2dThAO5FXyJ2nrkEjp9EmvLsOjiFoqCCXbJNS2u+t
	gybRIZ1blTm4F0HVFl3VtAlKR8nkGoU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-197-bSfVZ7koMQKPE3wg7AfSDQ-1; Wed,
 19 Feb 2025 12:48:19 -0500
X-MC-Unique: bSfVZ7koMQKPE3wg7AfSDQ-1
X-Mimecast-MFC-AGG-ID: bSfVZ7koMQKPE3wg7AfSDQ_1739987298
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 87A7219560B9;
	Wed, 19 Feb 2025 17:48:18 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.79])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6DC341800359;
	Wed, 19 Feb 2025 17:48:17 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v2 04/12] dax: advance the iomap_iter in the read/write path
Date: Wed, 19 Feb 2025 12:50:42 -0500
Message-ID: <20250219175050.83986-5-bfoster@redhat.com>
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

DAX reads and writes flow through dax_iomap_iter(), which has one or
more subtleties in terms of how it processes a range vs. what is
specified in the iomap_iter. To keep things simple and remove the
dependency on iomap_iter() advances, convert a positive return from
dax_iomap_iter() to the new advance and status return semantics. The
advance can be pushed further down in future patches.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/dax.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 21b47402b3dc..296f5aa18640 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1585,8 +1585,12 @@ dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		iomi.flags |= IOMAP_NOWAIT;
 
-	while ((ret = iomap_iter(&iomi, ops)) > 0)
+	while ((ret = iomap_iter(&iomi, ops)) > 0) {
 		iomi.processed = dax_iomap_iter(&iomi, iter);
+		if (iomi.processed > 0)
+			iomi.processed = iomap_iter_advance(&iomi,
+							    &iomi.processed);
+	}
 
 	done = iomi.pos - iocb->ki_pos;
 	iocb->ki_pos = iomi.pos;
-- 
2.48.1

