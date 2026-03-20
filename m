Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50961A6817
	for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2026 13:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774013264; cv=none; b=fcWv5GPOYPdu57e5T+6QRPs8kkIDk6fCn8oy79I0RTTbYgSCNFnKMpo5mo6o61hJ318Zv25RAOGDt5FFScRNM1PAA+WW+ajmadyXL9cC/KWp7nZqeIN77hqRpv2Vtmv6UORLMuRq1BcNWrvzJHk+hxxx4WuCGQG+w9C7jmfyhr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774013264; c=relaxed/simple;
	bh=4DkD02w93NRBZvlcbED93Akmbs2vaS1j0o7dbzCv+Qw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FSVOk2K4SbrBe2ZlOVpUqgHefSuQV+zRPu7K/c/fM2+j1vcWnt1n9oafqdbvdkibmO/AevMFq5Mec+yD8rmx5yvqs+UC43TK6nP+xddQIvNl9xiOKOZvE1HP0p/w0RXehAl81yUefULqeY7XRGSYI78DZy0wrRnf8YQPo8Z/4xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dfwSXIi5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dfwSXIi5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774013261;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0BfAMfE2+J0+AredTECL3l7TF9y3hBFjvPfmdnESa4A=;
	b=dfwSXIi59flKhTA4bzVsnADhJEDprV+6xwZEdcQKF16cuUBUIcCd1J/zRldDZmR1Gqoj3l
	LERoVItc1thE5/9r8/QXiu3SsVE91ZuIOPhHFcXjX9a02NSpBn6gotFD2Sx/AcMfGe+Hi2
	Hd8WoFislqo3dqWh8qw+sipEkNWgxOM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-250-XPLgY9eXOL2SjMQ0PPB5hg-1; Fri,
 20 Mar 2026 09:27:40 -0400
X-MC-Unique: XPLgY9eXOL2SjMQ0PPB5hg-1
X-Mimecast-MFC-AGG-ID: XPLgY9eXOL2SjMQ0PPB5hg_1774013259
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7C78318005B2
	for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2026 13:27:39 +0000 (UTC)
Received: from tbecker-thinkpadp16vgen1.rmtbr.csb (unknown [10.96.134.48])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 79E021800766;
	Fri, 20 Mar 2026 13:27:38 +0000 (UTC)
From: tbecker@redhat.com
To: linux-xfs@vger.kernel.org
Cc: Thiago Becker <tbecker@redhat.com>
Subject: [PATCH] libxfs: fix printing of cache.c_maxcount.
Date: Fri, 20 Mar 2026 10:27:34 -0300
Message-ID: <20260320132734.2621943-1-tbecker@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

From: Thiago Becker <tbecker@redhat.com>

c_maxcount is usigned, but is being printed as signed.

Signed-off-by: Thiago Becker <tbecker@redhat.com>
---
 libxfs/cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxfs/cache.c b/libxfs/cache.c
index af20f385..e6443fa6 100644
--- a/libxfs/cache.c
+++ b/libxfs/cache.c
@@ -85,7 +85,7 @@ cache_expand(
 {
 	pthread_mutex_lock(&cache->c_mutex);
 #ifdef CACHE_DEBUG
-	fprintf(stderr, "doubling cache size to %d\n", 2 * cache->c_maxcount);
+	fprintf(stderr, "doubling cache size to %u\n", 2 * cache->c_maxcount);
 #endif
 	cache->c_maxcount *= 2;
 	pthread_mutex_unlock(&cache->c_mutex);
-- 
2.53.0

