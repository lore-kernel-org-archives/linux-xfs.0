Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7054AC2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NTE6ap48"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD05C433C8;
	Sun, 31 Dec 2023 23:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066783;
	bh=mzgJAMg1q76C6SKtcQWTwQPhAyc6A3G1zvpq100WskU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NTE6ap48Bsz4MhR3cet8Na1Kd9QLMu8fIV/f37WuY5qKH9rXmBUa6Wk245FIBxDVi
	 3BSGSIz4y+iPVhyZhXv4ZyWx+ZsNTQIF9m+QfBytdmrofxtDiihterDmqBxjm8BfrE
	 QeEGfa6bIhpeC0GwovYbj+dLqBSPQ2T4jinBT7ZfXHzZdEVl7+x92dxl49Tw83uc0Z
	 tTpKZ8+jn2cl+Nw7ficqKye9voTbh8rHJUgbfb1vt4lqiCVtdsiG0gyqWQK9HiRQSu
	 TIFXXsZ7JmvaNT9jpS6VAdsYU+43DOOXHFIUOfWnmmaGYzgBHhYEN0KQdnubgleXbg
	 Bay+ouorih7LA==
Date: Sun, 31 Dec 2023 15:53:02 -0800
Subject: [PATCH 21/52] xfs: scrub each rtgroup's portion of the rtbitmap
 separately
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012448.1811243.10931811105410968134.stgit@frogsfrogsfrogs>
In-Reply-To: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
References: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
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

Create a new scrub type code so that userspace can scrub each rtgroup's
portion of the rtbitmap file separately.  This reduces the long tail
latency that results from scanning the entire bitmap all at once, and
prepares us for future patchsets, wherein we'll need to be able to lock
a specific rtgroup so that we can rebuild that rtgroup's part of the
rtbitmap contents from the rtgroup's rmap btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/scrub.c                     |    5 +++++
 libxfs/xfs_fs.h                     |    3 ++-
 man/man2/ioctl_xfs_scrub_metadata.2 |   12 ++++++++++++
 3 files changed, 19 insertions(+), 1 deletion(-)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index a9aad03de0d..b22770d639c 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -164,6 +164,11 @@ const struct xfrog_scrub_descr xfrog_scrubbers[XFS_SCRUB_TYPE_NR] = {
 		.descr	= "realtime group superblock",
 		.group	= XFROG_SCRUB_GROUP_RTGROUP,
 	},
+	[XFS_SCRUB_TYPE_RGBITMAP] = {
+		.name	= "rgbitmap",
+		.descr	= "realtime group bitmap",
+		.group	= XFROG_SCRUB_GROUP_RTGROUP,
+	},
 };
 
 const struct xfrog_scrub_descr xfrog_metapaths[XFS_SCRUB_METAPATH_NR] = {
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 237d13a500d..102b9273360 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -736,9 +736,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_DIRTREE	28	/* directory tree structure */
 #define XFS_SCRUB_TYPE_METAPATH	29	/* metadata directory tree paths */
 #define XFS_SCRUB_TYPE_RGSUPER	30	/* realtime superblock */
+#define XFS_SCRUB_TYPE_RGBITMAP	31	/* realtime group bitmap */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	31
+#define XFS_SCRUB_TYPE_NR	32
 
 /*
  * This special type code only applies to the vectored scrub implementation.
diff --git a/man/man2/ioctl_xfs_scrub_metadata.2 b/man/man2/ioctl_xfs_scrub_metadata.2
index 13f655e2b97..dc439897c98 100644
--- a/man/man2/ioctl_xfs_scrub_metadata.2
+++ b/man/man2/ioctl_xfs_scrub_metadata.2
@@ -97,6 +97,18 @@ The realtime allocation group number must be given in
 .IR sm_ino " and " sm_gen
 must be zero.
 
+.PP
+.TP
+.B XFS_SCRUB_TYPE_RGBITMAP
+Examine a given realtime allocation group's free space bitmap.
+Records are checked for obviously incorrect values and cross-referenced
+with other allocation group metadata records to ensure that there are no
+conflicts.
+The realtime allocation group number must be given in
+.IR sm_agno "."
+.IR sm_ino " and " sm_gen
+must be zero.
+
 .TP
 .B XFS_SCRUB_TYPE_INODE
 Examine a given inode record for obviously incorrect values and

