Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465D047D941;
	Thu,  2 Jul 2026 09:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782984935; cv=none; b=B/yx37svy/F/hQrmmli8xMU8ee2iCSZtEqqsFjWkw+YlHlLhJpYPrbLSuvrm76p7vAtmxNiFAwefN5xKVq7Tx2hLUhrsQZEeya93rh9aQvdJIeXBLfsI8hLR4VN0BbVd5ZnaXP79nB3C2FF6ASbG6w5Tp3ch1rsxPGWtOnYHtCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782984935; c=relaxed/simple;
	bh=uXLZVHHy3UWwhbhbhkVd97wUO4lIggrF2vt2F4/41s0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E/e5Ac1P3xJO4kpyC5WeGTPT2FSAd7tzgQORk2OoxAMaaQ6UHhz3/1R8ZVNen9aUzpqLuOgsi24VZzFkoBCMFeB4KPRNM8W4Ge0+FowbPgv4VE5K7nHusppKj54mwkqSoF/YKOKpbL5+jgDv/j5opJoObOAFChV7KKcz8gFyJds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PCvkc2cs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PCvkc2cs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569791F000E9;
	Thu,  2 Jul 2026 09:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782984934;
	bh=k2bwKzXdeEiP3AG887oTuV7RQ360zS1KdgoW8z2oFfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PCvkc2csxy/C2sQOhsOZVh+OZGuFJPhIB3M3bO2FV95273JN8DqrEdnr8zznPiEck
	 sMP1QTiy60q4ZJRNasI0Tw26ISbfObE+tbaX/5YBNmLJGBvipHPlGDgodvDHNRXuGO
	 PH4jLEBfgZIbw1I7je0bIi8icaeimP5YH+EWa/G5RApkk5UeXPzdRkkJIzze+fuu93
	 gf/s0vk7x1LfJIKik4BNKFaFUjUGkFnF0+evuP9JDqJwpRKZXLc/dUb7g4LoLwSOGP
	 u5y4nhFTw86NJxvwY7mkqfwnICMS8RCbd0Kz3QwSC/Ht4U0//airv902/FBRJ3OR3M
	 9t7uEEZxt9x3Q==
From: cem@kernel.org
To: cem@kernel.org
Cc: stable@vger.kernel.org,
	Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@lst.de>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Eric Sandeen <sandeen@redhat.com>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
Subject: [PATCH v3 1/5] xfs: fix capability check in xfs
Date: Thu,  2 Jul 2026 11:33:17 +0200
Message-ID: <20260702093324.127450-3-cem@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260702093324.127450-1-cem@kernel.org>
References: <20260702093324.127450-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

An user reported a bug where he managed to evade group's quota
by changing a file's gid to a different group id the same user
belonged to, even though quotas were enforced on both gids and the
file's size was big enough to exceed the quota's hardlimit.

Commit eba0549bc7d1 replaced a capable() call by a
has_capability_noaudit() to prevent unnecessary selinux audit messages.
Turns out that both calls have slightly different semantics even though
their documentation seems similar. Where in a nutshell:

capable() - Tests the task's effective credentials
has_ns_capability_noaudit() - Tests the task's real credentials

This most of the time has no practical difference but in some cases like
changing attrs (specifically group id in this case) through a NFS client
this will allow the quota code to use XFS_QMOPT_FORCE_RES, effectively
bypassing quota accounting checks.

Using instead ns_capable_noaudit() should fix this issue and prevent
selinux audit messages.

This also fix the remaining calls to has_capability_noaudit()

Fixes: eba0549bc7d1 ("xfs: don't generate selinux audit messages for capability testing")
Cc: <stable@vger.kernel.org> # v5.18
Cc: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>
Cc: Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
Cc: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Reported-by: Dr. Thomas Orgis <thomas.orgis@uni-hamburg.de>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_fsmap.c | 2 +-
 fs/xfs/xfs_ioctl.c | 2 +-
 fs/xfs/xfs_iops.c  | 3 ++-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index b6a3bc9f143c..7c79fbe0a74c 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -1175,7 +1175,7 @@ xfs_getfsmap(
 		return -EINVAL;
 
 	use_rmap = xfs_has_rmapbt(mp) &&
-		   has_capability_noaudit(current, CAP_SYS_ADMIN);
+		   ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN);
 	head->fmh_entries = 0;
 
 	/* Set up our device handlers. */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 1b53701bebea..1a8af827dde1 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -647,7 +647,7 @@ xfs_ioctl_setattr_get_trans(
 		goto out_error;
 
 	error = xfs_trans_alloc_ichange(ip, NULL, NULL, pdqp,
-			has_capability_noaudit(current, CAP_FOWNER), &tp);
+			ns_capable_noaudit(&init_user_ns, CAP_FOWNER), &tp);
 	if (error)
 		goto out_error;
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 6339f4956ecb..205fe2dae732 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -835,7 +835,8 @@ xfs_setattr_nonsize(
 	}
 
 	error = xfs_trans_alloc_ichange(ip, udqp, gdqp, NULL,
-			has_capability_noaudit(current, CAP_FOWNER), &tp);
+					ns_capable_noaudit(&init_user_ns, CAP_FOWNER),
+					&tp);
 	if (error)
 		goto out_dqrele;
 
-- 
2.54.0

