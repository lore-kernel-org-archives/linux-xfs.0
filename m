Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31DD6C4338F
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 02:07:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 127FE6105A
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 02:07:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238097AbhHECHW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Aug 2021 22:07:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238148AbhHECHU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Aug 2021 22:07:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3582E6105A;
        Thu,  5 Aug 2021 02:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628129227;
        bh=P4rG1V5ihlqi/nk5QbukDBEdn3JlATsyoq4IosZatvg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fBNbiU28+9tlnOfd71e8BRQQkqO74VtCj+Hp+IgNe7a10Kn9GAIeUrL7x2RaYtvWF
         8SAn5S1BQv2mgkUqnKg9TjYCocMDfq76IIevGtdrR4SSKtl2WUWWgAXQDej++zKuq+
         NvhwWjDqc2Yi6bm0mK7Kj9oKCPvzBdDToE6u7s52IUP6XGuOxLyRWKT/uz/UiQSv+z
         MWWQ8AWDZ5q6ejeKgzkoQFOVbBHNxCoqHDc+/t2Z2Dg0UddOkopmuOQeWojl+C4wgw
         xvDwzA/Z/KLhqTr9fr7hj3z4OMIc7a86Dbqstdipn5cSSIwUjCH/CHMd11dX42MY4V
         EG9QuYs+4NbuA==
Subject: [PATCH 08/14] xfs: queue inactivation immediately when free realtime
 extents are tight
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Wed, 04 Aug 2021 19:07:06 -0700
Message-ID: <162812922691.2589546.7668598169022490963.stgit@magnolia>
In-Reply-To: <162812918259.2589546.16599271324044986858.stgit@magnolia>
References: <162812918259.2589546.16599271324044986858.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we have made the inactivation of unlinked inodes a background
task to increase the throughput of file deletions, we need to be a
little more careful about how long of a delay we can tolerate.

Similar to the patch doing this for free space on the data device, if
the file being inactivated is a realtime file and the realtime volume is
running low on free extents, we want to run the worker ASAP so that the
realtime allocator can make better decisions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |   24 ++++++++++++++++++++++++
 fs/xfs/xfs_mount.c  |   13 ++++++++-----
 fs/xfs/xfs_mount.h  |    3 ++-
 3 files changed, 34 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index e5e90f09bcc6..4a062cf689c3 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1924,6 +1924,27 @@ xfs_inodegc_start(
 	xfs_inodegc_queue_all(mp);
 }
 
+#ifdef CONFIG_XFS_RT
+static inline bool
+xfs_inodegc_want_queue_rt_file(
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	uint64_t		freertx;
+
+	if (!XFS_IS_REALTIME_INODE(ip))
+		return false;
+
+	spin_lock(&mp->m_sb_lock);
+	freertx = mp->m_sb.sb_frextents;
+	spin_unlock(&mp->m_sb_lock);
+
+	return freertx < mp->m_low_rtexts[XFS_LOWSP_5_PCNT];
+}
+#else
+# define xfs_inodegc_want_queue_rt_file(ip)	(false)
+#endif /* CONFIG_XFS_RT */
+
 /*
  * Schedule the inactivation worker when:
  *
@@ -1946,6 +1967,9 @@ xfs_inodegc_want_queue_work(
 				XFS_FDBLOCKS_BATCH) < 0)
 		return true;
 
+	if (xfs_inodegc_want_queue_rt_file(ip))
+		return true;
+
 	if (xfs_inode_near_dquot_enforcement(ip, XFS_DQTYPE_USER))
 		return true;
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 5fe6f1db4fe9..ed1e7e3dce7e 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -365,13 +365,16 @@ void
 xfs_set_low_space_thresholds(
 	struct xfs_mount	*mp)
 {
-	int i;
+	uint64_t		dblocks = mp->m_sb.sb_dblocks;
+	uint64_t		rtexts = mp->m_sb.sb_rextents;
+	int			i;
+
+	do_div(dblocks, 100);
+	do_div(rtexts, 100);
 
 	for (i = 0; i < XFS_LOWSP_MAX; i++) {
-		uint64_t space = mp->m_sb.sb_dblocks;
-
-		do_div(space, 100);
-		mp->m_low_space[i] = space * (i + 1);
+		mp->m_low_space[i] = dblocks * (i + 1);
+		mp->m_low_rtexts[i] = rtexts * (i + 1);
 	}
 }
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 750297498a09..1061ac985c18 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -145,7 +145,8 @@ typedef struct xfs_mount {
 	int			m_fixedfsid[2];	/* unchanged for life of FS */
 	uint			m_qflags;	/* quota status flags */
 	uint64_t		m_flags;	/* global mount flags */
-	int64_t			m_low_space[XFS_LOWSP_MAX];
+	uint64_t		m_low_space[XFS_LOWSP_MAX];
+	uint64_t		m_low_rtexts[XFS_LOWSP_MAX];
 	struct xfs_ino_geometry	m_ino_geo;	/* inode geometry */
 	struct xfs_trans_resv	m_resv;		/* precomputed res values */
 						/* low free space thresholds */

