Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F068C4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:47:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 783E1601FD
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:47:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233688AbhGZLHX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 07:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233463AbhGZLHW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jul 2021 07:07:22 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F0EC061757
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:47:51 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id mt6so12546881pjb.1
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UrKkgXyTa6Zg2eSZoYP9ebRNht7GhTaU/pUIwGV/ojE=;
        b=RNVgLVpDfHK1gvFrGO/oUpUDG+dWZURnCpekt7Ap9puTrl+SqjzHfyCWsJYdnOSIdN
         EQThf7MjShqrkEtOgQnYWPxnMcFJe3+C2mqhMI4DCKJvV/Qq23XCjhTxGIVdT4BG7srf
         JnsrjPtvZdKGO0Tx/+NnGxkC/BeBvlj+NRK7XPHPRZnQQ6sH0XMevBwk/8C64eoozUHb
         uhpZJRPKbGjN9XRbEXoZdGgbaFPOMGerUqLB2c4mQIpXHHdZqEA3Dj8GcVPUvyG6Qhn9
         NVrmCtzuc3prV4QuWYecGp3RyyNfc5rEBsqwkwkw+yHr7tVrgh4KA5anvGT8gNHJdgQR
         KXIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UrKkgXyTa6Zg2eSZoYP9ebRNht7GhTaU/pUIwGV/ojE=;
        b=i8SmA7qiD0iPA+ZMZXQMe2ETzHqp2E5SA2hzS8QPe2aW/ifBKxtQ5wftMbR+hpG4Nc
         LthypVI838WFkiIjy4PW0tJsl4mFaTLf5Q/lfGzdLu4YG/NJh8G1OexoLhhw7UZYqHrE
         bFrOUvrmUkv261SjgHES1AluDDU0VGXr3CtvsJFbb7XSy2eHIcAfpp4qeBofXGmkcutn
         gkCzYVsqOMGMVT/95sXFXAhmsLxW4QjFnu8qQ788rGR+3Wea78iDhbjjkxJheZrWvU9A
         3X0EaUY83TAgGLenLgCfVgGD8k+gmmqIXR/2A6xpJXPy+or1qD3fBS5f3p8R4VRsXybM
         jtSg==
X-Gm-Message-State: AOAM5328vh8eYFHrsct6LnTp0gzC82H67vEUwDRL0wqMapAbHfuBiHnE
        tQfWiZWhbWdzQWDH8SOuJVjfab3ihOE=
X-Google-Smtp-Source: ABdhPJxqbLWScE4ZOBIx8fn3kUN+teE4UeK6vmWLnXPkY/+Ya11hIKc2Gs9zeefm4v+9AlL/OL/qjA==
X-Received: by 2002:a17:903:32cd:b029:12c:18ad:7e58 with SMTP id i13-20020a17090332cdb029012c18ad7e58mr5050043plr.67.1627300070454;
        Mon, 26 Jul 2021 04:47:50 -0700 (PDT)
Received: from localhost.localdomain ([122.179.41.55])
        by smtp.gmail.com with ESMTPSA id y10sm35936900pjy.18.2021.07.26.04.47.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 04:47:50 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org
Subject: [PATCH V2 09/12] xfsprogs: Rename XFS_IOC_BULKSTAT to XFS_IOC_BULKSTAT_V5
Date:   Mon, 26 Jul 2021 17:17:21 +0530
Message-Id: <20210726114724.24956-10-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726114724.24956-1-chandanrlinux@gmail.com>
References: <20210726114724.24956-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit renames XFS_IOC_BULKSTAT to XFS_IOC_BULKSTAT_V5 to allow a future
commit to extend bulkstat facility to support 64-bit extent counters. To this
end, this commit also renames xfs_bulkstat->bs_extents field to
xfs_bulkstat->bs_extents32.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fsr/xfs_fsr.c      | 4 ++--
 io/bulkstat.c      | 2 +-
 libfrog/bulkstat.c | 8 ++++----
 libxfs/xfs_fs.h    | 4 ++--
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index bb5d4a2c0..3446944cb 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -606,7 +606,7 @@ cmp(const void *s1, const void *s2)
 		(bs1->bs_version == XFS_BULKSTAT_VERSION_V5 &&
 		bs2->bs_version == XFS_BULKSTAT_VERSION_V5));
 
