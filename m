Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59F12F12DB
	for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 16:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771433791; cv=none; b=TON6vMTM4uG0gSU4ZKGAb/WeoRAbuw/Xll4Ctac5EQY80WgP7Bzl2UM32pvF9NKpkUrRBvq5bLMX16z1wQfeMJxpQDwIMBaJJTmzFrUJUfc5w+T1IQAw0/zsTHJzpwdxUyDoG1nesZ/82xCZFkLJmwEYMilvLRD1AdFfzX6OuNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771433791; c=relaxed/simple;
	bh=eu5qGor+Ocr8H8dpqM3t3TgMpTKujUecPG4BPGS6bew=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cpsmE39cSAVQRPDOC+vWknC5o3VYTLUOaJAO+KxlL90cKLION+FKjQiaCBtRJ+SvivGd9uwoJjG4SuxH7mYj1pEcTeOpTsUe17Hqcsey6jEhNNu8E3ZBwihx1RsaPxbS5tMUaC5VEt5hsCg8VvuyjFKQn6daU+bpB+Qqlxqx7AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PLGm7tfJ; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PLGm7tfJ"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4806bf39419so7998255e9.1
        for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 08:56:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771433788; x=1772038588; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=elzy5JOSmtPeHgoS3qukWz3CcOnWYEZc+4cPnyfUXGQ=;
        b=PLGm7tfJoSur/00fJkQPib7vyQu0HeIhSihN6UcRczER8+xS7xXIBWLPACfJXbMOxe
         tkTj4kfJy8pPNG/JamQ6bdsxJz+tDWvb9DLu1sgX1xb5Ndy9RlXPuDNCfEakbe5JjPWT
         LPww/X1gOHRyV2v8BymR06VWE2LkYHlt5mRYn9E2cvupWM4E+v3iwWTlsY054u4CmMYD
         6oGB/e+ymeWDftS6nA/suyLRFEB9M0AR666WHoK5YH2rGLxw1+kzxx6QOMCkKMFcwxw8
         dz5HHjh88QL6VUoKnrQzvPSByo1/aNncR0Gjpa6LpUqaK8ZFDvvZKgvflvtDHEDEwr60
         8jTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771433788; x=1772038588;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=elzy5JOSmtPeHgoS3qukWz3CcOnWYEZc+4cPnyfUXGQ=;
        b=I1hr1XQyWOUGOOdq03H/Ph5nnl+y/gvHsS4z/B6batfi6l5Pt4XMX1xXaSj//y4MN3
         QrvKbKUJg5cL5tbvQH8p1FiYsoKm0gMJJhmf0uHVMRRdMyi5QvA3kd72rF7qR/5fXVMP
         nR8+zpjKcQ5gT5oX34C+rluA3iECiKeQ2o3DFsWuu+47vE/BAQzRtq+y51YYB9X4uNSB
         1r9Wd/FL29wwQE25fRRIK9HUDm6nrxUj1TdMjz5JnwbydOmY3hyfeyu8yVt5A4ARXV4F
         QmXcLSm73xeYmI1z/UpQe99xkkU6wvLRU7wsvLXjbouYfrBMsYNBW7ywC3L37mEVGPmr
         l3pg==
X-Forwarded-Encrypted: i=1; AJvYcCUdMzDSiEov1BHTsOQBt08Nfj0O8p01ZhSQNUuk91KhF8bfZ3lMdXk8Y1hPFKyf9hOx+fD6bjjlaBI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyC0+SttNdGer2qEDH4uNIEk2EfyiJbtM8RsB+IkGcZ3KCjJAsZ
	3g84HWCulRfwPsjK2vFbP1Pzoo/nIy8mbSoW8/xkigi1qK67ypaUvCy90R9WK2w3lWo=
X-Gm-Gg: AZuq6aIORZBGV3YvYL/jQXbFUn3O38ETv5GEHjBH1QZQwWt2qJX2zy+H2+6CYH6E/8s
	DSHRqprdAEL5bnJHvpz77VSVTPpkSjI/o63vQBYOfNhaVelK/uh1zNEV6WbclwqTMdHlobOnNYG
	QYLSA3U1bLy4wABg1XQ9Dy7ObUAhHIv+NhXFG1Q4Om7RD5l5Sk2+QHXoIV6889xMuzLErS+/Wan
	4S3LCgMycPTssUCOkRu4LyP7w3GzqE4jn4wUDE+q2czgfZyThOdlTpQ3NBuYfBFTyFp9qfnMALY
	EY7tXXfHiUc7xPsS3cR6zQ5Y7ewW0HKPjZOZCxz4YOi9hqIz3tdWnp9H/xX1wv0y7mixVpk50j0
	+o9QDPQo+dYdFOoCvZl28bP3z7FM9Zw3ObKY/f4cNFXhPRwcfmm5hbPIY4SvERsXwzZlTxMKJTR
	NwuKG0lnV9US0sjAJapiMDtKxb
