Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2296D2FB
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610421; cv=none; b=tDIBSBsUAyFaceIA815B1tNsFzg9Zp5bRcZu77ThJWZ+07Ss+QCOrjlDMRRKJ9sDECOjYuZSfajvx3a4QvO0g0dLaOoTBVNFuYzDMpZ9Xfe/CP6zK5xnuATxYWtovXY3LbdG+jLz1lwypd6iO9JPVjtE3oVzbZv8xQcTq5ljVpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610421; c=relaxed/simple;
	bh=CM3YMnoMbIRQPhJuoK651eoxPm9LqsaHPoKdACpqzh4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B6aRHg/gk5zf9AdinYyG1b3pOapTK3X9jh4vlgQssbZnN90h3+gR/IClssd7rfbKQdpRaO9vleEiB7cR0SmhblJuFmMXNWjx0SG+jcSTMQKjM5OEWxDBew3pXiUbajv+LzafBJ410TC1Hzb1BoYEENgOk1AS1/bG9cKX7Dobwpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ACXL10zU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ACXL10zU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80997C4CEC5;
	Fri, 11 Oct 2024 01:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610421;
	bh=CM3YMnoMbIRQPhJuoK651eoxPm9LqsaHPoKdACpqzh4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ACXL10zUu5dsaeN4WdW1aMhTDPdq36dwgNP+4Wb6GAR+52OYCLSGRurLBt9Ermywx
	 jwJAtrarv9lkTfsmvc8/cXJXOjOazpsAGyFydQ+fSvXaBCXHoN5bpFff9g6BpD83Wt
	 Q4uWlgaP6HDS1pCqrPJqKODHknVmqwBHRBxGTvOsCY38nqjLSC3+U9+H9fgytlyiC4
	 hC4o5eX7AGDGJcCQUnFGPRVK0qkvvU/K924OsUYoDgloA5QbpEjxY11v+osde2aZy1
	 suIAE9ZAiQPb3Ihjs4s8Q50EuAcCS3si5hzhr5uorojVPQAYWm4q3+J7MjX6Ch6u5o
	 5NqpWR4I58vOQ==
Date: Thu, 10 Oct 2024 18:33:41 -0700
Subject: [PATCH 35/43] xfs_io: display rt group in verbose fsmap output
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860655903.4184637.9450310661916679042.stgit@frogsfrogsfrogs>
In-Reply-To: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
References: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
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
 io/fsmap.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)


diff --git a/io/fsmap.c b/io/fsmap.c
index bf1196390cf35d..545f619f5e1dc1 100644
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
-	off_t			agoff, bperag;
+	off_t			agoff, bperag, bperrtg;
 	int			foff_w, boff_w, aoff_w, tot_w, agno_w, own_w;
 	int			nr_w, dev_w;
 	char			rbuf[40], bbuf[40], abuf[40], obuf[40];
@@ -185,6 +186,7 @@ dump_map_verbose(
 	tot_w = MINTOT_WIDTH;
 	bperag = (off_t)fsgeo->agblocks *
 		  (off_t)fsgeo->blocksize;
+	bperrtg = bytes_per_rtgroup(fsgeo);
 	sunit = (fsgeo->sunit * fsgeo->blocksize);
 	swidth = (fsgeo->swidth * fsgeo->blocksize);
 
@@ -243,6 +245,13 @@ dump_map_verbose(
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
@@ -315,6 +324,16 @@ dump_map_verbose(
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
@@ -501,6 +520,7 @@ fsmap_f(
 	}
 	fs = fs_table_lookup(file->name, FS_MOUNT_POINT);
 	xfs_data_dev = fs ? fs->fs_datadev : 0;
+	xfs_rt_dev = fs ? fs->fs_rtdev : 0;
 
 	head->fmh_count = map_size;
 	do {

