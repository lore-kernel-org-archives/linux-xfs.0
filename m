Received: from out198-177.us.a.mail.aliyun.com (out198-177.us.a.mail.aliyun.com [47.90.198.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FB537AA9E
	for <linux-xfs@vger.kernel.org>; Tue, 21 Apr 2026 23:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=47.90.198.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776812840; cv=none; b=mih/B3eLOdzAai8ZydsoZcV7GYsTkWs94pgKLSB3JrD4bldmXRl7jr07bqKhzraL0xaeZMlHHaq/g21hfvZgG7a0+hxtkyiBfO/Kw6kPXZLVDMaAV7PARZlhHEoAPqEFqX3P6kXGOMOJyjU+YsLOy/M8lfwBKzoWP7+AMIBKcSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776812840; c=relaxed/simple;
	bh=CiswoQf2gps/3abTRHYKzHwpx4Kk3WlIOUmzpPnM32s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mvoZF2MFzpv9JdKmsPDGp6y26U9WgGyAP780JB+Zum1nLhEnScU98O50ppeEfKaCoeJBx79LAPD2EWgcA5QP7TwgLgVqtDP/KmPuPDp1TAwq1e99WgNwnPtkswoJLqV8ErN1J2IfegeWQLgChyG+sVPDPhOzDJp5F9LqfDv+vms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com; spf=pass smtp.mailfrom=e16-tech.com; arc=none smtp.client-ip=47.90.198.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=e16-tech.com
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.04516068|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.046581-0.000705164-0.952714;FP=17646905942975516529|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033037025160;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=2;RT=2;SR=0;TI=SMTPD_---.hHJ6Ner_1776812509;
Received: from T7610-el9.e16-tech.com(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.hHJ6Ner_1776812509 cluster:ay29)
          by smtp.aliyun-inc.com;
          Wed, 22 Apr 2026 07:01:50 +0800
From: Wang Yugui <wangyugui@e16-tech.com>
To: linux-xfs@vger.kernel.org
Cc: Wang Yugui <wangyugui@e16-tech.com>
Subject: [PATCH] xfsprogs: 4K inode support
Date: Wed, 22 Apr 2026 07:01:49 +0800
Message-ID: <20260421230149.2211-1-wangyugui@e16-tech.com>
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

---
 include/xfs_multidisk.h | 2 +-
 libxfs/xfs_format.h     | 2 +-
 libxfs/xfs_sb.c         | 1 +
 man/man8/mkfs.xfs.8.in  | 3 +--
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/xfs_multidisk.h b/include/xfs_multidisk.h
index ef4443b0bb0e..b77a915811f9 100644
--- a/include/xfs_multidisk.h
+++ b/include/xfs_multidisk.h
@@ -14,7 +14,7 @@
 #define	XFS_DFL_BLOCKSIZE_LOG	12		/* 4096 byte blocks */
 #define	XFS_DINODE_DFL_LOG	8		/* 256 byte inodes */
 #define	XFS_DINODE_DFL_CRC_LOG	9		/* 512 byte inodes for CRCs */
-#define	XFS_MIN_INODE_PERBLOCK	2		/* min inodes per block */
+#define	XFS_MIN_INODE_PERBLOCK	1		/* min inodes per block */
 #define	XFS_DFL_IMAXIMUM_PCT	25		/* max % of space for inodes */
 #define	XFS_MIN_REC_DIRSIZE	12		/* 4096 byte dirblocks (V2) */
 #define XFS_MAX_INODE_SIG_BITS	32		/* most significant bits in an
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 779dac59b1f3..84cce8d268e6 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1079,7 +1079,7 @@ enum xfs_dinode_fmt {
  * Inode minimum and maximum sizes.
  */
 #define	XFS_DINODE_MIN_LOG	8
-#define	XFS_DINODE_MAX_LOG	11
+#define	XFS_DINODE_MAX_LOG	12
 #define	XFS_DINODE_MIN_SIZE	(1 << XFS_DINODE_MIN_LOG)
 #define	XFS_DINODE_MAX_SIZE	(1 << XFS_DINODE_MAX_LOG)
 
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index dd14c3ab3b59..9c57d13e50bc 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -717,6 +717,7 @@ xfs_validate_sb_common(
 	case 512:
 	case 1024:
 	case 2048:
+	case 4096:
 		break;
 	default:
 		xfs_warn(mp, "inode size of %d bytes not supported",
diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index fbafc5c79e02..b0a2222d370d 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -638,8 +638,7 @@ The minimum (and default)
 is 256 bytes without crc, 512 bytes with crc enabled.
 The maximum
 .I value
-is 2048 (2 KiB) subject to the restriction that
-the inode size cannot exceed one half of the filesystem block size.
+is 4096 (4 KiB).
 .IP
 XFS uses 64-bit inode numbers internally; however, the number of
 significant bits in an inode number
-- 
2.36.2

