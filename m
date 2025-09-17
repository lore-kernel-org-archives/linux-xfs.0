Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963C430CDA6
	for <linux-xfs@vger.kernel.org>; Wed, 17 Sep 2025 22:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758147896; cv=none; b=Hz+lLSBKqj5uj2ds8mtwij8sRnKJc6f4J0hXc4FO/gQ67Y8R1Iou95yy+Lfu2vrcfpDU2nLsUDWL1rKMAG1VSqi/a4esPe3zOB3mtbfEL2YY25P+qYIXD3pU5DSMvh1xthuPT1orQwpG+QFuB4odulQ/JQDs5FAQyxTyhSgsC7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758147896; c=relaxed/simple;
	bh=EPOF/xH8uiUGAdgfxUOBZsyNn4JbqRiUhKFkY/coZzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwV+flylx8GLLcqeeqSVySp3z16VL+to+RX0AXkKS598FTv/K8unV8OrooEfZMqhfTpniS53Z5ONtpUPZXJyXsRH64rCJekeRR5LCewwwjB/OhAdoNR2M+79ijJTnZ8ZNLAIKoRaDx87VnM8PwEPtGrFcwLQjGc87n7AffwlyKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=nBzwUzRT; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="nBzwUzRT"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-269639879c3so2551675ad.2
        for <linux-xfs@vger.kernel.org>; Wed, 17 Sep 2025 15:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1758147894; x=1758752694; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EgZN3OXFQnjpDaEEiaPr26+m3P4PKvy+vxsJ9/o6UHw=;
        b=nBzwUzRT90U8Qgd1oEt9bdXRR+S4DfzxaJjN8FOs9BeQyrHitmwXoH8szOtUXwZwXx
         BYGi3Z1zqhcWMwl83WwRLKiB1W1Fn4E1k9/6t4FVA/4ruzw4e5w6e9Ta1nNfa9oEpL09
         kp9OLNSF/K71GsuW6RsQQ1YWlHkMEzUqXqKlkmjV7Tj3hd+EGch8X8g4tRN65vi1xaji
         8nNLX11EbmJxTCIWQ6Mjd1+dd6dZPDKDjnRPEd+sLxRNIFjfHqZr7z18qqPXyS2yXJQd
         1oOKty5IDyBUPV9qnKo+6GWaZMOYLUVinmYEUoI8uuLUYJtk0CoN15kfI8WWhDsG4Nme
         sLsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758147894; x=1758752694;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EgZN3OXFQnjpDaEEiaPr26+m3P4PKvy+vxsJ9/o6UHw=;
        b=UdBZ4d03KgFtlJKv+uvc7LRT81D5VxDtzu3fsT4KuGQRK261Xfoxrghy6RJfO8HUjc
         dZCaWr56SpqtlCJAuZCxclLVhctFsFKxOi65Vclk4+6dUIz0dztsUjyfEtkrqrcHE5mB
         3jxEWkVfIjxnzqI/V4BhsO9aUozCLUJdZZq2beFtCY73j69GufdwRnHMzU+eid/NpGwk
         +b5+CzFJc38bMgiEQ3jHWVG1gfcEK+m+T2MC7hvCtwEIts/+09om3SnpKE9JIox6mGeJ
         QmtulSCWqsEl4UMGXaWUpOaT2t6zouhQJlKP5GPTp5+n5xezs3JhKj0WzBnNRMsxqaf/
         0eEw==
X-Gm-Message-State: AOJu0Yza1GbUdiqhnY86GTLNlmYI1p8gYUqBTU9oVFa/x68qaQVhTbtr
	wHtir7/Na9zHBT8Vmxf/tAbGpMWRFd9noZmmSIJUTB6TvmdjsrMqxWpvPQieWyMeJ9z4LP74S4j
	9duKw
