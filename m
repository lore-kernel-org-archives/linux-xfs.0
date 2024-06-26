Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F088514264A;
	Wed, 26 Jun 2024 04:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719377361; cv=none; b=GKHkJWRoCmR/VlJSyM8AfnDOOFxkUBqZvjWIN/MtCyM360HOAGHAleJehStEXP55cKELxSX2ukg+zAvie5vrVt0GjGewe6HQocCeX0vdNpyKu7V5TwLasJtdQ8fDXhYxhIr+dQvdkIZIrpBhvh4VU5Zmmx/I8krvuPkOaKzOj18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719377361; c=relaxed/simple;
	bh=7niHlmjKuoR07woD9Y+yYJFdrMBB6KSRMb/3Q3cj+Z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HsR8EF+lhRi6c8SlmWjAyiu2k4dVAdg45SV+60YH3q3M8pdtQWe8Kzx+SutDSGtsxFrGs3VwXAaXIBqtdlX8AdwmI74jKHyX9+iK1b850eFsxjZH9eUgYL53u3yznaGOFN1ZeneR081UOqSD5AK3/v/i1axREPeCKodgQzPfwxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KFaCWLuL; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KFaCWLuL"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1f9b364faddso51585855ad.3;
        Tue, 25 Jun 2024 21:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719377359; x=1719982159; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C222SWLCuVOoT7+Oa8+HjPQoTQUppM2Vdy/T8D8Hdww=;
        b=KFaCWLuL+P4DTKQx9pjTIC6vzKiR/bKVp7UTIruODSQf4ZvEkKA4czfhi25wjbe70p
         Vz3tsGoQEcLAW1fiUGQRYNOKuqqde/CXW+vSuJ/vX7lFWMmnWQyNeo0qCGxaCj/7TAJV
         jH/2zh3AydBWCyOFMaJc+cWlv/GtcvbxQo5IcpsKOHcNbWyrERglytkUwrleMPefWoNE
         Z3Q7bxx4ErLPRKZjQz/OwY6PHFVSJHFigzCz/t6lB+mPYo5YTnLZFOmW0YHocNCvLOWL
         DyfFpBDeEZIc2CCat6yK0QYduojeC+CiyB2U/Fht4pTYYmTfjDxxcPu/ICeil1OihHYW
         JnIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719377359; x=1719982159;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C222SWLCuVOoT7+Oa8+HjPQoTQUppM2Vdy/T8D8Hdww=;
        b=CCqwmqNOn5odgFMlbWKeXMhvZ5sv5udk156fJ2P4AKAJPN72E/GZImT/37+W8Fm5pC
         nuYL+5UkTPrXiaqlWFCzQxJVu3NzowRKitHk0geEgYXPDDutL8jJ0t/EUrM/nzAL/MH+
         nl03QI4xBKbIVfB6bM3k0ZWPG2tX9J7UsiAdfIWDjbRyeNEnTnj+bvfpb/03WUC/bnqC
         7NlsTIT0ZD627VXumwVUbGAIohYm31OwFT22NLJn40KO7/31DuRAC7ugUim5Tv7v5vo5
         EIFRf/n2WOJn+CD3+nK3caWYSEoxBtl9wEk0aIdHj82Nk1JAKjrOnno3+ESJa4baxW0+
         WiEg==
X-Forwarded-Encrypted: i=1; AJvYcCUztYwDEZc3CH1x40C67MU/rrnBg6VEAND5A/iMCyjQL/zWSskM3BZGiZBXuq76TXM9f4IvTc7Hyz9lNDCGBWCeFFQxIRf8Pz1Eh99DMS6C5DC7JokU9ANI4hzM69Tf+scgTTeRDTXS
X-Gm-Message-State: AOJu0Yw/TiqLIEYWde54bGNmQVidzB8AGcYMyQptgvXKwTGDGy2LNuB0
	8Y4n3kWB4rUzfWd7oPQhwZ4Cmn2Hp4s3O3idrMeUlFyDVT3Z3pm/
X-Google-Smtp-Source: AGHT+IHRECYXJsgbDFyGK55lbzYPeGgU7f2wCi6qTbF9mBQ6flh9uFI5U9KLU+9BO84FOxb8py1UrQ==
X-Received: by 2002:a17:902:f685:b0:1f6:ed89:6bca with SMTP id d9443c01a7336-1fa23fb2970mr100625485ad.39.1719377359145;
        Tue, 25 Jun 2024 21:49:19 -0700 (PDT)
Received: from localhost.localdomain ([43.135.72.207])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9eb321a8esm90110685ad.96.2024.06.25.21.49.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jun 2024 21:49:18 -0700 (PDT)
From: alexjlzheng@gmail.com
X-Google-Original-From: alexjlzheng@tencent.com
To: chandan.babu@oracle.com,
	djwong@kernel.org
Cc: david@fromorbit.com,
	hch@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	alexjlzheng@tencent.com
Subject: [PATCH v3 1/2] xfs: add xfs_log_vec_cache for separate xfs_log_vec/xfs_log_iovec
Date: Wed, 26 Jun 2024 12:49:08 +0800
Message-ID: <20240626044909.15060-2-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.41.1
In-Reply-To: <20240626044909.15060-1-alexjlzheng@tencent.com>
References: <20240626044909.15060-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jinliang Zheng <alexjlzheng@tencent.com>

This patch prepares for the next patch that separates xfs_log_iovec
from the xfs_log_vec/xfs_log_iovec combination.

Because xfs_log_vec itself is a very small object, there is no need
to fallback to vmalloc(). Use kmalloc() to allocate memory for
xfs_log_vec and use kmem_cache to speed it up.

Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
---
 fs/xfs/xfs_log.c   | 1 +
 fs/xfs/xfs_log.h   | 2 ++
 fs/xfs/xfs_super.c | 9 +++++++++
 3 files changed, 12 insertions(+)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 416c15494983..49e676061f2f 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -21,6 +21,7 @@
 #include "xfs_sb.h"
 #include "xfs_health.h"
 
+struct kmem_cache	*xfs_log_vec_cache;
 struct kmem_cache	*xfs_log_ticket_cache;
 
 /* Local miscellaneous function prototypes */
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index d69acf881153..9cc10acf7bcd 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -20,6 +20,8 @@ struct xfs_log_vec {
 	int			lv_size;	/* size of allocated lv */
 };
 
+extern struct kmem_cache *xfs_log_vec_cache;
+
 #define XFS_LOG_VEC_ORDERED	(-1)
 
 /*
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 27e9f749c4c7..7e94f9439a8f 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2222,8 +2222,16 @@ xfs_init_caches(void)
 	if (!xfs_parent_args_cache)
 		goto out_destroy_xmi_cache;
 
+	xfs_log_vec_cache = kmem_cache_create("xfs_log_vec",
+						sizeof(struct xfs_log_vec),
+						0, 0, NULL);
+	if (!xfs_log_vec_cache)
+		goto out_destroy_args_cache;
+
 	return 0;
 
+ out_destroy_args_cache:
+	kmem_cache_destroy(xfs_parent_args_cache);
  out_destroy_xmi_cache:
 	kmem_cache_destroy(xfs_xmi_cache);
  out_destroy_xmd_cache:
@@ -2286,6 +2294,7 @@ xfs_destroy_caches(void)
 	 * destroy caches.
 	 */
 	rcu_barrier();
+	kmem_cache_destroy(xfs_log_vec_cache);
 	kmem_cache_destroy(xfs_parent_args_cache);
 	kmem_cache_destroy(xfs_xmd_cache);
 	kmem_cache_destroy(xfs_xmi_cache);
-- 
2.41.1

