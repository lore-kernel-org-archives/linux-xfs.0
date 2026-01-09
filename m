Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4193854763
	for <linux-xfs@vger.kernel.org>; Fri,  9 Jan 2026 17:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767980953; cv=none; b=QPOiC3vcYlS5kTUWnFxm4AzqYMF4pRlNUF0IiyL9c4LHz/w7d/BfUbu6gA9qMetTMEV5JJn0GJSfj9YRsDhaAA0rK7jnlXi9FzcQdh0F210omutQSlLsApz1bd0y0PBqaaPMlqzEJUsyNO5tfhbpuBnQT5MgbQyDC6gqZDkwYpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767980953; c=relaxed/simple;
	bh=oHG1dOag0Y1sp028swXHPmwQfCPM3G+HZq2qshlz39I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Jkix+gnlduZJX7+/+yq8joSPiD9Exloccs2ikIzMPbcoC7flxtQB/XtXYnNIMmywxRGPUyNKa3Rx444e1v9D/imScYYSld0Udz6bmsGM+MMaaIkkPC254qgCx3LBR3rqreNOI09sdsjvXH2WNga9yGAHvZHJq4VrHsjFRy/3y5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C/gb2go8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C/gb2go8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767980951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5m9UCf/ZwMyk6gro66kViqJhDy8m7tCsKqGnFbpzlHs=;
	b=C/gb2go8mSzsBUxuoeurfbvQr9xsfQZ87SrnCmiFJkmle2M3s8a5ZSvjdb2t+WX8eVPFig
	QkYJZEIVAYkObLETrA0Ugza45I4iq/+spwygpMpRfL/Fp63nfQSWSmmutmZ1sDBecGIFLv
	PC4hyEE8T6xT1F51albbTrdGIA8+8hQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-263-cCCy3A4KOQWNdGvQheXX0w-1; Fri,
 09 Jan 2026 12:49:08 -0500
X-MC-Unique: cCCy3A4KOQWNdGvQheXX0w-1
X-Mimecast-MFC-AGG-ID: cCCy3A4KOQWNdGvQheXX0w_1767980947
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 25EED1956089;
	Fri,  9 Jan 2026 17:49:07 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.127])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7DFF61955F66;
	Fri,  9 Jan 2026 17:49:06 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: stable@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH v2] xfs: set max_agbno to allow sparse alloc of last full inode chunk
Date: Fri,  9 Jan 2026 12:49:05 -0500
Message-ID: <20260109174905.26372-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Sparse inode cluster allocation sets min/max agbno values to avoid
allocating an inode cluster that might map to an invalid inode
chunk. For example, we can't have an inode record mapped to agbno 0
or that extends past the end of a runt AG of misaligned size.

The initial calculation of max_agbno is unnecessarily conservative,
however. This has triggered a corner case allocation failure where a
small runt AG (i.e. 2063 blocks) is mostly full save for an extent
to the EOFS boundary: [2050,13]. max_agbno is set to 2048 in this
case, which happens to be the offset of the last possible valid
inode chunk in the AG. In practice, we should be able to allocate
the 4-block cluster at agbno 2052 to map to the parent inode record
at agbno 2048, but the max_agbno value precludes it.

Note that this can result in filesystem shutdown via dirty trans
cancel on stable kernels prior to commit 9eb775968b68 ("xfs: walk
all AGs if TRYLOCK passed to xfs_alloc_vextent_iterate_ags") because
the tail AG selection by the allocator sets t_highest_agno on the
transaction. If the inode allocator spins around and finds an inode
chunk with free inodes in an earlier AG, the subsequent dir name
creation path may still fail to allocate due to the AG restriction
and cancel.

To avoid this problem, update the max_agbno calculation to the agbno
prior to the last chunk aligned agbno in the AG. This is not
necessarily the last valid allocation target for a sparse chunk, but
since inode chunks (i.e. records) are chunk aligned and sparse
allocs are cluster sized/aligned, this allows the sb_spino_align
alignment restriction to take over and round down the max effective
agbno to within the last valid inode chunk in the AG.

Note that even though the allocator improvements in the
aforementioned commit seem to avoid this particular dirty trans
cancel situation, the max_agbno logic improvement still applies as
we should be able to allocate from an AG that has been appropriately
selected. The more important target for this patch however are
older/stable kernels prior to this allocator rework/improvement.

Cc: <stable@vger.kernel.org> # v4.2
Fixes: 56d1115c9bc7 ("xfs: allocate sparse inode chunks on full chunk allocation failure")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---

v2:
- Added misc. commit log tags.
v1: https://lore.kernel.org/linux-xfs/20260108141129.7765-1-bfoster@redhat.com/

 fs/xfs/libxfs/xfs_ialloc.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index d97295eaebe6..c19d6d713780 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -848,15 +848,16 @@ xfs_ialloc_ag_alloc(
 		 * invalid inode records, such as records that start at agbno 0
 		 * or extend beyond the AG.
 		 *
-		 * Set min agbno to the first aligned, non-zero agbno and max to
-		 * the last aligned agbno that is at least one full chunk from
-		 * the end of the AG.
+		 * Set min agbno to the first chunk aligned, non-zero agbno and
+		 * max to one less than the last chunk aligned agbno from the
+		 * end of the AG. We subtract 1 from max so that the cluster
+		 * allocation alignment takes over and allows allocation within
+		 * the last full inode chunk in the AG.
 		 */
 		args.min_agbno = args.mp->m_sb.sb_inoalignmt;
 		args.max_agbno = round_down(xfs_ag_block_count(args.mp,
 							pag_agno(pag)),
-					    args.mp->m_sb.sb_inoalignmt) -
-				 igeo->ialloc_blks;
+					    args.mp->m_sb.sb_inoalignmt) - 1;
 
 		error = xfs_alloc_vextent_near_bno(&args,
 				xfs_agbno_to_fsb(pag,
-- 
2.52.0

