Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F378DC77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:29:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233106AbjEZC3l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233245AbjEZC3k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:29:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1182B2
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:29:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F9D264C57
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:29:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1245C433EF;
        Fri, 26 May 2023 02:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685068178;
        bh=ciNgXCbN6/kwXMTeqf5dIYjgDEaeKjVngaH898wmNAE=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=NnhVcxlkFNR8IGjvLAl+v/nPU4lBLVazJW9sYz8t2KV7FIPPhpQgl/tX48kC/QuN/
         0+tr9tPfXg5atC+hCKH0gJI6/WI1pl64CV3ebfONZ3UhXV+mXc9hjwhfs2Ru3etp+L
         blQrqEQ0EAzvQzy4vrkumQJqyyIN1QxwHubaBicExwkPM8efF9F1PthUdit/0tFoSi
         xeiSfJrubwnQQq0ZPPhE5t5Ik1P9KNZ46jT7ZYCpGeIZkIiwieJWW9u7/vUObtJAfk
         yKKSQwTvGnK+OjWXIp/44R4qbJnsoCwW1GV6pM/urDzzFgrzeQ9/Q3A1CqZKmkUCnq
         UpXLmP7rgW/XQ==
Date:   Thu, 25 May 2023 19:29:38 -0700
Subject: [PATCH 30/30] mkfs: enable formatting with parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506078296.3749421.10263563788583854501.stgit@frogsfrogsfrogs>
In-Reply-To: <168506077876.3749421.7883085669588003826.stgit@frogsfrogsfrogs>
References: <168506077876.3749421.7883085669588003826.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Enable parent pointer support in mkfs via the '-n parent' parameter.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |   29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 89b1f2c27a6..0f61699bf35 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -113,6 +113,7 @@ enum {
 	N_SIZE = 0,
 	N_VERSION,
 	N_FTYPE,
+	N_PARENT,
 	N_MAX_OPTS,
 };
 
@@ -648,6 +649,7 @@ static struct opt_params nopts = {
 		[N_SIZE] = "size",
 		[N_VERSION] = "version",
 		[N_FTYPE] = "ftype",
+		[N_PARENT] = "parent",
 		[N_MAX_OPTS] = NULL,
 	},
 	.subopt_params = {
@@ -671,6 +673,14 @@ static struct opt_params nopts = {
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
 
@@ -1030,7 +1040,7 @@ usage( void )
 			    sunit=value|su=num,sectsize=num,lazy-count=0|1,\n\
 			    concurrency=num]\n\
 /* label */		[-L label (maximum 12 characters)]\n\
-/* naming */		[-n size=num,version=2|ci,ftype=0|1]\n\
+/* naming */		[-n size=num,version=2|ci,ftype=0|1,parent=0|1]]\n\
 /* no-op info only */	[-N]\n\
 /* prototype file */	[-p fname]\n\
 /* quiet */		[-q]\n\
@@ -1871,6 +1881,9 @@ naming_opts_parser(
 	case N_FTYPE:
 		cli->sb_feat.dirftype = getnum(value, opts, subopt);
 		break;
+	case N_PARENT:
+		cli->sb_feat.parent_pointers = getnum(value, &nopts, N_PARENT);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2394,6 +2407,14 @@ _("inode btree counters not supported without finobt support\n"));
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
@@ -3487,8 +3508,6 @@ sb_set_features(
 		sbp->sb_features2 |= XFS_SB_VERSION2_LAZYSBCOUNTBIT;
 	if (fp->projid32bit)
 		sbp->sb_features2 |= XFS_SB_VERSION2_PROJID32BIT;
-	if (fp->parent_pointers)
-		sbp->sb_features2 |= XFS_SB_VERSION2_PARENTBIT;
 	if (fp->crcs_enabled)
 		sbp->sb_features2 |= XFS_SB_VERSION2_CRCBIT;
 	if (fp->attr_version == 2)
@@ -3529,6 +3548,10 @@ sb_set_features(
 		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_INOBTCNT;
 	if (fp->bigtime)
 		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_BIGTIME;
+	if (fp->parent_pointers) {
+		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_PARENT;
+		sbp->sb_versionnum |= XFS_SB_VERSION_ATTRBIT;
+	}
 
 	/*
 	 * Sparse inode chunk support has two main inode alignment requirements.

