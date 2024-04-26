Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F693B782
	for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 21:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714168573; cv=none; b=kwyG0A4FD4sr6QGZXgYOSHh0gApqgBxZ2Q+m2Hk4xwU7+lTWt9mw1J6uYFQgKPiAebQbWRhwgPU4Qvyyp8vxbMMNpBCvxXyLxKJFeik584MLFwaM83yny4oLQKcTzFIUYP3zgNWwi8zF2LV9o/+8c8RcHoplQ1VsbxcgtAWVzxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714168573; c=relaxed/simple;
	bh=n1LyQTxHOYjIkP96aeq5RE1qIpC98Uo55vPf4aOlwec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZgufCD5PZ3XARTbwu+UUXITLbrvlupgJwK3T51fmIRtCZ6Vk18sna07R5Wjjv2ZOu+RnvDFcuFHcq2hWp2AdOqPIlUieutMMH6NZWTFrwll5O8LGYwX9TdlNXEBTPqRqedqQwF7T9XphA5QuS+N4LvTafQLdjXmvtIC4PjzFFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q3riNLGG; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q3riNLGG"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1eac92f7c74so18180325ad.3
        for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 14:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714168572; x=1714773372; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9hNIdm5d+yg3LAm9vN9skzBV5xAcIN1I+3KiZR3PtOI=;
        b=Q3riNLGGni+1ti/hF+wUqeEQf09rbLSCGwi08DSGuHtB+aHtScxUDlQW+oqbDyN8d0
         wEGugBOr0+l+d+wHU+DWPegN/hI1FntnOKj4kaJBO7X7XPzqxkcRGoWMZiS7fvDBz0OL
         4DRzAr3aSfhfZP4pd59ShE1pXjyb73kKHZB9rAJ5TEtxCB+NzdQh/ivq5yePSgVV5NR2
         bmnPqkOLO8iV6N3/Or/JRaF10+L8UfUz2pFjtBLGbnONAMMjbCRdnt5og2HvS8qF38ZW
         Ia+nMjyX2Ve4JZ/WhtHzTYbVcWpqlTZMm6J69Mtgp6RTu1DN55VW5aBwgN53XjF+x2Tm
         L/Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714168572; x=1714773372;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9hNIdm5d+yg3LAm9vN9skzBV5xAcIN1I+3KiZR3PtOI=;
        b=TZ/sD4uQ/Qi01aJ56qjDthcD4nQ+iw2/pU8DGaC1ZyVajoL+I5rbzr/idBTapIw2v4
         /jBPqtvmzL8Ff2xjq6eloeRPutz63j+dt0JfCLSGwkwTW1ajCDmSTJcr4DFu5FnpYH9y
         61ajLBD3IKCASuHFPi6MV77bL7nGep1S+Df4mpibEjN1sIWEtuQfVpPYgxRiV2OssHwj
         GT6wAiO0nTDeAoWxZun4vm8xFbyKPMClzyiXq/9uM/kv+DsZ3ViARbHs64H9Dc93dgO6
         Ttxr06RW9xfjNgv+HW4yjdZGv23T6EVxJVAP9F7YGYan32VsL3GVVMhqNP4qtyHQcJIg
         wXeQ==
X-Gm-Message-State: AOJu0YzYlDgQ3cXsq5/eIS3tawz9Waa545/S/HcjIb/fyj94v95bsVcj
	SjRRlY133mDQgSRmNsFBRsSp8Pwp7e2pfrTMP+/lZgkAbKkgW29bcLQKtFXb
