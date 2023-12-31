Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7D7C2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iPi/NYs3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9904AC433C7;
	Sun, 31 Dec 2023 23:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065766;
	bh=pGv8pJqxaIkvagYKFnvYntaJOiEE8SmNEHZMQUksg+s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iPi/NYs3vo7ebhh0EuxLctDU6Rg0RJ24PiYM3vqkIFFF/MQIjLtexlRSUAB3KTfzj
	 LZIyFvGs6Q8/C583EaRB68XYiEM59d0GAdLDJ839rmNgCR1SLIuyBm5fTLv0LMGnUv
	 jDmD2SG3LuZqTtSwu3JY/ehGTu7KhIUUP/rhWdWOc0n7Azivv6krK7V4Qpbcam/z56
	 2FMw6dFJThTIm+ATC3PsmY59ys4bVIVYQR8NKXyZOEn6U9KRYskUdY6eIgcaNEhio6
	 Bn6KBIulx4kgZeF5MeKX64B+O9BQS+LBYqgj+3knmCp41tvJ0bE+jWWT3/XrpLQeHM
	 0pqto+PisQ5hw==
Date: Sun, 31 Dec 2023 15:36:06 -0800
Subject: [PATCH 25/58] xfs_io: support scrubbing metadata directory paths
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010281.1809361.10040112335448075566.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
References: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
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
 libfrog/scrub.c |   34 +++++++++++++++++++++++++++++++++-
 libfrog/scrub.h |    2 ++
 scrub/scrub.c   |   18 ++++++++++++++++++
 3 files changed, 53 insertions(+), 1 deletion(-)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index 8264aab00ef..f48bb1a0d2b 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -154,8 +154,40 @@ const struct xfrog_scrub_descr xfrog_scrubbers[XFS_SCRUB_TYPE_NR] = {
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
+	[XFS_SCRUB_METAPATH_RTBITMAP]	= {
+		.name	= "rtbitmap",
+		.descr	= "realtime bitmap metadir path",
+		.group	= XFROG_SCRUB_GROUP_FS,
+	},
+	[XFS_SCRUB_METAPATH_RTSUMMARY]	= {
+		.name	= "rtsummary",
+		.descr	= "realtime summary metadir path",
+		.group	= XFROG_SCRUB_GROUP_FS,
+	},
+	[XFS_SCRUB_METAPATH_USRQUOTA]	= {
+		.name	= "usrquota",
+		.descr	= "user quota metadir path",
+		.group	= XFROG_SCRUB_GROUP_FS,
+	},
+	[XFS_SCRUB_METAPATH_GRPQUOTA]	= {
+		.name	= "grpquota",
+		.descr	= "group quota metadir path",
+		.group	= XFROG_SCRUB_GROUP_FS,
+	},
+	[XFS_SCRUB_METAPATH_PRJQUOTA]	= {
+		.name	= "prjquota",
+		.descr	= "project quota metadir path",
+		.group	= XFROG_SCRUB_GROUP_FS,
+	},
 };
-#undef DEP
 
 /* Invoke the scrub ioctl.  Returns zero or negative error code. */
 int
diff --git a/libfrog/scrub.h b/libfrog/scrub.h
index 43456230479..5fa0fafef56 100644
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
index 2ec3cbc9aac..bad1384dcfb 100644
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
@@ -80,6 +96,8 @@ format_scrubv_descr(
 	case XFROG_SCRUB_GROUP_ISCAN:
 	case XFROG_SCRUB_GROUP_NONE:
 		return snprintf(buf, buflen, _("%s"), _(sc->descr));
+	case XFROG_SCRUB_GROUP_METAPATH:
+		return format_metapath_descr(buf, buflen, vhead);
 	}
 	return -1;
 }

