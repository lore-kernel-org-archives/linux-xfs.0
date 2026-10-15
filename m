Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34F7414428
	for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2026 06:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792046082; cv=none; b=WpjMvwXPVA7up80w2FilfN0ONUlAkEjHznoZzKjd/pCktKvUjHdkyyR1z1xg+08VPq0NR0/z+qrhOOzXN+65YoyD8uCMNAWRyMvy6s8jfOKVMKTltnPzT9tpV4f7D4sBrZHg6Ywej/+/vm3jDw0RXDw3tyu5tdc4QQbVtMn/rhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792046082; c=relaxed/simple;
	bh=puuBnkxbtBb31wefiUV64lr49mzFdTEJyT6rI0HIXKA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=npwdTowkcLWiiRANn453ctFwZhSaA2meidzJV475xmPNmly9e8IcqQBtlC1a1Ym3l2tYZgbD9m/cViLxHDsSZKLkCKeIyFcyq4pAdSOloO3DwhF5oKDka3AK5wcWGgwQ2A9w0vXF1vhrwZ9vSppKPznKA1Al5JwXakQo1q49zBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=YdIaRr4d; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="YdIaRr4d"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20261015063438epoutp03c7e916aacf67959fde541e5304b817dc~eoGoDVBz02401824018epoutp03a
	for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2026 06:34:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20261015063438epoutp03c7e916aacf67959fde541e5304b817dc~eoGoDVBz02401824018epoutp03a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1792046078;
	bh=2GsYvQ/6JgKTg9lFSU3ngilOi6d/uCaDwgC4qri72cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YdIaRr4dFZjTOcQRsfcwPotE8jX/EysTHtqtDUwaVtcQWB6Z4/BteRIud7Pf89AIC
	 FPIVwDH1kFg/Iz5JtHacqWlnqM+dWf5F5XLYmxK5ti0GpacpjL3WlNU7P+xrCzBXld
	 YZnano2tZG43egAMFrtuN6RXSlfk5cXO+uYFxfhA=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20261015063438epcas5p1add5f0c69b643592231430302a0a83f5~eoGnloZyb3135831358epcas5p1y;
	Thu, 15 Oct 2026 06:34:38 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.91]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4j4ywY4zTDz6B9m6; Thu, 15 Oct
	2026 06:34:37 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20261015063437epcas5p33408b76d2c2b7bbf1ceaf91b89343703~eoGmdjKeB2932029320epcas5p3R;
	Thu, 15 Oct 2026 06:34:37 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261015063435epsmtip190e23e6e9ee3bb6ad2ddb7f888789b72~eoGkgSm7S1270712707epsmtip10;
	Thu, 15 Oct 2026 06:34:34 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	cem@kernel.org, jack@suse.cz, axboe@kernel.dk, kbusch@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com, Kanchan Joshi <joshi.k@samsung.com>, Anuj Gupta
	<anuj20.g@samsung.com>
Subject: [PATCH v6 5/8] xfs: write stream based AG placement
Date: Thu, 15 Oct 2026 12:02:43 +0530
Message-Id: <20261015063246.103433-6-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261015063246.103433-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20261015063437epcas5p33408b76d2c2b7bbf1ceaf91b89343703
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261015063437epcas5p33408b76d2c2b7bbf1ceaf91b89343703
References: <20261015063246.103433-1-joshi.k@samsung.com>
	<CGME20261015063437epcas5p33408b76d2c2b7bbf1ceaf91b89343703@epcas5p3.samsung.com>

Choose the starting AG from the write stream set on the file.

Isolating streams into separate allocation groups reduces block
interleaving between concurrent writers, AGF lock contention and logical
file fragmentation.

AGs are partitioned among the streams. The stream value selects the AG
set and the inode number selects the AG within it, so intra-stream
concurrency comes from the AG set size.

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

If the AGs do not divide evenly, the last stream absorbs the remainder.

Set boundaries are a hint, not a partition: file contiguity is preserved
and the full space stays usable with a single stream.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 59 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 57 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index d64defeda645..cb1c2e5496e6 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3579,8 +3579,32 @@ xfs_bmap_btalloc_filestreams(
 	return xfs_bmap_btalloc_low_space(ap, args);
 }
 
