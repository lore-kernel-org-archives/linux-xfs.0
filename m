Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5EC625
	for <linux-xfs@vger.kernel.org>; Sat, 24 Feb 2024 01:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708738482; cv=none; b=rPyD/PY3uG/1GOupKVD4MWhGZ9LOzCMIS7GIQcbeW48d3jYwekByXFqb/kjYqxovFGDagJU2Z01OsPynbPws9VPGEJmlWfIDKeP/YfQPruumE2C2m6kpb7hI7ia5RkVe5eShhyxywJUuDEBZcQIdiw1BRAaOdeSqM6yJIFzIlPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708738482; c=relaxed/simple;
	bh=Jn44IS2bRRCkd+jWBnzdDzxBWTau1fPAx/JjB7+0kzs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EM6OFdKDrI14X/Mn/2vIVvhWTgTWlCazXWqoA8ZVvXRVkmd4gHi7Cj0K4izanAgfePDkBhSCooNOvTVuJZ+DXBGCyAUaRMSJ/wbULDk5Kn7mDTY05oDYGn9V1vH8/DPVNn6ilk6gFxHMbNV4J7os9707vwW/kvCJGW+lnr8zAc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LM0O8hmM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LM0O8hmM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF81C433C7;
	Sat, 24 Feb 2024 01:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708738482;
	bh=Jn44IS2bRRCkd+jWBnzdDzxBWTau1fPAx/JjB7+0kzs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LM0O8hmMuliY/ITC671tRMD0N9OFT6gWJJ3sJcmqrKCmdYKF/moejE+PJok8jQkrP
	 NZWf5lJ4LFYCrDXHP1WKYdQSLlwIow/ja7tSId6xsL6Q+ImikUMm/8Pxq45giBbBhD
	 Knx8gvMIC9ZKgt7TlmG/iN2WzbgFrycPImweNDtFQtOwT+z3CWbBtWtsDar+IUqUzz
	 4CvXfPxVm5zV19FTkOvuOLSuWCqUMX1dwPiFi7jtJ3X91tMeDcd5w4dX/zg9vBgQuo
	 KrFhB/kKWIXnPQGgao7lGYORBaQSKAjn029SQ6u2xnr+yjagMbK9ZXmezYh6C/Aemf
	 kbr6a1oyYLlVQ==
Date: Fri, 23 Feb 2024 17:34:41 -0800
Subject: [PATCH 2/7] xfs: create hooks for monitoring health updates
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, kent.overstreet@linux.dev, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170873836584.1902540.8474649922770298302.stgit@frogsfrogsfrogs>
In-Reply-To: <170873836546.1902540.13109376239205481967.stgit@frogsfrogsfrogs>
References: <170873836546.1902540.13109376239205481967.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_health.h |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)


diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index 89b80e957917..3c508a71ec91 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -331,4 +331,52 @@ void xfs_bulkstat_health(struct xfs_inode *ip, struct xfs_bulkstat *bs);
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
+	XFS_HEALTHUP_RT,	/* realtime */
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

