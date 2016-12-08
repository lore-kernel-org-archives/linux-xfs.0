Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50476 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932164AbcLHSGF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Dec 2016 13:06:05 -0500
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CFC6F18E3C0
        for <linux-xfs@vger.kernel.org>; Thu,  8 Dec 2016 18:06:04 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_repair: junk leaf attribute if count == 0
Message-ID: <725190d9-6db0-4f6c-628b-76f2dca3071f@redhat.com>
Date: Thu, 8 Dec 2016 12:06:03 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: plambri@redhat.com

We have recently seen a case where, during log replay, the
attr3 leaf verifier reported corruption when encountering a
leaf attribute with a count of 0 in the header.

We chalked this up to a transient state when a shortform leaf
was created, the attribute didn't fit, and we promoted the
(empty) attribute to the larger leaf form.

I've recently been given a metadump of unknown provenance which actually
contains a leaf attribute with count 0 on disk.  This causes the
verifier to fire every time xfs_repair is run:

 Metadata corruption detected at xfs_attr3_leaf block 0x480988/0x1000

If this 0-count state is detected, we should just junk the leaf, same
as we would do if the count was too high.  With this change, we now
remedy the problem:

 Metadata corruption detected at xfs_attr3_leaf block 0x480988/0x1000
 bad attribute count 0 in attr block 0, inode 12587828
 problem with attribute contents in inode 12587828
 clearing inode 12587828 attributes
 correcting nblocks for inode 12587828, was 2 - counted 1

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 40cb5f7..b855a10 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -593,7 +593,8 @@ process_leaf_attr_block(
 	stop = xfs_attr3_leaf_hdr_size(leaf);
 
 	/* does the count look sorta valid? */
-	if (leafhdr.count * sizeof(xfs_attr_leaf_entry_t) + stop >
+	if (!leafhdr.count ||
+	    leafhdr.count * sizeof(xfs_attr_leaf_entry_t) + stop >
 						mp->m_sb.sb_blocksize) {
 		do_warn(
 	_("bad attribute count %d in attr block %u, inode %" PRIu64 "\n"),
