Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7BEBA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MpLeZXuW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE51C433C7;
	Sun, 31 Dec 2023 21:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057478;
	bh=Yb/y8uzEQq10qTquGSS8shy6v+pwFMRsesAUu7c20+Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MpLeZXuWwykVbQgdBCct4NSNjEVqnksUJCYWaSpAUASi+etA0jRfzeQtzTxWCggxr
	 61ZSdvLXa5/xOnzfEiK/GVf6hmg7rFx8bm0QcImYblb6SYmkJuzCFZbdAVNOIMaBdk
	 EYFFUt1heLmKOcYSqoHt80COroNChATtEtVhWcVJ/IhIPK7rdJH8BcAtHoaURYSoyU
	 wcOP/Ysaeg5Hu5T5Xb6fgZFHkmrIinRNDIbIOiaQARswM/Bcg72ZGRn6b8/kLZ4KeP
	 Dimm4Ya47XV1KYw4XSekSQHyR2163AA5p5zg4i/SD/a5kJNHAbGic0CALhspvwqfxj
	 lVMc8Is01PqMg==
Date: Sun, 31 Dec 2023 13:17:57 -0800
Subject: [PATCH 09/24] xfs: export realtime group geometry via XFS_FSOP_GEOM
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404846385.1763124.16362358589721884777.stgit@frogsfrogsfrogs>
In-Reply-To: <170404846187.1763124.7316400597964398308.stgit@frogsfrogsfrogs>
References: <170404846187.1763124.7316400597964398308.stgit@frogsfrogsfrogs>
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

Export the realtime geometry information so that userspace can query it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h |    4 +++-
 fs/xfs/libxfs/xfs_sb.c |    5 +++++
 2 files changed, 8 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index a0efcbde5ae60..bae9ef924bf59 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -186,7 +186,9 @@ struct xfs_fsop_geom {
 	__u32		logsunit;	/* log stripe unit, bytes	*/
 	uint32_t	sick;		/* o: unhealthy fs & rt metadata */
 	uint32_t	checked;	/* o: checked fs & rt metadata	*/
-	__u64		reserved[17];	/* reserved space		*/
+	__u32		rgblocks;	/* rtblocks in a realtime group	*/
+	__u32		rgcount;	/* number of realtime groups	*/
+	__u64		reserved[16];	/* reserved space		*/
 };
 
 #define XFS_FSOP_GEOM_SICK_COUNTERS	(1 << 0)  /* summary counters */
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index b37924cf67a93..cf94417aa9faa 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1411,6 +1411,11 @@ xfs_fs_geometry(
 		return;
 
 	geo->version = XFS_FSOP_GEOM_VERSION_V5;
+
+	if (xfs_has_rtgroups(mp)) {
+		geo->rgcount = sbp->sb_rgcount;
+		geo->rgblocks = sbp->sb_rgblocks;
+	}
 }
 
 /* Read a secondary superblock. */

