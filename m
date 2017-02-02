Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55462 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752121AbdBBPy6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Feb 2017 10:54:58 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8149780F94
        for <linux-xfs@vger.kernel.org>; Thu,  2 Feb 2017 15:54:58 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id v12FsvYT030136
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
        for <linux-xfs@vger.kernel.org>; Thu, 2 Feb 2017 10:54:58 -0500
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_metadump: ignore attr leaf with 0 entries
Message-ID: <7481b076-dbc6-ddaa-4e3f-9a1bc2b94e26@redhat.com>
Date: Thu, 2 Feb 2017 09:54:56 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Another in the ongoing saga of attribute leaves with zero
entries; in this case, if we try to metadump an inode with
a zero-entries attribute leaf, the zeroing code will go off
the rails and segfault at:

                memset(&entries[nentries], 0,
                       first_name - (char *)&entries[nentries]);

because first_name is null, and we try to memset a large
(negative) number.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/db/metadump.c b/db/metadump.c
index 38519f1..66952f6 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1654,7 +1654,8 @@ process_attr_block(
 	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &hdr, leaf);
 
 	nentries = hdr.count;
-	if (nentries * sizeof(xfs_attr_leaf_entry_t) +
+	if (nentries == 0 ||
+	    nentries * sizeof(xfs_attr_leaf_entry_t) +
 			xfs_attr3_leaf_hdr_size(leaf) >
 				XFS_ATTR3_RMT_BUF_SPACE(mp, bs)) {
 		if (show_warnings)

