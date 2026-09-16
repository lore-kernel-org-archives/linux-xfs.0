Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A0E366DA5;
	Wed, 16 Sep 2026 00:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789519435; cv=none; b=NdvLikGKrBJQOkW851bV1CuhaVkgWkOUwS7/4mTu6hkUWEagD9YUe4MmWiv/zLyWrSnTq3RT2h2aRiX+kU7Ll+qUj9MwWk1gJeVqdxDI0vzSyDL3y0Zc3CPphMAqUYrMZV97WoTZOhTjOdTlmKNfmLq1U4GSCpm3boq/i7rjNpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789519435; c=relaxed/simple;
	bh=PeRwC/7l24s34QCvX4GHYD0lAvQ0aAUs91senf8r18k=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=m44i+NroYrtwEI/R9PCSysyxzBN8Xcny1dA0FpW05fYEzIfVdMEoHA6doJrCzkuZKvTQAlsK2PJGdsWbQg1/XfHjCFZyChW7lEyu4GGKLvYfwjBSEBon9xACIwM4r7dw4fQ2lG2LZESSmV3eUZh2HVc4S406ufYVDB808lxN9GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=nYVl0WDI; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="nYVl0WDI"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FNsNxp602464;
	Wed, 16 Sep 2026 00:43:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=G/2Re3ER3
	bBWK6ZjUVxJveFiLHO++ZKLD9+kzlG95n0=; b=nYVl0WDIIUXQM3R97p9SpDUKL
	NbuMlP9t0+nZUms/OGJRILjJB36tDe6NZqs5Ovw4KdL2dnEkigjMVaH9UgpYMv8d
	c61FQqTmihFfOhBHdfx1BaLqoTkdMEFZGeh3azgV0J84Lyi9LBDwQMjDK6buBv4d
	XFMN0G7TPq/DkwIfFZrL0cFAM3sJxVl660Qvc1dctWjBQPB7r8yIuJBeI5OmAla4
	M/uRTPWCBdoqJS5XRsCMPYdpgYAbPwg+XzdWpvP9GXD1RQ6cLO5tZouE8lt/rKfJ
	D4F5yzC0pdsDKfaL+cKr/mULlfQgEt97ykWtS1YuFTr2oaGIdj+MES3+6LYSA==
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [128.224.246.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4gqc1nget8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 16 Sep 2026 00:43:39 +0000 (GMT)
Received: from ala-p2exch01.corp.ad.wrs.com (10.11.226.101) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Tue, 15 Sep 2026 17:43:38 -0700
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-p2exch01.corp.ad.wrs.com (10.11.226.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.46; Tue, 15 Sep 2026 17:43:37 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Tue, 15 Sep 2026 17:43:36 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [PATCH] xfs: move xfs_sync_sb_buf() out of libxfs into xfs_ioctl.c
Date: Wed, 16 Sep 2026 08:43:35 +0800
Message-ID: <20260916004335.228753-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 5XKYqVnM9lU-6ZBM1wzfQkFX_h9kghW8
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDAwNyBTYWx0ZWRfX6LGFeP1pOnvh
 cpUTJZVpQEhJPv10+14XaNkSxAmZBUPVzn+1xPoYyk454C8+lsZfLq/UhTI2YdZnQjuq+xrGmyZ
 m4uvXtlXzaX1H4VSEiKc16DgEqF1kkVXdIu+vc+wAYty+epsVk4m
X-Authority-Analysis: v=2.4 cv=L+GI0OT8 c=1 sm=1 tr=0 ts=6aa9e63b cx=c_pps
 a=Lg6ja3A245NiLSnFpY5YKQ==:117 a=Lg6ja3A245NiLSnFpY5YKQ==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=klDOsUkWDRETUCZYPvoE:22 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=t7CeM3EgAAAA:8
 a=Oqw7-2tlOnOurFbf-4kA:9 a=1CNFftbPRP8L7MoqJWF3:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: 5XKYqVnM9lU-6ZBM1wzfQkFX_h9kghW8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDAwNyBTYWx0ZWRfXyOscAwArgbRV
 VAMJGcFTQyEPRgPfx5iIqjhGLu6ILydQ2R5xKqWo0qql67wZRBuXN0LzsTGzI1XgQd+xPscV8Zf
 XXO6uoaKKg9E09xzsoYyfHRFdyCNtfe6SG/M5RGVPz4e57cr0gX3fqaReFi3WuUMO+YpIq49Gba
 z9W+HlYcqMc5s5zlnjUm37FycLcKBeW/ggRh2t8ee/nsToy0ETSRpXf3eOo2i0o+XZG5VnWfZj+
 WrOODoSSQvOg+FOR7XWxFKLHDBEOQoR0qH0PyPVATfRvYLa5v4lha3BcQGbv3TQsbxJjR8UeTCH
 CIaIDq3e5BnLMXtaIZbaWrcPQz+92CTuNdvIye8cSMlbWFKzZaydPc7He2z82r6FtZ2rKZNADVL
 nlyHVmrvdkD9XfAd1jxyxLX7HMIxwklC+5uuAjLzVhwukOFx8BWOSYJGKxosNrBAo8CZasfofEq
 qH4KzBaVkRQOEktx88w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 spamscore=0
 clxscore=1015 priorityscore=1501 impostorscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609160007

xfs_sync_sb_buf() dereferences mp->m_sb_bp and mp->m_rtsb_bp, which
only exist in the kernel's struct xfs_mount, not in xfsprogs' libxfs.
Keeping it in libxfs is a porting hazard.

Its only caller, xfs_ioc_setlabel(), is kernel-only, so move it there
and make it static.

Fixes: c1351fb48eee ("xfs: don't hold buffer locks across sync transaction commit in xfs_sync_sb_buf")
Suggested-by: Darrick J. Wong <djwong@kernel.org>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 fs/xfs/libxfs/xfs_sb.c | 40 ----------------------------------------
 fs/xfs/libxfs/xfs_sb.h |  1 -
 fs/xfs/xfs_ioctl.c     | 40 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 40 insertions(+), 41 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 2664728f2d8f..2c976b9d343d 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1460,46 +1460,6 @@ xfs_update_secondary_sbs(
 	return saved_error ? saved_error : error;
 }
 
-/*
- * Same behavior as xfs_sync_sb, except that it is always synchronous and it
- * also writes the superblock buffer to disk sector 0 immediately.
- */
-int
-xfs_sync_sb_buf(
-	struct xfs_mount	*mp,
-	bool			update_rtsb)
-{
-	struct xfs_trans	*tp;
-	int			error;
-
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_sb, 0, 0, 0, &tp);
-	if (error)
-		return error;
-
-	xfs_log_sb(tp);
-	if (update_rtsb)
-		xfs_log_rtsb(tp, xfs_trans_getsb(tp));
-	xfs_trans_set_sync(tp);
-	error = xfs_trans_commit(tp);
-	if (error)
-		return error;
-
-	/* Re-acquire and write the sb and rtsb to disk. */
-	xfs_buf_lock(mp->m_sb_bp);
-	error = xfs_bwrite(mp->m_sb_bp);
-	xfs_buf_unlock(mp->m_sb_bp);
-	if (error)
-		return error;
-
-	if (update_rtsb && mp->m_rtsb_bp) {
-		xfs_buf_lock(mp->m_rtsb_bp);
-		error = xfs_bwrite(mp->m_rtsb_bp);
-		xfs_buf_unlock(mp->m_rtsb_bp);
-	}
-
-	return error;
-}
-
 void
 xfs_fs_geometry(
 	struct xfs_mount	*mp,
diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index 34d0dd374e9b..77de65922213 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -15,7 +15,6 @@ struct xfs_perag;
 
 extern void	xfs_log_sb(struct xfs_trans *tp);
 extern int	xfs_sync_sb(struct xfs_mount *mp, bool wait);
-extern int	xfs_sync_sb_buf(struct xfs_mount *mp, bool update_rtsb);
 extern void	xfs_sb_mount_common(struct xfs_mount *mp, struct xfs_sb *sbp);
 void		xfs_sb_mount_rextsize(struct xfs_mount *mp, struct xfs_sb *sbp);
 void		xfs_mount_sb_set_rextsize(struct xfs_mount *mp,
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 1b53701bebea..fc8c59d2879c 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1035,6 +1035,46 @@ xfs_ioc_getlabel(
 	return 0;
 }
 
+/*
+ * Same behavior as xfs_sync_sb, except that it is always synchronous and it
+ * also writes the superblock buffer to disk sector 0 immediately.
+ */
+static int
+xfs_sync_sb_buf(
+	struct xfs_mount	*mp,
+	bool			update_rtsb)
+{
+	struct xfs_trans	*tp;
+	int			error;
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_sb, 0, 0, 0, &tp);
+	if (error)
+		return error;
+
+	xfs_log_sb(tp);
+	if (update_rtsb)
+		xfs_log_rtsb(tp, xfs_trans_getsb(tp));
+	xfs_trans_set_sync(tp);
+	error = xfs_trans_commit(tp);
+	if (error)
+		return error;
+
+	/* Re-acquire and write the sb and rtsb to disk. */
+	xfs_buf_lock(mp->m_sb_bp);
+	error = xfs_bwrite(mp->m_sb_bp);
+	xfs_buf_unlock(mp->m_sb_bp);
+	if (error)
+		return error;
+
+	if (update_rtsb && mp->m_rtsb_bp) {
+		xfs_buf_lock(mp->m_rtsb_bp);
+		error = xfs_bwrite(mp->m_rtsb_bp);
+		xfs_buf_unlock(mp->m_rtsb_bp);
+	}
+
+	return error;
+}
+
 static int
 xfs_ioc_setlabel(
 	struct file		*filp,
-- 
2.43.0

