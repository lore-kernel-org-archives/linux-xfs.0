Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62B90C38159
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 22:45:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjARWp1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:45:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbjARWpS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:45:18 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E8763E3D
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:16 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id z3so126927pfb.2
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AM/yFw9DPN4KIAGOss3si3SHWCLwKSOHyX05QXq/+Rc=;
        b=aMGGe3rq0NW16xm9yj1KDr3HF6WXXa5zVEzYJrskcWxGOtooZfi5+OH86NoOuNDM74
         UngDWNWiWmdosdvmqkelj2nV4xW1FehXh0tVO1G+QeOiIOGNvcdeIP/Rl84v+llAG7LA
         jCUotXOvs+1JVcwk0yZxzPCCUOak/ysNbHECd3g6kwaa/Tk8Va4mkaFV2U3lxjOndrZN
         rWhfKkjG4u6C1rxl2Ab41PzVn6KscfuMWkflV4NPOsaAXfODSLyo63XyY8QC1FTJeiUu
         npDwJNLr/cgSqH8ytunBYbZcDC8eUqx54YaiaTalruAGWpnPUBKZ1EdEIZ+zUMmljCAr
         yoSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AM/yFw9DPN4KIAGOss3si3SHWCLwKSOHyX05QXq/+Rc=;
        b=oKsVvG10S9EbpiyqJX2Qhm/xo/KCnNBvMFkpGt79VPr+iHr/HpM9HlYKJUeakDTThC
         nJshOU5V47EP6gqVaofQOSbLCF5n2kn7+NRlzfCwSX6lY26BlsXKIFYgWzfIpn1uqi4N
         uWbc5qFXob3o903mlWaV8mzc/M/pDh1diCbKZYLh+wTtzmgOck1tZtTLvTie01ksjggc
         a9r4ZAlfe8lBIPvZX40mh9jsYMdkCeLrmG5f6aK+uR4ZXsMeUMsLwrCqT1st2HuvtW1/
         vE1FVP+wZ+2mFsgXscNuzzGuygGhUUKeZkAOTilTVIILx/alnmgvfhrCVtrLbcdGxhDV
         O5kw==
X-Gm-Message-State: AFqh2kqUsGMhKsFHsMvKEJY4H2JMa9QZnXgooiIOwKExtdVZCH9o/5AS
        oWy/wgzMmMfisFzOEmCJSsU8gGZWnwm0OFI8
X-Google-Smtp-Source: AMrXdXtdsZoZUQfXdxaz1gbaJM60ep3Ml4b34C2P8STJd5Zsb6UbTauwM1dJA72DXEgaBIBpiC5A9w==
X-Received: by 2002:a05:6a00:3495:b0:58d:d7b6:cf58 with SMTP id cp21-20020a056a00349500b0058dd7b6cf58mr7622217pfb.7.1674081915799;
        Wed, 18 Jan 2023 14:45:15 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id 3-20020a621503000000b00581c741f95csm20795520pfv.46.2023.01.18.14.45.13
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:45:13 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB9-004iXA-4H
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB9-008FDT-0R
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 12/42] xfs: convert xfs_ialloc_next_ag() to an atomic
Date:   Thu, 19 Jan 2023 09:44:35 +1100
Message-Id: <20230118224505.1964941-13-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118224505.1964941-1-david@fromorbit.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

This is currently a spinlock lock protected rotor which can be
implemented with a single atomic operation. Change it to be more
efficient and get rid of the m_agirotor_lock. Noticed while
converting the inode allocation AG selection loop to active perag
references.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 17 +----------------
 fs/xfs/libxfs/xfs_sb.c     |  3 ++-
 fs/xfs/xfs_mount.h         |  3 +--
 fs/xfs/xfs_super.c         |  1 -
 4 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 5b8401038bab..c8d837d8876f 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1576,21 +1576,6 @@ xfs_dialloc_roll(
 	return error;
 }
 
-static xfs_agnumber_t
-xfs_ialloc_next_ag(
-	xfs_mount_t	*mp)
-{
-	xfs_agnumber_t	agno;
-
-	spin_lock(&mp->m_agirotor_lock);
-	agno = mp->m_agirotor;
-	if (++mp->m_agirotor >= mp->m_maxagi)
-		mp->m_agirotor = 0;
-	spin_unlock(&mp->m_agirotor_lock);
-
-	return agno;
-}
-
 static bool
 xfs_dialloc_good_ag(
 	struct xfs_perag	*pag,
@@ -1748,7 +1733,7 @@ xfs_dialloc(
 	 * an AG has enough space for file creation.
 	 */
 	if (S_ISDIR(mode))
-		start_agno = xfs_ialloc_next_ag(mp);
+		start_agno = atomic_inc_return(&mp->m_agirotor) % mp->m_maxagi;
 	else {
 		start_agno = XFS_INO_TO_AGNO(mp, parent);
 		if (start_agno >= mp->m_maxagi)
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 1eeecf2eb2a7..99cc03a298e2 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -909,7 +909,8 @@ xfs_sb_mount_common(
 	struct xfs_mount	*mp,
 	struct xfs_sb		*sbp)
 {
-	mp->m_agfrotor = mp->m_agirotor = 0;
+	mp->m_agfrotor = 0;
+	atomic_set(&mp->m_agirotor, 0);
 	mp->m_maxagi = mp->m_sb.sb_agcount;
 	mp->m_blkbit_log = sbp->sb_blocklog + XFS_NBBYLOG;
 	mp->m_blkbb_log = sbp->sb_blocklog - BBSHIFT;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 8aca2cc173ac..f3269c0626f0 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -210,8 +210,7 @@ typedef struct xfs_mount {
 	struct xfs_error_cfg	m_error_cfg[XFS_ERR_CLASS_MAX][XFS_ERR_ERRNO_MAX];
 	struct xstats		m_stats;	/* per-fs stats */
 	xfs_agnumber_t		m_agfrotor;	/* last ag where space found */
-	xfs_agnumber_t		m_agirotor;	/* last ag dir inode alloced */
-	spinlock_t		m_agirotor_lock;/* .. and lock protecting it */
+	atomic_t		m_agirotor;	/* last ag dir inode alloced */
 
 	/* Memory shrinker to throttle and reprioritize inodegc */
 	struct shrinker		m_inodegc_shrinker;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 0c4b73e9b29d..96375b5622fd 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1922,7 +1922,6 @@ static int xfs_init_fs_context(
 		return -ENOMEM;
 
 	spin_lock_init(&mp->m_sb_lock);
-	spin_lock_init(&mp->m_agirotor_lock);
 	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
 	spin_lock_init(&mp->m_perag_lock);
 	mutex_init(&mp->m_growlock);
-- 
2.39.0

