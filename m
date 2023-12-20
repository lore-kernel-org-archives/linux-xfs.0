Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0258847789
	for <linux-xfs@vger.kernel.org>; Wed, 20 Dec 2023 17:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q5rTouIF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933C4C433C8;
	Wed, 20 Dec 2023 17:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703092520;
	bh=4ZnHxdmIN4pNizR4EjfnFMU2oEkYnIPvXX17Ls+58Uo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Q5rTouIFK5hNRdR+NvpE2fsFwuNl/hvApfP0IBrg/Hv+6HE+zMC5dahYrJQYuk6BN
	 ZF//Q7Jo91TJoLoUWVGOXeNnWjEhdRmCm/Em3qwPTMpZonR1zqDTtteOa60NThXD7e
	 nXxY8tWIe5ZjmBPpCejlVuPYoqFIzPjzcMJcIOzTLJaiHgAIHyvuJLhUnX4VglSyr1
	 jFM7V2YB8RtYj6I2v5gvJntvZoY4bkJDJNqK2t/ps58m6YveG7JvFiPYSDWYEZdzr6
	 HDcvdsNYT0n+9jO1lFrvDCee3u81NMJANTdnlpzTMKZqKXdR3Ts96a5mIKdWhRhyRw
	 ewRBCebrLlSxg==
Date: Wed, 20 Dec 2023 09:15:20 -0800
Subject: [PATCH 4/4] xfs_io: support passing the FORCE_REBUILD flag to online
 repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Carlos Maiolino <cmaiolino@redhat.com>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
Message-ID: <170309219133.1608142.1654531129225506927.stgit@frogsfrogsfrogs>
In-Reply-To: <170309219080.1608142.737701463093437769.stgit@frogsfrogsfrogs>
References: <170309219080.1608142.737701463093437769.stgit@frogsfrogsfrogs>
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

Add CLI options to the scrubv and repair commands so that the user can
pass FORCE_REBUILD to force the kernel to rebuild metadata.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 io/scrub.c        |   11 +++++++++--
 man/man8/xfs_io.8 |    3 +++
 2 files changed, 12 insertions(+), 2 deletions(-)


diff --git a/io/scrub.c b/io/scrub.c
index cde788fb..403b3a72 100644
--- a/io/scrub.c
+++ b/io/scrub.c
@@ -131,11 +131,15 @@ parse_args(
 {
 	int				type = -1;
 	int				i, c;
+	uint32_t			flags = 0;
 	const struct xfrog_scrub_descr	*d = NULL;
 
 	memset(meta, 0, sizeof(struct xfs_scrub_metadata));
-	while ((c = getopt(argc, argv, "")) != EOF) {
+	while ((c = getopt(argc, argv, "R")) != EOF) {
 		switch (c) {
+		case 'R':
+			flags |= XFS_SCRUB_IFLAG_FORCE_REBUILD;
+			break;
 		default:
 			exitcode = 1;
 			return command_usage(cmdinfo);
@@ -160,6 +164,7 @@ parse_args(
 	optind++;
 
 	meta->sm_type = type;
+	meta->sm_flags = flags;
 
 	switch (d->type) {
 	case XFROG_SCRUB_TYPE_INODE:
@@ -248,11 +253,13 @@ repair_help(void)
 " or (optionally) take an inode number and generation number to act upon as\n"
 " the second and third parameters.\n"
 "\n"
+" Flags are -R to force rebuilding metadata.\n"
+"\n"
 " Example:\n"
 " 'repair inobt 3' - repairs the inode btree in AG 3.\n"
 " 'repair bmapbtd 128 13525' - repairs the extent map of inode 128 gen 13525.\n"
 "\n"
-" Known metadata repairs types are:"));
+" Known metadata repair types are:"));
 	for (i = 0, d = xfrog_scrubbers; i < XFS_SCRUB_TYPE_NR; i++, d++)
 		printf(" %s", d->name);
 	printf("\n");
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index ef7087b3..d46dc369 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1340,6 +1340,9 @@ parameter specifies which type of metadata to repair.
 For AG metadata, one AG number must be specified.
 For file metadata, the repair is applied to the open file unless the
 inode number and generation number are specified.
+The
+.B -R
+option can be specified to force rebuilding of a metadata structure.
 .TP
 .BI "label" " " "[ -c | -s " label " ] "
 On filesystems that support online label manipulation, get, set, or clear the

