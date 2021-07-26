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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FA7FC4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:46:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8716A60238
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:46:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233671AbhGZLFn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 07:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233589AbhGZLFk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jul 2021 07:05:40 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22CDEC061757
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:46:08 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id mt6so12541201pjb.1
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+sNe0biOTzrw8FH/FH+7krQPI3MEAik336cuQ1PpaBU=;
        b=o+RrJ1EcRK/kr/Ni7noL1i/HVVUUp50/Q6SSGEaLO68YGw24/YLDPHJJLDmSdadq6F
         +rGduVV0egO3oDh7MxgTHmbsKTMGfibeYjryFxqyx91dSocLuCD+xp4IzHeqbfc+PEXd
         0e7ECo2arJnZWWcgbxEWV70qqPGYyg63v5Xc+SbsRx4kZeTVblCZVuUSbqiPquVsP5ac
         wgl0M4M+jdr8VmYeYNlcXQsjcsSH7s46/R3IjYpltkMvNuXtPSqrt3u48Scl1FWHtkf3
         OEU2M93LRrxIH6Lua5sB9bWD2v6VXUzSuwnsQDn9L1HqfWOjLGCHwCioXi9+1moA8Xub
         Vf0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+sNe0biOTzrw8FH/FH+7krQPI3MEAik336cuQ1PpaBU=;
        b=ejQVJYQ69mA/AQzqJAoj3ETEo5/3FKZvCrwRHdHaQKfUY+HR9+zwQc9Ma7fSs5UBt4
         0c3Qslr352Vlunto59d8Q/AT4qasiSWHNlM18hQezP+JI41nJQR8kcWgbRNnd7/55Eek
         QXpB35UYOggZaovs2D8SaF4LAa67Ss1wc1obZ2Ef0UqkDERxDWPlCrYjbdGlhiDNWSlH
         M5mTisXTEBt2PqzQR9g0cA3lw74PN+rvhPBBYxy3mtXd4iNQ9J/KSWvDiksE/uxpNV6Z
         A7SMh+Bt2wrFagb6/VF/yARyG/XaJhhiDprthFQ8mpFKURbLp+2sxsSHtHh3MUDGSxJ/
         8QYA==
X-Gm-Message-State: AOAM530WGdQg08mImeyZLaNfuR7VzEx2JFql8zj4QinotSNQqqSjr940
        obbXJzocvhdP/tMBjhIUtgVlDzttmdI=
X-Google-Smtp-Source: ABdhPJzhT/CJ9don88L8lTuTF4cMA/5pNguX6ZIhBXy3WGDcGDBsA4Qz6k+jP5kVz3jRMZ9DQaUQ/A==
X-Received: by 2002:a17:90a:2f62:: with SMTP id s89mr1524586pjd.33.1627299967567;
        Mon, 26 Jul 2021 04:46:07 -0700 (PDT)
Received: from localhost.localdomain ([122.179.41.55])
        by smtp.gmail.com with ESMTPSA id k8sm50833919pgr.91.2021.07.26.04.46.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 04:46:07 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org
