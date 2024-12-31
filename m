Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FAC71B0421
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735689332; cv=none; b=DzKwsRvs1HMnOQkXv/7pgMfwVZHRPyn6Fdrumol3c81h88z3/CMXAG4z/Kej4uqUoQn0VpxI4N15zklnMcS3JXLs4oxxn5wOBldRpy902o5x4voZwkYv2kgpQOwITwCsuFofmco+D2u8F2ak8WxdDrabwjJSykr87/DZZewhhsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735689332; c=relaxed/simple;
	bh=yzfBUlqjSaOPjaCG0NSDV5KSqH6DRLWFFY3aTTMXITU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hm9Li93YrblDvYSInBxaI48TybzOeOtTiDcF3GRLGKYldhx5u9TT8aiITzVvfnY9tJBMn5O28g4K3nFIIG1TKi8JUnwXSgf+WumPr9ERljHNBwrdEjvB6iFP3fammggEdWyTHZMhMoqCf6kQm3FjNLTTrYxva59mGBswwy6fT4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pXcO71bh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pXcO71bh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B3B9C4CED2;
	Tue, 31 Dec 2024 23:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735689332;
	bh=yzfBUlqjSaOPjaCG0NSDV5KSqH6DRLWFFY3aTTMXITU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pXcO71bhZgvQ27CDCqp+WuB5hsbp5zYREE2To5zPKp5OR4+h1HNl45YjE/mAjiv5l
	 ngo4EtLPTYvleSlfQU37yPva/BOIhGK7JwtdDA4fM4A7iQc0YreCHGqiXr871MfpAo
	 sQNUUHl30tFXNmOq1Q2KxmUTX16VY9zkDyWWd98xO5dgy3pwUHwy20oks/lJaHXMst
	 S7c0tA9ryoN4CuGhTiY/xScrP+hnyQotPIKfzZbfxc2CV9ZavJ14grO2Xo0nE2pLNZ
	 u3hbd49yVWYoGqRbkhI7XdX19wjlkrwKqVfsk4thiHYH2+cS8xwSHozf/uhwLU6H25
	 SfBVT6Jqjrz5Q==
Date: Tue, 31 Dec 2024 15:55:31 -0800
Subject: [PATCH 09/10] xfs_repair: skip free space checks when upgrading
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568779272.2710949.2287968490226708363.stgit@frogsfrogsfrogs>
In-Reply-To: <173568779121.2710949.16873326283859979950.stgit@frogsfrogsfrogs>
References: <173568779121.2710949.16873326283859979950.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add a debug knob to disable the free space checks when upgrading a
system.  This is extremely risky and will cause severe tire damage!!!

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/globals.c    |    1 +
 repair/globals.h    |    1 +
 repair/phase2.c     |    2 ++
 repair/xfs_repair.c |   11 +++++++++++
 4 files changed, 15 insertions(+)


diff --git a/repair/globals.c b/repair/globals.c
index 603fea73da1654..fe9f9ac5914bb0 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -48,6 +48,7 @@ char	*rt_name;		/* Name of realtime device */
 int	rt_spec;		/* Realtime dev specified as option */
 int	convert_lazy_count;	/* Convert lazy-count mode on/off */
 int	lazy_count;		/* What to set if to if converting */
+bool	skip_freesp_check_on_upgrade; /* do not enable */
 bool	features_changed;	/* did we change superblock feature bits? */
 bool	add_inobtcount;		/* add inode btree counts to AGI */
 bool	add_bigtime;		/* add support for timestamps up to 2486 */
diff --git a/repair/globals.h b/repair/globals.h
index 9211e5e2432c9a..c660971080f7e4 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -89,6 +89,7 @@ extern char	*rt_name;		/* Name of realtime device */
 extern int	rt_spec;		/* Realtime dev specified as option */
 extern int	convert_lazy_count;	/* Convert lazy-count mode on/off */
 extern int	lazy_count;		/* What to set if to if converting */
+extern bool	skip_freesp_check_on_upgrade; /* do not enable */
 extern bool	features_changed;	/* did we change superblock feature bits? */
 extern bool	add_inobtcount;		/* add inode btree counts to AGI */
 extern bool	add_bigtime;		/* add support for timestamps up to 2486 */
diff --git a/repair/phase2.c b/repair/phase2.c
index 8dc936b572196e..780294d24c9900 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -688,6 +688,8 @@ need_check_fs_free_space(
 	struct xfs_mount		*mp,
 	const struct check_state	*old)
 {
+	if (skip_freesp_check_on_upgrade)
+		return false;
 	if (xfs_has_finobt(mp) && !(old->features & XFS_FEAT_FINOBT))
 		return true;
 	if (xfs_has_reflink(mp) && !(old->features & XFS_FEAT_REFLINK))
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index d4101f7d2297d7..55e417201b34f7 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -46,6 +46,7 @@ enum o_opt_nums {
 	BLOAD_LEAF_SLACK,
 	BLOAD_NODE_SLACK,
 	NOQUOTA,
+	SKIP_FREESP_CHECK,
 	O_MAX_OPTS,
 };
 
@@ -59,6 +60,7 @@ static char *o_opts[] = {
 	[BLOAD_LEAF_SLACK]	= "debug_bload_leaf_slack",
 	[BLOAD_NODE_SLACK]	= "debug_bload_node_slack",
 	[NOQUOTA]		= "noquota",
+	[SKIP_FREESP_CHECK]	= "debug_skip_freesp_check_on_upgrade",
 	[O_MAX_OPTS]		= NULL,
 };
 
@@ -323,6 +325,15 @@ process_args(int argc, char **argv)
 				case NOQUOTA:
 					quotacheck_skip();
 					break;
+				case SKIP_FREESP_CHECK:
+					if (!val)
+						do_abort(
+		_("-o debug_skip_freesp_check_on_upgrade requires a parameter\n"));
+					skip_freesp_check_on_upgrade = (int)strtol(val, NULL, 0);
+					if (skip_freesp_check_on_upgrade)
+						do_log(
+		_("WARNING: Allowing filesystem upgrades to proceed without free space check.  THIS MAY DESTROY YOUR FILESYSTEM!!!\n"));
+					break;
 				default:
 					unknown('o', val);
 					break;

