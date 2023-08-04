Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EF2EC04A6A
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Aug 2023 17:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbjHDRMj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Aug 2023 13:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231577AbjHDRMi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Aug 2023 13:12:38 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7891469A
        for <linux-xfs@vger.kernel.org>; Fri,  4 Aug 2023 10:12:37 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-112-100.bstnma.fios.verizon.net [173.48.112.100])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 374HCRLk019436
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 4 Aug 2023 13:12:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1691169149; bh=3Dx6489r2fYooCL2ajoJdVPcDSLe97j6v4niddJEHb0=;
        h=From:Subject:Date:Message-Id:MIME-Version;
        b=Ur73FNUqnoOKKUrMYm+slr41f1CsE3h/XVUr6ClCrCFuDuQPC+o1cQ6gZNnZfpm55
         8GaogRAIOYlw956Lf8Zvv0z02q5/Bh3D5S8lBQaLI15d8gOv1M5KMSljcbw/Fqwkja
         tYkde0nFHGaLalnmZZGa2ol4nmIysgNqEH5vryXV4ww+LlAHq+w6O9SJDa2VFyk1Hj
         ZOvsscSA3oJbFvKBDZC57TB4XXFpyYX57NBeojoE6ovndtr0mTnWGMSGDZe9ifx3u6
         P7W0vCnTDFC2wWRVRwOo1WceCjoP4kJyjXnruUe6QVBsXKxsWHokdYCiNYzlVS+CTu
         UjXLtSGgt4dKw==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 011B715C04F4; Fri,  4 Aug 2023 13:12:26 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, djwong@kernel.org, chandan.babu@oracle.com,
        leah.rumancik@gmail.com, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH CANDIDATE v6.1 4/5] xfs: use the directory name hash function for dir scrubbing
Date:   Fri,  4 Aug 2023 13:12:22 -0400
Message-Id: <20230804171223.1393045-4-tytso@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20230804171223.1393045-1-tytso@mit.edu>
References: <20230804171223.1393045-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

The directory code has a directory-specific hash computation function
that includes a modified hash function for case-insensitive lookups.
Hence we must use that function (and not the raw da_hashname) when
checking the dabtree structure.

Found by accidentally breaking xfs/188 to create an abnormally huge
case-insensitive directory and watching scrub break.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
(cherry picked from commit 9dceccc5822f2ecea12a89f24d7cad1f3e5eab7c)
---
 fs/xfs/scrub/dir.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 5c87800ab223..ee29084ec44e 100644
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

