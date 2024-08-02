Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B0F1757D
	for <linux-xfs@vger.kernel.org>; Fri,  2 Aug 2024 22:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722637582; cv=none; b=V7vKUZY2AYWATsrmwyChkCL45Y8zxTeNvI3tpdhG6l+1JSKDYsQOJWkQhKxagODW8mlxDd0G/cXlioH/r4HeeG5kRIxLUOZRj7E3s8gBUxxOQyuYqrUwZPmeo1MO6xo8tjsKmqbuwXtEdH8z2lao30cCRG+g50CcFtCXBN0Nxvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722637582; c=relaxed/simple;
	bh=wBIK0cOKXQ3+tDAb52kq15u6pMCga0pWeFQFH5VgemM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LZZWqG7dlm5vs5iEquLO0NBXyJPL8+VZCXVhrTyoU+CocQyc5GK08B7mEJTYL4oee/M59bSdFwK25SAKyMDqqnrxEBrQNI7OR6ENC01yRSGqPUXyPbmKbAG79aPFZFZdDi7eUEFF7CGTcORlUczrj29yvLXC6gdAGSY42vdCMmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UYibSi6b; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UYibSi6b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722637579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=c1MlrX2CsZGoB5oaGU+Gx/mKUVmm5Y/agIQZyrKaXWk=;
	b=UYibSi6bI5RdTHoaKSWRtMVElDcXBCZ3KdzIvuA73ei+ORW9sDsmoZ75cEGKwCGzlez05s
	/aBmDPb+4BDxUPKmkKeBYonIyCkb/VsW8eyYdcVmx7p0YsWlkzx4cDwrtHhFjN1BxpPlso
	yxSLGREHUagcOAUB6Juilg93O/nLxLM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-301-i5jf7ptsPVGP0mtoKkpTDw-1; Fri,
 02 Aug 2024 18:26:16 -0400
X-MC-Unique: i5jf7ptsPVGP0mtoKkpTDw-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0776C1955D44;
	Fri,  2 Aug 2024 22:26:15 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.32.103])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 55BDE1955E80;
	Fri,  2 Aug 2024 22:26:13 +0000 (UTC)
From: Bill O'Donnell <bodonnel@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	Bill O'Donnell <bodonnel@redhat.com>
Subject: [PATCH] xfs_db: release ip resource before returning from get_next_unlinked()
Date: Fri,  2 Aug 2024 17:25:52 -0500
Message-ID: <20240802222552.64389-1-bodonnel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

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
 db/iunlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/db/iunlink.c b/db/iunlink.c
index d87562e3..3b2417c5 100644
--- a/db/iunlink.c
+++ b/db/iunlink.c
@@ -72,6 +72,7 @@ get_next_unlinked(
 	dip = xfs_buf_offset(ino_bp, ip->i_imap.im_boffset);
 	ret = be32_to_cpu(dip->di_next_unlinked);
 	libxfs_buf_relse(ino_bp);
+	libxfs_irele(ip);
 
 	return ret;
 bad:
-- 
2.45.2

