Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A90717C7D0;
	Tue, 25 Jun 2024 18:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719340135; cv=none; b=EbVQvtjv6DbMWmnb1s2ZcU2W9v9YyazIl3IbbOiaj08FpY5TFizFjkIOirIcHNvqq3N7F1tOyl1xLTTI1EBxwCIPDetqyci9kvM+h30V4gUwhm0MHx4n+IVlRnQF7Rh8ck1udMb/XwRbZvMfix3szf9l4qU5l2dTti6Y8OGEcLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719340135; c=relaxed/simple;
	bh=r34+NkBjnqYSLz5JiYQOZc7LdjFOXtY+UI22sjL5X/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UgT8qzEz0mz5zzTHa98x1FPmGyIxt9svjwNNkCDnpXSQ5sl73rK8fuj0CLRK5cSozMVea9cubJylPK4VCtjwsRzP/bRGdLt65LC59WwseV/HEh/6gzINUst1v8aDSJ+Be0iot6o6zCPkBhtrQQO/vJlovdA0IPo9MUtQXxxIKqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FMGv/WNk; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FMGv/WNk"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1f480624d0dso49395775ad.1;
        Tue, 25 Jun 2024 11:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719340134; x=1719944934; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tti8tfUni+jo0pgZ1UkC8BRXUh3kKnbvv76kUo1ZzXQ=;
        b=FMGv/WNk5UE4nhH5GIzwrr0TGgnShhAegVu/FFADqRqNJeEueIQtWWd8ZSq1/cVnhT
         2eSjFk+aennf9QYQFOx9hq9B5ljIoStIH4Cu+ctWtWZk++pWb/U0BEP2GxIQEWDMKGvq
         d2Vh/MKVScrHERZjAiQvObLwSmmbeOoqb4RDFVgWcpVCisLdlN5YFyvcK8t3IaJkfK5j
         H059fqt5GEYekUoO5ThZMxM1/cdj0umWtqSBvgKhyl+OOAwujojA8BBFpO7lUGwAh3ld
         LR2O6E/kkHx2Owat75wi+jIxDncFBJDe5i/HxQ1onAaFVvXX7gu+KLRme7jMngeoAjae
         N1TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719340134; x=1719944934;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tti8tfUni+jo0pgZ1UkC8BRXUh3kKnbvv76kUo1ZzXQ=;
        b=eSsro+gy0XbK9aQBhh0rwsmhu4GUDsbcdHZfDYwme2v3pwrkntSyD5orPrsFUN9J7a
         svVYrADVRjk6fDNW7CqQVoBkp3yL7bfOaLq/YAH0tCiro+WnY8/CyzmNloK3taCmWZo0
         8VkxR7xaih3uLPP+q/96lcR66sCfWcnyBtYgxzHyIy4gqiL6pYqIxPV0HWAryeiO3ouQ
         F6tyMtt9pGpZXmMZKP/tt6rFcUP6jxSdSAb+oppJK7Bae+fC1xdQ3foGESrsuOMUKkDC
         NBK6+D/SwAVVNMQopmMIpWGsnevLIepIEIknWwiE4IiohtYlgtrmBnwkKyU3HIraW/Bd
         7OYg==
X-Forwarded-Encrypted: i=1; AJvYcCVm7HYln4u1tA04av/cYnAqgR2jqxmBBVpsdXdactoTHFCC6mEBhMuAgkzqRfb8aK8W1pmIhIY+1AHZxQbfZj38SqkQAkSsYuJdMXNaGliyxwOAsbpx07WP1jnfWLUvByOzzPMkxMfl
X-Gm-Message-State: AOJu0YyE0UlFikVoV34U9AouG/UzTc9KE06oXKjZRKVmPIhavMB1EuFO
	G3kSvdI6ACI0weaoYBJsW2VNH4fWkethTMeVxK2k8Y7BR/E/CxRN
X-Google-Smtp-Source: AGHT+IEmlcT3TsRk/DWUOLT5RLzBfBeh2YkFR61NnBmyhYdmWOe9EIm6Ah7rQW2alYm7N9ImRfXssQ==
X-Received: by 2002:a17:902:cec1:b0:1fa:2d1:1071 with SMTP id d9443c01a7336-1fa23ec9866mr106396905ad.19.1719340133657;
        Tue, 25 Jun 2024 11:28:53 -0700 (PDT)
Received: from localhost.localdomain ([43.135.72.207])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9eb320917sm84690555ad.75.2024.06.25.11.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jun 2024 11:28:53 -0700 (PDT)
From: alexjlzheng@gmail.com
X-Google-Original-From: alexjlzheng@tencent.com
To: chandan.babu@oracle.com,
	djwong@kernel.org
Cc: david@fromorbit.com,
	hch@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	alexjlzheng@tencent.com
Subject: [PATCH xfs v2 1/2] xfs: add xfs_log_vec_cache for separate xfs_log_vec/xfs_log_iovec
Date: Wed, 26 Jun 2024 02:28:41 +0800
Message-ID: <20240625182842.1038809-2-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.41.1
In-Reply-To: <20240625182842.1038809-1-alexjlzheng@tencent.com>
References: <20240625182842.1038809-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jinliang Zheng <alexjlzheng@tencent.com>

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
2.39.3

