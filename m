Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E6A3EA962
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 10:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782814000; cv=none; b=PaYo7FIGBmQJvXa0nneRKYM+KJzRxig5SpOsdWd710Te3dK7bpCk2JjRjXp+utIQx3QDsegQPIsQQWc1MvxjfO/CHRlhzB0V/bpiWmpkYYglxKxvMS5BhfZoiT+Hux6uiz/Ad+jvc3v3p6Ltqk1GXHoYRi93T5SueSXkhBQKmnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782814000; c=relaxed/simple;
	bh=jLHPncpWDl0+2GMPq5aycjfL2hE5xvIsIfTOWjV86Ak=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nlcg2NfciB5ATfekA7SO0tovTsTdHCDkglcRjytnewgMrsgxG7rz5W5XxNoWrJAzX0ZOp6RO1aUpiMS2ebW/lIEyKyRYKKNR5bjXs576R2ED6Xs0oXMK1Tjk10a6xiue2thdQ291q8GfZzg+Qe9ajw8o4z3+jzdOlzhKBlRVFmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nbCkmdtv; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nbCkmdtv"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-80cbb0688c8so28670257b3.1
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 03:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782813998; x=1783418798; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sMhrCDxHf7aAooYY94uRPeuetG8ov61hCXcWeNIKwUg=;
        b=nbCkmdtvH7U3XjDz65UKLKoc1LpXnyacN4uuQciKW28jvtyioLkOVJgKznMwD6KzEJ
         5rsub8axUdBD/0Zg6cc+kHCGPqCk/OwS9tvaQn7LiWV7QrjLs3JmLlbxMW1Pnutqeo5A
         kmVnmwO9G0LeFjNw/kp0uXyC7M6d/cEt0fZK5j4VMozrqFMvb27jVLDbEa7Ofjzvpdu4
         WIXVYZKhfAvnDAKsPRAIMIMaThyEwk6s7wvRbeaGxB4SgxW1SUFHq4vkxpVNrBCGSg0b
         12gUeUoZTmmb7qgLZoutdb4dXyB5GunghT03gAnjonPAeX99H5PmNKVsu0VyMyLHlbuv
         pSfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782813998; x=1783418798;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sMhrCDxHf7aAooYY94uRPeuetG8ov61hCXcWeNIKwUg=;
        b=FWEqjlcd3jGKr6k4eRE+dMPlgIDDGer0dD/8QOi6kvNUHUo9ISOMx6i4PvUHPpXNs+
         XHWhnRxIz1i3Bf3zOkFMgI63brzQ7pZSTMUvR1MlTcPojHUOe/ozSkS3TUg1lgwYpf82
         M2LH7UO9j7mmHLtVP9rp27fNGdkBE4cCZIl4qbx4Px9prcUHSw8lIq+ETfItZA1vV879
         E3A6AbcbxMdA0BHKgmGOdAopAl+ViMAMNXl9WE0Igcek8RMaIfjHqIYMxOULOswuPOYd
         hXbJYO632KLEVAH4dcnKgaHWXjIAM6tKA6IbS22m8sDOAXeGmdLo55LbQz4zR9k1bEwK
         y3Qg==
X-Forwarded-Encrypted: i=1; AHgh+RrUmhfZ+5Yy/7ha8wgpWciz+/7ZvvrUSGKhY8LTySxF+K8VUanTT0QditYCWO/tS3oF0F5VsejQwgM=@vger.kernel.org
X-Gm-Message-State: AOJu0YweDOATtI+cNhIOpKSMB6DNcuFEklRz/6YIjTMoPSJTuY0FMU2B
	SuFxmbS6ifqllWLPI84FyUgx4UgN3WlCHbEW6TPZbjiItTS8ttHwypUv
