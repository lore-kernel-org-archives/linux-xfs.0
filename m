Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9480EC433B4
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Apr 2021 21:00:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EC0461158
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Apr 2021 21:00:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbhDMVBO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Apr 2021 17:01:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:60474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229666AbhDMVBO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Apr 2021 17:01:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D257361176;
        Tue, 13 Apr 2021 21:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618347654;
        bh=2twklLVsiiTAhx4ULnreo8j5NZdiPzTm3s+W42E/mVk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DmKaJmYd2ehm+AXv5evPN5/YaAPLdJHvslWE90cOXLEamv68p+gczSblGOxJdW1f9
         aJosbkVh7RAa5ic7jKwYHgowtrzdp/Oaf3KzLPHL7f8viu3ZU1Z0+F/+rnLYirWvz1
         CA8cAjLzbE3gVp1WKlX/ZrSMFD5atK05Gsu29lqqsjVvVrVfSfhBFdS09/LqYEM24y
         9Ca8aXPTtqdb+1t5JVWOAiyFD1urMabArmp14LNYjUgPaEw+srO+5LuHX4bdG+JQ/f
         hrh38kCXO5N6oIS7xz3RE+QU+qIgoANHYc37ILmLbnrd7SSJTzS7B62Z9C3AH9zyJ4
         BECZJrcNU3d6w==
Subject: [PATCH 1/2] libfrog: report inobtcount in geometry
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 13 Apr 2021 14:00:53 -0700
Message-ID: <161834765317.2607077.766491854638241008.stgit@magnolia>
In-Reply-To: <161834764606.2607077.6884775882008256887.stgit@magnolia>
References: <161834764606.2607077.6884775882008256887.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Report the inode btree counter feature in fs feature reports.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/fsgeom.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 14507668..4f1a1842 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -29,6 +29,7 @@ xfs_report_geom(
 	int			rmapbt_enabled;
 	int			reflink_enabled;
 	int			bigtime_enabled;
+	int			inobtcount;
 
 	isint = geo->logstart > 0;
 	lazycount = geo->flags & XFS_FSOP_GEOM_FLAGS_LAZYSB ? 1 : 0;
@@ -45,12 +46,13 @@ xfs_report_geom(
 	rmapbt_enabled = geo->flags & XFS_FSOP_GEOM_FLAGS_RMAPBT ? 1 : 0;
 	reflink_enabled = geo->flags & XFS_FSOP_GEOM_FLAGS_REFLINK ? 1 : 0;
 	bigtime_enabled = geo->flags & XFS_FSOP_GEOM_FLAGS_BIGTIME ? 1 : 0;
+	inobtcount = geo->flags & XFS_FSOP_GEOM_FLAGS_INOBTCNT ? 1 : 0;
 
 	printf(_(
 "meta-data=%-22s isize=%-6d agcount=%u, agsize=%u blks\n"
 "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
 "         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u\n"
-"         =%-22s reflink=%-4u bigtime=%u\n"
+"         =%-22s reflink=%-4u bigtime=%u inobtcount=%u\n"
 "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 "         =%-22s sunit=%-6u swidth=%u blks\n"
 "naming   =version %-14u bsize=%-6u ascii-ci=%d, ftype=%d\n"
@@ -60,7 +62,7 @@ xfs_report_geom(
 		mntpoint, geo->inodesize, geo->agcount, geo->agblocks,
 		"", geo->sectsize, attrversion, projid32bit,
 		"", crcs_enabled, finobt_enabled, spinodes, rmapbt_enabled,
-		"", reflink_enabled, bigtime_enabled,
+		"", reflink_enabled, bigtime_enabled, inobtcount,
 		"", geo->blocksize, (unsigned long long)geo->datablocks,
 			geo->imaxpct,
 		"", geo->sunit, geo->swidth,

