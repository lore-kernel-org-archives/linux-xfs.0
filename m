Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3AC73A1DB
	for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 21:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714168571; cv=none; b=DsnvSTMnT9HoidFAjuSD4qQPYZbs8aa7xNgCSkRGvI2BnljpNL8SgGzDDUyVBZZ+44rJxD+XMUAdwe7cm/kKvwUAolLhllA1FY6obBUZ58z1RlhRVVgpTbCPPhIvffGp/419uZRMoYj24eqybqOjLWrttK8DHWbv7Cppur0CNro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714168571; c=relaxed/simple;
	bh=BGYxDlgEBNrM/Xk350n6qGbU6rrTMIpEK1TwomqAWzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=limw3zS9CSH67SETKZVe9SVgJq1bJPsnpiAi3i1KbsOoXntuw4LXae8wnZEqISOfN/qjyI9YHChRwWrN4RS94Edzm7J22hI5epz9D7Wpt3iDC3xQc2AAUBRuNuafLmva/uDRf75Fc25e2UElyPPQ+e/Ud/n/9PVNABOHmSkdwIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WyG2Rv9m; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WyG2Rv9m"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1e3ca4fe4cfso20198515ad.2
        for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 14:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714168569; x=1714773369; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TbMO1dyHOlYXIqVrSti+1+Ate8R8MbRlXl2H56MKL4Q=;
        b=WyG2Rv9mtKcTrAAyvhdz8biuNwO3ll52vzRngT0WF1vNCS6b9KMVEWoVkD32MuUSXZ
         ul+22yDDYkfRZ+MOFxOJqEPRmQznv/07rszYh2HyjEmkud7UJFPwQ98GmwDHSaqmX6cU
         G3zQqyeS1JwZ4DEjYaJIBh8kzHQvCBdsWFTU11cizOLsRGNQdnq2emq2ygy/0YNbYamJ
         GDwlS8DN2139aj9mpoxdbGSs5OuXFiZrVPEJGVf2sf5nahrv2HpBdn7bxxOt6y8ndw6D
         dIc+c9ZZPiQO27aIQ6UqqTkoK4Htxqsutyqysf0ENBu/WE4xV+WNehk9pZost5ZBLq0m
         u0Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714168569; x=1714773369;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TbMO1dyHOlYXIqVrSti+1+Ate8R8MbRlXl2H56MKL4Q=;
        b=ih9wgaH3FJoSFssjn9op5Htaz9NTCU2dVeW1ts1+H3byoYYP0d052zeL3W8K6ZHWgw
         Tokn9WbsDEO1hdz7m24MbSl1o83KX/jxMldeEPoeQFRZlbB6lruEvIgltCRzDzXDBwz2
         UxENwjaAs3RXooF47YPB9eb9r13S5a9HHlSvC5UqKJne4lSFY0hwGkmVk87zPBu4a61j
         U2aoqeenRH7xZ0VHQelDtdBxXOPbdJvRsiIgWbBbUUoghusNhOmOJ00jcSBCZocZGjBO
         KqT0pv45dQoM7J1ZUSgHkrhQae5P7r1mWqZz4j0pnMBEybfNwlXPaCh1dAWsb6+BfWIj
         3gqw==
X-Gm-Message-State: AOJu0Yz44+A5+lmNYFvj5UGTLNwmEihJ+iJS2sznoU2w3cW5l32lmxJH
	q/7JF2wKEZNf/KLl7CgE0m4fLBl/fpL4qPbEQUJNPoz7824H/lWA40ENCBYo
X-Google-Smtp-Source: AGHT+IFSLeSBvy/flXkWlQo3Gtu/BAoq6gQuc3hl+CJW60DE8GziX3/CsIY8cbn8NRkH4pfAUXSCXg==
X-Received: by 2002:a17:903:1208:b0:1e3:dfdc:6972 with SMTP id l8-20020a170903120800b001e3dfdc6972mr5098188plh.9.1714168568764;
        Fri, 26 Apr 2024 14:56:08 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2b3a:c37d:d273:a588])
        by smtp.gmail.com with ESMTPSA id b18-20020a170903229200b001eb2e6b14e0sm855772plh.126.2024.04.26.14.56.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 14:56:08 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	mngyadam@amazon.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Xiao Yang <yangx.jy@fujitsu.com>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 19/24] xfs: estimate post-merge refcounts correctly
