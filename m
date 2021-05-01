Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39898C433B4
	for <linux-xfs@archiver.kernel.org>; Sat,  1 May 2021 06:07:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10073613F0
	for <linux-xfs@archiver.kernel.org>; Sat,  1 May 2021 06:07:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbhEAGIg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 1 May 2021 02:08:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:58462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229505AbhEAGIg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 1 May 2021 02:08:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB697613EF;
        Sat,  1 May 2021 06:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619849266;
        bh=zf8j9oYD5HVQ1LGQFvf7djbazKO+5b9+/+TzjQfmW3c=;
        h=Date:From:To:Cc:Subject:From;
        b=HR1miv14Sn1RS8EonzPlUSTE/bUkJitxN5+Wz2mrm2j1fDKqMTiD/1xnVbk6r0BeC
         dDbqfDa1XEozhY1UE1TFv23C2WkRVlTvdw3jKU1T1UjA6mMSYBxHnoqQUtQS3GXL4g
         dmzMYM8mah3hQ5Vv7jGlTJJ7H8ngT+3oY0bxevL8UnZ1UtmFRZNO0Z1mHqGr+VsNvS
         ppqFlLmkedMslwAgjDY4dD6eN8m1QpMNwidy/dck/nznhcmAdrAslNpA8SrsyVeNri
         M6cFO1ZYTrZ7yKNtvVxDx7LGi5cjQK/wFnNKTrXIZCvI1P+IAsxi9m2PjrhDTxKer1
         BysflT/MsD8bA==
Date:   Fri, 30 Apr 2021 23:07:45 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] mkfs: reject cowextsize after making final decision about
 reflink support
Message-ID: <20210501060745.GA7448@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

There's a snippet of code that rejects cowextsize option if reflink is
disabled.  This really ought to be /after/ the last place where we can
turn off reflink.  Fix it so that people don't see stuff like this:

$ mkfs.xfs -r rtdev=b.img a.img -f -d cowextsize=16
illegal CoW extent size hint 16, must be less than 9600.

(reflink isn't supported when realtime is enabled)

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 0eac5336..f84a42f9 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2164,13 +2164,6 @@ _("inode btree counters not supported without finobt support\n"));
 		cli->sb_feat.inobtcnt = false;
 	}
 
-	if ((cli->fsx.fsx_xflags & FS_XFLAG_COWEXTSIZE) &&
-	    !cli->sb_feat.reflink) {
-		fprintf(stderr,
-_("cowextsize not supported without reflink support\n"));
-		usage();
-	}
-
 	if (cli->xi->rtname) {
 		if (cli->sb_feat.reflink && cli_opt_set(&mopts, M_REFLINK)) {
 			fprintf(stderr,
@@ -2187,6 +2180,13 @@ _("rmapbt not supported with realtime devices\n"));
 		cli->sb_feat.rmapbt = false;
 	}
 
+	if ((cli->fsx.fsx_xflags & FS_XFLAG_COWEXTSIZE) &&
+	    !cli->sb_feat.reflink) {
+		fprintf(stderr,
+_("cowextsize not supported without reflink support\n"));
+		usage();
+	}
+
 	/*
 	 * Copy features across to config structure now.
 	 */