+static xfs_agnumber_t
+xfs_bmap_write_stream_agno(
+	struct xfs_inode	*ip,
+	unsigned int		stream_id)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_agnumber_t		nr_ags = mp->m_sb.sb_agcount;
+	unsigned int		nr_streams =
+		write_stream_pool_count(&mp->m_ddev_targp->bt_stream_pool);
+	xfs_agnumber_t		ag_set_size, start_agno;
+	xfs_ino_t		ino = I_INO(ip);
+
+	stream_id -= 1;	/* convert from 1-based to 0-based */
+	ag_set_size = nr_ags / nr_streams;
+	start_agno = stream_id * ag_set_size;
+
+	/* last stream absorbs any uneven remainder */
+	if (stream_id == nr_streams - 1)
+		ag_set_size = nr_ags - start_agno;
+
+	return start_agno + do_div(ino, ag_set_size);
+}
+
+/* Core AG allocator.  The caller sets ap->blkno to the target AG start. */
 static int
-xfs_bmap_btalloc_best_length(
+xfs_bmap_btalloc_from_blkno(
 	struct xfs_bmalloca	*ap,
 	struct xfs_alloc_arg	*args,
 	int			stripe_align)
@@ -3588,7 +3612,6 @@ xfs_bmap_btalloc_best_length(
 	xfs_extlen_t		blen = 0;
 	int			error;
 
-	ap->blkno = XFS_INODE_TO_FSB(ap->ip);
 	if (!xfs_bmap_adjacent(ap))
 		ap->eof = false;
 
@@ -3621,6 +3644,32 @@ xfs_bmap_btalloc_best_length(
 	return xfs_bmap_btalloc_low_space(ap, args);
 }
 
+/* Start a write-stream file in the AG set that backs its stream. */
+static int
+xfs_bmap_btalloc_write_stream(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args,
+	int			stripe_align,
+	unsigned int		stream_id)
+{
+	struct xfs_mount	*mp = ap->ip->i_mount;
+	xfs_agnumber_t		agno;
+
+	agno = xfs_bmap_write_stream_agno(ap->ip, stream_id);
+	ap->blkno = XFS_AGB_TO_FSB(mp, agno, 0);
+	return xfs_bmap_btalloc_from_blkno(ap, args, stripe_align);
+}
+
+static int
+xfs_bmap_btalloc_best_length(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args,
+	int			stripe_align)
+{
+	ap->blkno = XFS_INODE_TO_FSB(ap->ip);
+	return xfs_bmap_btalloc_from_blkno(ap, args, stripe_align);
+}
+
 static int
 xfs_bmap_btalloc(
 	struct xfs_bmalloca	*ap)
@@ -3640,6 +3689,7 @@ xfs_bmap_btalloc(
 	};
 	xfs_fileoff_t		orig_offset;
 	xfs_extlen_t		orig_length;
+	unsigned int		stream_id;
 	int			error;
 	int			stripe_align;
 
@@ -3652,11 +3702,16 @@ xfs_bmap_btalloc(
 	/* Trim the allocation back to the maximum an AG can fit. */
 	args.maxlen = min(ap->length, mp->m_ag_max_usable);
 
+	stream_id = READ_ONCE(VFS_I(ap->ip)->i_write_stream);
+
 	if (unlikely(XFS_TEST_ERROR(mp, XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
 		error = xfs_bmap_exact_minlen_extent_alloc(ap, &args);
 	else if ((ap->datatype & XFS_ALLOC_USERDATA) &&
 			xfs_inode_is_filestream(ap->ip))
 		error = xfs_bmap_btalloc_filestreams(ap, &args, stripe_align);
+	else if ((ap->datatype & XFS_ALLOC_USERDATA) && stream_id)
+		error = xfs_bmap_btalloc_write_stream(ap, &args, stripe_align,
+				stream_id);
 	else
 		error = xfs_bmap_btalloc_best_length(ap, &args, stripe_align);
 	if (error)
-- 
2.25.1

