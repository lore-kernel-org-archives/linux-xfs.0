Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF5D14D717
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528504; cv=none; b=cie64IBmn7y3vj+1wyjNBSe4vMtes4rBfK0gxwTQ29p7u8D/KRq2rWfzm2mVmvsLTcveCkT18FlAjwGwkirRwDcCyZUMaVd0sjNUvGydRsZia49E83wcF+VeZ7JUqZchoANEHtMNoEpJoPF6WjSCr0PG00XWlsoi0/dmidsf5hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528504; c=relaxed/simple;
	bh=o/ly8O0JIafHUtrrAijltVLSp9DFscstSadZl2MY2M8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lr4m0uJR5KGR9OmplWWluQAQAoIP1v+5bV2oSwz953EKNt2NNtqSJDmRt4oznSI2CMspM4lszACUYQxZj1Owlxx408NiR+dqpcGp15ZePFBiyUYo1jDN4n7axtEVs2Jf1G7YgL8vfO5nnalIdPJp0jrxo/HQ9BTJTsevgCy+1tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hqvB+W11; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hqvB+W11"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35090C4CED1;
	Fri,  6 Dec 2024 23:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528504;
	bh=o/ly8O0JIafHUtrrAijltVLSp9DFscstSadZl2MY2M8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hqvB+W11byXUmlslkB5Nz/rKiRIDIYO2CFgdR8arda12Zt5nNOKTAiFas3eOoVa0/
	 ypHAmY8gXO/c9yh4E0Fst1uYvn9P8tyep1j9SYwK8s92XP/+yNgMBNcTwbsZyTql+j
	 6iVJWfNqgvrPqaCUPIx8HZ/5LJKkXe19ITTQw3P+0Z1DoYpiOhNxnFLNzA9hhp5lDs
	 sRvXOoY4weOif0Glehr909qwTvG4adYEZV2ytuAzknbDBI34PHNitLkWfbBWc84HBI
	 cjTXe8BwkYYBcu2+LToFJtit8+MIFIRi6WA/ecp1XEPjA+FLqhxt474/hx0c5RwP0I
	 E6SvNCPASmp4g==
Date: Fri, 06 Dec 2024 15:41:43 -0800
Subject: [PATCH 08/41] xfs_io: support scrubbing metadata directory paths
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352748361.122992.14800316196936096339.stgit@frogsfrogsfrogs>
In-Reply-To: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
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

