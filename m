Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39904 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752470AbdAZCaH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Jan 2017 21:30:07 -0500
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_repair: Fix uninit var in process_leaf_attr_level
Message-ID: <fe6cd162-4f2a-d470-f8ea-8a028a649212@redhat.com>
Date: Wed, 25 Jan 2017 20:30:05 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>

My unreviewed maintainer adjustment on the way in gets a
brown paper bag.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 158e31a..9ec2231 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -753,6 +753,7 @@ process_leaf_attr_level(xfs_mount_t	*mp,
 	struct xfs_attr3_icleaf_hdr leafhdr;
 
 	da_bno = da_cursor->level[0].bno;
+	ino = da_cursor->ino;
 	/*
 	 * 0 is the root block and no block
 	 * pointer can point to the root block of the btree
@@ -764,7 +765,6 @@ process_leaf_attr_level(xfs_mount_t	*mp,
 		goto error_out;
 	}
 
-	ino = da_cursor->ino;
 	prev_bno = 0;
 
 	do {

