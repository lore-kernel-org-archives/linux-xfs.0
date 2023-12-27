Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265231368
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OIdQA9EX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B867C433C8;
	Mon,  1 Jan 2024 00:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069113;
	bh=934PcW4dwNt1BPr54/rQK6Qc+4TDeNhIiLn1HeTLjTM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OIdQA9EXHQgC+hzKCnBscvH9MfwgGVemRrKsT6T4tCVBWcsKbcnv6kriHFxqy60AD
	 kCRkGKiTFqdkR/DPRXaFLCk2irA9gSPCWMNsfmEnL5PQ6TK8mQ22yV67QWa63PiFv5
	 QDFrG5e2YDZfmZPf8QcOhpxDPZ6t/hkHyFr89ZS2I+YNx30crVJDfSFpaI1KjAru66
	 a3nDFQ/B3splhhTYSg3vl4sbwlH36spjBly5cGq0XlVAAk2O+CwofTPY2Devk3042/
	 jGM+M9/avOdFVkiTvHvKXMFKy/T2kQDZFnNNfHMwwoYCeiUgFfN65lCdDWM8AEUS6e
	 qaN75HoW/d8Aw==
Date: Sun, 31 Dec 2023 16:31:53 +9900
Subject: [PATCH 22/42] xfs: scrub the metadir path of rt refcount btree files
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017419.1817107.10086590945379462719.stgit@frogsfrogsfrogs>
In-Reply-To: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
References: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
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
directory tree path to the refcount btree file for each rt group.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/scrub.c |    5 +++++
 libxfs/xfs_fs.h |    3 ++-
 2 files changed, 7 insertions(+), 1 deletion(-)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index 290ba0fb8bf..97b3d533910 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -207,6 +207,11 @@ const struct xfrog_scrub_descr xfrog_metapaths[XFS_SCRUB_METAPATH_NR] = {
 		.descr	= "rmap btree file metadir path",
 		.group	= XFROG_SCRUB_GROUP_RTGROUP,
 	},
+	[XFS_SCRUB_METAPATH_RTREFCBT]	= {
+		.name	= "rtrefcbt",
+		.descr	= "refcount btree file metadir path",
+		.group	= XFROG_SCRUB_GROUP_RTGROUP,
+	},
 };
 
 /* Invoke the scrub ioctl.  Returns zero or negative error code. */
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 7847da61db2..4159e96d01a 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -806,9 +806,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_METAPATH_GRPQUOTA	3
 #define XFS_SCRUB_METAPATH_PRJQUOTA	4
 #define XFS_SCRUB_METAPATH_RTRMAPBT	5
+#define XFS_SCRUB_METAPATH_RTREFCBT	6
 
 /* Number of metapath sm_ino values */
-#define XFS_SCRUB_METAPATH_NR		6
+#define XFS_SCRUB_METAPATH_NR		7
 
 /*
  * ioctl limits

