Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C962FC433DB
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 11:31:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A27C721D79
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 11:31:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725840AbhADLbk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Jan 2021 06:31:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60757 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725830AbhADLbj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jan 2021 06:31:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609759813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Oh1UQT8l5uI5jKy4v7K5ditbYDvrThP3KQ2u4F3okeE=;
        b=FEJGNjxxgUepHNArOgLPVdWgkWGPUxTHp/iOas0d5sbkwGfaDV2ZtmY7vT7EEdcWcHxZSu
        5apDbQPTsbdavFSNEYYxR7iWwrmQyrL8iu8/vqH4XWoCKPqbzewL5VU/dqSCWORS29HVzQ
        76THczfCdFX12CF0ax0f1nFVCuyXuvE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-NjsiKk2pO2ylshENARHfqg-1; Mon, 04 Jan 2021 06:30:11 -0500
X-MC-Unique: NjsiKk2pO2ylshENARHfqg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F374B59
        for <linux-xfs@vger.kernel.org>; Mon,  4 Jan 2021 11:30:10 +0000 (UTC)
Received: from bogon.redhat.com (ovpn-14-10.pek2.redhat.com [10.72.14.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 175E819726
        for <linux-xfs@vger.kernel.org>; Mon,  4 Jan 2021 11:30:09 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] mkfs: make inobtcount visible
Date:   Mon,  4 Jan 2021 19:30:06 +0800
Message-Id: <20210104113006.328274-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

When set inobtcount=1/0, we can't see it from xfs geometry report.
So make it visible.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---
 libfrog/fsgeom.c | 6 ++++--
 libxfs/xfs_fs.h  | 1 +
 libxfs/xfs_sb.c  | 2 ++
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 14507668..c2b5f265 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -29,6 +29,7 @@ xfs_report_geom(
 	int			rmapbt_enabled;
 	int			reflink_enabled;
 	int			bigtime_enabled;
+	int			inobtcnt_enabled;
 
 	isint = geo->logstart > 0;
 	lazycount = geo->flags & XFS_FSOP_GEOM_FLAGS_LAZYSB ? 1 : 0;
@@ -45,12 +46,13 @@ xfs_report_geom(
 	rmapbt_enabled = geo->flags & XFS_FSOP_GEOM_FLAGS_RMAPBT ? 1 : 0;
 	reflink_enabled = geo->flags & XFS_FSOP_GEOM_FLAGS_REFLINK ? 1 : 0;
 	bigtime_enabled = geo->flags & XFS_FSOP_GEOM_FLAGS_BIGTIME ? 1 : 0;
+	inobtcnt_enabled = geo->flags & XFS_FSOP_GEOM_FLAGS_INOBTCNT ? 1 : 0;
 
 	printf(_(
 "meta-data=%-22s isize=%-6d agcount=%u, agsize=%u blks\n"
 "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
 "         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u\n"
-"         =%-22s reflink=%-4u bigtime=%u\n"
+"         =%-22s reflink=%-4u bigtime=%u, inobtcount=%u\n"
 "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 "         =%-22s sunit=%-6u swidth=%u blks\n"
 "naming   =version %-14u bsize=%-6u ascii-ci=%d, ftype=%d\n"
@@ -60,7 +62,7 @@ xfs_report_geom(
 		mntpoint, geo->inodesize, geo->agcount, geo->agblocks,
 		"", geo->sectsize, attrversion, projid32bit,
 		"", crcs_enabled, finobt_enabled, spinodes, rmapbt_enabled,
-		"", reflink_enabled, bigtime_enabled,
+		"", reflink_enabled, bigtime_enabled, inobtcnt_enabled,
 		"", geo->blocksize, (unsigned long long)geo->datablocks,
 			geo->imaxpct,
 		"", geo->sunit, geo->swidth,
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 2a2e3cfd..6fad140d 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -250,6 +250,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_RMAPBT	(1 << 19) /* reverse mapping btree */
 #define XFS_FSOP_GEOM_FLAGS_REFLINK	(1 << 20) /* files can share blocks */
 #define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
+#define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index fb2212b8..a5ab0211 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1145,6 +1145,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_REFLINK;
 	if (xfs_sb_version_hasbigtime(sbp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_BIGTIME;
+	if (xfs_sb_version_hasinobtcounts(sbp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_INOBTCNT;
 	if (xfs_sb_version_hassector(sbp))
 		geo->logsectsize = sbp->sb_logsectsize;
 	else
-- 
2.25.4

