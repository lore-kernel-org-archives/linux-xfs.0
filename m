Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64E526293
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346345; cv=none; b=rFQvTDwIXLZgnUfz0vPtU+TMLS+Hrve3xIHXaDrXfgNirVigf7ZxkGgcwG15DamEcCltpS7rfyLnWZ1UiWGivXSzl4EDRmwBB0tzt+E20wSN41FUrnC912X2elwEalUwnRv/B7buJU08qLfEoBXG6x2ojhGAB8xlbmU8ynmLSq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346345; c=relaxed/simple;
	bh=aWxpToVOLHU24bP/QStlISr6/QhU7Co0wkg7RjaFopc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GpG1Kwa13pKNjGd+wtfTYHSKDYNISccfDFcgqjHvpqUoEqtqpVr5P9zUqtCpwvn0ZXnxB09PWjguWUSr2w9IAqUVcb8b7IQg9hYU1rBaiSHziyXka8PhAJvDkVzi8JmMdx9ZWpasfhX8L9DMN553M/eWzzHoNABXgcuGcn1H7Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dhPLZ1aq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dhPLZ1aq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72AEEC2BD11;
	Wed, 22 May 2024 02:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346345;
	bh=aWxpToVOLHU24bP/QStlISr6/QhU7Co0wkg7RjaFopc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dhPLZ1aq16AmASEHBDIBy5FYND1V5ReA3Ji4faRJUoGJLV1/ApcdFsyWAzr8C3zHm
	 fFSoS7b4/FtUuJJT/SHXYUooypfd8kJTtvY70NzMPS6AGXiEC8CZnKoMrRyRYu3Fpj
	 yvBAo6Kcb/1lpGY9sOaPouoKTTrWg51/UjEB52idT4UnVvlXQLxC8KCJqH7G0ep0yl
	 zgpfMQMbTVMIXWFvuUmCmppn4CpijBvlwjCfMbPisa9D6B2V0apSR/BJvDA/i2eEfh
	 HjLxR368Ox8VNlmoFEl4EMh91HNjvO7IDOOr6BeS/tUALxtWWoZH+Xol/GJ1TN/gOB
	 YJ8ov63egaxLQ==
Date: Tue, 21 May 2024 19:52:25 -0700
Subject: [PATCH 014/111] xfs: report health of inode link counts
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634531921.2478931.8206719523979192968.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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

