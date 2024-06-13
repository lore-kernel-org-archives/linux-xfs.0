Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74B0149DF7
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 21:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718313596; cv=none; b=AX6sRJFRRaM6B7AXuxk4pzLw4fv3v8xyL8mRFKoRTimu67kMovl4EqAL/xx6e5O+jPbZ7lglF0yBueB1cW2MTX4EwzrFtl4AshKaeClNnA7kyLlT+nYHynT5Al4jxfIp42vYzdAXuTSrWlyIR5Z25jz3Emvk6d45ozUyeCtjenM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718313596; c=relaxed/simple;
	bh=Psgl4jWfxo5CxhvH5p9i+VXNoKSO6EurRUXoquwBArM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qrPhSbLVZr7mpUBhVMNx05U03BPuvffmhCRle+7u5mReJkhlmD3sGa+UBw8Tg/75U3vZtWgNVKNccCvFfbtJSczV7zwiWO8gyCr4sGhoP34dVw62wSKzvm5wnW0QOVBN+Brljj/ZESUuSvdVnRNlFhPEZrApaf8PPtQpaOEtttE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AU7QZHw9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AU7QZHw9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718313593;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pZIlJphp8G8/h6O5w/8tP06TqZ6erkdAGwexKEZ/9fI=;
	b=AU7QZHw9Xv36yFh728ry1CwtRQl8pdHcLioD5DYfS3Yx/+EEDPXCvPrZmwRW8XhynE92p6
	cV5r3136OjOXFffxUwiPhl6qzIEIZeZxZKAFmdnu424l3qKNoTVbE5NPWF8W9kTfbJvc2x
	KrUaSKx8hmmmbr6yMHlDpwNfUPaq0WA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-418-A_mjydQVNR-dVFnvcmBeFQ-1; Thu,
 13 Jun 2024 17:19:52 -0400
X-MC-Unique: A_mjydQVNR-dVFnvcmBeFQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6034C19560B2
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 21:19:51 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.34.24])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 79C131956056;
	Thu, 13 Jun 2024 21:19:50 +0000 (UTC)
From: Bill O'Donnell <bodonnel@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cmaiolino@redhat.com,
	Bill O'Donnell <bodonnel@redhat.com>
Subject: [PATCH v2 3/4] xfs_fsr: correct type in fsrprintf() call
Date: Thu, 13 Jun 2024 16:09:17 -0500
Message-ID: <20240613211933.1169581-4-bodonnel@redhat.com>
In-Reply-To: <20240613211933.1169581-1-bodonnel@redhat.com>
References: <20240613211933.1169581-1-bodonnel@redhat.com>
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

