Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABCF43CE57;
	Tue,  4 Aug 2026 09:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785836772; cv=none; b=SxWC634fmTICG44NAyWEEkTKMsZ+o5DA7lPvEApdVaAf8N32dic1VnUbPzszR44emOzui1/9Q1iBs+mKSAek7aFbYYGKErwpRTEoGpCS9ZY30+vSL+9oCnGRmziJmwjKzcy/Zbmfa/tyDwFILyOf79EsOPmo/N8EQjCt56ZJyFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785836772; c=relaxed/simple;
	bh=YcU7GrGFUaJqL+3aXbZSaVkG/0ztE1GW5kFuqvSxOhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iitsw00oVmGcQQ4y8tcXxkwiLQ0/gYiEsB8hk9cRGb/vWTRpkndzUn65pGKelkTH5sBN8JYQYb0hrVPqasjwHNcfXTBb4KwhaVSQIs+3E5k9CU5+Y/JTgsxrytpsVqa52VK0EaTqspdzPHL4EVtAXQsvmoVYE8vkQbmCh3QDl5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d2cNLvU4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d2cNLvU4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6091B1F00A3E;
	Tue,  4 Aug 2026 09:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785836770;
	bh=RJh+bg3/dAMmaBEyL3S0BEiJK+J4XOxu5GyZH+nl4KQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d2cNLvU42RThjouHPhOs6cOBdFWezzxcpAwQo2dRDv2cpEs7SI0l6PUyZnXu65kXq
	 wFxy5vFFgngPvXPqu9CDis0JXmamoZZ78FcafdO1GaSp7INuz8iVniLf4veA929cZ0
	 u9CWcVRXHHapYvGH2jv/6uh7Wef8/33wyI8wDmGvp+RgIbXssgLucslVd/GfZn8d6H
	 wdLWzIOHkjOngaqKeni35i8rXwdSWZQZ9oJXdWQQ5AGKM9CzATViffFE11voMw5iLj
	 +cCPDIsn4NKmcxTMcAXxaLc4DHR/QOn/YL+yOTPVbsVV8ruiWN6kGvqFv2Ctge19UH
	 GTzqoTWrjUMxQ==
From: cem@kernel.org
To: cem@kernel.org
Cc: jack@suse.cz,
	djwong@kernel.org,
	hch@lst.de,
	serge@hallyn.com,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	stable@vger.kernel.org,
	"Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
Subject: [PATCH v4 1/5] xfs: fix capability check in xfs
Date: Tue,  4 Aug 2026 11:45:51 +0200
Message-ID: <20260804094602.84766-2-cem@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260804094602.84766-1-cem@kernel.org>
References: <20260804094602.84766-1-cem@kernel.org>
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
Reported-by: Dr. Thomas Orgis <thomas.orgis@uni-hamburg.de>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_fsmap.c | 2 +-
 fs/xfs/xfs_ioctl.c | 2 +-
 fs/xfs/xfs_iops.c  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

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
index 6339f4956ecb..7a8c77fdcf68 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -835,7 +835,7 @@ xfs_setattr_nonsize(
 	}
 
 	error = xfs_trans_alloc_ichange(ip, udqp, gdqp, NULL,
-			has_capability_noaudit(current, CAP_FOWNER), &tp);
+			ns_capable_noaudit(&init_user_ns, CAP_FOWNER), &tp);
 	if (error)
 		goto out_dqrele;
 
-- 
2.55.0

