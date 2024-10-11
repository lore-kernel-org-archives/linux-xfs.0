Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB4B8F54
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609297; cv=none; b=JVDFGlBD0uz3QDkqg7OXZklwVJy3vUJJF2ohic9GPSNc9cWZNc3uCacCG8zDEKyTbzAOi7njW6KXGiQapI48XCWvfT+//INFdu/S4FDqwVrgkrBxr8aJk4b8wYFK+LmNbZfmdKa9WiwETr5gornsgedw0hc7x2fAbR1YnHvvkTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609297; c=relaxed/simple;
	bh=gjfhfXDrNHL6pxPQXcNTBkD2bIB4M3cS2pG5MqJ5eUY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BzcR8rcWzm6cRJXB7N4qG3riG+JIy/Ch4Hjg3CgsqHh4q8NGxmKcab5/GgiNxxB9BNoyGk8ewBjdP1hXnKurA6uhvRAEnUeeNU9eXEZlv6HPVfRrB1GWMAcMFN6HmypTup1IPLhHAD7HTFh3SRtR4MANPAJzVbpu0SQXUnNIjWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H7qfVXiI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H7qfVXiI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF61C4CEC5;
	Fri, 11 Oct 2024 01:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609297;
	bh=gjfhfXDrNHL6pxPQXcNTBkD2bIB4M3cS2pG5MqJ5eUY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=H7qfVXiIv1omlfHmbWEefnRW/W/o/03qxz9BGChcsBsuRw4VAuIeysBLoUf7CkzJT
	 gbZzRwAfpHiSwpeWt87eMZsARXfOyUAaMWllcAySmp44lobEF127PigANIBFdGhwO1
	 Rokjcyzrfs/oyLfv/or3tQYH6yYaMq2ykcLL/Orqt/CU+B4djUkjXhhxBIwt2or1x+
	 M7JwSaIKwPGsc2p+Z1r652aoR0yatTOqzW6j9pkiXj0ob+QfJRFfsp/Bxdv5qYongK
	 MPA1Z3tR2GVI5PwScJ/AM5CP6jmWgOUj6bcIWkBrlcGXX2Msw7zs/ltK8uIwa6npgI
	 yBS/68oYjQCIw==
Date: Thu, 10 Oct 2024 18:14:57 -0700
Subject: [PATCH 03/38] xfs_io: support scrubbing metadata directory paths
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860654023.4183231.14503249535049144377.stgit@frogsfrogsfrogs>
In-Reply-To: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
References: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
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

Support invoking the metadata directory path scrubber from xfs_io for
testing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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

