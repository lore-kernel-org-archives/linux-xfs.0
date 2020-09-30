Return-Path: <SRS0=giQg=DH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5250C4727C
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Sep 2020 06:35:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CA622076A
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Sep 2020 06:35:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725320AbgI3Gfk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Sep 2020 02:35:40 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:45972 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725535AbgI3Gfk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Sep 2020 02:35:40 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 9081482540B;
        Wed, 30 Sep 2020 16:35:36 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kNViB-0001S9-6m; Wed, 30 Sep 2020 16:35:35 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1kNViA-000b2v-Lu; Wed, 30 Sep 2020 16:35:34 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     nathans@redhat.com
Subject: [PATCH 1/2] xfs: stats expose padding value at end of qm line
Date:   Wed, 30 Sep 2020 16:35:31 +1000
Message-Id: <20200930063532.142256-2-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200930063532.142256-1-david@fromorbit.com>
References: <20200930063532.142256-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=reM5J-MqmosA:10 a=20KFwNOVAAAA:8 a=J_TEopbkc_tPh9fy0NUA:9
        a=guKmcpLB375hL5oD:21 a=pds3yW93IAeJ4Szg:21
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

There are 8 quota stats exposed, but:

$ grep qm /proc/fs/xfs/stat
qm 0 0 0 1889 308893 0 0 0 0
$

There are 9 values exposed. Code inspection reveals that the struct
xfsstats has a hole in the structure where the values change from 32
bit counters to 64 bit counters. pahole output:

....
uint32_t                   xs_qm_dquot;          /*   748     4 */
uint32_t                   xs_qm_dquot_unused;   /*   752     4 */

/* XXX 4 bytes hole, try to pack */

uint64_t                   xs_xstrat_bytes;      /*   760     8 */
....

Fix this by defining an "end of 32 bit variables" variable that
we then use to define the end of the quota line. This will then
ensure that we print the correct number of values regardless of
structure layout.

However, ABI requirements for userspace parsers mean we cannot
remove the output that results from this hole, so we also need to
explicitly define this unused value until such time that we actually
add a new stat that makes the output meaningful.

And now we have a defined end of 32bit variables, update the  stats
union to be sized to match all the 32 bit variables correctly.

Output with this patch:

$ grep qm /proc/fs/xfs/stat
qm 0 0 0 326 1802 0 6 3 0
$

Reported-by: Nathan Scott <nathans@redhat.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_stats.c |  2 +-
 fs/xfs/xfs_stats.h | 15 +++++++++++++--
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index f70f1255220b..3409b273f00a 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -51,7 +51,7 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 		{ "rmapbt",		xfsstats_offset(xs_refcbt_2)	},
 		{ "refcntbt",		xfsstats_offset(xs_qm_dqreclaims)},
 		/* we print both series of quota information together */
-		{ "qm",			xfsstats_offset(xs_xstrat_bytes)},
+		{ "qm",			xfsstats_offset(xs_end_of_32bit_counts)},
 	};
 
 	/* Loop over all stats groups */
diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
index 34d704f703d2..861acf84cb3c 100644
--- a/fs/xfs/xfs_stats.h
+++ b/fs/xfs/xfs_stats.h
@@ -133,6 +133,17 @@ struct __xfsstats {
 	uint32_t		xs_qm_dqwants;
 	uint32_t		xs_qm_dquot;
 	uint32_t		xs_qm_dquot_unused;
+	uint32_t		xs_qm_zero_until_next_stat_is_added;
+
+/*
+ * Define the end of 32 bit counters as a 32 bit variable so that we don't
+ * end up exposing an implicit structure padding hole due to the next counters
+ * being 64bit values. If the number of coutners is odd, this fills the hole. If
+ * the number of coutners is even the hole is after this variable and the stats
+ * line will terminate printing at this offset and not print the hole.
+ */
+	uint32_t		xs_end_of_32bit_counts;
+
 /* Extra precision counters */
 	uint64_t		xs_xstrat_bytes;
 	uint64_t		xs_write_bytes;
@@ -143,8 +154,8 @@ struct __xfsstats {
 
 struct xfsstats {
 	union {
-		struct __xfsstats	s;
-		uint32_t		a[xfsstats_offset(xs_qm_dquot)];
+		struct __xfsstats s;
+		uint32_t	a[xfsstats_offset(xs_end_of_32bit_counts)];
 	};
 };
 
-- 
2.28.0

