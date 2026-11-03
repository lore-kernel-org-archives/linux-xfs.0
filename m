Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.24
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793705714;
	b=HH/t2PlS0H/7zxVR4By839MJNCJF1f9xhzC0Pmyi31a3OnrKgB+xysYBaQyKIPzEDaHl
	 G85mSjIRf0/j9GbuzMT3F4QYp1B+SQ5y5LgsgWARstNO/g2jPCbS0lTt7TnspR5z71QLs
	 DLiAifYaEPwXWL1Fzke9O6Uy0xAgEoqoV6R4vmwDQP+fzMXLswEfd42b3vBx+QY2TECA/
	 BXCbxya+NY9A5SNhOO1KrvHZ7r7Mkd3dnA7SqJTgHngi+djn0lb8A5rhhh3nmz3XqTlhC
	 +7XYn/PZCnaTHC9AxT9Y+5tjbj31hMUAx3GU5Xap8XlzkSB7nXTfDDjvWg/BwNYOe0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793705714;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:cpgsPolicy:
	 X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=WA2ijIyP6bOHb/76Y8AimxUfHW+2pPTSSiCOBudYjJ8=;
	b=cHWRSPtkIa7WV4DndnS5FjUnlEdS4GQ46g2dmXW2PNnbRrN6QBPCpHPNzeOxvrFu69aC
	 f9NMAEZBEuS3sMeiLYxt8Kl8y7op4ER+4OavgEWpPLpitPKmDQhdm+Dvk3p4/JgSVb6GB
	 Ewbl6oe4a9eUTlqJjo/cW4wMihtwVSTZj7rnVVdtKU8+eS8hBecKqXqQEQrs2QZJAxeyQ
	 VYrJCDkNit91k7Ish/RAUrIgploqjkhseqgePe2U5X22keMPeAKqYY2y3WKlY2UTVsWln
	 JvLgrxSUD902+Gctwhw7SMxEpKN+TzdaqUgKTvVRkrtgNcIlIb67nkXA1ODZmC/HZrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=Fdv24U1E;
	arc=none smtp.remote-ip=203.254.224.24
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597AE606A32F
	for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2026 11:35:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 597AE606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=Fdv24U1E
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261103113510epoutp01fd993bad0deeae534be1d8ca8eeaed11~khdchnTNS2844728447epoutp019
	for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2026 11:35:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261103113510epoutp01fd993bad0deeae534be1d8ca8eeaed11~khdchnTNS2844728447epoutp019
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793705710;
	bh=WA2ijIyP6bOHb/76Y8AimxUfHW+2pPTSSiCOBudYjJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fdv24U1EFCLU+pUaxBMruBhY5Z6AiLLy6NkN4TN2FZp+7O/0pIZPEKD0xm+7AYrGs
	 r/YmZ45u9E96zyX9TvhjE02hQrpeNDP7tJ2jvYneKQQZ8jeINjnqtzLJokFVl6Il+N
	 d4LHJvlugfDNJqW8cFWVgvA3MxK7a5Pel2ZBmmck=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20261103113509epcas5p2ca8e4193da15af04b230032f4b535a8d~khdbe4P932045420454epcas5p2D;
	Tue,  3 Nov 2026 11:35:09 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.94]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4jJmhX5dGGz6B9m5; Tue,  3 Nov
	2026 11:35:08 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20261103111033epcas5p11be538e916933cdb3f12fe8c13250b91~khH9Bj0Jh2741327413epcas5p15;
	Tue,  3 Nov 2026 11:10:33 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261103111031epsmtip12bfee54dc652dd556d9750963917564f~khH7Uk7L72910629106epsmtip1M;
	Tue,  3 Nov 2026 11:10:31 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	cem@kernel.org, jack@suse.cz, axboe@kernel.dk, kbusch@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v7 5/8] xfs: write stream based AG placement
Date: Tue,  3 Nov 2026 16:36:37 +0530
Message-Id: <20261103110640.1000095-6-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261103110640.1000095-1-anuj20.g@samsung.com>
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
X-CMS-MailID: 20261103111033epcas5p11be538e916933cdb3f12fe8c13250b91
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261103111033epcas5p11be538e916933cdb3f12fe8c13250b91
References: <20261103110640.1000095-1-anuj20.g@samsung.com>
	<CGME20261103111033epcas5p11be538e916933cdb3f12fe8c13250b91@epcas5p1.samsung.com>

From: Kanchan Joshi <joshi.k@samsung.com>

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
index ca49bf4a50c5..9d8c9d9945a0 100644
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
 
@@ -3623,6 +3646,32 @@ xfs_bmap_btalloc_best_length(
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
@@ -3642,6 +3691,7 @@ xfs_bmap_btalloc(
 	};
 	xfs_fileoff_t		orig_offset;
 	xfs_extlen_t		orig_length;
+	unsigned int		stream_id;
 	int			error;
 	int			stripe_align;
 
@@ -3654,11 +3704,16 @@ xfs_bmap_btalloc(
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

