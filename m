Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53C6390C8A
	for <linux-xfs@vger.kernel.org>; Sun, 19 Jul 2026 11:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784460631; cv=none; b=pgWvVjjwYybeR8nq0N5X2tIDxrYpsohaDHGa+NfC8mVy7nFF+Iqt3Bvb7xJ4fn1qTffRpVLi2aSnmjqKALyDnPzxoahNhCpP7GRAzIwL6e0lQ2EkqqCGUZ55w3EHPIqA3CAqbjYEE5+2fyMd/yNqXcLAobZipWMR1m1TfCsuyag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784460631; c=relaxed/simple;
	bh=V1E4ldfQJDyP6ZfDcqT6Ru436JirUZfMBpHQx0g4yjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EgLTNhmC04kct85PLMQdM+ArXKxm28Ywa+ILOGevQhn9dvL2rKeuxp4lEAUpaqwYbO7Kakx+4T3JsBgEtSMRDlC1+pWHsaCjDUDPyiFBmHDblG26jUpogi0OqvpyGElu7CkteibYhUAfpeT7TBX6PhKCCFzc8XbP/VA4sGk4Li8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VmEJeIzQ; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VmEJeIzQ"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2cc97653887so102034165ad.1
        for <linux-xfs@vger.kernel.org>; Sun, 19 Jul 2026 04:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784460626; x=1785065426; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N18ILb2wHDXeZG6Bb9nkkO9XUrYEdry3ahf/Z0caz74=;
        b=VmEJeIzQJ77jAmOi29pP3HFG6nELdj+RZ2ej5xk0arn0XwzJvasZ75SpV+KCjXGL+j
         2LtdY1Zz3exH+50LEkHMhx4DWL6AkHFoYeCSju0W0XTkQiOu8AaYo1rZIUb5BsS9CyS9
         7+sn4EIDmyXJmA8bul4ZRBNMrrAkG2TTFtgAjd4JvnmmzYK8o2uH6CyNr60fpEraioKW
         YzroAwsyzZnnINYPUlGgTMIoNzcstIqwvwGig8Y6Twd1QHUewhPqLif+R7bYNg2cwiNz
         S77XNhHuUJJNT8dSXIaWGEGFusyKt4rOy3WzH6mMhOImg7/m4dMfzh2yE3CeqwDWamFc
         2nRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784460626; x=1785065426;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=N18ILb2wHDXeZG6Bb9nkkO9XUrYEdry3ahf/Z0caz74=;
        b=CSrFy+vHMAapBIgAUjGu6dtMVgIR+Ket7HEOhuMZ0sqbM5HzGEKBP2VcgRUJIruNdG
         2n1l0iR/6A1BzzWG5tcZ7r4fI77Gy3OqrrshH0EeHRUQxgU/ec44WuLPUhTy/a/50n/B
         CuEAnEcIvk/GRXN6eb5XMQinz1MrWLkvUfy9YmR+Dcx9fTh9e/OytNUqSvGkoHo7ER6F
         OC4c9pmhH56OfdurIIW8cc+Yu7KqeIec7gzJeOStR6580QstOJCceFGy/TD5WSU/Us8h
         lKGY6XxjGqYxEl406/a/mc8skQUEJka2kSlNhGCOPkDYBCvRlWK1CrduNa/NzFo9jgr7
         vtYw==
X-Gm-Message-State: AOJu0Yw3Tu2rEoNyksSdYuwPE82lK5q4ZmZD9btHEXYsTxiORoY2nEp3
	Jve8QQmxNBnNesYshOLuXYaHYqLhE1jlAfH3g6qaF8ngbVjgCcOQzAv7srqK8DqmWfo=
X-Gm-Gg: AfdE7ckkgiT7Cg7XvOVIu/Yu40b7T2UtZYD8fnsLr1lDhBtX4XLu82At0XWIb2NPBOp
	4sejboKgpAjA0p2hYvSYuyfT3KORpZbDEKbOzfqVdMC0OuXC6DQt0fudt0ysnfDU7qaPJqa7ls1
	Eq+fdL+mHmtQOULN8p0CuKDRpPp2saehFrg1Yx4hMcJ/5MPuR1tLH77KeHnykirX+CQyZVyCUfN
	xvHpMpVYvp1cK4klhg1p+YsVoWI5vG3OUl5ExGB3BHLJOkbFdDhhRrPhv2BxkHA5jmkhvRZt8Sr
	pcqf8fBrlC9FIWQChXaCVtaJyXDp0KPgiKowY+GUO0Pu6+wmwTT+wTQEQe99EL3fbK9uywh2zIF
	OZNqrUam62fJZEl64sHlYdY343PmgwH2N0W5XZbivUJqd0SqkJsjAnxKw3ji/b4FX5VD3Ii5ht9
	M9UBe+IkKE2Xn25m2U4nSBpDaIsrMJjk6UD2I1a/M+X088n+q1MgwySdWIyA==
X-Received: by 2002:a17:902:ccc8:b0:2c9:ae0b:61e3 with SMTP id d9443c01a7336-2cf3484b193mr90357755ad.2.1784460625780;
        Sun, 19 Jul 2026 04:30:25 -0700 (PDT)
Received: from fx.tailc0aff1.ts.net ([206.206.192.132])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13ce2ddfb35sm22035031c88.14.2026.07.19.04.30.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 04:30:24 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xmei5@asu.edu,
	Weiming Shi <bestswngs@gmail.com>,
	Dave Chinner <dgc@kernel.org>
