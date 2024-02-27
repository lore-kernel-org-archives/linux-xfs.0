Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDD71B94E
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000546; cv=none; b=iFUeatX6kYUzJfp0e8l7ouz8eJJkb+SafubLdgj8LJHYuhtyBB7/wQZ57Q/Q0Fv6Ef6uckwMNSY5aiBI3NPeLIWDPMsuS3/SPBLzeQZA9ZRNPTG9FmuRMWMB9VdfqgQlJJWpDr9T6fqaUX+QaFhHpJI1yhnP5qL3hieS2DTxIpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000546; c=relaxed/simple;
	bh=HnxAXpPS/DL3A9Og/yEEV4YVeUgbQ4kwPiQqSZ/Lokc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t2q2uTh6LrEiMyMh7OKWfKENb6gNQ/ZdrQmpAHYsbjoFy2xtY/3kR5dkr0q3kneidI7IQjBP57bYkF4smzS4xPZiMdcIi4eZ3MwKuF1jLYHOhJAIgIHhhZcl0Mf9duvwTIsTwjksz8d6l85MXsbOHmrJogYupH288OEz0h9IWcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FP+MqTo4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FP+MqTo4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67527C433F1;
	Tue, 27 Feb 2024 02:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709000546;
	bh=HnxAXpPS/DL3A9Og/yEEV4YVeUgbQ4kwPiQqSZ/Lokc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FP+MqTo4ZtPw696QbimU9Vx8CDGJ/q7atzHBPvLIagwj72jQUNNVucKwU0VtDnv6A
	 9D2qi7npQITiLvRBruYofAcLpCnaxiTwGfHhIE6iTPScQ18N9PIvvum0UQ0J9biKA1
	 h34GYk2oJYQ7wU1CBRv1MlDChFOGF5nMVUK665u1SvDxaQtuIIqbHm5lqpyOztw5vZ
	 34ej2fStE+xxQWK20Mtk4N/OXO02FX8eEmYpPH5qGhAMnrdkhJb2OI5AbAoH/2mJbp
	 LmU4qs7MOHWzCJHw44SZO0FEEdy5l7PLxt0fA/LTJCkv5XmX2/lRg1xsWnetX/7VK4
	 /lXUaNAx4mM0g==
Date: Mon, 26 Feb 2024 18:22:26 -0800
Subject: [PATCH 06/14] xfs: bind together the front and back ends of the file
 range exchange code
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170900011741.938268.17978239071578352808.stgit@frogsfrogsfrogs>
In-Reply-To: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
References: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

So far, we've constructed the front end of the file range exchange code
that does all the checking; and the back end of the file mapping
exchange code that actually does the work.  Glue these two pieces
together so that we can turn on the functionality.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_exchrange.c |  396 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_exchrange.h |    1 
 fs/xfs/xfs_mount.h     |    5 -
 fs/xfs/xfs_trace.c     |    1 
 fs/xfs/xfs_trace.h     |  164 ++++++++++++++++++++
 5 files changed, 565 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_exchrange.c b/fs/xfs/xfs_exchrange.c
index 431adcd3e6722..741c7ae7f7895 100644
--- a/fs/xfs/xfs_exchrange.c
+++ b/fs/xfs/xfs_exchrange.c
@@ -12,8 +12,15 @@
 #include "xfs_defer.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
+#include "xfs_quota.h"
+#include "xfs_bmap_util.h"
+#include "xfs_reflink.h"
+#include "xfs_trace.h"
 #include "xfs_exchrange.h"
 #include "xfs_exchmaps.h"
