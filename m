Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B46CC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:40:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236168AbiLaCkM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:40:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236164AbiLaCkL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:40:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B11B02DED
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:40:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BF8B61CCF
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D47C433D2;
        Sat, 31 Dec 2022 02:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454409;
        bh=02GBLLvxLye5fdM6Ogk3SxhPv9oIBiNrBLWrwyERkRY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Qmbiz4MZE9tjKaqV7hZc9UbuHr/AfMIjDc8CdVjAV16Ew+pJY4j3aQ/MYja6u/RMk
         7PgD5GiM2a+ESaZ9/rffeOc48DmzzNK+3bw9JXs9eUr4bBc0asSEtMo57UDNHLS9ns
         xf/28iou07QnzlumctDewjBDWj9Sv3TsWVLE2BdXAw76GrSpsCSnJOB8C7poceovnR
         cuytYoXEY621T49kgkPPjj0VIHcMtSFfT3WoLLmlD35HR5hrZ97TeHRceixYA3op2D
         VTxMdUU6IlAh+TAaBK0E1nyUUUyPF+Y0PD0JTEqAkOZkJgmX2sFi1f68ID7y6d/bcb
         k7FBUV2KbX5XQ==
Subject: [PATCH 39/45] xfs_io: display rt group in verbose fsmap output
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:48 -0800
Message-ID: <167243878873.731133.4190432176522703778.stgit@magnolia>
In-Reply-To: <167243878346.731133.14642166452774753637.stgit@magnolia>
References: <167243878346.731133.14642166452774753637.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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

