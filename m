Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3960043AD2
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 07:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718868141; cv=none; b=qlvu1AgYd25SBZak7am6OXUNTrQOtpXmrveqiqAs2M/HH6HvMtzICpTb3DwdVgVQdl9ZeTEzofwIj6VuZWOPKrkhKvqpnzuUlfu4OLXO36KJJbfdEEjCAzO8bKzDcI4RXAQ9H2c4TGhpcY/IpvySdyw1qd+gCdfy5uOLUc3KnWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718868141; c=relaxed/simple;
	bh=0r3RxqTYTzuHm3waHTRw0kicMZQc75UcyWX2oeh/l9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SJeO/G6QZIcj/NZ8pnSXiiQr3IM+ylY64i5AK3NLWLugGT7SJupfKVAkxro1HdS8lPwFhE/F6qDbfF23GeLgDAY71ELvLgYYq0IWdRYY3ATgZAHyeZuLRZmByJRawO8soBft2sEAr7mqeS1u96WaE3F3my9qvA2lRrHqomTX1Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xk7UZis0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xk7UZis0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=8RQKYZCp3JefLBZB47X/DDU7VahAsWlVHFU3qQrkDeE=; b=xk7UZis0PgEW7jCjGj3dB0a1y9
	ml0PoQiJpCLmNqtkxusb80AtJ25TSv/sGjftCgkpvUMwrAHzlF+VwriC83ItpdQRXz4X1ONAihT3s
	e+RWsN0pRb8V3P/YPVkvNjDdWUAye9EgewY5liYk7NuS1j1myzT3qkn7rVtpFruSCMzc50/ViG5Jt
	Bd8WgZRy98ayC9l4jowXnbB7qBl+43i53eg/VkgxcfmM+HUuXT8JQ+gIj5UG1mm7xdDtNqyPlQw/i
	xI1+IQrFkX1QkCju9OlDLAzzQrynrji8C9Omb7xjzfERNGxYZ1QGSEtdwQ7JzDYC14L3KxQpg9B7k
	bEzfc83g==;
Received: from 2a02-8389-2341-5b80-3a9c-dc0d-9615-f1ed.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3a9c:dc0d:9615:f1ed] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKC7f-00000003xet-2KKC;
	Thu, 20 Jun 2024 07:22:19 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 11/11] xfs: skip flushing log items during push
Date: Thu, 20 Jun 2024 09:21:28 +0200
Message-ID: <20240620072146.530267-12-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240620072146.530267-1-hch@lst.de>
References: <20240620072146.530267-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

From: Dave Chinner <dchinner@redhat.com>

The AIL pushing code spends a huge amount of time skipping over
items that are already marked as flushing. It is not uncommon to
see hundreds of thousands of items skipped every second due to inode
clustering marking all the inodes in a cluster as flushing when the
first one is flushed.

However, to discover an item is already flushing and should be
skipped we have to call the iop_push() method for it to try to flush
the item. For inodes (where this matters most), we have to first
check that inode is flushable first.

We can optimise this overhead away by tracking whether the log item
is flushing internally. This allows xfsaild_push() to check the log
item directly for flushing state and immediately skip the log item.
Whilst this doesn't remove the CPU cache misses for loading the log
item, it does avoid the overhead of an indirect function call
and the cache misses involved in accessing inode and
backing cluster buffer structures to determine flushing state. When
trying to flush hundreds of thousands of inodes each second, this
CPU overhead saving adds up quickly.

It's so noticeable that the biggest issue with pushing on the AIL on
fast storage becomes the 10ms back-off wait when we hit enough
pinned buffers to break out of the push loop but not enough for the
AIL pushing to be considered stuck. This limits the xfsaild to about
70% total CPU usage, and on fast storage this isn't enough to keep
the storage 100% busy.

The xfsaild will block on IO submission on slow storage and so is
self throttling - it does not need a backoff in the case where we
are really just breaking out of the walk to submit the IO we have
gathered.