X-Received: by 2002:a05:600c:41c3:b0:483:7eeb:4558 with SMTP id 5b1f17b1804b1-48398c5afa3mr26299875e9.2.1771433788203;
        Wed, 18 Feb 2026 08:56:28 -0800 (PST)
Received: from linux ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483983b837fsm31645435e9.5.2026.02.18.08.56.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 08:56:27 -0800 (PST)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Anthony Iliopoulos <ailiopoulos@suse.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH] xfs: convert alloc_workqueue users to WQ_UNBOUND
Date: Wed, 18 Feb 2026 17:56:09 +0100
Message-ID: <20260218165609.378983-1-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Recently, as part of a workqueue refactor, WQ_PERCPU has been added to
alloc_workqueue() users that didn't specify WQ_UNBOUND.
The change has been introduced by:

  69635d7f4b344 ("fs: WQ_PERCPU added to alloc_workqueue users")

These specific workqueues don't use per-cpu data, so change the behavior
removing WQ_PERCPU and adding WQ_UNBOUND. Even if these workqueue are
marked unbound, the workqueue subsystem maintains cache locality by
default via affinity scopes.

The changes from per-cpu to unbound will help to improve situations where
CPU isolation is used, because unbound work can be moved away from
isolated CPUs.

Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
---
 fs/xfs/xfs_log.c   |  2 +-
 fs/xfs/xfs_super.c | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index a26378ca247d..82f6b12efe22 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1441,7 +1441,7 @@ xlog_alloc_log(
 	log->l_iclog->ic_prev = prev_iclog;	/* re-write 1st prev ptr */
 
 	log->l_ioend_workqueue = alloc_workqueue("xfs-log/%s",
-			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM | WQ_HIGHPRI | WQ_PERCPU),
+			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM | WQ_HIGHPRI | WQ_UNBOUND),
 			0, mp->m_super->s_id);
 	if (!log->l_ioend_workqueue)
 		goto out_free_iclog;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 8586f044a14b..072381c6f137 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -592,19 +592,19 @@ xfs_init_mount_workqueues(
 	struct xfs_mount	*mp)
 {
 	mp->m_buf_workqueue = alloc_workqueue("xfs-buf/%s",
-			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM | WQ_PERCPU),
+			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM | WQ_UNBOUND),
 			1, mp->m_super->s_id);
 	if (!mp->m_buf_workqueue)
 		goto out;
 
 	mp->m_unwritten_workqueue = alloc_workqueue("xfs-conv/%s",
-			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM | WQ_PERCPU),
+			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM | WQ_UNBOUND),
 			0, mp->m_super->s_id);
 	if (!mp->m_unwritten_workqueue)
 		goto out_destroy_buf;
 
 	mp->m_reclaim_workqueue = alloc_workqueue("xfs-reclaim/%s",
-			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM | WQ_PERCPU),
+			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM | WQ_UNBOUND),
 			0, mp->m_super->s_id);
 	if (!mp->m_reclaim_workqueue)
 		goto out_destroy_unwritten;
@@ -616,13 +616,13 @@ xfs_init_mount_workqueues(
 		goto out_destroy_reclaim;
 
 	mp->m_inodegc_wq = alloc_workqueue("xfs-inodegc/%s",
-			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM | WQ_PERCPU),
+			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM | WQ_UNBOUND),
 			1, mp->m_super->s_id);
 	if (!mp->m_inodegc_wq)
 		goto out_destroy_blockgc;
 
 	mp->m_sync_workqueue = alloc_workqueue("xfs-sync/%s",
-			XFS_WQFLAGS(WQ_FREEZABLE | WQ_PERCPU), 0,
+			XFS_WQFLAGS(WQ_FREEZABLE | WQ_UNBOUND), 0,
 			mp->m_super->s_id);
 	if (!mp->m_sync_workqueue)
 		goto out_destroy_inodegc;
@@ -2564,7 +2564,7 @@ xfs_init_workqueues(void)
 	 * AGs in all the filesystems mounted. Hence use the default large
 	 * max_active value for this workqueue.
 	 */
-	xfs_alloc_wq = alloc_workqueue("xfsalloc", XFS_WQFLAGS(WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_PERCPU),
+	xfs_alloc_wq = alloc_workqueue("xfsalloc", XFS_WQFLAGS(WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_UNBOUND),
 			0);
 	if (!xfs_alloc_wq)
 		return -ENOMEM;
-- 
2.52.0

