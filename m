Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA82D14A62B
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 18:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718302695; cv=none; b=Tyv+vySjcf38FrI+njLFa00RtcGUQdoplSL9DM1zucHH8BHtNWlFdMWE889cmTbmVa6qHzqDDX+tn6th82aFoZV/XTfQe5BWdYiPiOA504vI3LLQ2ngRhCa5epGLaz03UTjmBP3nqNLL6KdcUaIqGdqNwYqV2aIz8+71sJ8wLVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718302695; c=relaxed/simple;
	bh=hcgP6moRKDZpupzvJuP5HEtlh8u9Gky/DxONTuAjDWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jvys2oTyxcaOoYEVuhnyBtpGxZZnY1ueS1Lk/pD6Bx5OhwBipLGgfD71H+R7nrZTRdIsZPzpmV3w/tuiQgC8fzxv5mfU7Wiq+FLnn64aQ7OL/oOoPgY/d0MNiAF20oaalG8v369iwaYoiy9mfjEAwNwj/0w1m+E7d9PQqVHimdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SHXWanoJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SHXWanoJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718302689;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=snThJpWDNgNHCNOl6uD91ooMEJ1Wr3g9bkc7QeOUZT8=;
	b=SHXWanoJe89s621z1gz+QGevdb5AE+lYt9UVTjyp3R0ZpKPy3Us7upHrMnmdzolwgjll1E
	0iKfidO/yZLYFkcLyPvWOHrYhuaTQ9zKzsoHTOkYbRp4O/VEgWABEEjlrsIF+uCGltuHg5
	kN4QsjPKHr1IzGiCSGbkVwQxnvYc7hk=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-16-vBcWyfq4NWKgG8Qx282JXQ-1; Thu,
 13 Jun 2024 14:18:08 -0400
X-MC-Unique: vBcWyfq4NWKgG8Qx282JXQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5677C19560B9
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 18:18:07 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.34.24])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 026531956056;
	Thu, 13 Jun 2024 18:18:04 +0000 (UTC)
From: Bill O'Donnell <bodonnel@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cmaiolino@redhat.com,
	Bill O'Donnell <bodonnel@redhat.com>
Subject: [PATCH 4/4] xfs_repair: correct type of variable global_msgs.interval to time_t
Date: Thu, 13 Jun 2024 13:07:08 -0500
Message-ID: <20240613181745.1052423-5-bodonnel@redhat.com>
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

Use time_t instead of int for interval field.

Coverity-id: 1596599

Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
---
 repair/progress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/repair/progress.c b/repair/progress.c
index 2ce36cef..15455a99 100644
--- a/repair/progress.c
+++ b/repair/progress.c
@@ -91,7 +91,7 @@ typedef struct msg_block_s {
 	uint64_t	*done;
 	uint64_t	*total;
 	int		count;
-	int		interval;
+	time_t		interval;
 } msg_block_t;
 static msg_block_t 	global_msgs;
 
-- 
2.45.2