Date: Fri, 26 Apr 2024 14:55:06 -0700
Message-ID: <20240426215512.2673806-20-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
In-Reply-To: <20240426215512.2673806-1-leah.rumancik@gmail.com>
References: <20240426215512.2673806-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit b25d1984aa884fc91a73a5a407b9ac976d441e9b ]

Upon enabling fsdax + reflink for XFS, xfs/179 began to report refcount
metadata corruptions after being run.  Specifically, xfs_repair noticed
single-block refcount records that could be combined but had not been.

The root cause of this is improper MAXREFCOUNT edge case handling in
xfs_refcount_merge_extents.  When we're trying to find candidates for a
refcount btree record merge, we compute the refcount attribute of the
merged record, but we fail to account for the fact that once a record
hits rc_refcount == MAXREFCOUNT, it is pinned that way forever.  Hence
the computed refcount is wrong, and we fail to merge the extents.

Fix this by adjusting the merge predicates to compute the adjusted
refcount correctly.

Fixes: 3172725814f9 ("xfs: adjust refcount of an extent of blocks in refcount btree")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Xiao Yang <yangx.jy@fujitsu.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/libxfs/xfs_refcount.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 4408893333a6..6f7ed9288fe4 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -820,6 +820,17 @@ xfs_refc_valid(
 	return rc->rc_startblock != NULLAGBLOCK;
 }
 
+static inline xfs_nlink_t
+xfs_refc_merge_refcount(
+	const struct xfs_refcount_irec	*irec,
+	enum xfs_refc_adjust_op		adjust)
+{
+	/* Once a record hits MAXREFCOUNT, it is pinned there forever */
+	if (irec->rc_refcount == MAXREFCOUNT)
+		return MAXREFCOUNT;
+	return irec->rc_refcount + adjust;
+}
+
 static inline bool
 xfs_refc_want_merge_center(
 	const struct xfs_refcount_irec	*left,
@@ -831,6 +842,7 @@ xfs_refc_want_merge_center(
 	unsigned long long		*ulenp)
 {
 	unsigned long long		ulen = left->rc_blockcount;
+	xfs_nlink_t			new_refcount;
 
 	/*
 	 * To merge with a center record, both shoulder records must be
@@ -846,9 +858,10 @@ xfs_refc_want_merge_center(
 		return false;
 
 	/* The shoulder record refcounts must match the new refcount. */
-	if (left->rc_refcount != cleft->rc_refcount + adjust)
+	new_refcount = xfs_refc_merge_refcount(cleft, adjust);
+	if (left->rc_refcount != new_refcount)
 		return false;
-	if (right->rc_refcount != cleft->rc_refcount + adjust)
+	if (right->rc_refcount != new_refcount)
 		return false;
 
 	/*
@@ -871,6 +884,7 @@ xfs_refc_want_merge_left(
 	enum xfs_refc_adjust_op		adjust)
 {
 	unsigned long long		ulen = left->rc_blockcount;
+	xfs_nlink_t			new_refcount;
 
 	/*
 	 * For a left merge, the left shoulder record must be adjacent to the
@@ -881,7 +895,8 @@ xfs_refc_want_merge_left(
 		return false;
 
 	/* Left shoulder record refcount must match the new refcount. */
-	if (left->rc_refcount != cleft->rc_refcount + adjust)
+	new_refcount = xfs_refc_merge_refcount(cleft, adjust);
+	if (left->rc_refcount != new_refcount)
 		return false;
 
 	/*
@@ -903,6 +918,7 @@ xfs_refc_want_merge_right(
 	enum xfs_refc_adjust_op		adjust)
 {
 	unsigned long long		ulen = right->rc_blockcount;
+	xfs_nlink_t			new_refcount;
 
 	/*
 	 * For a right merge, the right shoulder record must be adjacent to the
@@ -913,7 +929,8 @@ xfs_refc_want_merge_right(
 		return false;
 
 	/* Right shoulder record refcount must match the new refcount. */
-	if (right->rc_refcount != cright->rc_refcount + adjust)
+	new_refcount = xfs_refc_merge_refcount(cright, adjust);
+	if (right->rc_refcount != new_refcount)
 		return false;
 
 	/*
-- 
2.44.0.769.g3c40516874-goog

