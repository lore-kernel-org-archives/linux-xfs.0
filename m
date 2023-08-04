Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FFFEC04A6A
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Aug 2023 17:11:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbjHDRLT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Aug 2023 13:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232259AbjHDRLA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Aug 2023 13:11:00 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1557A198B
        for <linux-xfs@vger.kernel.org>; Fri,  4 Aug 2023 10:10:50 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-112-100.bstnma.fios.verizon.net [173.48.112.100])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 374HAWbb018484
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 4 Aug 2023 13:10:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1691169034; bh=oi/YQdJtCDS/0hEIfpYRZpQ2Zp44SZ7fmLeWR86RvKU=;
        h=From:Subject:Date:Message-Id:MIME-Version;
        b=VnA6QvRFdf2Q6plISM0Tr1QljyX2LMjt8DnqDJjhI/ps+DaR/0gQ8n/e6lAREW4mu
         i3drYLaLOz5PRBQQsPSjB3V0LQIAnGtPAg42PTq4SC2n8YJe07uMkgGFps9Hc/udLk
         9INSFh3QvphfrYoSixHKON+c9IzGua5Yc3Z3Nfv8KHfrm2MmXXUtbFSGTY1etS8Mtd
         ar+z8/Jl5NXlRkY7cjLGQNhChtwxnyOr4DEpTuc5bUEouNRzMC752Dbsmu0uib+xW6
         AtwxZ8Dl6hJ4/+cjHZDWwYLmmnpmLVaxlWMQEqWECCQnLGllTQUfNGK06iIRbFszx1
         HqtQpeqjpPxSA==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 0A7BA15C04F6; Fri,  4 Aug 2023 13:10:30 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, djwong@kernel.org, chandan.babu@oracle.com,
        leah.rumancik@gmail.com, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH CANDIDATE v5.15 6/9] xfs: use the directory name hash function for dir scrubbing
Date:   Fri,  4 Aug 2023 13:10:16 -0400
Message-Id: <20230804171019.1392900-6-tytso@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20230804171019.1392900-1-tytso@mit.edu>
References: <20230802205747.GE358316@mit.edu>
 <20230804171019.1392900-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit 9dceccc5822f2ecea12a89f24d7cad1f3e5eab7c upstream.

The directory code has a directory-specific hash computation function
that includes a modified hash function for case-insensitive lookups.
Hence we must use that function (and not the raw da_hashname) when
checking the dabtree structure.

Found by accidentally breaking xfs/188 to create an abnormally huge
case-insensitive directory and watching scrub break.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/scrub/dir.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 200a63f58fe7..829dadd400b0 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -201,6 +201,7 @@ xchk_dir_rec(
 	struct xchk_da_btree		*ds,
 	int				level)
 {
+	struct xfs_name			dname = { };
 	struct xfs_da_state_blk		*blk = &ds->state->path.blk[level];
 	struct xfs_mount		*mp = ds->state->mp;
 	struct xfs_inode		*dp = ds->dargs.dp;
@@ -297,7 +298,11 @@ xchk_dir_rec(
 		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
 		goto out_relse;
 	}
-	calc_hash = xfs_da_hashname(dent->name, dent->namelen);
+
+	/* Does the directory hash match? */
+	dname.name = dent->name;
+	dname.len = dent->namelen;
+	calc_hash = xfs_dir2_hashname(mp, &dname);
 	if (calc_hash != hash)
 		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
 
-- 
2.31.0

