Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709CB221DB5
	for <linux-xfs@vger.kernel.org>; Mon, 20 Oct 2025 14:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760971448; cv=none; b=lep0m1XhGcwQ8TOlkXcoYDz+V582rOb9UZzsBT8LJts3om7eN/k190zZFEB3fKbf/r/uYm1CwaVOj249UiJ3p6vN1Ct1JZJgY1+bdzigF2k6k8nLR1pZOymYVfYbru/bcujVgLs0oPRaIiLAwgWY7a8dBUBA6xf4De3g+HyzUq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760971448; c=relaxed/simple;
	bh=872wLbfLIOZNtc0JKr7d8Bd+loImqIh6j3Clw2RkwUI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=f3dN+VyTYbevL680KX1yJQYwCAjapPILeFBaSUh15la+MTqjeEsMvAV0X7bKEfeq14KXIdSPe/rIMu1NKFzKYIuV5kQgU/5dHmndw+zWdr5jX+9iNryxa6mXoTFSW6zi8DRb6GCxTqVpeOM8cZmD5yhaWVYtbzhVEwy0bSZBATA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=u/O1tcq5; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="u/O1tcq5"
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59K4gjPr133176
	for <linux-xfs@vger.kernel.org>; Mon, 20 Oct 2025 07:44:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=boUu/SItvCmZ/jzUks
	WjdxDApfmEE/SJt+Q+Lyv1olk=; b=u/O1tcq52F0Az2rwOTPfTSxpuoAQ7TlYJ+
	3Jk0S8S1zmwjUauW8vFs6TX3WpP2RpRFTkWNLzA92oZB1LonCxcvUA6GAK2Kee6R
	q88z8VAQZyqlXRW+oyjhbdbSbiI1qzvshMSPH8fwGmJ63iTkA5rERYvRLXkUwS3S
	2fmk44BC3u0Uwq8FdHHML6+G23fwgekO/ZqAsKgUaQBVpqg1nma60gd/XZn2OFmZ
	lm9/+Epg4J50C49W2j8Yjyboaxe3cxc+JLAAljt/BWD0ObZHZ0qZuvH64dXU8I+a
	GrW0IIy0y10aQsXPLn8Az6RYhNxKl2t8rJ3HML0WUSYF3jDpS2pQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49we9xamrb-8
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Mon, 20 Oct 2025 07:44:06 -0700 (PDT)
Received: from twshared10560.01.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Mon, 20 Oct 2025 14:43:59 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id F01072E64BDA; Mon, 20 Oct 2025 07:43:56 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <dsterba@suse.com>, <cem@kernel.org>, <linux-btrfs@vger.kernel.org>,
        <linux-xfs@vger.kernel.org>, <hch@lst.de>
CC: Keith Busch <kbusch@kernel.org>, Chris Mason <clm@fb.com>
Subject: [PATCH 1/2] xfs: handle bio split errors during gc
Date: Mon, 20 Oct 2025 07:43:55 -0700
Message-ID: <20251020144356.693288-1-kbusch@meta.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: vxvX7kn5_U3YwBI8js7z0xkqCJVeQw4o
X-Authority-Analysis: v=2.4 cv=UoJu9uwB c=1 sm=1 tr=0 ts=68f64ab6 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=FOH2dFAWAAAA:8
 a=zgweXSLHRC2n6cIoVi8A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIwMDEyMiBTYWx0ZWRfX3RCvSVjPQEVS
 iSvnD0rhpqblfWGIvUV3ksJYDtaCR0e+0gP09TNXBre3l+uwjJWZCXHa05zHVfWOXcyf97vtI7j
 AIhBFAQ/qt1IjoVN5PjK4cE0KSgIvD71I2/9CGM81nbp0EuJH1xR2G8BEASOhgQkL+vYxS0kfy8
 U2i5RRwPKwZt8veAruKSgEYzYm8G3kZKCCO7IuJYGVTrhpFwOOxDweT9cbZ0bXJDMVa7NXURqKu
 LrwwomNjbMBkn/M8wEB25OU5/8p0WvPy6NJnN0tXawcLlsQTIcr44K9VQ8tqbfHy6ugu0vBtvs6
 1xiVac3DMRPJzUIrRG+xYJEOPx+5Fv3FAIop0tanlwZIt3vUiD59DXHu14YVpAQ0V9qZYLitTwi
 yIDcX802MX/XsXTzTl3KdSZJKwUJZA==
X-Proofpoint-GUID: vxvX7kn5_U3YwBI8js7z0xkqCJVeQw4o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_04,2025-10-13_01,2025-03-28_01

From: Keith Busch <kbusch@kernel.org>

bio_split_rw_at may return a negative error value if the bio can not be
split into anything that adheres to the block device's queue limits.
Check for that condition and fail the bio accordingly.

Reported-by: Chris Mason <clm@fb.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 fs/xfs/xfs_zone_gc.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 064cd1a857a02..24799715efdc4 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -765,6 +765,8 @@ xfs_zone_gc_split_write(
 			lim->max_zone_append_sectors << SECTOR_SHIFT);
 	if (!split_sectors)
 		return NULL;
+	if (split_sectors < 0)
+		return ERR_PTR(split_sectors);
=20
 	/* ensure the split chunk is still block size aligned */
 	split_sectors =3D ALIGN_DOWN(split_sectors << SECTOR_SHIFT,
@@ -819,8 +821,16 @@ xfs_zone_gc_write_chunk(
 	bio_add_folio_nofail(&chunk->bio, chunk->scratch->folio, chunk->len,
 			offset_in_folio(chunk->scratch->folio, bvec_paddr));
=20
-	while ((split_chunk =3D xfs_zone_gc_split_write(data, chunk)))
+	while (!IS_ERR_OR_NULL(split_chunk =3D xfs_zone_gc_split_write(data, ch=
unk)))
 		xfs_zone_gc_submit_write(data, split_chunk);
+
+	if (IS_ERR(split_chunk)) {
+		chunk->bio.bi_status =3D errno_to_blk_status(PTR_ERR(
+								split_chunk));
+		bio_endio(&chunk->bio);
+		return;
+	}
+
 	xfs_zone_gc_submit_write(data, chunk);
 }
=20
--=20
2.47.3

