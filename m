Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0E6160792;
	Wed,  1 May 2024 18:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714588902; cv=none; b=H8geMsPAIoz//Y/L2DcK7qJbS3fCP0uuB4oGryB39cQwtt1NmGkmqks13tiXT5HUKHL3lVX7rKLShDdw0oobRcBm5/e0tVWTdT0pE5wCJHMpWkLZ5F4+SivLrjATD7aZNM7jvaGEqjykwUMFwXpJ3JMe/2NT1/KwHXQDX7DMKXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714588902; c=relaxed/simple;
	bh=yAWn3HjRsvD5XeV2oswLi0XJYsUTvCHFfJQvZG2QxIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=og0zOhE4rn694/JXYa/5vyw1i3/wEEi67a0JPoS90l6rXIXKsMnBAv5LpVQgHLkFmu2MFYAlJuC7IbKBpTxm2jEWvTidCWLcU2EeecqaFEtVlNH/SwsA1BJ+AKm0b3cUJbWaE/uTJMvOJBcpPnCr8mHcP3XobdeDV+lIHFrsULQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aC7Zryv0; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aC7Zryv0"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6ed5109d924so6060796b3a.0;
        Wed, 01 May 2024 11:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714588901; x=1715193701; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ep/s8Qc3fZK5FTK/7erNFUdsYSPanW/kBEW57a9gFg=;
        b=aC7Zryv0V+Ggl/Cibg40krYdZtMK1b8EoQRSOtcZg7UAqDXGKqIRXvOJO/odNV2AQ9
         7itKlc9F3L+Z5oeWVyuSI/uaHXeU5GOAdytdttIwBUTBcH9YFp4LTi4iLIKGtD2x/J0Z
         3Hxdot3qS821/hfpLufKdXIj1GSOFhuQ24xFZu+ZKTcaFNz7PYpCiPo07s4EY844fZ3I
         IxQVyngJDzeaX1z8JU900teCAhCDYlddVxdTQDBz8WYLJ8bViFEoK5HCZS21QQth5zdx
         4J1yPSp/ERKBaIX8pYzDUWJAwGFySC0PVpXNdw0BXzxd2zJsfvdUDepshrB2WVJCnZKj
         ci2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714588901; x=1715193701;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0ep/s8Qc3fZK5FTK/7erNFUdsYSPanW/kBEW57a9gFg=;
        b=njRMhKPXR/Lx+nxT3e8rFsiQkGm03BGIaGLqegw4JhifElMof+PtLK2bhPuQQSj4ne
         KolyHQKp9bY+1GLhvfofBonjMG+CfQKOhg2nEiLZDSfDV6/7OlUp/QaU5uL+sXIuUZZq
         pjQAHJPY3JPR71lsxQ1zoPf/ijsVjuBKtodxhxKTsWDzsc0CoFAEEr77M3+JmrUzW8br
         M/TmJ9aQ+w3m74ZI+oIxYCWG39Dh5oREXgLvBQGTUBdgH2l7owiVQKs4eMb1y5O+R5VM
         Sw7r+ZipHlqIlY+PSXX3zmfpUzXq+5qd6C2EDu/wkHZSprwjifNjpxkquz+Q6vQoNBtc
         1ghw==
X-Gm-Message-State: AOJu0YxHuA1l8whO27qEGB2/8qKmVY/hI/vAqfq7FUC8UZw/K2ASXUGs
	UnzDzK4ls9xGLsu4dplPJQliEv1xWxBqvmsJy7CyX9O8fKGEMheLvs849W4T
X-Google-Smtp-Source: AGHT+IFRcEhFkLKZNHM62CLeZpNQGteFMNRRz0UAo71PGb/YxaDPSHSl/zB0wGLPS2Jfre2RHW9OlA==
X-Received: by 2002:a05:6a00:938d:b0:6ed:def8:4dc with SMTP id ka13-20020a056a00938d00b006eddef804dcmr3438048pfb.10.1714588900393;
        Wed, 01 May 2024 11:41:40 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:9dbc:724d:6e88:fb08])
        by smtp.gmail.com with ESMTPSA id j18-20020a62e912000000b006e681769ee0sm23687369pfh.145.2024.05.01.11.41.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 May 2024 11:41:40 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 22/24] xfs: fix log recovery when unknown rocompat bits are set
Date: Wed,  1 May 2024 11:41:10 -0700
Message-ID: <20240501184112.3799035-22-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
In-Reply-To: <20240501184112.3799035-1-leah.rumancik@gmail.com>
References: <20240501184112.3799035-1-leah.rumancik@gmail.com>
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
Acked-by: Darrick J. Wong <djwong@kernel.org>
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
2.45.0.rc1.225.g2a3ae87e7f-goog

