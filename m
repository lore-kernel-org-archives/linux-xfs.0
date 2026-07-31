Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3972F12AC
	for <linux-xfs@vger.kernel.org>; Fri, 31 Jul 2026 16:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785515626; cv=none; b=rPoj874UnV54wNj+7fa94112urmFaIHqEAYw2BDDWzvDKYspOdkyNUVUxNsLK6jGJ8njZC3EB5GOpotw3hUttmyXc7nv9CtKpMZlo1IimT+JjrM3anlkMIkD7ka/+araGgp+TL8qCQ1Fy+hGhsLYAoeB+k8kN8X9TXxjIJmKYCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785515626; c=relaxed/simple;
	bh=ODQMTkOjmpT06+iugZQDCMegVutvaIkAXTH18XZ9aTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UHTo66DSt8InvLMVCWx18FJdMR73BO+A5CNgm2BwAjgyvWd4mW7VvURZBcxGwiUc2FQRxcXlDwzB47gBu7gKM3vuF2vbU1fa1CcpabV7hvByH39djikDDNe1HEN2S4hps7186bkvVIz6rMzE+4lp06j/0JhvUY6v+1/30vOW0Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cvp3dZN+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cvp3dZN+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785515623;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ePwm/Sup5CRtR0h4eRer/SB/jldLZQQQatP1o8m2knM=;
	b=Cvp3dZN+xOdDBJKStpP6erI4rgQdtAXmGzOCtCLI6jlI++Q9uB46dAIKu2Db9m3vdUVRkN
	uZAa9r1k8f9srJBH52gVAzTsw3vHN9ISbwaC2CpLOr5wlor60olr7jFkzlvDT3fHUQ9pEU
	6WybgPB/TLaRjXsJ9ZT0XyL19URE5N8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-623-JCZEf4e8N_6nmWA8O7c81A-1; Fri,
 31 Jul 2026 12:33:41 -0400
X-MC-Unique: JCZEf4e8N_6nmWA8O7c81A-1
X-Mimecast-MFC-AGG-ID: JCZEf4e8N_6nmWA8O7c81A_1785515619
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5D7371956089;
	Fri, 31 Jul 2026 16:33:39 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.80.193])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C981C30002E9;
	Fri, 31 Jul 2026 16:33:38 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Matt Fleming <matt@readmodwrite.com>
Subject: [PATCH 1/2] xfs: set minleft correctly for sparse chunk errortag allocation
Date: Fri, 31 Jul 2026 12:33:36 -0400
Message-ID: <20260731163337.152522-2-bfoster@redhat.com>
In-Reply-To: <20260731163337.152522-1-bfoster@redhat.com>
References: <20260731163337.152522-1-bfoster@redhat.com>
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
---
 fs/xfs/libxfs/xfs_ialloc.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index ffcdd1f691fd..633b2d6e42c5 100644
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

