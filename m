Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:36776 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731088AbeGRQ3I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jul 2018 12:29:08 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6IFnQBx167409
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jul 2018 15:50:36 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2k9yjx28ss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jul 2018 15:50:36 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w6IFoZDa021686
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jul 2018 15:50:36 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w6IFoZQM031603
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jul 2018 15:50:35 GMT
Subject: [PATCH 1/8] xfs: check leaf attribute block freemap in verifier
From: "Darrick J. Wong" <djwong@maple.djwong.org>
Date: Wed, 18 Jul 2018 08:50:34 -0700
Message-ID: <153192903434.31685.282625226695514597.stgit@magnolia>
In-Reply-To: <153192902811.31685.11590100183112248407.stgit@magnolia>
References: <153192902811.31685.11590100183112248407.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Check the leaf attribute freemap when we we're verifying the block.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 76e90046731c..b3c19339e1b5 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -244,6 +244,8 @@ xfs_attr3_leaf_verify(
 	struct xfs_attr_leafblock	*leaf = bp->b_addr;
 	struct xfs_perag		*pag = bp->b_pag;
 	struct xfs_attr_leaf_entry	*entries;
+	uint16_t			end;
+	int				i;
 
 	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr, leaf);
 
@@ -289,6 +291,22 @@ xfs_attr3_leaf_verify(
 	/* XXX: need to range check rest of attr header values */
 	/* XXX: hash order check? */
 
+	for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; i++) {
+		if (ichdr.freemap[i].base > mp->m_attr_geo->blksize)
+			return __this_address;
+		if (ichdr.freemap[i].base & 0x3)
+			return __this_address;
+		if (ichdr.freemap[i].size > mp->m_attr_geo->blksize)
+			return __this_address;
+		if (ichdr.freemap[i].size & 0x3)
+			return __this_address;
+		end = ichdr.freemap[i].base + ichdr.freemap[i].size;
+		if (end < ichdr.freemap[i].base)
+			return __this_address;
+		if (end > mp->m_attr_geo->blksize)
+			return __this_address;
+	}
+
 	return NULL;
 }
 