+#include "xfs_sb.h"
+#include "xfs_icache.h"
+#include "xfs_log.h"
 #include <linux/fsnotify.h>
 
 /*
@@ -47,6 +54,34 @@ xfs_exchrange_possible(
 	       xfs_can_add_incompat_log_features(mp, false);
 }
 
+/*
+ * Get permission to use log-assisted atomic exchange of file mappings.
+ * Callers must not be running any transactions or hold any ILOCKs.
+ */
+int
+xfs_exchrange_enable(
+	struct xfs_mount	*mp)
+{
+	int			error = 0;
+
+	/* Mapping exchange log intent items are already enabled */
+	if (xfs_sb_version_haslogexchmaps(&mp->m_sb))
+		return 0;
+
+	if (!xfs_exchrange_upgradeable(mp))
+		return -EOPNOTSUPP;
+
+	error = xfs_add_incompat_log_feature(mp,
+			XFS_SB_FEAT_INCOMPAT_LOG_EXCHMAPS);
+	if (error)
+		return error;
+
+	xfs_warn_mount(mp, XFS_OPSTATE_WARNED_EXCHMAPS,
+ "EXPERIMENTAL atomic file range exchange feature in use. Use at your own risk!");
+
+	return 0;
+}
+
 /* Lock (and optionally join) two inodes for a file range exchange. */
 void
 xfs_exchrange_ilock(
@@ -95,6 +130,234 @@ xfs_exchrange_estimate(
 	return error;
 }
 
+/*
+ * Check that file2's metadata agree with the snapshot that we took for the
+ * range commit request.
+ *
+ * This should be called after the filesystem has locked /all/ inode metadata
+ * against modification.
+ */
+STATIC int
+xfs_exchrange_check_freshness(
+	const struct xfs_exchrange	*fxr,
+	struct xfs_inode		*ip2)
+{
+	struct inode			*inode2 = VFS_I(ip2);
+	struct timespec64		ctime = inode_get_ctime(inode2);
+	struct timespec64		mtime = inode_get_mtime(inode2);
+
+	trace_xfs_exchrange_freshness(fxr, ip2);
+
+	/* Check that file2 hasn't otherwise been modified. */
+	if (fxr->file2_ino != ip2->i_ino ||
+	    !timespec64_equal(&fxr->file2_ctime, &ctime) ||
+	    !timespec64_equal(&fxr->file2_mtime, &mtime))
+		return -EBUSY;
+
+	return 0;
+}
+
+#define QRETRY_IP1	(0x1)
+#define QRETRY_IP2	(0x2)
+
+/*
+ * Obtain a quota reservation to make sure we don't hit EDQUOT.  We can skip
+ * this if quota enforcement is disabled or if both inodes' dquots are the
+ * same.  The qretry structure must be initialized to zeroes before the first
+ * call to this function.
+ */
+STATIC int
+xfs_exchrange_reserve_quota(
+	struct xfs_trans		*tp,
+	const struct xfs_exchmaps_req	*req,
+	unsigned int			*qretry)
+{
+	int64_t				ddelta, rdelta;
+	int				ip1_error = 0;
+	int				error;
+
+	/*
+	 * Don't bother with a quota reservation if we're not enforcing them
+	 * or the two inodes have the same dquots.
+	 */
+	if (!XFS_IS_QUOTA_ON(tp->t_mountp) || req->ip1 == req->ip2 ||
+	    (req->ip1->i_udquot == req->ip2->i_udquot &&
+	     req->ip1->i_gdquot == req->ip2->i_gdquot &&
+	     req->ip1->i_pdquot == req->ip2->i_pdquot))
+		return 0;
+
+	*qretry = 0;
+
+	/*
+	 * For each file, compute the net gain in the number of regular blocks
+	 * that will be mapped into that file and reserve that much quota.  The
+	 * quota counts must be able to absorb at least that much space.
+	 */
+	ddelta = req->ip2_bcount - req->ip1_bcount;
+	rdelta = req->ip2_rtbcount - req->ip1_rtbcount;
+	if (ddelta > 0 || rdelta > 0) {
+		error = xfs_trans_reserve_quota_nblks(tp, req->ip1,
+				ddelta > 0 ? ddelta : 0,
+				rdelta > 0 ? rdelta : 0,
+				false);
+		if (error == -EDQUOT || error == -ENOSPC) {
+			/*
+			 * Save this error and see what happens if we try to
+			 * reserve quota for ip2.  Then report both.
+			 */
+			*qretry |= QRETRY_IP1;
+			ip1_error = error;
+			error = 0;
+		}
+		if (error)
+			return error;
+	}
+	if (ddelta < 0 || rdelta < 0) {
+		error = xfs_trans_reserve_quota_nblks(tp, req->ip2,
+				ddelta < 0 ? -ddelta : 0,
+				rdelta < 0 ? -rdelta : 0,
+				false);
+		if (error == -EDQUOT || error == -ENOSPC)
+			*qretry |= QRETRY_IP2;
+		if (error)
+			return error;
+	}
+	if (ip1_error)
+		return ip1_error;
+
+	/*
+	 * For each file, forcibly reserve the gross gain in mapped blocks so
+	 * that we don't trip over any quota block reservation assertions.
+	 * We must reserve the gross gain because the quota code subtracts from
+	 * bcount the number of blocks that we unmap; it does not add that
+	 * quantity back to the quota block reservation.
+	 */
+	error = xfs_trans_reserve_quota_nblks(tp, req->ip1, req->ip1_bcount,
+			req->ip1_rtbcount, true);
+	if (error)
+		return error;
+
+	return xfs_trans_reserve_quota_nblks(tp, req->ip2, req->ip2_bcount,
+			req->ip2_rtbcount, true);
+}
+
+/* Exchange the mappings (and hence the contents) of two files' forks. */
+STATIC int
+xfs_exchrange_mappings(
+	const struct xfs_exchrange	*fxr,
+	struct xfs_inode		*ip1,
+	struct xfs_inode		*ip2)
+{
+	struct xfs_mount		*mp = ip1->i_mount;
+	struct xfs_exchmaps_req		req = {
+		.ip1			= ip1,
+		.ip2			= ip2,
+		.startoff1		= XFS_B_TO_FSBT(mp, fxr->file1_offset),
+		.startoff2		= XFS_B_TO_FSBT(mp, fxr->file2_offset),
+		.blockcount		= XFS_B_TO_FSB(mp, fxr->length),
+	};
+	struct xfs_trans		*tp;
+	unsigned int			qretry;
+	bool				retried = false;
+	int				error;
+
+	trace_xfs_exchrange_mappings(fxr, ip1, ip2);
+
+	if (fxr->flags & XFS_EXCHRANGE_TO_EOF)
+		req.flags |= XFS_EXCHMAPS_SET_SIZES;
+	if (fxr->flags & XFS_EXCHRANGE_FILE1_WRITTEN)
+		req.flags |= XFS_EXCHMAPS_INO1_WRITTEN;
+
+	error = xfs_exchrange_estimate(&req);
+	if (error)
+		return error;
+
+retry:
+	/* Allocate the transaction, lock the inodes, and join them. */
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, req.resblks, 0,
+			XFS_TRANS_RES_FDBLKS, &tp);
+	if (error)
+		return error;
+
+	xfs_exchrange_ilock(tp, ip1, ip2);
+
+	trace_xfs_exchrange_before(ip2, 2);
+	trace_xfs_exchrange_before(ip1, 1);
+
+	error = xfs_exchmaps_check_forks(mp, &req);
+	if (error)
+		goto out_trans_cancel;
+
+	/*
+	 * Reserve ourselves some quota if any of them are in enforcing mode.
+	 * In theory we only need enough to satisfy the change in the number
+	 * of blocks between the two ranges being remapped.
+	 */
+	error = xfs_exchrange_reserve_quota(tp, &req, &qretry);
+	if ((error == -EDQUOT || error == -ENOSPC) && !retried) {
+		xfs_trans_cancel(tp);
+		xfs_exchrange_iunlock(ip1, ip2);
+		if (qretry & QRETRY_IP1)
+			xfs_blockgc_free_quota(ip1, 0);
+		if (qretry & QRETRY_IP2)
+			xfs_blockgc_free_quota(ip2, 0);
+		retried = true;
+		goto retry;
+	}
+	if (error)
+		goto out_trans_cancel;
+
+	/* If we got this far on a dry run, all parameters are ok. */
+	if (fxr->flags & XFS_EXCHRANGE_DRY_RUN)
+		goto out_trans_cancel;
+
+	/* Update the mtime and ctime of both files. */
+	if (fxr->flags & __XFS_EXCHRANGE_UPD_CMTIME1)
+		xfs_trans_ichgtime(tp, ip1, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+	if (fxr->flags & __XFS_EXCHRANGE_UPD_CMTIME2)
+		xfs_trans_ichgtime(tp, ip2, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+
+	xfs_exchange_mappings(tp, &req);
+
+	/*
+	 * Force the log to persist metadata updates if the caller or the
+	 * administrator requires this.  The generic prep function already
+	 * flushed the relevant parts of the page cache.
+	 */
+	if (xfs_has_wsync(mp) || (fxr->flags & XFS_EXCHRANGE_DSYNC))
+		xfs_trans_set_sync(tp);
+
+	error = xfs_trans_commit(tp);
+
+	trace_xfs_exchrange_after(ip2, 2);
+	trace_xfs_exchrange_after(ip1, 1);
+
+	if (error)
+		goto out_unlock;
+
+	/*
+	 * If the caller wanted us to exchange the contents of two complete
+	 * files of unequal length, exchange the incore sizes now.  This should
+	 * be safe because we flushed both files' page caches, exchanged all
+	 * the mappings, and updated the ondisk sizes.
+	 */
+	if (fxr->flags & XFS_EXCHRANGE_TO_EOF) {
+		loff_t	temp;
+
+		temp = i_size_read(VFS_I(ip2));
+		i_size_write(VFS_I(ip2), i_size_read(VFS_I(ip1)));
+		i_size_write(VFS_I(ip1), temp);
+	}
+
+out_unlock:
+	xfs_exchrange_iunlock(ip1, ip2);
+	return error;
+
+out_trans_cancel:
+	xfs_trans_cancel(tp);
+	goto out_unlock;
+}
+
 /*
  * Generic code for exchanging ranges of two files via XFS_IOC_EXCHANGE_RANGE.
  * This part deals with struct file objects and byte ranges and does not deal
@@ -318,6 +581,137 @@ xfs_generic_exchrange_finish(
 	return file_remove_privs(fxr->file2);
 }
 
+/* Prepare two files to have their data exchanged. */
+STATIC int
+xfs_exchrange_prep(
+	struct xfs_exchrange	*fxr,
+	struct xfs_inode	*ip1,
+	struct xfs_inode	*ip2)
+{
+	unsigned int		alloc_unit = xfs_inode_alloc_unitsize(ip2);
+	int			error;
+
+	trace_xfs_exchrange_prep(fxr, ip1, ip2);
+
+	/* Verify both files are either real-time or non-realtime */
+	if (XFS_IS_REALTIME_INODE(ip1) != XFS_IS_REALTIME_INODE(ip2))
+		return -EINVAL;
+
+	/*
+	 * The alignment checks in the generic helpers cannot deal with
+	 * allocation units that are not powers of 2.  This can happen with the
+	 * realtime volume if the extent size is set.
+	 */
+	if (!is_power_of_2(alloc_unit))
+		return -EOPNOTSUPP;
+
+	error = xfs_generic_exchrange_prep(fxr, alloc_unit);
+	if (error || fxr->length == 0)
+		return error;
+
+	if (fxr->flags & __XFS_EXCHRANGE_CHECK_FRESH2) {
+		error = xfs_exchrange_check_freshness(fxr, ip2);
+		if (error)
+			return error;
+	}
+
+	/* Attach dquots to both inodes before changing block maps. */
+	error = xfs_qm_dqattach(ip2);
+	if (error)
+		return error;
+	error = xfs_qm_dqattach(ip1);
+	if (error)
+		return error;
+
+	trace_xfs_exchrange_flush(fxr, ip1, ip2);
+
+	/* Flush the relevant ranges of both files. */
+	error = xfs_flush_unmap_range(ip2, fxr->file2_offset, fxr->length);
+	if (error)
+		return error;
+	error = xfs_flush_unmap_range(ip1, fxr->file1_offset, fxr->length);
+	if (error)
+		return error;
+
+	/*
+	 * Cancel CoW fork preallocations for the ranges of both files.  The
+	 * prep function should have flushed all the dirty data, so the only
+	 * CoW mappings remaining should be speculative.
+	 */
+	if (xfs_inode_has_cow_data(ip1)) {
+		error = xfs_reflink_cancel_cow_range(ip1, fxr->file1_offset,
+				fxr->length, true);
+		if (error)
+			return error;
+	}
+
+	if (xfs_inode_has_cow_data(ip2)) {
+		error = xfs_reflink_cancel_cow_range(ip2, fxr->file2_offset,
+				fxr->length, true);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
+/*
+ * Exchange contents of files.  This is the binding between the generic
+ * file-level concepts and the XFS inode-specific implementation.
+ */
+STATIC int
+xfs_exchrange_contents(
+	struct xfs_exchrange	*fxr)
+{
+	struct inode		*inode1 = file_inode(fxr->file1);
+	struct inode		*inode2 = file_inode(fxr->file2);
+	struct xfs_inode	*ip1 = XFS_I(inode1);
+	struct xfs_inode	*ip2 = XFS_I(inode2);
+	struct xfs_mount	*mp = ip1->i_mount;
+	int			error;
+
+	if (fxr->flags & ~(XFS_EXCHRANGE_ALL_FLAGS | XFS_EXCHRANGE_PRIVATE_FLAGS))
+		return -EINVAL;
+
+	if (xfs_is_shutdown(mp))
+		return -EIO;
+
+	/* Lock both files against IO */
+	error = xfs_ilock2_io_mmap(ip1, ip2);
+	if (error)
+		goto out_err;
+
+	/* Get permission to use log-assisted file mapping exchanges. */
+	error = xfs_exchrange_enable(mp);
+	if (error)
+		goto out_unlock;
+
+	/* Prepare and then exchange file contents. */
+	error = xfs_exchrange_prep(fxr, ip1, ip2);
+	if (error)
+		goto out_unlock;
+
+	error = xfs_exchrange_mappings(fxr, ip1, ip2);
+	if (error)
+		goto out_unlock;
+
+	/*
+	 * Finish the exchange by removing special file privileges like any
+	 * other file write would do.  This may involve turning on support for
+	 * logged xattrs if either file has security capabilities.
+	 */
+	error = xfs_generic_exchrange_finish(fxr);
+	if (error)
+		goto out_unlock;
+
+out_unlock:
+	xfs_iunlock2_io_mmap(ip1, ip2);
+out_err:
+	if (error)
+		trace_xfs_exchrange_error(ip2, error, _RET_IP_);
+	return error;
+}
+
 /* Exchange parts of two files. */
 int
 xfs_exchange_range(
@@ -375,7 +769,7 @@ xfs_exchange_range(
 		fxr->flags |= __XFS_EXCHRANGE_UPD_CMTIME2;
 
 	file_start_write(fxr->file2);
-	ret = -EOPNOTSUPP; /* XXX call out to xfs code */
+	ret = xfs_exchrange_contents(fxr);
 	file_end_write(fxr->file2);
 	if (ret)
 		return ret;
diff --git a/fs/xfs/xfs_exchrange.h b/fs/xfs/xfs_exchrange.h
index eeec4b40b9fbe..2dd9ab7d76828 100644
--- a/fs/xfs/xfs_exchrange.h
+++ b/fs/xfs/xfs_exchrange.h
@@ -7,6 +7,7 @@
 #define __XFS_EXCHRANGE_H__
 
 bool xfs_exchrange_possible(struct xfs_mount *mp);
+int xfs_exchrange_enable(struct xfs_mount *mp);
 
 /* Update the mtime/cmtime of file1 and file2 */
 #define __XFS_EXCHRANGE_UPD_CMTIME1	(1ULL << 63)
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 654d282234b1e..a567a1ac24134 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -417,6 +417,8 @@ __XFS_HAS_FEAT(nouuid, NOUUID)
 #define XFS_OPSTATE_QUOTACHECK_RUNNING	10
 /* Do we want to clear log incompat flags? */
 #define XFS_OPSTATE_UNSET_LOG_INCOMPAT	11
+/* Kernel has logged a warning about logged file mapping exchanges being used. */
+#define XFS_OPSTATE_WARNED_EXCHMAPS	12
 
 #define __XFS_IS_OPSTATE(name, NAME) \
 static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
@@ -464,7 +466,8 @@ xfs_should_warn(struct xfs_mount *mp, long nr)
 	{ (1UL << XFS_OPSTATE_WARNED_SHRINK),		"wshrink" }, \
 	{ (1UL << XFS_OPSTATE_WARNED_LARP),		"wlarp" }, \
 	{ (1UL << XFS_OPSTATE_QUOTACHECK_RUNNING),	"quotacheck" }, \
-	{ (1UL << XFS_OPSTATE_UNSET_LOG_INCOMPAT),	"unset_log_incompat" }
+	{ (1UL << XFS_OPSTATE_UNSET_LOG_INCOMPAT),	"unset_log_incompat" }, \
+	{ (1UL << XFS_OPSTATE_WARNED_EXCHMAPS),		"wexchmaps" }
 
 /*
  * Max and min values for mount-option defined I/O
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 9f38e69f1ce40..cf92a3bd56c79 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -40,6 +40,7 @@
 #include "xfs_btree_mem.h"
 #include "xfs_bmap.h"
 #include "xfs_exchmaps.h"
+#include "xfs_exchrange.h"
 
 /*
  * We include this last to have the helpers above available for the trace
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 0a56397a92373..3929022b03cfe 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -84,6 +84,7 @@ struct xfs_btree_ops;
 struct xfs_bmap_intent;
 struct xfs_exchmaps_intent;
 struct xfs_exchmaps_req;
+struct xfs_exchrange;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -4805,6 +4806,169 @@ DEFINE_INODE_IREC_EVENT(xfs_exchmaps_mapping1);
 DEFINE_INODE_IREC_EVENT(xfs_exchmaps_mapping2);
 DEFINE_ITRUNC_EVENT(xfs_exchmaps_update_inode_size);
 
+#define XFS_EXCHRANGE_INODES \
+	{ 1,	"file1" }, \
+	{ 2,	"file2" }
+
+DECLARE_EVENT_CLASS(xfs_exchrange_inode_class,
+	TP_PROTO(struct xfs_inode *ip, int whichfile),
+	TP_ARGS(ip, whichfile),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(int, whichfile)
+		__field(xfs_ino_t, ino)
+		__field(int, format)
+		__field(xfs_extnum_t, nex)
+		__field(int, broot_size)
+		__field(int, fork_off)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->whichfile = whichfile;
+		__entry->ino = ip->i_ino;
+		__entry->format = ip->i_df.if_format;
+		__entry->nex = ip->i_df.if_nextents;
+		__entry->fork_off = xfs_inode_fork_boff(ip);
+	),
+	TP_printk("dev %d:%d ino 0x%llx whichfile %s format %s num_extents %llu forkoff 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __print_symbolic(__entry->whichfile, XFS_EXCHRANGE_INODES),
+		  __print_symbolic(__entry->format, XFS_INODE_FORMAT_STR),
+		  __entry->nex,
+		  __entry->fork_off)
+)
+
+#define DEFINE_EXCHRANGE_INODE_EVENT(name) \
+DEFINE_EVENT(xfs_exchrange_inode_class, name, \
+	TP_PROTO(struct xfs_inode *ip, int whichfile), \
+	TP_ARGS(ip, whichfile))
+
+DEFINE_EXCHRANGE_INODE_EVENT(xfs_exchrange_before);
+DEFINE_EXCHRANGE_INODE_EVENT(xfs_exchrange_after);
+DEFINE_INODE_ERROR_EVENT(xfs_exchrange_error);
+
+#define XFS_EXCHRANGE_FLAGS_STRS \
+	{ XFS_EXCHRANGE_TO_EOF,		"TO_EOF" }, \
+	{ XFS_EXCHRANGE_DSYNC	,	"DSYNC" }, \
+	{ XFS_EXCHRANGE_DRY_RUN,	"DRY_RUN" }, \
+	{ XFS_EXCHRANGE_FILE1_WRITTEN,	"F1_WRITTEN" }, \
+	{ __XFS_EXCHRANGE_UPD_CMTIME1,	"CMTIME1" }, \
+	{ __XFS_EXCHRANGE_UPD_CMTIME2,	"CMTIME2" }, \
+	{ __XFS_EXCHRANGE_CHECK_FRESH2,	"FRESH2" }
+
+/* file exchange-range tracepoint class */
+DECLARE_EVENT_CLASS(xfs_exchrange_class,
+	TP_PROTO(const struct xfs_exchrange *fxr, struct xfs_inode *ip1,
+		 struct xfs_inode *ip2),
+	TP_ARGS(fxr, ip1, ip2),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ip1_ino)
+		__field(loff_t, ip1_isize)
+		__field(loff_t, ip1_disize)
+		__field(xfs_ino_t, ip2_ino)
+		__field(loff_t, ip2_isize)
+		__field(loff_t, ip2_disize)
+
+		__field(loff_t, file1_offset)
+		__field(loff_t, file2_offset)
+		__field(unsigned long long, length)
+		__field(unsigned long long, flags)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip1)->i_sb->s_dev;
+		__entry->ip1_ino = ip1->i_ino;
+		__entry->ip1_isize = VFS_I(ip1)->i_size;
+		__entry->ip1_disize = ip1->i_disk_size;
+		__entry->ip2_ino = ip2->i_ino;
+		__entry->ip2_isize = VFS_I(ip2)->i_size;
+		__entry->ip2_disize = ip2->i_disk_size;
+
+		__entry->file1_offset = fxr->file1_offset;
+		__entry->file2_offset = fxr->file2_offset;
+		__entry->length = fxr->length;
+		__entry->flags = fxr->flags;
+	),
+	TP_printk("dev %d:%d flags %s bytecount 0x%llx "
+		  "ino1 0x%llx isize 0x%llx disize 0x%llx pos 0x%llx -> "
+		  "ino2 0x%llx isize 0x%llx disize 0x%llx pos 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		   __print_flags_u64(__entry->flags, "|", XFS_EXCHRANGE_FLAGS_STRS),
+		  __entry->length,
+		  __entry->ip1_ino,
+		  __entry->ip1_isize,
+		  __entry->ip1_disize,
+		  __entry->file1_offset,
+		  __entry->ip2_ino,
+		  __entry->ip2_isize,
+		  __entry->ip2_disize,
+		  __entry->file2_offset)
+)
+
+#define DEFINE_EXCHRANGE_EVENT(name)	\
+DEFINE_EVENT(xfs_exchrange_class, name,	\
+	TP_PROTO(const struct xfs_exchrange *fxr, struct xfs_inode *ip1, \
+		 struct xfs_inode *ip2), \
+	TP_ARGS(fxr, ip1, ip2))
+DEFINE_EXCHRANGE_EVENT(xfs_exchrange_prep);
+DEFINE_EXCHRANGE_EVENT(xfs_exchrange_flush);
+DEFINE_EXCHRANGE_EVENT(xfs_exchrange_mappings);
+
+TRACE_EVENT(xfs_exchrange_freshness,
+	TP_PROTO(const struct xfs_exchrange *fxr, struct xfs_inode *ip2),
+	TP_ARGS(fxr, ip2),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ip2_ino)
+		__field(long long, ip2_mtime)
+		__field(long long, ip2_ctime)
+		__field(int, ip2_mtime_nsec)
+		__field(int, ip2_ctime_nsec)
+
+		__field(xfs_ino_t, file2_ino)
+		__field(long long, file2_mtime)
+		__field(long long, file2_ctime)
+		__field(int, file2_mtime_nsec)
+		__field(int, file2_ctime_nsec)
+	),
+	TP_fast_assign(
+		struct timespec64	ts64;
+		struct inode		*inode2 = VFS_I(ip2);
+
+		__entry->dev = inode2->i_sb->s_dev;
+		__entry->ip2_ino = ip2->i_ino;
+
+		ts64 = inode_get_ctime(inode2);
+		__entry->ip2_ctime = ts64.tv_sec;
+		__entry->ip2_ctime_nsec = ts64.tv_nsec;
+
+		ts64 = inode_get_mtime(inode2);
+		__entry->ip2_mtime = ts64.tv_sec;
+		__entry->ip2_mtime_nsec = ts64.tv_nsec;
+
+		__entry->file2_ino = fxr->file2_ino;
+		__entry->file2_mtime = fxr->file2_mtime.tv_sec;
+		__entry->file2_ctime = fxr->file2_ctime.tv_sec;
+		__entry->file2_mtime_nsec = fxr->file2_mtime.tv_nsec;
+		__entry->file2_ctime_nsec = fxr->file2_ctime.tv_nsec;
+	),
+	TP_printk("dev %d:%d "
+		  "ino 0x%llx mtime %lld:%d ctime %lld:%d -> "
+		  "file 0x%llx mtime %lld:%d ctime %lld:%d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ip2_ino,
+		  __entry->ip2_mtime,
+		  __entry->ip2_mtime_nsec,
+		  __entry->ip2_ctime,
+		  __entry->ip2_ctime_nsec,
+		  __entry->file2_ino,
+		  __entry->file2_mtime,
+		  __entry->file2_mtime_nsec,
+		  __entry->file2_ctime,
+		  __entry->file2_ctime_nsec)
+);
+
 TRACE_EVENT(xfs_exchmaps_overhead,
 	TP_PROTO(struct xfs_mount *mp, unsigned long long bmbt_blocks,
 		 unsigned long long rmapbt_blocks),

