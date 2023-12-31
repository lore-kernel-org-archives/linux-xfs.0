Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5782C2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IaNcWuJw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7088FC433C8;
	Sun, 31 Dec 2023 23:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066892;
	bh=eg8+0rvdkqScq2QyjaA7QMFq+gvy8goPgsy30Z6KgTs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IaNcWuJwn08OlKr8YYdEGIpZOggdOXmk2MKS1K1RM33/dFcFdeuAZgBl7F+XZEFqz
	 zbigNtueeCTeBcyyPWLV0oGozl7WzndVZr5TQrkKZOjXonnafg5odfY4FNz2T3Mxy1
	 uR0i4TPpo1tcvpKx4xzj7PpW48Z4uGP9T5jSbw7Y1GSnuaUdGSXnwQ8K9f+kTDm4nR
	 e5dZWXyOn6K6VBdotZINzjkF/bE00d6Uo44QZo3G2bDraR0w2dY56Y3IPoNlkCzRaH
	 gJaOWM0jyqxi0kawIX/eowtUi9GaKkX56byACS2cWv/BbiBJrW7DuzNF7woZlfjOfQ
	 IfMdRY20I+okw==
Date: Sun, 31 Dec 2023 15:54:51 -0800
Subject: [PATCH 28/52] xfs_repair: support adding rtgroups to a filesystem
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012540.1811243.14950637052724269713.stgit@frogsfrogsfrogs>
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

Allow users to add the rtgroups feature to a filesystem if the
filesystem does not already have a realtime volume attached.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man8/xfs_admin.8 |    9 +++++++++
 repair/globals.c     |    1 +
 repair/globals.h     |    1 +
 repair/phase2.c      |   42 ++++++++++++++++++++++++++++++++++++++++++
 repair/xfs_repair.c  |   11 +++++++++++
 5 files changed, 64 insertions(+)


diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index 68b4bf62427..57e08bb8212 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -193,6 +193,15 @@ device.
 The filesystem cannot be downgraded after this feature is enabled.
 This upgrade can fail if any AG has less than 5% free space remaining.
 This feature is not upstream yet.
+.TP 0.4i
+.B rtgroups
+Create allocation groups for the realtime volume, to increase parallelism.
+This is required for reverse mapping btrees and reflink support on the realtime
+device.
+The filesystem cannot be downgraded after this feature is enabled.
+This upgrade is not possible if a realtime volume has already been added to the
+filesystem.
+This feature is not upstream yet.
 .RE
 .TP
 .BI \-U " uuid"
diff --git a/repair/globals.c b/repair/globals.c
index e3b2697127f..b121d6e2d6d 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -57,6 +57,7 @@ bool	add_reflink;		/* add reference count btrees */
 bool	add_rmapbt;		/* add reverse mapping btrees */
 bool	add_parent;		/* add parent pointers */
 bool	add_metadir;		/* add metadata directory tree */
+bool	add_rtgroups;		/* add realtime allocation groups */
 
 /* misc status variables */
 
diff --git a/repair/globals.h b/repair/globals.h
index 1c24e313b89..f5dcc11f410 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -98,6 +98,7 @@ extern bool	add_reflink;		/* add reference count btrees */
 extern bool	add_rmapbt;		/* add reverse mapping btrees */
 extern bool	add_parent;		/* add parent pointers */
 extern bool	add_metadir;		/* add metadata directory tree */
+extern bool	add_rtgroups;		/* add realtime allocation groups */
 
 /* misc status variables */
 
diff --git a/repair/phase2.c b/repair/phase2.c
index cc7ddad8240..4cb0d7946bf 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -16,6 +16,8 @@
 #include "scan.h"
 #include "quotacheck.h"
 
+#define TERABYTES(count, blog)	((uint64_t)(count) << (40 - (blog)))
+
 /* workaround craziness in the xlog routines */
 int xlog_recover_do_trans(struct xlog *log, struct xlog_recover *t, int p)
 {
@@ -352,6 +354,44 @@ set_metadir(
 	return true;
 }
 
+static bool
+set_rtgroups(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*new_sb)
+{
+	uint64_t		rgsize;
+
+	if (xfs_has_rtgroups(mp)) {
+		printf(_("Filesystem already supports realtime groups.\n"));
+		exit(0);
+	}
+
+	if (!xfs_has_metadir(mp)) {
+		printf(
+	_("Realtime allocation group feature only supported if metadir is enabled.\n"));
+		exit(0);
+	}
+
+	if (xfs_has_realtime(mp)) {
+		printf(
+	_("Realtime allocation group feature cannot be added to existing realtime volumes.\n"));
+		exit(0);
+	}
+
+	printf(_("Adding realtime groups to filesystem.\n"));
+	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_RTGROUPS;
+	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+	new_sb->sb_rgcount = 0;
+	/*
+	 * The allocation group size is 1TB, rounded down to the nearest rt
+	 * extent.
+	 */
+	rgsize = TERABYTES(1, mp->m_sb.sb_blocklog);
+	rgsize -= rgsize % mp->m_sb.sb_rextsize;
+	new_sb->sb_rgblocks = rgsize;
+	return true;
+}
+
 struct check_state {
 	struct xfs_sb		sb;
 	uint64_t		features;
@@ -627,6 +667,8 @@ upgrade_filesystem(
 		dirty |= set_parent(mp, &new_sb);
 	if (add_metadir)
 		dirty |= set_metadir(mp, &new_sb);
+	if (add_rtgroups)
+		dirty |= set_rtgroups(mp, &new_sb);
 	if (!dirty)
 		return;
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 811e89317f1..e3701f91470 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -75,6 +75,7 @@ enum c_opt_nums {
 	CONVERT_RMAPBT,
 	CONVERT_PARENT,
 	CONVERT_METADIR,
+	CONVERT_RTGROUPS,
 	C_MAX_OPTS,
 };
 
@@ -88,6 +89,7 @@ static char *c_opts[] = {
 	[CONVERT_RMAPBT]	= "rmapbt",
 	[CONVERT_PARENT]	= "parent",
 	[CONVERT_METADIR]	= "metadir",
+	[CONVERT_RTGROUPS]	= "rtgroups",
 	[C_MAX_OPTS]		= NULL,
 };
 
@@ -392,6 +394,15 @@ process_args(int argc, char **argv)
 		_("-c metadir only supports upgrades\n"));
 					add_metadir = true;
 					break;
+				case CONVERT_RTGROUPS:
+					if (!val)
+						do_abort(
+		_("-c rtgroups requires a parameter\n"));
+					if (strtol(val, NULL, 0) != 1)
+						do_abort(
+		_("-c rtgroups only supports upgrades\n"));
+					add_rtgroups = true;
+					break;
 				default:
 					unknown('c', val);
 					break;