Subject: [PATCH V2 09/12] xfs: Rename XFS_IOC_BULKSTAT to XFS_IOC_BULKSTAT_V5
Date:   Mon, 26 Jul 2021 17:15:38 +0530
Message-Id: <20210726114541.24898-10-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726114541.24898-1-chandanrlinux@gmail.com>
References: <20210726114541.24898-1-chandanrlinux@gmail.com>
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
 fs/xfs/libxfs/xfs_fs.h |  4 ++--
 fs/xfs/xfs_ioctl.c     | 27 ++++++++++++++++++++++-----
 fs/xfs/xfs_ioctl32.c   |  7 +++++++
 fs/xfs/xfs_itable.c    |  4 ++--
 fs/xfs/xfs_itable.h    |  1 +
 5 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 2594fb647384..d760a969599e 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
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
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 2da90f81e6e3..85f45340cb16 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -715,6 +715,8 @@ xfs_fsbulkstat_one_fmt(
 {
 	struct xfs_bstat		bs1;
 
+	ASSERT(breq->version == XFS_BULKSTAT_VERSION_V1);
+
 	xfs_bulkstat_to_bstat(breq->mp, &bs1, bstat);
 	if (copy_to_user(breq->ubuffer, &bs1, sizeof(bs1)))
 		return -EFAULT;
@@ -728,6 +730,8 @@ xfs_fsinumbers_fmt(
 {
 	struct xfs_inogrp		ig1;
 
+	ASSERT(breq->version == XFS_INUMBERS_VERSION_V1);
+
 	xfs_inumbers_to_inogrp(&ig1, igrp);
 	if (copy_to_user(breq->ubuffer, &ig1, sizeof(struct xfs_inogrp)))
 		return -EFAULT;
@@ -787,14 +791,17 @@ xfs_ioc_fsbulkstat(
 	 */
 	if (cmd == XFS_IOC_FSINUMBERS) {
 		breq.startino = lastino ? lastino + 1 : 0;
+		breq.version = XFS_INUMBERS_VERSION_V1;
 		error = xfs_inumbers(&breq, xfs_fsinumbers_fmt);
 		lastino = breq.startino - 1;
 	} else if (cmd == XFS_IOC_FSBULKSTAT_SINGLE) {
 		breq.startino = lastino;
 		breq.icount = 1;
+		breq.version = XFS_BULKSTAT_VERSION_V1;
 		error = xfs_bulkstat_one(&breq, xfs_fsbulkstat_one_fmt);
 	} else {	/* XFS_IOC_FSBULKSTAT */
 		breq.startino = lastino ? lastino + 1 : 0;
+		breq.version = XFS_BULKSTAT_VERSION_V1;
 		error = xfs_bulkstat(&breq, xfs_fsbulkstat_one_fmt);
 		lastino = breq.startino - 1;
 	}
@@ -819,6 +826,8 @@ xfs_bulkstat_fmt(
 	struct xfs_ibulk		*breq,
 	const struct xfs_bulkstat	*bstat)
 {
+	ASSERT(breq->version == XFS_BULKSTAT_VERSION_V5);
+
 	if (copy_to_user(breq->ubuffer, bstat, sizeof(struct xfs_bulkstat)))
 		return -EFAULT;
 	return xfs_ibulk_advance(breq, sizeof(struct xfs_bulkstat));
@@ -918,13 +927,15 @@ STATIC int
 xfs_ioc_bulkstat(
 	struct file			*file,
 	unsigned int			cmd,
-	struct xfs_bulkstat_req __user	*arg)
+	struct xfs_bulkstat_req __user	*arg,
+	int				version)
 {
 	struct xfs_mount		*mp = XFS_I(file_inode(file))->i_mount;
 	struct xfs_bulk_ireq		hdr;
 	struct xfs_ibulk		breq = {
 		.mp			= mp,
 		.mnt_userns		= file_mnt_user_ns(file),
+		.version		= version,
 	};
 	int				error;
 
@@ -960,6 +971,8 @@ xfs_inumbers_fmt(
 	struct xfs_ibulk		*breq,
 	const struct xfs_inumbers	*igrp)
 {
+	ASSERT(breq->version == XFS_INUMBERS_VERSION_V5);
+
 	if (copy_to_user(breq->ubuffer, igrp, sizeof(struct xfs_inumbers)))
 		return -EFAULT;
 	return xfs_ibulk_advance(breq, sizeof(struct xfs_inumbers));
@@ -970,11 +983,13 @@ STATIC int
 xfs_ioc_inumbers(
 	struct xfs_mount		*mp,
 	unsigned int			cmd,
-	struct xfs_inumbers_req __user	*arg)
+	struct xfs_inumbers_req __user	*arg,
+	int				version)
 {
 	struct xfs_bulk_ireq		hdr;
 	struct xfs_ibulk		breq = {
 		.mp			= mp,
+		.version		= version,
 	};
 	int				error;
 
@@ -1882,10 +1897,12 @@ xfs_file_ioctl(
 	case XFS_IOC_FSINUMBERS:
 		return xfs_ioc_fsbulkstat(filp, cmd, arg);
 
-	case XFS_IOC_BULKSTAT:
-		return xfs_ioc_bulkstat(filp, cmd, arg);
+	case XFS_IOC_BULKSTAT_V5:
+		return xfs_ioc_bulkstat(filp, cmd, arg,
+				XFS_BULKSTAT_VERSION_V5);
 	case XFS_IOC_INUMBERS:
-		return xfs_ioc_inumbers(mp, cmd, arg);
+		return xfs_ioc_inumbers(mp, cmd, arg,
+				XFS_INUMBERS_VERSION_V5);
 
 	case XFS_IOC_FSGEOMETRY_V1:
 		return xfs_ioc_fsgeometry(mp, arg, 3);
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index bef19060f4aa..d9a7abc209b5 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -88,6 +88,8 @@ xfs_fsinumbers_fmt_compat(
 	struct xfs_inogrp		ig1;
 	struct xfs_inogrp		*igrp = &ig1;
 
+	ASSERT(breq->version == XFS_INUMBERS_VERSION_V1);
+
 	xfs_inumbers_to_inogrp(&ig1, ig);
 
 	if (put_user(igrp->xi_startino,   &p32->xi_startino) ||
@@ -177,6 +179,8 @@ xfs_fsbulkstat_one_fmt_compat(
 	struct xfs_bstat		bs1;
 	struct xfs_bstat		*buffer = &bs1;
 
+	ASSERT(breq->version == XFS_BULKSTAT_VERSION_V1);
+
 	xfs_bulkstat_to_bstat(breq->mp, &bs1, bstat);
 
 	if (put_user(buffer->bs_ino,	  &p32->bs_ino)		||
@@ -293,15 +297,18 @@ xfs_compat_ioc_fsbulkstat(
 	 */
 	if (cmd == XFS_IOC_FSINUMBERS_32) {
 		breq.startino = lastino ? lastino + 1 : 0;
+		breq.version = XFS_INUMBERS_VERSION_V1;
 		error = xfs_inumbers(&breq, inumbers_func);
 		lastino = breq.startino - 1;
 	} else if (cmd == XFS_IOC_FSBULKSTAT_SINGLE_32) {
 		breq.startino = lastino;
 		breq.icount = 1;
+		breq.version = XFS_BULKSTAT_VERSION_V1;
 		error = xfs_bulkstat_one(&breq, bs_one_func);
 		lastino = breq.startino;
 	} else if (cmd == XFS_IOC_FSBULKSTAT_32) {
 		breq.startino = lastino ? lastino + 1 : 0;
+		breq.version = XFS_BULKSTAT_VERSION_V1;
 		error = xfs_bulkstat(&breq, bs_one_func);
 		lastino = breq.startino - 1;
 	} else {
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 65c194cdea79..f0daa65e61ff 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -134,7 +134,7 @@ xfs_bulkstat_one_int(
 
 	buf->bs_xflags = xfs_ip2xflags(ip);
 	buf->bs_extsize_blks = ip->i_extsize;
-	buf->bs_extents = xfs_ifork_nextents(&ip->i_df);
+	buf->bs_extents32 = xfs_ifork_nextents(&ip->i_df);
 	xfs_bulkstat_health(ip, buf);
 	buf->bs_aextents = xfs_ifork_nextents(ip->i_afp);
 	buf->bs_forkoff = XFS_IFORK_BOFF(ip);
@@ -356,7 +356,7 @@ xfs_bulkstat_to_bstat(
 	bs1->bs_blocks = bstat->bs_blocks;
 	bs1->bs_xflags = bstat->bs_xflags;
 	bs1->bs_extsize = XFS_FSB_TO_B(mp, bstat->bs_extsize_blks);
-	bs1->bs_extents = bstat->bs_extents;
+	bs1->bs_extents = bstat->bs_extents32;
 	bs1->bs_gen = bstat->bs_gen;
 	bs1->bs_projid_lo = bstat->bs_projectid & 0xFFFF;
 	bs1->bs_forkoff = bstat->bs_forkoff;
diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
index f5a13f69883a..ee4d8d0461ca 100644
--- a/fs/xfs/xfs_itable.h
+++ b/fs/xfs/xfs_itable.h
@@ -14,6 +14,7 @@ struct xfs_ibulk {
 	unsigned int		icount;   /* number of elements in ubuffer */
 	unsigned int		ocount;   /* number of records returned */
 	unsigned int		flags;    /* see XFS_IBULK_FLAG_* */
+	int			version;  /* structure version to be returned */
 };
 
 /* Only iterate within the same AG as startino */
-- 
2.30.2

