Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880A9139E
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530555; cv=none; b=c2SkE3/P7kjlPLZ3SeIhF9y0KmUbRRhfwW52uZHtmCSVSn9ZpK/xEU/m2Dv3gkRqNRxQNivXzrDZvjCsU/Wkev2VIG59osEFR2NN4wWQ1HEe+3hAESjjg8EHYzYKChgRF8nCvUhb4mcL2+8rJLFdEtiMcJUShb1sFEmjm6GY6F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530555; c=relaxed/simple;
	bh=4tZA5FKyFxTQOcRRrILNuEM+UdscBxJh0rXN/1xZ3/4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CVeofVagiaSARE52OXYMoxojtyzpbBDhONJoQT8vxg2f6Fw9FUeUmkIg2sQkyx5q7wt7+8Q8RoZZG5bt2lPZVgox1WaJrl0HG0luxbbRMR3wT0l1U2NvHGyMbArI556SyBL5+5LX4Zx85F20UdjE44pA3rO3692FCM5riLJ+qbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c506VS7A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c506VS7A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB91C4CED1;
	Sat,  7 Dec 2024 00:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530555;
	bh=4tZA5FKyFxTQOcRRrILNuEM+UdscBxJh0rXN/1xZ3/4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=c506VS7AHB59BPJhmgB2Uh6jBdwwqopz0nv98NbkGxBqb1OjfqN2UOQjiJWvXVshB
	 95Om84yJxHgD+yGPySp0fAFSQ8uw/x5nguTZeLmxxRyQKeDJ6Z7cno/ocLJbhSIPMM
	 NG/FBIY85eMFVtkpQtR5jmG16yPvDOFgUkHLvy1+l/2byM9Se1EDJpnNZTIkfKn75G
	 HZrd4vAtGt5nDB6FX7zj3vyPZckaTZkR4DT4tnAArhI234/e9836oar5lischSwKfb
	 oXxaaur/GV2iRH8d1jp+s70wtGpEU32MUt9rS2Gkh+ejj6MpYnirva477hYF5aDDpK
	 DiYzEjgxw1dyA==
Date: Fri, 06 Dec 2024 16:15:54 -0800
Subject: [PATCH 42/50] xfs_io: display rt group in verbose fsmap output
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352752587.126362.15499339908546372305.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
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

