Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60A52C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 22:26:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbjBIW0g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 17:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbjBIW0e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 17:26:34 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2895568AE3
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 14:26:30 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id a8-20020a17090a6d8800b002336b48f653so1764413pjk.3
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 14:26:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I9lbwCZzIysHgaPLJ3pbh8BwWz1zuriXycaeBoxT4K0=;
        b=LZQJ8Q8qvGw/qttyvbCaQ4W1mBeMhth7RVHmMqiyAFRE8jX+qsSOPtxCOzCNbeRKjy
         6xh23N91GkYFlam/tZXzIeTBIyHC+pRTaE+v1pE2+fQTI4Do4FOS/m/pmv4dZwvBBhZd
         ABX5fIluX7IoMddZPiQktq/TpyYh60lVFdw2/rbDKgALltAPmvFGzH3RY2TxQp01DKgX
         XTCNoYcyovhETi+D5Yz/1kC/M28yF4SXBeHd+rsVzWjLN+sjvAZnSl5G0EoQ4ovpH7D+
         eetqh7igCs1Bdh3JozP+NidUXQF18/SZ2qyuGXNMW8a825nXhgQDsC9IJfIn2Hxji9Jf
         RvBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I9lbwCZzIysHgaPLJ3pbh8BwWz1zuriXycaeBoxT4K0=;
        b=WEpG2HoILutQxg/Bp757FEzLv74A4tMFZ2xMjy4nsi8SWqrKSoHHFY46X2jFiAeDOl
         yVCmXR/+IxXBu3Zli2epeQEf+fFUGjmqjTQk0wtdfQhlSa8GlQTn8QbL+Awo92dxfdK/
         AGWIpt00W+AKI+PEPdfz7aOyuTpsCEwrSaiknt2YW0naxFRgOVCYAWt3IYUVu5TEgOCI
         TnitYKFSoRq1UQcZ0WEAEyJ52yuTZewrJLEn53CnqURS3FKY0tS4zr2CdOdwBdqfS7Dy
         uIhGbLEycQ2r7xmxAiCbd4dKOYVUcW4a4IGfWJwIZgkusFEYsMhWpd/1U3kZEjcgNu6H
         q2uQ==
X-Gm-Message-State: AO0yUKUFYJMdTid9C6gC1+c2D8oAMep+tuOFAi9CN0VI0318YjH9Gj33
        2CdH2dWFLiZ9LPiFlvNazVje4aAt7L05yl/P
X-Google-Smtp-Source: AK7set+ylRqSUDYhIbbfK8dNUTFmM5wSpjwZJ7o3avZNkDWLc5XToMOuOKitz1QwYgmYfhfOFwxslw==
X-Received: by 2002:a17:90b:17c2:b0:22c:69b6:2be8 with SMTP id me2-20020a17090b17c200b0022c69b62be8mr14298413pjb.8.1675981589619;
        Thu, 09 Feb 2023 14:26:29 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id y19-20020a637d13000000b004dfacb4804bsm1787161pgc.21.2023.02.09.14.26.29
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 14:26:29 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pQFFM-00DOVA-5Y
        for linux-xfs@vger.kernel.org; Fri, 10 Feb 2023 09:18:28 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pQFFM-00FcMs-0W
        for linux-xfs@vger.kernel.org;
        Fri, 10 Feb 2023 09:18:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 12/42] xfs: convert xfs_ialloc_next_ag() to an atomic
Date:   Fri, 10 Feb 2023 09:17:55 +1100
Message-Id: <20230209221825.3722244-13-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209221825.3722244-1-david@fromorbit.com>
References: <20230209221825.3722244-1-david@fromorbit.com>
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
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ialloc.c | 17 +----------------
 fs/xfs/libxfs/xfs_sb.c     |  3 ++-
 fs/xfs/xfs_mount.h         |  3 +--
 fs/xfs/xfs_super.c         |  1 -
 4 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index c8b31c06a95d..86b7adc355e6 100644
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

