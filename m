Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720C31BDCF
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 13:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737552748; cv=none; b=TZrWZL5eiAPV126FjzK/PfA3PpvNqhjAQ2rvCg8kKsSc0WozrUQfeFi260Xs7xMGrZJ/nXmd8lxEBEAc+HTz02p4xeIcODWRXjttWFnIiKeICE0FmLqG8v29+U/HFzhIOLnsHwrNnux1TMcu5pFhFGGoMWjeUFW1OAE9oXGfZ9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737552748; c=relaxed/simple;
	bh=jG34dVuSjv0z2kFCOUY6Xx2vuTQQe1eQNxGnCYQWBsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FtyKBBpB8vLLIMUS31p+U3++BUp3lebEx28S76Q/V9oa3T/A/8qLE/hGlF/9uYbqpCw14D3n+9y9TdIaP+X+hmd2zwze9R17vL1MxoDApQlXtPw/IWqg1+q7UERMwNh1oDo/3Z63Opz8xO1cGqImb6gE3G7RyZnbfs+l2/aHcyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G12vyERc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G12vyERc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737552745;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fubx2YvHL6SBTZx4vMOkPvsm0q8yavBOqWeP66VgBDA=;
	b=G12vyERc2Ud+mnry0lyvR2nMa2F0U8o2ozvkueTJeJjfVsQ7fbZYamWroEPYjlC1ILOLOK
	032ue4Qc97ucIwnbMqlf5xdgwQnsCVIa/s/PPOZUrIBXJxkLVelu84P5O7qyT6giDmUa4c
	8B+AAE35h+hNKAKG0W+p28U73A0tTGc=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-330-oMCk6Pp5Pou3YEYefd1Jjg-1; Wed,
 22 Jan 2025 08:32:23 -0500
X-MC-Unique: oMCk6Pp5Pou3YEYefd1Jjg-1
X-Mimecast-MFC-AGG-ID: oMCk6Pp5Pou3YEYefd1Jjg
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BBCCF1954185;
	Wed, 22 Jan 2025 13:32:22 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.80.118])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 34ED819560A7;
	Wed, 22 Jan 2025 13:32:22 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH v2 2/7] iomap: factor out iomap length helper
Date: Wed, 22 Jan 2025 08:34:29 -0500
Message-ID: <20250122133434.535192-3-bfoster@redhat.com>
In-Reply-To: <20250122133434.535192-1-bfoster@redhat.com>
References: <20250122133434.535192-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

In preparation to support more granular iomap iter advancing, factor
the pos/len values as parameters to length calculation.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 include/linux/iomap.h | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 75bf54e76f3b..b6f7d96156f2 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -230,6 +230,16 @@ struct iomap_iter {
 
 int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops);
 
+static inline u64 iomap_length_trim(const struct iomap_iter *iter, loff_t pos,
+		u64 len)
+{
+	u64 end = iter->iomap.offset + iter->iomap.length;
+
+	if (iter->srcmap.type != IOMAP_HOLE)
+		end = min(end, iter->srcmap.offset + iter->srcmap.length);
+	return min(len, end - pos);
+}
+
 /**
  * iomap_length - length of the current iomap iteration
  * @iter: iteration structure
@@ -238,11 +248,7 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops);
  */
 static inline u64 iomap_length(const struct iomap_iter *iter)
 {
-	u64 end = iter->iomap.offset + iter->iomap.length;
-
-	if (iter->srcmap.type != IOMAP_HOLE)
-		end = min(end, iter->srcmap.offset + iter->srcmap.length);
-	return min(iter->len, end - iter->pos);
+	return iomap_length_trim(iter, iter->pos, iter->len);
 }
 
 /**
-- 
2.47.1

