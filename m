Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26141127B62
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 18:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717440943; cv=none; b=XU6/EjFEV6RR3MunMADFAUem0uLXUdcCS5c0pCAlSdveXQDx1261FFA79fs8H3RBrfxGdVfmkeEusSfYSI2ShkP3mFU6OTOgnURxbbyV5ZBp4kjQ9Zr5R+meLlzSKo7wBFcY1O2neb60l8I4XI7VT/mo1NhLdhFGV+kyLiwjdN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717440943; c=relaxed/simple;
	bh=r++1a4moutge2ePG0ftt+bQDlF46f5yDNkhbAe+Hf48=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mNzrhRZJVIsVv3O8z8aAVtAQ79f5Wn1b6iPwQtqzQY0Bm+/DyRZmpigQ6gKYVOfnELu40nFwKlLDvqRVXocV95xlD2Hj1QE4Vfi6ceC1ssj26WS9rN6OWWuWWFiJL052MLvb2lvFsUj+woO55zoIn9Hx4tWWTWt6Lp9AOQbrcdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IZxTz14o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IZxTz14o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4BEBC32786;
	Mon,  3 Jun 2024 18:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717440942;
	bh=r++1a4moutge2ePG0ftt+bQDlF46f5yDNkhbAe+Hf48=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IZxTz14o8r/+0zPhO0pfz3B5GpfeqAFXOwyAEPv+Q/kPi7V3+fZOSxNhYtvjX+w7p
	 SLyOTk0lGuQtNErp4KoU51/lWDdfsXujVfuu3IQQ3w0IdrJgJHQDJ09EzD97GYrJCh
	 MgFzTkRtoj9D1sffTnyOThQi7QAe3DQFb9AmRl41d/a5Ny1k3Q6U5wEtMSdVU5jWZ3
	 wgmpoLxnDaFUNbJGWXBlEVvG/L7/WFD18IrkWjqPlqmrL4Y4P8h2k0EU7HoQpRtQR8
	 kLVa/TCjADjbiS1vAFS/0C1H5ugiFs/RHmOjefORWgjzGWDE4ZiXJUuZo7JAH/9Z6p
	 DTRLip/nPG3OA==
Date: Mon, 03 Jun 2024 11:55:42 -0700
Subject: [PATCH 014/111] xfs: report health of inode link counts
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744039578.1443973.4636874168417968272.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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

Source kernel commit: 93687ee2e3748a4a6b541ff0d83d1480815b00a9

Report on the health of the inode link counts.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_fs.h     |    1 +
 libxfs/xfs_health.h |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 07acbed92..f10d0aa0e 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -196,6 +196,7 @@ struct xfs_fsop_geom {
 #define XFS_FSOP_GEOM_SICK_RT_BITMAP	(1 << 4)  /* realtime bitmap */
 #define XFS_FSOP_GEOM_SICK_RT_SUMMARY	(1 << 5)  /* realtime summary */
 #define XFS_FSOP_GEOM_SICK_QUOTACHECK	(1 << 6)  /* quota counts */
+#define XFS_FSOP_GEOM_SICK_NLINKS	(1 << 7)  /* inode link counts */
 
 /* Output for XFS_FS_COUNTS */
 typedef struct xfs_fsop_counts {
diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index 5626e53b3..2bfe2dc40 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -42,6 +42,7 @@ struct xfs_fsop_geom;
 #define XFS_SICK_FS_GQUOTA	(1 << 2)  /* group quota */
 #define XFS_SICK_FS_PQUOTA	(1 << 3)  /* project quota */
 #define XFS_SICK_FS_QUOTACHECK	(1 << 4)  /* quota counts */
+#define XFS_SICK_FS_NLINKS	(1 << 5)  /* inode link counts */
 
 /* Observable health issues for realtime volume metadata. */
 #define XFS_SICK_RT_BITMAP	(1 << 0)  /* realtime bitmap */
@@ -79,7 +80,8 @@ struct xfs_fsop_geom;
 				 XFS_SICK_FS_UQUOTA | \
 				 XFS_SICK_FS_GQUOTA | \
 				 XFS_SICK_FS_PQUOTA | \
-				 XFS_SICK_FS_QUOTACHECK)
+				 XFS_SICK_FS_QUOTACHECK | \
+				 XFS_SICK_FS_NLINKS)
 
 #define XFS_SICK_RT_PRIMARY	(XFS_SICK_RT_BITMAP | \
 				 XFS_SICK_RT_SUMMARY)

