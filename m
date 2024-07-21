Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338D0441D
	for <linux-xfs@vger.kernel.org>; Sun, 21 Jul 2024 11:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721561248; cv=none; b=Bj5s1zNtg7ZKe0LSgRzMUYDrOlshNrrK5KcpCB4BgPMOcDabj29ecsscSlSvL+XI2R+useD2f5SB4lweGNzrt7xS5g0eU6WWm62VwC9dgOzKZA5fvOHoOq9E9gAdtI93163c7a4heMeDtotNczdY1D12t7q5BXByFc9bpnGvOgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721561248; c=relaxed/simple;
	bh=cy30LxzsokbSJtg7YkDwVU1gwYCwn58YF59VtECVCM4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UCHLYbEi2DmaCsaDUOsy8RFJJLjwXclbsw7tpBcrzSgKR2mcEf/nb1n5zfnyZUUTlnUsHXmT6Jfe6TQ/zSwUL9VKlaQipdmJuXQTD8JH3bOAzTlbQlqQi38xShuWYTuqDHnGTmVO+/UQB3D/wn991b+DoWWCeaBZBq289t0091U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JTRwIpzG; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JTRwIpzG"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-70b0e7f6f8bso1970327b3a.3
        for <linux-xfs@vger.kernel.org>; Sun, 21 Jul 2024 04:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721561246; x=1722166046; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MkVyRZi4tj9DgOEUIGR+D9RvRqQXblasLIhG5cmz7Cg=;
        b=JTRwIpzGxtexruEbo+03Lv7R+TtPHOVyJbmQG0TN267sTmmvGq2qtnnqYoENFMTe10
         FZLmSXs5LHkperIhPWGbnFybu+VBlcH1+li9IphhrUVIN+wMlakYVOTT0y9NHuK32maC
         yeqnLIsENL2tn9mOBfSQlNP5oDR26MW+PSCRRLv2DoRVv63lJjmuU9eXt3D2CF48BmME
         h0F7z4AUL+NKqbPjcvJr8uafVSLHHQWYwjiL4zdd/MIX7VHm8dSNSPhO4fdxsk2iVrCw
         3u5CnN2iJliJhcwzJv/dQn3N5uHtz228mSOII+NrIXgy4ec/DgGN2CAYjFlgvptBZKaj
         y4EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721561246; x=1722166046;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MkVyRZi4tj9DgOEUIGR+D9RvRqQXblasLIhG5cmz7Cg=;
        b=G15iFpJed9zeOrCgAS8GqTmP971IIzpgiMAv6QRZr1TNebVgCtGG6DIlhRVnrdtjAN
         oeF+pvG5lvsmKZ5hP0U0zJq/XR+s9pUXWoIeo/czYuXujm6ZieR2akDYZcjqCURSVXpg
         gBmB5wkL/bMBWbVYWf6W37cMyisQLVkLy0vzTWgB8pHZqFW8evNluON7wr3QptXpvK53
         i8bS+tKNLWAZ70t3EuPE7NKP8zwfI3URGPDmTC01WVUQ/N2CVVU/DVx6/H9ypEJ+gv/E
         cPm+gW/YrNiHdlKgoD9BmZduLy4txMUZJyUpqwJZzhiVazabeoiOgALXQsxLBiTlWz6y
         QhUg==
X-Gm-Message-State: AOJu0YxzOXOBdfv1rLkmtM7Jn1dYZpoh93TAjK5vjWpsrgLlv7vLa6Ej
	H6WqUA4tvJ78Ejvt7PROo/kZuCAH66neVuTwVtBU9NVVT1zDwml3Sy4plKpIXcdxWQ==
X-Google-Smtp-Source: AGHT+IEEOTyOTFs/qvAxdoSopCINw2N1CFoVpj05FvTNRLq/XEJ3omakWqmy9lDnVHozajSzaFLtgw==
X-Received: by 2002:a05:6a21:c8a:b0:1c3:ce0f:bfb2 with SMTP id adf61e73a8af0-1c4285d55a7mr5182128637.23.1721561245930;
        Sun, 21 Jul 2024 04:27:25 -0700 (PDT)
Received: from localhost ([60.206.64.40])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cb77307630sm6050279a91.21.2024.07.21.04.27.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jul 2024 04:27:25 -0700 (PDT)
From: Julian Sun <sunjunchao2870@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: chandan.babu@oracle.com,
	djwong@kernel.org,
	Julian Sun <sunjunchao2870@gmail.com>
Subject: [PATCH] xfs: remove unused parameter in macro XFS_DQUOT_LOGRES
Date: Sun, 21 Jul 2024 07:27:01 -0400
Message-Id: <20240721112701.212342-1-sunjunchao2870@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the macro definition of XFS_DQUOT_LOGRES, a parameter is accepted,
but it is not used. Hence, it should be removed.

This patch has only passed compilation test, but it should be fine.

Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
---
 fs/xfs/libxfs/xfs_quota_defs.h |  2 +-
 fs/xfs/libxfs/xfs_trans_resv.c | 28 ++++++++++++++--------------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index cb035da3f990..fb05f44f6c75 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -56,7 +56,7 @@ typedef uint8_t		xfs_dqtype_t;
  * And, of course, we also need to take into account the dquot log format item
  * used to describe each dquot.
  */
