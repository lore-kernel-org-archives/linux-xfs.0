Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35168 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750930AbdLHEP7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Dec 2017 23:15:59 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 10D45614304
        for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2017 22:15:57 -0600 (CST)
Subject: [PATCH 3/5] mkfs: invert project id width boolean name
References: <ba4823ed-fabd-d02c-42f3-40c8d5aa44a6@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c22e3212-3e1c-ed6d-e1cc-4f0396265c52@sandeen.net>
Date: Thu, 7 Dec 2017 22:15:58 -0600
MIME-Version: 1.0
In-Reply-To: <ba4823ed-fabd-d02c-42f3-40c8d5aa44a6@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

It's a bit nuts that we have a projid32bit mkfs option, but
we carry around the inverse of its value in "projid16bit" - 
just flip it around for sanity.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 mkfs/xfs_mkfs.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index d30f73d..f6e2fad 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -763,7 +763,7 @@ struct sb_feat_args {
 	bool	inode_align;
 	bool	nci;
 	bool	lazy_sb_counters;
-	bool	projid16bit;
+	bool	projid32bit;
 	bool	crcs_enabled;
 	bool	dirftype;
 	bool	finobt;
@@ -1551,7 +1551,7 @@ inode_opts_parser(
 		cli->sb_feat.attr_version = getnum(value, &iopts, I_ATTR);
 		break;
 	case I_PROJID32BIT:
-		cli->sb_feat.projid16bit = !getnum(value, &iopts, I_PROJID32BIT);
+		cli->sb_feat.projid32bit = getnum(value, &iopts, I_PROJID32BIT);
 		break;
 	case I_SPINODES:
 		cli->sb_feat.spinodes = getnum(value, &iopts, I_SPINODES);
@@ -2037,7 +2037,7 @@ _("V2 attribute format always enabled on CRC enabled filesytems\n"));
 
 		/* 32 bit project quota always on */
 		/* attr2 always on */
-		if (cli->sb_feat.projid16bit) {
+		if (!cli->sb_feat.projid32bit) {
 			fprintf(stderr,
 _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
 			usage();
@@ -2905,7 +2905,7 @@ sb_set_features(
 	sbp->sb_features2 = 0;
 	if (fp->lazy_sb_counters)
 		sbp->sb_features2 |= XFS_SB_VERSION2_LAZYSBCOUNTBIT;
-	if (!fp->projid16bit)
+	if (fp->projid32bit)
 		sbp->sb_features2 |= XFS_SB_VERSION2_PROJID32BIT;
 	if (fp->parent_pointers)
 		sbp->sb_features2 |= XFS_SB_VERSION2_PARENTBIT;
@@ -3219,7 +3219,7 @@ print_mkfs_cfg(
 "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
 		dfile, cfg->inodesize, (long long)cfg->agcount,
 			(long long)cfg->agsize,
-		"", cfg->sectorsize, fp->attr_version, !fp->projid16bit,
+		"", cfg->sectorsize, fp->attr_version, fp->projid32bit,
 		"", fp->crcs_enabled, fp->finobt, fp->spinodes, fp->rmapbt,
 			fp->reflink,
 		"", cfg->blocksize, (long long)cfg->dblocks, cfg->imaxpct,
@@ -3854,7 +3854,7 @@ main(
 			.inode_align = XFS_IFLAG_ALIGN,
 			.nci = false,
 			.lazy_sb_counters = true,
-			.projid16bit = false,
+			.projid32bit = true,
 			.crcs_enabled = true,
 			.dirftype = true,
 			.finobt = true,
-- 
1.8.3.1


