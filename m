Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7805315FA7C
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 16:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718381236; cv=none; b=mfiTBYpPtGRqEys8ZfcGrRje3POZQ5kLj1R+ODm97vYKl2hO3hKazHCpGkMMIRlhb10xCXFtm+wOW0naUm0ZCYp+9E/2Mvizd0rS8AbMciZMnrJlRp/5zMGZocEU95QVZTQ7PWgkI+PlrOgkcECK7jKOno5mjPGb0SABtwJ4HX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718381236; c=relaxed/simple;
	bh=z/Oa0t/afI9qXk+YYiKVjvK/vguOt1ij2iWhTg4fMT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BuC31Of5DIl4qUDSSr+l+fRR3QrXLLQ41ZqSV95kZMLncEe1U8sPoGjkpCffdqRUzUon2CYP7VuAPJzXcZhun/3NpRxNv9VFX+/9FcBlo/doAmBn0Dmiy9ocdRhAR+FV7uJ6hEI6PCkh3Cw4WYIX7isJpX1WN+cJ/vCyOfUtWiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QJP2W9Rh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QJP2W9Rh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718381234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l1ZxR2I94Q4eCiiQ+Tgtohe9AJ6ChZgZQQE4+LgSneo=;
	b=QJP2W9RhbhSkjfxnzxZepg9yWO5EdQufuRYdYb7EV92Kp3eZUrldR35OhqC53hwiD8KKKK
	SITBf9fJhShI9RZ+/o0k1qYQisPl3TiEJ24kTCi8eHpM/UWiKRyMUWeZKX63dAb0BDib3I
	bAW+MxgiZfOfGSTkY0H6yRA6/3qnEEs=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-219-o8o1w4IGPzePkI8IVi7YNA-1; Fri,
 14 Jun 2024 12:07:12 -0400
X-MC-Unique: o8o1w4IGPzePkI8IVi7YNA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 186431977325
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 16:07:12 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.34.24])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1727319560BF;
	Fri, 14 Jun 2024 16:07:10 +0000 (UTC)
From: Bill O'Donnell <bodonnel@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cmaiolino@redhat.com,
	Bill O'Donnell <bodonnel@redhat.com>
Subject: [PATCH v3 3/4] xfs_fsr: correct type in fsrprintf() call
Date: Fri, 14 Jun 2024 11:00:15 -0500
Message-ID: <20240614160643.1879156-4-bodonnel@redhat.com>
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

Use %lld instead of %d for howlong variable.

Coverity-id: 1596598

Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
---
 fsr/xfs_fsr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index fdd37756..06cc0552 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -426,7 +426,8 @@ fsrallfs(char *mtab, time_t howlong, char *leftofffile)
 	fsdesc_t *fsp;
 	struct stat sb, sb2;
 
-	fsrprintf("xfs_fsr -m %s -t %d -f %s ...\n", mtab, howlong, leftofffile);
+	fsrprintf("xfs_fsr -m %s -t %lld -f %s ...\n", mtab,
+		  (long long)howlong, leftofffile);
 
 	endtime = starttime + howlong;
 	fs = fsbase;
-- 
2.45.2

