Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04DD176FB1
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772496886; cv=none; b=O30uZ2vJsJ16xzC/ltYdQfMkB1r82MGnKLeIkzV5YyWSUe1vJDA7IXDR1d5uQWWivWBe4N4f95GHClqCcC46BjkT4z9DkJ+3HOA2xzV32uFFXHh/+yM0TSkHFnABnigREhWcnRMHJIdRAPysDU+CV4G26BcbZ296xKPoFKXpGNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772496886; c=relaxed/simple;
	bh=A/188eQSg6Izlh4t7DV7ltpRRHl0aR3boj37W6y2P+4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nRSPC6Pyvctc1n+/AAd5r2xcGDBGFEhOMXxY5cEieDTxIomCQEzoECTl4qWZPGcr8hjvGFgo7392RuMyo84KUpqNTQv23MDamG9v9k4K2opKZoy1YPw5DYH94F0ciCJC013t/HFubq9+6XO3xPl5hrXDExLLuwzT0mpkIu5XD+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hHB6Cjvz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hHB6Cjvz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA34EC19423;
	Tue,  3 Mar 2026 00:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772496885;
	bh=A/188eQSg6Izlh4t7DV7ltpRRHl0aR3boj37W6y2P+4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hHB6Cjvz1U/FEtSjYc3zrlkz+lzCVOhRFikPTEFXp1JyY/AmlV6sf+m5h89KGgTId
	 0rzk8p+W6XC6inWFU6sHu2VLC0yjzGDfmrXIMVopIGQlynomZZb0Lk51Tkx6w4KVVJ
	 g1ikNFw5dnmTStldIXfawv/A7hHjwRBOIx01kIPrQnYI6WsRvp0dYwEMh1jCl4I3TB
	 ZkrPJKi7mTmGHS4kuyvGNVLaqp2tq8hUqAAScVXrqoUw5qHNtWM7zbQ3uMgr03iirL
	 IW8y+Vux80TYKtykpoX7SlYtopxKeYE2+mtJbruP2x7iYtylwR55SesQ++2k5KxcPY
	 c4gDlM2sfWU9Q==
Date: Mon, 02 Mar 2026 16:14:45 -0800
Subject: [PATCH 10/36] xfs: check if an open file is on the health monitored
 fs
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177249637959.457970.17795134556111842313.stgit@frogsfrogsfrogs>
In-Reply-To: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
References: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 8b85dc4090e1c72c6d42acd823514cce67cd54fc

Create a new ioctl for the healthmon file that checks that a given fd
points to the same filesystem that the healthmon file is monitoring.
This allows xfs_healer to check that when it reopens a mountpoint to
perform repairs, the file that it gets matches the filesystem that
generated the corruption report.

(Note that xfs_healer doesn't maintain an open fd to a filesystem that
it's monitoring so that it doesn't pin the mount.)

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 4ec1b2aede976f..a01303c5de6ce6 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -1151,6 +1151,15 @@ struct xfs_health_monitor {
 /* Initial return format version */
 #define XFS_HEALTH_MONITOR_FMT_V0	(0)
 
+/*
+ * Check that a given fd points to the same filesystem that the health monitor
+ * is monitoring.
+ */
+struct xfs_health_file_on_monitored_fs {
+	__s32		fd;
+	__u32		flags;	/* zero for now */
+};
+
 /*
  * ioctl commands that are used by Linux filesystems
  */
@@ -1191,7 +1200,8 @@ struct xfs_health_monitor {
 #define XFS_IOC_SCRUBV_METADATA	_IOWR('X', 64, struct xfs_scrub_vec_head)
 #define XFS_IOC_RTGROUP_GEOMETRY _IOWR('X', 65, struct xfs_rtgroup_geometry)
 #define XFS_IOC_HEALTH_MONITOR	_IOW ('X', 68, struct xfs_health_monitor)
-
+#define XFS_IOC_HEALTH_FD_ON_MONITORED_FS \
+				_IOW ('X', 69, struct xfs_health_file_on_monitored_fs)
 /*
  * ioctl commands that replace IRIX syssgi()'s
  */

