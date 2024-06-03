Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165C8405D8
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717442618; cv=none; b=oRAF2WDje41Sg3FB/kcFFrn0PWBWJdQ/NaJXI1eEo91ZPSKxMTp0gML8mca5HMFI5gJv5Wn2WwNPCl7oZOt8iIj/46a2DwaVfzRo9VOmI4Sbp8YNURHXo+V+1kBuusM/Z+AhRVLOzKIz8YJFje4MK0z8+LeKbBHhxORiJq9JfRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717442618; c=relaxed/simple;
	bh=aZwhe3ZhywT4Od5QgWwbYcqIYrymTGf7G6C5NYTENkQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LP2kNMbyaelXP/fLkiH9trGFvdWwpVAaaCveuhMgnUTwKLSskDeMfC3x3OdFA8u19oAc/itLXh+0pzTaW6Glie+4LSMi2C4ykj8y7Ouz0hSIu6O+3wMKFVCwwjmwW1DtfycQBbVTaSfR/KdXI/YMzpSQJNmXPGFQHkSIZ/vkI/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aDcWFV5Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aDcWFV5Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3094C2BD10;
	Mon,  3 Jun 2024 19:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717442617;
	bh=aZwhe3ZhywT4Od5QgWwbYcqIYrymTGf7G6C5NYTENkQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aDcWFV5YyIEd1wZqcUrf+wuGxeTrKj5MAHwaDMvtBHMdP1uanvYzqN10j7ZgcIals
	 VKJPoMZE9SAUm5kSBgakOoj+ECkHujzF13vJ2nHkd8WeNcKOGj8h4KAK++BhZsvLhC
	 fdAa8mbS8mgkVXYi80HxJdDYTbmRY3zEIGmxt+0xgWzvQ++TIYTwl2lTu693fdn8Fa
	 0Xw1hnt7NXhlOH2q+KF0b1v6V6Ip8CFcUtX34iak25GWElQh42//6MVu6mn28BkdYl
	 mdXPCPL9O6HYYCeq/nXg3B3OTetL/z3wTyy9B8PhqsBZGcm6Hx5DX8GIcbz/6PkZzW
	 3k1xhwyNuYRRw==
Date: Mon, 03 Jun 2024 12:23:37 -0700
Subject: [PATCH 3/5] xfs_scrub: update health status if we get a clean bill of
 health
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171744042419.1449803.4492026477850863110.stgit@frogsfrogsfrogs>
In-Reply-To: <171744042368.1449803.3300792972803173625.stgit@frogsfrogsfrogs>
References: <171744042368.1449803.3300792972803173625.stgit@frogsfrogsfrogs>
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

