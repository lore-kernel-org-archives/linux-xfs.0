Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941E138228A
	for <linux-xfs@vger.kernel.org>; Fri, 17 Jul 2026 19:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784316269; cv=none; b=qXgm7cKdeRUGOT8dB4SeJM2ni2ZYISpxgckZz1bFmR3VRXV8ZSvNecUf3GsSuOcnmvbUicXAmBNt/jDfAvzAwRFDqg3g49ANPe6eAeTvYRAFey6HxPMcTsGUzjjmMY5/gURZQCmIU/nxdpljvidynqAQmxqA+r1o83azUtDBa6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784316269; c=relaxed/simple;
	bh=KeKC7n/oTJyTV63b3Kr+tQ3oG2a+u/DbbZq9QhNw8gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=frMl7NNfWxDC7jFohExgO0EPtdUuv7ohEpSJp7513AgQcF7/FBchpKwEnz6D6yevedWlgH8JvR9vnqQ//m2d5FcCT+v9EP/QTWTuOOBxsO9iZghjsb+TeIZFdUiZZhj9/hH77qmGRJ6+C8sOS0PkdCLgHxhRTHA6DGEVd37oEKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=tE6YSNYf; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tE6YSNYf"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-38dfe7eb825so4066910a91.0
        for <linux-xfs@vger.kernel.org>; Fri, 17 Jul 2026 12:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784316268; x=1784921068; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UidqxNP5YgqeCULD9zL1DJ+TVbEY7ph+loZhp7Vlg48=;
        b=tE6YSNYfWKI6rzcWfv3HKWfx0kWoOi1SpLlxtEDg6BJIOC1zHMw8K7BTgoYJmJY7DU
         iZVpWdLLU706WKxzqYdnb7EyLnyZp33v6gbxIEG2DzPOgLcnCNBv7lrDxlRcTnnwof/w
         pgznmIc8UPf8WlB1TcUEBGatTYMnsqlY7T74iVZFOLiZ5v/x97c+VgLDgKy7hLR/YKkW
         2lkJPKQvOpq+Ldh6Id4FDVpLOkbHhse29m+gNb66dnIUyVnUh9trRg9jgN3fANNcQaGY
         3Vxy7UUT2RX9BCBkNwzN/7MJaUqr724xnkymD0sPYMlcwTGR3hydLohm9kFaeMNWxx/E
         WvNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784316268; x=1784921068;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UidqxNP5YgqeCULD9zL1DJ+TVbEY7ph+loZhp7Vlg48=;
        b=AO5g0jy+3awGjq64t0NwEk9+CR6z+3kRyQsyDcHflLw+18DCT67i38VZTyPo7SXp4L
         baawiYwSezST564ncuyWp+kLPbZhxdqnUJUuMrHyjeaAX/KblSMu8OFnGnsFcJruAZEk
         WgEEMOwMP/s9WKiGMX4CiZ2iw5Q7BmHnoFz1FGNkOEqFnTTDvcF85aCrvfKpU2qQxQPW
         33me3NpisyfJKOEvQ8ToCSwIsClijluq8dnq+MYPFCJey9lwdmGVoRdkafpYsp5c8oT1
         GDC0dh0kwL1z37rgVnxZ7eOkiSPcU1hFKd930fipch0bRtUccbshld2075lmNklbIFlr
         glqg==
X-Gm-Message-State: AOJu0YyKVmEqVRNUUPZIKxq+IUb5XCkq4M2Dd8yH1hiuJT8Ze/pyKLj6
	gZ98r/s1c9dW0npHvWr6B7yJDTuZiyTiw+QyM4AUw7vAzHHMRnIXA21E
X-Gm-Gg: AfdE7cks2RkQiHUhki7N/B4sTzOTECxpM7G70SXk2ecbByBUSyVktNGfYs8zfgKC534
	qYadIl3rSO7N5tOweBBe//F9KLQnuQYf9uUoblqZ4WkS7NwCEkEEmCeHpq2UjMNU4x3RwWTeuHN
	pnkwd69hv8/aUeRj6Ngzt/vv0E3tJxFsgraP932I5Nj5nPkm/3yDPpJZe7unmKBG1c8hmkCqaYU
	WKdp+pBnj+/bM53C1+1kxGMMLNv6VkCku0kPA5DXPa01Bth4nOhY6Jsu/qa7Nw6XO+RezUy9+G+
	BQrIzAKl3/vxET+/V+H+p4RP1SExHDljvSlYIGfFO0muzzq7X5SukDnZxnjNATAxOfg55951NND
	QjEyWxsM4i1GlVD/XRbVOm5gHFiNJV/bNEzV6BTSQgu8eOqpi/WUsDnBWrTYBP+731r2olGXjjy
	Lq9tLFESHU1c7wRArPzYOfhXzel40n/m/ZQymb0ysNQQPBGRQ=
X-Received: by 2002:a17:90b:264b:b0:387:e0db:bc24 with SMTP id 98e67ed59e1d1-38e4b555d20mr3795621a91.36.1784316267848;
        Fri, 17 Jul 2026 12:24:27 -0700 (PDT)
Received: from fx.tailc0aff1.ts.net ([206.206.192.132])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3142a1dde81sm18648783eec.21.2026.07.17.12.24.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 12:24:27 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xmei5@asu.edu,
	Weiming Shi <bestswngs@gmail.com>,
	Dave Chinner <dgc@kernel.org>
Subject: [PATCH v2 1/2] xfs: reject log items with missing regions during recovery
Date: Fri, 17 Jul 2026 12:24:07 -0700
Message-ID: <20260717192408.109168-2-bestswngs@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260717192408.109168-1-bestswngs@gmail.com>
References: <20260717192408.109168-1-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Each recovered log item is assembled in xlog_recover_add_to_trans() into
an ri_buf[] of ri_total (= the format's declared region count) slots, and
the regions actually logged are counted in ri_cnt. Nothing checks that
ri_cnt reached ri_total once the transaction is complete, so a crafted or
truncated log can present an item whose format declares more regions than
were logged. The trailing ri_buf[] slots are then NULL, and the reorder,
readahead and replay code dereference them.

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

Whether an item logged all its declared regions is a generic log format
property, not a per-item-type concern, so reject any item with a missing
region in xlog_recover_commit_trans() before the item ops run.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Xiang Mei <xmei5@asu.edu>
Suggested-by: Dave Chinner <dgc@kernel.org>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
 fs/xfs/xfs_log_recover.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 09e6678ca487..5250d512a392 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2039,6 +2039,17 @@ xlog_recover_commit_trans(
 
 	hlist_del_init(&trans->r_list);
 
+	/*
+	 * Reject an item missing a region its format declared; the NULL slot
+	 * would be dereferenced by the reorder and replay code.
+	 */
+	list_for_each_entry(item, &trans->r_itemq, ri_list) {
+		if (XFS_IS_CORRUPT(log->l_mp,
+				   item->ri_total == 0 ||
+				   item->ri_cnt != item->ri_total))
+			return -EFSCORRUPTED;
+	}
+
 	error = xlog_recover_reorder_trans(log, trans, pass);
 	if (error)
 		return error;
-- 
2.43.0

