Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37699 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754734AbcJQNy1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Oct 2016 09:54:27 -0400
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8FC65800B0
        for <linux-xfs@vger.kernel.org>; Mon, 17 Oct 2016 13:54:26 +0000 (UTC)
Received: from [IPv6:::1] (ovpn03.gateway.prod.ext.phx2.redhat.com [10.5.9.3])
        by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id u9HDsP2u010840
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
        for <linux-xfs@vger.kernel.org>; Mon, 17 Oct 2016 09:54:26 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: remove pointless error goto in xfs_bmap_remap_alloc
Message-ID: <3f9689e1-3e1a-c874-f6ae-88ac40f9cde1@redhat.com>
Date: Mon, 17 Oct 2016 08:54:25 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

The commit:

f65306ea xfs: map an inode's offset to an exact physical block

added a pointless error0: target; remove it.

Addresses-Coverity-Id: 1373865
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c27344c..861cf8d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3974,9 +3974,6 @@ xfs_bmap_remap_alloc(
 	 * allocating, so skip that check by pretending to be freeing.
 	 */
 	error = xfs_alloc_fix_freelist(&args, XFS_ALLOC_FLAG_FREEING);
-	if (error)
-		goto error0;
-error0:
 	xfs_perag_put(args.pag);
 	if (error)
 		trace_xfs_bmap_remap_alloc_error(ap->ip, error, _RET_IP_);

