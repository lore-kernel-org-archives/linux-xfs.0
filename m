Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273F4439F71
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 10:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789122367; cv=none; b=FCk7RfqbVrgBDp2UUPhE2awbdjhb5Got4llg6CY2tp8Y+p9b3vACwCvzRtFSsfko3Rv8bQAAdXUHD3QmAVyOE/qL3/u8NgKtBOpZoKE8S/JQ1IwjsSb0daHpEMjEqBkGQYr1VJ9lGkxteC0dMJChK3BFZ5Z8LfLMQIrNzpCCmq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789122367; c=relaxed/simple;
	bh=AXS4qHAgHTV5BL/xeHAWPrMzvJoratQYNUkU1MxARUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hhixZnjHpoZGJFEkSGVbHlOCS/EQtZfh+rjPZM8xgIv6rimcBdIq99ieFFrXxH2afa8Ok1FsU3jKDL8eUVedjK4wHq0OVemxNxLGk4SqF4ipLTQib1ND/W40/plwJ45N5SNlG9AhZ2fTV9iLy3Fyo3y6yZ3Yvb5JC9Z08ieTw3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pJU7lt/k; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pJU7lt/k"
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d90ba1d807so8546295ad.3
        for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 03:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789122363; x=1789727163; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ifO3sasXxMBfgKginCHFmBB2zJHYEMMnSmBmMbp7mX4=;
        b=pJU7lt/k7Wiu544gGDO5YJpwGj6fXl5+epztjm95di4rGjQHfEYAixKkgesaSKuyCA
         kk/XnhH6G++nCnREhPOCsKvo23H4+Rc9PAZzoWNRo/vz0FDqCuLwSAjE5alUyPJEWWIJ
         tJ2FbN5fuUnPRxfOvUcRBzcTuW/5UKuXr6tVshpntGQhnA9qGREKDEf2re857f5m+O7O
         QwwYWqhEEQKy9rjF+qpB5DG4L0INXt6hWScBlwM41ariLwK1uBDWy6lbTOB1AvNhuol4
         Lw618DoyF8GDHwImcdzZQXKD66z1PrbLeg9lxOzM3gb4vb/KdLXlvbmZAjwjErBosquJ
         6LAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789122363; x=1789727163;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ifO3sasXxMBfgKginCHFmBB2zJHYEMMnSmBmMbp7mX4=;
        b=r+wZG5SW0Qv0axJecrXqj/S3nHoOa5xfbm86vmqlxQ4dG7lSkUIBpeS31bt4D22TjH
         vEkQXINGr6eGp0ApTXAVikxIWgPtiGtBhi8WYAdZekSfu8ZpNgy8Th7B16zu6JJ0IncB
         tX/FqtKL+ESfKoo5ExRpmzU6ttuyB4ZD+799cGREwP5S3LeWEh+hkkv68hEjQIDhhACI
         cHrLaOziVLrunXWohag0TJsqp9xujp9nczTXw3mn/KZ1OOFwRI2OsvG2a1zcaF7N3sQj
         5CwJ7oSmKa+SiXoGJ/uyw0FGS45tmEwKD2+k17Fq3+lal3aanUXkV05XaZLHHPsi5v2n
         H3rg==
X-Forwarded-Encrypted: i=1; AKwUvBxKH54n+F8jd+zdedT/2h8KoMWUQwmaj7DUmmyBJjTuVSa09OaWURu4+7j7KWafAd2G6xTx+mCWuas=@vger.kernel.org
X-Gm-Message-State: AFuF++lNIWZU/ANMy8fVxRy1lt5gAEdHBWhPpKE26ujhBmD8qsfqZrzb
	hMppO4eGm85PNmYYApyDm1DgEFzyEKtO6x3J/+0LlAVRtD/IHgAr8fAOiVjQoQ==
X-Gm-Gg: AYBFou2Q3KOJT/sJSYcFCb2uKN2wHG9U9H4mnUdX49VBM7Dtytjs7qqoEuDMLj9TX1H
	PoiYqd8nlX/3Kwrl7kAg4EsoQrSJj+MQPYpuZebcj9D1yJE9/Ie4b/5Vxp/RRjzPXagzKHX3tWn
	9xFqjKSTSXwrIBIoTH+Eq8eSBmToVH+CjXNJkWVSChE855q40ZLVDlk6OYjv/wPwQI/FfuNJHbD
	UPcnzOV/q1gnFNAl++jZuPKDFBmvd3RRJ69BWvFV+XB94MxhW3pfh3je3RxO7AutlBsUnyV+ibo
	FTr7AbQEqKWZ6us4Brhm1zDHLxff9v0xtp9SeAL0UCEdS/98a9IbVpyQLxWlLOMyo+nwRIpuohS
	2h6oHGTRZkLBxW5S3+lzaZII5Yt4tgWUMun+i8ESZx1JtdQ9EyqgRi+p+3Q3eW06ziqNk2RDvAR
	ZMPhGtURK6ugwTmWU8SXeuLrmJhjeaG1/b/osVYKxnFHyHYf9S71tryv2O4IazRSa+E2SqralCo
	rbX
