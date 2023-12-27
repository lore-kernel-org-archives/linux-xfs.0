Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933E4384
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TNqVS8zu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFBCC433C8;
	Mon,  1 Jan 2024 00:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068113;
	bh=x3Y4Nhde1imslMdavfYz54VefE75MYh8QFabXy8VwGo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TNqVS8zuP5PcvFzptHv6U6VmMb9MnxzPvy1bb9wCnQzAAVKuVgmwD9NWii0iIshvl
	 GDqRXjI4n92fD8TGfeVhn34QDKEZQS/6duynxEE9TBDTrjLfCxXiO98/OeZ3WMDvL1
	 Cc/sC+kM3O+WtEjObh2HIcbpdUpXdowDSA060CADEQM2x7nzdb4JpU48efEo2/W2wk
	 t2Vo9GDReG9k3k7sD2HRd8bf0FDM4yr/yAFHYu/CkazkwKo/IZKYqnQuPLrhiyvjHO
	 7obOOGJBcWlqB3GZEYb4ebGL+R/1vQBGTkKRcp9pC8fSU8H4Rm08if6X+CPr/3QM6W
	 NQZCVjspmY6Cg==
Date: Sun, 31 Dec 2023 16:15:12 +9900
Subject: [PATCH 18/47] xfs: scrub the metadir path of rt rmap btree files
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015553.1815505.5227863645429649399.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
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

Add a new XFS_SCRUB_METAPATH subtype so that we can scrub the metadata
directory tree path to the rmap btree file for each rt group.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/scrub.c |    5 +++++
 libxfs/xfs_fs.h |    3 ++-
 scrub/scrub.c   |    3 +++
 3 files changed, 10 insertions(+), 1 deletion(-)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index b22770d639c..8822fc0088c 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -197,6 +197,11 @@ const struct xfrog_scrub_descr xfrog_metapaths[XFS_SCRUB_METAPATH_NR] = {
 		.descr	= "project quota metadir path",
 		.group	= XFROG_SCRUB_GROUP_FS,
 	},
+	[XFS_SCRUB_METAPATH_RTRMAPBT]	= {
+		.name	= "rtrmapbt",
+		.descr	= "rmap btree file metadir path",
+		.group	= XFROG_SCRUB_GROUP_RTGROUP,
+	},
 };
 
 /* Invoke the scrub ioctl.  Returns zero or negative error code. */
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index dcf048aae8c..0bbdbfb0a8a 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -804,9 +804,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_METAPATH_USRQUOTA	2
 #define XFS_SCRUB_METAPATH_GRPQUOTA	3
 #define XFS_SCRUB_METAPATH_PRJQUOTA	4
+#define XFS_SCRUB_METAPATH_RTRMAPBT	5
 
 /* Number of metapath sm_ino values */
-#define XFS_SCRUB_METAPATH_NR		5
+#define XFS_SCRUB_METAPATH_NR		6
 
 /*
  * ioctl limits
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 8f9fde80263..f20910de855 100644
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
 

