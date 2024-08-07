Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08C158203
	for <linux-xfs@vger.kernel.org>; Wed,  7 Aug 2024 19:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723059634; cv=none; b=JR2Dgdza4sIfoMSlbQ3QSjSARW8PzYuoz2C1TLxjExYISOaThKveyfHO0ExMbXj91BgxPBdDbXH/IRLP6H9gNGnmnjxhZc4+pegmjjid4XrzKQzKlPWoW+dEm1D1AzKjSmuy/AtzTsaoSdBTClfTIT08JPpPfs1WcFpCn+tMfac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723059634; c=relaxed/simple;
	bh=T1KNh9qlcCRb53l5jw8v9fuip2Kq32T9Kd+PeiPL7vc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NbkDW+Xg+jT5hsplF/5wPFhp3b/hjNgOuZrVRoejhE+qSSeLGjfGztu4hdfLHLDglQ8ZV2olFBuOmwsCWWsOJVOVf/lIkNlCSAJ552Mf7wxhErMAxli8in5FkEr3gvHUXDkhgSVVvh9qnp7Zn3qnjupPViqwcV/KYZ4dyvfKFHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YF1dWroB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YF1dWroB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723059630;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MIZM8QpiUOoLKRR6XlPXI/grUbCLYhQ9qX6kPK3zrSg=;
	b=YF1dWroBYlWBDtYUISs78K6nG7+12yuO24L61LA3pKP3UIIX+8WVl9xCLuBJ/CWXQBah3G
	nyY0FfnDkudxng7X3/ZKIe5iYF3fQBQtWypigidZnJ7LvLp+dgF8o+A3KX17mFsWfaS41y
	hzfJSklowfSOnojZLtt2+l8viMJ6v4g=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-610-wSwnCbbBMxqTFpGGIvmC1A-1; Wed,
 07 Aug 2024 15:40:27 -0400
X-MC-Unique: wSwnCbbBMxqTFpGGIvmC1A-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 46C181955F0D;
	Wed,  7 Aug 2024 19:40:26 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.32.103])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2FB2919560A3;
	Wed,  7 Aug 2024 19:40:25 +0000 (UTC)
From: Bill O'Donnell <bodonnel@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	sandeen@sandeen.net,
	cem@kernel.org,
	Bill O'Donnell <bodonnel@redhat.com>
Subject: [PATCH v3] xfs_db: release ip resource before returning from get_next_unlinked()
Date: Wed,  7 Aug 2024 14:38:03 -0500
Message-ID: <20240807193801.248101-3-bodonnel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Fix potential memory leak in function get_next_unlinked(). Call
libxfs_irele(ip) before exiting.

Details:
Error: RESOURCE_LEAK (CWE-772):
xfsprogs-6.5.0/db/iunlink.c:51:2: alloc_arg: "libxfs_iget" allocates memory that is stored into "ip".
xfsprogs-6.5.0/db/iunlink.c:68:2: noescape: Resource "&ip->i_imap" is not freed or pointed-to in "libxfs_imap_to_bp".
xfsprogs-6.5.0/db/iunlink.c:76:2: leaked_storage: Variable "ip" going out of scope leaks the storage it points to.
#   74|   	libxfs_buf_relse(ino_bp);
#   75|
#   76|-> 	return ret;
#   77|   bad:
#   78|   	dbprintf(_("AG %u agino %u: %s\n"), agno, agino, strerror(error));

Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
---
v2: cover error case.
v3: fix coverage to not release unitialized variable.
---
 db/iunlink.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/db/iunlink.c b/db/iunlink.c
index d87562e3..57e51140 100644
--- a/db/iunlink.c
+++ b/db/iunlink.c
@@ -66,15 +66,18 @@ get_next_unlinked(
 	}
 
 	error = -libxfs_imap_to_bp(mp, NULL, &ip->i_imap, &ino_bp);
-	if (error)
+	if (error) {
+		libxfs_buf_relse(ino_bp);
 		goto bad;
-
+	}
 	dip = xfs_buf_offset(ino_bp, ip->i_imap.im_boffset);
 	ret = be32_to_cpu(dip->di_next_unlinked);
 	libxfs_buf_relse(ino_bp);
+	libxfs_irele(ip);
 
 	return ret;
 bad:
+	libxfs_irele(ip);
 	dbprintf(_("AG %u agino %u: %s\n"), agno, agino, strerror(error));
 	return NULLAGINO;
 }
-- 
2.45.2