-#define XFS_DQUOT_LOGRES(mp)	\
+#define XFS_DQUOT_LOGRES	\
 	((sizeof(struct xfs_dq_logformat) + sizeof(struct xfs_disk_dquot)) * 6)
 
 #define XFS_IS_QUOTA_ON(mp)		((mp)->m_qflags & XFS_ALL_QUOTA_ACCT)
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 3dc8f785bf29..45aaf169806a 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -338,11 +338,11 @@ xfs_calc_write_reservation(
 					blksz);
 		t1 += adj;
 		t3 += adj;
-		return XFS_DQUOT_LOGRES(mp) + max3(t1, t2, t3);
+		return XFS_DQUOT_LOGRES + max3(t1, t2, t3);
 	}
 
 	t4 = xfs_calc_refcountbt_reservation(mp, 1);
-	return XFS_DQUOT_LOGRES(mp) + max(t4, max3(t1, t2, t3));
+	return XFS_DQUOT_LOGRES + max(t4, max3(t1, t2, t3));
 }
 
 unsigned int
@@ -410,11 +410,11 @@ xfs_calc_itruncate_reservation(
 					xfs_refcountbt_block_count(mp, 4),
 					blksz);
 
-		return XFS_DQUOT_LOGRES(mp) + max3(t1, t2, t3);
+		return XFS_DQUOT_LOGRES + max3(t1, t2, t3);
 	}
 
 	t4 = xfs_calc_refcountbt_reservation(mp, 2);
-	return XFS_DQUOT_LOGRES(mp) + max(t4, max3(t1, t2, t3));
+	return XFS_DQUOT_LOGRES + max(t4, max3(t1, t2, t3));
 }
 
 unsigned int
@@ -466,7 +466,7 @@ STATIC uint
 xfs_calc_rename_reservation(
 	struct xfs_mount	*mp)
 {
-	unsigned int		overhead = XFS_DQUOT_LOGRES(mp);
+	unsigned int		overhead = XFS_DQUOT_LOGRES;
 	struct xfs_trans_resv	*resp = M_RES(mp);
 	unsigned int		t1, t2, t3 = 0;
 
@@ -577,7 +577,7 @@ STATIC uint
 xfs_calc_link_reservation(
 	struct xfs_mount	*mp)
 {
-	unsigned int		overhead = XFS_DQUOT_LOGRES(mp);
+	unsigned int		overhead = XFS_DQUOT_LOGRES;
 	struct xfs_trans_resv	*resp = M_RES(mp);
 	unsigned int		t1, t2, t3 = 0;
 
@@ -641,7 +641,7 @@ STATIC uint
 xfs_calc_remove_reservation(
 	struct xfs_mount	*mp)
 {
-	unsigned int            overhead = XFS_DQUOT_LOGRES(mp);
+	unsigned int            overhead = XFS_DQUOT_LOGRES;
 	struct xfs_trans_resv   *resp = M_RES(mp);
 	unsigned int            t1, t2, t3 = 0;
 
@@ -729,7 +729,7 @@ xfs_calc_icreate_reservation(
 	struct xfs_mount	*mp)
 {
 	struct xfs_trans_resv	*resp = M_RES(mp);
-	unsigned int		overhead = XFS_DQUOT_LOGRES(mp);
+	unsigned int		overhead = XFS_DQUOT_LOGRES;
 	unsigned int		t1, t2, t3 = 0;
 
 	t1 = xfs_calc_icreate_resv_alloc(mp);
@@ -747,7 +747,7 @@ STATIC uint
 xfs_calc_create_tmpfile_reservation(
 	struct xfs_mount        *mp)
 {
-	uint	res = XFS_DQUOT_LOGRES(mp);
+	uint	res = XFS_DQUOT_LOGRES;
 
 	res += xfs_calc_icreate_resv_alloc(mp);
 	return res + xfs_calc_iunlink_add_reservation(mp);
@@ -829,7 +829,7 @@ STATIC uint
 xfs_calc_ifree_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
+	return XFS_DQUOT_LOGRES +
 		xfs_calc_inode_res(mp, 1) +
 		xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
 		xfs_calc_iunlink_remove_reservation(mp) +
@@ -846,7 +846,7 @@ STATIC uint
 xfs_calc_ichange_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
+	return XFS_DQUOT_LOGRES +
 		xfs_calc_inode_res(mp, 1) +
 		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
 
@@ -955,7 +955,7 @@ STATIC uint
 xfs_calc_addafork_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
+	return XFS_DQUOT_LOGRES +
 		xfs_calc_inode_res(mp, 1) +
 		xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
 		xfs_calc_buf_res(1, mp->m_dir_geo->blksize) +
@@ -1003,7 +1003,7 @@ STATIC uint
 xfs_calc_attrsetm_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
+	return XFS_DQUOT_LOGRES +
 		xfs_calc_inode_res(mp, 1) +
 		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
 		xfs_calc_buf_res(XFS_DA_NODE_MAXDEPTH, XFS_FSB_TO_B(mp, 1));
@@ -1043,7 +1043,7 @@ STATIC uint
 xfs_calc_attrrm_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
+	return XFS_DQUOT_LOGRES +
 		max((xfs_calc_inode_res(mp, 1) +
 		     xfs_calc_buf_res(XFS_DA_NODE_MAXDEPTH,
 				      XFS_FSB_TO_B(mp, 1)) +
-- 
2.39.2

