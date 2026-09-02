Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0072336C0C8
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 17:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788370836; cv=none; b=DWPJ9znsRL/xvS5tHX0q+xOVCkUhgzSqWe0ftccfk68CH3XJB1Rw992MKVFtqcv3EvcJEsO99gbA0ZnLI6bwC1YJYqSf+a2sREkMqaI2Al75MgkRgX/OtQX1jB6G+vbyD20K+eQhORBCoyqAreY+4DWO8H7H1cPHELpGPmx/2+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788370836; c=relaxed/simple;
	bh=fjW9AIv0ZlpZ5/erUwKldU8xVWk6jDz8J8Q0V4gfXTw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=alckbM3FtsmWtmwMtk/4K0wiBgfLuCxx5S1POILPHBabMryUE84NiV2sFKsu0USVebjEZvmGnIsrL1cFolUGDNMMh7Ea1IUMoHLR4nP/wJ9UAT2P7nGXIgEKyaZXm734NaZFDK7i1hs4JX8Gc8rt/rhOfFv3qOX5twm84LG8ak8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N9tPnQC1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N9tPnQC1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788370834;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jdmO+snc+Uy1cjCQbvANNzr+/Q9Rw+yjLpQd3RpvCAc=;
	b=N9tPnQC1dpNKK/k9NqVn0v5go5yxlP6+GKnPPLXUImx7JZMFdIKvlxLUur1eX3hKI5NfSJ
	WJyEVMqPAugvsIAWcz9eGtzrfsmiwrzXE1gWHDlBeh4v4cxFpIlhLGeNwIpJv/50YrgHzQ
	ZAReDhlAUG7vf3eE9hlf5NWuGPhFlB4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-629-MhHhIjPsMNij5D544eskoQ-1; Wed,
 02 Sep 2026 13:40:32 -0400
X-MC-Unique: MhHhIjPsMNij5D544eskoQ-1
X-Mimecast-MFC-AGG-ID: MhHhIjPsMNij5D544eskoQ_1788370831
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A5056195DE45
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 17:40:31 +0000 (UTC)
Received: from bfoster (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 460B81800765
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 17:40:31 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH v3 1/4] xfs: set minleft correctly for sparse chunk errortag allocation
Date: Wed,  2 Sep 2026 13:40:22 -0400
Message-ID: <20260902174025.284387-2-bfoster@redhat.com>
In-Reply-To: <20260902174025.284387-1-bfoster@redhat.com>
References: <20260902174025.284387-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

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
index 58dac4d505ba..edcda77b11ac 100644
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

