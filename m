Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60B84534AE
	for <linux-xfs@vger.kernel.org>; Fri, 31 Jul 2026 16:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785515625; cv=none; b=BuplLpKFlcracnY8rJ3jaXEKPeQw1083i38e7R0zTW5mzPLXqF2+bjP8bMY7S40ffyNCh51u5tuja3EYByQeE/NBtjWx0SOF9/Bo99ikh867KxlI+sqW1AIUrwEqKCSSmAD2M2w/aOvACjm/NI5sLEimcJp34VRqBiHgG/HbIfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785515625; c=relaxed/simple;
	bh=kb8Gq2NzoUGVg6SxI/ZvnPcsTumuaCuvWAvSdmNM7B0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HT2iqOb5m521BHQJo7rBQkvqRHYXboHDFld4VZLtAKR13glsitzjWjoh6bCHfbKnKtPAoGensngJoFRhH0PgNOX+AKousMnQahknwfLKgBfNWvk7KobU+/rm37wiI4lQtLVgEsvgyBXFGgqJbCe0JO3xcgCvA1U2z26oNzP7He8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NHMQp7g2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NHMQp7g2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785515622;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aJoDNfi7PbvFAwIZ59jNGUqpCKbrX7nIUyaZT9vjnlM=;
	b=NHMQp7g2mZS+Ij8ID+PIvsTQb+2JFou9ktmm7VKjPtAiajntXb/ERWlW+faKVRZmX7RJ0+
	PRXqac/rawcKJoR0kFw6barQx+c2V0+ALQ5cUtVGhoJzXcs/IM61qWEoCozVD0WvilviIq
	RineQ9aa8dOicOFuzpri7g0mbQHKEMQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-686-aY9mG574PTCm2QSKF6-CgQ-1; Fri,
 31 Jul 2026 12:33:40 -0400
X-MC-Unique: aY9mG574PTCm2QSKF6-CgQ-1
X-Mimecast-MFC-AGG-ID: aY9mG574PTCm2QSKF6-CgQ_1785515620
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 194A51800347;
	Fri, 31 Jul 2026 16:33:40 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.80.193])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9165E30002E9;
	Fri, 31 Jul 2026 16:33:39 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Matt Fleming <matt@readmodwrite.com>
Subject: [PATCH 2/2] xfs: consistent low ag space behavior for sparse inode chunk allocs
Date: Fri, 31 Jul 2026 12:33:37 -0400
Message-ID: <20260731163337.152522-3-bfoster@redhat.com>
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

Matt Fleming reports a filesystem shutdown due to inobt block
allocation failure during sparse chunk allocation. Inode creation
can involve multiple allocations in a transaction via the initial
chunk allocation and inode btree growth via the subsequent inobt
record insertion. Technically this should be safe as the chunk
allocation sets the allocation minleft parameter to the max depth of
the inode btree, which means the allocation selects an AG only if
there is enough free space for record insertion after the
allocation. The record insertion naturally occurs in the same AG as
the allocation and the associated AGF is locked and held by the
current transaction.

The situation that reproduces this failure is a bit of a corner
case. The allocation and inode btrees are all completely full and
require a split on the next insertion. The AG has just enough
available space to satisfy inode creation through sparse allocation
(i.e. 7 blocks in this example). The block allocation occurs within
an existing free space record, splitting the free space record into
two and triggering the aforementioned allocbt splits.

The sparse chunk allocation consumes 4 blocks for the chunk, and 4
blocks from the AGFL for the two allocbt splits. This leaves the
AGFL with 4 remaining blocks and 3 available blocks in the AG. The
record insertion attempts block allocation for the inobt split, but
even though space is available, the geometry change has changed the
minimum allocation requirements enforced by
xfs_alloc_fix_freelist(). The min freelist value jumps from 8 to 12
due to the alloc btree level increases, so the available space
calculation goes from something like this before the allocation:

	free + agfl - res - minfree - minleft = avail
	2514 + 8 - 2505 - 8 - 2 = 7

... to this after it:

	2510 + 4 - 2505 - 12 - 0 = -3

Essentially the minleft value of 2 for the chunk alloc is not
sufficient to overcome the additional requirements imposed on the
subsequent inobt alloc due to the allocbt geometry changes caused by
the first.

Technically this shouldn't be a concern because a full split of any
of the allocation btrees in one transaction means that we're not
going to see another full split in the lifetime of that transaction,
but the allocation path does not behave that way.

Absent of a clear way to lock in the agfl state for the particular
case of multiple allocations into a single AG, this patch works
around the problem by increasing the minleft requirement for sparse
chunk allocations. Specifically, we increase minleft by the number
of blocks that the alloc length was reduced by. The reasoning behind
this is to generally preserve the AG level no space behavior between
full and sparse inode chunk allocations.

The purpose of sparse inode chunks is to facilitate allocation in
AGs under severe free space fragmentation and thus prevent premature
-ENOSPC conditions across the broader fs, not necessarily squeeze
every last block out of any single AG. Therefore, this helps ensure
the low AG space boundary conditions for sparse inode chunks are
relatively well tested compared to full inode chunks.

Fixes: 56d1115c9bc7 ("xfs: allocate sparse inode chunks on full chunk allocation failure")
Reported-by: Matt Fleming <matt@readmodwrite.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 633b2d6e42c5..7e71c33fbefa 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -840,6 +840,14 @@ xfs_ialloc_ag_alloc(
 		args.minlen = igeo->ialloc_min_blks;
 		args.maxlen = args.minlen;
 
+		/*
+		 * Bump minleft by the alloc size delta to maintain consistent
+		 * out of space behavior with normal sized chunks. This isn't a
+		 * requirement, but helps avoid sparse chunk and inobt block
+		 * allocation quirks at or close to AG depletion.
+		 */
+		args.minleft += igeo->ialloc_blks - igeo->ialloc_min_blks;
+
 		/*
 		 * The inode record will be aligned to full chunk size. We must
 		 * prevent sparse allocation from AG boundaries that result in
-- 
2.55.0

