Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7082915E5DE
	for <linux-xfs@vger.kernel.org>; Tue,  2 Apr 2024 21:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712093750; cv=none; b=sqCE7b7gRpqnyGNWPxs+o6iqPr4c4BNoZuZU+1A0f9ifV37lnGjKmSDa2q5nyAGEAxSFPwLLUmNdMZPfbfjpECnZu7lnpuevzRZGQJ08jPMDpLEowu7/xkmdFrRSyCEdEMS3+AJGkkBKo1oi51qoFtjRBS4wGsYibdDK3uT2IpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712093750; c=relaxed/simple;
	bh=UVFaSvKtQtbkxIKww4Gb8H8z9Qia4xQf/EiX/zan0Io=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pw3/IVpohuxhEq/uUn4vH2M9G/VLxWqKTM7OwQ+1kkBBfiZnj3S3NMznGGw+/UQ74p43KFQi3u+s9THYHRRRbhv+UT4f9BES8xZNpgJ5fnuLpVIrZYCRXp1t8eMeH0ySbuat/e8H4LvN7a2s7optz+rNS/5I1Vrl9RiTRc1bF78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=TIAXUDH/; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="TIAXUDH/"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-5dcc4076c13so252827a12.0
        for <linux-xfs@vger.kernel.org>; Tue, 02 Apr 2024 14:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712093748; x=1712698548; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NEnfM+jopKkDMHCtvibf7wJfRopPLPsgM5YkBKMJle0=;
        b=TIAXUDH/y+xgUwlH2Co7Z9Kb+JikirVUid7aOW+vEr+VWwTCl9juhxbEUu5nSJKzYb
         9CW7qFBficylkf+WGmUdbzKnu5sAZ99lSMior3cmqPapUM1/7pT7HipAem5XiPfYP6/Z
         PdESKxsB9ljSuoDSt4GHNB3ndbBQZDSFLyicZc2y5du4jCtSQnLWyCL24VqA+55nryPl
         KoTVDor88pH+dH8KOPPMF0pefD2LBuJrosnwnReyvPO6LApYzi9Sm3nLTT7G/wurpKP5
         Qw/3xPS3R+GxKjGme/vO8jC8wh2SRdF8l4Cb1KWOirScrNgOzrg9NLlWu7V1JUPZK5qc
         Q0/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712093748; x=1712698548;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NEnfM+jopKkDMHCtvibf7wJfRopPLPsgM5YkBKMJle0=;
        b=YU+HzdoYx5gvKOhBIBD9vXUu/IJdBgnyiofLkU6DD/LmhQlm+ozapJZmroaF6o/o18
         JAiRZEzrADXOMaYSzRE0vxMkACXdcI5dj2Fv7Apdh19Z8V7FiiT5hcRYRnuo1iUQweBH
         2j2k8t+3K1oE9vScyMmYt6J06u/n+FsJpTb8Kb0sqXaZ7R2GkSvS+u32Xtnw5JQHUTpQ
         9yd+UXWT9Q6/fO1L/WC7FyiHNPDaUoWBl8GQ2nQN1vCn7IvIlr8K+vmxuxvhpKupUXcb
         tiepxJtpX4e2yKgCvmyttqjXZNq3+jsB/xGpbHGL+m9MzIDpRun43adbQ6suMiYqHHCo
         exug==
X-Gm-Message-State: AOJu0YyRYb1n2KCFlAsoEIVGGMed1PNndjiiT/kjUW2XCKHvV8mb8Wcr
	acttv3A8Vbwg1PiHfJTb1A8nAtntIDOLor8/Vm+cM4a5mHav7tmLe2N2OVH+LmhXOnQcVWkSmU0
	C
X-Google-Smtp-Source: AGHT+IHjmiWuparFR6Fhqk6Oxg3UbvrZuI56Qu0VjhCOhIxeTu4x4cmpxkc0UV8VSJLhgsjLTvzdAw==
X-Received: by 2002:a17:903:1206:b0:1e0:1a52:3c59 with SMTP id l6-20020a170903120600b001e01a523c59mr1028871plh.23.1712093747514;
        Tue, 02 Apr 2024 14:35:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id x5-20020a170902a38500b001e256cb48f7sm2047251pla.197.2024.04.02.14.35.46
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 14:35:46 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rrlnE-001n7G-0k
	for linux-xfs@vger.kernel.org;
	Wed, 03 Apr 2024 08:35:43 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rrlnD-000000052Fi-31Zv
	for linux-xfs@vger.kernel.org;
	Wed, 03 Apr 2024 08:35:43 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 5/5] xfs: fix sparse warnings about unused interval tree functions