X-Gm-Gg: ASbGncuLErBEpVn8jJ4YWKSK+KyHZ3hrw/8W4ZYVhI2kvPO8v0inmAkUShM/vagKisd
	hGN9r2QpEl4w0rFnwXzRFv6MniZP+SzornEqJrSekG1thSI2FIyhRNmJHuqLMWwrssSQi1X1oEm
	IqmoQxXuxlI2DoNuziDNNU26EHMEYc1x+uQt7OHQQHAF2CEC+6uYJ0IxKJsSYwrNZKEiCXD/skv
	a6KqSXIQGd0G8ZAZ+L6tJ38LZA9/DVqYstTJaz3taLC6+1lLzY+Lr2pI/2m6s246jtenfNs8wbt
	D5606chZfG6Ucki31x9bOKquoxxOlT/xh8WoaavgZOJh8V0LiDJ0hqOi/XUJSMCoUvCxBGMUjur
	Lez/ehXeTV1UCpNGl/XkaY4/cs3J09AZVuyWiFnMVf3du5is8PhOqORZk8GCgj98tqFCE3IxLWu
	33uRtW
X-Google-Smtp-Source: AGHT+IHLFZpjGeeFeSbKWsaeOCjv4V0h4w2XiBg+gbm4qYlWyvRtC2qEsd0+UOnu92Xinvw0/0wPBQ==
X-Received: by 2002:a17:902:fc44:b0:262:9c4:5470 with SMTP id d9443c01a7336-268137f232bmr44808925ad.28.1758147893655;
        Wed, 17 Sep 2025 15:24:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-26980319d02sm5443685ad.119.2025.09.17.15.24.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Sep 2025 15:24:53 -0700 (PDT)
Received: from devoid.disaster.area ([192.168.253.111])
	by dread.disaster.area with esmtp (Exim 4.98.2)
	(envelope-from <dave@fromorbit.com>)
	id 1uz0a1-00000003I2b-48h9;
	Thu, 18 Sep 2025 08:24:49 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.98.2)
	(envelope-from <dave@devoid.disaster.area>)
	id 1uz0a1-00000005a9H-3ZOf;
	Thu, 18 Sep 2025 08:24:49 +1000
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: jack@suse.cz,
	lherbolt@redhat.com
Subject: [PATCH 2/2] xfs: rework datasync tracking and execution
Date: Thu, 18 Sep 2025 08:12:54 +1000
Message-ID: <20250917222446.1329304-3-david@fromorbit.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250917222446.1329304-1-david@fromorbit.com>
References: <20250917222446.1329304-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

Jan Kara reported that the shared ILOCK held across the journal
flush during fdatasync operations slows down O_DSYNC DIO on
unwritten extents significantly. The underlying issue is that
unwritten extent conversion needs the ILOCK exclusive, whilst the
datasync operation after the extent conversion holds it shared.

Hence we cannot be flushing the journal for one IO completion whilst
at the same time doing unwritten extent conversion on another IO
completion on the same inode. This means that IO completions
lock-step, and IO performance is dependent on the journal flush
latency.

Jan demostrated that reducing the ifdatasync lock hold time can
improve O_DSYNC DIO to unwritten extents performance by 2.5x.
Discussion on that patch found issues with the method, and we
came to the conclusion that seperately tracking datasync flush
seqeunces was the best approach to solving the problem.

The fsync code uses the ILOCK to serialise against concurrent
modifications in the transaction commit phase. In a transaction
commit, there are several disjoint updates to inode log item state
that need to be considered atomically by the fsync code. These
operations are allo done under ILOCK_EXCL context:

1. ili_fsync_flags is updated in ->iop_precommit
2. i_pincount is updated in ->iop_pin before it is added to the CIL
3. ili_commit_seq is updated in ->iop_committing, after it has been
   added to the CIL

In fsync, we need to:

1. check that the inode is dirty in the journal (ipincount)
2. check that ili_fsync_flags is set
3. grab the ili_commit_seq if a journal flush is needed
4. clear the ili_fsync_flags to ensure that new modifications that
require fsync are tracked in ->iop_precommit correctly

The serialisation of ipincount/ili_commit_seq is needed
to ensure that we don't try to unnecessarily flush the journal.

