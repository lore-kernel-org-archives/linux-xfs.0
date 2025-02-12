Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28F920E706
	for <linux-xfs@vger.kernel.org>; Wed, 12 Feb 2025 13:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739368497; cv=none; b=IokEHH2Ij5vsVGjKcIMPY4QHt+7kfsou9hxvrQiR4s7cWV3nRNtFry9WI6qK5TV/AlUBjpWEZJkwJITP173VyV4PScoKF5kUD/nJBSmMGggwfdG2mPi54Z11BwGooiN0MwAlBHonpA+f+8jNs8wGBgRh8BlAmaO/nbTqK+c38io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739368497; c=relaxed/simple;
	bh=f8DFHn++FSNxdRrma0vBnULi1guvmZSKAjNa80vkjxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l98FjUBny0W9BHVCWtJCeys8Sh5DbAXgJltMR5kU1hnilcyGiRipF6B/zT5Dv4F4DlQVgA/avKJSdLQAESu/c+4JwOIROuzD8VBCGFdYXNsO2LVrM+XSLrU19cLfJhrS8I+G193BWF2LXZTwIYVkJHORCM7qNKQami986CxSbRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C+joOVwL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C+joOVwL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739368494;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xcjroBFg2EKxMPG6+JoHYOI4juN+AENf3+yfTE6F4sk=;
	b=C+joOVwLsJG4O6U/JbqFEIIVUxcWCXU1HEadS82ZcW/h6WGHNRBjwshY17r9kvvFO/v+eH
	4W5dqM2Mpwsi+B4qDoavyiubdyl5CWX71bNYtoGeN9rc7j8I9FbqYObUYYndbpv3QP8f1J
	+AwqxpOAx3rin6G/XikkQxN6lZ9g4CM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-658-LaR-nrDSOgCNpSbs-yfHNQ-1; Wed,
 12 Feb 2025 08:54:52 -0500
X-MC-Unique: LaR-nrDSOgCNpSbs-yfHNQ-1
X-Mimecast-MFC-AGG-ID: LaR-nrDSOgCNpSbs-yfHNQ
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 511A219560B9;
	Wed, 12 Feb 2025 13:54:51 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.88])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 58B023001D17;
	Wed, 12 Feb 2025 13:54:50 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 04/10] dax: advance the iomap_iter in the read/write path
Date: Wed, 12 Feb 2025 08:57:06 -0500
Message-ID: <20250212135712.506987-5-bfoster@redhat.com>
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

DAX reads and writes flow through dax_iomap_iter(), which has one or
more subtleties in terms of how it processes a range vs. what is
specified in the iomap_iter. To keep things simple and remove the
dependency on iomap_iter() advances, convert a positive return from
dax_iomap_iter() to the new advance and status return semantics. The
advance can be pushed further down in future patches.

Signed-off-by: Brian Foster <bfoster@redhat.com>
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

