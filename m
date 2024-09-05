Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2CF718892D
	for <linux-xfs@vger.kernel.org>; Thu,  5 Sep 2024 18:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725560536; cv=none; b=hPrE8Iv5ZVpm7H0+K0k2B41b6ylDEiPen+NZgDqCU74nBtFsJJHv4n3Tal0IXZ8UzHRHNZBe9v1sjfWvGsxa5TdxeNLnJpnGGQOvjtBLELI8/0LeBj1KjqqQw8lsBWyXcMtpk9rX3K8R5RkuTS654lScGCk8rqm6vE7WMIcBeKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725560536; c=relaxed/simple;
	bh=q6qq7169Hq/Hf2cGfojdRbHgLExeOMKheLI3HiW/Yo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NJAuOdN9pT4g/cJSKCC/VjpNDddKkG+OqL8WX0wvXgLkNAnnPlV0LO49ShwEfk6B95FG5Z5vnHEEOiNedUsnD9hI4rLac5DqKLAk9qYtvJjox4KQsIii7XP3yTKVAmUv6jWCWrRSsHykSBfkTWdvFnXa1YVRA6h54aAHluDnN7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qf82lU5R; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qf82lU5R"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-20696938f86so11309395ad.3
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2024 11:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725560534; x=1726165334; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v5/3DIxSIUXkMvmWDVCYDFtNq6m7PQRik1oF/pZe10U=;
        b=Qf82lU5RNzhrrJljOqG0FRf4EqTiEZIA+hvzlQ8X+gfOWiySWtXTCcw3vM+86HTLaE
         t72WCzO62ZjbtSBjgiMCvod6a3O3eo1JCB7tkKKayG0/uV01hfhIwM/SeKuZpyHkeh0S
         V5ZhdJinQ72zBO87Sj6jnvU8/SW3ucv3tvAvcsodT42IaWJlMBvBPG3ZeDsNX1PdwH8+
         qHerBX4cRE5BMstmZ05rmQnwDeIoDeLnqY2Ubh0rSxNYe1cf5NxUIwFTEuoLWhqQttA7
         ryEH9x/o+zMkjD1O+r56ea5aDUSRInA91aAeZhaNF+JjvGwykeSI/oNkVRmtLk5Izaps
         ybEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725560534; x=1726165334;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v5/3DIxSIUXkMvmWDVCYDFtNq6m7PQRik1oF/pZe10U=;
        b=oAzbWTsQi2BQOh7g1Bt1G2XXd4eFm/LepKzXvwQIjLerZaH4U9sMwBMGEvI6H4oFbN
         QaMmR2tkzsM4iuoAvwNwBI/Fk2g5tg3cty4iPmnsWW1WpLyp9fLOmMLsIyqMaSy+3mCy
         /nj+r1wedJYCwrOAuLJl2cIE0jN7BQL+M7dwjNzl/XuMAdImb0nrH4rRJe3W47giuQwj
         CUrgQZb60uL5Y2tnJiuG9Z+lvB3838fXh3/nDKCFqeav4wU8iIum1fT0ehT8mOWSTKMj
         h881Kuma0F6ogG+molnk6YNF9SeZo3SPENaJ5xmuKcFFZpXEFmdzv9XxYSa6CrpJBT62
         2reA==
X-Gm-Message-State: AOJu0Yx78djlBJnH9PRRHb3/6w6tzbJ9CQZmf9ON+DAGIRxJdlCR0pO4
	3ZXa+jM3R3zLS53edIZY2kPh7bIRYDh7PpbnohxOXiWffM3FH7WOY5sMhwoM
X-Google-Smtp-Source: AGHT+IHXU+DWAX2XZfMGSDQOFShwSzczl6sa382Wgp2ZwMGWu/OlFErxaGuefhnawU2I4KeNm6fHEA==
X-Received: by 2002:a17:902:ce05:b0:206:5104:a21c with SMTP id d9443c01a7336-2065104a474mr144360285ad.20.1725560534140;
        Thu, 05 Sep 2024 11:22:14 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2da2:d734:ef56:7ccf])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206aea684f0sm31374395ad.271.2024.09.05.11.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 11:22:13 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 22/26] xfs: use i_prev_unlinked to distinguish inodes that are not on the unlinked list
