Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2855816131A;
	Wed,  1 May 2024 18:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714588899; cv=none; b=QI0pGqquFnexThl9Wx1sqiBQVt8Al8MxqYDpFJegUtSS+k+wU386AgSMhWRh+ujX7bGDUTqOzP/4DJ82na7bKUdef3rGnEX9CBp4NuMQMMj8o7xbM0HfFTJ0LETZQdKy1DyQNplccaa0bpOdRMXdhPyiCSz9GPRjHXmsQs6sDYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714588899; c=relaxed/simple;
	bh=d0l69Gcsw/vDJus6C3eaPV2ij5WC8jODHuGbI9yJ4r0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PqOwJvTzJuIg/JXv0pd+3/ps03U4MYwqVmBRPiwGQrXZN36qj3KbtBUFfLxBl5wpODFEI7YjQ+Pc1Bd1nfcX67sVMlMlMIZRMMg+C3UBHSqMZk2TDYC7m7CNbHwiHqm0eHo3+TcTAUV8sqn2UychEtVMB17eH0PRGu1jjnrrazk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gVzBpELm; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gVzBpELm"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6edc61d0ff6so7090010b3a.2;
        Wed, 01 May 2024 11:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714588897; x=1715193697; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=37Y3fWOSX//AmqHXVYxSNoGC2xonxoZ9gZAufCblsfs=;
        b=gVzBpELmZp7DiO+TNGxM54zwp7fVYDbyfq12c7OVKjmp2044IqBxKknXzUQ/XAOn7p
         oE2NKae+THolnaBCOp4yoeKVc4inwl/2qYiEIEMwOxtBcQkBPWXV3jlBCXwa/YIzCYha
         Bg133wp/elrJWs1ACkzPV71+7eIP5/1YFpvit8mIFiFb3vF1Sc2vD474LwZcH9NEcQun
         1a7MWh8la8qahQAJ7CnqCZPqoHpAU2lFXxxlr480/qVIJmWClSiRv5e0KwufninoApJ+
         +qtse3/ZISu4O9HMxvbh6YbYBoImDrroKMpN/0tlmvUAPN5e9jWZYVhp1j40wE+dBU6X
         rjrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714588897; x=1715193697;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=37Y3fWOSX//AmqHXVYxSNoGC2xonxoZ9gZAufCblsfs=;
        b=UJpzfGXSb0Ib0FlkZaAGD9liMRULRqoARZLHjU51td7UvHcOU8VXB4Yavf2WxJP38x
         frkp59Bk7+0p3vtFvjCMt8ASKrx8R8xJQkXRCLZbNoUQgIAPwyXpCm/JmVPn5hFwGGuF
         UGy6v4yubR5bwViB71OaIle2gqAyXU5IltfUTgbKbw0zcXm8hS4mXpJaobHRydgjruzi
         lvWptu0jVQkFkKc3jN0ty3ay+edDQgwMhVYvUA0vZpnn4RGhtR0AddRWTs+ueBxP81QP
         TxpyM9aZsTRweyTwtXnQI3PC5GpLRr7ckTAeX5S6S1sc2BVetMJMzXrp6AksCzOOsiFk
         SmFA==
X-Gm-Message-State: AOJu0YzuYR+s4ddkwcxpNPIh3zcovHl/A/TB9XtLN0fHRk+zmk8tsrJG
	IwgKHeR2FlB56NJPukm9njzUctGVoPLw4HHVOkxOlQrtMjj3tOWVBaQBWeNJ
X-Google-Smtp-Source: AGHT+IHTQjZfwNLL19dD33T0N6CclEHQyZVcnBhYHiJKwhpgcesop7bwmzQ4sAfu6aljZN6+1EpG5Q==
X-Received: by 2002:a05:6a20:3c8b:b0:1a3:5c61:5ec2 with SMTP id b11-20020a056a203c8b00b001a35c615ec2mr3950217pzj.16.1714588897329;
        Wed, 01 May 2024 11:41:37 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:9dbc:724d:6e88:fb08])
        by smtp.gmail.com with ESMTPSA id j18-20020a62e912000000b006e681769ee0sm23687369pfh.145.2024.05.01.11.41.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 May 2024 11:41:37 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Xiao Yang <yangx.jy@fujitsu.com>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 19/24] xfs: estimate post-merge refcounts correctly
Date: Wed,  1 May 2024 11:41:07 -0700
Message-ID: <20240501184112.3799035-19-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
In-Reply-To: <20240501184112.3799035-1-leah.rumancik@gmail.com>
References: <20240501184112.3799035-1-leah.rumancik@gmail.com>
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
Acked-by: Darrick J. Wong <djwong@kernel.org>
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
2.45.0.rc1.225.g2a3ae87e7f-goog

