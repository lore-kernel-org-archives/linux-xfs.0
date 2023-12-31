Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F76DC2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KbgXWp6+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5FDAC433C8;
	Sun, 31 Dec 2023 23:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066751;
	bh=vM0Y4M4Rci788cKWeyHLKLjG6nIHefg5/6gG718diVw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KbgXWp6+C+8AAG+ehFc20DZG8ZDKn7mZe30m1hefF8IdAsNkR5Cej4hjIC+0AoukD
	 2k/cSu0rhN+bGuuT1SpgX5SivW61zM/2mOd5X6GVtH1on5aKbzvTq4wf5n0bh9esTC
	 A5ls4dNHjDhDLRGMHv5mJNaYs78CLlk3nyUCn23as+zS5zyh1LovqA8wURphgYQ+zR
	 XLjBiiwOumG2WPbFGLxPrhRJ6796vhMFnT9B2jM3zhNu5MivO+aQeZSHvUkivfIk/Y
	 eRAnLaCvijRrgfPn4kCpo1g3uMucDa3pKeZz2W/Ku7KO/Rg1PBSXclQuLZpZedEhgY
	 neRfQKh9ftH7g==
Date: Sun, 31 Dec 2023 15:52:31 -0800
Subject: [PATCH 19/52] xfs: scrub the realtime group superblock
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012422.1811243.10122410054802249826.stgit@frogsfrogsfrogs>
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

Enable scrubbing of realtime group superblocks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/scrub.c                     |    5 +++++
 libfrog/scrub.h                     |    1 +
 libxfs/xfs_fs.h                     |    3 ++-
 man/man2/ioctl_xfs_scrub_metadata.2 |    9 +++++++++
 scrub/repair.c                      |    1 +
 scrub/scrub.c                       |    3 +++
 6 files changed, 21 insertions(+), 1 deletion(-)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index f48bb1a0d2b..a9aad03de0d 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -159,6 +159,11 @@ const struct xfrog_scrub_descr xfrog_scrubbers[XFS_SCRUB_TYPE_NR] = {
 		.descr	= "metadata directory paths",
 		.group	= XFROG_SCRUB_GROUP_METAPATH,
 	},
+	[XFS_SCRUB_TYPE_RGSUPER] = {
+		.name	= "rgsuper",
+		.descr	= "realtime group superblock",
+		.group	= XFROG_SCRUB_GROUP_RTGROUP,
+	},
 };
 
 const struct xfrog_scrub_descr xfrog_metapaths[XFS_SCRUB_METAPATH_NR] = {
diff --git a/libfrog/scrub.h b/libfrog/scrub.h
index 5fa0fafef56..afab2b07fc4 100644
--- a/libfrog/scrub.h
+++ b/libfrog/scrub.h
@@ -16,6 +16,7 @@ enum xfrog_scrub_group {
 	XFROG_SCRUB_GROUP_ISCAN,	/* metadata requiring full inode scan */
 	XFROG_SCRUB_GROUP_SUMMARY,	/* summary metadata */
 	XFROG_SCRUB_GROUP_METAPATH,	/* metadata directory path */
+	XFROG_SCRUB_GROUP_RTGROUP,	/* per-rtgroup metadata */
 };
 
 /* Catalog of scrub types and names, indexed by XFS_SCRUB_TYPE_* */
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index c5bf53c6a43..237d13a500d 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -735,9 +735,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_HEALTHY	27	/* everything checked out ok */
 #define XFS_SCRUB_TYPE_DIRTREE	28	/* directory tree structure */
 #define XFS_SCRUB_TYPE_METAPATH	29	/* metadata directory tree paths */
+#define XFS_SCRUB_TYPE_RGSUPER	30	/* realtime superblock */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	30
+#define XFS_SCRUB_TYPE_NR	31
 
 /*
  * This special type code only applies to the vectored scrub implementation.
diff --git a/man/man2/ioctl_xfs_scrub_metadata.2 b/man/man2/ioctl_xfs_scrub_metadata.2
index b1db740560d..13f655e2b97 100644
--- a/man/man2/ioctl_xfs_scrub_metadata.2
+++ b/man/man2/ioctl_xfs_scrub_metadata.2
@@ -88,6 +88,15 @@ The allocation group number must be given in
 .BR sm_ino " and " sm_gen
 must be zero.
 
+.PP
+.TP
+.B XFS_SCRUB_TYPE_RGSUPER
+Examine a given realtime allocation group's superblock.
+The realtime allocation group number must be given in
+.IR sm_agno "."
+.IR sm_ino " and " sm_gen
+must be zero.
+
 .TP
 .B XFS_SCRUB_TYPE_INODE
 Examine a given inode record for obviously incorrect values and
diff --git a/scrub/repair.c b/scrub/repair.c
index 7e131001e13..43037a7c5e1 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -545,6 +545,7 @@ repair_item_difficulty(
 		case XFS_SCRUB_TYPE_REFCNTBT:
 		case XFS_SCRUB_TYPE_RTBITMAP:
 		case XFS_SCRUB_TYPE_RTSUM:
+		case XFS_SCRUB_TYPE_RGSUPER:
 			ret |= REPAIR_DIFFICULTY_PRIMARY;
 			break;
 		}
diff --git a/scrub/scrub.c b/scrub/scrub.c
index bad1384dcfb..8f9fde80263 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -98,6 +98,9 @@ format_scrubv_descr(
 		return snprintf(buf, buflen, _("%s"), _(sc->descr));
 	case XFROG_SCRUB_GROUP_METAPATH:
 		return format_metapath_descr(buf, buflen, vhead);
+	case XFROG_SCRUB_GROUP_RTGROUP:
+		return snprintf(buf, buflen, _("rtgroup %u %s"),
+				vhead->svh_agno, _(sc->descr));
 	}
 	return -1;
 }

