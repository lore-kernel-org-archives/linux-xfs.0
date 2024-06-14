Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4C215F41D
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 16:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718381236; cv=none; b=pp0M/wTNWVw8l5SqRbHad6j7O4lOEyZqF/7t5W4/ZNJR4svAlohXiLso0xa3QSiErFpEmeWzVB6NTPt3TzdvKV79SwmePMetp+PBM5bdHeumbOBMFQSR0BE/A3uvCwN/FBNjQx3Kqoyb0bj/tA7fQiw2dhg3lHru0hBag8YCsLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718381236; c=relaxed/simple;
	bh=cegaVVSne7+vtUTFtDiscA8vJJUMFLEvP8aDaQ9mGII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lDpzi7CbM0Qca1AUE39u2uzCOtsi+y7uP4QjT60fZnqb3FsiEcyI0QHyAEucMlxQU11hEMT2/6+U8hXoKlrD2gshKsbUF/qAKygscCeaoKwIV111LAHghwbV5AZvNONVJQyLlDPhPwVBjLFNahTNkhoDIaNdqvUhWz1FQ8WuaXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eePqvnVu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eePqvnVu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718381233;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZomfkoVq0suL2c8mJWdTAIMC632vfRZrJwPBlAjNVJo=;
	b=eePqvnVufos3xWIjz7YuRSTieBnjb+aNcibgOKJfjYNz9oIGDnJt+a4jyDMpV23Pv5eQ0F
	xb7Wvp2LmOWIYO0qIZAuac7c8rHG1IOeIyy76eFd4QJrYJJVGavpy+mmR5YdaPlUt6lN/H
	BA150Z/1Y7KXZ3tF+/Rgt5jsZHKnxQE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-394-M2k544CfPVGk_Xqg2PI7yw-1; Fri,
 14 Jun 2024 12:07:10 -0400
X-MC-Unique: M2k544CfPVGk_Xqg2PI7yw-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 31968195608B;
	Fri, 14 Jun 2024 16:07:09 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.34.24])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A39511955E74;
	Fri, 14 Jun 2024 16:07:07 +0000 (UTC)
From: Bill O'Donnell <bodonnel@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cmaiolino@redhat.com,
	Bill O'Donnell <bodonnel@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v3 1/4] mkfs.xfs: avoid potential overflowing expression in xfs_mkfs.c
Date: Fri, 14 Jun 2024 11:00:13 -0500
Message-ID: <20240614160643.1879156-2-bodonnel@redhat.com>
In-Reply-To: <20240614160643.1879156-1-bodonnel@redhat.com>
References: <20240614160643.1879156-1-bodonnel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Cast max_tx_bytes to uint64_t to avoid overflowing expression in
calc_concurrency_logblocks().

Coverity-id: 1596603

Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
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

