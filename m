Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F853A5421
	for <linux-xfs@vger.kernel.org>; Wed,  9 Sep 2026 06:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788933711; cv=none; b=alG8G2yLZgT/Zh8ZLooFK+cyajPcKIMwcDUclB2zanevmSIQjGBCspxcQ27osGEH9NMcF+BzDK0ZNNuVKdnwq+GO4X2gPHSnyFabbkoRVHgCNi4N+RWkT1nWdvxkTtb9GgIgN/dGYjwZY6RGUzw68flunBNaLa5mis1R0xrUPaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788933711; c=relaxed/simple;
	bh=Iez9IXzNAzzKUuUr089ADdTPhYTK+h2yS3yJYWGZycM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=apRDdlyXI9JgDILMTaqSfUZ6oH3WP4Sm5ABugjcRl3Vsxh+6QoTBk/LIYyQV1QDZ27IggAPqsKZVSukETROIHbWhBz2ffXv2AJqsjtI/pmRMwlXXXjdiH0ieOmwIqb/eiQwhvl65uruVsLcKDF8MbDQOV1bIiEhEq/oCSu+Dbcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oMQFDOA3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oMQFDOA3"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 44D731F00A3D;
	Wed,  9 Sep 2026 06:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788933709;
	bh=ymb2PyqfS56XwVM0BkCEyDKQnzNGVMWBrsMZhI1EJKY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=oMQFDOA3TQankiQTHuMIjEboHjg0tD0zZRvu/WHrqCqhJ/nJ9t6vXkw8t1ErN46oG
	 ViIbshp09rKSQuyt3MG4qz+Bz7ho8hMylLQNi/bZSvDRiiV2aijtlLjX/ye4u4IoO1
	 L0WZ7C4RipFsAGl6PBbpx4xG7H9u6HfEymNPyvOdyl1tLHlC632GAlGb883uR/FXw5
	 tE1Vzm4TanrcxdyRnxUUQveygIx2nSE0WibbUNfCHY4+auAoegBeXoZWN2fweZpfoJ
	 H1ubJs+TTJRC1VTzrlvAijnxIqpKV1HDk2wZjLjX8tv4w2JcnRHrIIwFe9w2InxUZA
	 x9EabLBFpHzTg==
Date: Tue, 08 Sep 2026 23:01:48 -0700
Subject: [PATCH 6/9] makecfg: handle old V4 options that are almost always on
 by default
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178892910641.4047311.14095703802962095779.stgit@frogsfrogsfrogs>
In-Reply-To: <178892910484.4047311.5337345469992668181.stgit@frogsfrogsfrogs>
References: <178892910484.4047311.5337345469992668181.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The same alternate LOLLM also observed that there are a couple of V4
options that are always enabled on a V5 filesystem.  Since we support V4
for another 4 years, add these two options but only for the weird case
where someone wants to turn them off.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libfrog/fsgeom.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)


diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 2172310aa102d6..5f2d8dc428fee5 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -286,6 +286,7 @@ enum {
 	I_SPINODES = 0,
 	I_NREXT64,
 	I_EXCHANGE,
+	I_PROJID32BIT,
 	I_MAX_OPTS,
 };
 
@@ -301,6 +302,11 @@ enum {
 	R_MAX_OPTS,
 };
 
+enum {
+	L_LAZYSBCNTR,
+	L_MAX_OPTS,
+};
+
 struct mkfs_config_opt;
 
 struct mkfs_config_data {
@@ -344,6 +350,24 @@ print_fsgeom(
 	return 0;
 }
 
+static int
+print_fsgeom_only_if_missing(
+	const struct mkfs_config_opt	*opt,
+	const struct mkfs_config_data	*data,
+	FILE				*fp)
+{
+	const struct xfs_fsop_geom	*fsgeo = data->fsgeo;
+	int				ret;
+
+	if (fsgeo->flags & opt->fsgeom_flag)
+		return 0;
+
+	ret = fprintf(fp, "%s=0\n", opt->name);
+	if (ret <= 0)
+		return ret;
+	return 0;
+}
+
 static int
 print_xflag(
 	const struct mkfs_config_opt	*opt,
@@ -618,9 +642,24 @@ static const struct mkfs_config_section config_sections[] = {
 				.name		= "exchange",
 				.fsgeom_flag	= XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE,
 			},
+			[I_PROJID32BIT] = {
+				.name		= "projid32bit",
+				.fsgeom_flag	= XFS_FSOP_GEOM_FLAGS_PROJID32,
+				.print_fn	= print_fsgeom_only_if_missing,
+			},
 			[I_MAX_OPTS] = { },
 		},
 	},
+	{
+		.ini_section = "log",
+		.subopts = {
+			[L_LAZYSBCNTR] = {
+				.name		= "lazy-count",
+				.fsgeom_flag	= XFS_FSOP_GEOM_FLAGS_LAZYSB,
+				.print_fn	= print_fsgeom_only_if_missing,
+			},
+		},
+	},
 	{
 		.ini_section = "naming",
 		.subopts = {

