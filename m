Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D4535E1AA
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 19:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792179613; cv=none; b=keS6ZZykZDhUaTyA7PQFs83nNXCgwQRIMQDBCZ/1aLLY6QBe0zFYhGCi+GICCbAKrf5eW7X9Cgwypmv3cnz/C0Wus4rArpukJ2jPS9yq52pZcatdta+jOXTlUhbs+eEdDcTxsr4Kb8cB5wSx8T2duo3K0t04wZd9S6hhtxdO4UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792179613; c=relaxed/simple;
	bh=iNmoOuE0qJb/ZVEt/pNyNRobtdOVcCT52Z5Fperfphs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qsGgi+aX1BpkUc/g2VMoRyH/7kfnTtKdEM0xBoVWssHnLNnhhOKTq7v28L0cSKPqnOtXgN/NEd7Dl3dgsfRSMzQfcP14AxBjvC7MgP6M2wSmMnHKlw4TarWHUZJxJ2sVe+iIOJbUUFLoGHB75A50zrAknwru4enNit4VLJ0rryw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mKNvJhoy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mKNvJhoy"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 511A11F000C4;
	Fri, 16 Oct 2026 19:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792179612;
	bh=1wd1X1SHJpQJPrLAHRnf7sBOgqtR2HiWRUXXb0N0L8w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=mKNvJhoyKgS2XR3HaRUH02Huek6tVLoezsoORD38rc5ITTEmMu7qSuLK59U1HPsb2
	 ggsARiuZhls/Gg6LRjaYUTNOA5upOCGqQteCEKgflOdp5Qj2fwfKEg0P12eQ0NwJaz
	 vKoaiClVvXgj75OBYLFDdJwGAuc/JF4Byx6bfmLRNSzqEIJpdcSuWd1BGW36kf7PRB
	 0xWrNeD2iyaPE1/retlcZLC9ASTVSRqV3npuGEo0CYGraLkpIj0SsLki1n9JlaLfvd
	 X0IJTfay30TmSFycsZv4FNx8QhorC5L9Il6/SfWNV0RI8vyjmDZ5COQSlNbIKrdm/O
	 h1swmnoficT5Q==
Date: Fri, 16 Oct 2026 12:40:11 -0700
Subject: [PATCH 09/10] xfs_repair: skip free space checks when upgrading
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <179217942904.717548.3915597165075499911.stgit@frogsfrogsfrogs>
In-Reply-To: <179217942688.717548.16906066734797910984.stgit@frogsfrogsfrogs>
References: <179217942688.717548.16906066734797910984.stgit@frogsfrogsfrogs>
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
 repair/globals.h    |    1 +
 repair/globals.c    |    1 +
 repair/phase2.c     |    2 ++
 repair/xfs_repair.c |   11 +++++++++++
 4 files changed, 15 insertions(+)


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
diff --git a/repair/phase2.c b/repair/phase2.c
index 16bdb579e702a5..f0466bc2992161 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -668,6 +668,8 @@ need_check_fs_free_space(
 	struct xfs_mount		*mp,
 	const struct check_state	*old)
 {
+	if (skip_freesp_check_on_upgrade)
+		return false;
 	if (xfs_has_finobt(mp) && !(old->features & XFS_FEAT_FINOBT))
 		return true;
 	if (xfs_has_reflink(mp) && !(old->features & XFS_FEAT_REFLINK))
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index dd27672f874f26..6cc5ad4dc8996c 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -47,6 +47,7 @@ enum o_opt_nums {
 	BLOAD_LEAF_SLACK,
 	BLOAD_NODE_SLACK,
 	NOQUOTA,
+	SKIP_FREESP_CHECK,
 	O_MAX_OPTS,
 };
 
@@ -60,6 +61,7 @@ static char *o_opts[] = {
 	[BLOAD_LEAF_SLACK]	= "debug_bload_leaf_slack",
 	[BLOAD_NODE_SLACK]	= "debug_bload_node_slack",
 	[NOQUOTA]		= "noquota",
+	[SKIP_FREESP_CHECK]	= "debug_skip_freesp_check_on_upgrade",
 	[O_MAX_OPTS]		= NULL,
 };
 
@@ -324,6 +326,15 @@ process_args(int argc, char **argv)
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

