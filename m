Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E936C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 19:48:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240982AbiEXTsv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 15:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239067AbiEXTsv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 15:48:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C27577892C
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 12:48:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8AC99B81B9A
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 19:48:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57007C34100;
        Tue, 24 May 2022 19:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653421727;
        bh=DsAKeBjGipozb1iLIOGMgIKoAhfow2JDmXHDDn0PWP8=;
        h=Date:From:To:Cc:Subject:From;
        b=kzA0mtfVCP1ZztrYiyuSDflrQgAcU3u94+YN/OxDnSmRGfSzEzQ3Jm1v9VTmqnyGc
         nrQYdXDxIu8dFhwIt37jes7XCMBm4uSPTkZGcK/ZlFsCVWidFDd0RVNvGm9LQyp+Ty
         6f2dNybdFhOwuh+Xjoe5VlsflHV8Xpc585w1LNoPCOHO9XiL7MIbIgU5zCX9mcEg9f
         zLYdhAg4NcG6HbquIYY8SqLpbmKoWavpoKjI0LUE96zD+XeKPEUu8OSZrFynqLCi52
         YsaabROqq2bKtm33BYvE7yLfJvVjiu/TfRqKlBGKbvbNkQoeb2LbMg5nCRQ+jwFX6P
         XDbRfSEPk8AkQ==
Date:   Tue, 24 May 2022 12:48:46 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs_repair: don't flag log_incompat inconsistencies as
 corruptions
Message-ID: <Yo02nmlajIuFqVez@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While testing xfs/233 and xfs/127 with LARP mode enabled, I noticed
errors such as the following:

xfs_growfs --BlockSize=4096 --Blocks=8192
data blocks changed from 8192 to 2579968
meta-data=/dev/sdf               isize=512    agcount=630, agsize=4096 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1
data     =                       bsize=4096   blocks=2579968, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=3075, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
_check_xfs_filesystem: filesystem on /dev/sdf is inconsistent (r)
*** xfs_repair -n output ***
Phase 1 - find and verify superblock...
        - reporting progress in intervals of 15 minutes
Phase 2 - using internal log
        - zero log...
        - 23:03:47: zeroing log - 3075 of 3075 blocks done
        - scan filesystem freespace and inode maps...
would fix log incompat feature mismatch in AG 30 super, 0x0 != 0x1
would fix log incompat feature mismatch in AG 8 super, 0x0 != 0x1
would fix log incompat feature mismatch in AG 12 super, 0x0 != 0x1
would fix log incompat feature mismatch in AG 24 super, 0x0 != 0x1
would fix log incompat feature mismatch in AG 18 super, 0x0 != 0x1
<snip>

0x1 corresponds to XFS_SB_FEAT_INCOMPAT_LOG_XATTRS, which is the feature
bit used to indicate that the log contains extended attribute log intent
items.  This is a mechanism to prevent older kernels from trying to
recover log items that they won't know how to recover.

I thought about this a little bit more, and realized that log_incompat
features bits are set on the primary sb prior to writing certain types
of log records, and cleared once the log has written the committed
changes back to the filesystem.  If the secondary superblocks are
updated at any point during that interval (due to things like growfs or
setting labels), the log_incompat field will now be set on the secondary
supers.

Due to the ephemeral nature of the current log_incompat feature bits,
a discrepancy between the primary and secondary supers is not a
corruption.  If we're in dry run mode, we should log the discrepancy,
but that's not a reason to end with EXIT_FAILURE.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/agheader.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/repair/agheader.c b/repair/agheader.c
index 2c2a26d1..478ed7e5 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -286,15 +286,24 @@ check_v5_feature_mismatch(
 		}
 	}
 
+	/*
+	 * Log incompat feature bits are set and cleared from the primary super
+	 * as needed to protect against log replay on old kernels finding log
+	 * records that they cannot handle.  Secondary sb resyncs performed as
+	 * part of a geometry update to the primary sb (e.g. growfs, label/uuid
+	 * changes) will copy the log incompat feature bits, but it's not a
+	 * corruption for a secondary to have a bit set that is clear in the
+	 * primary super.
+	 */
 	if (mp->m_sb.sb_features_log_incompat != sb->sb_features_log_incompat) {
 		if (no_modify) {
-			do_warn(
-	_("would fix log incompat feature mismatch in AG %u super, 0x%x != 0x%x\n"),
+			do_log(
+	_("would sync log incompat feature in AG %u super, 0x%x != 0x%x\n"),
 					agno, mp->m_sb.sb_features_log_incompat,
 					sb->sb_features_log_incompat);
 		} else {
 			do_warn(
-	_("will fix log incompat feature mismatch in AG %u super, 0x%x != 0x%x\n"),
+	_("will sync log incompat feature in AG %u super, 0x%x != 0x%x\n"),
 					agno, mp->m_sb.sb_features_log_incompat,
 					sb->sb_features_log_incompat);
 			dirty = true;
