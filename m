Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B44348D896
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 09:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789983166; cv=none; b=g18jHQvpEszwF1FFkNrSRDjtQ9bBd5ZPZ0grphu10zqvLGfuaOgiFA2ASUcn3GzSs6VQjKw9GXnIHuFzRdEKMzIxwrplKhjJq72fudJDfPieHw5VrdoPzxUwJXcEUgvf0FAnU+9zKbGWCa+GFhp6bhxV8IOtTHnE0nSrmcTiYcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789983166; c=relaxed/simple;
	bh=FpNLCZP4lZe3QtFGJyreBlxYDKkDw47T/M3/440hVxk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=HtmMSbUYCUdaEWunIfJW+ubtgeirqJkr/hzi1iHiO0m1A8EuYTPE6YbD7nv3edQ+E5dXKgy3caDSCLmi0w6iGkUG+APU+SnGF56caiM/JzDDcW9d0aWd36Vqi9CNb2sqb4ROfp1uGOZYYeeILB2+d4mHpmTg6XEULwcdrXAVww4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=QDvtXIGA; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="QDvtXIGA"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260921093241epoutp038c4b91429a0dc07fa66ac772e528b059~XTDO7BeXU0785307853epoutp03F
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 09:32:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260921093241epoutp038c4b91429a0dc07fa66ac772e528b059~XTDO7BeXU0785307853epoutp03F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1789983162;
	bh=FtfffXXIc9fyrVF3M2KDX5/338uskPeDxsruvp6EmXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QDvtXIGAxHTR0xeKc+2qwajFy+PONZxO/Rzx4HxI3Hp0hs9NzuWsiDs7t7zM6I5nF
	 LuhXMCqUxMfNBIW5KaB2VRgK0HuXYAROg5fcYlpSXjTdnhzFKEhOfmYK3xymAm5FFQ
	 5w/fGEdDxPzROvTTBXCkP6c2vcndQsd7YYjzC7Mg=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260921093241epcas5p222048a09f88909db12673d22637113c6~XTDOfMl-Y0340403404epcas5p2W;
	Mon, 21 Sep 2026 09:32:41 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.95]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4hpJ1452Lrz6B9m4; Mon, 21 Sep
	2026 09:32:40 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260921093240epcas5p1e7ab52aa9ba37ae7054d8f4d60f0a38d~XTDNGpnxw3091630916epcas5p17;
	Mon, 21 Sep 2026 09:32:40 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260921093238epsmtip1bc375db8cb87a4a850f3bd90d10f23d4~XTDLavaVn0528305283epsmtip1E;
	Mon, 21 Sep 2026 09:32:38 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	cem@kernel.org, jack@suse.cz, axboe@kernel.dk, kbusch@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com, Kanchan Joshi <joshi.k@samsung.com>, Anuj Gupta
	<anuj20.g@samsung.com>
Subject: [PATCH v5 5/8] xfs: write stream based AG placement
Date: Mon, 21 Sep 2026 15:01:44 +0530
Message-Id: <20260921093147.59935-6-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260921093147.59935-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260921093240epcas5p1e7ab52aa9ba37ae7054d8f4d60f0a38d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260921093240epcas5p1e7ab52aa9ba37ae7054d8f4d60f0a38d
References: <20260921093147.59935-1-joshi.k@samsung.com>
	<CGME20260921093240epcas5p1e7ab52aa9ba37ae7054d8f4d60f0a38d@epcas5p1.samsung.com>

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
 fs/xfs/libxfs/xfs_bmap.c | 58 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 56 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index d64defeda645..2e83811cefcb 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3579,8 +3579,31 @@ xfs_bmap_btalloc_filestreams(
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
+
+	stream_id -= 1;	/* convert from 1-based to 0-based */
+	ag_set_size = nr_ags / nr_streams;
+	start_agno = stream_id * ag_set_size;
+
+	/* last stream absorbs any uneven remainder */
+	if (stream_id == nr_streams - 1)
+		ag_set_size = nr_ags - start_agno;
+
+	return start_agno + I_INO(ip) % ag_set_size;
+}
+
+/* Core AG allocator.  The caller sets ap->blkno to the target AG start. */
 static int
-xfs_bmap_btalloc_best_length(
+xfs_bmap_btalloc_from_blkno(
 	struct xfs_bmalloca	*ap,
 	struct xfs_alloc_arg	*args,
 	int			stripe_align)
@@ -3588,7 +3611,6 @@ xfs_bmap_btalloc_best_length(
 	xfs_extlen_t		blen = 0;
 	int			error;
 
-	ap->blkno = XFS_INODE_TO_FSB(ap->ip);
 	if (!xfs_bmap_adjacent(ap))
 		ap->eof = false;
 
@@ -3621,6 +3643,32 @@ xfs_bmap_btalloc_best_length(
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
@@ -3640,6 +3688,7 @@ xfs_bmap_btalloc(
 	};
 	xfs_fileoff_t		orig_offset;
 	xfs_extlen_t		orig_length;
+	unsigned int		stream_id;
 	int			error;
 	int			stripe_align;
 
@@ -3652,11 +3701,16 @@ xfs_bmap_btalloc(
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

