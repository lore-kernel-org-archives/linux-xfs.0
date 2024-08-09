Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2296546542
	for <linux-xfs@vger.kernel.org>; Fri,  9 Aug 2024 17:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723223909; cv=none; b=B5zYKo6Anb8rVP1GOSBexx9igV+vKnEauWfGGILnEz3w9CF7QVT3P/qKo5+p3/K1vTIqsTAN8OgGugP5L759gjwNi+47VkPPUTA0slNvd6UJSMJz7rYjNS3PKJXv6fV/0FK9uy2B6knn39++2Gwen3LvBuMzuYxH1d/zWwLxgEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723223909; c=relaxed/simple;
	bh=WBT+r0bsAh+5IoS+c51mNn1R0SD/xOfcHK2e8iqDutQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S+7KxMuwDsVnXvkj9ktOXPW8P3z1H/AI9qkpn+MWLJ6SW5B4Ft1OLpfFaGgMsWG0gNIBx2vnIgpJ7Cc4pnZoyLyQCVEdAMEmsu1RshdqyYT5HCcPS8ls5FtpRE08nuHf+OkinFzagvQATCK7rFn25eymmpArzmTN9egP+D9iOmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dP/kKlQs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dP/kKlQs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723223907;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8akKrMxZB3oGr9d0cwnnQJT7UPJkTonQOFy4fYG0IdE=;
	b=dP/kKlQsKwWc9wt6vbZeWZtcFKkgqlfy2ZgWgFMyn9Y8FiTCPuD7Xp9LPjixABDZLWXaHQ
	FAmw9hOqixEAdaWnWrcXN89rAKzCIAOysnGJ/bNVEqJPOIxRMRLJpWu0jjHLTRF5rIP26e
	3zdrnbQp6hyhgzom4VgDJgV4HTZFttI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-528-akS5PToEM56ujm9bCT0K8A-1; Fri,
 09 Aug 2024 13:18:24 -0400
X-MC-Unique: akS5PToEM56ujm9bCT0K8A-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AA610196CDF3;
	Fri,  9 Aug 2024 17:18:22 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.32.103])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1801F1956089;
	Fri,  9 Aug 2024 17:18:20 +0000 (UTC)
From: Bill O'Donnell <bodonnel@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	sandeen@sandeen.net,
	cem@kernel.org,
	Bill O'Donnell <bodonnel@redhat.com>
Subject: [PATCH v5] xfs_db: release ip resource before returning from get_next_unlinked()
Date: Fri,  9 Aug 2024 12:15:42 -0500
Message-ID: <20240809171541.360496-2-bodonnel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

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
v4: add logic to cover error case when ip is not attained.
v5: no need to release a NULL tp in the first error case.
---
 db/iunlink.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/db/iunlink.c b/db/iunlink.c
index d87562e3..35dbc3a0 100644
--- a/db/iunlink.c
+++ b/db/iunlink.c
@@ -66,12 +66,15 @@ get_next_unlinked(
 	}
 
 	error = -libxfs_imap_to_bp(mp, NULL, &ip->i_imap, &ino_bp);
-	if (error)
+	if (error) {
+		libxfs_irele(ip);
 		goto bad;
+	}
 
 	dip = xfs_buf_offset(ino_bp, ip->i_imap.im_boffset);
 	ret = be32_to_cpu(dip->di_next_unlinked);
 	libxfs_buf_relse(ino_bp);
+	libxfs_irele(ip);
 
 	return ret;
 bad:
-- 
2.46.0

