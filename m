Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1F32DA76C
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 18:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774291466; cv=none; b=LJNl7XJxugWd2J4nUYYRDGUysCNjTxuoBlUUEZObb1yy+oE2NskSWAdb87raThcMdk3BcXa45DIvfpp9T1gHppM7G6dNSehZhMTf5mnz0GT4ctY3ou7OMjJFNi4pNw4C/zrmqHkUW5N4FcRt0nW8jhmMACpJtwu7p7GD1ecYLuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774291466; c=relaxed/simple;
	bh=A/188eQSg6Izlh4t7DV7ltpRRHl0aR3boj37W6y2P+4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s5CjzxTqWA2d0ZIanzqPht/NVTN97KJfCQQECJ0mjrJqc4wJ2YQnMLBTGHfUZFZHiQBQ9aLG4rYx8mB/utfPhcZKepB9DWEVguEP9XFfrElDhQBd6FCHzSTHnoZMT6DvJxOME444/ZXx7nbDoJoXpWQrNQXIyoTdqMyavi/VgPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fnh5xyDq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fnh5xyDq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354CAC4CEF7;
	Mon, 23 Mar 2026 18:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774291466;
	bh=A/188eQSg6Izlh4t7DV7ltpRRHl0aR3boj37W6y2P+4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fnh5xyDqjCU+h5XRW/APH7p7WWi/ulQByv6DA0LyUHO5aNC9p3mpC6I+RqOAc105O
	 6iq5KHa0QQUGNEuyDTEaL8MKE5NUI/DGodF3YGI+OvgSH28nD2qtEMVGqJX/IB83VD
	 XwjF9/qSHLI7SpPs9bryn6I8Ow4oIoawUUIuuf9/ySN1H5mjVFQOWEKXg18Im3o4Gm
	 vzZl1YPc+HJpqDJK7dwPjD42tpf3u8j/MrHsui2Mfv4HWB2T+ZsKpoq/tFQP8SX/nM
	 I7Ihsgxak7wuZsJGGWdca2LN/vS2jvWjN5syRnr/XsAPWjTDgPngztcH41A9ncKFvd
	 Vlcpdz5lrnrFg==
Date: Mon, 23 Mar 2026 11:44:25 -0700
Subject: [PATCH 12/40] xfs: check if an open file is on the health monitored
 fs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177429120958.2266274.12424332509701993675.stgit@frogsfrogsfrogs>
In-Reply-To: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
References: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
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

