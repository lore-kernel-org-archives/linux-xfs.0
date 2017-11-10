Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:9939 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755402AbdKJBj2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2017 20:39:28 -0500
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1eCyI2-000878-EV
        for linux-xfs@vger.kernel.org; Fri, 10 Nov 2017 12:39:26 +1100
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1eCyI2-0003zR-Ag
        for linux-xfs@vger.kernel.org; Fri, 10 Nov 2017 12:39:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs_io: fix gcc-7 related printf warnings
Date: Fri, 10 Nov 2017 12:39:26 +1100
Message-Id: <20171110013926.15289-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

New compiler, new checks, new warnings.

Fix the new [-Wformat-truncation=] warnings that io/fsmap.c is
throwing w/ gcc-7.2 because "%lld..%lld" requires a buffer 40
characters long, not 32.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 io/fsmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io/fsmap.c b/io/fsmap.c
index 448fb5356466..e46fdbaa148c 100644
--- a/io/fsmap.c
+++ b/io/fsmap.c
@@ -184,8 +184,8 @@ dump_map_verbose(
 	off64_t			agoff, bperag;
 	int			foff_w, boff_w, aoff_w, tot_w, agno_w, own_w;
 	int			nr_w, dev_w;
-	char			rbuf[32], bbuf[32], abuf[32], obuf[32];
-	char			nbuf[32], dbuf[32], gbuf[32];
+	char			rbuf[40], bbuf[40], abuf[40], obuf[40];
+	char			nbuf[40], dbuf[40], gbuf[40];
 	char			owner[OWNER_BUF_SZ];
 	int			sunit, swidth;
 	int			flg = 0;
-- 
2.15.0

