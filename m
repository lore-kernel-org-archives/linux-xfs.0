Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128B84C6B
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 18:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718302694; cv=none; b=gfUcz1Yk4fCH9BzDn+Cep2ocy0rHXqqLuDY5ICQ3bH3Cax/Py8YsSWJ5C3FScB2eDZWWSJYEK6EeOJj3u1GQMpAox6HLFmL8fl+LYO1yPaLWnVGjc3eGrQDRsB+hKekwQL0zT7bn34QwCvv9k5fKTU+RWY504ZMizf2R6X26WJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718302694; c=relaxed/simple;
	bh=4MFNKBkwOuCTKGMrWeriH18qR1ppM/8njECJL03PqGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MFLD7SP0ZtNSgcSoSWxULTjo6RgIk5qPZ5voZ97UFpfyWJirG/DNY+w1R66RowToCx7fJuQ9UI9tVuYJ56qv42JdrmTyLlBDuvGg5gYXg/HLTirmFSvvCbh2zffFSzSHto+gDfwSgqYh+TfeQqtWmXqc9RlTWQeG4DrAe94LDJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z/IPV1i6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z/IPV1i6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718302688;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9//GnoWQOg3r7NCHZJv5fANLow1kY48WzmeTaph72lg=;
	b=Z/IPV1i6XidNyO0IodZGo/Xz1krtY3B6Vz13jceMd7GUIAFtcQEqhRYk2leyvxJ8YvbRIR
	fBFsgHGT4VpJsRmb1W/BGVuIQtnUnsAx6CXj2+XdwxXkW3ZkDkZe12oWTKwvCJJeEcKcOv
	owY/g7hojTmMeV9yZQugYqvg7nBnAYI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-126-kaPPE9_ZPBO7myTPCZ2oRw-1; Thu,
 13 Jun 2024 14:18:05 -0400
X-MC-Unique: kaPPE9_ZPBO7myTPCZ2oRw-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BF7AF19560AD
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 18:18:03 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.34.24])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E86F61956056;
	Thu, 13 Jun 2024 18:18:02 +0000 (UTC)
From: Bill O'Donnell <bodonnel@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cmaiolino@redhat.com,
	Bill O'Donnell <bodonnel@redhat.com>
Subject: [PATCH 2/4] xfs_db: fix unitialized variable ifake->if_levels
Date: Thu, 13 Jun 2024 13:07:06 -0500
Message-ID: <20240613181745.1052423-3-bodonnel@redhat.com>
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

Initialize if_levels to 0.

Coverity-id: 1596600, 1596597

Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
---
 db/bmap_inflate.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/db/bmap_inflate.c b/db/bmap_inflate.c
index 33b0c954..8232f486 100644
--- a/db/bmap_inflate.c
+++ b/db/bmap_inflate.c
@@ -351,6 +351,7 @@ build_new_datafork(
 	/* Set up staging for the new bmbt */
 	ifake.if_fork = kmem_cache_zalloc(xfs_ifork_cache, 0);
 	ifake.if_fork_size = xfs_inode_fork_size(ip, XFS_DATA_FORK);
+	ifake.if_levels = 0;
 	bmap_cur = libxfs_bmbt_stage_cursor(ip->i_mount, ip, &ifake);
 
 	/*
@@ -404,6 +405,7 @@ estimate_size(
 
 	ifake.if_fork = kmem_cache_zalloc(xfs_ifork_cache, 0);
 	ifake.if_fork_size = xfs_inode_fork_size(ip, XFS_DATA_FORK);
+	ifake.if_levels = 0;
 
 	bmap_cur = libxfs_bmbt_stage_cursor(ip->i_mount, ip, &ifake);
 	error = -libxfs_btree_bload_compute_geometry(bmap_cur, &bmap_bload,
-- 
2.45.2

