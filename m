Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F672213E7B
	for <linux-xfs@vger.kernel.org>; Tue,  4 Feb 2025 13:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738675705; cv=none; b=omF2oWFblFGAsogCX+6aXSK1ae82yS867/ICW/XB19WCMg36RCDiwOBs2ks9jEO2P0IVGnq+0YLUbnXKRIAdltnP72WoMeowm19HhDfKrkE2Bxg+GRuQbxZcQHjHpkxCrt03nRgV1GYU9fWgJ7kl6IkJ8sHUI6r85XRtIHkIMAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738675705; c=relaxed/simple;
	bh=dXen0DTYAlGNQYYaDMnjO2sZtIbbtkxy0gZwBzm+jZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pgImMBtpk8sOPFTJpl11SQFdmtb5N3FL3Y52tiF1edskxTPYyqT45PHc0Vuv1XxWldS8VJLzHg+3GYDuNvV/pQvbfOEEmOMhRXzClTkaTeVjXTxX5edbxcs2/Tlu4nkwvCgjskkc7Sc3qF2k6vz2sdqvhwlFh9dh5oqDptLFyqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DHz6iO1M; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DHz6iO1M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738675702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TRZyPJSOIJqRx4T6prfBGyNdUHyxuHREUAR+mm6vxL8=;
	b=DHz6iO1M7gob3qw0ZpOxgqxXHSIoV0FKm4gT8DCNBgYFAiaAyZyiZmpvEwOG8jy/NWWJIu
	3jkYWUZIYiFeLDk86pGgTI56Smk6FQNRsmn3yxp6dryas9x5XnFR9oWbGB5Cx5EVRQehHE
	JIpcTgik6IXKDc3DdxhQNcjqPan6Lbw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-146-5YoVZ6k_M7y0JmTtqX9dUw-1; Tue,
 04 Feb 2025 08:28:21 -0500
X-MC-Unique: 5YoVZ6k_M7y0JmTtqX9dUw-1
X-Mimecast-MFC-AGG-ID: 5YoVZ6k_M7y0JmTtqX9dUw
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0A27F1801F0E;
	Tue,  4 Feb 2025 13:28:20 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.48])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 16C3719560AD;
	Tue,  4 Feb 2025 13:28:18 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v4 01/10] iomap: factor out iomap length helper
Date: Tue,  4 Feb 2025 08:30:35 -0500
Message-ID: <20250204133044.80551-2-bfoster@redhat.com>
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

In preparation to support more granular iomap iter advancing, factor
the pos/len values as parameters to length calculation.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/iomap.h | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 75bf54e76f3b..f5ca71ac2fa2 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -231,18 +231,33 @@ struct iomap_iter {
 int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops);
 
 /**
- * iomap_length - length of the current iomap iteration
+ * iomap_length_trim - trimmed length of the current iomap iteration
  * @iter: iteration structure
+ * @pos: File position to trim from.
+ * @len: Length of the mapping to trim to.
  *
- * Returns the length that the operation applies to for the current iteration.
+ * Returns a trimmed length that the operation applies to for the current
+ * iteration.
  */
-static inline u64 iomap_length(const struct iomap_iter *iter)
+static inline u64 iomap_length_trim(const struct iomap_iter *iter, loff_t pos,
+		u64 len)
 {
 	u64 end = iter->iomap.offset + iter->iomap.length;
 
 	if (iter->srcmap.type != IOMAP_HOLE)
 		end = min(end, iter->srcmap.offset + iter->srcmap.length);
-	return min(iter->len, end - iter->pos);
+	return min(len, end - pos);
+}
+
+/**
+ * iomap_length - length of the current iomap iteration
+ * @iter: iteration structure
+ *
+ * Returns the length that the operation applies to for the current iteration.
+ */
+static inline u64 iomap_length(const struct iomap_iter *iter)
+{
+	return iomap_length_trim(iter, iter->pos, iter->len);
 }
 
 /**
-- 
2.48.1

