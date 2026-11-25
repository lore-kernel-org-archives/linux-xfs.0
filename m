Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.24
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795595748;
	b=gInx2OVp0hmvA7QFh0mv0k+lHHBuDnED8L5J4ucQW0uULXGeN2iew9cbULT09VAiZ6/B
	 oNug2eqXmAmo2+FRoXrI8bFUK8hqOCIjp3QK4rjOCOAPzf+i+4s/J66YqSZnzJyj57msc
	 7t5TC3ZA/G9S9qL2FhEzjyhdBz7x6QCYAbOxC77y4E3xIbe38uFi3Mrw94A/LQIWICUri
	 eWlYQ+7m1ua3mydmZu3cNPyXgyNqTSQV50lRuTYAekUg0RAyNpN8P1sRcI9V/HGzqAHl0
	 Kd1ExLSqTsTam5X6sGzFStcVfZJknaXivJCci/CI5oZrraFuklYX5hWSX2EJgyG98aQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795595748;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:CMS-TYPE:cpgsPolicy:X-CFilter-Loop:
	 X-CMS-RootMailID:References;
	bh=VD0MaCX5qCS0c6FTcnTGwd1uejLs02oe5yx0DLfxt7k=;
	b=1TTiM1wMj0g2FJ2aTBrugbQvdoHFgUKUvXWBcm9Bqfy8B2JFhfD/Z7i3C8LZhF9cfQ7Y
	 QezI8Jdn8trUctK4mU2DVOSIltKOIpEdD4ZS9VL1lyIAaQHSmCxHB5S25+aRdfL0RbaZF
	 rkHzLwqPzqwdxmpze6E1iwsNJPfiX3eUMKcqRASRqT/oFuKG0puzUboiSwGboLj4Nvojs
	 MtIeI2lYle0Lun396fKh2GmFs4KolcgsdOVdpOQ2tD7SZuXP1Vwip/2NHuDJiIoI7GdDE
	 PoNUXQVbWbf1ygoCUr2SVjTKTwjw2AsTunaWIZYsXg++jN4lyKF19INgm6H+/icEVCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=BmIx7qgr;
	arc=none smtp.remote-ip=203.254.224.24
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1F4606A33A
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 08:35:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C1F4606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=BmIx7qgr
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261125083545epoutp01c4920bc81f5e49633b3d06e32f31629e~rPNE7TRnZ2243022430epoutp010
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 08:35:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261125083545epoutp01c4920bc81f5e49633b3d06e32f31629e~rPNE7TRnZ2243022430epoutp010
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1795595745;
	bh=VD0MaCX5qCS0c6FTcnTGwd1uejLs02oe5yx0DLfxt7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BmIx7qgrVBv2NIgKMe+ZRGyTAmSnWMPrDTsXmoTN/+NXMqaiFmlnhpK65J6nvTPeE
	 IBMRPMNE9TNVsUeooPV0i+PpNOc9/IWgb316y1B1RJkKRYCOlQgDGxbXQMS7n4dukJ
	 t6OmN56RIaP6tggxrNo1ItGOhBB8EKjxiauj9Uvc=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20261125083545epcas5p316905bf12dc930bbda30c768a8af25fb~rPNEZcFJc1807418074epcas5p3q;
	Wed, 25 Nov 2026 08:35:45 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.91]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4jZCgN2qr0z6B9mB; Wed, 25 Nov
	2026 08:35:44 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20261125083543epcas5p3651b8d3382124d6bac6917cb989790b2~rPNDAf89l1828118281epcas5p3b;
	Wed, 25 Nov 2026 08:35:43 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261125083542epsmtip15a797c73970a56f0640edb2b39b04fbb~rPNBfxR9i0486404864epsmtip1E;
	Wed, 25 Nov 2026 08:35:41 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	cem@kernel.org, jack@suse.cz, hans.holmberg@wdc.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	anuj20.g@samsung.com, gost.dev@samsung.com, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v8 6/9] xfs: write stream based AG placement
Date: Wed, 25 Nov 2026 14:03:10 +0530
Message-Id: <20261125083313.106334-7-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261125083313.106334-1-joshi.k@samsung.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20261125083543epcas5p3651b8d3382124d6bac6917cb989790b2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261125083543epcas5p3651b8d3382124d6bac6917cb989790b2
References: <20261125083313.106334-1-joshi.k@samsung.com>
	<CGME20261125083543epcas5p3651b8d3382124d6bac6917cb989790b2@epcas5p3.samsung.com>

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
 fs/xfs/libxfs/xfs_bmap.c | 61 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 59 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index ca49bf4a50c5..94a7ceb9c2f6 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3581,8 +3581,32 @@ xfs_bmap_btalloc_filestreams(
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
@@ -3590,7 +3614,6 @@ xfs_bmap_btalloc_best_length(
 	xfs_extlen_t		blen = 0;
 	int			error;
 
-	ap->blkno = XFS_INODE_TO_FSB(ap->ip);
 	if (!xfs_bmap_adjacent(ap))
 		ap->eof = false;
 
@@ -3623,6 +3646,34 @@ xfs_bmap_btalloc_best_length(
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
+	/* the stream picks the AG; don't let the inode32 rotor override it */
+	args->datatype &= ~XFS_ALLOC_INITIAL_USER_DATA;
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
@@ -3642,6 +3693,7 @@ xfs_bmap_btalloc(
 	};
 	xfs_fileoff_t		orig_offset;
 	xfs_extlen_t		orig_length;
+	unsigned int		stream_id;
 	int			error;
 	int			stripe_align;
 
@@ -3654,11 +3706,16 @@ xfs_bmap_btalloc(
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

