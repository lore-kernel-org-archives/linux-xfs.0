Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613CC1482E9
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 18:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718302689; cv=none; b=n2u68jSxQGxWCcT8ZrEm+6XGj6VEOoP6r0qD37DQm4XX9DQhVvgUbqxhBZbiwflWYJiqQecJlsLi0OqIcJyWRoyYM5PJ4PPneunLYJH0MvU6VwrlfhKkRKWnsBu3Riy4YdcTMbFRKjjAPhow0PSqJ95TKF5ZFEW86KY2vS3MqJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718302689; c=relaxed/simple;
	bh=Psgl4jWfxo5CxhvH5p9i+VXNoKSO6EurRUXoquwBArM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mF4Te58Ncqz2xDEslmKQInan+UKt32BPpC8ETZDOFDJR8A3FuFBZKh3o89y/HZcMOVpU4LlHCzQTyrBu26egjwtxdQPGKxWFVjlmtdflGmtzm1A25NreUIWmULekF22kZIZ/X06rSTWS2vJN4MPJ93Y5k1gdyKDJ7Ji3C7c/C9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IkTLA3JA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IkTLA3JA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718302687;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pZIlJphp8G8/h6O5w/8tP06TqZ6erkdAGwexKEZ/9fI=;
	b=IkTLA3JAE/sHBFi7f6NiLm5i1pR9KOni8BonLyuZVR00QnY3X8Ra5pLVuiGMv22w2Ln3W+
	OMQr3EySn5sPpQruOFnY9GdEdgE2vKOQwUmC7ta05fG5Xq5tUqhmyh6TBoaga0yAC5Preb
	h+HETq/wtM16J5fvYVQpFifwl51wbss=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-328-qdSujx6QMOSjCJbDoJiXsw-1; Thu,
 13 Jun 2024 14:18:05 -0400
X-MC-Unique: qdSujx6QMOSjCJbDoJiXsw-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D7E431956086
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 18:18:04 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.34.24])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F39B61956056;
	Thu, 13 Jun 2024 18:18:03 +0000 (UTC)
From: Bill O'Donnell <bodonnel@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cmaiolino@redhat.com,
	Bill O'Donnell <bodonnel@redhat.com>
Subject: [PATCH 3/4] xfs_fsr: correct type in fsrprintf() call
Date: Thu, 13 Jun 2024 13:07:07 -0500
Message-ID: <20240613181745.1052423-4-bodonnel@redhat.com>
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

Use %ld instead of %d for howlong variable.

Coverity-id: 1596598

Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
---
 fsr/xfs_fsr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index fdd37756..d204e3a4 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -426,7 +426,7 @@ fsrallfs(char *mtab, time_t howlong, char *leftofffile)
 	fsdesc_t *fsp;
 	struct stat sb, sb2;
 
-	fsrprintf("xfs_fsr -m %s -t %d -f %s ...\n", mtab, howlong, leftofffile);
+	fsrprintf("xfs_fsr -m %s -t %ld -f %s ...\n", mtab, howlong, leftofffile);
 
 	endtime = starttime + howlong;
 	fs = fsbase;
-- 
2.45.2

