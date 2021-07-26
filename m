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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E50B4C4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:46:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE03C60238
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:46:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233656AbhGZLFr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 07:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233669AbhGZLFn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jul 2021 07:05:43 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A996AC061760
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:46:09 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id l19so12605393pjz.0
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=znSA5RStZM3Z97yY0DOr1Pxi36RUJ6xfhLKiW9+thY0=;
        b=fEWci3OQ9eUmyjuz8wH9mvRl5LEzuMo2tMqRCNl4GAvaGosZ7iV6wLsvswnOKGu4mL
         hlQ305B3NSM2l0fgM9ymsjd4QH4NKyV92NeRU6iJ3NOTdGGPiRJX1fOPTYBFHf2l3HDQ
         popPlXmV8jCDf2Z7sCfLW7yMru0SgLcD32/FUc7q2L1ughI6iz7/iv4FRQYg1TTOu4HW
         J2v01qc8MnAzkOIu0OnXBCsgp/m6Fvy/IeOkR3KQz21Uppx9FeBotPbGTSPVV8kgXYXB
         R/SyZMz96mXqTsk9WpyQZGn10bIbfdJjO0crkuNv+QkoQU+EvD+b4YQw33NKsYPekMqO
         JS4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=znSA5RStZM3Z97yY0DOr1Pxi36RUJ6xfhLKiW9+thY0=;
        b=p1vMedu4G9eadkXGcffdYrAYSPes4MUGVXpRuQfRIsHCuDOYDA1Sz0lwbtGAuAOgGe
         Vi3Fm0kHapxnVEnCPWy/P29f3UcIH9H7v61yDqSntR8gD9bzVCigOTt/zz48L/2lDx2l
         KCYpP5dCd1/SONKJTRn0L+ek1SCfMHwKel02JjajHLWrTP+ai+V4mHDPvXKZYL8OgN7t
         yQfDO7TNwZT1W22QzvXjfAolyvARDl5NXM5Lfoh/XuzP5JGZzG55byC4Pjk+EyB9BtWA
         vJ4vrODLaV2ZDqVzR7cfptCCmU44TgktKFeWC6Y88/atKVwziqoVgzJJRfWXYdvCMgWd
         K6yQ==
X-Gm-Message-State: AOAM530EJomSJQFQxeWlHbZpR8/VDU2OCY3cY+TQoKXxBlw7YOJS7fvH
        kiQ6K+KBsY3TagPhpIg+YtZ75K7wKqw=
X-Google-Smtp-Source: ABdhPJyVUS7YeowaO8CZwqB8T54BCP67SkjE7IfqGz7EqFRR7iVLDNP9Wp3PJVOFMabwBOudzDt7Iw==
X-Received: by 2002:aa7:8b07:0:b029:2f7:d38e:ff1 with SMTP id f7-20020aa78b070000b02902f7d38e0ff1mr17825578pfd.72.1627299969143;
        Mon, 26 Jul 2021 04:46:09 -0700 (PDT)
Received: from localhost.localdomain ([122.179.41.55])
        by smtp.gmail.com with ESMTPSA id k8sm50833919pgr.91.2021.07.26.04.46.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 04:46:08 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org
Subject: [PATCH V2 10/12] xfs: Enable bulkstat ioctl to support 64-bit extent counters
Date:   Mon, 26 Jul 2021 17:15:39 +0530
Message-Id: <20210726114541.24898-11-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726114541.24898-1-chandanrlinux@gmail.com>
References: <20210726114541.24898-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds XFS_IOC_BULKSTAT_V6 to support 64-bit inode extent
counters. The new field xfs_bulkstat->bs_extents64 is added to hold data
extent count for filesystems supporting 64-bit data extent counters.

