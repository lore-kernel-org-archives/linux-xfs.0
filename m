Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7FC30FC1A
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 18:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774291419; cv=none; b=f0ReTEiDpYiPOBhnAzmm9PNLPnKqrINoJ6Y2sr4IuSMSV9fHyZ3UPbYkj0k0GAAxFxUR+tEtTwkjHUxEPciTkgUGaxTGHD8vGzgiKH+syGm73tTrAVnvNmrNNtjz1YRlAV1cjTIudYzpslvSU8ozPaXn695nbMU4PBN0oRIV+cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774291419; c=relaxed/simple;
	bh=g3P/Y+DcO9JylGN3U1mmgwOTfAKDoIg0NwnnLt3/aEk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vETNU81wg2ZI+0s2pghEf8VhMU1pGwK9DSQxLpv20gOcqUOIhc2PldZajhxb794cIl68mPfyJncTc6pQ5pnkwrLGYw54g1QjYKXsQcC0w2YoMZm6BandxTsTgXNBHlZJa9SegiicAtpTH73e3nxVP58GJcv52uiV6HBiz7ThctE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A9auZzjH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A9auZzjH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A042C4CEF7;
	Mon, 23 Mar 2026 18:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774291419;
	bh=g3P/Y+DcO9JylGN3U1mmgwOTfAKDoIg0NwnnLt3/aEk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=A9auZzjHQX5HC4frE1IQd3swGA6T5+LyL5ZYTcdE/cUTbA8MMWECG5kj4bT9/n3d5
	 iIIoiA/sVwi/JqKKSyYy80FVfms4m47FzB6hGvwSr9CHivDTqBjE0xAX5lNwTaID58
	 nxz2dHeOOEDKeSqS2HjJgFrgr/CSnTEq31hERbwqLbDddy4bsrk0Y+btKB+tHJT5MM
	 8WfjTgg37fQ+kBKUSjSXcwZUDxe+1fhkCHdjlSVnhLbZ8+2bOP6kZw7b598gsf8ooW
	 zuiu2EjV40W2MQPsBOzx162iWy419WC2SJ8DPwwG0Lf8x/uOTBGbI7Yxc4bUJhYc6Q
	 OckR4zWBPm/yQ==
Date: Mon, 23 Mar 2026 11:43:38 -0700
Subject: [PATCH 09/40] xfs: convey filesystem shutdown events to the health
 monitor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177429120903.2266274.4159904413848062421.stgit@frogsfrogsfrogs>
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

Source kernel commit: 74c4795e50f816dbf5cf094691fc4f95bbc729ad

Connect the filesystem shutdown code to the health monitor so that xfs
can send events about that to the xfs_healer daemon.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 04e1dcf61257d0..c8f7011a7ef8ef 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -1028,6 +1028,9 @@ struct xfs_rtgroup_geometry {
 #define XFS_HEALTH_MONITOR_TYPE_CORRUPT		(4)
 #define XFS_HEALTH_MONITOR_TYPE_HEALTHY		(5)
 
+/* filesystem shutdown */
+#define XFS_HEALTH_MONITOR_TYPE_SHUTDOWN	(6)
+
 /* lost events */
 struct xfs_health_monitor_lost {
 	__u64	count;
@@ -1054,6 +1057,20 @@ struct xfs_health_monitor_inode {
 	__u64	ino;
 };
 
+/* shutdown reasons */
+#define XFS_HEALTH_SHUTDOWN_META_IO_ERROR	(1u << 0)
+#define XFS_HEALTH_SHUTDOWN_LOG_IO_ERROR	(1u << 1)
+#define XFS_HEALTH_SHUTDOWN_FORCE_UMOUNT	(1u << 2)
+#define XFS_HEALTH_SHUTDOWN_CORRUPT_INCORE	(1u << 3)
+#define XFS_HEALTH_SHUTDOWN_CORRUPT_ONDISK	(1u << 4)
+#define XFS_HEALTH_SHUTDOWN_DEVICE_REMOVED	(1u << 5)
+
+/* shutdown */
+struct xfs_health_monitor_shutdown {
+	/* XFS_HEALTH_SHUTDOWN_* flags */
+	__u32	reasons;
+};
+
 struct xfs_health_monitor_event {
 	/* XFS_HEALTH_MONITOR_DOMAIN_* */
 	__u32	domain;
@@ -1074,6 +1091,7 @@ struct xfs_health_monitor_event {
 		struct xfs_health_monitor_fs fs;
 		struct xfs_health_monitor_group group;
 		struct xfs_health_monitor_inode inode;
+		struct xfs_health_monitor_shutdown shutdown;
 	} e;
 
 	/* zeroes */

