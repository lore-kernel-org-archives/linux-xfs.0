Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4874F40DB55
	for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 16:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790180131; cv=none; b=fcqJ9J1UJ+AUzszoxxTmhtKTz6QUWmB5RTFZYPjkkSJ/b9QGFJatn4/6MscWca6eKubnT/+nWpTf6l783Nh5S3flm1I21tAX6I31UyoQqudddzWctkvqOj1hSQmALsMbLXMirt/UUDBDxu/CsT0x/XTrm0bMwXHqiv3xn2KXC/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790180131; c=relaxed/simple;
	bh=nZjGH5/RZAPFMAiVc07KrnIB5LsAGxKKvLsc3hV0amU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hfqkb+lUigBPNhij64cDDYOGIAIBW1V6Abn7JKY+W/uVi0pkAQpCmNXMgJfzcLi5RdV5pcrdpUEJvtaOoyTO3XQ4W13Xl10lXKglHSCechi9sGr1enQeAslkHppKxMSQgCIFeWxAb4A7Ds7YPTGzMP/LzOUC/oeferZllvMdx8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f/6xMGRg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f/6xMGRg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790180129;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PRkyL84gQgwuP7OjTp+WvlmToqY1TePu1gru9EXR8ts=;
	b=f/6xMGRgF2vTIO/kZ6nCZSc/oyq1Oy74csLCYVBC4Y/IfHD6KFWlMZ2zYp/d162FKtDN6l
	Z8kIbeyIDg8w5VY9CgtwI8fLu4ll1NQD1OGS13ZPtw4dQahuO9X6XmPbcWQwaf7EDtOHX2
	vqvYLcJJbhv2SdJUbqtOY9djhLIGC14=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-609-bDomdocaNiWC3YaCiJRAxA-1; Wed,
 23 Sep 2026 12:15:27 -0400
X-MC-Unique: bDomdocaNiWC3YaCiJRAxA-1
X-Mimecast-MFC-AGG-ID: bDomdocaNiWC3YaCiJRAxA_1790180126
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 86AAB180ABDD;
	Wed, 23 Sep 2026 16:15:26 +0000 (UTC)
Received: from bfoster.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F22F73000218;
	Wed, 23 Sep 2026 16:15:25 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Carlos Maiolino <cem@kernel.org>
Subject: [PATCH v4 1/4] xfs: set minleft correctly for sparse chunk errortag allocation
Date: Wed, 23 Sep 2026 12:15:21 -0400
Message-ID: <20260923161524.416059-2-bfoster@redhat.com>
In-Reply-To: <20260923161524.416059-1-bfoster@redhat.com>
References: <20260923161524.416059-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

The errortag instrumentation for forced sparse chunk allocation
jumps straight to the allocation path without setting args.minleft.
minleft is unconditionally set to ->inobt_maxlevels for the normal
allocation path. Lift the assignment to the initial args setup so
it covers all possible paths.

Assisted-by: LLM
Fixes: 1cdadee11f8d ("xfs: randomly do sparse inode allocations in DEBUG mode")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Mark Tinguely <mark.tinguely@oracle.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ialloc.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 19b513b11692..e31611cabd4d 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -733,6 +733,10 @@ xfs_ialloc_ag_alloc(
 							igeo->maxicount)
 		return -ENOSPC;
 	args.minlen = args.maxlen = igeo->ialloc_blks;
+
+	/* Allow space for the inode btree to split. */
+	args.minleft = igeo->inobt_maxlevels;
+
 	/*
 	 * First try to allocate inodes contiguous with the last-allocated
 	 * chunk of inodes.  If the filesystem is striped, this will fill
@@ -764,8 +768,6 @@ xfs_ialloc_ag_alloc(
 		args.alignment = 1;
 		args.minalignslop = igeo->cluster_align - 1;
 
-		/* Allow space for the inode btree to split. */
-		args.minleft = igeo->inobt_maxlevels;
 		error = xfs_alloc_vextent_exact_bno(&args,
 				xfs_agbno_to_fsb(pag, args.agbno));
 		if (error)
@@ -804,10 +806,6 @@ xfs_ialloc_ag_alloc(
 		 * Allocate a fixed-size extent of inodes.
 		 */
 		args.prod = 1;
-		/*
-		 * Allow space for the inode btree to split.
-		 */
-		args.minleft = igeo->inobt_maxlevels;
 		error = xfs_alloc_vextent_near_bno(&args,
 				xfs_agbno_to_fsb(pag,
 					be32_to_cpu(agi->agi_root)));
-- 
2.55.0

