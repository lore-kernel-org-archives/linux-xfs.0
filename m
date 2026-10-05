Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC92E4457BC
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 12:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791201685; cv=none; b=kG3CJhBvi/6AsQjFoOl9Wo5m5/fVvzFEucqBTZf4chUtlN0iWvZ0ud6ZiBu1qKnrmQC21pDd5OZuit8GxtBOmiOE1WQSNX/sQMFv1F7w0GHLZBO1jXShHrB5L5jG9bzZoWFcJJ6pFhBM+PZi6veegzeEFf/pFNa9JW4h+yYGT2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791201685; c=relaxed/simple;
	bh=nZjGH5/RZAPFMAiVc07KrnIB5LsAGxKKvLsc3hV0amU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eK05QpPT9gFVgOLMJHh92Uy7zX8BWjbS4sa4rMn6mWrEs7d+TJU6IYAmv8suaz0iKhGJkuBureCZ6fo4beqk2tWEuOQJprXzenYkbDxbcWx8r1u3jBf50OSZBe0OwQpN1c5YxG8A4yZ2CdQ/5tSQlsNnUoWz02vcMP6BcN2FGAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h8RISojl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h8RISojl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791201683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PRkyL84gQgwuP7OjTp+WvlmToqY1TePu1gru9EXR8ts=;
	b=h8RISojleAa5wSh4RDQq49qVYS8Kb25J8EJl3OvF/xROxF2z4/p0frZYD+4MRqqV28/Jpm
	C7CGTYcZxB6GkdtwBzCbV7OSLUK1y8X0Zu8PsCvptmAgNjfy03mzyurWZs1awwqYtv+W+B
	iG39OK+p3Xb4Ba7HecRm4y4oQ4ZUNlI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-41-GZGOWCAUOD-0h4sxBORQ2A-1; Mon,
 05 Oct 2026 08:01:21 -0400
X-MC-Unique: GZGOWCAUOD-0h4sxBORQ2A-1
X-Mimecast-MFC-AGG-ID: GZGOWCAUOD-0h4sxBORQ2A_1791201680
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 803F31944B15;
	Mon,  5 Oct 2026 12:01:20 +0000 (UTC)
Received: from bfoster.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 026B41956087;
	Mon,  5 Oct 2026 12:01:19 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Carlos Maiolino <cem@kernel.org>
Subject: [PATCH v5 1/4] xfs: set minleft correctly for sparse chunk errortag allocation
Date: Mon,  5 Oct 2026 08:01:15 -0400
Message-ID: <20261005120118.229086-2-bfoster@redhat.com>
In-Reply-To: <20261005120118.229086-1-bfoster@redhat.com>
References: <20261005120118.229086-1-bfoster@redhat.com>
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

