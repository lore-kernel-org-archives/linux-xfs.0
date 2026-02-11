Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8AF23BCE3
	for <linux-xfs@vger.kernel.org>; Wed, 11 Feb 2026 13:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770818163; cv=none; b=d9T3LynTIBCv8dps2p4h2qj23P/ndDBa4p1LGSotT9FQwBPzgo7SP9kIBfW+/qtSoZuKWSeu7BnBqBEQn1HO8ZRkOeox+aLdKU/Jtq+FaWUzSZzD69FPaJnMgPC47Xyn4zkbMC6E5hwzBblaF9GtVpUoP6nbEFKCpqQ9deJfK4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770818163; c=relaxed/simple;
	bh=Lx7JRtdmJDbHzv4HoxieVD/WNQX4Yq+sKXe7kwrXLzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/BarSScM0Q9+vbQ/jdtkUbOj8VmCj7Zfok8XRzDoEwjSny7m+U4BPCyEOQ00iS77vpepNKR7mhaB776HrCwZ9D5932RXp9i7MiM2MJOiMB0Yt+/og66V8VRld82xCzwmAYlEMAY0xbTv3z0rVsw/6vtd1q19LPSGkjxmcK6OdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kMyjjqjw; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kMyjjqjw"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61BAAOKj2871415;
	Wed, 11 Feb 2026 13:55:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=qj2Cvpstii81noB0B
	lX+aBP1s9WANK72rTI3L/bOXOI=; b=kMyjjqjwQFD5sizxoTn6A71OaJnfLFU0T
	pj6hrTLVqAnhBXJ5BobGRr26Ve/hOnQfPfIJ9JYe1WHsIuFdFAVEoC24Rn0egPCw
	PzCOGgf79xA07kLGNZ2VwKG0Rs98i1fQrg6Ol0RO/vYMThcom5xjmDxmK3Aglzey
	IUSLvdMWUMWdL62xKf3rIQov7Fx5GKrMXUBvioyp21dneoHxbgjEXYHDyVOuHG/X
	1oKyxwah4HlamstL6enGKSFccLPJc2wexwFDL6Rrq2hprBXYC5GIEGmGFX10OFD7
	fJurHpOepQyDkkKaz49t8Wd3ICY5ZzFPfb2dgyKP+pE+qXSeJAt8Q==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696uhft9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Feb 2026 13:55:47 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61B9eeej001407;
	Wed, 11 Feb 2026 13:55:46 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c6gqn61e7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Feb 2026 13:55:46 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61BDtjnq17040120
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Feb 2026 13:55:45 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4576E58064;
	Wed, 11 Feb 2026 13:55:45 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D4C4758062;
	Wed, 11 Feb 2026 13:55:42 +0000 (GMT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com (unknown [9.39.20.201])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 11 Feb 2026 13:55:42 +0000 (GMT)
From: nirjhar@linux.ibm.com
To: djwong@kernel.org, hch@infradead.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
        nirjhar.roy.lists@gmail.com
Subject: [PATCH v2 1/2] xfs: Refactoring the nagcount and delta calculation
Date: Wed, 11 Feb 2026 19:25:13 +0530
Message-ID: <d6baea36063f013c5420b94ca53c85d97c5563ba.1770817711.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1770817711.git.nirjhar.roy.lists@gmail.com>
References: <cover.1770817711.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=KZnfcAYD c=1 sm=1 tr=0 ts=698c8a63 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8
 a=HzJ0amtto8-uTMgRARsA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjExMDEwNyBTYWx0ZWRfXxJkuM0sBeS8u
 GwTn9meApgE0qybDm+2t/ZRWzNyiUvC8mxLxnG70wDLnhXZ56Rg7AnaGxervLZMOvbUNiRXXaH4
 AH3WPQmmuRZqcd20O4Zu2sjFHfcL2glQJbzI02LoSeHBp7+e9vCTYKXdMpFNjDQcVKpmINACiNH
 8OIw0xpOEuH9QscaqdxXa5G2hzfM/fTSiRNosQaJDNlFNZCTFWR9rMGkwK7cYwS4V674zUQ94JX
 GA7QB/5oW+jNRIeMOCQKZlJgSjPblmJQeBvCyu2jLXIMh712q3CyxmPAMsiopWMaCZyhmzTiA7L
 s41SZZnbDTa4Ap7X/74aI5R+SRFqmuIFyN8lCJ3N0MJAcouKxqE7lEYfFgI7okpNMl6b9vshK99
 j27s+1lFFJ+vpCsu3VLn/BkWAeeGp7X+QvKkChsD8jRu2X30RfK+GYWq13hioELpmD5yOa4Alvx
 p5ioRrYOWbCyg26W/Ug==
X-Proofpoint-ORIG-GUID: ydNJasi4YUnu1B3ZC2NeTI17EVZfhdzT
X-Proofpoint-GUID: uyacB9yWRdN-AfqSe1O7_8Tp3ATiYasN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-11_01,2026-02-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 clxscore=1015 suspectscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602110107

From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>

Introduce xfs_growfs_compute_delta() to calculate the nagcount
and delta blocks and refactor the code from xfs_growfs_data_private().
No functional changes.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 fs/xfs/libxfs/xfs_ag.c | 28 ++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ag.h |  3 +++
 fs/xfs/xfs_fsops.c     | 17 ++---------------
 3 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index e6ba914f6d06..f2b35d59d51e 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -872,6 +872,34 @@ xfs_ag_shrink_space(
 	return err2;
 }
 
+void
+xfs_growfs_compute_deltas(
+	struct xfs_mount	*mp,
+	xfs_rfsblock_t		nb,
+	int64_t			*deltap,
+	xfs_agnumber_t		*nagcountp)
+{
+	xfs_rfsblock_t	nb_div, nb_mod;
+	int64_t		delta;
+	xfs_agnumber_t	nagcount;
+
+	nb_div = nb;
+	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
+	if (nb_mod && nb_mod >= XFS_MIN_AG_BLOCKS)
+		nb_div++;
+	else if (nb_mod)
+		nb = nb_div * mp->m_sb.sb_agblocks;
+
+	if (nb_div > XFS_MAX_AGNUMBER + 1) {
+		nb_div = XFS_MAX_AGNUMBER + 1;
+		nb = nb_div * mp->m_sb.sb_agblocks;
+	}
+	nagcount = nb_div;
+	delta = nb - mp->m_sb.sb_dblocks;
+	*deltap = delta;
+	*nagcountp = nagcount;
+}
+
 /*
  * Extent the AG indicated by the @id by the length passed in
  */
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 1f24cfa27321..3cd4790768ff 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -331,6 +331,9 @@ struct aghdr_init_data {
 int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
 int xfs_ag_shrink_space(struct xfs_perag *pag, struct xfs_trans **tpp,
 			xfs_extlen_t delta);
+void
+xfs_growfs_compute_deltas(struct xfs_mount *mp, xfs_rfsblock_t nb,
+			int64_t *deltap, xfs_agnumber_t *nagcountp);
 int xfs_ag_extend_space(struct xfs_perag *pag, struct xfs_trans *tp,
 			xfs_extlen_t len);
 int xfs_ag_get_geometry(struct xfs_perag *pag, struct xfs_ag_geometry *ageo);
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 0ada73569394..8353e2f186f6 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -92,18 +92,17 @@ xfs_growfs_data_private(
 	struct xfs_growfs_data	*in)		/* growfs data input struct */
 {
 	xfs_agnumber_t		oagcount = mp->m_sb.sb_agcount;
+	xfs_rfsblock_t		nb = in->newblocks;
 	struct xfs_buf		*bp;
 	int			error;
 	xfs_agnumber_t		nagcount;
 	xfs_agnumber_t		nagimax = 0;
-	xfs_rfsblock_t		nb, nb_div, nb_mod;
 	int64_t			delta;
 	bool			lastag_extended = false;
 	struct xfs_trans	*tp;
 	struct aghdr_init_data	id = {};
 	struct xfs_perag	*last_pag;
 
-	nb = in->newblocks;
 	error = xfs_sb_validate_fsb_count(&mp->m_sb, nb);
 	if (error)
 		return error;
@@ -122,20 +121,8 @@ xfs_growfs_data_private(
 			mp->m_sb.sb_rextsize);
 	if (error)
 		return error;
+	xfs_growfs_compute_deltas(mp, nb, &delta, &nagcount);
 
-	nb_div = nb;
-	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
-	if (nb_mod && nb_mod >= XFS_MIN_AG_BLOCKS)
-		nb_div++;
-	else if (nb_mod)
-		nb = nb_div * mp->m_sb.sb_agblocks;
-
-	if (nb_div > XFS_MAX_AGNUMBER + 1) {
-		nb_div = XFS_MAX_AGNUMBER + 1;
-		nb = nb_div * mp->m_sb.sb_agblocks;
-	}
-	nagcount = nb_div;
-	delta = nb - mp->m_sb.sb_dblocks;
 	/*
 	 * Reject filesystems with a single AG because they are not
 	 * supported, and reject a shrink operation that would cause a
-- 
2.43.5

