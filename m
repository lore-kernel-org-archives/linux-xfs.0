Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF5BDC07E95
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Jul 2021 02:57:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF86661424
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Jul 2021 02:57:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhGCDA3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Jul 2021 23:00:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230353AbhGCDA2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Jul 2021 23:00:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA77E61416;
        Sat,  3 Jul 2021 02:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625281076;
        bh=B5CXjl5gYKzgwNIvy154yNSoTNppk20kiOk2HZw3lyw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=iDOgHODM4FCkVoFadkwW3hwsbuhSPbQ6/lsA5bfIZmZGPC8uuBa9AJ+84g6shSlEi
         QdNE2RUZACsBSNzlZGFuuxIvoKjZaBoFcqEkrnFOekTsm+vrXJVQO9djJn77r1XaNl
         tuCS0kOF9PyiE8dMjtDbLXRaiAthxBW5xwbN3V98/fTDzgUHPkE+1wtXWUTQtUasOt
         XZxXYRH+R9XkB8BTzozNVC5zCLi0JxoGhTdDp/jQyYr5Y5yDSVvkGn8mOI3LsFF/wh
         QDZC4MxO88RHj11XEe4B1PXI63jafVJqElqO+i6h4cbsLUXqdUkOL9nLgDVOroD9BQ
         gevyLu/RCrCHQ==
Subject: [PATCH 2/2] mkfs: validate rt extent size hint when rtinherit is set
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com, hch@infradead.org
Date:   Fri, 02 Jul 2021 19:57:55 -0700
Message-ID: <162528107571.36302.10688550571764503068.stgit@locust>
In-Reply-To: <162528106460.36302.18265535074182102487.stgit@locust>
References: <162528106460.36302.18265535074182102487.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Extent size hints exist to nudge the behavior of the file data block
allocator towards trying to make aligned allocations.  Therefore, it
doesn't make sense to allow a hint that isn't a multiple of the
fundamental allocation unit for a given file.

This means that if the sysadmin is formatting with rtinherit set on the
root dir, validate_extsize_hint needs to check the hint value on a
simulated realtime file to make sure that it's correct.  Unfortunately,
the gate check here was for a nonzero rt extent size, which is wrong
since we never format with rtextsize==0.  This leads to absurd failures
such as:

# mkfs.xfs -f /dev/sdf -r extsize=7b -d rtinherit=0,extszinherit=13
illegal extent size hint 13, must be less than 649088 and a multiple of 7.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index f84a42f9..9c14c04e 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2384,10 +2384,11 @@ _("illegal extent size hint %lld, must be less than %u.\n"),
 	}
 
 	/*
-	 * Now we do it again with a realtime file so that we know the hint and
-	 * flag that get passed on to realtime files will be correct.
+	 * If the value is to be passed on to realtime files, revalidate with
+	 * a realtime file so that we know the hint and flag that get passed on
+	 * to realtime files will be correct.
 	 */
-	if (mp->m_sb.sb_rextsize == 0)
+	if (!(cli->fsx.fsx_xflags & FS_XFLAG_RTINHERIT))
 		return;
 
 	flags = XFS_DIFLAG_REALTIME;

