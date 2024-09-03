Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9A618F2C4
	for <linux-xfs@vger.kernel.org>; Tue,  3 Sep 2024 17:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725385339; cv=none; b=XNHvyRfzC3Sqava0wZZit2/U2ia8GZ2Lo/Q1fSilXQDNwbcF0hLl1lM0rIDs91d1SHutI/LNn17oQ0Fe7a3afx1ftxN2KC6e6HTO1nl+/cRjbuPCIYGECRYaPtzAedv1sgOxDc65DBZ4kNDbGv3OUnundLE49NbHp7dymsTznQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725385339; c=relaxed/simple;
	bh=VyjOHJMBpBhdfitoKNFY5nbfM+9Qlq/3fQU59AAQfwU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NzwN3utrTplJAdFpWhJxgbLnJrzlb/z2mkVPEFeAU2J+ZhL0dWTfh/3pfnSlfiMyJvYNSEi6NLVKEDCikekQN21TTB+T/9HtIQo8qUe6GO7l7xeTuW1TEhqM4Sw+goDrxfOuRRlpxGHWYoNNpojhqWM1WF4AXYAvVF8U/b967Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DAPjZx7o; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DAPjZx7o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725385336;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Cl0bKkOyy3vAGCdU0ZlVsvQjgftKy/3uFNj0iagwaxA=;
	b=DAPjZx7oh4OhvBYpDC7K2dEmey1YIxx6RwZ0hxnG6aKoO/pNQSxDpSx+3xrxMqPhyPzLTg
	TjeOWVVHpxi9S82tSOgC5NQlNhg004utvBRce+t/TPiqIz6WcM+eH9iQ7HGRlWckBLFS/Y
	Zj+yPp/bkO4VjFbXGz0Oe3fFkLHwxzY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-641-gLb__RwVMTeMFUDf_6Je1g-1; Tue,
 03 Sep 2024 13:42:15 -0400
X-MC-Unique: gLb__RwVMTeMFUDf_6Je1g-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 093D11955BEE;
	Tue,  3 Sep 2024 17:42:14 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.33.32])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D45BA30001A4;
	Tue,  3 Sep 2024 17:42:12 +0000 (UTC)
From: Bill O'Donnell <bodonnel@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	sandeen@sandeen.net,
	Bill O'Donnell <bodonnel@redhat.com>
Subject: [PATCH] xfsdump: Remove dead code from restore_extent().
Date: Tue,  3 Sep 2024 12:41:41 -0500
Message-ID: <20240903174140.268614-2-bodonnel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Remove dead code and from restore_extent() in content.c.
Variable rttrunc is constantly 0.

Coverity CID 1618877

Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
---
 restore/content.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/restore/content.c b/restore/content.c
index 7ec3a4d..20f9dbf 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -8495,7 +8495,6 @@ restore_extent(filehdr_t *fhdrp,
 				      tries++,
 				      remaining -= (size_t)rval,
 				      tmp_off += (off64_t)rval) {
-					int rttrunc = 0;
 					int trycnt = 0;
 					assert(remaining
 						<=
@@ -8535,12 +8534,6 @@ restore_extent(filehdr_t *fhdrp,
 						      tmp_off,
 						      rval);
 					}
-					if (rttrunc) {
-						/* truncate and re-set rval */
-						if (rval == remaining)
-							rval = rttrunc;
-						ftruncate(fd, bstatp->bs_size);
-					}
 				}
 			} else {
 				nwritten = (int)ntowrite;
-- 
2.46.0

