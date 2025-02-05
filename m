Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBF914F9FD
	for <linux-xfs@vger.kernel.org>; Wed,  5 Feb 2025 13:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763763; cv=none; b=J6/mAfYtYXzuhZXjH63QYuzP18q8vGPKArRoMZDjHl3H/Ai93Pueh0bl2RdwehsNmZ+GzoRTF9M4DHFtuc7TeWR23LVmR93NtvWAntLnmkljt89jn+MgqrRoRmYYSi2plYsRWezO+iRjIZYOiVmJRABsuxEZzoWpCGUK0j0V//k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763763; c=relaxed/simple;
	bh=dXen0DTYAlGNQYYaDMnjO2sZtIbbtkxy0gZwBzm+jZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qKeaPDopzhj9bxYp64hLZHusPoMfb/5FKC/8sUmyzbeAQa8qV112Ecs7qGEDp/H86Fs0N2HcRDvlpWmMJnDI5tNda2qzLVC3LVOnbd6xpnnB2EpTic4FOJ82awdZpQ9a50/U0Ged13hAfq+ub41sSpa71Tdb+alMURUCdBPEcI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hSpFbH4J; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hSpFbH4J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738763761;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TRZyPJSOIJqRx4T6prfBGyNdUHyxuHREUAR+mm6vxL8=;
	b=hSpFbH4J/sRiDWMyLJWuxecnSJab9sVokwMY3Bf25FYp6x2thS0ikiYOqFJEibTXe7LGBY
	phVXITyWbaRzKxUWjOLhfvPutInTJB4Bm1lpmrYiRpjUZFx9s/jb7IMKfpyX1erD24EfHb
	u2EX0IDPbeYsqCoqRAC1nr50oc3FxT8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-538-dCLe6NreN7mlKMS626YvZA-1; Wed,
 05 Feb 2025 08:55:57 -0500
X-MC-Unique: dCLe6NreN7mlKMS626YvZA-1
X-Mimecast-MFC-AGG-ID: dCLe6NreN7mlKMS626YvZA
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BC94F1800874;
	Wed,  5 Feb 2025 13:55:56 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.48])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BD4683000197;
	Wed,  5 Feb 2025 13:55:55 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v5 01/10] iomap: factor out iomap length helper
Date: Wed,  5 Feb 2025 08:58:12 -0500
Message-ID: <20250205135821.178256-2-bfoster@redhat.com>
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