X-Received: by 2002:a17:902:db0e:b0:2da:dcd8:713d with SMTP id d9443c01a7336-2dd2a34f6e6mr68042715ad.15.1789122362869;
        Fri, 11 Sep 2026 03:26:02 -0700 (PDT)
Received: from Default ([2409:40f4:1034:ff33:e7d7:d190:816c:e597])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33ba4ed295esm6220095eec.15.2026.09.11.03.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 03:26:02 -0700 (PDT)
From: Jeffin Philip <jeffinphilip14@gmail.com>
To: cem@kernel.org
Cc: dgc@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jeffin Philip <jeffinphilip14@gmail.com>
Subject: [RFC PATCH 1/2] xfs: add lockref and generic helpers for refcounting
Date: Fri, 11 Sep 2026 15:55:01 +0530
Message-ID: <20260911102502.163566-2-jeffinphilip14@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260911102502.163566-1-jeffinphilip14@gmail.com>
References: <20260911102502.163566-1-jeffinphilip14@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As part of fixing the UAF in xlog_cil_ail_insert() reported by
syzbot, add a generic lockref to xfs_log_item struct and
initialize it in xfs_log_item_init(). In addition, add generic
helpers(get()/put()/get_safe()) as part of the generic refcounting
infrastructure for xfs.

Signed-off-by: Jeffin Philip <jeffinphilip14@gmail.com>
---
 fs/xfs/xfs_log.c   | 38 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trans.h |  7 +++++++
 2 files changed, 45 insertions(+)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f807f8f4f705..1489f8f20b3e 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1033,12 +1033,50 @@ xfs_log_item_init(
 	item->li_ops = ops;
 	item->li_lv = NULL;
 
+	/*
+	 * Refrain from using lockref_init as BLI refcount should be
+	 * initialized to 0 and lockref_init initializes refcount to 1
+	 */
+	spin_lock_init(&item->li_ref.lock);
+	item->li_ref.count = 0;
 	INIT_LIST_HEAD(&item->li_ail);
 	INIT_LIST_HEAD(&item->li_cil);
 	INIT_LIST_HEAD(&item->li_bio_list);
 	INIT_LIST_HEAD(&item->li_trans);
 }
 
+/*
+ * Only called when the caller knows the object is alive
+ */
+void
+xfs_log_item_get(
+	struct xfs_log_item	*lip)
+{
+	lockref_get(&lip->li_ref);
+}
+
+/*
+ * Drop a log item reference when called. Returns true if last
+ * ref with lock held. Otherwise false.
+ */
+bool
+xfs_log_item_put(
+	struct xfs_log_item	*lip)
+{
+	return lockref_put_or_lock(&lip->li_ref);
+}
+
+/*
+ * Used to lookup if item may be dying. Returns true is the object
+ * is not dead, false otherwise.
+ */
+bool
+xfs_log_item_get_safe(
+	struct xfs_log_item	*lip)
+{
+	return lockref_get_not_dead(&lip->li_ref);
+}
+
 /*
  * Wake up processes waiting for log space after we have moved the log tail.
  */
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index eb83c5dac032..cd469e2e4e4d 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -6,6 +6,8 @@
 #ifndef	__XFS_TRANS_H__
 #define	__XFS_TRANS_H__
 
+#include <linux/lockref.h>
+
 /* kernel only transaction subsystem defines */
 
 struct xlog;
@@ -46,6 +48,8 @@ struct xfs_log_item {
 	struct xfs_log_vec		*li_lv_shadow;	/* standby vector */
 	xfs_csn_t			li_seq;		/* CIL commit seq */
 	uint32_t			li_order_id;	/* CIL commit order */
+
+	struct lockref			li_ref;		/* log item reference */
 };
 
 /*
@@ -110,6 +114,9 @@ xlog_item_is_intent_done(struct xfs_log_item *lip)
 
 void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
 			  int type, const struct xfs_item_ops *ops);
+void	xfs_log_item_get(struct xfs_log_item *lip);
+bool	xfs_log_item_put(struct xfs_log_item *lip);
+bool	xfs_log_item_get_safe(struct xfs_log_item *lip);
 
 /*
  * Return values for the iop_push() routines.
-- 
2.55.0

