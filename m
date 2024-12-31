Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348E229415
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688879; cv=none; b=oavDYZMMSDM/qoAO8s+2BzZuRkoedKwibNS4usbGEGTV5sYVN8moE7T8NMmpx+jbH1iAHJpfC+X5QKQS9XCNRnd94trdKjHSzWkKLBDQ2xzW8hQ8drb9yJEPADbG3q9SJQptqObbmdupmgpvHQtptSFUKCINlq67BCKg7b9ZZA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688879; c=relaxed/simple;
	bh=LjusH2PxP+GNtXvK1bhZVyveE0hQJrey2O7/Hu/DV7g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MK+gJeTilmuGBBn9FdlvO2o32VL1efgoH0kHl+Hw0INNyTLwxAcpO7M3T260LgksMmPdsu/JNH1hwyiUIjvQGtNcS4TBoCZbbxN8Ay1QCgy1qRjKQhQKciaR4X899reczeMN2/IoxwExlF6wH66akntfRl6JdzS09WYhDOmV+cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lr29jpwa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lr29jpwa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24B8C4CED2;
	Tue, 31 Dec 2024 23:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688878;
	bh=LjusH2PxP+GNtXvK1bhZVyveE0hQJrey2O7/Hu/DV7g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Lr29jpwarFP8UpQzTwT0lgiwf8YAVETgzBXjo2NU1CuUVUyY30EZMGr+ea8+X//uR
	 bKPB7vXfgh2uj+zXLkXAKUdq7sQOkJvX59em6zDgLX36mPYiO1puPWyJnV8SGuSYpC
	 qapHU7MhfwXNGbG876qm0V/C0OtD40T+NKK+JpizTMua5u8Lcptigz3ZAt+Kte3E7k
	 u9+f+sEyfiPRvgnTBlliNzOMjCgVwsl0Fq1QPBJfy/+kYc44ffLdbtFcbRP7PzGXqH
	 pydpTurotUf6x9RR+M+cMVsxyGq2ISq/6nzXDg2gZifwCxzOqP+zXwBeDax+vgf4me
	 qJSJUc3ZvrEnQ==
Date: Tue, 31 Dec 2024 15:47:58 -0800
Subject: [PATCH 01/21] xfs: create hooks for monitoring health updates
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568778474.2710211.1014685356160559759.stgit@frogsfrogsfrogs>
In-Reply-To: <173568778426.2710211.10173859713748230492.stgit@frogsfrogsfrogs>
References: <173568778426.2710211.10173859713748230492.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create hooks for monitoring health events.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/xfs_health.h |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)


diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index b31000f7190ce5..39fef33dedc6a8 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -289,4 +289,51 @@ void xfs_bulkstat_health(struct xfs_inode *ip, struct xfs_bulkstat *bs);
 #define xfs_metadata_is_sick(error) \
 	(unlikely((error) == -EFSCORRUPTED || (error) == -EFSBADCRC))
 
+/*
+ * Parameters for tracking health updates.  The enum below is passed as the
+ * hook function argument.
+ */
+enum xfs_health_update_type {
+	XFS_HEALTHUP_SICK = 1,	/* runtime corruption observed */
+	XFS_HEALTHUP_CORRUPT,	/* fsck reported corruption */
+	XFS_HEALTHUP_HEALTHY,	/* fsck reported healthy structure */
+	XFS_HEALTHUP_UNMOUNT,	/* filesystem is unmounting */
+};
+
+/* Where in the filesystem was the event observed? */
+enum xfs_health_update_domain {
+	XFS_HEALTHUP_FS = 1,	/* main filesystem */
+	XFS_HEALTHUP_AG,	/* allocation group */
+	XFS_HEALTHUP_INODE,	/* inode */
+	XFS_HEALTHUP_RTGROUP,	/* realtime group */
+};
+
+struct xfs_health_update_params {
+	/* XFS_HEALTHUP_INODE */
+	xfs_ino_t			ino;
+	uint32_t			gen;
+
+	/* XFS_HEALTHUP_AG/RTGROUP */
+	uint32_t			group;
+
+	/* XFS_SICK_* flags */
+	unsigned int			old_mask;
+	unsigned int			new_mask;
+
+	enum xfs_health_update_domain	domain;
+};
+
+#ifdef CONFIG_XFS_LIVE_HOOKS
+struct xfs_health_hook {
+	struct xfs_hook			health_hook;
+};
+
+void xfs_health_hook_disable(void);
+void xfs_health_hook_enable(void);
+
+int xfs_health_hook_add(struct xfs_mount *mp, struct xfs_health_hook *hook);
+void xfs_health_hook_del(struct xfs_mount *mp, struct xfs_health_hook *hook);
+void xfs_health_hook_setup(struct xfs_health_hook *hook, notifier_fn_t mod_fn);
+#endif /* CONFIG_XFS_LIVE_HOOKS */
+
 #endif	/* __XFS_HEALTH_H__ */

