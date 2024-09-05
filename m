Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCC718892D
	for <linux-xfs@vger.kernel.org>; Thu,  5 Sep 2024 18:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725560538; cv=none; b=FR1PB/gWh/RIqAnlTaWAjDY5/kaGhPlXqlEpq02nG3bBqvbIeiWD2ZZpRzqEkND/De+m2eAq+6KLfyG48AF88+haiAHzEGd1owxgMx+wZFt1bJVY4MvTst+YntJaOhawkePcGNfksa+PZeRoaPmLgqPj2DiJg+yHKoFT2WTrk4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725560538; c=relaxed/simple;
	bh=HrhF2RdocuWG5Lwf+Z0wFqbLpsdOrAh3uIOG9AOLI/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=srjuXd0j9wN/eilpFtFcCL/XnO8ej9zmcntjQjF8mZEH9iC0DKBKGJkLkhh+3DDpKL+AIIbxkEkzuYjb9QEgJdHn0OPlXlVoNa7krUEM+A7iaMUb/NP9N4X81i4DOzc3GzC6CxLaHkR6iRaW2TQHhaJ2oUctmj/hAq1vpJEJmAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V0MTufMx; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V0MTufMx"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-7b0c9bbddb4so851190a12.3
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2024 11:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725560536; x=1726165336; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+kNHJ80eZPdzthSlv5Lf6HBlIG2tAlDhqhvDn22hO1k=;
        b=V0MTufMx02mP8T8AtA7NDPqDJ7+EgZWCxoShYL7AYfhakqz4ZsqZIwuyUmFoGUA2bP
         oQC/gIL42fkHC152LItABkuadsNOsL4Pjlq+tikAHqgwLAMR+H2+5wpHYQ+9voGcuWLN
         S4JhVw/XBTqJjK3wxNTLVNk56PdKBGGMmo6Qu9m+qfHkrpPloD/bsJq6tinP/3OWJsmA
         V3sK1q8z3ypaLGiLvt/2ScGYmkvLXK8Um83+FjKMvdhahyDzDnwbhRinvInYx8xIVvM3
         m6aAk4A1UEpvJQGeUq+O7tBzydfEG6++Fq/2gELuTDwucnYhsEDjHHwaOMVYVT1J/3Ew
         NZHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725560536; x=1726165336;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+kNHJ80eZPdzthSlv5Lf6HBlIG2tAlDhqhvDn22hO1k=;
        b=S3hzm7pk5sFwKldIcRN6UCYygHvlF9cD0jAbk24EJ3IjbPGBUFFDQpLCBBoZWS1s4B
         wBb3ntidm1y5cPj9HUdans26t6fNPaPkw0jUyjImymwoe5VW9OuRJBIRjmOFWDCuX7v1
         +wSNpeGrk5oe4BixC0+8swtgZlBhV80ZA9QM40NzMcV2hDCEWCbOsBDoDB6XPl39u2DY
         +gxJtmY52JBOdoBAR/8yrSCrRvw4eheH3ocuNCkeL9mPkwGvUkrhIw4KIuzVXVDWBJar
         HO824JwsT3C0GedIanR5AbcMgoKzcxxyyNmK5Jf0mS6UY/QZvIp9xwoN3yeK4XOsTL9s
         RaqA==
X-Gm-Message-State: AOJu0Yx1EUJXnDki8f5O9il7zAKTXZz9FBqqcnP43gvfUiWKtX9JVgj8
	EYljWyANoLb7ceAQEEyKaF2/hpMxbTht6FS0em7qXdgIKrdIE84acOWrrOvv
X-Google-Smtp-Source: AGHT+IGumzvb+BIkQ4+cFxHHl/WEWZMVsVfEoKa/I4wZGds7TRHkVpEon+rtHU1zBGWPc3gTLXtagg==
X-Received: by 2002:a17:902:d2c6:b0:205:5417:ddda with SMTP id d9443c01a7336-2055417e04emr202055815ad.45.1725560536034;
        Thu, 05 Sep 2024 11:22:16 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2da2:d734:ef56:7ccf])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206aea684f0sm31374395ad.271.2024.09.05.11.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 11:22:15 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 24/26] xfs: make inode unlinked bucket recovery work with quotacheck
Date: Thu,  5 Sep 2024 11:21:41 -0700
Message-ID: <20240905182144.2691920-25-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
In-Reply-To: <20240905182144.2691920-1-leah.rumancik@gmail.com>
References: <20240905182144.2691920-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 49813a21ed57895b73ec4ed3b99d4beec931496f ]

Teach quotacheck to reload the unlinked inode lists when walking the
inode table.  This requires extra state handling, since it's possible
that a reloaded inode will get inactivated before quotacheck tries to
scan it; in this case, we need to ensure that the reloaded inode does
not have dquots attached when it is freed.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_attr_inactive.c |  1 -
 fs/xfs/xfs_inode.c         | 12 +++++++++---
 fs/xfs/xfs_inode.h         |  5 ++++-
 fs/xfs/xfs_mount.h         | 10 +++++++++-
 fs/xfs/xfs_qm.c            |  7 +++++++
 5 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 5db87b34fb6e..89c7a9f4f930 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -333,7 +333,6 @@ xfs_attr_inactive(
 	int			error = 0;
 
 	mp = dp->i_mount;
-	ASSERT(! XFS_NOT_DQATTACHED(mp, dp));
 
 	xfs_ilock(dp, lock_mode);
 	if (!xfs_inode_has_attr_fork(dp))
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 06cdf5dd88af..00f41bc76bd7 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1743,9 +1743,13 @@ xfs_inactive(
 	     ip->i_df.if_nextents > 0 || ip->i_delayed_blks > 0))
 		truncate = 1;
 