However, the accessibility of this ioctl is deferred to a future commit which
actually adds support for 64-bit data extent counter.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_fs.h |  6 ++++--
 fs/xfs/xfs_ioctl.c     |  5 +++--
 fs/xfs/xfs_itable.c    | 26 +++++++++++++++++++++++---
 3 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index d760a969599e..756be4ff5996 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -394,7 +394,7 @@ struct xfs_bulkstat {
 	uint32_t	bs_extsize_blks; /* extent size hint, blocks	*/
 
 	uint32_t	bs_nlink;	/* number of links		*/
-	uint32_t	bs_extents32;	/* number of extents		*/
+	uint32_t	bs_extents32;	/* number of extents; v5 only	*/
 	uint32_t	bs_aextents;	/* attribute number of extents	*/
 	uint16_t	bs_version;	/* structure version		*/
 	uint16_t	bs_forkoff;	/* inode fork offset in bytes	*/
@@ -403,12 +403,14 @@ struct xfs_bulkstat {
 	uint16_t	bs_checked;	/* checked inode metadata	*/
 	uint16_t	bs_mode;	/* type and mode		*/
 	uint16_t	bs_pad2;	/* zeroed			*/
+	uint64_t	bs_extents64;	/* number of extents; v6 only	*/
 
-	uint64_t	bs_pad[7];	/* zeroed			*/
+	uint64_t	bs_pad[6];	/* zeroed			*/
 };
 
 #define XFS_BULKSTAT_VERSION_V1	(1)
 #define XFS_BULKSTAT_VERSION_V5	(5)
+#define XFS_BULKSTAT_VERSION_V6	(6)
 
 /* bs_sick flags */
 #define XFS_BS_SICK_INODE	(1 << 0)  /* inode core */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 85f45340cb16..19964b394dc4 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -826,7 +826,8 @@ xfs_bulkstat_fmt(
 	struct xfs_ibulk		*breq,
 	const struct xfs_bulkstat	*bstat)
 {
-	ASSERT(breq->version == XFS_BULKSTAT_VERSION_V5);
+	ASSERT(breq->version == XFS_BULKSTAT_VERSION_V5 ||
+		breq->version == XFS_BULKSTAT_VERSION_V6);
 
 	if (copy_to_user(breq->ubuffer, bstat, sizeof(struct xfs_bulkstat)))
 		return -EFAULT;
@@ -922,7 +923,7 @@ xfs_bulk_ireq_teardown(
 	hdr->ocount = breq->ocount;
 }
 
-/* Handle the v5 bulkstat ioctl. */
+/* Handle the v5/v6 bulkstat ioctl. */
 STATIC int
 xfs_ioc_bulkstat(
 	struct file			*file,
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index f0daa65e61ff..8493870a0a87 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -74,6 +74,7 @@ xfs_bulkstat_one_int(
 	struct xfs_inode	*ip;		/* incore inode pointer */
 	struct inode		*inode;
 	struct xfs_bulkstat	*buf = bc->buf;
+	xfs_extnum_t		nextents;
 	int			error = -EINVAL;
 
 	error = xfs_iget(mp, tp, ino,
@@ -95,7 +96,12 @@ xfs_bulkstat_one_int(
 		buf->bs_gen = inode->i_generation;
 		buf->bs_mode = inode->i_mode & S_IFMT;
 		xfs_bulkstat_health(ip, buf);
-		buf->bs_version = XFS_BULKSTAT_VERSION_V5;
+
+		if (bc->breq->version != XFS_BULKSTAT_VERSION_V6)
+			buf->bs_version = XFS_BULKSTAT_VERSION_V5;
+		else
+			buf->bs_version = XFS_BULKSTAT_VERSION_V6;
+
 		xfs_iunlock(ip, XFS_ILOCK_SHARED);
 		xfs_irele(ip);
 
@@ -134,11 +140,25 @@ xfs_bulkstat_one_int(
 
 	buf->bs_xflags = xfs_ip2xflags(ip);
 	buf->bs_extsize_blks = ip->i_extsize;
-	buf->bs_extents32 = xfs_ifork_nextents(&ip->i_df);
+
+	nextents = xfs_ifork_nextents(&ip->i_df);
+	if (bc->breq->version != XFS_BULKSTAT_VERSION_V6) {
+		if (nextents > XFS_IFORK_EXTCNT_MAXS32) {
+			xfs_iunlock(ip, XFS_ILOCK_SHARED);
+			xfs_irele(ip);
+			error = -EINVAL;
+			goto out_advance;
+		}
+		buf->bs_extents32 = nextents;
+		buf->bs_version = XFS_BULKSTAT_VERSION_V5;
+	} else {
+		buf->bs_extents64 = nextents;
+		buf->bs_version = XFS_BULKSTAT_VERSION_V6;
+	}
+
 	xfs_bulkstat_health(ip, buf);
 	buf->bs_aextents = xfs_ifork_nextents(ip->i_afp);
 	buf->bs_forkoff = XFS_IFORK_BOFF(ip);
-	buf->bs_version = XFS_BULKSTAT_VERSION_V5;
 
 	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		buf->bs_btime = ip->i_crtime.tv_sec;
-- 
2.30.2

