Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A7D29415
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735689348; cv=none; b=FgqLcZhLbkoob3tCc+dK+jQf3eeBjbonxnWMOEQVqaTDkwUuRU+8YTZ1Ta3IePrwU2KBF72JKHutbSViDHlV8MdM/VwclGUdmhA/VsUt70SpNq4IxOODXAJmIJT4ty2gIl/7vfLZl9uf1xJJ4Xal3OZcfkZPX20EAZtRTERewGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735689348; c=relaxed/simple;
	bh=iW0VSLmxwouGLalyJTPjrXf3Oly3hMgfOoGGOwu7Ac4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sE8/HRJ+EGmJMpaU2J0BQzx7g3+JM79USfEwFGuZ4hDLv3EvfkRXrqua6DWbqSRDqjsO625/WUVvjQYkJ4qNFglwfeBp8q5vATSt9wQPSOLI0B4xSVavCsQlq8l9PARTpstGBVTl+x43kVbLGo2QHj7M0P7kSKQIcmxVtOPT7uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N77OdRyT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N77OdRyT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA56BC4CED2;
	Tue, 31 Dec 2024 23:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735689347;
	bh=iW0VSLmxwouGLalyJTPjrXf3Oly3hMgfOoGGOwu7Ac4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=N77OdRyTv3wnn41dD56tZbC/J8MSXOrTBHYgRupnHFwTb8nTk6MgHlK7OodJpAGnJ
	 qcvBFMtHrm5s7iodyko8OiVyWkX+7BuDpjGg3y2LAu8ATPkLrZu1wndvxiWctkR5bD
	 5rm7FLCDAJ2aqj9G+c7tM+QdRIAXlakaAB6bI1A9fQYyoiM42zJEuQXep5Y2BSnRSK
	 MmE2AFv7LXrrc370AB/P7SoAnzMZJQLfcxUu5dUJ47D9C5bBJ/Wgu/S+oNKN29rDOJ
	 EY+cf4wOKk4v/f70qMT5PZc0QN/tLPJMZi+79dWBE8tdNKUuJl6EflLtlvub9+T7s0
	 zM0zK1LyWw+gA==
Date: Tue, 31 Dec 2024 15:55:47 -0800
Subject: [PATCH 10/10] xfs_repair: allow adding rmapbt to reflink filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568779287.2710949.3018758018747416020.stgit@frogsfrogsfrogs>
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

New debugging knob so that I can upgrade a filesystem to have rmap
btrees even if reflink was already enabled.  We cannot easily precompute
the space requirements, so this is dangerous.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/globals.c    |    1 +
 repair/globals.h    |    1 +
 repair/phase2.c     |    3 ++-
 repair/xfs_repair.c |   11 +++++++++++
 4 files changed, 15 insertions(+), 1 deletion(-)


diff --git a/repair/globals.c b/repair/globals.c
index fe9f9ac5914bb0..f4f1d317917183 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -49,6 +49,7 @@ int	rt_spec;		/* Realtime dev specified as option */
 int	convert_lazy_count;	/* Convert lazy-count mode on/off */
 int	lazy_count;		/* What to set if to if converting */
 bool	skip_freesp_check_on_upgrade; /* do not enable */
+bool	allow_rmapbt_upgrade_with_reflink; /* add rmapbt when reflink already on */
 bool	features_changed;	/* did we change superblock feature bits? */
 bool	add_inobtcount;		/* add inode btree counts to AGI */
 bool	add_bigtime;		/* add support for timestamps up to 2486 */
diff --git a/repair/globals.h b/repair/globals.h
index c660971080f7e4..febbbbcc81f931 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -90,6 +90,7 @@ extern int	rt_spec;		/* Realtime dev specified as option */
 extern int	convert_lazy_count;	/* Convert lazy-count mode on/off */
 extern int	lazy_count;		/* What to set if to if converting */
 extern bool	skip_freesp_check_on_upgrade; /* do not enable */
+extern bool	allow_rmapbt_upgrade_with_reflink; /* add rmapbt when reflink already on */
 extern bool	features_changed;	/* did we change superblock feature bits? */
 extern bool	add_inobtcount;		/* add inode btree counts to AGI */
 extern bool	add_bigtime;		/* add support for timestamps up to 2486 */
diff --git a/repair/phase2.c b/repair/phase2.c
index 780294d24c9900..29a406f69ca3a1 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -283,7 +283,8 @@ set_rmapbt(
 		exit(0);
 	}
 
-	if (xfs_has_reflink(mp) && !add_reflink) {
+	if (xfs_has_reflink(mp) && !add_reflink &&
+	    !allow_rmapbt_upgrade_with_reflink) {
 		printf(
 	_("Reverse mapping btrees cannot be added when reflink is enabled.\n"));
 		exit(0);
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 55e417201b34f7..4cff11d81d6bcb 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -47,6 +47,7 @@ enum o_opt_nums {
 	BLOAD_NODE_SLACK,
 	NOQUOTA,
 	SKIP_FREESP_CHECK,
+	ALLOW_RMAPBT_UPGRADE_WITH_REFLINK,
 	O_MAX_OPTS,
 };
 
@@ -61,6 +62,7 @@ static char *o_opts[] = {
 	[BLOAD_NODE_SLACK]	= "debug_bload_node_slack",
 	[NOQUOTA]		= "noquota",
 	[SKIP_FREESP_CHECK]	= "debug_skip_freesp_check_on_upgrade",
+	[ALLOW_RMAPBT_UPGRADE_WITH_REFLINK] = "debug_allow_rmapbt_upgrade_with_reflink",
 	[O_MAX_OPTS]		= NULL,
 };
 
@@ -334,6 +336,15 @@ process_args(int argc, char **argv)
 						do_log(
 		_("WARNING: Allowing filesystem upgrades to proceed without free space check.  THIS MAY DESTROY YOUR FILESYSTEM!!!\n"));
 					break;
+				case ALLOW_RMAPBT_UPGRADE_WITH_REFLINK:
+					if (!val)
+						do_abort(
+		_("-o debug_allow_rmapbt_upgrade_with_reflink requires a parameter\n"));
+					allow_rmapbt_upgrade_with_reflink = (int)strtol(val, NULL, 0);
+					if (allow_rmapbt_upgrade_with_reflink)
+						do_log(
+		_("WARNING: Allowing filesystem upgrade to rmapbt when reflink enabled.  THIS MAY DESTROY YOUR FILESYSTEM!!!\n"));
+					break;
 				default:
 					unknown('o', val);
 					break;

