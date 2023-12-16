Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996041E497
	for <linux-xfs@vger.kernel.org>; Sat, 16 Dec 2023 15:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GJqgGNkm"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-28b556fc260so16382a91.1
        for <linux-xfs@vger.kernel.org>; Sat, 16 Dec 2023 07:36:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702741000; x=1703345800; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/K4uj2bQGDwLUuCYVG3fVENL7moLYldudfeWUbn5F8Y=;
        b=GJqgGNkmsetbzFlYktuqel80V0Q1Io4nUxIv0vovDFLGPT8fAtELgdqpHVX49kzXPo
         /JFyrZWNVRcn1omkmcJf83nULcMp6ZGKXferxh0W0At6tEusdXogZxpDZrk0jeU1wfoK
         Y9x8KPWNb8gHsfKG9lDf7qNUiJacMSvRKDR3zbz3JtqDTfZTfagZzqtN5/E5Ic6POTZf
         96LKjtRkjgTq3EnyCmzXJX5Rprodzilh5y3+q4XQt8hMpA7unHaIZ2TXSdsTf20qlFjQ
         NFLJjkrtNoxFzktWkxOK9nq6WxLmsVdNz91LuH3zsVDVRnMjbNvQxrBByPHoflMlUf6b
         9yMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702741000; x=1703345800;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/K4uj2bQGDwLUuCYVG3fVENL7moLYldudfeWUbn5F8Y=;
        b=Np/gOllmBhfUdYpx+EuMMBm68HdKu6QGvSujB0X0byRRpwdOKq++kGfYXXZV2Pi24l
         8vOeaRHZpTHiDxhGV8y7amQV/kGsbULDnyHYDwNM7tiKi4vqcB9kEHVzebFIg49pFndM
         kFbhfobCTefK6MF2y/zyOEmfzv7PR3F5CtqriZ2aqpNwL6fOLAX12WXPsITmJly8Ya7V
         I0uGMkI8UGeVM3vMndizpKI57xWCOxtNwMLO8+ocwWLsVs8TEsgZMmEZiWsJjzqYslpi
         vKrfFys45tYeNca7Y8U5ddxTr1hWdO+/Mouptx2QHLD5YmZ+T9j/LGQclfubwKv0iB/T
         ljnQ==
X-Gm-Message-State: AOJu0Yzf1RytbhkapZzk6K1W8UxTZzp+tO/qfNYzVnNlaSA6W5Q1iO68
	C0jLzbkFib/PIm+XyqVa71VwmpPvwStyrg==
X-Google-Smtp-Source: AGHT+IFkX9aeBirBUBKFDMbaWqD7g1ghWaksdQMP0Yx6jlZIg+MsOJt1VQZeCpyokQpVjc0UFYU2ew==
X-Received: by 2002:a05:6a20:3942:b0:18c:198a:469b with SMTP id r2-20020a056a20394200b0018c198a469bmr31294592pzg.6.1702740999726;
        Sat, 16 Dec 2023 07:36:39 -0800 (PST)
Received: from wj-xps.. ([43.224.245.230])
        by smtp.gmail.com with ESMTPSA id k21-20020aa788d5000000b006ce75e0ef88sm15249830pff.78.2023.12.16.07.36.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Dec 2023 07:36:39 -0800 (PST)
From: Jian Wen <wenjianhn@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Jian Wen <wenjianhn@gmail.com>,
	djwong@kernel.org,
	hch@lst.de,
	dchinner@redhat.com,
	Jian Wen <wenjian1@xiaomi.com>
Subject: [PATCH v2] xfs: improve handling of prjquot ENOSPC
Date: Sat, 16 Dec 2023 23:35:22 +0800
Message-Id: <20231216153522.52767-1-wenjianhn@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231214150708.77586-1-wenjianhn@gmail.com>
References: <20231214150708.77586-1-wenjianhn@gmail.com>
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

Changes since v1:
- use the want_blockgc_free_quota helper that written by Darrick

Signed-off-by: Jian Wen <wenjian1@xiaomi.com>
---
 fs/xfs/xfs_file.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e33e5e13b95f..7764697e7822 100644
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
@@ -761,6 +764,20 @@ xfs_file_dax_write(
 	return ret;
 }
 
+static inline bool want_blockgc_free_quota(struct xfs_inode *ip, int ret)
+{
+	if (ret == -EDQUOT)
+		return true;
+	if (ret != -ENOSPC)
+		return false;
+
+	if (XFS_IS_PQUOTA_ENFORCED(ip->i_mount) &&
+	    ip->i_pdquot && xfs_dquot_lowsp(ip->i_pdquot))
+		return true;
+
+	return false;
+}
+
 STATIC ssize_t
 xfs_file_buffered_write(
 	struct kiocb		*iocb,
@@ -796,7 +813,7 @@ xfs_file_buffered_write(
 	 * running at the same time.  Use a synchronous scan to increase the
 	 * effectiveness of the scan.
 	 */
-	if (ret == -EDQUOT && !cleared_space) {
+	if (want_blockgc_free_quota(ip, ret) && !cleared_space) {
 		xfs_iunlock(ip, iolock);
 		xfs_blockgc_free_quota(ip, XFS_ICWALK_FLAG_SYNC);
 		cleared_space = true;
-- 
2.34.1