The serialisation of ili_fsync_flags being set in
->iop_precommit and cleared in fsync post journal flush is
required for correctness.

Hence holding the ILOCK_SHARED in xfs_file_fsync() performs all this
serialisation for us.  Ideally, we want to remove the need to hold
the ILOCK_SHARED in xfs_file_fsync() for best performance.

We start with the observation that fsync/fdatasync() only need to
wait for operations that have been completed. Hence operations that
are still being committed have not completed and datasync operations
do not need to wait for them.

This means we can use a single point in time in the commit process
to signal "this modification is complete". This is what
->iop_committing is supposed to provide - it is the point at which
the object is unlocked after the modification has been recorded in
the CIL. Hence we could use ili_commit_seq to determine if we should
flush the journal.

In theory, we can already do this. However, in practice this will
expose an internal global CIL lock to the IO path. The ipincount()
checks optimise away the need to take this lock - if the inode is
not pinned, then it is not in the CIL and we don't need to check if
a journal flush at ili_commit_seq needs to be performed.

The reason this is needed is that the ili_commit_seq is never
cleared. Once it is set, it remains set even once the journal has
been committed and the object has been unpinned. Hence we have to
look that journal internal commit sequence state to determine if
ili_commit_seq needs to be acted on or not.

We can solve this by clearing ili_commit_seq when the inode is
unpinned. If we clear it atomically with the last unpin going away,
then we are guaranteed that new modifications will order correctly
as they add a new pin counts and we won't clear a sequence number
for an active modification in the CIL.

