Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4981946AA9F
	for <linux-xfs@vger.kernel.org>; Fri, 14 Aug 2026 13:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786713769; cv=none; b=QZFVsq3sUN9Nj1NXfKgqu6Y7nI1+q/pptrEK7KCX37HCPJx0FL1mv8HT9sfXD4vI6YxXP5qa1e6Mh6gMcHiemBl+wFk/NMPD1CtYGUwG1M6H3AnXoeDS/pRUu/OoScAudq8l9aEG5MEhzdsut2R3AL9Nq40zMrhWfa16+n0o8Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786713769; c=relaxed/simple;
	bh=dQZa88XrYSZgvuQ3N9q3MYtcQTEaIGx1UBNSQYgojkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GiT1mY2SsN4DNv2SORP2wA2gZuf6Ob2ff+d5TLYw1vKf6zSnt01n8Kp7g32n4SaIuOFoKou4fmCdVQYTvShV2iwRpTu8MCzSWyTHQCH5lyrAezAwp0UEO7AO/Et5v/cNXGFIrx3KG3v7Ra1XPQlfGYDGJNpKGIWxMir9BCv2D8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MarnhyZ6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MarnhyZ6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786713767;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b0hCoHKKFf+fjfS1+JpKWcHRoNavAwJ7aiDzwaopqV8=;
	b=MarnhyZ6PTeM+Ro3RFOr7xiU5HziEVR7QrQyMbW1bdwum2Eh5eTUNSD05BJamyhF0T24ih
	gUsU91rvAGjR7pG3Zpvw24u+KPqM9XXEMlKG18VmrCVjUs1kYhxhtgkfw/Eh/DeCZA5Aun
	74haTTaV28nUcNzSN6MypBK1FG93NBA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-343-H28P7L99OwCFeJyKvSFfZg-1; Fri,
 14 Aug 2026 09:22:42 -0400
X-MC-Unique: H28P7L99OwCFeJyKvSFfZg-1
X-Mimecast-MFC-AGG-ID: H28P7L99OwCFeJyKvSFfZg_1786713761
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AFC97180074B;
	Fri, 14 Aug 2026 13:22:41 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.64.105])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 22FCF195608A;
	Fri, 14 Aug 2026 13:22:41 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Matt Fleming <matt@readmodwrite.com>
Subject: [PATCH v2 1/3] xfs: set minleft correctly for sparse chunk errortag allocation
Date: Fri, 14 Aug 2026 09:22:37 -0400
Message-ID: <20260814132239.271492-2-bfoster@redhat.com>
In-Reply-To: <20260814132239.271492-1-bfoster@redhat.com>
References: <20260814132239.271492-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

The errortag instrumentation for forced sparse chunk allocation
jumps straight to the allocation path without setting args.minleft.
minleft is unconditionally set to ->inobt_maxlevels for the normal
allocation path. Lift the assignment to the initial args setup so
it covers all possible paths.

Assisted-by: LLM
Fixes: 1cdadee11f8d ("xfs: randomly do sparse inode allocations in DEBUG mode")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Mark Tinguely <mark.tinguely@oracle.com>
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

