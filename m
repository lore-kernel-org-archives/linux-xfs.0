Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37382 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S3000941AbdDZOCq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Apr 2017 10:02:46 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] mkfs.xfs: Assign proper defaults to rmapbt and reflink flags
Message-ID: <0f7c888b-5c62-e874-53d1-9159f1a3beba@redhat.com>
Date: Wed, 26 Apr 2017 09:02:44 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Jan Tulak <jtulak@redhat.com>

The "defaultval" field in the options structure was a bit confusing,
so when the rmapbt & reflink options got added, the desire was
to keep them off by default, and "defaultval = 0" got set.

However, the purpose of this field is to define the default value
when the flag is specified with no associated value, i.e.

-m rmapbt vs. -m rmapbt=0 or -m rmapbt=1

Today, the resulting behavior is unexpected, and different from any
other mkfs flags; specifying "-m rmapbt,reflink" results in a
filesystem /without/ those features.

Fix these to be consistent with every other boolean flag in the
mkfs options, so that specifying the flag with no value will
enable the feature.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I want to get this fixed up for 4.11, so just sending it separately
ahead of any other change Jan may make in this area.

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index affa405..10858e4 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -697,13 +697,13 @@ struct opt_params mopts = {
 		  .conflicts = { LAST_CONFLICT },
 		  .minval = 0,
 		  .maxval = 1,
-		  .defaultval = 0,
+		  .defaultval = 1,
 		},
 		{ .index = M_REFLINK,
 		  .conflicts = { LAST_CONFLICT },
 		  .minval = 0,
 		  .maxval = 1,
-		  .defaultval = 0,
+		  .defaultval = 1,
 		},
 	},
 };