-	return (bs2->bs_extents - bs1->bs_extents);
+	return (bs2->bs_extents32 - bs1->bs_extents32);
 }
 
 /*
@@ -670,7 +670,7 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 		for (p = buf, endp = (buf + buflenout); p < endp ; p++) {
 			/* Do some obvious checks now */
 			if (((p->bs_mode & S_IFMT) != S_IFREG) ||
-			     (p->bs_extents < 2))
+			     (p->bs_extents32 < 2))
 				continue;
 
 			ret = open_handle(&file_fd, fshandlep, p,
diff --git a/io/bulkstat.c b/io/bulkstat.c
index 4ae275864..378048379 100644
--- a/io/bulkstat.c
+++ b/io/bulkstat.c
@@ -49,7 +49,7 @@ dump_bulkstat(
 	printf("\tbs_extsize_blks = %"PRIu32"\n", bstat->bs_extsize_blks);
 
 	printf("\tbs_nlink = %"PRIu32"\n", bstat->bs_nlink);
-	printf("\tbs_extents = %"PRIu32"\n", bstat->bs_extents);
+	printf("\tbs_extents = %"PRIu32"\n", bstat->bs_extents32);
 	printf("\tbs_aextents = %"PRIu32"\n", bstat->bs_aextents);
 	printf("\tbs_version = %"PRIu16"\n", bstat->bs_version);
 	printf("\tbs_forkoff = %"PRIu16"\n", bstat->bs_forkoff);
diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
index 195f6ea05..5a967d4b1 100644
--- a/libfrog/bulkstat.c
+++ b/libfrog/bulkstat.c
@@ -61,7 +61,7 @@ xfrog_bulkstat_single5(
 		return ret;
 
 	req->hdr.flags = flags;
-	ret = ioctl(xfd->fd, XFS_IOC_BULKSTAT, req);
+	ret = ioctl(xfd->fd, XFS_IOC_BULKSTAT_V5, req);
 	if (ret) {
 		ret = -errno;
 		goto free;
@@ -260,7 +260,7 @@ xfrog_bulkstat5(
 {
 	int			ret;
 
-	ret = ioctl(xfd->fd, XFS_IOC_BULKSTAT, req);
+	ret = ioctl(xfd->fd, XFS_IOC_BULKSTAT_V5, req);
 	if (ret)
 		return -errno;
 	return 0;
@@ -366,7 +366,7 @@ xfrog_bulkstat_v5_to_v1(
 	bs1->bs_blocks = bs5->bs_blocks;
 	bs1->bs_xflags = bs5->bs_xflags;
 	bs1->bs_extsize = cvt_off_fsb_to_b(xfd, bs5->bs_extsize_blks);
-	bs1->bs_extents = bs5->bs_extents;
+	bs1->bs_extents = bs5->bs_extents32;
 	bs1->bs_gen = bs5->bs_gen;
 	bs1->bs_projid_lo = bs5->bs_projectid & 0xFFFF;
 	bs1->bs_forkoff = bs5->bs_forkoff;
@@ -407,7 +407,7 @@ xfrog_bulkstat_v1_to_v5(
 	bs5->bs_blocks = bs1->bs_blocks;
 	bs5->bs_xflags = bs1->bs_xflags;
 	bs5->bs_extsize_blks = cvt_b_to_off_fsbt(xfd, bs1->bs_extsize);
-	bs5->bs_extents = bs1->bs_extents;
+	bs5->bs_extents32 = bs1->bs_extents;
 	bs5->bs_gen = bs1->bs_gen;
 	bs5->bs_projectid = bstat_get_projid(bs1);
 	bs5->bs_forkoff = bs1->bs_forkoff;
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 2594fb647..d760a9695 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -394,7 +394,7 @@ struct xfs_bulkstat {
 	uint32_t	bs_extsize_blks; /* extent size hint, blocks	*/
 
 	uint32_t	bs_nlink;	/* number of links		*/
-	uint32_t	bs_extents;	/* number of extents		*/
+	uint32_t	bs_extents32;	/* number of extents		*/
 	uint32_t	bs_aextents;	/* attribute number of extents	*/
 	uint16_t	bs_version;	/* structure version		*/
 	uint16_t	bs_forkoff;	/* inode fork offset in bytes	*/
@@ -853,7 +853,7 @@ struct xfs_scrub_metadata {
 #define XFS_IOC_FSGEOMETRY_V4	     _IOR ('X', 124, struct xfs_fsop_geom_v4)
 #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, uint32_t)
 #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 126, struct xfs_fsop_geom)
-#define XFS_IOC_BULKSTAT	     _IOR ('X', 127, struct xfs_bulkstat_req)
+#define XFS_IOC_BULKSTAT_V5	     _IOR ('X', 127, struct xfs_bulkstat_req)
 #define XFS_IOC_INUMBERS	     _IOR ('X', 128, struct xfs_inumbers_req)
 /*	FIEXCHANGE_RANGE ----------- hoisted 129	 */
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
-- 
2.30.2