Further, we can then allow the per-transaction flag state to
propagate into ->iop_committing (instead of clearing it in
->iop_precommit) and that will allow us to determine if the
modification needs a full fsync or just a datasync, and so we can
record a separate datasync sequence number (Jan's idea!) and then
use that in the fdatasync path instead of the full fsync sequence
number.

With this infrastructure in place, we no longer need the
ILOCK_SHARED in the fsync path. All serialisation is done against
the commit sequence numbers - if the sequence number is set, then we
have to flush the journal. If it is not set, then we have nothing to
do. This greatly simplifies the fsync implementation....

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Tested-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_file.c       | 75 +++++++++++++++++++----------------------
 fs/xfs/xfs_inode.c      | 25 +++++++++-----
 fs/xfs/xfs_inode_item.c | 72 ++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_inode_item.h | 10 +++++-
 fs/xfs/xfs_iomap.c      | 15 +++++++--
 5 files changed, 128 insertions(+), 69 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index f96fbf5c54c9..2702fef2c90c 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -75,52 +75,47 @@ xfs_dir_fsync(
 	return xfs_log_force_inode(ip);
 }
 
-static xfs_csn_t
-xfs_fsync_seq(
-	struct xfs_inode	*ip,
-	bool			datasync)
-{
-	if (!xfs_ipincount(ip))
-		return 0;
-	if (datasync && !(ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
-		return 0;
-	return ip->i_itemp->ili_commit_seq;
-}
-
 /*
- * All metadata updates are logged, which means that we just have to flush the
- * log up to the latest LSN that touched the inode.
+ * All metadata updates are logged, which means that we just have to push the
+ * journal to the required sequence number than holds the updates. We track
+ * datasync commits separately to full sync commits, and hence only need to
+ * select the correct sequence number for the log force here.
  *
- * If we have concurrent fsync/fdatasync() calls, we need them to all block on
- * the log force before we clear the ili_fsync_fields field. This ensures that
- * we don't get a racing sync operation that does not wait for the metadata to
- * hit the journal before returning.  If we race with clearing ili_fsync_fields,
- * then all that will happen is the log force will do nothing as the lsn will
- * already be on disk.  We can't race with setting ili_fsync_fields because that
- * is done under XFS_ILOCK_EXCL, and that can't happen because we hold the lock
- * shared until after the ili_fsync_fields is cleared.
+ * We don't have to serialise against concurrent modifications, as we do not
+ * have to wait for modifications that have not yet completed. We define a
+ * transaction commit as completing when the commit sequence number is updated,
+ * hence if the sequence number has not updated, the sync operation has been
+ * run before the commit completed and we don't have to wait for it.
+ *
+ * If we have concurrent fsync/fdatasync() calls, the sequence numbers remain
+ * set on the log item until - at least - the journal flush completes. In
+ * reality, they are only cleared when the inode is fully unpinned (i.e.
+ * persistent in the journal and not dirty in the CIL), and so we rely on
+ * xfs_log_force_seq() either skipping sequences that have been persisted or
+ * waiting on sequences that are still in flight to correctly order concurrent
+ * sync operations.
  */
-static  int
+static int
 xfs_fsync_flush_log(
 	struct xfs_inode	*ip,
 	bool			datasync,
 	int			*log_flushed)
 {
-	int			error = 0;
-	xfs_csn_t		seq;
+	struct xfs_inode_log_item *iip = ip->i_itemp;
+	xfs_csn_t		seq = 0;
 
-	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	seq = xfs_fsync_seq(ip, datasync);
-	if (seq) {
-		error = xfs_log_force_seq(ip->i_mount, seq, XFS_LOG_SYNC,
+	spin_lock(&iip->ili_lock);
+	if (datasync)
+		seq = iip->ili_datasync_seq;
+	else
+		seq = iip->ili_commit_seq;
+	spin_unlock(&iip->ili_lock);
+
+	if (!seq)
+		return 0;
+
+	return xfs_log_force_seq(ip->i_mount, seq, XFS_LOG_SYNC,
 					  log_flushed);
-
-		spin_lock(&ip->i_itemp->ili_lock);
-		ip->i_itemp->ili_fsync_fields = 0;
-		spin_unlock(&ip->i_itemp->ili_lock);
-	}
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-	return error;
 }
 
 STATIC int
@@ -158,12 +153,10 @@ xfs_file_fsync(
 		error = blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
 
 	/*
-	 * Any inode that has dirty modifications in the log is pinned.  The
-	 * racy check here for a pinned inode will not catch modifications
-	 * that happen concurrently to the fsync call, but fsync semantics
-	 * only require to sync previously completed I/O.
+	 * If the inode has a inode log item attached, it may need the journal
+	 * flushed to persist any changes the log item might be tracking.
 	 */
-	if (xfs_ipincount(ip)) {
+	if (ip->i_itemp) {
 		err2 = xfs_fsync_flush_log(ip, datasync, &log_flushed);
 		if (err2 && !error)
 			error = err2;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 0ddb9ce0f5e3..b5619ed5667b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1667,7 +1667,6 @@ xfs_ifree_mark_inode_stale(
 	spin_lock(&iip->ili_lock);
 	iip->ili_last_fields = iip->ili_fields;
 	iip->ili_fields = 0;
-	iip->ili_fsync_fields = 0;
 	spin_unlock(&iip->ili_lock);
 	ASSERT(iip->ili_last_fields);
 
@@ -1832,12 +1831,20 @@ static void
 xfs_iunpin(
 	struct xfs_inode	*ip)
 {
-	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED);
+	struct xfs_inode_log_item *iip = ip->i_itemp;
+	xfs_csn_t		seq = 0;
 
 	trace_xfs_inode_unpin_nowait(ip, _RET_IP_);
+	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED);
+
+	spin_lock(&iip->ili_lock);
+	seq = iip->ili_commit_seq;
+	spin_unlock(&iip->ili_lock);
+	if (!seq)
+		return;
 
 	/* Give the log a push to start the unpinning I/O */
-	xfs_log_force_seq(ip->i_mount, ip->i_itemp->ili_commit_seq, 0, NULL);
+	xfs_log_force_seq(ip->i_mount, seq, 0, NULL);
 
 }
 
@@ -2506,7 +2513,6 @@ xfs_iflush(
 	spin_lock(&iip->ili_lock);
 	iip->ili_last_fields = iip->ili_fields;
 	iip->ili_fields = 0;
-	iip->ili_fsync_fields = 0;
 	set_bit(XFS_LI_FLUSHING, &iip->ili_item.li_flags);
 	spin_unlock(&iip->ili_lock);
 
@@ -2665,12 +2671,15 @@ int
 xfs_log_force_inode(
 	struct xfs_inode	*ip)
 {
+	struct xfs_inode_log_item *iip = ip->i_itemp;
 	xfs_csn_t		seq = 0;
 
-	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	if (xfs_ipincount(ip))
-		seq = ip->i_itemp->ili_commit_seq;
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	if (!iip)
+		return 0;
+
+	spin_lock(&iip->ili_lock);
+	seq = iip->ili_commit_seq;
+	spin_unlock(&iip->ili_lock);
 
 	if (!seq)
 		return 0;
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 318e7c68ec72..a35f43b5e768 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -187,13 +187,16 @@ xfs_inode_item_precommit(
 	}
 
 	/*
-	 * Record the specific change for fdatasync optimisation. This allows
-	 * fdatasync to skip log forces for inodes that are only timestamp
-	 * dirty. Once we've processed the XFS_ILOG_IVERSION flag, convert it
-	 * to XFS_ILOG_CORE so that the actual on-disk dirty tracking
-	 * (ili_fields) correctly tracks that the version has changed.
+	 * Store the dirty flags back into the inode item as this state is used
+	 * later on in xfs_inode_item_committing() to determine whether the
+	 * transaction is relevant to fsync state or not.
+	 */
+	iip->ili_dirty_flags = flags;
+
+	/*
+	 * Convert the flags on-disk fields that have been modified in the
+	 * transaction so that ili_fields tracks the changes correctly.
 	 */
-	iip->ili_fsync_fields |= (flags & ~XFS_ILOG_IVERSION);
 	if (flags & XFS_ILOG_IVERSION)
 		flags = ((flags & ~XFS_ILOG_IVERSION) | XFS_ILOG_CORE);
 
@@ -207,12 +210,6 @@ xfs_inode_item_precommit(
 	spin_unlock(&iip->ili_lock);
 
 	xfs_inode_item_precommit_check(ip);
-
-	/*
-	 * We are done with the log item transaction dirty state, so clear it so
-	 * that it doesn't pollute future transactions.
-	 */
-	iip->ili_dirty_flags = 0;
 	return 0;
 }
 
@@ -722,13 +719,24 @@ xfs_inode_item_unpin(
 	struct xfs_log_item	*lip,
 	int			remove)
 {
-	struct xfs_inode	*ip = INODE_ITEM(lip)->ili_inode;
+	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
+	struct xfs_inode	*ip = iip->ili_inode;
 
 	trace_xfs_inode_unpin(ip, _RET_IP_);
 	ASSERT(lip->li_buf || xfs_iflags_test(ip, XFS_ISTALE));
 	ASSERT(atomic_read(&ip->i_pincount) > 0);
-	if (atomic_dec_and_test(&ip->i_pincount))
+
+	/*
+	 * If this is the last unpin, then the inode no longer needs a journal
+	 * flush to persist it. Hence we can clear the commit sequence numbers
+	 * as a fsync/fdatasync operation on the inode at this point is a no-op.
+	 */
+	if (atomic_dec_and_lock(&ip->i_pincount, &iip->ili_lock)) {
+		iip->ili_commit_seq = 0;
+		iip->ili_datasync_seq = 0;
+		spin_unlock(&iip->ili_lock);
 		wake_up_bit(&ip->i_flags, __XFS_IPINNED_BIT);
+	}
 }
 
 STATIC uint
@@ -856,12 +864,45 @@ xfs_inode_item_committed(
 	return lsn;
 }
 
+/*
+ * The modification is now complete, so before we unlock the inode we need to
+ * update the commit sequence numbers for data integrity journal flushes. We
+ * always record the commit sequence number (ili_commit_seq) so that anything
+ * that needs a full journal sync will capture all of this modification.
+ *
+ * We then
+ * check if the changes will impact a datasync (O_DSYNC) journal flush. If the
+ * changes will require a datasync flush, then we also record the sequence in
+ * ili_datasync_seq.
+ *
+ * These commit sequence numbers will get cleared atomically with the inode being
+ * unpinned (i.e. pin count goes to zero), and so it will only be set when the
+ * inode is dirty in the journal. This removes the need for checking if the
+ * inode is pinned to determine if a journal flush is necessary, and hence
+ * removes the need for holding the ILOCK_SHARED in xfs_file_fsync() to
+ * serialise pin counts against commit sequence number updates.
+ *
+ */
 STATIC void
 xfs_inode_item_committing(
 	struct xfs_log_item	*lip,
 	xfs_csn_t		seq)
 {
-	INODE_ITEM(lip)->ili_commit_seq = seq;
+	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
+
+	spin_lock(&iip->ili_lock);
+	iip->ili_commit_seq = seq;
+	if (iip->ili_dirty_flags & ~(XFS_ILOG_IVERSION | XFS_ILOG_TIMESTAMP))
+		iip->ili_datasync_seq = seq;
+	spin_unlock(&iip->ili_lock);
+
+	/*
+	 * Clear the per-transaction dirty flags now that we have finished
+	 * recording the transaction's inode modifications in the CIL and are
+	 * about to release and (maybe) unlock the inode.
+	 */
+	iip->ili_dirty_flags = 0;
+
 	return xfs_inode_item_release(lip);
 }
 
@@ -1053,7 +1094,6 @@ xfs_iflush_abort_clean(
 {
 	iip->ili_last_fields = 0;
 	iip->ili_fields = 0;
-	iip->ili_fsync_fields = 0;
 	iip->ili_flush_lsn = 0;
 	iip->ili_item.li_buf = NULL;
 	list_del_init(&iip->ili_item.li_bio_list);
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index ba92ce11a011..2ddcca41714f 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -32,9 +32,17 @@ struct xfs_inode_log_item {
 	spinlock_t		ili_lock;	   /* flush state lock */
 	unsigned int		ili_last_fields;   /* fields when flushed */
 	unsigned int		ili_fields;	   /* fields to be logged */
-	unsigned int		ili_fsync_fields;  /* logged since last fsync */
 	xfs_lsn_t		ili_flush_lsn;	   /* lsn at last flush */
+
+	/*
+	 * We record the sequence number for every inode modification, as
+	 * well as those that only require fdatasync operations for data
+	 * integrity. This allows optimisation of the O_DSYNC/fdatasync path
+	 * without needing to track what modifications the journal is currently
+	 * carrying for the inode. These are protected by the above ili_lock.
+	 */
 	xfs_csn_t		ili_commit_seq;	   /* last transaction commit */
+	xfs_csn_t		ili_datasync_seq;  /* for datasync optimisation */
 };
 
 static inline int xfs_inode_clean(struct xfs_inode *ip)
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 2a74f2957341..f8c925220005 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -149,9 +149,18 @@ xfs_bmbt_to_iomap(
 		iomap->bdev = target->bt_bdev;
 	iomap->flags = iomap_flags;
 
-	if (xfs_ipincount(ip) &&
-	    (ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
-		iomap->flags |= IOMAP_F_DIRTY;
+	/*
+	 * If the inode is dirty for datasync purposes, let iomap know so it
+	 * doesn't elide the IO completion journal flushes on O_DSYNC IO.
+	 */
+	if (ip->i_itemp) {
+		struct xfs_inode_log_item *iip = ip->i_itemp;
+
+		spin_lock(&iip->ili_lock);
+		if (iip->ili_datasync_seq)
+			iomap->flags |= IOMAP_F_DIRTY;
+		spin_unlock(&iip->ili_lock);
+	}
 
 	iomap->validity_cookie = sequence_cookie;
 	return 0;
-- 
2.50.1

