Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37150 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728761AbfEVSFs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 May 2019 14:05:48 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6635F8CB51
        for <linux-xfs@vger.kernel.org>; Wed, 22 May 2019 18:05:48 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 251021B465
        for <linux-xfs@vger.kernel.org>; Wed, 22 May 2019 18:05:48 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 03/11] xfs: skip small alloc cntbt logic on NULL cursor
Date: Wed, 22 May 2019 14:05:38 -0400
Message-Id: <20190522180546.17063-4-bfoster@redhat.com>
In-Reply-To: <20190522180546.17063-1-bfoster@redhat.com>
References: <20190522180546.17063-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The small allocation helper is implemented in a way that is fairly
tightly integrated to the existing allocation algorithms. It expects
a cntbt cursor beyond the end of the tree, attempts to locate the
last record in the tree and only attempts an AGFL allocation if the
cntbt is empty.

The upcoming generic algorithm doesn't rely on the cntbt processing
of this function. It will only call this function when the cntbt
doesn't have a big enough extent or is empty and thus AGFL
allocation is the only remaining option. Tweak
xfs_alloc_ag_vextent_small() to handle a NULL cntbt cursor and skip
the cntbt logic. This facilitates use by the existing allocation
code and new code that only requires an AGFL allocation attempt.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_alloc.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index b345fe771c54..436f8eb0bc4c 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -713,9 +713,16 @@ xfs_alloc_ag_vextent_small(
 	int			error = 0;
 	xfs_agblock_t		fbno = NULLAGBLOCK;
 	xfs_extlen_t		flen = 0;
-	int			i;
+	int			i = 0;
 
-	error = xfs_btree_decrement(ccur, 0, &i);
+	/*
+	 * If a cntbt cursor is provided, try to allocate the largest record in
+	 * the tree. Try the AGFL if the cntbt is empty, otherwise fail the
+	 * allocation. Make sure to respect minleft even when pulling from the
+	 * freelist.
+	 */
+	if (ccur)
+		error = xfs_btree_decrement(ccur, 0, &i);
 	if (error)
 		goto error;
 	if (i) {
-- 
2.17.2
