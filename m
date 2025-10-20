Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9072726FDBB
	for <linux-xfs@vger.kernel.org>; Mon, 20 Oct 2025 15:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760975106; cv=none; b=RnY6eR5X69Cn+F944k+UGnIzOD9CMBnGwBUeFuaSJnF64755R1ZDPJEPZdBqamGT+ctd8YYstlIhdOhYn2NMNVPjpvu1UGJEXLlP/JcetR1Uy4/rw/zxQECYKWQ9SlKhoiYsj2W64nW6hQaV1XMlrzbzbG5dYtyyvpUSWvHBlvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760975106; c=relaxed/simple;
	bh=rf1m2f4iUjHH0eQ1oqWqEAIfCxj+9MFyYeUboy1Tc3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k1C7nwoaDTcVtRas+28/7JQtC8xGtMzI8/FkmAR9vqsfUtQNVQwxF756LOAZKTJGvhfQZ8FrVn2AipgKxn11TVI7Jjgddx9yok5+u9zPjjbf79JK4WDzl32BSt1Ciw4GHbDjlMo+FyV2psiTiecSbGU2Ukg5ZjEeeO8KceLD7Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=foqLIjLR; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="foqLIjLR"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-33d7589774fso2067220a91.0
        for <linux-xfs@vger.kernel.org>; Mon, 20 Oct 2025 08:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760975103; x=1761579903; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BHAIL2Oax/vE44PIvxtgi5jncaQ24osFHZOKTbCofck=;
        b=foqLIjLR8wY0MWh03vs+pIVuX2QwQvcvMUoAKLGcSIXRfFmnqEjYW3QZpLdV6WiDiE
         7bhHKiOc3vduRy7UYZyf0zUVg6+uNqLeVR6aH3FxB0q7vxvvt9aeacLr2LqcgOwkqQnK
         bK01jnvIU21ImIx0TWMevOaKBJRMjjlho9iR3AqaGxqZdlYk2U7y1HrF+zmtXB2i5wX5
         dEQP47iiFyUzyElvTbDdm6hiEx/sblcT1a+1zR/zZrMOKR/P9AB5MwmwJYiZ4dsf/W7G
         4kLIQQOWHJNVlGFAjH/2IeIAPcwwdhXeJ2OF196zK+d1Mx2jLAodW8gMVnjAfezZDOvQ
         fEzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760975103; x=1761579903;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BHAIL2Oax/vE44PIvxtgi5jncaQ24osFHZOKTbCofck=;
        b=a4lwSZIkkp7cn88mCdxECQ5F7iLUkYoyydjanFKrpKeXOb02qaL1tH6aW8Pkxc00wG
         uTYh7aXNRLoPlIJySoiqq/oDGaY5nv2VGgi5gVO3LI54N0H3SbyNfC3RFZwro7vRvZWR
         E8xfDrvHddiMNoNydYfiDIiZS+34aH+gC5oojUwplv7UKKqWGPQf27f4ei2StigBi63N
         1ndy6A66ZewynfXS9ZukMW+TIb50ZnK2D7DJjrZRSDzQVvQAQX3OhdqTJsgMmZ/aKzuQ
         nwFxv+1l+5MejNU2grkP8cXATxdFdKqzViDz/i3i3YDE3Ink1i5HezpOBi21M9B7TzKJ
         uuxw==
X-Gm-Message-State: AOJu0YxefAm/3ha6I/qUSFerpRq9gYasKBkaliY3YjfhRy4JJjK/3Uf0
	5qYpRJiDcT4J7CldvDN8PHMoy+BypI24ndIMF7GfhFV21EcgsgNrvEO1eA3ArA==
X-Gm-Gg: ASbGncueJZcB6a6PKtNulQc/Nqa1P2ufHMjNbHXdSkOOBCKrToGmBde+Ze3Z6h9kfTn
	fv48S+JX6N+BmBhYFUxTqET9RupRYKHgc8xtYSLMjCHY4VBQqcWMy/ZwWlxkKqIetgOiSxKyoSm
	Rd9whL/DbBilF11hDloKvvbGoFnboX5xi32v6TL+qgdbCXrvISws/cf1DoE9W8+5xbM5GXIezEa
	KyEB0iXSKvpmOHSz6hJ3yFWRJi99RkGAgO3ODOoHThgEssXMRmuqswty2sXWk98OUBtDm+1zZId
	zSlrEydACpXxj4Hajh2bh8ciFplv6BtNTOE78d0yEIY2niyFjHUpUqZVczXNTVYnmD2LZ8QxjU3
	LO2P3Bp59VE+uCKrb9hD/lVgRH/oc5Q1BjAWZQIqu+EPXNCbvWiZ/QsQTYa1JDeVvOsMCAjm5Ja
	h+v+wjjuzAqKEAAKJOZUmcaHICS+RGGuhID9tE9V7yRixSU4x38uLWgQ==
