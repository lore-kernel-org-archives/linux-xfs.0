Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F828C127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jaX6DjnJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A0BC433C8;
	Sun, 31 Dec 2023 22:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060857;
	bh=bBmFnOAhv8wRl2O8eU9gytscKBAJLQuG1hOsfwwXH48=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jaX6DjnJlKBlla4jS/i1pOWaaarp/QhmLcmPrqaxb5/qbY7zG82kdw6+8H+t7yirH
	 z85xApExGBWKjGpgegfi3Zca6bURz3kSPeuJc9eq2JFqH/wUsX3tkdUouS1eXJJC45
	 EP2IFntmFhKMpSFr940//RYiNM5Plod7jzLEnrOxVW6+VQGEuYY/xyMD5JeNXg4+qy
	 RjfL/VR1r7R0FIC2/TR6tZMbrOCtPA/tWrKwhoNj5q8X8R0DWVrlR7khUuWXHxK1eA
	 V1MmZdcxLhWxg4vBs4twovpgoOfgbhFBmibjrnQM9JW+/BVbbxSxSC5uRoxLFnsgQj
	 r0V4ydC1RlhOA==
Date: Sun, 31 Dec 2023 14:14:17 -0800
Subject: [PATCH 3/4] xfs: update health status if we get a clean bill of
 health
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404992442.1794340.8471028953776733918.stgit@frogsfrogsfrogs>
In-Reply-To: <170404992400.1794340.13951488488074140755.stgit@frogsfrogsfrogs>
References: <170404992400.1794340.13951488488074140755.stgit@frogsfrogsfrogs>
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

If scrub finds that everything is ok with the filesystem, we need a way
to tell the health tracking that it can let go of indirect health flags,
since indirect flags only mean that at some point in the past we lost
some context.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/scrub.c                     |    5 +++++
 libxfs/xfs_fs.h                     |    3 ++-
 man/man2/ioctl_xfs_scrub_metadata.2 |    6 ++++++
 scrub/scrub.c                       |    7 +------
 4 files changed, 14 insertions(+), 7 deletions(-)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index b6b8ae042c4..1df2965fe2d 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -144,6 +144,11 @@ const struct xfrog_scrub_descr xfrog_scrubbers[XFS_SCRUB_TYPE_NR] = {
 		.descr	= "inode link counts",
 		.group	= XFROG_SCRUB_GROUP_ISCAN,
 	},
+	[XFS_SCRUB_TYPE_HEALTHY] = {
+		.name	= "healthy",
+		.descr	= "retained health records",
+		.group	= XFROG_SCRUB_GROUP_NONE,
+	},
 };
 
 /* Invoke the scrub ioctl.  Returns zero or negative error code. */
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index b5c8da7e6aa..ca1b17d0143 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -714,9 +714,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_FSCOUNTERS 24	/* fs summary counters */
 #define XFS_SCRUB_TYPE_QUOTACHECK 25	/* quota counters */
 #define XFS_SCRUB_TYPE_NLINKS	26	/* inode link counts */
+#define XFS_SCRUB_TYPE_HEALTHY	27	/* everything checked out ok */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	27
+#define XFS_SCRUB_TYPE_NR	28
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1u << 0)
diff --git a/man/man2/ioctl_xfs_scrub_metadata.2 b/man/man2/ioctl_xfs_scrub_metadata.2
index 8e8bb72fb3b..9963f1913e6 100644
--- a/man/man2/ioctl_xfs_scrub_metadata.2
+++ b/man/man2/ioctl_xfs_scrub_metadata.2
@@ -168,6 +168,12 @@ count) for errors.
 .TP
 .B XFS_SCRUB_TYPE_NLINKS
 Scan all inodes in the filesystem to verify each file's link count.
+
+.TP
+.B XFS_SCRUB_TYPE_HEALTHY
+Mark everything healthy after a clean scrub run.
+This clears out all the indirect health problem markers that might remain
+in the system.
 .RE
 
 .PD 1
diff --git a/scrub/scrub.c b/scrub/scrub.c
index b7ec54c16a4..cf056779526 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -39,20 +39,15 @@ format_scrub_descr(
 	case XFROG_SCRUB_GROUP_PERAG:
 		return snprintf(buf, buflen, _("AG %u %s"), meta->sm_agno,
 				_(sc->descr));
-		break;
 	case XFROG_SCRUB_GROUP_INODE:
 		return scrub_render_ino_descr(ctx, buf, buflen,
 				meta->sm_ino, meta->sm_gen, "%s",
 				_(sc->descr));
-		break;
 	case XFROG_SCRUB_GROUP_FS:
 	case XFROG_SCRUB_GROUP_SUMMARY:
 	case XFROG_SCRUB_GROUP_ISCAN:
-		return snprintf(buf, buflen, _("%s"), _(sc->descr));
-		break;
 	case XFROG_SCRUB_GROUP_NONE:
-		assert(0);
-		break;
+		return snprintf(buf, buflen, _("%s"), _(sc->descr));
 	}
 	return -1;
 }

