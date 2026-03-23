Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B522D8DDB
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 18:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774291403; cv=none; b=H5b0O4i5KrAuprCwhGA57gQtG2YNmXb2YcgIR+Lu3us8uHoOv3lR6pH9/1YtI/h29hlikBYO8NgaxD+rCy5+lC5Ac9Gn8YE0pEq171HZoNp+QcfrA5yNNO2SSZTe+lGfTFjokIh94BUkQe1ngzPOOAbUAxf2hSTIgVFj/tIiqrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774291403; c=relaxed/simple;
	bh=FQNp0SPMREhVwp2zlxrIjTWhVKx013cTIUZ7S/8SgIE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WeMn2SQ5vywiFivRgARk0Shlvr6AF/cL+HQcqXWKmJ96CwRKEoGx7v+jaWd7ZhTtsJTnyaT8D4fE1tAwrq9+mc2z4bkWA3zrcmD2R4NO69MamUsBLJ5hQonUz+MyM0S9rInw8A3Ye9j2J3cRFEbbss1acrNl2987WUuqzwVplvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RDu+E+t5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RDu+E+t5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B25DC4CEF7;
	Mon, 23 Mar 2026 18:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774291403;
	bh=FQNp0SPMREhVwp2zlxrIjTWhVKx013cTIUZ7S/8SgIE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RDu+E+t5EUJUNK43IRFtajKXGGnlaxXyZzjFEFLrNZxG4ISmrZYqCkmfrAFdQlaPN
	 pdLPZe5fFCb8c1ag4OaHB3FNg6bafs/3qz9qd/Gg/wztfToATNlQ6S02GuzXKJNe70
	 B0cKA+18zgRCYozh9Nyfzpt/dkLBGLUibzCuteorVBtn7iWsSfzsJGavowFTdaOQ2g
	 Vh9DX2UNZuAGUyn0fdrAxGVyPJA/vZubgpPCqjTt1XY6v8CDcvoTVj8jS41aFTOV4f
	 Jgu3db744TxjJoAOM/TCDCPEFu4MM0qnU3IYjKpheIwv9+JyMBaxwHtLdW61LWxlt/
	 dZrplvE2+FZPw==
Date: Mon, 23 Mar 2026 11:43:22 -0700
Subject: [PATCH 08/40] xfs: convey metadata health events to the health
 monitor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177429120884.2266274.9562434959355023142.stgit@frogsfrogsfrogs>
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

