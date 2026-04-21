Received: from out198-147.us.a.mail.aliyun.com (out198-147.us.a.mail.aliyun.com [47.90.198.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B20137AA81
	for <linux-xfs@vger.kernel.org>; Tue, 21 Apr 2026 23:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=47.90.198.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776812730; cv=none; b=lkAgY7ZAqitrGOqBYvljbK4xdlRzKzgNIddMIwSog9hKEB7OS0Ry4XgBpY8axu/qUsSY9E4pIXwT/Io7R9lTpy03YlzcFepZTO9FAnhvNgvVYj3SYA9IAXg4fyv0oLNmkPS4YjkO/H1VjMJt1D2/RwHZJ0kc4t1ZbYoP3zzGfpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776812730; c=relaxed/simple;
	bh=hiPljp1xLehYPakrYd5/t0do4ncNFnS5yr06hsetCvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zt66YlSNacSIjqu+eEy1HUfqz+WJushP3klqDogUU5pSV2QVXJuhKTryxLORz6XHy/YSc49uZlce23pQhggNuW70UJwgHyiC7w93id/ZaKxpT0U5qdFOU9bfGrgfxtzS+EWNhLl1q3dmR0V9FiqMMgoc/4MhQV4cvvkRdRJ8LeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com; spf=pass smtp.mailfrom=e16-tech.com; arc=none smtp.client-ip=47.90.198.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=e16-tech.com
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.04688288|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.108126-0.00193365-0.889941;FP=15342186217492778747|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033037025160;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=2;RT=2;SR=0;TI=SMTPD_---.hHGs8.K_1776812715;
Received: from T7610-el9.e16-tech.com(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.hHGs8.K_1776812715 cluster:ay29)
          by smtp.aliyun-inc.com;
          Wed, 22 Apr 2026 07:05:16 +0800
From: Wang Yugui <wangyugui@e16-tech.com>
To: linux-xfs@vger.kernel.org
Cc: Wang Yugui <wangyugui@e16-tech.com>
Subject: [ RFC ] xfs: 4K inode support
Date: Wed, 22 Apr 2026 07:05:15 +0800
Message-ID: <20260421230515.2234-1-wangyugui@e16-tech.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260421094204.A743.409509F4@e16-tech.com>
References: <20260421094204.A743.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

use case for 4K inode
- simpler logic for 4Kn device, and less lock.
- better performance for directory with many files.
- maybe inline data support later.

TODO:
still crash in xfs_trans_read_buf_map() when mount a 4K inode xfs now.

---
 fs/xfs/libxfs/xfs_format.h   | 2 +-
 fs/xfs/libxfs/xfs_metafile.c | 2 +-
 fs/xfs/libxfs/xfs_sb.c       | 1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 779dac59b1f3..84cce8d268e6 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1079,7 +1079,7 @@ enum xfs_dinode_fmt {
  * Inode minimum and maximum sizes.
  */
 #define	XFS_DINODE_MIN_LOG	8
-#define	XFS_DINODE_MAX_LOG	11
+#define	XFS_DINODE_MAX_LOG	12
 #define	XFS_DINODE_MIN_SIZE	(1 << XFS_DINODE_MIN_LOG)
 #define	XFS_DINODE_MAX_SIZE	(1 << XFS_DINODE_MAX_LOG)
 
diff --git a/fs/xfs/libxfs/xfs_metafile.c b/fs/xfs/libxfs/xfs_metafile.c
index cf239f862212..9db799576775 100644
--- a/fs/xfs/libxfs/xfs_metafile.c
+++ b/fs/xfs/libxfs/xfs_metafile.c
@@ -98,7 +98,7 @@ xfs_metafile_resv_can_cover(
 	 * isn't critical unless there also isn't enough free space.
 	 */
 	return xfs_compare_freecounter(mp, XC_FREE_BLOCKS,
-			rhs - mp->m_metafile_resv_avail, 2048) >= 0;
+			rhs - mp->m_metafile_resv_avail, 4096) >= 0;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 38d16fe1f6d8..39424a7c74df 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -734,6 +734,7 @@ xfs_validate_sb_common(
 	case 512:
 	case 1024:
 	case 2048:
+	case 4096:
 		break;
 	default:
 		xfs_warn(mp, "inode size of %d bytes not supported",
-- 
2.36.2