Further with no backoff we don't need to gather huge delwri lists to
mitigate the impact of backoffs, so we can submit IO more frequently
and reduce the time log items spend in flushing state by breaking
out of the item push loop once we've gathered enough IO to batch
submission effectively.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c      | 1 +
 fs/xfs/xfs_inode_item.c | 6 +++++-
 fs/xfs/xfs_trans.h      | 4 +++-
 fs/xfs/xfs_trans_ail.c  | 8 +++++++-
 4 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 58fb7a5062e1e6..da611ec56f1be0 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3713,6 +3713,7 @@ xfs_iflush(
 	iip->ili_last_fields = iip->ili_fields;
 	iip->ili_fields = 0;
 	iip->ili_fsync_fields = 0;
+	set_bit(XFS_LI_FLUSHING, &iip->ili_item.li_flags);
 	spin_unlock(&iip->ili_lock);
 
 	/*
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index f28d653300d124..ba49e56820f0a7 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -933,6 +933,7 @@ xfs_iflush_finish(
 		}
 		iip->ili_last_fields = 0;
 		iip->ili_flush_lsn = 0;
+		clear_bit(XFS_LI_FLUSHING, &lip->li_flags);
 		spin_unlock(&iip->ili_lock);
 		xfs_iflags_clear(iip->ili_inode, XFS_IFLUSHING);
 		if (drop_buffer)
@@ -991,8 +992,10 @@ xfs_buf_inode_io_fail(
 {
 	struct xfs_log_item	*lip;
 
-	list_for_each_entry(lip, &bp->b_li_list, li_bio_list)
+	list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
 		set_bit(XFS_LI_FAILED, &lip->li_flags);
+		clear_bit(XFS_LI_FLUSHING, &lip->li_flags);
+	}
 }
 
 /*
@@ -1011,6 +1014,7 @@ xfs_iflush_abort_clean(
 	iip->ili_flush_lsn = 0;
 	iip->ili_item.li_buf = NULL;
 	list_del_init(&iip->ili_item.li_bio_list);
+	clear_bit(XFS_LI_FLUSHING, &iip->ili_item.li_flags);
 }
 
 /*
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 1636663707dc04..20eb6ea7ebaa04 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -58,13 +58,15 @@ struct xfs_log_item {
 #define	XFS_LI_FAILED	2
 #define	XFS_LI_DIRTY	3
 #define	XFS_LI_WHITEOUT	4
+#define	XFS_LI_FLUSHING	5
 
 #define XFS_LI_FLAGS \
 	{ (1u << XFS_LI_IN_AIL),	"IN_AIL" }, \
 	{ (1u << XFS_LI_ABORTED),	"ABORTED" }, \
 	{ (1u << XFS_LI_FAILED),	"FAILED" }, \
 	{ (1u << XFS_LI_DIRTY),		"DIRTY" }, \
-	{ (1u << XFS_LI_WHITEOUT),	"WHITEOUT" }
+	{ (1u << XFS_LI_WHITEOUT),	"WHITEOUT" }, \
+	{ (1u << XFS_LI_FLUSHING),	"FLUSHING" }
 
 struct xfs_item_ops {
 	unsigned flags;
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 6a106a05fae017..0fafcc9f3dbe44 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -512,6 +512,9 @@ xfsaild_push(
 	while ((XFS_LSN_CMP(lip->li_lsn, ailp->ail_target) <= 0)) {
 		int	lock_result;
 
+		if (test_bit(XFS_LI_FLUSHING, &lip->li_flags))
+			goto next_item;
+
 		/*
 		 * Note that iop_push may unlock and reacquire the AIL lock.  We
 		 * rely on the AIL cursor implementation to be able to deal with
@@ -581,9 +584,12 @@ xfsaild_push(
 		if (stuck > 100)
 			break;
 
+next_item:
 		lip = xfs_trans_ail_cursor_next(ailp, &cur);
 		if (lip == NULL)
 			break;
+		if (lip->li_lsn != lsn && count > 1000)
+			break;
 		lsn = lip->li_lsn;
 	}
 
@@ -620,7 +626,7 @@ xfsaild_push(
 		/*
 		 * Assume we have more work to do in a short while.
 		 */
-		tout = 10;
+		tout = 0;
 	}
 
 	return tout;
-- 
2.43.0