X-Google-Smtp-Source: AGHT+IGIOyvhnJE9FnatOR0lsh374OL5JjZ43Gg9lE3X6CXyLi9wV5LsxwFTNZUzpYU6Q8XnezZVmw==
X-Received: by 2002:a17:90b:3fc6:b0:338:3dca:e0a3 with SMTP id 98e67ed59e1d1-33bcf87f8b8mr20101003a91.16.1760975103252;
        Mon, 20 Oct 2025 08:45:03 -0700 (PDT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.204.231])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a76b73727sm8075327a12.40.2025.10.20.08.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 08:45:02 -0700 (PDT)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: nirjhar.roy.lists@gmail.com,
	ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	djwong@kernel.org,
	bfoster@redhat.com,
	david@fromorbit.com,
	hsiangkao@linux.alibaba.com
Subject: [RFC V3 1/3] xfs: Re-introduce xg_active_wq field in struct xfs_group
Date: Mon, 20 Oct 2025 21:13:42 +0530
Message-ID: <2be0b91485bbfe7392a533248e733f5ed249545c.1760640936.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1760640936.git.nirjhar.roy.lists@gmail.com>
References: <cover.1760640936.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pag_active_wq was removed in
commit 9943b4573290
	("xfs: remove the unused pag_active_wq field in struct xfs_perag")
because it was not waited upon. Re-introducing this in struct xfs_group.
This patch also replaces atomic_dec() in xfs_group_rele() with

if (atomic_dec_and_test(&xg->xg_active_ref))
	wake_up(&xg->xg_active_wq);

The reason for this change is that the online shrink code will wait
for all the active references to come down to zero before actually
starting the shrink process (only if the number of blocks that
we are trying to remove is worth 1 or more AGs).

Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_group.c | 4 +++-
 fs/xfs/libxfs/xfs_group.h | 2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_group.c b/fs/xfs/libxfs/xfs_group.c
index 792f76d2e2a0..51ef9dd9d1ed 100644
--- a/fs/xfs/libxfs/xfs_group.c
+++ b/fs/xfs/libxfs/xfs_group.c
@@ -147,7 +147,8 @@ xfs_group_rele(
 	struct xfs_group	*xg)
 {
 	trace_xfs_group_rele(xg, _RET_IP_);
-	atomic_dec(&xg->xg_active_ref);
+	if (atomic_dec_and_test(&xg->xg_active_ref))
+		wake_up(&xg->xg_active_wq);
 }
 
 void
@@ -202,6 +203,7 @@ xfs_group_insert(
 	xfs_defer_drain_init(&xg->xg_intents_drain);
 
 	/* Active ref owned by mount indicates group is online. */
+	init_waitqueue_head(&xg->xg_active_wq);
 	atomic_set(&xg->xg_active_ref, 1);
 
 	error = xa_insert(&mp->m_groups[type].xa, index, xg, GFP_KERNEL);
diff --git a/fs/xfs/libxfs/xfs_group.h b/fs/xfs/libxfs/xfs_group.h
index 4423932a2313..21361508a5b7 100644
--- a/fs/xfs/libxfs/xfs_group.h
+++ b/fs/xfs/libxfs/xfs_group.h
@@ -11,6 +11,8 @@ struct xfs_group {
 	enum xfs_group_type	xg_type;
 	atomic_t		xg_ref;		/* passive reference count */
 	atomic_t		xg_active_ref;	/* active reference count */
+	/* woken up when xg_active_ref falls to zero */
+	wait_queue_head_t	xg_active_wq;
 
 	/* Precalculated geometry info */
 	uint32_t		xg_block_count;	/* max usable gbno */
-- 
2.43.5

