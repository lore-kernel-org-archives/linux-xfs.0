Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0325D14AD20
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772496839; cv=none; b=sJf8H/7qKNx2fKXWb4yTfAMyzQF2iY5WjNhNRVHbpV63pBGnHIlfGvZvVvg/qpSLsq7twNA4YG9IKMurNj8In5LBn54YpHdZkhTCREGxF+GnliXBoYJpwoY7yG4wX3puo+1lU4fP0r5E1KNzHzw8XPJpbcuSCarkfktP4RVHYqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772496839; c=relaxed/simple;
	bh=g3P/Y+DcO9JylGN3U1mmgwOTfAKDoIg0NwnnLt3/aEk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lci7HbPdgPbAk2xC9EXpx/wTIIo9Tal/pJUrZUuyl0omAzUps22A7m1KSRj3hAO0L+WuA3jY6n0NG97BUt39O9JQXGTnngXpyhz0vMCmTsZI4PsWySrXdAxHJ8rXb/m8RRhtSe4lc2mI3Gy1O1k+gRygkuJKhzG3wnE23K/lIEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pGyt+LaJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pGyt+LaJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A9CC19423;
	Tue,  3 Mar 2026 00:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772496838;
	bh=g3P/Y+DcO9JylGN3U1mmgwOTfAKDoIg0NwnnLt3/aEk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pGyt+LaJu6nevbApk9/CTQI7SDx1iE9HpS+U+ORkxK1FkgTrSfmOl6Fc+pS3O05BA
	 vIOj8iIzOgS9S49UWhJeWx3JsCu/Xx+ebZdbYuI8Ne+/o4339egX1Jdjg/Icsx4AcI
	 R3UwKpVjE0uWjvf8G2TzCDCVUxqtoUHz+4lKk/Tr2vBXfPKGNEKdGtmE7egrVlzYP3
	 zoxH++Mw26RduaCVzg9nhWqUTbn16h8K4/GFGt8k2+euBCJ48zDstTIOVNIlnOvJT2
	 wmHAoGGCt0RnY+CRuGTzKp7mMIy7fLuvv1L7bMD132VDRgM4yj1pGw19QOrIYBl94C
	 44fcpKHrWlfig==
Date: Mon, 02 Mar 2026 16:13:58 -0800
Subject: [PATCH 07/36] xfs: convey filesystem shutdown events to the health
 monitor
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177249637904.457970.7173276809251021727.stgit@frogsfrogsfrogs>
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

