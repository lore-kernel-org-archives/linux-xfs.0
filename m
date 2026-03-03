Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7689F176FB1
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772496823; cv=none; b=dMUwqSBnl6OYy2Vmnbw1Yd3wQcR7FwqhmDukWltMO2pdxsKJNcqQF5U5JtamfTv+r7WooC3pRuaUP9EgfPmzmOH0OagsiYInvg7xa3hBftOhfEiCYoJmZf/qTh2qvAodH9F+J4T7mOt+gAF5ixotoSbQkFWoU+CdFwNEzRHh0Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772496823; c=relaxed/simple;
	bh=FQNp0SPMREhVwp2zlxrIjTWhVKx013cTIUZ7S/8SgIE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eSlb/6nqjkD0lSSRlNBZlqtci1ns0F4fwvnyYTkelXGGUzYfW2JujH6hTLseGM+FXr82mNpENopIgxRpJ3/A2l0kwucO+0/1rrv3MvsKDtViUB1NREe8GetXA4Wk+Egix6mm2xzlingss+mtJgs3Djupc5UkNLOZsMxM/mFbYKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lwo6udne; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lwo6udne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3317CC19423;
	Tue,  3 Mar 2026 00:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772496823;
	bh=FQNp0SPMREhVwp2zlxrIjTWhVKx013cTIUZ7S/8SgIE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Lwo6udneQ0z3vRsB3PCn1TZ9oAOrTb7pPGgG9eITo/xbsTldL2AwQZrH4denz1DuX
	 8Wj4uRfkfmVnJ9BPMNLeUaSzWOCdHFUD2B1DvCh4BJ0PcVIcWZiQlE+P/OZGiu85L3
	 Ml1V6BnLoolyGUs4GFDiTX7tn5x+aO50efBUO9EeG9Bk8B6JAhkC5F2g+1MySlQ/4M
	 yoLKPw4QAUexxY2DhQynSNls39KtfuJBNOI6bGwiVQSbFdJq57oZE+QuOHioPykGCS
	 53s1IBrbZ9UTKsQhYELd0GEuD+6CzHyLi+MsFv1KDPNJem5yLyCFjEFyK4NLJQC6nQ
	 htQeLT/QzaH3g==
Date: Mon, 02 Mar 2026 16:13:42 -0800
Subject: [PATCH 06/36] xfs: convey metadata health events to the health
 monitor
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177249637886.457970.18439279193651122279.stgit@frogsfrogsfrogs>
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

Source kernel commit: 5eb4cb18e445d09f64ef4b7c8fdc3b2296cb0702

Connect the filesystem metadata health event collection system to the
health monitor so that xfs can send events to xfs_healer as it collects
information.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h     |   35 +++++++++++++++++++++++++++++++++++
 libxfs/xfs_health.h |    5 +++++
 2 files changed, 40 insertions(+)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 59de6ab69fb319..04e1dcf61257d0 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -1008,6 +1008,12 @@ struct xfs_rtgroup_geometry {
 /* affects the whole fs */
 #define XFS_HEALTH_MONITOR_DOMAIN_MOUNT		(0)
 
+/* metadata health events */
+#define XFS_HEALTH_MONITOR_DOMAIN_FS		(1)
+#define XFS_HEALTH_MONITOR_DOMAIN_AG		(2)
+#define XFS_HEALTH_MONITOR_DOMAIN_INODE		(3)
+#define XFS_HEALTH_MONITOR_DOMAIN_RTGROUP	(4)
+
 /* Health monitor event types */
 
 /* status of the monitor itself */
@@ -1017,11 +1023,37 @@ struct xfs_rtgroup_geometry {
 /* filesystem was unmounted */
 #define XFS_HEALTH_MONITOR_TYPE_UNMOUNT		(2)
 
+/* metadata health events */
+#define XFS_HEALTH_MONITOR_TYPE_SICK		(3)
+#define XFS_HEALTH_MONITOR_TYPE_CORRUPT		(4)
+#define XFS_HEALTH_MONITOR_TYPE_HEALTHY		(5)
+
 /* lost events */
 struct xfs_health_monitor_lost {
 	__u64	count;
 };
 
+/* fs/rt metadata */
+struct xfs_health_monitor_fs {
+	/* XFS_FSOP_GEOM_SICK_* flags */
+	__u32	mask;
+};
+
+/* ag/rtgroup metadata */
+struct xfs_health_monitor_group {
+	/* XFS_{AG,RTGROUP}_SICK_* flags */
+	__u32	mask;
+	__u32	gno;
+};
+
+/* inode metadata */
+struct xfs_health_monitor_inode {
+	/* XFS_BS_SICK_* flags */
+	__u32	mask;
+	__u32	gen;
+	__u64	ino;
+};
+
 struct xfs_health_monitor_event {
 	/* XFS_HEALTH_MONITOR_DOMAIN_* */
 	__u32	domain;
@@ -1039,6 +1071,9 @@ struct xfs_health_monitor_event {
 	 */
 	union {
 		struct xfs_health_monitor_lost lost;
+		struct xfs_health_monitor_fs fs;
+		struct xfs_health_monitor_group group;
+		struct xfs_health_monitor_inode inode;
 	} e;
 
 	/* zeroes */
diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index b31000f7190ce5..1d45cf5789e864 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -289,4 +289,9 @@ void xfs_bulkstat_health(struct xfs_inode *ip, struct xfs_bulkstat *bs);
 #define xfs_metadata_is_sick(error) \
 	(unlikely((error) == -EFSCORRUPTED || (error) == -EFSBADCRC))
 
+unsigned int xfs_healthmon_inode_mask(unsigned int sick_mask);
+unsigned int xfs_healthmon_rtgroup_mask(unsigned int sick_mask);
+unsigned int xfs_healthmon_perag_mask(unsigned int sick_mask);
+unsigned int xfs_healthmon_fs_mask(unsigned int sick_mask);
+
 #endif	/* __XFS_HEALTH_H__ */

