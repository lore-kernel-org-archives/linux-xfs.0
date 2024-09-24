Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4361AC884;
	Tue, 24 Sep 2024 18:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727203169; cv=none; b=NtbDpLRsHb2rMXzHilKto8H6JMbmmkUdJRw+khEXEF13SS4wmstvXJAlhnwAaEpfFNcQJOJk8mGSdubYzsEGes6l0CQaej7CaREw6a+8adZeGHjN3O4MtzQz36m/3SsVXEoiHt20wqIIQUdym9ERuJH1U9K4BE7ueApykijg28w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727203169; c=relaxed/simple;
	bh=xn1TSxOH9t9D6ncb5xsyR6YORTVeRRBLGHiIjk38a8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FZroNLDAxx/98TxfIP28Uh+aKMy7O1bVybY151Tv8hYj0P6Ue8ASrksdRQ24u+8pnksTbjID4zstdkNvy8Yo4RoaccCwgVKZAXXlBb+2OVn7lSskvti1nwuA5WNmCQbSvy6HYE2sgW9opS+B1e7yYgArUCHeu+zgyHt3lFlQ0K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LeIF2BZS; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LeIF2BZS"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-7d916b6a73aso3708468a12.1;
        Tue, 24 Sep 2024 11:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727203167; x=1727807967; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BZUeJe/rRA7SJET1iqfLUgqNK6rrqLShtm4GagY4nYk=;
        b=LeIF2BZSrpF65XRPtekXpqZuFmIR/NBFfXj0Lt+0n6BofKyXw3DXi7IYydoqpQ6qlV
         YeDfpbXac59g6qWghYg53qzW8WZ8mIx7RCuh00NxpTAuBRJ4TN9Lnlt4BHQSamidgdzW
         czIRo8nOP5fbNcsgssYmAt2CSkczzwtB7QKMWa67bx29O93Q1e+yNoEFV0IUlKOGxXbE
         5a3bkKGHR2uwYBt7gomN9PfGqThnQJMFVLvJH8epLJp0ucMhsAIQ/P9tvG7ou+Z3kGQg
         fQ0NlWsgqEUat8ZcKHS3gbIO6xm7lPADkXD5eCkfv2EJd0zFK/8og5QTrt78WWaWBBqK
         LnrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727203167; x=1727807967;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BZUeJe/rRA7SJET1iqfLUgqNK6rrqLShtm4GagY4nYk=;
        b=HXOVng+zghvj3jvNQfghgAhy1l3qdOOH49yYS63z34Xj+XHH3Sc/agl4XqMptQUlzO
         /xapHp7sbOdG8askWS3azMnFDKcfYsDRqdhywwCtiEiCxFXI2iR3o7qj0lItrVqar+Ge
         n5crLa+u2r2b80WAA/SOYd2aHbxHqZgyFpziZ8zCuQuxu40iDvDyCda8gpbW0C3sgdt/
         Ys+IBmccIrvuobgVEL6mtYKOEP2UBg/gII5VyZ1uy8NJ6IsOOVkANdsqjDnqApwi9Mks
         /4Szxg6JwjZufpDsOFPh3mbJCyqsii1w+6/NIRnPuASPiiEs7B9LazPtbHMM6FLwZn4R
         +AtQ==
X-Gm-Message-State: AOJu0YzamEW3firlVEXANRTNAYEU8AdlOYbRcH7/QMJbN/w5l6D7uyx6
	a5oslkSqBtk3mq6ndf7c/mGgUCJb4agowZvUw+0r0rQsafOs69Y+QiJGDWDl
X-Google-Smtp-Source: AGHT+IGb1dWKCpGdqgojkJahejDdLsMckptxWWQmqFAfxOdlXze9MbjgfgdqYzNSX50EIbc0+Z0AzQ==
X-Received: by 2002:a17:90b:c12:b0:2c9:6a38:54e4 with SMTP id 98e67ed59e1d1-2e06b0029fcmr65779a91.41.1727203166628;
        Tue, 24 Sep 2024 11:39:26 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:3987:6b77:4621:58ca])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dd6ef93b2fsm11644349a91.49.2024.09.24.11.39.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 11:39:26 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	cem@kernel.org,
	catherine.hoang@oracle.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 22/26] xfs: use i_prev_unlinked to distinguish inodes that are not on the unlinked list
Date: Tue, 24 Sep 2024 11:38:47 -0700
Message-ID: <20240924183851.1901667-23-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.792.g87dc391469-goog
In-Reply-To: <20240924183851.1901667-1-leah.rumancik@gmail.com>
References: <20240924183851.1901667-1-leah.rumancik@gmail.com>
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
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
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
2.46.0.792.g87dc391469-goog

