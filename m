Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66BB3FBEBC
	for <linux-xfs@vger.kernel.org>; Fri, 17 Jul 2026 12:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784293004; cv=none; b=ozgp4BUvd3xqmO9qFriovUXoR2ZlkvUAaXDID05OBAPxYiYpXMQGMKoHFq14fS8+g2SD/QUaY/iNDCGtY/mqU21pMVGHVzfQS01nl2jipScSNLHJrVw9SdsLK4RwbOLeCoWdGCCQLI/spUOYcQZMQspWlP08OEfLZa6JaNeUEr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784293004; c=relaxed/simple;
	bh=I+unap7eooUVs+bL1pFKGRdcpiEMaQP3tyyFY+nDmuA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=eGoEYrlzHtUbnnJe01WPKAuVHna9iP9IryhlWUkujemOrc8kpLybK8Fj4JKcp49zgCushZsCqv0LVoRXDRt6lmngQJakHr1dldoNcNWBj2iZaxFpNgDWRrSb17lbhNFCICO4dyUYse8mwz9xPxgBVkU12J/6mdIXL7JgUp0PAw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=K3SNmucz; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="K3SNmucz"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260717125640epoutp04819ffee807a7ae31b98cdc61da26a60c~DFQfSoh_S2896028960epoutp04g
	for <linux-xfs@vger.kernel.org>; Fri, 17 Jul 2026 12:56:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260717125640epoutp04819ffee807a7ae31b98cdc61da26a60c~DFQfSoh_S2896028960epoutp04g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1784293000;
	bh=ErRK7449xmsR9DkimUBcG2AGoZldOM7hLKB3BCxLde8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K3SNmuczw+sBjG53zbFcP5BIHVMWS8hb4RDw8s4Bby6NLKcbsDhU0ogpRFHxPJALa
	 Lj3nUxx7/L6l9v/9ik1FKzW2vv5dnakuuxjIz6YGSnfSYM0qGwhHplt40OfysbctkU
	 GM4dEOchucz6+hHCZKJRQEFw4oCt+4hswHlP0HQY=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260717125640epcas5p198dbc1effcf05e448e60e211bf885a58~DFQe3hWWa2976629766epcas5p1E;
	Fri, 17 Jul 2026 12:56:40 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.90]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4h1qfv1xkbz6B9m7; Fri, 17 Jul
	2026 12:56:39 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260717125638epcas5p2fb7128170d2443be3cfe1a7687d0c5fd~DFQdRY8TR1692416924epcas5p2P;
	Fri, 17 Jul 2026 12:56:38 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260717125636epsmtip2c44a26297a4875c91105340b705a5544~DFQbVWAnA1835118351epsmtip2H;
	Fri, 17 Jul 2026 12:56:36 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	jack@suse.cz, cem@kernel.org, axboe@kernel.dk, kbusch@kernel.org,
	ritesh.list@gmail.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v4 5/6] xfs: write stream based AG placement
Date: Fri, 17 Jul 2026 18:25:37 +0530
Message-Id: <20260717125538.508925-6-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260717125538.508925-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260717125638epcas5p2fb7128170d2443be3cfe1a7687d0c5fd
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260717125638epcas5p2fb7128170d2443be3cfe1a7687d0c5fd
References: <20260717125538.508925-1-joshi.k@samsung.com>
	<CGME20260717125638epcas5p2fb7128170d2443be3cfe1a7687d0c5fd@epcas5p2.samsung.com>

When write stream is set on the file, choose the AG set based on the
write stream value.

Isolating distinct write streams into dedicated allocation groups helps
in reducing the block interleaving of concurrent writers. Keeping these
streams spatially separated reduces AGF lock contention and logical file
fragmentation.

If AGs are fewer than write streams, write streams are distributed into
available AGs in round robin fashion.
If not, available AGs are partitioned into write streams. The write-stream
value is used to derive the AG set, and low bits of the inode is used to
select the AG within the AG set.

While each stream provides the isolation, the intra-stream concurrency
comes from the AG set size.

Example: 8 Allocation Groups, 4 write streams
AG set size = 2 AGs per write stream

   Stream 1 (ID: 1)         Stream 2 (ID: 2)         Streams 3 & 4
 +---------+---------+    +---------+---------+    +-------------
 |   AG0   |   AG1   |    |   AG2   |   AG3   |    |  AG4...AG7
 +---------+---------+    +---------+---------+    +-------------
      ^         ^              ^         ^
      |         |              |         |
      | File B (ino: 101)      | File D (ino: 201)
      | 101 % 2 = 1 -> AG 1    | 201 % 2 = 1 -> AG 3
      |                        |
 File A (ino: 100)        File C (ino: 200)
 100 % 2 = 0 -> AG 0      200 % 2 = 0 -> AG 2

If AGs can not be evenly distributed among streams, the last stream will
absorb the remaining AGs.

Note that there are no hard boundaries; write-stream only provides explicit
routing hint to xfs allocator. We still preserve file contiguity, and the
full space can be utilized even with a single stream.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index fd1a3aa4ad3f..872a4abd2315 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3203,6 +3203,38 @@ xfs_default_ag_set_size(
 	return min_t(xfs_agnumber_t, GENERIC_AG_SET_SZ, mp->m_sb.sb_agcount);
 }
 
+static xfs_agnumber_t
+xfs_inode_write_stream_ag_set(
+	struct xfs_inode	*ip,
+	xfs_agnumber_t		*target_agno)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	uint32_t		nr_streams = xfs_inode_max_write_streams(ip);
+	uint32_t		stream_id = ip->i_write_stream;
+	uint32_t		nr_ags = mp->m_sb.sb_agcount;
+	xfs_agnumber_t		set_size;
+
+
+	if (!nr_streams)
+		return xfs_default_ag_set_size(ip);
+
+	stream_id -= 1; /* For 0-based math; stream-ids are 1-based */
+	set_size = nr_ags / nr_streams;
+
+	if (set_size) {
+		*target_agno = stream_id * set_size;
+		/* uneven distribution, last stream will cover extra AGs */
+		if (stream_id == nr_streams - 1)
+			set_size = nr_ags - *target_agno;
+	} else {
+		/* for the case when we have fewer AGs than streams */
+		*target_agno = stream_id % nr_ags;
+		set_size = 1;
+	}
+
+	return set_size;
+}
+
 static xfs_agnumber_t
 xfs_ag_to_ag_set(
 	struct xfs_bmalloca	*ap,
@@ -3216,7 +3248,11 @@ xfs_ag_to_ag_set(
 	if (!(ap->datatype & XFS_ALLOC_USERDATA))
 		return base_agno;
 
-	set_size = xfs_default_ag_set_size(ip);
+	if (ip->i_write_stream)
+		set_size = xfs_inode_write_stream_ag_set(ip, &base_agno);
+	else
+		set_size = xfs_default_ag_set_size(ip);
+
 	/* Fan out within the AG set using low bits of the inode */
 	return (base_agno + (XFS_INO_TO_AGINO(mp, I_INO(ip)) % set_size)) %
 		mp->m_sb.sb_agcount;
-- 
2.25.1

