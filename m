Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42836 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751296AbeDDTMl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Apr 2018 15:12:41 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id DEC022B0F
        for <linux-xfs@vger.kernel.org>; Wed,  4 Apr 2018 14:12:05 -0500 (CDT)
Subject: [PATCH 6/6] xfs: delay quota timelimit init until after quotacheck
From: Eric Sandeen <sandeen@sandeen.net>
References: <f0856054-551f-9139-39f7-1d5439910903@sandeen.net>
Message-ID: <49eeb340-2ff2-c274-d26b-fd8edd982d61@sandeen.net>
Date: Wed, 4 Apr 2018 14:12:40 -0500
MIME-Version: 1.0
In-Reply-To: <f0856054-551f-9139-39f7-1d5439910903@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Initializing the time limits in the quota info requires reading
the default quota block.  If it's corrupt, this yields even more
dmesg spew before kernelspace gets around to properly detecting
and repairing the corruption.

If we move the read and initialization until post-quotacheck,
we can avoid the noisy read if it's corrupted.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_qm.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index a4da46c..95487cb4 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -698,9 +698,9 @@ struct xfs_qm_isolate {
 	qinf->qi_dqchunklen = XFS_FSB_TO_BB(mp, XFS_DQUOT_CLUSTER_SIZE_FSB);
 	qinf->qi_dqperchunk = xfs_calc_dquots_per_chunk(qinf->qi_dqchunklen);
 
-	mp->m_qflags |= (mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD);
+	/* Default quota will be read post-quotacheck to set timelimits */
 
-	xfs_qm_set_timelimits(mp, qinf);
+	mp->m_qflags |= (mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD);
 
 	qinf->qi_shrinker.scan_objects = xfs_qm_shrink_scan;
 	qinf->qi_shrinker.seeks = DEFAULT_SEEKS;
@@ -1469,6 +1469,10 @@ struct xfs_qm_isolate {
 			return;
 		}
 	}
+
+	/* Now that quotacheck is done, set time limits */
+	xfs_qm_set_timelimits(mp, mp->m_quotainfo);
+
 	/*
 	 * If one type of quotas is off, then it will lose its
 	 * quotachecked status, since we won't be doing accounting for
-- 
1.8.3.1

