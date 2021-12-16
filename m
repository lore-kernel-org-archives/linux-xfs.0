Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A74DC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Dec 2021 01:09:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhLPBJe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Dec 2021 20:09:34 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48136 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhLPBJe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Dec 2021 20:09:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8087AB82163
        for <linux-xfs@vger.kernel.org>; Thu, 16 Dec 2021 01:09:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F40C36AE0;
        Thu, 16 Dec 2021 01:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639616972;
        bh=t/ZeqlaOqA8O6RfXXKrJLh80mUsLKCGZui2WrECJAyc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HM43La5ugHzvy/cY9z0+d8vJ31ChoUdnRzeaNbWGSj++1ARuznuQLkS5uWRVKzsri
         pATwxApTQqnognU7fXBWUIQ+rSwAxI0CdriOyrrdXE/MxR88xjjdXpa3AOv37dNS2E
         QvN9N5FPurVGXL04XM0v/zcqVSRkOxlEFj492pECU8YRGCMONVO5sTifz95AW/weIH
         s3biggE9ScDRgRwpiYgh34ax4SKA5rLPTkX/fu14vmfC6GolJUEDXiPrj98VRsPMsY
         8mDh8dc9K9j6Kb+uV54eKIaeKXtjxRpsBc0R0piE4YqQulmGgoWl2X5IZCSPFYMsBS
         FDZN/ljuINfcg==
Subject: [PATCH 3/7] xfs: fix a bug in the online fsck directory leaf1
 bestcount check
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 15 Dec 2021 17:09:32 -0800
Message-ID: <163961697197.3129691.1911552605195534271.stgit@magnolia>
In-Reply-To: <163961695502.3129691.3496134437073533141.stgit@magnolia>
References: <163961695502.3129691.3496134437073533141.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When xfs_scrub encounters a directory with a leaf1 block, it tries to
validate that the leaf1 block's bestcount (aka the best free count of
each directory data block) is the correct size.  Previously, this author
believed that comparing bestcount to the directory isize (since
directory data blocks are under isize, and leaf/bestfree blocks are
above it) was sufficient.

Unfortunately during testing of online repair, it was discovered that it
is possible to create a directory with a hole between the last directory
block and isize.  The directory code seems to handle this situation just
fine and xfs_repair doesn't complain, which effectively makes this quirk
part of the disk format.

Fix the check to work properly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/dir.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 200a63f58fe7..9a16932d77ce 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -497,6 +497,7 @@ STATIC int
 xchk_directory_leaf1_bestfree(
 	struct xfs_scrub		*sc,
 	struct xfs_da_args		*args,
+	xfs_dir2_db_t			last_data_db,
 	xfs_dablk_t			lblk)
 {
 	struct xfs_dir3_icleaf_hdr	leafhdr;
@@ -534,10 +535,14 @@ xchk_directory_leaf1_bestfree(
 	}
 
 	/*
-	 * There should be as many bestfree slots as there are dir data
-	 * blocks that can fit under i_size.
+	 * There must be enough bestfree slots to cover all the directory data
+	 * blocks that we scanned.  It is possible for there to be a hole
+	 * between the last data block and i_disk_size.  This seems like an
+	 * oversight to the scrub author, but as we have been writing out
+	 * directories like this (and xfs_repair doesn't mind them) for years,
+	 * that's what we have to check.
 	 */
-	if (bestcount != xfs_dir2_byte_to_db(geo, sc->ip->i_disk_size)) {
+	if (bestcount != last_data_db + 1) {
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 		goto out;
 	}
@@ -669,6 +674,7 @@ xchk_directory_blocks(
 	xfs_fileoff_t		lblk;
 	struct xfs_iext_cursor	icur;
 	xfs_dablk_t		dabno;
+	xfs_dir2_db_t		last_data_db = 0;
 	bool			found;
 	int			is_block = 0;
 	int			error;
@@ -712,6 +718,7 @@ xchk_directory_blocks(
 				args.geo->fsbcount);
 		     lblk < got.br_startoff + got.br_blockcount;
 		     lblk += args.geo->fsbcount) {
+			last_data_db = xfs_dir2_da_to_db(mp->m_dir_geo, lblk);
 			error = xchk_directory_data_bestfree(sc, lblk,
 					is_block);
 			if (error)
@@ -734,7 +741,7 @@ xchk_directory_blocks(
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 			goto out;
 		}
-		error = xchk_directory_leaf1_bestfree(sc, &args,
+		error = xchk_directory_leaf1_bestfree(sc, &args, last_data_db,
 				leaf_lblk);
 		if (error)
 			goto out;