Date: Wed,  3 Apr 2024 08:28:32 +1100
Message-ID: <20240402213541.1199959-6-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240402213541.1199959-1-david@fromorbit.com>
References: <20240402213541.1199959-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

Sparse throws warnings about the interval tree functions that are
defined and then not used in the scrub bitmap code:

fs/xfs/scrub/bitmap.c:57:1: warning: unused function 'xbitmap64_tree_iter_next' [-Wunused-function]
INTERVAL_TREE_DEFINE(struct xbitmap64_node, bn_rbnode, uint64_t,
^
./include/linux/interval_tree_generic.h:151:33: note: expanded from macro 'INTERVAL_TREE_DEFINE'
ITSTATIC ITSTRUCT *                                                           \
                                                                              ^
<scratch space>:3:1: note: expanded from here
xbitmap64_tree_iter_next
^
fs/xfs/scrub/bitmap.c:331:1: warning: unused function 'xbitmap32_tree_iter_next' [-Wunused-function]
INTERVAL_TREE_DEFINE(struct xbitmap32_node, bn_rbnode, uint32_t,
^
./include/linux/interval_tree_generic.h:151:33: note: expanded from macro 'INTERVAL_TREE_DEFINE'
ITSTATIC ITSTRUCT *                                                           \
                                                                              ^
<scratch space>:59:1: note: expanded from here
xbitmap32_tree_iter_next

Fix these by marking the functions created by the interval tree
creation macro as __maybe_unused to suppress this warning.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/scrub/bitmap.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
index 0cb8d43912a8..7ba35a7a7920 100644
--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -40,22 +40,23 @@ struct xbitmap64_node {
  * These functions are defined by the INTERVAL_TREE_DEFINE macro, but we'll
  * forward-declare them anyway for clarity.
  */
-static inline void
+static inline __maybe_unused void
 xbitmap64_tree_insert(struct xbitmap64_node *node, struct rb_root_cached *root);
 
-static inline void
+static inline __maybe_unused void
 xbitmap64_tree_remove(struct xbitmap64_node *node, struct rb_root_cached *root);
 
-static inline struct xbitmap64_node *
+static inline __maybe_unused struct xbitmap64_node *
 xbitmap64_tree_iter_first(struct rb_root_cached *root, uint64_t start,
 			uint64_t last);
 
-static inline struct xbitmap64_node *
+static inline __maybe_unused struct xbitmap64_node *
 xbitmap64_tree_iter_next(struct xbitmap64_node *node, uint64_t start,
 		       uint64_t last);
 
 INTERVAL_TREE_DEFINE(struct xbitmap64_node, bn_rbnode, uint64_t,
-		__bn_subtree_last, START, LAST, static inline, xbitmap64_tree)
+		__bn_subtree_last, START, LAST, static inline __maybe_unused,
+		xbitmap64_tree)
 
 /* Iterate each interval of a bitmap.  Do not change the bitmap. */
 #define for_each_xbitmap64_extent(bn, bitmap) \
@@ -314,22 +315,23 @@ struct xbitmap32_node {
  * These functions are defined by the INTERVAL_TREE_DEFINE macro, but we'll
  * forward-declare them anyway for clarity.
  */
-static inline void
+static inline __maybe_unused void
 xbitmap32_tree_insert(struct xbitmap32_node *node, struct rb_root_cached *root);
 
-static inline void
+static inline __maybe_unused void
 xbitmap32_tree_remove(struct xbitmap32_node *node, struct rb_root_cached *root);
 
-static inline struct xbitmap32_node *
+static inline __maybe_unused struct xbitmap32_node *
 xbitmap32_tree_iter_first(struct rb_root_cached *root, uint32_t start,
 			  uint32_t last);
 
-static inline struct xbitmap32_node *
+static inline __maybe_unused struct xbitmap32_node *
 xbitmap32_tree_iter_next(struct xbitmap32_node *node, uint32_t start,
 			 uint32_t last);
 
 INTERVAL_TREE_DEFINE(struct xbitmap32_node, bn_rbnode, uint32_t,
-		__bn_subtree_last, START, LAST, static inline, xbitmap32_tree)
+		__bn_subtree_last, START, LAST, static inline __maybe_unused,
+		xbitmap32_tree)
 
 /* Iterate each interval of a bitmap.  Do not change the bitmap. */
 #define for_each_xbitmap32_extent(bn, bitmap) \
-- 
2.43.0