Subject: [PATCH v3 2/3] xfs: verify recovered log items are complete before replaying them
Date: Sun, 19 Jul 2026 04:29:22 -0700
Message-ID: <20260719112923.226550-3-bestswngs@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260719112923.226550-1-bestswngs@gmail.com>
References: <20260719112923.226550-1-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xlog_recover_add_to_trans() assembles each recovered log item into an
ri_buf[] of ri_total slots, where ri_total is the region count the item's
format header declared, and counts the regions actually logged in ri_cnt.
Nothing checked that ri_cnt reached ri_total once the item was fully
decoded, so a crafted or truncated log can present an item whose header
declares more regions than were logged. The trailing ri_buf[] slots stay
NULL, and the reorder, readahead and replay code then dereference them.

For example, an XFS_LI_INODE item declaring two regions but logging only
the format region leaves ri_buf[1] NULL, and mount-time recovery faults
dereferencing it as the log dinode:

 KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
 RIP: xlog_recover_inode_commit_pass2 (fs/xfs/xfs_inode_item_recover.c:370)
 Call Trace:
  xlog_recover_items_pass2 (fs/xfs/xfs_log_recover.c:2011)
  xlog_recover_commit_trans (fs/xfs/xfs_log_recover.c:2078)
  xlog_recovery_process_trans (fs/xfs/xfs_log_recover.c:2328)
  xlog_recover_process_data (fs/xfs/xfs_log_recover.c:2502)
  xlog_recover (fs/xfs/xfs_log_recover.c:3486)
  xfs_log_mount (fs/xfs/xfs_log.c:667)
  xfs_mountfs (fs/xfs/xfs_mount.c:1039)
  xfs_fs_fill_super (fs/xfs/xfs_super.c:1965)
  get_tree_bdev_flags (fs/super.c:1680)
  __x64_sys_mount (fs/namespace.c:4433)

An item is fully decoded once every region its header declared has
arrived. That happens when the next item's header starts (the current
item is closed out in xlog_recover_add_to_trans()) or, for the last item
in the transaction, when the commit record arrives
(xlog_recover_commit_trans()). Verify the item at both of those points
with xlog_recover_verify_item(): confirm it received all its declared
regions, and run the item type's verifier if one is provided. Item types
opt in with a new xlog_recover_item_ops->verify method; the first, for
inode items, is added in the next patch.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Xiang Mei <xmei5@asu.edu>
Suggested-by: Dave Chinner <dgc@kernel.org>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
 fs/xfs/libxfs/xfs_log_recover.h |  9 ++++++++
 fs/xfs/xfs_log_recover.c        | 41 ++++++++++++++++++++++++++++++++-
 2 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 77f51afcbd9c..c7c93c65f60a 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -41,6 +41,15 @@ struct xlog_recover_item_ops {
 	 */
 	enum xlog_recover_reorder (*reorder)(struct xlog_recover_item *item);
 
+	/*
+	 * Comprehensively validate a fully decoded item's formatted log
+	 * structures, if provided: the region count and sizes the item type
+	 * requires, and any header fields that can be checked without the
+	 * on-disk buffer.  Called once the item is complete, before it is
+	 * queued for replay.  Returning an error aborts recovery.
+	 */
+	int (*verify)(struct xlog *log, struct xlog_recover_item *item);
+
 	/* Start readahead for pass2, if provided. */
 	void (*ra_pass2)(struct xlog *log, struct xlog_recover_item *item);
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 41fa029054d3..956599b73b16 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1997,6 +1997,9 @@ xlog_recover_items_pass2(
 	return error;
 }
 
+STATIC int xlog_recover_verify_item(struct xlog *log,
+		struct xlog_recover_item *item);
+
 /*
  * Perform the transaction.
  *
@@ -2021,6 +2024,18 @@ xlog_recover_commit_trans(
 
 	hlist_del_init(&trans->r_list);
 
+	/*
+	 * The final item is completed by the commit record rather than by a
+	 * following item, so no decode step has verified it yet; do so now.
+	 */
+	if (!list_empty(&trans->r_itemq)) {
+		item = list_entry(trans->r_itemq.prev,
+				  struct xlog_recover_item, ri_list);
+		error = xlog_recover_verify_item(log, item);
+		if (error)
+			return error;
+	}
+
 	xlog_recover_reorder_trans(log, trans, pass);
 
 	list_for_each_entry_safe(item, next, &trans->r_itemq, ri_list) {
@@ -2164,6 +2179,25 @@ xlog_recover_verify_item_header(
 	return 0;
 }
 
+/*
+ * A fully decoded item has received all its declared regions.  Check it is
+ * complete and run the type's verifier, if any, before it is queued for
+ * replay.
+ */
+STATIC int
+xlog_recover_verify_item(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	if (XFS_IS_CORRUPT(log->l_mp,
+			item->ri_total == 0 || item->ri_cnt != item->ri_total))
+		return -EFSCORRUPTED;
+
+	if (item->ri_ops->verify)
+		return item->ri_ops->verify(log, item);
+	return 0;
+}
+
 /*
  * The next region to add is the start of a new region.  It could be
  * a whole region or it could be the first part of a new region.  Because
@@ -2226,7 +2260,12 @@ xlog_recover_add_to_trans(
 			  ri_list);
 	if (item->ri_total != 0 &&
 	     item->ri_total == item->ri_cnt) {
-		/* tail item is in use, get a new one */
+		/* the tail item is complete; verify it before starting a new one */
+		error = xlog_recover_verify_item(log, item);
+		if (error) {
+			kvfree(ptr);
+			return error;
+		}
 		xlog_recover_add_item(&trans->r_itemq);
 		item = list_entry(trans->r_itemq.prev,
 					struct xlog_recover_item, ri_list);
-- 
2.43.0