X-Google-Smtp-Source: AGHT+IH/l2YLzxOu8WG9HZdiWM5ii10swQfVE2jFXaoPsjtae5G3mCHJD3hwwnYlkKx1ACaXP71CgA==
X-Received: by 2002:a17:902:cf0e:b0:1e5:2ea7:a0b3 with SMTP id i14-20020a170902cf0e00b001e52ea7a0b3mr5237703plg.62.1714168571866;
        Fri, 26 Apr 2024 14:56:11 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2b3a:c37d:d273:a588])
        by smtp.gmail.com with ESMTPSA id b18-20020a170903229200b001eb2e6b14e0sm855772plh.126.2024.04.26.14.56.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 14:56:11 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	mngyadam@amazon.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 22/24] xfs: fix log recovery when unknown rocompat bits are set
Date: Fri, 26 Apr 2024 14:55:09 -0700
Message-ID: <20240426215512.2673806-23-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
In-Reply-To: <20240426215512.2673806-1-leah.rumancik@gmail.com>
References: <20240426215512.2673806-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 74ad4693b6473950e971b3dc525b5ee7570e05d0 ]

Log recovery has always run on read only mounts, even where the primary
superblock advertises unknown rocompat bits.  Due to a misunderstanding
between Eric and Darrick back in 2018, we accidentally changed the
superblock write verifier to shutdown the fs over that exact scenario.
As a result, the log cleaning that occurs at the end of the mounting
process fails if there are unknown rocompat bits set.

As we now allow writing of the superblock if there are unknown rocompat
bits set on a RO mount, we no longer want to turn off RO state to allow
log recovery to succeed on a RO mount.  Hence we also remove all the
(now unnecessary) RO state toggling from the log recovery path.

Fixes: 9e037cb7972f ("xfs: check for unknown v5 feature bits in superblock write verifier"
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/libxfs/xfs_sb.c |  3 ++-
 fs/xfs/xfs_log.c       | 17 -----------------
 2 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 28c464307817..bf2cca78304e 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -266,7 +266,8 @@ xfs_validate_sb_write(
 		return -EFSCORRUPTED;
 	}
 
-	if (xfs_sb_has_ro_compat_feature(sbp, XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
+	if (!xfs_is_readonly(mp) &&
+	    xfs_sb_has_ro_compat_feature(sbp, XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
 		xfs_alert(mp,
 "Corruption detected in superblock read-only compatible features (0x%x)!",
 			(sbp->sb_features_ro_compat &
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 60b19f6d7077..d9aa5eab02c3 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -730,15 +730,7 @@ xfs_log_mount(
 	 * just worked.
 	 */
 	if (!xfs_has_norecovery(mp)) {
-		/*
-		 * log recovery ignores readonly state and so we need to clear
-		 * mount-based read only state so it can write to disk.
-		 */
-		bool	readonly = test_and_clear_bit(XFS_OPSTATE_READONLY,
-						&mp->m_opstate);
 		error = xlog_recover(log);
-		if (readonly)
-			set_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);
 		if (error) {
 			xfs_warn(mp, "log mount/recovery failed: error %d",
 				error);
@@ -787,7 +779,6 @@ xfs_log_mount_finish(
 	struct xfs_mount	*mp)
 {
 	struct xlog		*log = mp->m_log;
-	bool			readonly;
 	int			error = 0;
 
 	if (xfs_has_norecovery(mp)) {
@@ -795,12 +786,6 @@ xfs_log_mount_finish(
 		return 0;
 	}
 
-	/*
-	 * log recovery ignores readonly state and so we need to clear
-	 * mount-based read only state so it can write to disk.
-	 */
-	readonly = test_and_clear_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);
-
 	/*
 	 * During the second phase of log recovery, we need iget and
 	 * iput to behave like they do for an active filesystem.
@@ -850,8 +835,6 @@ xfs_log_mount_finish(
 	xfs_buftarg_drain(mp->m_ddev_targp);
 
 	clear_bit(XLOG_RECOVERY_NEEDED, &log->l_opstate);
-	if (readonly)
-		set_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);
 
 	/* Make sure the log is dead if we're returning failure. */
 	ASSERT(!error || xlog_is_shutdown(log));
-- 
2.44.0.769.g3c40516874-goog

