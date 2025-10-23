Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685CF8C1F
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761177950; cv=none; b=NTaq5I9gO3WesLxRlktvjatpsvb5pNeFMDrv1e9Dbs1N9dlHhfgpTHqq3TlvpHarpURIporAARCr2Ma6GUlI4jpGtoIZB+/tSZNcHAG6NB2Ihlhgo7FHKrIuzEIpAieo16/MBLEWxj1cQGUQ8cT7M7SBzPUht/oAVWj1AmD4DBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761177950; c=relaxed/simple;
	bh=LjusH2PxP+GNtXvK1bhZVyveE0hQJrey2O7/Hu/DV7g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D2Acu2DnBPQrcgn1VNz6uWovtf1eVZdgZfw2fmi72LQYellSF+A52aaKxjuzuM1IsdYeYMvjqIgT0ij1KjwIHZ10yTMUz1Tq8ujIifmHpfeHu90DLB/JHed4so+iVkmNhkSE4kJT/eD282gGnjDQeq13f7dtkEf0ORTaASxx4W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OuVD4VRT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OuVD4VRT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F134EC113D0;
	Thu, 23 Oct 2025 00:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761177950;
	bh=LjusH2PxP+GNtXvK1bhZVyveE0hQJrey2O7/Hu/DV7g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OuVD4VRTNRaWqUJS9gTVFNqDKBk7raU2asZhyXYb2Hu5YES8ImIoi3pjXzeB51Qs0
	 jhT5rVyGNoTKlqrU2mpac5ytt/ilPdoM1cvH1wOKI2pqQ8T/xGD13bllcIzcYbQSzW
	 Vr7YpxnXsWofFMT2rs9NSyoR0PiefhSUmKrXFG124qsglwPfywkHzFj0u2E8RMBSUA
	 bzUFiPBzXW8j2PZWWJ7fczlaC+GaH7iaWrLe46V4HTWhVg8WjVUpfjG/YPNk8ZlTOV
	 B46OM1UAWWUJVVD59BT3mpysmnPEAYJLx3bcfs7ECDvbsHblgmUhcoDc7hVnttQ3UI
	 LZpxb3tJKbngA==
Date: Wed, 22 Oct 2025 17:05:49 -0700
Subject: [PATCH 01/26] xfs: create hooks for monitoring health updates
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117747487.1028044.15356316210082343459.stgit@frogsfrogsfrogs>
In-Reply-To: <176117747330.1028044.14577065342150898892.stgit@frogsfrogsfrogs>
References: <176117747330.1028044.14577065342150898892.stgit@frogsfrogsfrogs>
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