Date: Thu,  5 Sep 2024 11:21:39 -0700
Message-ID: <20240905182144.2691920-23-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
In-Reply-To: <20240905182144.2691920-1-leah.rumancik@gmail.com>
References: <20240905182144.2691920-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit f12b96683d6976a3a07fdf3323277c79dbe8f6ab ]

Alter the definition of i_prev_unlinked slightly to make it more obvious
when an inode with 0 link count is not part of the iunlink bucket lists
rooted in the AGI.  This distinction is necessary because it is not
sufficient to check inode.i_nlink to decide if an inode is on the
unlinked list.  Updates to i_nlink can happen while holding only
ILOCK_EXCL, but updates to an inode's position in the AGI unlinked list
(which happen after the nlink update) requires both ILOCK_EXCL and the
AGI buffer lock.

The next few patches will make it possible to reload an entire unlinked
bucket list when we're walking the inode table or performing handle
operations and need more than the ability to iget the last inode in the
chain.

The upcoming directory repair code also needs to be able to make this
distinction to decide if a zero link count directory should be moved to
the orphanage or allowed to inactivate.  An upcoming enhancement to the
online AGI fsck code will need this distinction to check and rebuild the
AGI unlinked buckets.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_icache.c |  2 +-
 fs/xfs/xfs_inode.c  |  3 ++-
 fs/xfs/xfs_inode.h  | 20 +++++++++++++++++++-
 3 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 4b040740678c..6df826fc787c 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -113,7 +113,7 @@ xfs_inode_alloc(
 	INIT_LIST_HEAD(&ip->i_ioend_list);
 	spin_lock_init(&ip->i_ioend_lock);
 	ip->i_next_unlinked = NULLAGINO;
-	ip->i_prev_unlinked = NULLAGINO;
+	ip->i_prev_unlinked = 0;
 
 	return ip;
 }
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 8c7cbe7f47ef..8c1782a72487 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2015,6 +2015,7 @@ xfs_iunlink_insert_inode(
 	}
 
 	/* Point the head of the list to point to this inode. */
+	ip->i_prev_unlinked = NULLAGINO;
 	return xfs_iunlink_update_bucket(tp, pag, agibp, bucket_index, agino);
 }
 
@@ -2117,7 +2118,7 @@ xfs_iunlink_remove_inode(
 	}
 
 	ip->i_next_unlinked = NULLAGINO;
-	ip->i_prev_unlinked = NULLAGINO;
+	ip->i_prev_unlinked = 0;
 	return error;
 }
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 225f6f93c2fa..c0211ff2874e 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -68,8 +68,21 @@ typedef struct xfs_inode {
 	uint64_t		i_diflags2;	/* XFS_DIFLAG2_... */
 	struct timespec64	i_crtime;	/* time created */
 
-	/* unlinked list pointers */
+	/*
+	 * Unlinked list pointers.  These point to the next and previous inodes
+	 * in the AGI unlinked bucket list, respectively.  These fields can
+	 * only be updated with the AGI locked.
+	 *
+	 * i_next_unlinked caches di_next_unlinked.
+	 */
 	xfs_agino_t		i_next_unlinked;
+
+	/*
+	 * If the inode is not on an unlinked list, this field is zero.  If the
+	 * inode is the first element in an unlinked list, this field is
+	 * NULLAGINO.  Otherwise, i_prev_unlinked points to the previous inode
+	 * in the unlinked list.
+	 */
 	xfs_agino_t		i_prev_unlinked;
 
 	/* VFS inode */
@@ -81,6 +94,11 @@ typedef struct xfs_inode {
 	struct list_head	i_ioend_list;
 } xfs_inode_t;
 
+static inline bool xfs_inode_on_unlinked_list(const struct xfs_inode *ip)
+{
+	return ip->i_prev_unlinked != 0;
+}
+
 static inline bool xfs_inode_has_attr_fork(struct xfs_inode *ip)
 {
 	return ip->i_forkoff > 0;
-- 
2.46.0.598.g6f2099f65c-goog

