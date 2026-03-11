Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31BDE346FB7
	for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2026 16:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773246309; cv=none; b=H1CJyaFCVoGe6MMPxxr1E7aRqLMP/B43Hfp8pn07tQvS6sYNdmXQo/bHRkT6XlrV1qP4QQhrE73MG+DOA4vIj0z93rGl4u/7AuAGCY/mdX0uk26ohefli3j/bG7j0v+fG5QwHpb0Td7kIhD2qfjn5LfO/nVUrhGOmRxgiMqpAQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773246309; c=relaxed/simple;
	bh=2wfNWKfssWe6Ruk5DTUTQbQR/y7zGDzVeSmdBgemYd4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O7EK3oSXb/Sha6LdstbFKZ82Y+dbkr3ycgHxKl3O8q6jFu2HYlwseBE3vEfCuo2NN+LGpCot1EKrDHCDHVAYARKz2B7FM6HmDj+BP2G6GRXYG526tmsVuDFd7ChPHR812i8nDrEz+hFOrazfINqvccvM0kWfYCT0Ec4Ru79MHZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PXZs05LQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PXZs05LQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773246307;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FsnLdIFK+u1btiDHUGzTcKFbMBFdrj2IeOkIfKRdlm4=;
	b=PXZs05LQ4J/kwSUmvOi22NB1JJ+RcZ+zg6tMr7zQZ3sq7pvfN62OXNfzq4W2z51mKj6t2f
	POTG6/PNfgnQZJ3rZrJewge2/K3PWGX3Ay7mWOzL6aNsfFYl8BU6NiRHMBV36ctnmTOQ7K
	fCInnHz0rkArIpTG/RJwadGm6YyMX4Y=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-610-iMUFvDFlNaiWzJOV1Qh9yQ-1; Wed,
 11 Mar 2026 12:25:06 -0400
X-MC-Unique: iMUFvDFlNaiWzJOV1Qh9yQ-1
X-Mimecast-MFC-AGG-ID: iMUFvDFlNaiWzJOV1Qh9yQ_1773246305
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 271AA1956051;
	Wed, 11 Mar 2026 16:25:05 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.89.107])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9BB59180035F;
	Wed, 11 Mar 2026 16:25:04 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v4 2/8] xfs: flush dirty pagecache over hole in zoned mode zero range
Date: Wed, 11 Mar 2026 12:24:56 -0400
Message-ID: <20260311162502.192375-3-bfoster@redhat.com>
In-Reply-To: <20260311162502.192375-1-bfoster@redhat.com>
References: <20260311162502.192375-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

For zoned filesystems a window exists between the first write to a
sparse range (i.e. data fork hole) and writeback completion where we
might spuriously observe holes in both the COW and data forks. This
occurs because a buffered write populates the COW fork with
delalloc, writeback submission removes the COW fork delalloc blocks
and unlocks the inode, and then writeback completion remaps the
physically allocated blocks into the data fork. If a zero range
operation does a lookup during this window where both forks show a
hole, it incorrectly reports a hole mapping for a range that
contains data.

This currently works because iomap checks for dirty pagecache over
holes and unwritten mappings. If found, it flushes and retries the
lookup. We plan to remove the hole flush logic from iomap, however,
so lift the flush into xfs_zoned_buffered_write_iomap_begin() to
preserve behavior and document the purpose for it. Zoned XFS
filesystems don't support unwritten extents, so if zoned mode can
come up with a way to close this transient hole window in the
future, this flush can likely be removed.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 8c3469d2c73e..d3b8c018c883 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1590,6 +1590,7 @@ xfs_zoned_buffered_write_iomap_begin(
 {
 	struct iomap_iter	*iter =
 		container_of(iomap, struct iomap_iter, iomap);
+	struct address_space	*mapping = inode->i_mapping;
 	struct xfs_zone_alloc_ctx *ac = iter->private;
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
@@ -1614,6 +1615,7 @@ xfs_zoned_buffered_write_iomap_begin(
 	if (error)
 		return error;
 
+restart:
 	error = xfs_ilock_for_iomap(ip, flags, &lockmode);
 	if (error)
 		return error;
@@ -1686,8 +1688,25 @@ xfs_zoned_buffered_write_iomap_begin(
 	 * When zeroing, don't allocate blocks for holes as they are already
 	 * zeroes, but we need to ensure that no extents exist in both the data
 	 * and COW fork to ensure this really is a hole.
+	 *
+	 * A window exists where we might observe a hole in both forks with
+	 * valid data in cache. Writeback removes the COW fork blocks on
+	 * submission but doesn't remap into the data fork until completion. If
+	 * the data fork was previously a hole, we'll fail to zero. Until we
+	 * find a way to avoid this transient state, check for dirty pagecache
+	 * and flush to wait on blocks to land in the data fork.
 	 */
 	if ((flags & IOMAP_ZERO) && srcmap->type == IOMAP_HOLE) {
+		if (filemap_range_needs_writeback(mapping, offset,
+				offset + count - 1)) {
+			xfs_iunlock(ip, lockmode);
+			error = filemap_write_and_wait_range(mapping, offset,
+					offset + count - 1);
+			if (error)
+				return error;
+			goto restart;
+		}
+
 		xfs_hole_to_iomap(ip, iomap, offset_fsb, end_fsb);
 		goto out_unlock;
 	}
-- 
2.52.0

