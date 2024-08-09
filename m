Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5631870
	for <linux-xfs@vger.kernel.org>; Fri,  9 Aug 2024 16:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723220406; cv=none; b=dGQYOdF5YzCOBrmV1l29d8igQf2XSsiagtn+WQl+3hA6TqmXxDHC9kIcwrIOtX6/NyCGmVzUr+WUJ/zEfhpOxjZ/TX2spK6caZimNj/kbvbTRiwyM6sGiWS4q00dM+oI7+kM60rO+o+nd+6W+hUqiwWdADeCqFeHMg6heczP6N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723220406; c=relaxed/simple;
	bh=4toctklRGlqDiGyugmykkHxcPsH+3b5DBSrYn3jKujM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A6UaIktsfrWOnrxLQwXtwFTsl6ADHQOOuN4hjmhCBSyUiqcOzH7s97rcp7mwIknDuKi87fVEktok+WZYFc5uzWgf7dK7zUGBh4joiWlSpTsMqH5GbIUW7J+6hG5IIv/t6zqMUXtWBjmi3HkqTUF+0g0suLgUEcsjmZsUy4NFz84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A1/S8vX3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A1/S8vX3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723220403;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=QzI77namtqetni0m21j3KTp92KjlugEG5tCZkOUmOm0=;
	b=A1/S8vX3V2QOYdeYaCpHTVx3CSxqJOHGfh5GJL2auOKaiQIK1cJKPiDoSrVVqWYaMHd4p4
	GjHsA3AlETB/ZqEw6IRwzw9UQtOomlftF68wi6z+FNub6TFvoW7TbtHoRm8YBiCBbeLdyR
	1SdRI4Jtvdjug13XhMl/wnphVwduSTA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-562-zo12wfnEPFGNDCqrYkYKVQ-1; Fri,
 09 Aug 2024 12:20:00 -0400
X-MC-Unique: zo12wfnEPFGNDCqrYkYKVQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 757701956095;
	Fri,  9 Aug 2024 16:19:59 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.32.103])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 05F7F19560AE;
	Fri,  9 Aug 2024 16:19:57 +0000 (UTC)
From: Bill O'Donnell <bodonnel@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	sandeen@sandeen.net,
	cem@kernel.org,
	Bill O'Donnell <bodonnel@redhat.com>
Subject: [PATCH v4] xfs_db: release ip resource before returning from get_next_unlinked()
Date: Fri,  9 Aug 2024 11:15:11 -0500
Message-ID: <20240809161509.357133-3-bodonnel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

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
---
db/iunlink.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/db/iunlink.c b/db/iunlink.c
index d87562e3..98d1effc 100644
--- a/db/iunlink.c
+++ b/db/iunlink.c
@@ -49,8 +49,12 @@ get_next_unlinked(
 
 	ino = XFS_AGINO_TO_INO(mp, agno, agino);
 	error = -libxfs_iget(mp, NULL, ino, 0, &ip);
-	if (error)
-		goto bad;
+	if (error) {
+		if (ip)
+			goto bad_rele;
+		else
+			goto bad;
+	}
 
 	if (verbose) {
 		xfs_filblks_t	blocks, rtblks = 0;
@@ -67,13 +71,16 @@ get_next_unlinked(
 
 	error = -libxfs_imap_to_bp(mp, NULL, &ip->i_imap, &ino_bp);
 	if (error)
-		goto bad;
+		goto bad_rele;
 
 	dip = xfs_buf_offset(ino_bp, ip->i_imap.im_boffset);
 	ret = be32_to_cpu(dip->di_next_unlinked);
 	libxfs_buf_relse(ino_bp);
+	libxfs_irele(ip);
 
 	return ret;
+bad_rele:
+	libxfs_irele(ip);
 bad:
 	dbprintf(_("AG %u agino %u: %s\n"), agno, agino, strerror(error));
 	return NULLAGINO;
-- 
2.46.0

