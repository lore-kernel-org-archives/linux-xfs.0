Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47502 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbfHEAe7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Aug 2019 20:34:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x750Obvo023953
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:34:57 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2u51ptmb9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 05 Aug 2019 00:34:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x750N0Zb195596
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:34:57 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2u51kkts9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 05 Aug 2019 00:34:57 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x750YuZh012524
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:34:56 GMT
Subject: [PATCH 02/18] xfs: always rescan allegedly healthy per-ag metadata
 after repair
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 04 Aug 2019 17:34:55 -0700
Message-ID: <156496529566.804304.5836342939008239769.stgit@magnolia>
In-Reply-To: <156496528310.804304.8105015456378794397.stgit@magnolia>
References: <156496528310.804304.8105015456378794397.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

After an online repair function runs for a per-AG metadata structure,
sc->sick_mask is supposed to reflect the per-AG metadata that the repair
function fixed.  Our next move is to re-check the metadata to assess
the completeness of our repair, so we don't want the rebuilt structure
to be excluded from the rescan just because the health system previously
logged a problem with the data structure.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/health.c |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index b2f602811e9d..4865b2180e22 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -220,6 +220,16 @@ xchk_ag_btree_healthy_enough(
 		return true;
 	}
 
+	/*
+	 * If we just repaired some AG metadata, sc->sick_mask will reflect all
+	 * the per-AG metadata types that were repaired.  Exclude these from
+	 * the filesystem health query because we have not yet updated the
+	 * health status and we want everything to be scanned.
+	 */
+	if ((sc->flags & XREP_ALREADY_FIXED) &&
+	    type_to_health_flag[sc->sm->sm_type].group == XHG_AG)
+		mask &= ~sc->sick_mask;
+
 	if (xfs_ag_has_sickness(pag, mask)) {
 		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XFAIL;
 		return false;
