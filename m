Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8641194AF6
	for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 22:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729548014; cv=none; b=Do4OcToedR53XZwWyZZzB+x9UlzcCK5ctlzPxHD8HPWsyDegp11OTZ6LNoO4IuDEHoldFMwdPAt6ei82YS5j+Y1ElcKBLxZtGIRFEzrKknHUE+WKQb6oIPNzZzJnIw+kO+oyzv5YN5zW3bhdj//yI15G1qSvv6raxyGZVyYzpmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729548014; c=relaxed/simple;
	bh=lzVoYZzuy3JOoP9rud6PBrHJYBfHfKzj9rizo7qWaHU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hniV19LjjCequMOLYo3tOsU/TqZBeRaHgZt8ZgjX+Joq4Boc3aeMtnSTQSL0pAuWhH8rNPCB2091zSlpEc0MVJCqccvcnQpz9kRqGIq6JNSdg/PUwmRJPZpYoDpCR7cxeQl5psuN+LU379jPQX5dLO3n7Bo+E+vbKFbJPu4/u3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FuMUgFFX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FuMUgFFX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60794C4CEC3;
	Mon, 21 Oct 2024 22:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729548014;
	bh=lzVoYZzuy3JOoP9rud6PBrHJYBfHfKzj9rizo7qWaHU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FuMUgFFX4Lw7QgOJAYJ3+dZyy/MO27GO5Lb1s9BTlQNfSJ4Zh5VR6qMY2HUjrWQ7Z
	 S/mQGaKF+xjcgFBgZ9VxRRN8auxFNum30A2cG/zIfB3z58DxVZ0JUaIR9pIM2w9rs7
	 UBU3Mj+DwkylWSbryk6988y9q/FLS4PcbeDla/klym8rvYcpGnvqzbOqRuCe3WvZij
	 WapmxpGbw2rEUZo/CEhou6whsUAhaCSdZRCXz/VOHSN0Gt0EWIfZum0N3uur2/y5SX
	 r3M9h8g0/52aItCmFL297NT1cRlUush6ixwY90TNctWyPPF8F1RS0jAtmt2GF6COwC
	 qiF9Z8TR7A7GA==
Date: Mon, 21 Oct 2024 15:00:13 -0700
Subject: [PATCH 05/37] xfs: introduce new file range commit ioctls
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172954783547.34558.563053329709168007.stgit@frogsfrogsfrogs>
In-Reply-To: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
References: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
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
 
 

