Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF1B155333
	for <linux-xfs@vger.kernel.org>; Wed,  5 Feb 2025 13:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763769; cv=none; b=OBBTKDpfKq26FcS/e/HjKLD2A7lbyRilw5OBpjX/cNQWoUb0s8hmxkf9jZ4Pp5uaCztQTMQ+HyzsF2s1SRuNTMfPncV7RDUwjUFPLDqS7jv1EjRXjDGX0ONcxB66TNdKpz95r/8ciutTcuQo+eUjfMcNuNSPIlYtSz1P4CcdjIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763769; c=relaxed/simple;
	bh=dDi20ppat0OBMNZLS30VTLSXxQ1X3dp0n18Q0weiNFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ofN4p779cq5BfmujEpO495wjHkttHAMeQ9mZSczL2NiAb7K5j7LhaoFKbp7XvULWDsWvhZJ7VHPSXxKL1mmVdLoU2aP/VsXt5GLe0OzwTUC+VVNivtIgFs+E6wa1JfQlNK8k5Hwd35eFqm0atc4CWNqLQ3GPNJTwmus/falbzNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=an9NDMGh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="an9NDMGh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738763766;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HsxOSnZ81sHhPbWb/Z0THp1tBOnvIA6FX31noBUuZXY=;
	b=an9NDMGh7a+KSynsEUK97XhzHGbSczLh9p3lAuEAlu/axcufMVIDF8jL3yE/1XfkSjmmg4
	G+nsrX92SfucSPmM2vI4E/ugYA4YyEE6/+wQDIxIiHJaSGucrKaoJvSXQtMaN4R3hP4uaK
	FFeKIQ1IJ+ZMjIYaU0VTYYFU4ORfu7c=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-653-E7OpkDpaNh2sdAS1whRC0w-1; Wed,
 05 Feb 2025 08:56:01 -0500
X-MC-Unique: E7OpkDpaNh2sdAS1whRC0w-1
X-Mimecast-MFC-AGG-ID: E7OpkDpaNh2sdAS1whRC0w
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EE7021956046;
	Wed,  5 Feb 2025 13:56:00 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.48])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0F256300018D;
	Wed,  5 Feb 2025 13:55:59 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v5 04/10] iomap: lift error code check out of iomap_iter_advance()
Date: Wed,  5 Feb 2025 08:58:15 -0500
Message-ID: <20250205135821.178256-5-bfoster@redhat.com>
In-Reply-To: <20250205135821.178256-1-bfoster@redhat.com>
References: <20250205135821.178256-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

The error code is only used to check whether iomap_iter() should
terminate due to an error returned in iter.processed. Lift the check
out of iomap_iter_advance() in preparation to make it more generic.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/iter.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index a2ae99fe6431..1db16be7b9f0 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -30,8 +30,6 @@ static inline int iomap_iter_advance(struct iomap_iter *iter, s64 count)
 	bool stale = iter->iomap.flags & IOMAP_F_STALE;
 	int ret = 1;
 
-	if (count < 0)
-		return count;
 	if (WARN_ON_ONCE(count > iomap_length(iter)))
 		return -EIO;
 	iter->pos += count;
@@ -71,6 +69,7 @@ static inline void iomap_iter_done(struct iomap_iter *iter)
  */
 int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 {
+	s64 processed;
 	int ret;
 
 	trace_iomap_iter(iter, ops, _RET_IP_);
@@ -86,8 +85,14 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 			return ret;
 	}
 
+	processed = iter->processed;
+	if (processed < 0) {
+		iomap_iter_reset_iomap(iter);
+		return processed;
+	}
+
 	/* advance and clear state from the previous iteration */
-	ret = iomap_iter_advance(iter, iter->processed);
+	ret = iomap_iter_advance(iter, processed);
 	iomap_iter_reset_iomap(iter);
 	if (ret <= 0)
 		return ret;
-- 
2.48.1

