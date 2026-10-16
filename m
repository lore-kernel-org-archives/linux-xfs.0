Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B85E25393E
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 19:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792179629; cv=none; b=ms6ru2SN0vl4YmBSxFyRDlWBS7c2V7GI56qMSLxEip/p34qpBGvyv48NJmS1kUR+1mxBvyKhnGZy8xTT61FJKcOHS1+YyLZIOmC0dQhLAqJZwkB7g/oWZzqPHsH2DLCuXrncgPN6EOd4ABUVUPulsX7Sk7Q585fx5zkGOdnld+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792179629; c=relaxed/simple;
	bh=312wx7euZibtsEtSV5id7bHG0H8wu/u8sDTNCHfOxl4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XPIJen6jetFWkbNIzre5JuScSlTOSPPpVUC8bL1A80j9sn30WyKOctVVuYSgC6moI2pM8VB1h92dA8pRtpCCPoqYCq9u8RVWhvh79twg001OWF8Vg5LuAOH0lU/fJqX5luP3ZpBCkol6qnmgK2TEYVnP0mbjnBSXt9+54+lyNN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MxDN1d05; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MxDN1d05"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E67C61F000C5;
	Fri, 16 Oct 2026 19:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792179628;
	bh=ZIYIuJ8CHOgL1v4TLohPYNBANY1ak9nfK5kK35jjKAw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=MxDN1d05RWmxBX2QZcYXMPGysqe8CH40p64pSD3xakemzgGIKE2FMx+sIglSklFGO
	 IZovUfKWkUbY3c+ElbEYTFN8IanA7NK3srD01wZsEVTgLoERBav+5f7wIOojNzFLop
	 4U08B81uLZcH2+d4mihlzTzqfqBVDf+5NAdYGA/TgOJXUrHLwILfvpFRaSLVBZUWQ+
	 HK1VXvVgLZZjZieTQFpimMs//mP4XdzAfhyjVotGE+8Qazk1pv8KOVO6tfvmNXmfgj
	 DPyUZLK6ihyNGArcaMwsctxdKPN47Bb80OuDrftFYrRO/bBt1tTaf2hnU1pplUk8q7
	 NlGdZAyltgyIg==
Date: Fri, 16 Oct 2026 12:40:27 -0700
Subject: [PATCH 10/10] xfs_repair: allow adding rmapbt to reflink filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <179217942923.717548.10242654476190047653.stgit@frogsfrogsfrogs>
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

New debugging knob so that I can upgrade a filesystem to have rmap
btrees even if reflink was already enabled.  We cannot easily precompute
the space requirements, so this is dangerous.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/globals.h    |    1 +
 repair/globals.c    |    1 +
 repair/phase2.c     |    3 ++-
 repair/xfs_repair.c |   11 +++++++++++
 4 files changed, 15 insertions(+), 1 deletion(-)


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
diff --git a/repair/phase2.c b/repair/phase2.c
index f0466bc2992161..12fc2d52261c72 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -290,7 +290,8 @@ set_rmapbt(
 		exit(0);
 	}
 
-	if (xfs_has_reflink(mp) && !add_reflink) {
+	if (xfs_has_reflink(mp) && !add_reflink &&
+	    !allow_rmapbt_upgrade_with_reflink) {
 		printf(
 	_("Reverse mapping btrees cannot be added when reflink is enabled.\n"));
 		exit(0);
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 6cc5ad4dc8996c..10ca291cead40c 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -48,6 +48,7 @@ enum o_opt_nums {
 	BLOAD_NODE_SLACK,
 	NOQUOTA,
 	SKIP_FREESP_CHECK,
+	ALLOW_RMAPBT_UPGRADE_WITH_REFLINK,
 	O_MAX_OPTS,
 };
 
@@ -62,6 +63,7 @@ static char *o_opts[] = {
 	[BLOAD_NODE_SLACK]	= "debug_bload_node_slack",
 	[NOQUOTA]		= "noquota",
 	[SKIP_FREESP_CHECK]	= "debug_skip_freesp_check_on_upgrade",
+	[ALLOW_RMAPBT_UPGRADE_WITH_REFLINK] = "debug_allow_rmapbt_upgrade_with_reflink",
 	[O_MAX_OPTS]		= NULL,
 };
 
@@ -335,6 +337,15 @@ process_args(int argc, char **argv)
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

