Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3659729DFD
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 10:32:30 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C6C44AC004
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 08:32:26 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id ZyzoFDiWPewfCYo4 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Feb 2016 08:32:25 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs: handle AGs without reservation in
	xfs_refcountbt_free_reserve_pool
Date: Tue,  9 Feb 2016 17:32:19 +0100
Message-Id: <1455035539-24535-2-git-send-email-hch@lst.de>
In-Reply-To: <1455035539-24535-1-git-send-email-hch@lst.de>
References: <1455035539-24535-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

Without this xfstests starts crashing and burning in generic/003.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_refcount_btree.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 31e1b2d..f78041c 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -539,6 +539,10 @@ xfs_refcountbt_free_reserve_pool(
 	pool_len = 0;
 	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
 		pag = xfs_perag_get(mp, agno);
+		if (!pag->pagf_refcountbt_resv) {
+			xfs_perag_put(pag);
+			continue;
+		}
 		i = xfs_ag_resv_blocks(pag->pagf_refcountbt_resv);
 		if (pool_len < i)
 			pool_len = i;
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
