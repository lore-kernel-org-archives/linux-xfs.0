Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7E057CA6
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716348020; cv=none; b=UmU6AzKH/LJCSEfeWDtxtfUwuvfr19oXLp9toTaG8pHZy8UiaeVmzmm6dFZT3AjdHGZx3St8bBR+h9Exe7sWRzKvnKS3ce+QWHRzyVMptTWFRj9e0W6vEAm6JIcRxdVA2j2fLTN9NdIemm2Qv8BAJE4pK2iWkclU2zT/pPPOVXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716348020; c=relaxed/simple;
	bh=aZwhe3ZhywT4Od5QgWwbYcqIYrymTGf7G6C5NYTENkQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mIE8wB4dHS53KUytU1RZ8rLk5rPYho9kMcsfPjXAqKLokzX0hG4/sDi8iN+sXsYnzFCNcc592yVdU1fMYjDN6NJebVKO6sfxTqlKqpzSWbiFg0XPHjp7+Sz3ywT9cOA6L4zwMHcqbbwmiW4w5O3sVtx0KlV6Lt0oomM5OtIobQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dhycDZ/X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dhycDZ/X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB49C32786;
	Wed, 22 May 2024 03:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716348020;
	bh=aZwhe3ZhywT4Od5QgWwbYcqIYrymTGf7G6C5NYTENkQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dhycDZ/XiM4uUGakNS4/c/yh4qnk4G1Wvd3vc9FH8txcMtLiJ3uhtA5tc/ETZ9zL1
	 eYeX3IuVORrz/7vON7wOYnuFVr4OFGZ2qJJLTmAHJigqTWfFaALtk0P89GD2S1sZ+C
	 GTqZXYdqJbxnClwZ2ZKgIk0QgvQ5S8+FcOJ9a0ptmvtz5RnV0uM3bPp8/w2w/0pxbr
	 qmSY4c3VjgYfFcQRBAgWkuIgBw6wDeF7ZLEq8jBfWgoQt4CuMbA2FfbRGEGtAJ6rwG
	 ER7h2LvKjnPJZjKY1gSFt9Khj9f4sAjTyxvI+7rvgaXtxnOVZ0JnOYbpHEjnlkgqpx
	 23XSMVDvOJF4g==
Date: Tue, 21 May 2024 20:20:20 -0700
Subject: [PATCH 3/5] xfs_scrub: update health status if we get a clean bill of
 health
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634534758.2482960.9090286545136554659.stgit@frogsfrogsfrogs>
In-Reply-To: <171634534709.2482960.7052575979502113240.stgit@frogsfrogsfrogs>
References: <171634534709.2482960.7052575979502113240.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/scrub.c                     |    5 +++++
 man/man2/ioctl_xfs_scrub_metadata.2 |    6 ++++++
 scrub/scrub.c                       |    7 +------
 3 files changed, 12 insertions(+), 6 deletions(-)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index b6b8ae042..1df2965fe 100644
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
index 8e8bb72fb..9963f1913 100644
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
index a22633a81..436ccb0ca 100644
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

