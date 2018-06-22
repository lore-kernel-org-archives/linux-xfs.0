Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:43938 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750759AbeFVGVK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Jun 2018 02:21:10 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5M6JDPq056209
        for <linux-xfs@vger.kernel.org>; Fri, 22 Jun 2018 06:21:09 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2jrp8hrmdc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 22 Jun 2018 06:21:09 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w5M6L9Qk013391
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 22 Jun 2018 06:21:09 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w5M6L8bP023672
        for <linux-xfs@vger.kernel.org>; Fri, 22 Jun 2018 06:21:08 GMT
Date: Thu, 21 Jun 2018 23:21:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 9/8] xfs: check leaf attribute block freemap in verifier
Message-ID: <20180622062103.GM4838@magnolia>
References: <152960586416.26246.8634761888260524091.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152960586416.26246.8634761888260524091.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Check the leaf attribute freemap when we we're verifying the block.
Found via generic/070.

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
 
