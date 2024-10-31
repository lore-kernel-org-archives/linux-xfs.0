Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B3519F430
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416200; cv=none; b=Vs6lfsqtlo6vvqIIS/3x7AkSCFbZ7wC01s4NxwoP59lovx+0bq6cLa4EUwAtiYlBC20+9PY41AiTxdxqVlp07ShSS7fClgkoeizulUpm8m/yoQbnJHaLJfS16Mu94hIyCdV4rsTHQmgGKIYVuxzIp91tYf49cYpmcxizaJwtni8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416200; c=relaxed/simple;
	bh=lzVoYZzuy3JOoP9rud6PBrHJYBfHfKzj9rizo7qWaHU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U1XkqDXBOIp/DqGQblP1j/MPEaad9tXd+Y3siqNMrNoyM9kJgYQpuKVckw8SlzcFeyAkYNQpuIXrmTtvGwC7n7OolUFy2wLWC4Yy3rwR7UNDe9E5OeFiM5JI4qTJPRSAlDSmEdRUuSvhYkgTFssngcrao0RxnoAmZxA22t8qXrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YkOU/8ou; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YkOU/8ou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F44AC4CEC3;
	Thu, 31 Oct 2024 23:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416200;
	bh=lzVoYZzuy3JOoP9rud6PBrHJYBfHfKzj9rizo7qWaHU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YkOU/8ouoSKmxqOHEK/0oW/1lK8kB4PwvhSLB5GBLSCCuVLLEaeYulUh+gyGyzEuZ
	 92N3TVDZrCrSRhicXxGCaEffM30pRPZiW215tI3CP5ZZfQxQEjx9Dv8WhiYFGcDVbN
	 BKMDISd6bZakgBH6106Kc0isyZgyTqMmHeXTq9kCQp8dmQCOul0g3ckSeDk9sQ2w+F
	 HPoPtSMKDZOHS4R2sCQtnl+fcrKR67+3Kmj5F6iT25poUzhJ+HH6vEmsTRkNBkOIkk
	 3rkRYjXlsdNkMnCYKzBxDgXNuPk9uH3AMGIT9MMuJ/gTKO017oklS6p1tfVhnA0fEJ
	 Mu4Dkbn3XUazg==
Date: Thu, 31 Oct 2024 16:10:00 -0700
Subject: [PATCH 05/41] xfs: introduce new file range commit ioctls
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041565996.962545.14170969491883990692.stgit@frogsfrogsfrogs>
In-Reply-To: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
References: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 398597c3ef7fb1d8fa31491c8f4f3996cff45701

This patch introduces two more new ioctls to manage atomic updates to
file contents -- XFS_IOC_START_COMMIT and XFS_IOC_COMMIT_RANGE.  The
does, but with the additional requirement that file2 cannot have changed
since some sampling point.  The start-commit ioctl performs the sampling
of file attributes.

Note: This patch currently samples i_ctime during START_COMMIT and
checks that it hasn't changed during COMMIT_RANGE.  This isn't entirely
safe in kernels prior to 6.12 because ctime only had coarse grained
granularity and very fast updates could collide with a COMMIT_RANGE.
With the multi-granularity ctime introduced by Jeff Layton, it's now
possible to update ctime such that this does not happen.

It is critical, then, that this patch must not be backported to any
kernel that does not support fine-grained file change timestamps.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Acked-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 184ccbfe708218..860284064c5aa9 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -826,6 +826,30 @@ struct xfs_exchange_range {
 	__u64		flags;		/* see XFS_EXCHANGE_RANGE_* below */
 };
 
+/*
+ * Using the same definition of file2 as struct xfs_exchange_range, commit the
+ * contents of file1 into file2 if file2 has the same inode number, mtime, and
+ * ctime as the arguments provided to the call.  The old contents of file2 will
+ * be moved to file1.
+ *
+ * Returns -EBUSY if there isn't an exact match for the file2 fields.
+ *
+ * Filesystems must be able to restart and complete the operation even after
+ * the system goes down.
+ */
+struct xfs_commit_range {
+	__s32		file1_fd;
+	__u32		pad;		/* must be zeroes */
+	__u64		file1_offset;	/* file1 offset, bytes */
+	__u64		file2_offset;	/* file2 offset, bytes */
+	__u64		length;		/* bytes to exchange */
+
+	__u64		flags;		/* see XFS_EXCHANGE_RANGE_* below */
+
+	/* opaque file2 metadata for freshness checks */
+	__u64		file2_freshness[6];
+};
+
 /*
  * Exchange file data all the way to the ends of both files, and then exchange
  * the file sizes.  This flag can be used to replace a file's contents with a
@@ -998,6 +1022,8 @@ struct xfs_getparents_by_handle {
 #define XFS_IOC_BULKSTAT	     _IOR ('X', 127, struct xfs_bulkstat_req)
 #define XFS_IOC_INUMBERS	     _IOR ('X', 128, struct xfs_inumbers_req)
 #define XFS_IOC_EXCHANGE_RANGE	     _IOW ('X', 129, struct xfs_exchange_range)
+#define XFS_IOC_START_COMMIT	     _IOR ('X', 130, struct xfs_commit_range)
+#define XFS_IOC_COMMIT_RANGE	     _IOW ('X', 131, struct xfs_commit_range)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 

