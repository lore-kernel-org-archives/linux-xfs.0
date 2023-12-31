Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257A1C2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rEnCSjBO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94242C433C7;
	Sun, 31 Dec 2023 23:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067142;
	bh=02GBLLvxLye5fdM6Ogk3SxhPv9oIBiNrBLWrwyERkRY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rEnCSjBOBxu/BsdJQuL25OdTbUkLxUQFSIkJyaksptJUYHM5BOdMwy27eQAby7ygw
	 UerX7FXmc08+8RKuZQieGTQ+JrPytwAhY58ruq5ofDxIZjiyvt5hJHwJyYIB6VRZnR
	 +DN+HLzkRbi3g91Icm3BoshTXUN3iUq53JagSZAaeqRv+voWyG9vyRSVjTFlAg+BNX
	 QDgABlld3ORWzFsx/Ep3wN4YUNWkmfSUyASKf6y5MTDWUXoewSI2J3GjMMzZRx+9yv
	 kSM1ULZfwohbtt/Owk36sJaITSDD3aXGGR+v3+C+r1dDQ1ViQA6tWngdYdLMkCRHIM
	 KDc5jigmzlHBA==
Date: Sun, 31 Dec 2023 15:59:02 -0800
Subject: [PATCH 44/52] xfs_io: display rt group in verbose fsmap output
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012752.1811243.12050652314521602400.stgit@frogsfrogsfrogs>
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

Display the rt group number in the fsmap output, just like we do for
regular data files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/fsmap.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)


diff --git a/io/fsmap.c b/io/fsmap.c
index 7db51847e2b..cb70f86cb96 100644
--- a/io/fsmap.c
+++ b/io/fsmap.c
@@ -14,6 +14,7 @@
 
 static cmdinfo_t	fsmap_cmd;
 static dev_t		xfs_data_dev;
+static dev_t		xfs_rt_dev;
 
 static void
 fsmap_help(void)
@@ -170,7 +171,7 @@ dump_map_verbose(
 	unsigned long long	i;
 	struct fsmap		*p;
 	int			agno;
-	off64_t			agoff, bperag;
+	off64_t			agoff, bperag, bperrtg;
 	int			foff_w, boff_w, aoff_w, tot_w, agno_w, own_w;
 	int			nr_w, dev_w;
 	char			rbuf[40], bbuf[40], abuf[40], obuf[40];
@@ -185,6 +186,8 @@ dump_map_verbose(
 	tot_w = MINTOT_WIDTH;
 	bperag = (off64_t)fsgeo->agblocks *
 		  (off64_t)fsgeo->blocksize;
+	bperrtg = (off64_t)fsgeo->rgblocks *
+		  (off64_t)fsgeo->blocksize;
 	sunit = (fsgeo->sunit * fsgeo->blocksize);
 	swidth = (fsgeo->swidth * fsgeo->blocksize);
 
@@ -243,6 +246,13 @@ dump_map_verbose(
 				"(%lld..%lld)",
 				(long long)BTOBBT(agoff),
 				(long long)BTOBBT(agoff + p->fmr_length - 1));
+		} else if (p->fmr_device == xfs_rt_dev && fsgeo->rgcount > 0) {
+			agno = p->fmr_physical / bperrtg;
+			agoff = p->fmr_physical - (agno * bperrtg);
+			snprintf(abuf, sizeof(abuf),
+				"(%lld..%lld)",
+				(long long)BTOBBT(agoff),
+				(long long)BTOBBT(agoff + p->fmr_length - 1));
 		} else
 			abuf[0] = 0;
 		aoff_w = max(aoff_w, strlen(abuf));
@@ -315,6 +325,16 @@ dump_map_verbose(
 			snprintf(gbuf, sizeof(gbuf),
 				"%lld",
 				(long long)agno);
+		} else if (p->fmr_device == xfs_rt_dev && fsgeo->rgcount > 0) {
+			agno = p->fmr_physical / bperrtg;
+			agoff = p->fmr_physical - (agno * bperrtg);
+			snprintf(abuf, sizeof(abuf),
+				"(%lld..%lld)",
+				(long long)BTOBBT(agoff),
+				(long long)BTOBBT(agoff + p->fmr_length - 1));
+			snprintf(gbuf, sizeof(gbuf),
+				"%lld",
+				(long long)agno);
 		} else {
 			abuf[0] = 0;
 			gbuf[0] = 0;
@@ -501,6 +521,7 @@ fsmap_f(
 	}
 	fs = fs_table_lookup(file->name, FS_MOUNT_POINT);
 	xfs_data_dev = fs ? fs->fs_datadev : 0;
+	xfs_rt_dev = fs ? fs->fs_rtdev : 0;
 
 	head->fmh_count = map_size;
 	do {