X-Gm-Gg: AfdE7clof3eZj+TwL8Wl2QJHvgpJjFDZjmQy8wYK5o8jXa4ev3DLfCvHU2Et9WriQ8+
	1qJhkQ9cuHq1pNZMXwzbLvZ7fAvNYJdMrzraKGkBMLFgpxL6OkipXymyEPGDcMs05AZBSnLfeUB
	H9sE3cybDjOWfhuvatzhe/OpxnyXuB9ZLfkxif6v19IK1Gj6NDSUc71zQ2skGCoaRykqtgoCSJ1
	OFdWmZB3BlOpsrKPjvT+17YZKui07H/EJ4lGz97es4yR/rtIrROz+MuonfDWSqqaOMH2eatFbjG
	vEJo66G1f7bqe2RoXSzj4hNRtm5OLyIXo6k3uH/CWcwIKoa1XNqrwj980rZY4eOvOw7l5NTHV1x
	LLqR/yX/juz4ggBFASQ3QC/sHA5lp+smTsQVAKJdNjefagCBaqrfIGy03pEla36Av8wq1CNqD+l
	aIS3uckB/o22ntpC8JUaj9LAYAqKGBxGNN5WPI
X-Received: by 2002:a05:690c:e373:b0:80c:72a1:fca3 with SMTP id 00721157ae682-810d7ebe061mr34389197b3.16.1782813998261;
        Tue, 30 Jun 2026 03:06:38 -0700 (PDT)
Received: from Dev-Null-MSI ([2a0d:3344:52ac:a808:98a4:4381:be45:536f])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-810e7c6e9f3sm8837187b3.19.2026.06.30.03.06.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 03:06:37 -0700 (PDT)
From: Yousef Alhouseen <alhouseenyousef@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	syzbot+97f2c05378c5d68dcb8c@syzkaller.appspotmail.com,
	Yousef Alhouseen <alhouseenyousef@gmail.com>
Subject: [PATCH v2] xfs: zero newly allocated btree root space
Date: Tue, 30 Jun 2026 12:06:21 +0200
Message-ID: <20260630100621.7173-1-alhouseenyousef@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_broot_realloc() preserves the existing in-inode btree root while
growing its allocation, but leaves the added bytes uninitialized.  The
inode log formatter copies if_broot_bytes bytes into the journal, so those
bytes reach the log record and its CRC calculation before every location
has necessarily been overwritten by btree updates.

Request __GFP_ZERO for the initial allocation and every subsequent
allocation or reallocation, as required by krealloc() semantics.  This
keeps stale heap contents out of the filesystem log without a separate
memset after each growth.

Fixes: 6c1c55ac3c05 ("xfs: refactor the inode fork memory allocation functions")
Suggested-by: Darrick J. Wong <djwong@kernel.org>
Reported-by: syzbot+97f2c05378c5d68dcb8c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=97f2c05378c5d68dcb8c
Cc: stable@vger.kernel.org
Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
---
Changes in v2:
- Use __GFP_ZERO instead of an explicit memset after krealloc().
- Apply __GFP_ZERO consistently across the allocation lifetime.

 fs/xfs/libxfs/xfs_inode_fork.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 606a36526ce2..dc05540fa85b 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -384,7 +384,8 @@ xfs_broot_alloc(
 	ASSERT(ifp->if_broot == NULL);
 
 	ifp->if_broot = kmalloc(new_size,
-				GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
+				GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL |
+				__GFP_ZERO);
 	ifp->if_broot_bytes = new_size;
 	return ifp->if_broot;
 }
@@ -417,7 +418,8 @@ xfs_broot_realloc(
 	if (ifp->if_broot_bytes > 0 && ifp->if_broot_bytes > new_size) {
 		struct xfs_btree_block	*old_broot = ifp->if_broot;
 
-		ifp->if_broot = kmalloc(new_size, GFP_KERNEL | __GFP_NOFAIL);
+		ifp->if_broot = kmalloc(new_size,
+					GFP_KERNEL | __GFP_NOFAIL | __GFP_ZERO);
 		ifp->if_broot_bytes = new_size;
 		memcpy(ifp->if_broot, old_broot, new_size);
 		kfree(old_broot);
@@ -429,7 +431,7 @@ xfs_broot_realloc(
 	 * object.
 	 */
 	ifp->if_broot = krealloc(ifp->if_broot, new_size,
-			GFP_KERNEL | __GFP_NOFAIL);
+			GFP_KERNEL | __GFP_NOFAIL | __GFP_ZERO);
 	ifp->if_broot_bytes = new_size;
 	return ifp->if_broot;
 }
-- 
2.54.0
