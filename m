Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03EF19048A
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990516; cv=none; b=B/wSlU9erKKr8jWRxNyeCgr2z4JBBtk1vp0M5z2kjb9X0mVe59O8auAFuLZ0sCXJENHLdeyetC1A9JC+AddUAQ2gi3U5ICTBskgHDyC5TsTVmQbPssValLOLShahRDJK8NMlfJLPLfECSvfYHNaMpY9ZFr+3kdFPmKt5UIM1mIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990516; c=relaxed/simple;
	bh=u4VGsM8ngB0B3hDN54rJQ9YgmCLjUJ8WJVh/7na0sEo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GudIkrSn/RnYM1FYol2wOippW5doE9DYCxz4tJ4wQhy82NmvU5H8MX242PSG+pBjKBL1fnWM8rrQuDEfwA8P4nQ4uroDXgrOWr7Y+fExHTm0fEh6hVhP6wAX/LWTUrxIJIhcMs5uums8NkM6IpAG6vtzOnqqYSRgc5gZ8e1iDa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=URcFkfSD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="URcFkfSD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73AE8C4CED3;
	Mon, 23 Dec 2024 21:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990515;
	bh=u4VGsM8ngB0B3hDN54rJQ9YgmCLjUJ8WJVh/7na0sEo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=URcFkfSD/DibVe9x9QU0DaZDND/fr7Tt7SzJB8Y6iRopMrEeP8zsQ3k2mmgwwi2Qf
	 o1dVSB3RpRZW1KnC3c256m/za3WdBc99RZEFQnQ/8QbUG9l6TacSBUatg7Rn1x/+Co
	 8OCTucGRPEGW0Ef6mlMc0Gm4kFUJWfuxdTvN7flLWR/7YD49iTZrVpzZmLOY2RCrk5
	 jJC0F4vm2lAnlnfqWu1MhScdpKZcIbnGGBUjgHE+Yfv7uefxDtJG9wGS4uujOMkvlw
	 H2vn+SY67ur07CXLbhu0wSgf/gvVCYtIvcCuOJsDNGQFRXlDZyRgXzQICvSiZwKndv
	 ar2Od9Q1ACApg==
Date: Mon, 23 Dec 2024 13:48:34 -0800
Subject: [PATCH 08/41] xfs_io: support scrubbing metadata directory paths
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498941090.2294268.13647827378022473290.stgit@frogsfrogsfrogs>
In-Reply-To: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
References: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Support invoking the metadata directory path scrubber from xfs_io for
testing.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/scrub.c |   14 +++++++++++++-
 libfrog/scrub.h |    2 ++
 scrub/scrub.c   |   18 ++++++++++++++++++
 3 files changed, 33 insertions(+), 1 deletion(-)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index e233c0f9c8e1e6..b2d58c7a966b0d 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -154,8 +154,20 @@ const struct xfrog_scrub_descr xfrog_scrubbers[XFS_SCRUB_TYPE_NR] = {
 		.descr	= "directory tree structure",
 		.group	= XFROG_SCRUB_GROUP_INODE,
 	},
+	[XFS_SCRUB_TYPE_METAPATH] = {
+		.name	= "metapath",
+		.descr	= "metadata directory paths",
+		.group	= XFROG_SCRUB_GROUP_METAPATH,
+	},
+};
+
+const struct xfrog_scrub_descr xfrog_metapaths[XFS_SCRUB_METAPATH_NR] = {
+	[XFS_SCRUB_METAPATH_PROBE] = {
+		.name	= "probe",
+		.descr	= "metapath",
+		.group	= XFROG_SCRUB_GROUP_NONE,
+	},
 };
-#undef DEP
 
 /* Invoke the scrub ioctl.  Returns zero or negative error code. */
 int
diff --git a/libfrog/scrub.h b/libfrog/scrub.h
index b564c0d7bd0f55..a35d3e9c293fe5 100644
--- a/libfrog/scrub.h
+++ b/libfrog/scrub.h
@@ -15,6 +15,7 @@ enum xfrog_scrub_group {
 	XFROG_SCRUB_GROUP_INODE,	/* per-inode metadata */
 	XFROG_SCRUB_GROUP_ISCAN,	/* metadata requiring full inode scan */
 	XFROG_SCRUB_GROUP_SUMMARY,	/* summary metadata */
+	XFROG_SCRUB_GROUP_METAPATH,	/* metadata directory path */
 };
 
 /* Catalog of scrub types and names, indexed by XFS_SCRUB_TYPE_* */
@@ -25,6 +26,7 @@ struct xfrog_scrub_descr {
 };
 
 extern const struct xfrog_scrub_descr xfrog_scrubbers[XFS_SCRUB_TYPE_NR];
+extern const struct xfrog_scrub_descr xfrog_metapaths[XFS_SCRUB_METAPATH_NR];
 
 int xfrog_scrub_metadata(struct xfs_fd *xfd, struct xfs_scrub_metadata *meta);
 
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 44c4049899d29e..bcd63eea1030a6 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -53,6 +53,22 @@ static const unsigned int scrub_deps[XFS_SCRUB_TYPE_NR] = {
 };
 #undef DEP
 
+static int
+format_metapath_descr(
+	char				*buf,
+	size_t				buflen,
+	struct xfs_scrub_vec_head	*vhead)
+{
+	const struct xfrog_scrub_descr	*sc;
+
+	if (vhead->svh_ino >= XFS_SCRUB_METAPATH_NR)
+		return snprintf(buf, buflen, _("unknown metadir path %llu"),
+				(unsigned long long)vhead->svh_ino);
+
+	sc = &xfrog_metapaths[vhead->svh_ino];
+	return snprintf(buf, buflen, "%s", _(sc->descr));
+}
+
 /* Describe the current state of a vectored scrub. */
 int
 format_scrubv_descr(
@@ -89,6 +105,8 @@ format_scrubv_descr(
 	case XFROG_SCRUB_GROUP_ISCAN:
 	case XFROG_SCRUB_GROUP_NONE:
 		return snprintf(buf, buflen, _("%s"), _(sc->descr));
+	case XFROG_SCRUB_GROUP_METAPATH:
+		return format_metapath_descr(buf, buflen, vhead);
 	}
 	return -1;
 }

