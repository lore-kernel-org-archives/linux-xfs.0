Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ED4DC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:58:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbjBPU6z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:58:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjBPU6y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:58:54 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86DC50AC3
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:58:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 43619CE2D89
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8831BC433EF;
        Thu, 16 Feb 2023 20:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581123;
        bh=mv8q5PFfnZZbISyBF+xSWQceC8/biyNP2lI1hdbjZac=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=EJCgzlW8gzrAGyv/qt3x4URmOstN45+8MBGdinbTkQVVlm4ErWCbctlzoKeNtMmEC
         QVmYU3NuOoS5TbvR68wuQ6W10tGIBNuqbpnBp70/JZwFVf2KUfdcipfylkoUwgV+fU
         hDg95ZLTMbF5rwUVcyokZKX0Oh2OenOA4kgWmL1OnP8mmCvYnFGByyRitXCqb/otzG
         OfRzINSJj3E5kKHsHiw+ch1srUeQmk4R5RWNPW/R5FHui5GBw6HhZ1cEukmCME6qBS
         7c0c0yPZHbbAh4uVTHxzKBKM1qmEFzQOJdaBVYx5TTPPcC8jVPBg0IB3W3wNs+L97q
         vsbkXxXeyS+/A==
Date:   Thu, 16 Feb 2023 12:58:43 -0800
Subject: [PATCH 20/25] xfsprogs: Add parent pointer flag to cmd
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657879174.3476112.13283595059308677022.stgit@magnolia>
In-Reply-To: <167657878885.3476112.11949206434283274332.stgit@magnolia>
References: <167657878885.3476112.11949206434283274332.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

mkfs: enable formatting with parent pointers. Enable parent pointer support in mkfs
via the '-n parent' parameter.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 mkfs/xfs_mkfs.c |   29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index d95394a5..dffee9e2 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -110,6 +110,7 @@ enum {
 	N_SIZE = 0,
 	N_VERSION,
 	N_FTYPE,
+	N_PARENT,
 	N_MAX_OPTS,
 };
 
@@ -615,6 +616,7 @@ static struct opt_params nopts = {
 		[N_SIZE] = "size",
 		[N_VERSION] = "version",
 		[N_FTYPE] = "ftype",
+		[N_PARENT] = "parent",
 		[N_MAX_OPTS] = NULL,
 	},
 	.subopt_params = {
@@ -638,6 +640,14 @@ static struct opt_params nopts = {
 		  .maxval = 1,
 		  .defaultval = 1,
 		},
+		{ .index = N_PARENT,
+		  .conflicts = { { NULL, LAST_CONFLICT } },
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
+		},
+
+
 	},
 };
 
@@ -970,7 +980,7 @@ usage( void )
 /* log subvol */	[-l agnum=n,internal,size=num,logdev=xxx,version=n\n\
 			    sunit=value|su=num,sectsize=num,lazy-count=0|1]\n\
 /* label */		[-L label (maximum 12 characters)]\n\
-/* naming */		[-n size=num,version=2|ci,ftype=0|1]\n\
+/* naming */		[-n size=num,version=2|ci,ftype=0|1,parent=0|1]]\n\
 /* no-op info only */	[-N]\n\
 /* prototype file */	[-p fname]\n\
 /* quiet */		[-q]\n\
@@ -1744,6 +1754,9 @@ naming_opts_parser(
 	case N_FTYPE:
 		cli->sb_feat.dirftype = getnum(value, opts, subopt);
 		break;
+	case N_PARENT:
+		cli->sb_feat.parent_pointers = getnum(value, &nopts, N_PARENT);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2225,6 +2238,14 @@ _("inode btree counters not supported without finobt support\n"));
 		cli->sb_feat.inobtcnt = false;
 	}
 
+	if ((cli->sb_feat.parent_pointers) &&
+	    cli->sb_feat.dir_version == 4) {
+		fprintf(stderr,
+_("parent pointers not supported on v4 filesystems\n"));
+		usage();
+		cli->sb_feat.parent_pointers = false;
+	}
+
 	if (cli->xi->rtname) {
 		if (cli->sb_feat.reflink && cli_opt_set(&mopts, M_REFLINK)) {
 			fprintf(stderr,
@@ -3224,8 +3245,6 @@ sb_set_features(
 		sbp->sb_features2 |= XFS_SB_VERSION2_LAZYSBCOUNTBIT;
 	if (fp->projid32bit)
 		sbp->sb_features2 |= XFS_SB_VERSION2_PROJID32BIT;
-	if (fp->parent_pointers)
-		sbp->sb_features2 |= XFS_SB_VERSION2_PARENTBIT;
 	if (fp->crcs_enabled)
 		sbp->sb_features2 |= XFS_SB_VERSION2_CRCBIT;
 	if (fp->attr_version == 2)
@@ -3266,6 +3285,10 @@ sb_set_features(
 		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_INOBTCNT;
 	if (fp->bigtime)
 		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_BIGTIME;
+	if (fp->parent_pointers) {
+		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_PARENT;
+		sbp->sb_versionnum |= XFS_SB_VERSION_ATTRBIT;
+	}
 
 	/*
 	 * Sparse inode chunk support has two main inode alignment requirements.

