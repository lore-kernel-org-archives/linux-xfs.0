Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:40422 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933194AbeF1J2m (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jun 2018 05:28:42 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BBFD4814FDCF
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 09:28:41 +0000 (UTC)
Received: from odin.usersys.redhat.com (ovpn-204-57.brq.redhat.com [10.40.204.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 20DD51C71C
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 09:28:40 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH V2] xfs: Initialize variables in xfs_alloc_get_rec before using them
Date: Thu, 28 Jun 2018 11:28:35 +0200
Message-Id: <20180628092835.25879-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Make sure we initialize *bno and *len, before jumping to out_bad_rec
label, and risk calling xfs_warn() with uninitialized variables.

Coverity: 100898
Coverity: 1437081
Coverity: 1437129
Coverity: 1437191
Coverity: 1437201
Coverity: 1437212
Coverity: 1437341
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---

This is based on Darrick's suggestion, although, I believe initializing *bno and
*len before testing if *len is empty or not is a bit more clear than changing
xfs_warn() to use rec->alloc.ar_startblock and rec->alloc.ar_blockcount
directly.

 fs/xfs/libxfs/xfs_alloc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index eef466260d43..75dbdc14c45f 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -223,12 +223,13 @@ xfs_alloc_get_rec(
 	error = xfs_btree_get_rec(cur, &rec, stat);
 	if (error || !(*stat))
 		return error;
-	if (rec->alloc.ar_blockcount == 0)
-		goto out_bad_rec;
 
 	*bno = be32_to_cpu(rec->alloc.ar_startblock);
 	*len = be32_to_cpu(rec->alloc.ar_blockcount);
 
+	if (*len == 0)
+		goto out_bad_rec;
+
 	/* check for valid extent range, including overflow */
 	if (!xfs_verify_agbno(mp, agno, *bno))
 		goto out_bad_rec;
-- 
2.14.3

