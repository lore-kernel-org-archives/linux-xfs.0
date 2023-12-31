Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D2FC2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OKOpGKWs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3669CC433C7;
	Sun, 31 Dec 2023 23:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066564;
	bh=3z4a3Kz+HMp0L97aeYVLtAwZXz/ZzAfsgQaMJ0bCjC8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OKOpGKWsHBAsojQ0lu7Sb5djCXEA9F4UTlsSAqTAF6Ly8DcteP6edeTaZbnAUicDq
	 vWUMphL9IAsyqpZ8Yp4ejzu4IIuNIvRfCwP79ubErI4gqpxMolva0P84V0vpWgRGOc
	 ve+4YWp6SBnzoJbb2rwt9WfIojMKf4S637BwtfTGVNru1j5HtAVfh64oaUkn4rGZBp
	 g/alcCTpghIdn0Cg5lvukDgHJJsh6DvYSx9HdnKotZDPD8+fPE4lW2w+INv2RIrqwH
	 NHt1juzCK7NlRiXdt3Dhdor+pJYbmhc2vS4V4oSsOIM0bD8W4T5ICZmyWmU+/FXXQS
	 HtkmUYWwZ2xNA==
Date: Sun, 31 Dec 2023 15:49:23 -0800
Subject: [PATCH 07/52] xfs: export realtime group geometry via XFS_FSOP_GEOM
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012263.1811243.11107036625330360276.stgit@frogsfrogsfrogs>
In-Reply-To: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
References: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_fs.h |    4 +++-
 libxfs/xfs_sb.c |    5 +++++
 2 files changed, 8 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index a0efcbde5ae..bae9ef924bf 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
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
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 2de270171a4..3bd56edab87 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1409,6 +1409,11 @@ xfs_fs_geometry(
 		return;
 
 	geo->version = XFS_FSOP_GEOM_VERSION_V5;
+
+	if (xfs_has_rtgroups(mp)) {
+		geo->rgcount = sbp->sb_rgcount;
+		geo->rgblocks = sbp->sb_rgblocks;
+	}
 }
 
 /* Read a secondary superblock. */

