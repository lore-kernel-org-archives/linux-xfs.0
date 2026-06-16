Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F4E4418F2
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2026 18:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633578; cv=none; b=TgSoZimUJAqGxy1EUkjYUOcvrUZY5sNLjAalgD+/NByt3fTmwwHDMkLbxyu6wFY3f3IH3YnfNV5izEk9heiOJt/G6kpEAJ2vArDrVXi4nx8OHmIW7KLbOC9181iaVa2M3pavvB7sO4B7SdOlrMmy35PZLMBZt5DH28KKnTsyvwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633578; c=relaxed/simple;
	bh=opl3K9v1vkm09yAVNlC61Hcab9DnthyH3nsAj5JNDk0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=m/PSAdB1eOTPXPrt9KtSmpfpbI53obs1X4I11WgvWHAz5uo1qPukylxzld1zh3+SDKpqpybwGqFuECxE/lX29ysgAqkZhUGp35N77iM8ic+UPQbqwzSm58VRGhqywizQfzbq3fRcriiVauLqv5Qr3hBZC6PxmKd6Nz1nulduP9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Fxuh2K+M; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Fxuh2K+M"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260616181253epoutp0468d20880aefaf3e8a5e506844cdc0f83~5okuY8aBm0240002400epoutp04I
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2026 18:12:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260616181253epoutp0468d20880aefaf3e8a5e506844cdc0f83~5okuY8aBm0240002400epoutp04I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1781633573;
	bh=RA7tq76iAUOrV8AB9SfklLAuSTjgayR5/lf3SgdVz0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fxuh2K+McrW0xfRIX7qwNi05ZfI5iX7qSrSBCEDMDL99oGehyNcW5p07oArIyWm87
	 HgCxOY3T21nNRnp3aIw7M4YxE/8oaAbu9kWXlRjVILYiSRXPSyAAV1WoykRygavoke
	 jQupe5M6QoUWgBAdRg0QZxQqOGos6JKTHEUk0XAo=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260616181252epcas5p234d23e014003535276c4c340e6fdeb36~5okt2sBGW3144231442epcas5p2G;
	Tue, 16 Jun 2026 18:12:52 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.86]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4gfw834hMCz2SSKd; Tue, 16 Jun
	2026 18:12:51 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260616181251epcas5p202e6eed05c15258d292f79241b69329d~5oksjXAIt3144231442epcas5p2F;
	Tue, 16 Jun 2026 18:12:51 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260616181249epsmtip1afc4686c902b0d2d705f7a0b4b7d913c~5okqs7sVb1049410494epsmtip1V;
	Tue, 16 Jun 2026 18:12:49 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	jack@suse.cz, cem@kernel.org, axboe@kernel.dk, kbusch@kernel.org,
	ritesh.list@gmail.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: [PATCH v3 5/6] xfs: write stream based AG placement
Date: Tue, 16 Jun 2026 23:35:54 +0530
Message-Id: <20260616180555.33338-6-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260616180555.33338-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260616181251epcas5p202e6eed05c15258d292f79241b69329d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260616181251epcas5p202e6eed05c15258d292f79241b69329d
References: <20260616180555.33338-1-joshi.k@samsung.com>
	<CGME20260616181251epcas5p202e6eed05c15258d292f79241b69329d@epcas5p2.samsung.com>

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
derive the AG within the AG set.

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

Note that there are no hard boundaries; this only provides explicit
routing hint to xfs allocator. We still preserve file contiguity, and the
full space can be utilized even with a single stream.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6685220ec59a..325987b5bd9e 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3205,6 +3205,38 @@ xfs_default_ag_set_size(
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
+		/* unven distribution, last stream will cover extra AGs */
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
@@ -3218,7 +3250,11 @@ xfs_ag_to_ag_set(
 	if (!(ap->datatype & XFS_ALLOC_USERDATA))
 		return base_agno;
 
-	set_size = xfs_default_ag_set_size(ip);
+	if (ip->i_write_stream)
+		set_size = xfs_inode_write_stream_ag_set(ip, &base_agno);
+	else
+		set_size = xfs_default_ag_set_size(ip);
+
 	/* Fan out within the AG set using low bits of the inode */
 	return (base_agno + (XFS_INO_TO_AGINO(mp, ip->i_ino) % set_size)) %
 		mp->m_sb.sb_agcount;
-- 
2.25.1

