Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:53574 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751095AbdLXTMP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 24 Dec 2017 14:12:15 -0500
Received: from Liberator-5.netgear.com (unknown [50.35.53.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id DD52177B2D0
        for <linux-xfs@vger.kernel.org>; Sun, 24 Dec 2017 13:11:49 -0600 (CST)
Subject: [PATCH 3/3] mkfs: do not allow both "dev" and "name" subopts for log
 or realtime
From: Eric Sandeen <sandeen@sandeen.net>
References: <529c056a-a40c-06b8-a37e-3b1b7e664303@sandeen.net>
Message-ID: <6ea46cfb-357b-17c4-fc5f-65598431526f@sandeen.net>
Date: Sun, 24 Dec 2017 11:12:13 -0800
MIME-Version: 1.0
In-Reply-To: <529c056a-a40c-06b8-a37e-3b1b7e664303@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Today we can specify i.e. both logdev= and name= ;
it works, with last-parsed-wins behavior:

mkfs.xfs -f -l logdev=/dev/sda1,name=/dev/sda2 /dev/sda3

Make these conflict to resolve ambiguity; do the same for
the realtime subvol.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 035af03..5ae67d5 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -507,6 +507,7 @@ struct opt_params lopts = {
 		},
 		{ .index = L_DEV,
 		  .conflicts = { { &lopts, L_AGNUM },
+				 { &lopts, L_NAME },
 				 { &lopts, L_INTERNAL },
 				 { &lopts, LAST_CONFLICT } },
 		  .defaultval = SUBOPT_NEEDS_VAL,
@@ -529,6 +530,7 @@ struct opt_params lopts = {
 		},
 		{ .index = L_NAME,
 		  .conflicts = { { &lopts, L_AGNUM },
+				 { &lopts, L_DEV },
 				 { &lopts, L_INTERNAL },
 				 { &lopts, LAST_CONFLICT } },
 		  .defaultval = SUBOPT_NEEDS_VAL,
@@ -599,7 +601,8 @@ struct opt_params ropts = {
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = R_DEV,
-		  .conflicts = { { &ropts, LAST_CONFLICT } },
+		  .conflicts = { { &ropts, R_NAME },
+			         { &ropts, LAST_CONFLICT } },
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = R_FILE,
@@ -609,7 +612,8 @@ struct opt_params ropts = {
 		  .conflicts = { { &ropts, LAST_CONFLICT } },
 		},
 		{ .index = R_NAME,
-		  .conflicts = { { &ropts, LAST_CONFLICT } },
+		  .conflicts = { { &ropts, R_DEV },
+			         { &ropts, LAST_CONFLICT } },
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = R_NOALIGN,