-	error = xfs_qm_dqattach(ip);
-	if (error)
-		goto out;
+	if (xfs_iflags_test(ip, XFS_IQUOTAUNCHECKED)) {
+		xfs_qm_dqdetach(ip);
+	} else {
+		error = xfs_qm_dqattach(ip);
+		if (error)
+			goto out;
+	}
 
 	if (S_ISLNK(VFS_I(ip)->i_mode))
 		error = xfs_inactive_symlink(ip);
@@ -1963,6 +1967,8 @@ xfs_iunlink_reload_next(
 	trace_xfs_iunlink_reload_next(next_ip);
 rele:
 	ASSERT(!(VFS_I(next_ip)->i_state & I_DONTCACHE));
+	if (xfs_is_quotacheck_running(mp) && next_ip)
+		xfs_iflags_set(next_ip, XFS_IQUOTAUNCHECKED);
 	xfs_irele(next_ip);
 	return error;
 }
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 0467d297531e..85395ad2859c 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -344,6 +344,9 @@ static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
  */
 #define XFS_INACTIVATING	(1 << 13)
 
+/* Quotacheck is running but inode has not been added to quota counts. */
+#define XFS_IQUOTAUNCHECKED	(1 << 14)
+
 /* All inode state flags related to inode reclaim. */
 #define XFS_ALL_IRECLAIM_FLAGS	(XFS_IRECLAIMABLE | \
 				 XFS_IRECLAIM | \
@@ -358,7 +361,7 @@ static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
 #define XFS_IRECLAIM_RESET_FLAGS	\
 	(XFS_IRECLAIMABLE | XFS_IRECLAIM | \
 	 XFS_IDIRTY_RELEASE | XFS_ITRUNCATED | XFS_NEED_INACTIVE | \
-	 XFS_INACTIVATING)
+	 XFS_INACTIVATING | XFS_IQUOTAUNCHECKED)
 
 /*
  * Flags for inode locking.
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index c8e72f0d3965..9dc0acf7314f 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -401,6 +401,8 @@ __XFS_HAS_FEAT(nouuid, NOUUID)
 #define XFS_OPSTATE_WARNED_SHRINK	8
 /* Kernel has logged a warning about logged xattr updates being used. */
 #define XFS_OPSTATE_WARNED_LARP		9
+/* Mount time quotacheck is running */
+#define XFS_OPSTATE_QUOTACHECK_RUNNING	10
 
 #define __XFS_IS_OPSTATE(name, NAME) \
 static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
@@ -423,6 +425,11 @@ __XFS_IS_OPSTATE(inode32, INODE32)
 __XFS_IS_OPSTATE(readonly, READONLY)
 __XFS_IS_OPSTATE(inodegc_enabled, INODEGC_ENABLED)
 __XFS_IS_OPSTATE(blockgc_enabled, BLOCKGC_ENABLED)
+#ifdef CONFIG_XFS_QUOTA
+__XFS_IS_OPSTATE(quotacheck_running, QUOTACHECK_RUNNING)
+#else
+# define xfs_is_quotacheck_running(mp)	(false)
+#endif
 
 static inline bool
 xfs_should_warn(struct xfs_mount *mp, long nr)
@@ -440,7 +447,8 @@ xfs_should_warn(struct xfs_mount *mp, long nr)
 	{ (1UL << XFS_OPSTATE_BLOCKGC_ENABLED),		"blockgc" }, \
 	{ (1UL << XFS_OPSTATE_WARNED_SCRUB),		"wscrub" }, \
 	{ (1UL << XFS_OPSTATE_WARNED_SHRINK),		"wshrink" }, \
-	{ (1UL << XFS_OPSTATE_WARNED_LARP),		"wlarp" }
+	{ (1UL << XFS_OPSTATE_WARNED_LARP),		"wlarp" }, \
+	{ (1UL << XFS_OPSTATE_QUOTACHECK_RUNNING),	"quotacheck" }
 
 /*
  * Max and min values for mount-option defined I/O
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index f51960d7dcbd..bbd0805fa94e 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1160,6 +1160,10 @@ xfs_qm_dqusage_adjust(
 	if (error)
 		return error;
 
+	error = xfs_inode_reload_unlinked(ip);
+	if (error)
+		goto error0;
+
 	ASSERT(ip->i_delayed_blks == 0);
 
 	if (XFS_IS_REALTIME_INODE(ip)) {
@@ -1173,6 +1177,7 @@ xfs_qm_dqusage_adjust(
 	}
 
 	nblks = (xfs_qcnt_t)ip->i_nblocks - rtblks;
+	xfs_iflags_clear(ip, XFS_IQUOTAUNCHECKED);
 
 	/*
 	 * Add the (disk blocks and inode) resources occupied by this
@@ -1319,8 +1324,10 @@ xfs_qm_quotacheck(
 		flags |= XFS_PQUOTA_CHKD;
 	}
 
+	xfs_set_quotacheck_running(mp);
 	error = xfs_iwalk_threaded(mp, 0, 0, xfs_qm_dqusage_adjust, 0, true,
 			NULL);
+	xfs_clear_quotacheck_running(mp);
 
 	/*
 	 * On error, the inode walk may have partially populated the dquot
-- 
2.46.0.598.g6f2099f65c-goog

