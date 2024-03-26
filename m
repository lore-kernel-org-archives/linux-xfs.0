Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755DB12838F
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711425585; cv=none; b=QAaM7RXtK+SGTrJLEgEcG9SbwKSSIgw5kRPMiTf4hwvgUW8PhioeDVj2N0i12u5lbJaPdke76A8RpuPnYyE1OF3PLhvqMYUN2/CLrFN+bGMFl1GUiLCFSxlCcSSo78qVU+vRUYuv+icYENg7yNI3SBJBs0HLS4UHzvf4411+bcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711425585; c=relaxed/simple;
	bh=xrbrAHoQbEU5o39uJPIGuZMEAzz4xWjm9SAww5yaKwU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TZ2/UseYwu9XOggyc7YDcrzV/utMD2SzoCgizAchXqJKEC6kt/Uru++a6aHzPIivhsRGpscIKoiGKZkEoAr+w/5oqzH9PKPoo+JvuxKFaYznc8kOefZElkULeOyyscB099gznanIeERcoWvmw6ifz1hnStMJnF9aAsTmByG6ox8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mb3e2v6l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mb3e2v6l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49CF7C433C7;
	Tue, 26 Mar 2024 03:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711425585;
	bh=xrbrAHoQbEU5o39uJPIGuZMEAzz4xWjm9SAww5yaKwU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mb3e2v6lZXLClutgqCoKejw+mWSZG09ZmGvT5LSZpeZG00TWekseVkDnNavpNGJ67
	 LBXTFUTNhg38QriPvXfQ9+zMxFeHBAR1hVI/T+8VEG1ySDhmd8/Y0vIlQ2Ike73RFt
	 RHwTIvJNW4Q+XA8qgY4M7AJL6Vfr3oaZBSIVNW6/8dazjnjV8mNKuPziWZzfCBmZyL
	 QpkSazZFMp7i8vN+Ib1cqvnhOrVsRSqb7WPed+ET9xLXIM5OCWQGTKzYRUDUHc0p6Y
	 3Qo8zs2OyilvLP9/CBV2LL65OaYpht8WO2qiVpeVAVkdrzKKy8/h2KWSu3Fxn5QN9p
	 lHcphvZd886KQ==
Date: Mon, 25 Mar 2024 20:59:44 -0700
Subject: [PATCH 3/5] xfs_scrub: update health status if we get a clean bill of
 health
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171142134352.2218196.1061886253403832667.stgit@frogsfrogsfrogs>
In-Reply-To: <171142134302.2218196.4456442187285422971.stgit@frogsfrogsfrogs>
References: <171142134302.2218196.4456442187285422971.stgit@frogsfrogsfrogs>
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

If we checked a filesystem and it turned out to be clean, upload that
information into the kernel.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/scrub.c                     |    5 +++++
 man/man2/ioctl_xfs_scrub_metadata.2 |    6 ++++++
 scrub/scrub.c                       |    7 +------
 3 files changed, 12 insertions(+), 6 deletions(-)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index b6b8ae042c44..1df2965fe2d4 100644
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
diff --git a/man/man2/ioctl_xfs_scrub_metadata.2 b/man/man2/ioctl_xfs_scrub_metadata.2
index 8e8bb72fb3bf..9963f1913e60 100644
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
index a22633a81157..436ccb0ca8c3 100644
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

