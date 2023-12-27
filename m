Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B855A1368
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bTIcPK7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46214C433C8;
	Mon,  1 Jan 2024 00:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069223;
	bh=VkENLGtFKMvDqYN7GWXv2Ko9P52ts+R/1BOx233iBz0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bTIcPK7G6Ylh3YlyBICDGqHl/AgMpMGQmthgzMmLN2sR57Yv5rBBFEidMPcdhic8P
	 ZItPWrrzF5cPM2noFEZNF/8wz4alMUOUWcu/Jw3KcIzSYTFV1ar0toTKSpE8eDzTqG
	 doxUNJhHwK5E/kDuVRNxLcQtyhhciognVeg7LTg05VhdTGr4a2JGdE4BCmPkyuhumz
	 M9L6nTBFEEGLSRsJyDIoaJU9YHLRtnUQ6ojZhsl52wLpDMOEQtmISR+NuWJNWbABOi
	 P04C5AW2jBP8FIElkEjXMGIYQ4bvZp7VSdNNcgn0aPLKq3D8Gk5b05uCSURmRylbqq
	 5xZ5Nk/+hbz1A==
Date: Sun, 31 Dec 2023 16:33:42 +9900
Subject: [PATCH 29/42] xfs_spaceman: report health of the realtime refcount
 btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017513.1817107.17398204189357753494.stgit@frogsfrogsfrogs>
In-Reply-To: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
References: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
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

Report the health of the realtime reference count btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 spaceman/health.c |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff --git a/spaceman/health.c b/spaceman/health.c
index fac81f4eda5..ce906967d47 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
@@ -46,6 +46,11 @@ static bool has_rtrmapbt(const struct xfs_fsop_geom *g)
 	return g->rtblocks > 0 && (g->flags & XFS_FSOP_GEOM_FLAGS_RMAPBT);
 }
 
+static bool has_rtreflink(const struct xfs_fsop_geom *g)
+{
+	return g->rtblocks > 0 && (g->flags & XFS_FSOP_GEOM_FLAGS_REFLINK);
+}
+
 struct flag_map {
 	unsigned int		mask;
 	bool			(*has_fn)(const struct xfs_fsop_geom *g);
@@ -155,6 +160,11 @@ static const struct flag_map rtgroup_flags[] = {
 		.descr = "realtime reverse mappings btree",
 		.has_fn = has_rtrmapbt,
 	},
+	{
+		.mask = XFS_RTGROUP_GEOM_SICK_REFCNTBT,
+		.descr = "realtime reference count btree",
+		.has_fn = has_rtreflink,
+	},
 	{0},
 };
 

