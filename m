Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE4521C9FF
	for <linux-xfs@vger.kernel.org>; Tue,  4 Feb 2025 13:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738675711; cv=none; b=hDIuhfO1me02E1exm3MoZ5O+c6cDI/Gg51AEduyOgDBwYDjqGFPGYu+8m163t3ublcpmmjmJkQoAqxtpXH6kKJ2DQnuSjjx2ubr1UNbPlNpyhCT7fwRjZP0o/YWLDgaNvD9o1kizm7svalq0X6+3EOtKZofZGjjMRFExTj5w2yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738675711; c=relaxed/simple;
	bh=/4Y5a2ZwNaBqDIiQEfHXnebcOtn7xP2TeLQTFwmK2no=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HxKJB+hR8WR5NZu8n7mulgXyXMh9drmtFWFVcqoKouAynl+TyPPRZdFlx3AQhmV6med1I2xXBrPO6UvDr2LOamJj2pPwq444IfBCVSlSpQg+ldvxpwk8cGefUxqILpNnlKKaNrca1zjXbddo0EuruUNKSG8HFAsHLXsaPdOPm1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i1ltDiL8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i1ltDiL8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738675709;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eAqKofu7qn46pbm8JjUjzHkZyEAPxNnDxqJm4YH070Q=;
	b=i1ltDiL8zwn8fO+nVVgtwEGbhh7WVWtH3AHDl1Weiuy3XvxpBOWlRsMcaIygXbGpofxktb
	CEt6no7Zd0JqGgCtfNK8QbMRIiHxcj6d8E92eF9BvYLuEberjhhovP1Kx5mJOvJvNi2SpN
	Jm1Wd9ywiY5j3xppu8c0Ix2wDJ5N3bo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-157-9hvSSzB7M1WFDnBFXGrEPQ-1; Tue,
 04 Feb 2025 08:28:25 -0500
X-MC-Unique: 9hvSSzB7M1WFDnBFXGrEPQ-1
X-Mimecast-MFC-AGG-ID: 9hvSSzB7M1WFDnBFXGrEPQ
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 741FD1801F18;
	Tue,  4 Feb 2025 13:28:24 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.48])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AD14719560AD;
	Tue,  4 Feb 2025 13:28:23 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v4 05/10] iomap: lift iter termination logic from iomap_iter_advance()
Date: Tue,  4 Feb 2025 08:30:39 -0500
Message-ID: <20250204133044.80551-6-bfoster@redhat.com>
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

The iter termination logic in iomap_iter_advance() is only needed by
iomap_iter() to determine whether to proceed with the next mapping
for an ongoing operation. The old logic sets ret to 1 and then
terminates if the operation is complete (iter->len == 0) or the
previous iteration performed no work and the mapping has not been
marked stale. The stale check exists to allow operations to
retry the current mapping if an inconsistency has been detected.

To further genericize iomap_iter_advance(), lift the termination
logic into iomap_iter() and update the former to return success (0)
or an error code. iomap_iter() continues on successful advance and
non-zero iter->len or otherwise terminates in the no progress (and
not stale) or error cases.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/iomap/iter.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index fcc8d75dd22f..04bd39ee5d47 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -27,17 +27,11 @@ static inline void iomap_iter_reset_iomap(struct iomap_iter *iter)
  */
 static inline int iomap_iter_advance(struct iomap_iter *iter, s64 count)
 {
-	bool stale = iter->iomap.flags & IOMAP_F_STALE;
-	int ret = 1;
-
 	if (WARN_ON_ONCE(count > iomap_length(iter)))
 		return -EIO;
 	iter->pos += count;
 	iter->len -= count;
-	if (!iter->len || (!count && !stale))
-		ret = 0;
-
-	return ret;
+	return 0;
 }
 
 static inline void iomap_iter_done(struct iomap_iter *iter)
@@ -69,6 +63,7 @@ static inline void iomap_iter_done(struct iomap_iter *iter)
  */
 int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 {
+	bool stale = iter->iomap.flags & IOMAP_F_STALE;
 	int ret;
 
 	trace_iomap_iter(iter, ops, _RET_IP_);
@@ -89,8 +84,18 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 		return iter->processed;
 	}
 
-	/* advance and clear state from the previous iteration */
+	/*
+	 * Advance the iter and clear state from the previous iteration. Use
+	 * iter->len to determine whether to continue onto the next mapping.
+	 * Explicitly terminate in the case where the current iter has not
+	 * advanced at all (i.e. no work was done for some reason) unless the
+	 * mapping has been marked stale and needs to be reprocessed.
+	 */
 	ret = iomap_iter_advance(iter, iter->processed);
+	if (!ret && iter->len > 0)
+		ret = 1;
+	if (ret > 0 && !iter->processed && !stale)
+		ret = 0;
 	iomap_iter_reset_iomap(iter);
 	if (ret <= 0)
 		return ret;
-- 
2.48.1

