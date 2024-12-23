Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394171AB53A
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991986; cv=none; b=rSGn5KWR/n1mKEMaM73YQtU5xG8EjOgBr8Y6whz0KHgMlbFa5rtu0carFgRmuY3r/d/FYoI6A4OB8xWQSPMAG0ycnKgiwp28nNwVWFXDerL38AM0TaRaksevexJfvcUhoRnq5Il/LWsN0GcIJi+o9oDk16y1SwFwVH2LIv7UVYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991986; c=relaxed/simple;
	bh=kyjUi+7JEO1+vHOV3CwmL9k9hl+qI5tUUlFiLfGg3g4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nd8QVQL0bwttyvm8PGcI9H3xbbo6tVtFU/mM2VLdTGSZJSpB35qkhKTxhgyJIS3xt13TEtzwwvVSHnFOoBfizAhrLZtxNVVp2h3E7oDc6gLiZYnSTcMzRL342nNQioGBunFhbhOrO5LXAOmjtRYZUZhNdBbBYPOcAsCUwOo+sBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r6J2oN9o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r6J2oN9o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B773CC4CED3;
	Mon, 23 Dec 2024 22:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991984;
	bh=kyjUi+7JEO1+vHOV3CwmL9k9hl+qI5tUUlFiLfGg3g4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=r6J2oN9o0Heeg1Xqm1aEd9RbjbvAoDGMgElOn+lughC/Ec2ksXnklI6GlCCPxQJ/A
	 6fUOnCS6Tw9cDgOtzhSOmOawD9FryzH+1EM/ErXdPDtqfsunzw6Kj2MWX2SLARKWlA
	 s0/8l1+oOue3iPUcGfXaqFFjFfhjjHl+EJXlPXo+aOKC1bcivtfDa44Yi4IXJGhNEP
	 rDqVx1IkKyvPDam8kmdYEmxMn0v3nAn4Vsc82u2JEdrtZJjqDKHWszZyRW5U9hf95b
	 DC7Z6paYNp5DK8Hp4DcEXUlrZcTDB9uKVXjfe+MJmdpe++Mldj/czFCKR54exismXr
	 Tgxtspomrh74g==
Date: Mon, 23 Dec 2024 14:13:04 -0800
Subject: [PATCH 05/51] libfrog: scrub the realtime group superblock
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498943880.2297565.13233945030751684553.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Enable scrubbing of realtime group superblocks in xfs_scrub, and
update the scrub ioctl documentation.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/scrub.c                     |    5 +++++
 libfrog/scrub.h                     |    1 +
 man/man2/ioctl_xfs_scrub_metadata.2 |    9 +++++++++
 scrub/repair.c                      |    1 +
 scrub/scrub.c                       |    6 ++++++
 5 files changed, 22 insertions(+)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index b2d58c7a966b0d..e7fb8b890bc133 100644
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
index a35d3e9c293fe5..83455c390e170a 100644
--- a/libfrog/scrub.h
+++ b/libfrog/scrub.h
@@ -16,6 +16,7 @@ enum xfrog_scrub_group {
 	XFROG_SCRUB_GROUP_ISCAN,	/* metadata requiring full inode scan */
 	XFROG_SCRUB_GROUP_SUMMARY,	/* summary metadata */
 	XFROG_SCRUB_GROUP_METAPATH,	/* metadata directory path */
+	XFROG_SCRUB_GROUP_RTGROUP,	/* per-rtgroup metadata */
 };
 
 /* Catalog of scrub types and names, indexed by XFS_SCRUB_TYPE_* */
diff --git a/man/man2/ioctl_xfs_scrub_metadata.2 b/man/man2/ioctl_xfs_scrub_metadata.2
index 1e7e327b37d226..545e3fcbac320e 100644
--- a/man/man2/ioctl_xfs_scrub_metadata.2
+++ b/man/man2/ioctl_xfs_scrub_metadata.2
@@ -88,6 +88,15 @@ .SH DESCRIPTION
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
index e594e704f51503..c8cdb98de5457b 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -546,6 +546,7 @@ repair_item_difficulty(
 		case XFS_SCRUB_TYPE_REFCNTBT:
 		case XFS_SCRUB_TYPE_RTBITMAP:
 		case XFS_SCRUB_TYPE_RTSUM:
+		case XFS_SCRUB_TYPE_RGSUPER:
 			ret |= REPAIR_DIFFICULTY_PRIMARY;
 			break;
 		}
diff --git a/scrub/scrub.c b/scrub/scrub.c
index bcd63eea1030a6..a2fd8d77d82be0 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -66,6 +66,9 @@ format_metapath_descr(
 				(unsigned long long)vhead->svh_ino);
 
 	sc = &xfrog_metapaths[vhead->svh_ino];
+	if (sc->group == XFROG_SCRUB_GROUP_RTGROUP)
+		return snprintf(buf, buflen, _("rtgroup %u %s"),
+				vhead->svh_agno, _(sc->descr));
 	return snprintf(buf, buflen, "%s", _(sc->descr));
 }
 
@@ -107,6 +110,9 @@ format_scrubv_descr(
 		return snprintf(buf, buflen, _("%s"), _(sc->descr));
 	case XFROG_SCRUB_GROUP_METAPATH:
 		return format_metapath_descr(buf, buflen, vhead);
+	case XFROG_SCRUB_GROUP_RTGROUP:
+		return snprintf(buf, buflen, _("rtgroup %u %s"),
+				vhead->svh_agno, _(sc->descr));
 	}
 	return -1;
 }

