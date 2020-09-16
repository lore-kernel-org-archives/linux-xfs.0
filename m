Return-Path: <SRS0=KYGq=CZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA65DC433E2
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 20:41:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6902B205CB
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 20:41:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FbaVlpXj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgIPUlK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 16:41:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41577 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728429AbgIPUlD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 16:41:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600288862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=sXluQkp7GDO9J1LBvDUbwtuT0VKyszMXIQPNK9rO1gA=;
        b=FbaVlpXjX3Ahs6iuTryNVJKB6QbWIcwh36WSW19DJqrUkG8vsw3vRA8k04z2IcPsyzVw0j
        4OVzVPV2+iRTct2lJbd9PF1Dvix8GYHFI0ogtUc3UZetmExWD5pF6uhlRS0kt9OOQTl5/e
        u0joe5vz8OJEfzaQx6GcXynSFWgWUII=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-LMLVSzd7OI2fssNRC703Hw-1; Wed, 16 Sep 2020 16:41:00 -0400
X-MC-Unique: LMLVSzd7OI2fssNRC703Hw-1
Received: by mail-wm1-f70.google.com with SMTP id q205so1590675wme.0
        for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2020 13:40:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sXluQkp7GDO9J1LBvDUbwtuT0VKyszMXIQPNK9rO1gA=;
        b=ry3fkafrGCHpZgenWrsllilg9Bz7buvZHOWmeAvhQrsVCeSwsjNJSAx6fkOEvkwxAC
         vB7cSFtjYP7vTIirF8YGO4dQqtUPyAigJl0QLOC6+8RKXRUd477F+x6Vu0cu6Qynjv+7
         zFOyZiVySnMJ7Cdz2COERdxQykIV92ai2hm9f/Jm0bPzedXslAyv+ytM979BqkwfzIt8
         NtFPAyYKa3mcWuFzX1etFk+fyaVS9ZZr23gAPIFXz1gBjCde8XkqysHQylFzuVcFMu1h
         5efgZHFhTix8aHNgEKfxyCE4ZUerilPuiMuew8T2wzZBD3I9t+xdldVollDM65CQJyVf
         nYTw==
X-Gm-Message-State: AOAM532KBalKGpKAaVj+v3CyNIsgf7B3+cuTqErSSK6e7QqRt5Y0NL2C
        9435VZMBcMtiKKNOsLyXyTKLEnRne8Bye1FTFwrsCd2II3esuBCzJVRRwvu4xkIuunuXy9EYPMW
        2fvRVmgrKAAnNbeRw1VmW
X-Received: by 2002:a5d:6406:: with SMTP id z6mr27559562wru.133.1600288858654;
        Wed, 16 Sep 2020 13:40:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzV2Wb9+DWQ0GHSl0xnId5TWMcDVo5wKH3IzVbSa2+jYbt+gPQMrE/9LW65OkpKGWubBzDR6w==
X-Received: by 2002:a5d:6406:: with SMTP id z6mr27559548wru.133.1600288858456;
        Wed, 16 Sep 2020 13:40:58 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id g8sm7257653wmd.12.2020.09.16.13.40.57
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 13:40:57 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2] mkfs.xfs: fix ASSERT on too-small device with stripe geometry
Date:   Wed, 16 Sep 2020 22:40:56 +0200
Message-Id: <20200916204056.29247-1-preichl@redhat.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

When a too-small device is created with stripe geometry, we hit an
assert in align_ag_geometry():

mkfs.xfs: xfs_mkfs.c:2834: align_ag_geometry: Assertion `cfg->agcount != 0' failed.

This is because align_ag_geometry() finds that the size of the last
(only) AG is too small, and attempts to trim it off.  Obviously 0
AGs is invalid, and we hit the ASSERT.

Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
Suggested-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Pavel Reichl <preichl@redhat.com>
---
 include/xfs_multidisk.h | 14 +++++++-------
 mkfs/xfs_mkfs.c         |  6 +++---
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/xfs_multidisk.h b/include/xfs_multidisk.h
index 1b9936ec..abfb50ce 100644
--- a/include/xfs_multidisk.h
+++ b/include/xfs_multidisk.h
@@ -14,7 +14,6 @@
 #define	XFS_DFL_BLOCKSIZE_LOG	12		/* 4096 byte blocks */
 #define	XFS_DINODE_DFL_LOG	8		/* 256 byte inodes */
 #define	XFS_DINODE_DFL_CRC_LOG	9		/* 512 byte inodes for CRCs */
-#define	XFS_MIN_DATA_BLOCKS	100
 #define	XFS_MIN_INODE_PERBLOCK	2		/* min inodes per block */
 #define	XFS_DFL_IMAXIMUM_PCT	25		/* max % of space for inodes */
 #define	XFS_MIN_REC_DIRSIZE	12		/* 4096 byte dirblocks (V2) */
@@ -25,13 +24,14 @@
 						 * accept w/o warnings
 						 */
 
-#define XFS_AG_BYTES(bblog)	((long long)BBSIZE << (bblog))
-#define	XFS_AG_MIN_BYTES	((XFS_AG_BYTES(15)))	/* 16 MB */
-#define	XFS_AG_MAX_BYTES	((XFS_AG_BYTES(31)))	/* 1 TB */
-#define XFS_AG_MIN_BLOCKS(blog)	(XFS_AG_MIN_BYTES >> (blog))
-#define XFS_AG_MAX_BLOCKS(blog)	((XFS_AG_MAX_BYTES - 1) >> (blog))
+#define XFS_AG_BYTES(bblog)		((long long)BBSIZE << (bblog))
+#define	XFS_MIN_DATA_BLOCKS(cfg)	(XFS_AG_MIN_BLOCKS((cfg)->blocklog))
+#define	XFS_AG_MIN_BYTES		((XFS_AG_BYTES(15)))	/* 16 MB */
+#define	XFS_AG_MAX_BYTES		((XFS_AG_BYTES(31)))	/* 1 TB */
+#define XFS_AG_MIN_BLOCKS(blog)		(XFS_AG_MIN_BYTES >> (blog))
+#define XFS_AG_MAX_BLOCKS(blog)		((XFS_AG_MAX_BYTES - 1) >> (blog))
 
-#define XFS_MAX_AGNUMBER	((xfs_agnumber_t)(NULLAGNUMBER - 1))
+#define XFS_MAX_AGNUMBER		((xfs_agnumber_t)(NULLAGNUMBER - 1))
 
 /*
  * These values define what we consider a "multi-disk" filesystem. That is, a
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index a687f385..204dfff1 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2530,10 +2530,10 @@ _("size %s specified for data subvolume is too large, maximum is %lld blocks\n")
 		cfg->dblocks = DTOBT(xi->dsize, cfg->blocklog);
 	}
 
-	if (cfg->dblocks < XFS_MIN_DATA_BLOCKS) {
+	if (cfg->dblocks < XFS_MIN_DATA_BLOCKS(cfg)) {
 		fprintf(stderr,
-_("size %lld of data subvolume is too small, minimum %d blocks\n"),
-			(long long)cfg->dblocks, XFS_MIN_DATA_BLOCKS);
+_("size %lld of data subvolume is too small, minimum %lld blocks\n"),
+			(long long)cfg->dblocks, XFS_MIN_DATA_BLOCKS(cfg));
 		usage();
 	}
 
-- 
2.26.2

