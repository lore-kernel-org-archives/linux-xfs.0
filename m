Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B72A932
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772496870; cv=none; b=RlsWmeteab/2Cp+kIr+OOJhOtg0K3q/4KMVrqZcrAJPuWWa6noo/enupPeUNCnbSILfAjYq4giYuEBGQs8jyrhVtnPq16EeOAa5TVuEbTrCTgoFEwcaHvRlliF5CM5X//CmmIrP9+5SVODqbQ64KaI+4DWLmR1s3KOwKDwKLO3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772496870; c=relaxed/simple;
	bh=6KoVoYq4sYmDcG7ROkguWGneUGT7Iz7ptsYCHsozxxY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jflqyPVvcZmc8XBPtfr2R6Ha461tw7sG3I91dggMbhditrVK5XxVnAKofeeyotK9m1AXzihbsRG4XagwbuBMAYQd1Z7+xIPHZEGbZExxa1jO9yZQlWnL6EPmv80nJPGu0CzZ3aQ88gBKYxZXASoI1GBntXCAH30PR1TEFGZjZwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LJcx/XcX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LJcx/XcX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3243BC19423;
	Tue,  3 Mar 2026 00:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772496870;
	bh=6KoVoYq4sYmDcG7ROkguWGneUGT7Iz7ptsYCHsozxxY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LJcx/XcXS28YTHToR4CWzMAfsDcRVmdPdJ0m9M8lLCnu+YNkfwWcdyr8pmsFY5d/i
	 WOeSLLCBdSX/CHCoHb0SEWiQm59nFE9VKr4F727ZawBbwW+x3XmKACxz+BlsWuvt4a
	 4wmrm+6KCTa5oiaqT7qzhqssNNCawPb1dfB20OoHq8jdnlvBM93C/xO1+G+9mjtEgt
	 P/YpRRmzHem9hB0RNgr0BT+eptuW3szvgYRjIPoLfNbkTn8SEcgZUdKVXXEDoE5Wmt
	 exelwa/xa5dyGje0UaBY2KNtR4ZqL/tQgcrk9+QWfD7SBZQk7FRMvYFuNZCan9n5OB
	 rXz603w272qxA==
Date: Mon, 02 Mar 2026 16:14:29 -0800
Subject: [PATCH 09/36] xfs: convey file I/O errors to the health monitor
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177249637941.457970.16330109887717955226.stgit@frogsfrogsfrogs>
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

Source kernel commit: dfa8bad3a8796ce1ca4f1d15158e2ecfb9c5c014

Connect the fserror reporting to the health monitor so that xfs can send
events about file I/O errors to the xfs_healer daemon.  These events are
entirely informational because xfs cannot regenerate user data, so
hopefully the fsnotify I/O error event gets noticed by the relevant
management systems.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 38aeb1b0d87b5e..4ec1b2aede976f 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -1019,6 +1019,9 @@ struct xfs_rtgroup_geometry {
 #define XFS_HEALTH_MONITOR_DOMAIN_RTDEV		(6)
 #define XFS_HEALTH_MONITOR_DOMAIN_LOGDEV	(7)
 
+/* file range events */
+#define XFS_HEALTH_MONITOR_DOMAIN_FILERANGE	(8)
+
 /* Health monitor event types */
 
 /* status of the monitor itself */
@@ -1039,6 +1042,17 @@ struct xfs_rtgroup_geometry {
 /* media errors */
 #define XFS_HEALTH_MONITOR_TYPE_MEDIA_ERROR	(7)
 
+/* pagecache I/O to a file range failed */
+#define XFS_HEALTH_MONITOR_TYPE_BUFREAD		(8)
+#define XFS_HEALTH_MONITOR_TYPE_BUFWRITE	(9)
+
+/* direct I/O to a file range failed */
+#define XFS_HEALTH_MONITOR_TYPE_DIOREAD		(10)
+#define XFS_HEALTH_MONITOR_TYPE_DIOWRITE	(11)
+
+/* out of band media error reported for a file range */
+#define XFS_HEALTH_MONITOR_TYPE_DATALOST	(12)
+
 /* lost events */
 struct xfs_health_monitor_lost {
 	__u64	count;
@@ -1079,6 +1093,15 @@ struct xfs_health_monitor_shutdown {
 	__u32	reasons;
 };
 
+/* file range events */
+struct xfs_health_monitor_filerange {
+	__u64	pos;
+	__u64	len;
+	__u64	ino;
+	__u32	gen;
+	__u32	error;
+};
+
 /* disk media errors */
 struct xfs_health_monitor_media {
 	__u64	daddr;
@@ -1107,6 +1130,7 @@ struct xfs_health_monitor_event {
 		struct xfs_health_monitor_inode inode;
 		struct xfs_health_monitor_shutdown shutdown;
 		struct xfs_health_monitor_media media;
+		struct xfs_health_monitor_filerange filerange;
 	} e;
 
 	/* zeroes */

