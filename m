Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADDB2E2DF2
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 06:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771480922; cv=none; b=li6TeNJK+7PxnBTnKFY7DKbrRr6Pa4pSAKUcAf00ZBpBNPc69gcJrDS5bR/GJWAzWF9eq706Dy38TZHDYXeE9gJ+Zo/JIPbzSz6XWdgNWkPhIynSrBVFztsI2h85pRyyDBebfo+6YP8JN1S3vOICVSkVXwRfx5VwN9yu9SF69yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771480922; c=relaxed/simple;
	bh=fCC0FeN7F4YoT1d/Nnmz8KTyMBXBQ/zmU4900w+vjvU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nmpd1lmG+9SvhDf2j5rnikJ6apDo4CbdcGHw49K0UcI0oPSI4k25OSBHLZMpXIeObqhh26pyEgS/flt1d8qFDdaXwSc1WKqzNwu4IFFuiSdu2KIbVmxC/5Y48t0PHQ4+ipZory0IYa8hnjTHPwSG7dY5KGW2h4fiaNZMi/tSRik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jDg68Qm2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jDg68Qm2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D846FC19423;
	Thu, 19 Feb 2026 06:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771480921;
	bh=fCC0FeN7F4YoT1d/Nnmz8KTyMBXBQ/zmU4900w+vjvU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jDg68Qm2KaocM4qxYnSy8Nm4DKm3r9XFfvaudMnsH4gznNDYOiXZXnZ3Kuqyk0BBv
	 ysVDHmo3jrVbJ3TN8w7chlWc4gxsGIbTYVh85krpQc15puvqRZwkEBg4hUDYA2UsYy
	 K4w7bGs7bCgqRUmYjj/+n5V4NmJmJ3rAypgNEciXNDXGuLvTnNi0mSqSpUzF4rQQMt
	 ldoXWmnvY82sO5VfUR4YsPMuGIUh0I+WnomIcW//iLT9L8Est9keWsoU8PE+PNsktz
	 PIZBml0egjvgHwjIldM0X8dX8B/vYPSTExN3qtz6GgAl1KUjYfzhxVWWnIPaI0VOkv
	 5/pjNA4z5gxDg==
Date: Wed, 18 Feb 2026 22:02:01 -0800
Subject: [PATCH 5/6] xfs: don't report metadata inodes to fserror
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <177145925516.401799.751825387607935746.stgit@frogsfrogsfrogs>
In-Reply-To: <177145925377.401799.10773940743454980308.stgit@frogsfrogsfrogs>
References: <177145925377.401799.10773940743454980308.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Internal metadata inodes are not exposed to userspace programs, so it
makes no sense to pass them to the fserror functions (aka fsnotify).
Instead, report metadata file problems as general filesystem corruption.

Fixes: 5eb4cb18e445d0 ("xfs: convey metadata health events to the health monitor")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_health.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 169123772cb39b..6475159eb9302c 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -314,6 +314,18 @@ xfs_rgno_mark_sick(
 	xfs_rtgroup_put(rtg);
 }
 
+static inline void xfs_inode_report_fserror(struct xfs_inode *ip)
+{
+	/* Report metadata inodes as general filesystem corruption */
+	if (xfs_is_internal_inode(ip)) {
+		fserror_report_metadata(ip->i_mount->m_super, -EFSCORRUPTED,
+				GFP_NOFS);
+		return;
+	}
+
+	fserror_report_file_metadata(VFS_I(ip), -EFSCORRUPTED, GFP_NOFS);
+}
+
 /* Mark the unhealthy parts of an inode. */
 void
 xfs_inode_mark_sick(
@@ -339,7 +351,7 @@ xfs_inode_mark_sick(
 	inode_state_clear(VFS_I(ip), I_DONTCACHE);
 	spin_unlock(&VFS_I(ip)->i_lock);
 
-	fserror_report_file_metadata(VFS_I(ip), -EFSCORRUPTED, GFP_NOFS);
+	xfs_inode_report_fserror(ip);
 	if (mask)
 		xfs_healthmon_report_inode(ip, XFS_HEALTHMON_SICK, old_mask,
 				mask);
@@ -371,7 +383,7 @@ xfs_inode_mark_corrupt(
 	inode_state_clear(VFS_I(ip), I_DONTCACHE);
 	spin_unlock(&VFS_I(ip)->i_lock);
 
-	fserror_report_file_metadata(VFS_I(ip), -EFSCORRUPTED, GFP_NOFS);
+	xfs_inode_report_fserror(ip);
 	if (mask)
 		xfs_healthmon_report_inode(ip, XFS_HEALTHMON_CORRUPT, old_mask,
 				mask);

