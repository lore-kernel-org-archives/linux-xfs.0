Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B228248C
	for <linux-xfs@vger.kernel.org>; Wed, 19 Jun 2024 10:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718791642; cv=none; b=SuTDUZ32xlrlyjLrMPpkFV6RlTgT3Z75fh7ErPKTNbUyychVOvJXU8IP3QHjrSBkZ1bdAjMgTHT87/XdWlRJVhRw8lbY/n0e+yPDS2aL9ZHuvyloUal2jGH6uu4o2IihikPb6nW74/Si4HN3UskpA+AyBKksKMNZoeztyKrJiNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718791642; c=relaxed/simple;
	bh=twyqrx/CE2OPi8Q85P2P/UZ8KtlTCtC2Gs3Acvkb3vs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qx5/TFPSQ4BgQx5C+RBqDXUbRM5sf6wF/blgRAu27kuznKNnlRsZwR7eucoi+82LAfZEdaH9EeHEpxB6bor8Nsrxwd74BeeDaPwp2kSoFF96vUs9ynFJFeI9TaDaOPeWoZejbJYzxUy3XxGn8AKgUJTkgUv5Fb6mAIttr1b2dPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nMo7KZCm; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nMo7KZCm"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-70631cd9e50so517477b3a.0
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jun 2024 03:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718791639; x=1719396439; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7MlN1Nd85/VRCwil5Mwq2nQYEf2Vi7uJ8bpCaOOvuHg=;
        b=nMo7KZCmxwuw2Z4q5D1e2r0aNJgqCw4C/T6tw0O4hD9JR28Re+i0EB8e2cZo/OmBI7
         uR457kVTjHQGwxFeCKyUK+0+Qigs7nWrVRyqKSoFz+QtQW80iCKGxR10wXZbkskg8nmz
         Q3xGuJ52KQDnie3kHNxny7eww/921x9yM6M3kIHljeh+o7Q/xMBBT6JtzKkWBLKy8kJj
         QFKNpT452ynYr06wMLw4nTHKsMA5aCW7QHkuyKQM8JmRmzo0ET1YbAgh9Y+2SWLnUcRW
         uYhzOXGe7u4XN9CpdoNvr/9AEqkS49V18ubFv3Lrlxr5ACW9ZQuc+ebP0HOA+M71/EY9
         vN1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718791639; x=1719396439;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7MlN1Nd85/VRCwil5Mwq2nQYEf2Vi7uJ8bpCaOOvuHg=;
        b=P4ub3cBowdB0/a1MUGLVAxF033TEcU7rdL+vTDttVi/nVphzBNZg0dtCESV6Dx4hQd
         R2c0dS7yn6GafGgRv7mV1vdFYPQ9QlWTUUlfXZ6XGa3dGJzI+eH6Jib2YrljIvXIKzI6
         uxqB9780Gf/iKrQORRoi4HXDMzmkB0TslayeCQ5gLHMgpZXvrqb/JLaODfd4PeELM5Gh
         06LsyPeb6HL/jQuOzS/D6vwX5e/dzxYp1drBZQAZV2Eul9iHOekCsIPMGLZ2wu3zykB3
         VVjJryXwH3GAOFitq13bqDnBAMquOlEqQ3aQ9hvp5hL6z+0XRQdwZ5HHLXfv/i3Z/YM5
         aEpA==
X-Gm-Message-State: AOJu0Yw/psu7oxtXAur3fcyBN0ZSfm510uQUQAVxEzGSO4geXwhTWm37
	RVJ9xlg7NCfh2JQUEZi8nVHXcB6fYqZMImf6pi1x814w8gbDarb+nvEiYtz+9y4=
X-Google-Smtp-Source: AGHT+IHye+0qLXdVvOaBABeqk2pK4uwtA14PbsEmt6MNZmlTcttgZH/fxvbUIZmybyzGCMDYOD/6Ng==
X-Received: by 2002:a05:6a20:2a2f:b0:1b8:6ed5:a92 with SMTP id adf61e73a8af0-1bcbb655bb8mr1883298637.39.1718791639479;
        Wed, 19 Jun 2024 03:07:19 -0700 (PDT)
Received: from localhost ([123.113.109.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f855ee7f04sm113088225ad.151.2024.06.19.03.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jun 2024 03:07:18 -0700 (PDT)
From: Junchao Sun <sunjunchao2870@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: chandan.babu@oracle.com,
	djwong@kernel.org,
	willy@infradead.org,
	Junchao Sun <sunjunchao2870@gmail.com>
Subject: [PATCH v2] xfs: reorder xfs_inode structure elements to remove unneeded padding.
Date: Wed, 19 Jun 2024 18:06:37 +0800
Message-Id: <20240619100637.392329-1-sunjunchao2870@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

By reordering the elements in the xfs_inode structure, we can
reduce the padding needed on an x86_64 system by 8 bytes.

Furthermore, it also enables denser packing of xfs_inode
structures within slab pages. In the Debian 6.8.12-amd64,
before applying the patch, the size of xfs_inode is 1000 bytes,
allowing 32 xfs_inode structures to be allocated from an
order-3 slab. After applying the patch, the size of
xfs_inode is reduced to 992 bytes, allowing 33 xfs_inode
structures to be allocated from an order-3 slab.

This improvement is also observed in the mainline kernel
with the same config.

Signed-off-by: Junchao Sun <sunjunchao2870@gmail.com>
---
 fs/xfs/xfs_inode.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 292b90b5f2ac..fedac2792a38 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -37,12 +37,6 @@ typedef struct xfs_inode {
 	struct xfs_ifork	i_df;		/* data fork */
 	struct xfs_ifork	i_af;		/* attribute fork */
 
-	/* Transaction and locking information. */
-	struct xfs_inode_log_item *i_itemp;	/* logging information */
-	struct rw_semaphore	i_lock;		/* inode lock */
-	atomic_t		i_pincount;	/* inode pin count */
-	struct llist_node	i_gclist;	/* deferred inactivation list */
-
 	/*
 	 * Bitsets of inode metadata that have been checked and/or are sick.
 	 * Callers must hold i_flags_lock before accessing this field.
@@ -88,6 +82,12 @@ typedef struct xfs_inode {
 	/* VFS inode */
 	struct inode		i_vnode;	/* embedded VFS inode */
 
+	/* Transaction and locking information. */
+	struct xfs_inode_log_item *i_itemp;	/* logging information */
+	struct rw_semaphore	i_lock;		/* inode lock */
+	struct llist_node	i_gclist;	/* deferred inactivation list */
+	atomic_t		i_pincount;	/* inode pin count */
+
 	/* pending io completions */
 	spinlock_t		i_ioend_lock;
 	struct work_struct	i_ioend_work;
-- 
2.39.2

