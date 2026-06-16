Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7BD3D811A
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2026 18:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633578; cv=none; b=EjjePknnIhCKbh4MgiuMNi3W5NCPB6ldk5mCS3uEtR9mIQoIbFtB1XZKrhwe900Qmtd2cn+aqz/twBGZwDlWplmQjsaDdNQg2mqUWQQC+w4uJoUU8EOmCvO7GeiDNgvXY2osHbJE2ICs+YpSw0Z/TEtfbGY3xjz1pg3WMEvmKPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633578; c=relaxed/simple;
	bh=PCG16QH9SXvo7SBTnRlJeviUr3Olfo/cWsyWR3BBwOg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=ut9RyN4qY+WOFsdbw2OE5uGEAV13lXFHzW2KHBj1dVR8LZJNqDV4ZMNuS7J9MkjnhvSGpru2+K7HrjXW3PXKqja/TpQJbKkkWk3vS0Zm7jhcV5yQsgrH89HhqB3ZzMGWOsVCDz1s4FZcP5y0kruL+rlfxoaLaVc3oG2D2vDtn3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Ym/WyNYc; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Ym/WyNYc"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260616181251epoutp049980aa81b862e6f6cb88676e6fdaf6ba~5oksm_6EC0241702417epoutp04M
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2026 18:12:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260616181251epoutp049980aa81b862e6f6cb88676e6fdaf6ba~5oksm_6EC0241702417epoutp04M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1781633571;
	bh=MpndRBpMyI5U9EEudHFdVv/rcJqw970MDntwpbKeS1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ym/WyNYcz8yJJIptmxBopB2tMpZdMLgoENu4oTNekhADqILw5VVDpdhaJK8q3FqPB
	 9ttoigylwYEHMxYnO4S7jUY0IntALfagi2myOmsZ2GyFPq0iH35ywgA5OQZYTh5Yai
	 9TDHfEwtqOJOSISWRCMCKC2rrOQtltAY19QhJDGU=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260616181250epcas5p293c08eb865b7ba82de75fcaab1e04314~5oksDwgbl1360013600epcas5p29;
	Tue, 16 Jun 2026 18:12:50 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.89]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4gfw814MJZz2SSKX; Tue, 16 Jun
	2026 18:12:49 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260616181248epcas5p21f29457999d850e165fb4030615e5b5f~5okqdS34C2846528465epcas5p2l;
	Tue, 16 Jun 2026 18:12:48 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260616181246epsmtip19678977edbe747a2158d58b11559ea9b~5okoh5avd1046310463epsmtip1J;
	Tue, 16 Jun 2026 18:12:46 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	jack@suse.cz, cem@kernel.org, axboe@kernel.dk, kbusch@kernel.org,
	ritesh.list@gmail.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com, Kanchan Joshi
	<joshi.k@samsung.com>, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v3 4/6] xfs: generic AG set based steering
Date: Tue, 16 Jun 2026 23:35:53 +0530
Message-Id: <20260616180555.33338-5-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260616180555.33338-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260616181248epcas5p21f29457999d850e165fb4030615e5b5f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260616181248epcas5p21f29457999d850e165fb4030615e5b5f
References: <20260616180555.33338-1-joshi.k@samsung.com>
	<CGME20260616181248epcas5p21f29457999d850e165fb4030615e5b5f@epcas5p2.samsung.com>

Improve allocator concurrency and reduce interlaving by introducing
fixed sized AG set.
Use low bits of the inode as a hash to select AG within the AG set.
Overall, a file will try to use the same AG (and contiguity is maintained),
but multiple files will be spread across all AGs in the target AG set.

Suggested-by: Dave Chinner <dgc@kernel.org>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 7a4c8f1aa76c..6685220ec59a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3194,6 +3194,36 @@ xfs_bmap_select_minlen(
 	return args->maxlen;
 }
 
+#define	GENERIC_AG_SET_SZ	(2)
+
+static inline xfs_agnumber_t
+xfs_default_ag_set_size(
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+
+	return min_t(xfs_agnumber_t, GENERIC_AG_SET_SZ, mp->m_sb.sb_agcount);
+}
+
+static xfs_agnumber_t
+xfs_ag_to_ag_set(
+	struct xfs_bmalloca	*ap,
+	xfs_agnumber_t		base_agno)
+{
+	struct xfs_inode	*ip = ap->ip;
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_agnumber_t		set_size;
+
+	/* Apply fanning only for regular file data */
+	if (!(ap->datatype & XFS_ALLOC_USERDATA))
+		return base_agno;
+
+	set_size = xfs_default_ag_set_size(ip);
+	/* Fan out within the AG set using low bits of the inode */
+	return (base_agno + (XFS_INO_TO_AGINO(mp, ip->i_ino) % set_size)) %
+		mp->m_sb.sb_agcount;
+}
+
 static int
 xfs_bmap_btalloc_select_lengths(
 	struct xfs_bmalloca	*ap,
@@ -3589,8 +3619,16 @@ xfs_bmap_btalloc_best_length(
 {
 	xfs_extlen_t		blen = 0;
 	int			error;
+	xfs_agnumber_t		target_ag, start_ag;
 
 	ap->blkno = XFS_INO_TO_FSB(args->mp, ap->ip->i_ino);
+
+	/* fan out initial AG across the generic AG set */
+	start_ag = XFS_FSB_TO_AGNO(args->mp, ap->blkno);
+	target_ag = xfs_ag_to_ag_set(ap, start_ag);
+	if (target_ag != start_ag)
+		ap->blkno = XFS_AGB_TO_FSB(args->mp, target_ag, 0);
+
 	if (!xfs_bmap_adjacent(ap))
 		ap->eof = false;
 
-- 
2.25.1

