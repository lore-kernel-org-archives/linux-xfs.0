Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f/I9yPQ8"
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393D311B
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 07:07:49 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1d346f4a043so6482895ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 07:07:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702566468; x=1703171268; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3yKPmLzQlR5DZCmXV5MMctKnKAoTBjayjh0kheIIFvk=;
        b=f/I9yPQ8c3dTIN2mIXSPzfu+ROssl0xNTGwhCeUdv99mEcx4iFzv5Iiulna2F/2Qv8
         VDfwxPDRf/Y1H6/8QqWttDLq8Z/znWauxQXSz0WZ1tYSdYNz65xtWcHklEBD6EsDEQ3F
         g+6VXwMWs8sX3Y/3VyVXfyJNQs1aGbnlHCWbA0f75Q2jiXfEb1y3SjcOQW6ERcz268gx
         uNO/nebUeGUrfD7zhDCTHnnypD3pDybeqEZ8/6+GY3sC6JBWbYYfGLvmZUqGaSn3SyO5
         ODWjVlECSup6wv5gdSGhCZrZSwjMky+KN0gpUoLadtVBncYpyXYDhOPQxzXZyCeECYfU
         alAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702566468; x=1703171268;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3yKPmLzQlR5DZCmXV5MMctKnKAoTBjayjh0kheIIFvk=;
        b=my7Ld4LZPLIGuZ+Tqxova7spJums+xdfm7youo8wIgGOt/3v5lhspUMPoEGSdAFaQu
         kgG0f+Njs6+yZjIoW3/029rh4vdlaUeH4vSNPXg47SMfTowfbnPLvGv24bvPEXFxjy68
         DrVV65JP+zmzQnAxiJTCMJadrNDpKUoEMVIYxU8H/g0m2RtK17j9Ho7dd0+s/m6VNEXB
         f2SSCfhqIYTmdP64r7zCiZAFPwB+UozVEmCaaaNxsb88FLDrkhXBi7Ovu98ekzQmZiFE
         /7r52AMRiswQUerAcXUmViQn+fUIrU8ACXvYSOCovAGW+LzidOGjVQb0mqbAd74vK1Y6
         QxpQ==
X-Gm-Message-State: AOJu0YyLEF/36mlu0JQb3qkbYeMY58T1y1fT5WrYMoWp5M36MJYkOsGy
	kdhs/H3I/0WlJvCVQerpslefEYirR0s=
X-Google-Smtp-Source: AGHT+IEWckN/R3yvzjuQgqPk+ufznpqJ7vSNKs+4pt8m3X2+ih6Vod6fa57poU/3Bh1b36a0AsHxcg==
X-Received: by 2002:a17:902:ea03:b0:1d0:56b9:3730 with SMTP id s3-20020a170902ea0300b001d056b93730mr19524655plg.5.1702566468149;
        Thu, 14 Dec 2023 07:07:48 -0800 (PST)
Received: from wj-xps.. ([43.224.245.229])
        by smtp.gmail.com with ESMTPSA id d21-20020a170902729500b001d3797d6899sm317923pll.263.2023.12.14.07.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Dec 2023 07:07:47 -0800 (PST)
From: Jian Wen <wenjianhn@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Jian Wen <wenjianhn@gmail.com>,
	djwong@kernel.org,
	Jian Wen <wenjian1@xiaomi.com>
Subject: [PATCH] xfs: improve handling of prjquot ENOSPC
Date: Thu, 14 Dec 2023 23:07:08 +0800
Message-Id: <20231214150708.77586-1-wenjianhn@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't clear space of the whole fs when the project quota limit is
reached, since it affects the writing performance of files of
the directories that are under quota.

Only run cow/eofblocks scans on the quota attached to the inode.

Signed-off-by: Jian Wen <wenjian1@xiaomi.com>
---
 fs/xfs/xfs_file.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e33e5e13b95f..4fbe262d33cc 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -24,6 +24,9 @@
 #include "xfs_pnfs.h"
 #include "xfs_iomap.h"
 #include "xfs_reflink.h"
+#include "xfs_quota.h"
+#include "xfs_dquot_item.h"
+#include "xfs_dquot.h"
 
 #include <linux/dax.h>
 #include <linux/falloc.h>
@@ -803,8 +806,18 @@ xfs_file_buffered_write(
 		goto write_retry;
 	} else if (ret == -ENOSPC && !cleared_space) {
 		struct xfs_icwalk	icw = {0};
+		struct xfs_dquot	*pdqp = ip->i_pdquot;
 
 		cleared_space = true;
+		if (XFS_IS_PQUOTA_ENFORCED(ip->i_mount) &&
+			pdqp && xfs_dquot_lowsp(pdqp)) {
+			xfs_iunlock(ip, iolock);
+			icw.icw_prid = pdqp->q_id;
+			icw.icw_flags |= XFS_ICWALK_FLAG_PRID;
+			xfs_blockgc_free_space(ip->i_mount, &icw);
+			goto write_retry;
+		}
+
 		xfs_flush_inodes(ip->i_mount);
 
 		xfs_iunlock(ip, iolock);
-- 
2.34.1

